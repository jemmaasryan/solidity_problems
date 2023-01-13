//SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;
/** @title Adds and removes shareholders*/
contract Problem5 {
    address public owner;
    /** Mapping to connect shareholder to its percent.*/
    mapping(address => uint8) public shareholder;
    /** An array of all shareholders. */
    address[] public allShareholders;
    /* A variable to count total shares of all shareholders. */
    uint8 totalShares;

    constructor() {
        owner = payable(msg.sender);
    }
    /** Modifier that gives access to owner.
    */
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not allowed.");
        _;
    }
    /** @dev Adds a shareholder.
      * @param _shareholder The address of a shareholder to be added.
      * @param _percentage The percent of that address.
      */
    function addShareholder(address _shareholder, uint8 _percentage) external onlyOwner {
        require(shareholder[_shareholder] == 0, "Already in system.");
        require(_percentage > 0 && _percentage <= 100, "");
        totalShares += _percentage;
        shareholder[_shareholder] = _percentage;
        allShareholders.push(_shareholder);
    }
    /** @dev Removes a shareholder.
      * @param _shareholder The address of a shareholder to be removed.
      */
    function removeShareholder(address _shareholder) external onlyOwner {
        require(shareholder[_shareholder] > 0, "Address not found.");
        totalShares -= shareholder[_shareholder];
        delete shareholder[_shareholder];
        for(uint i; i < allShareholders.length; i++){
            if(allShareholders[i] == _shareholder){
                allShareholders[i] = allShareholders[allShareholders.length-1];
                allShareholders.pop;
            }
        }
    }
    /** @dev Distributes funds to all shareholders by their percent.
      */
    function shares() internal {
        for(uint256 i = 0; i < allShareholders.length; i++) {
            uint share = (address(this).balance * shareholder[allShareholders[i]]) / 100;
            payable(allShareholders[i]).transfer(share);
        }
    }
    receive() external payable {
        shares();
    }
}
