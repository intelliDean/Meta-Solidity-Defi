// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IDeFiScheme {
    function invest() external payable;
    function withdraw(uint256 amount) external;
    function getInterest(address user) external view returns (uint256);
}