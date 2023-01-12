//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;
/*Ստեղծել կոնտրակտ, որը constructor-ի միջոցով կարժեքավորի address տիպի
  owner փոփոխականը հետագայում onlyOwner modifier-ը օգտագործելու համար։ 
  Owner-ը որևիցե ֆունկցիայի միջոցով հնարավորություն պիտի ունենա ավելացնել բաժնետերերի
  այսինքն՝ address և percentage յուրաքանչյուրի համար (ավելացնել նաև բաժնետեր 
  հեռացնելու հնարավորությունը)։ Contract-ը հնարավորություն պիտի ունենա իր մեջ 
  գումար պահելու (receive) և ամեն անգամ երբ որոշակի գումար կփոխանցվի contract-ի 
  հասցեին, contract-ը կուղարկի այն բաժնետերերին իրենց տոկոսներին համապատասխան։  
*/
contract Problem5 {
    address public owner;
   
    struct Shareholder {
        address personAddress;
        uint percentage;
    }
    
    mapping(address => uint) public shareholder;
    mapping(address => Shareholder) public system;
    Shareholder[] public all;
    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not allowed.");
        _;
    }

    function addShareholder(address _shareholder, uint _percentage) external onlyOwner {
        system[msg.sender].personAddress = _shareholder;
        system[msg.sender].percentage = _percentage;
        shareholder[_shareholder] = _percentage;
        all.push(Shareholder(_shareholder, _percentage));
    }

    function removeShareholder(address _shareholder) external onlyOwner {
        delete system[msg.sender].personAddress;
        system[msg.sender].percentage = 0;
    }

    receive() external payable {
        
    }
}
