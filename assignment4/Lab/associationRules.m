% Course: Information Systems
% Association Rule Analysis with Apriori
% Author: Dr. George Azzopardi
% Date: December 2019

% input parameters: minsup = minimum support, minconf = minimum confidence
function [rules, tridx, trlbl] = associationRules(minsup,minconf)
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
        % generate all subsets of the current item
        currItem = freqitemsList(i,:);
        sizeCurrItem = size(currItem);
        subsets = {};
        for j = sizeCurrItem(2) - 1:-1:1
            sb = nchoosek(currItem, j);
            for k = 1:size(sb,1)
                subsets = vertcat(subsets, sb(k,:));
            end
        end
        % for every element on the subsets calculate sub -> (currItem - sub)
        for j = 1:size(subsets, 1)
            antecedent = subsets{j};
            % calculate the set difference
            consequent = setdiff(currItem, antecedent);
            % calculate min_confidence
            supI = support{size(currItem, 2)}(i);
            tmpTbl = ismember(frequentItems{1,size(antecedent,2)}, antecedent, 'rows');
            suppRowIdx = find(tmpTbl == 1);
            supS = support{1, size(antecedent,2)}(suppRowIdx);
            currMinConf = supI / supS;
            % append to the rules array
            if currMinConf > minconf
                rules{rulesCount, 1} = antecedent;
                rules{rulesCount, 2} = consequent;
                rules{rulesCount, 3} = currMinConf;
                rulesCount = rulesCount + 1;
            end
        end
    end
end

% sort in terms of confidence
rules = sortrows(rules, [3], 'descend');
toc % timing end

end
