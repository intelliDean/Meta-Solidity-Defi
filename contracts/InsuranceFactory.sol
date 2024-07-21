// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./WalletInsurance.sol";
import "./CollateralProtectionLoan.sol";

contract InsuranceFactory {
    address public defiScheme;
    WalletInsurance[] walletInsurances;
    CollateralProtectionLoan[] collateralProtectionLoans;

    enum PolicyType {
        NULL,
        BRONZE,
        GOLD,
        PLATINUM
    }

    enum CollateralType {
        NULL,
        HALF,
        FULL
    }

    struct WalletPolicy {
        WalletInsurance.PolicyType policyType;
        uint256 policyAmount;
        uint256 policyReward;
    }

    struct CollateralPolicy {
        CollateralType collateralType;
        uint256 insurancePercentage;
    }

    mapping(uint256 => WalletPolicy) public walletPolicies;
    mapping(uint256 => CollateralPolicy) public collateralPolicies;
    mapping(address => WalletPolicy) userPolicy;
    mapping(address => address) public userInsurance;
    mapping(address => address) collateralOwner;

    event CollateralProtectionLoanCreate(address creator, address contractAddress);
    event WalletInsuranceCreated(address creator, address newWalletInsurance);

    constructor(address _defiScheme) {
        defiScheme = _defiScheme;

        createWalletPolicies();
        createCollateralPolicies();
    }

    function createWalletPolicies() private {
        walletPolicies[1] = WalletPolicy(
            WalletInsurance.PolicyType.BRONZE,
            2000,
            2500
        );
        walletPolicies[2] = WalletPolicy(
            WalletInsurance.PolicyType.GOLD,
            5000,
            7500
        );
        walletPolicies[3] = WalletPolicy(
            WalletInsurance.PolicyType.PLATINUM,
            10000,
            15000
        );
    }

    function createCollateralPolicies() private {
        collateralPolicies[1] = CollateralPolicy(CollateralType.HALF, 50);
        collateralPolicies[2] = CollateralPolicy(CollateralType.FULL, 100);
    }

    //===================================================================

    function createWalletInsurance(
        WalletInsurance.PolicyType _policyType,
        uint256 _policyAmount
    ) external {
        WalletPolicy memory _walletPolicy = walletPolicies[
                            uint256(_policyType)
            ];

        require(
            _walletPolicy.policyAmount == _policyAmount,
            "incorrect insurance fee"
        );

        WalletInsurance walletInsurance = new WalletInsurance(
            defiScheme,
            _policyType,
            _policyAmount
        );
        walletInsurances.push(walletInsurance);

        userPolicy[msg.sender] = _walletPolicy;
        address newWalletInsurance = address(walletInsurance);
        userInsurance[msg.sender] = newWalletInsurance;

        emit WalletInsuranceCreated(msg.sender, newWalletInsurance);
    }

    function payWalletInsurance(uint256 _amount) external {
        WalletInsurance _walletInsurance = getInsuranceContract(msg.sender);

        _walletInsurance.payInsurance(_amount);
    }

    function claimInsurancePart(uint256 _amount) external {
        WalletInsurance _walletInsurance = getInsuranceContract(msg.sender);
        _walletInsurance.withdrawPart(_amount);
    }

    function claimAllInsurance() external {
        WalletInsurance _walletInsurance = getInsuranceContract(msg.sender);
        _walletInsurance.claimInsurance();
    }

    function getInsuranceBalance() external view returns (uint256) {
        WalletInsurance _walletInsurance = getInsuranceContract(msg.sender);
        return _walletInsurance.getBalance();
    }

//=================================================================================

    function createCollateralProtectionLoan() external {
        CollateralProtectionLoan _collateralProtectionLoan = new CollateralProtectionLoan();
        collateralProtectionLoans.push(_collateralProtectionLoan);
        collateralOwner[msg.sender] = address(_collateralProtectionLoan);

        emit CollateralProtectionLoanCreate(msg.sender, address(_collateralProtectionLoan));
    }

    function initiateLoan(
        uint256 _index,
        uint256 _loanAmount,
        uint256 _collateralAmount,
        uint256 _insuranceType
    ) external {
        CollateralProtectionLoan _collateralProtectionLoan = collateralProtectionLoans[
                    _index
            ];
        _collateralProtectionLoan.initiateLoan(
            _loanAmount,
            _collateralAmount,
            collateralPolicies[_insuranceType].insurancePercentage
        );
    }

    function checkCollateralValue(uint256 _index)
    external
    returns (uint256){
        CollateralProtectionLoan _collateralProtectionLoan = collateralProtectionLoans[
                    _index
            ];
        return _collateralProtectionLoan.checkCollateralValue();
    }

    function isLoanRepaid(uint256 _index) external view returns(bool){
        CollateralProtectionLoan _collateralProtectionLoan = collateralProtectionLoans[
                    _index
            ];
        return _collateralProtectionLoan.isLoanRepaid();
    }

    function getInsuranceContract(address _user)
    private
    view
    returns (WalletInsurance)
    {
        return WalletInsurance(userInsurance[_user]);
    }
}