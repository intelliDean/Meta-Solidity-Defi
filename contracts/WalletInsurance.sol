// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IDeFiScheme.sol";

contract WalletInsurance  {


    IDeFiScheme public defiScheme;

    address public insured;
    PolicyType policyType;
    uint256 policyAmount;
    uint256 investment;
    uint256 balance;

    enum PolicyType {
        NULL,
        BRONZE,
        GOLD,
        PLATINUM
    }

    event InsurancePaid(address indexed insured, uint256 amount);
    event WithdrawPart(address indexed  insured, uint256 amountWithdrawn);
    event WithdrawAll(address indexed  insured, uint256 allInvestments);

    constructor(address _defiScheme, PolicyType _policyType, uint256 _policyAmount) {
        insured = tx.origin;
        policyType = _policyType;
        policyAmount = _policyAmount;
        defiScheme = IDeFiScheme(_defiScheme);
    }

    function payInsurance(uint256 _amount) external {
        require(tx.origin == insured, "You are not insured");
        require(_amount == policyAmount, "incorrect fee chosen insurance type");
        policyAmount += _amount;

        // Invest the insurance fee in the DeFi scheme
        defiScheme.invest(_amount);

        emit InsurancePaid(msg.sender, _amount);
    }

    function withdrawPart(uint256 _withdrawalAmount) external {
        require(tx.origin == insured, "You are not insured");
        uint256 _withdrawal = defiScheme.withdrawPart(_withdrawalAmount);
        balance += _withdrawal;

        emit WithdrawPart(tx.origin, _withdrawal);
    }

    function claimInsurance() external {
        require(tx.origin == insured, "You are not insured");

        uint256 _withdrawal = defiScheme.withdrawAll();
        balance += _withdrawal;

        emit WithdrawAll(insured, _withdrawal);
    }

    function getBalance() external view returns(uint256) {
        return balance;
    }
}