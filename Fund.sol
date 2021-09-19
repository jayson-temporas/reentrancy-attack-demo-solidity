// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Fund {
    mapping(address => uint) public balances;
    
    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }
    
    function withdraw() external {
        (bool success, ) = address(msg.sender).call{value: balances[msg.sender]}("");
        if (success) {
            balances[msg.sender] = 0;
        }
    }
    
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}