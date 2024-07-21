// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DeFiScheme {

    mapping(address => uint256) public balances;
    mapping(address => uint256) public interestEarned;

    event Invested(address indexed user, uint256 amount, uint256 interest);
    event WithdrawPart(address indexed user, uint256 amount);
    event WithdrawAll(address user, uint256 allInvestment);

    function invest(uint256 _amount) external {
        require(_amount > 0, "Cannot invest 0 token");
        require(tx.origin != address(0), "Unauthorized!");

        //10% of the invested amount = interest earned
        uint256 interest = (_amount * 10) / 100;
        interestEarned[tx.origin] += interest;

        balances[tx.origin] += (_amount + interest); //added the interest with invested amount

        emit Invested(tx.origin, _amount, interest);
    }

    function withdrawPart(uint256 amount) external returns (uint256) {

        require(balances[tx.origin] >= amount, "Insufficient balance");
        balances[tx.origin] -= amount;

        emit WithdrawPart(tx.origin, amount);

        return amount;
    }

    function withdrawAll() external returns(uint256) {

        uint256 interest = interestEarned[tx.origin];
        uint256 balance = balances[tx.origin];
        require(interest > 0, "No interest earned");

        interestEarned[tx.origin] = 0;
        balances[tx.origin] = 0;

        uint256 allInvestment = balance;

        emit WithdrawAll(tx.origin, allInvestment);

        return allInvestment;
    }

}