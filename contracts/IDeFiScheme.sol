// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IDeFiScheme {

    function withdrawPart(uint256 amount) external returns (uint256);

    function invest(uint256 _amount) external ;

    function getInterest(address user) external view returns (uint256);

    function balanceOf(address user) external view returns (uint256);

    function withdrawAll() external returns(uint256);
}