//SPDX-License-Identifier: MIT
pragma solidity 0.8.15;
/** Ստեղծել contract ընտրություններ կազմակերպելու համար։
Այն հասցեները, որոնք կցանկանան հանդիսանալ թեկնածու պետք է ուղարկեն x գումար 
կոնտրակտի հասցեին։ Նույն հասցեից կարելի է ընտրել միայն մեկ անգամ։
Ընտրություններից հետո կոնտրակտում հավաքված գումարը ուղարկել թեկնածուներին 
ըստ իրենց հավաքած ձայների տոկոսային հարաբերակցության։ Ընտրությունները պետք է 
սկսվեն կոնտրակտը deploy անելուց հետո և ավարտվեն մինիմումը 8 ժամ հետո։ 
Գումարը ըստ տոկոսների ուղարկելու համար օգտագործել Shareholders կոնտրակտը։
*/
import "./Problem5.sol";

interface Shareholder {
    function addShareholder(address _shareholder, uint8 _percentage) external;
}

contract Problem9 {
    address public owner;
    uint256 totalVotes;
    uint256 end = block.timestamp + 60; /*28800;*/
    mapping(address => uint) public candidatesVoteCount;
    mapping(address => bool) public voted;
    address[] public allCandidates;
    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not allowed.");
        _;
    }
    modifier endTime() {
        require(block.timestamp < end, "Can't vote. The election is over.");
        _;
    }
    function becomeCandidate(address _candidate) public payable endTime {
        require(candidatesVoteCount[_candidate] == 0, "You are already a candidate.");
        require(msg.value >= 1 ether, "Not enough money");
        candidatesVoteCount[_candidate];
        allCandidates.push(_candidate);
    }
    function vote(address _candidate) public endTime {
        require(!voted[msg.sender],"You are not allowed to vote more than once.");
        candidatesVoteCount[_candidate]++;
        totalVotes++;
    }
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
