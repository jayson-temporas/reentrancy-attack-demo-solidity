## Reentrancy Attack in Solidity

Simple demo to show reentrancy vulnerability on a Solidity Smart Contract.

Attacker will be able to drain the funds of a vulnerable contract (Fund.sol) by triggering multiple withdraws on the attacker(Attacker.sol) fallback function.

On Fund.sol, the method withdraw is vulnerable because if the msg.sender is a malacious smart contract, it can call the withdraw function multiple times using its fallback function before it hits the balances\[msg.sender\] = 0 line.

```
function withdraw() external {
    (bool success, ) = address(msg.sender).call{value: balances[msg.sender]}("");
    if (success) {
        balances[msg.sender] = 0;
    }
}
```

To solve this, you can use Checks-effects-interactions pattern.

We can rewrite that function into

```
function withdraw() external {
    uint256 myBalance = balances[msg.sender];
    balances[msg.sender] = 0;
    (bool success, ) = address(msg.sender).call{value: myBalance}("");
    require(success, "Fail to withdraw fund");
}
```

Even if the malicious contract call this function multiple times,
it will not have an effect because his balance is already zero.

You can also use a state variable as Guard tho it consumes more gas

```
...
bool locked = false;
...
function withdraw() external {
    require(!locked, "Reentrant call detected!");
    locked = true;
    (bool success, ) = address(msg.sender).call{value: balances[msg.sender]}("");
    if (success) {
        balances[msg.sender] = 0;
    }
    locked = false;
}

```

It's still better to use the Checks-effects-interactions pattern.

Read how hackers stole $50 Million worth of ETHs by exploiting reentrancy vulnerabilities on the [DAO project](https://ogucluturk.medium.com/the-dao-hack-explained-unfortunate-take-off-of-smart-contracts-2bd8c8db3562). 