// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IDeFiScheme.sol";

contract CollateralProtectionInsurance is Ownable {
    address public insured;
    uint256 public policyType;
    uint256 public premium;
    uint256 public coveragePercent;
    uint256 public premiumPaid;
    uint256 public interestEarned;
    IDeFiScheme public defiScheme;

    struct Policy {
        uint256 premium;
        uint256 coveragePercent;
    }

    mapping(uint256 => Policy) public policies;

    event PremiumPaid(address indexed insured, uint256 amount);
    event ClaimPaid(address indexed insured, uint256 amount);
    event InterestWithdrawn(address indexed insured, uint256 amount);
    event InvestedInDeFi(address indexed insured, uint256 amount);

    constructor(address _insured, uint256 _policyType, address _defiScheme) Ownable(msg.sender) {
        insured = _insured;
        policyType = _policyType;
        defiScheme = IDeFiScheme(_defiScheme);

        // Define policies
        policies[1] = Policy(1 ether, 50);  // Policy type 1
        policies[2] = Policy(2 ether, 75);  // Policy type 2

        // Set the selected policy
        premium = policies[policyType].premium;
        coveragePercent = policies[policyType].coveragePercent;
    }

    function payPremium() external payable {
        require(msg.sender == insured, "Only the insured can pay the premium");
        require(msg.value == premium, "Incorrect premium amount");
        premiumPaid += msg.value;

        // Invest the premium in the DeFi scheme
        defiScheme.invest{value: msg.value}();

        emit PremiumPaid(msg.sender, msg.value);
        emit InvestedInDeFi(msg.sender, msg.value);
    }

    function claimInsurance(uint256 loanAmount) external {
        require(msg.sender == insured, "Only the insured can claim the insurance");
        require(premiumPaid >= premium, "Premium not fully paid");

        uint256 coverageAmount = (loanAmount * coveragePercent) / 100;
        
        // Withdraw investment from DeFi scheme before paying out the claim
        defiScheme.withdraw(coverageAmount);

        payable(insured).transfer(coverageAmount);

        emit ClaimPaid(insured, coverageAmount);
    }

    function withdrawInterest() external {
        require(msg.sender == insured, "Only the insured can withdraw interest");
        uint256 interest = defiScheme.getInterest(insured);
        require(interest > 0, "No interest earned");

        defiScheme.withdraw(interest);
        payable(insured).transfer(interest);

        emit InterestWithdrawn(insured, interest);
    }

    receive() external payable {}
}