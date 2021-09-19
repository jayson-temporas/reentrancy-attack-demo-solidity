// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract FundFixed1 {
    mapping(address => uint) public balances;
    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }
    
    function withdraw() external {
         uint256 myBalance = balances[msg.sender];
         balances[msg.sender] = 0;
         (bool success, ) = address(msg.sender).call{value: myBalance}("");
         require(success, "Fail to withdraw fund");
    }
    
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

contract FundFixed2 {
    mapping(address => uint) public balances;
    bool locked = false;
    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }
    
    function withdraw() external {
       require(!locked, "Reentrant call detected!");
       locked = true;
        (bool success, ) = address(msg.sender).call{value: balances[msg.sender]}("");
        if (success) {
            balances[msg.sender] = 0;
        }
        locked = false;
    }
    
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}