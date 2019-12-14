% Course: Information Systems
% Association Rule Analysis with Apriori
% Author: Dr. George Azzopardi
% Date: December 2019

% input parameters: minsup = minimum support, minconf = minimum confidence
function  [rules, tridx, trlbl] = associationRulesAnti(minsup,minconf)
shoppingList = readDataFile;

ntrans = size(shoppingList,1);
items = unique([shoppingList{:}]);
nitems = numel(items);

[tridx,trlbl] = grp2idx(items);

% Create the binary matrix
dataset = zeros(ntrans,nitems);
for i = 1:ntrans
   dataset(i,tridx(ismember(items,shoppingList{i}))) = 1;
end

% Generate frequent items of length 1
support{1} = sum(dataset)/ntrans;
f = find(support{1} >= minsup);
frequentItems{1} = tridx(f);
support{1} = support{1}(f);

% Generate frequent item sets
k = 1;
while k < nitems && size(frequentItems{k},1) > 1
    % Generate length (k+1) candidate itemsets from length k frequent itemsets
    frequentItems{k+1} = [];
    support{k+1} = [];
    
    % Consider joining possible pairs of item sets
    for i = 1:size(frequentItems{k},1)-1
        for j = i+1:size(frequentItems{k},1)
            if k == 1 || isequal(frequentItems{k}(i,1:end-1),frequentItems{k}(j,1:end-1))
                candidateFrequentItem = union(frequentItems{k}(i,:),frequentItems{k}(j,:));  
                if all(ismember(nchoosek(candidateFrequentItem,k),frequentItems{k},'rows'))                
                    sup = sum(all(dataset(:,candidateFrequentItem),2))/ntrans;                    
                    if sup >= minsup
                        frequentItems{k+1}(end+1,:) = candidateFrequentItem;
                        support{k+1}(end+1) = sup;
                    end
                end
            else
                break;
            end            
        end
    end         
    k = k + 1;
end

% Generate association rules. To be implemented by students
tic % timing start
rules = {};
rulesCount = 1;

% Get the frequent items list
[w, freqCount] = size(frequentItems);

for l = 1:freqCount - 1 
    freqitemsList = frequentItems{1, freqCount - l};
    [itemsCount, nmbColumns] = size(freqitemsList);
    
    % loop over all the frequent items list
    for i = 1:itemsCount
        % get the current item
        currItem = freqitemsList(i,:);
        % the support of I just needs to be calculated once per itemset
        supI = support{size(currItem, 2)}(i);
        
        % the items that will determine which subsets are to be removed 
        % because of antimonotonicity
        removeFromCombs = {}; 
        pruneLattice = false;
        % loop for every possible comb on the itemset
        for depth = 1:size(currItem,2) - 1
            % get the possible item consequents of the rule
            H = nchoosek(currItem, depth);
            
            % Anti-monotone property
            % create the valid subsets from the matrix off all subsets of
            % the current lattice level
            validSbs = []; 
            if pruneLattice == false
                for row = 1:size(removeFromCombs,1)
                    % get the non valid subset from past levels of the lattice
                    currRow = removeFromCombs{row,1};
                    % will be used for the subset computation for varying row
                    % sizes
                    removeSize = removeFromCombs{row,2};
                    % check if the element to remove is present 
                    member = ismember(H,currRow);
                    % calculate the sum of element coincidences
                    memberSum = sum(member,2);
                    % if the sum per row >= to the size of the element to 
                    % remove then that element is a subset so it needs to be 
                    % removed from H, this way we get the valid indexes
                    memberIdxs = find(memberSum < removeSize); 
                    % intersect the valid indexes for all elemenents to remove
                    % form the combinations.
                    if size(validSbs,1) == 0 && row == 1
                        validSbs = [validSbs, memberIdxs];
                    else
                        validSbs = intersect(validSbs, memberIdxs);
                        % check if the intersection is void so we can break the
                        % loop
                        if size(validSbs,1) == 0
                            % set the prune to true so that we dont
                            % continue checking for valid subsets further
                            % down the lattice
                            pruneLattice = true;
                            break
                        end
                    end
                end
            end
            
            % only do if there is something to remove
            if size(removeFromCombs,2) > 0
                H = H(validSbs,:); % get all the valid subsets
            end
            
            % loop for every element on the cand (valid) consequent set
            for j = 1:size(H,1)
                % consequent + antecedent computation
                consequent = H(j,:);
                antecedent = setdiff(currItem, consequent);
                
                % confidence calculation
                %supI = support{size(currItem, 2)}(i);
                tmpTbl = ismember(frequentItems{1,size(antecedent,2)}, antecedent, 'rows');
                suppRowIdx = find(tmpTbl == 1);
                supS = support{1, size(antecedent,2)}(suppRowIdx);
                
                conf = supI / supS; % confidence computation
                if conf > minconf
                    % add to the rule array
                    rules{rulesCount, 1} = antecedent;
                    rules{rulesCount, 2} = consequent;
                    rules{rulesCount, 3} = conf;
                    rulesCount = rulesCount + 1;
                else
                    % to remove all subs generated by this consequent
                    if size(removeFromCombs,1) == 0
                        % subset to remove from the combs
                        removeFromCombs{1,1} = consequent;
                        % size of the sbs to remove
                        removeFromCombs{1,2} = size(consequent,2);
                    else
                        % add the item to the remove array so we do not
                        % calculate its confidence on the dependant nodes
                        % of the lattice on further levels.
                        removeFromCombs{end+1, 1} = consequent;
                        removeFromCombs{end,2} = size(consequent,2);
                    end
                end
            end
        end
    end
end

toc % timing end
% sort in terms of confidence
rules = sortrows(rules, [3], 'descend');

end
