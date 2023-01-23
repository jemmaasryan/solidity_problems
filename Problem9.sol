//SPDX-License-Identifier: MIT
pragma solidity 0.8.15;
/** @title Shareholder interface to use the methods from Shareholder contract in Problem5. */
interface Shareholder {
    function addShareholder(address _shareholder, uint8 _percentage) external;
}
/** @title Contract to held elections.*/
contract Problem9 {
    address public owner;
    uint256 totalVotes;
    uint256 end = block.timestamp + 28800;
    /** A mapping to connect candidate's address to their vote count.*/
    mapping(address => uint) public candidatesVoteCount;
    /** A mapping to connect voter's address to boolean value, 
     * to check if the address voted already or not.*/
    mapping(address => bool) public voted;
    /** An array of all candidates addresses.*/
    address[] public allCandidates;
    /** A constructor to set the message sender to be the owner of the contract.
    */
    constructor() {
        owner = msg.sender;
    }
    /** A modifier to allow only owner to take action.
    */
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not allowed.");
        _;
    }
    /** A modifier to allow voters to vote untill the end time(8 hours).
    */
    modifier endTime() {
        require(block.timestamp < end, "Can't vote. The election is over.");
        _;
    }
    /** @dev A payable function that adds candidates, requires to become 
      *       candidate only once and to pay right amount of ether to be accepted.
      * @param _candidate The address of a candidate that wants to be added.
      */
    function becomeCandidate(address _candidate) public payable endTime {
        require(candidatesVoteCount[_candidate] == 0, "You are already a candidate.");
        require(msg.value >= 1 ether, "Not enough money");
        candidatesVoteCount[_candidate];
        allCandidates.push(_candidate);
    }
    /** @dev Allows users to vote, requires them to vote only once, and increments 
      *      the vote count of the candidate. Also increments. the total number of votes.
      * @param _candidate The address of a candidate who is voting.
      */
    function vote(address _candidate) public endTime {
        require(!voted[msg.sender],"You are not allowed to vote more than once.");
        candidatesVoteCount[_candidate]++;
        totalVotes++;
    }
    /** @dev Only owner can end the elections by sending contract's money(ether)
      *      to the Shareholder contract, which then will share it with candidates 
      *      based on their vote counts. A payable function to be able to send the contract's balance.
      * @param _to Shareholder contract's address to send money.
      */
    function endVoting(address payable _to) public payable onlyOwner {
        require(block.timestamp > end, "The election is not over yet.");
        uint8 eachCandidate;
        for(uint256 i = 0; i < allCandidates.length; i++) {
            eachCandidate += uint8((candidatesVoteCount[allCandidates[i]] * 100) / totalVotes);
            Shareholder(allCandidates[i]).addShareholder(allCandidates[i], eachCandidate);
        }
        _to.transfer(msg.value);
    }
}
