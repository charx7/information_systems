pragma solidity ^0.5.12;
contract MyContract {
    uint256 public proposalCount; // counter that will increment everytime the director sets a new proposal(question)
    mapping(uint => Proposal) public proposals; // use a mapping to keep track of the proposals
    // an array of proposals
    //Proposal[] public proposals;

    address owner; // keep track of the owner

    // constructor that sets the owner as the person that deployed the contract
    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner); // compare the caller of the func to the person that deployed the contract
        _;
    }

    struct Proposal {
        uint _id; // id of the Proposal
        string _question; // contents of the question
    }

    // Function that sets a proposal can only be run by the director*
    function addProposal(string memory _question) public onlyOwner {
        incrementCount(); // call to the internal incrementCount function
        proposals[proposalCount] = Proposal(proposalCount, _question); // add a proposal to the mapping

        // add a proposal to the array using the Proposal struct
        //proposals.push(Proposal(_question));
    }

    // internal function
    function incrementCount() internal {
        // add one to the proposal mapping
        proposalCount += 1;
    }
}
