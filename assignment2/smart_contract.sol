pragma solidity ^0.5.12;
contract MyContract {
    uint256 public proposalCount; // counter that will increment everytime the director sets a new proposal(question)
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
        uint vote;   // index of the voted proposal
        bool canVote; // if true they can vote
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
        if (proposalCount > 0){
            require(proposals[proposalCount].closed, "Current Proposal is still being voted...");
            
        }
        incrementCount(); // call to the internal incrementCount function
        proposals[proposalCount] = Proposal(proposalCount, _question, false, 0, 0, false); // add a proposal to the mapping
    } 
    
    // voting count function based on the number of voters? and proposals
    function countVotes() public onlyOwner returns(uint)  {
        uint currCount;    
        currCount = proposals[proposalCount].voteCount;
        uint totalVoted = proposals[proposalCount].nmbrPplVoted;
        if ((currCount/totalVoted) > (totalVoted - currCount) / totalVoted) {
            proposals[proposalCount].passed = true; // the proposal passed
        }
        proposals[proposalCount].closed = true; // close the proposal
        return currCount;
    }
    
    // functions that will allow/deny a vote for a shareholder
    function allowVote(address shareholderAddress) public onlyOwner returns(bool success){
        shareholders[shareholderAddress].canVote = true;
        return true;
    }
    function denyVote(address shareholderAddress) public onlyOwner returns(bool success){
        shareholders[shareholderAddress].canVote = false;
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
        
        // if the sender has already voted then ignore
        require(!sender.voted, "Already voted.");
        
        // set voted for the sender to true
        sender.voted = true;
        sender.vote = proposal;
        
        // increment the voting counter for a proposal that was set to true
        if (_vote == true) {
            proposals[proposal].voteCount += 1; 
        }
        proposals[proposal].nmbrPplVoted += 1; // increment the total number of ppl that voted
    }
}