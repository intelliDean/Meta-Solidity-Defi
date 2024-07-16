// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./CryptoWalletInsurance.sol";
import "./CollateralProtectionInsurance.sol";

contract InsuranceFactory {
    address[] public cryptoWalletInsuranceContracts;
    address[] public collateralProtectionInsuranceContracts;
    address public defiScheme;

    constructor(address _defiScheme) {
        defiScheme = _defiScheme;
    }

    function createCryptoWalletInsurance(uint256 policyType) external {
        CryptoWalletInsurance newInsurance = new CryptoWalletInsurance(msg.sender, policyType, defiScheme);
        cryptoWalletInsuranceContracts.push(address(newInsurance));
    }

    function createCollateralProtectionInsurance(uint256 policyType) external {
        CollateralProtectionInsurance newInsurance = new CollateralProtectionInsurance(msg.sender, policyType, defiScheme);
        collateralProtectionInsuranceContracts.push(address(newInsurance));
    }

    function getCryptoWalletInsuranceContracts() external view returns (address[] memory) {
        return cryptoWalletInsuranceContracts;
    }

    function getCollateralProtectionInsuranceContracts() external view returns (address[] memory) {
        return collateralProtectionInsuranceContracts;
    }
}