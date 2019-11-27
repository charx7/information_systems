pragma solidity ^0.5.12;
contract MyContract {
    uint256 public proposalCount; // counter that will increment everytime the director sets a new proposal(question)
    address[] public shareholdersAddresses ; // array with all the sharesholders addresses
    mapping(uint => Proposal) proposals; // use a mapping to keep track of the proposals
    mapping(address => Shareholder) public shareholders; // state variable that stores a `Shareholder` struct for each possible address.
    address owner; // keep track of the owner
    
    // constructor that sets the owner as the person that deployed the contract
    constructor() public {
        owner = msg.sender;
    }
    
    // modifier function that will only allow execution of funcs if the sender is marked as the owner
    modifier onlyOwner() {
        require(msg.sender == owner); // compare the caller of the func to the person that deployed the contract
        _;
    }
    
    // voter representation    
    struct Shareholder {
        bool voted;  // if true, that person already voted
        bool canVote; // if true they can vote
        uint[] votedArray; // the array of the voted proposals
        bool exists; // if the element exists
        bool canView; // if the person can view approved proposals
    }
    
    // proposal representation
    struct Proposal {
        uint _id; // id of the Proposal
        string _question; // contents of the question
        bool closed;
        uint voteCount; // accumulated votes of the proposal
        uint nmbrPplVoted; // number of ppl who voted
        bool passed; // will be true if the proposal is voted by the majority
    }
    
    // internal function
    function incrementCount() internal {
        // add one to the proposal mapping
        proposalCount += 1;
    }
    
    // Director functions -------------------------------------------------
    // Function that sets a proposal can only be run by the director*
    function addProposal(string memory _question) public onlyOwner {
        // check only if there is at least one added proposal
        
        // this will only allow for 1 proposal vote at a time
        //if (proposalCount > 0){
        //     require(proposals[proposalCount].closed, "Current Proposal is still being voted...");
            
        // }
        incrementCount(); // call to the internal incrementCount function
        proposals[proposalCount] = Proposal(proposalCount, _question, false, 0, 0, false); // add a proposal to the mapping
    } 
    
    // voting count function based on the number of voters? and proposals
    function countVotes(uint proposal) public onlyOwner returns(uint)  {
        uint currCount;    
        currCount = proposals[proposal].voteCount;
        uint totalVoted = proposals[proposal].nmbrPplVoted;
        if ((currCount/totalVoted) > (totalVoted - currCount) / totalVoted) {
            proposals[proposal].passed = true; // the proposal passed
        }
        proposals[proposal].closed = true; // close the proposal
        return currCount;
    }
    
    // functions that will allow/deny a vote for a shareholder
    function allowVote(address shareholderAddress) public onlyOwner returns(bool success){
        // increment the shareholders count if the shareholder didnt already exist on the mapping
        if(shareholders[shareholderAddress].exists == false){
            shareholdersAddresses.push(shareholderAddress);
            shareholders[shareholderAddress].canVote = true;
            // mark the shareholder as counted
            shareholders[shareholderAddress].exists = true;
        } else {
            // if they already exist just allow for vote
            shareholders[shareholderAddress].canVote = true;
        }
        
        return true;
    }
    
    function denyVote(address shareholderAddress) public onlyOwner returns(bool success){
        shareholders[shareholderAddress].canVote = false;
        return true;
    }
    
    // functions that will allow/deny visibility of the approved proposals
    function allowVisibility(address shareholderAddress) public onlyOwner returns(bool success){
        shareholders[shareholderAddress].canView = true;
        return true;
    }
    
    function denyVisibility(address shareholderAddress) public onlyOwner returns(bool success){
        shareholders[shareholderAddress].canView = false;
        return true;
    }
    
    // Shareholder functions ---------------------------
    // voting function
    function vote(uint proposal, bool _vote) public {
        Shareholder storage sender = shareholders[msg.sender];
        
        // if the proposal is already closed its voting you cannot vote on it
        require(!proposals[proposal].closed, "The proposal is already closed.");
        
        // check if the sharesholder is allowed to vote
        require(sender.canVote, "You are not allowed to vote!");
        
        // if the sender has already voted then ignore OLD
        //require(!sender.voted, "Already voted.");
        
        // check if the vote is for a valid proposal
        require(proposal > 0 && proposal <= proposalCount, "There is not a proposal with that index.");
        
        // check if the sender has already voted for this proposal
        for(uint i=0; i<sender.votedArray.length; i ++) {
            require(sender.votedArray[i] != proposal, "You already voted for this proposal.");
        }
        
        // set voted for the sender of the current proposal
        sender.votedArray.push(proposal);
        //sender.voted = true; old

        // increment the voting counter for a proposal that was set to true
        if (_vote == true) {
            proposals[proposal].voteCount += 1; 
        }
        proposals[proposal].nmbrPplVoted += 1; // increment the total number of ppl that voted
    }
}
