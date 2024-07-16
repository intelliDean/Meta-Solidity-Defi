// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DeFiScheme {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public interestEarned;

    event Invested(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event InterestPaid(address indexed user, uint256 amount);

    function invest() external payable {
        require(msg.value > 0, "Must send ETH to invest");
        balances[msg.sender] += msg.value;

        // Simulate interest earning: 10% of the invested amount for simplicity
        uint256 interest = (msg.value * 10) / 100;
        interestEarned[msg.sender] += interest;

        emit Invested(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);

        emit Withdrawn(msg.sender, amount);
    }

    function getInterest(address user) external view returns (uint256) {
        return interestEarned[user];
    }

    function withdrawInterest() external {
        uint256 interest = interestEarned[msg.sender];
        require(interest > 0, "No interest earned");
        interestEarned[msg.sender] = 0;
        payable(msg.sender).transfer(interest);

        emit InterestPaid(msg.sender, interest);
    }

    receive() external payable {}
}