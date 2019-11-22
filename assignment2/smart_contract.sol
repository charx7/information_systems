pragma solidity ^0.5.12;
contract MyContract {
    uint256 public proposalCount; // counter that will increment everytime the director sets a new proposal(question)
    mapping(uint => Proposal) public proposals; // use a mapping to keep track of the proposals
    // state variable that stores a `Shareholder` struct for each possible address.
    mapping(address => Shareholder) public shareholders;

    //Proposal[] public proposals; // an array of proposals 
    address owner; // keep track of the owner

    // constructor that sets the owner as the person that deployed the contract
    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner); // compare the caller of the func to the person that deployed the contract
        _;
    }

    // voter representation    
    struct Shareholder {
        bool voted;  // if true, that person already voted
        uint vote;   // index of the voted proposal
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

    // Function that sets a proposal can only be run by the director*
    function addProposal(string memory _question) public onlyOwner {
        // check only if there is at least one added proposal
        if (proposalCount > 0){
            require(proposals[proposalCount].closed, "Current Proposal is still being voted...");
        }
        incrementCount(); // call to the internal incrementCount function
        proposals[proposalCount] = Proposal(proposalCount, _question, false, 0, 0, false); // add a proposal to the mapping

        // add a proposal to the array using the Proposal struct
        //proposals.push(Proposal(_question));
    }
    
    // internal function
    function incrementCount() internal {
        // add one to the proposal mapping
        proposalCount += 1;
    }
    
    // voting function
    function vote(uint proposal, bool _vote) public {
        Shareholder storage sender = shareholders[msg.sender];
        
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
    
    // voting count function based on the number of voters? and proposals
    function countVotes() public onlyOwner returns(uint)  {
        uint currCount;    
        currCount = proposals[proposalCount].voteCount;
        uint totalVoted = proposals[proposalCount].nmbrPplVoted;
        if (currCount > totalVoted) {
            proposals[proposalCount].passed = true; // the proposal passed
        }
        proposals[proposalCount].closed = true; // close the proposal
        return currCount;
    }
}