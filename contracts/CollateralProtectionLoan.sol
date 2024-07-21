// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract CollateralProtectionLoan {
    address public owner;
    Loan[] public loanList;

    struct Loan {
        address borrower;
        uint256 loanAmount;
        uint256 collateralAmount;
        uint256 insurancePercentage; // e.g., 100 for full, 50 for half protection
        bool isRepaid;
    }

    mapping(address => Loan) public loans;

    event LoanInitiated(address indexed borrower, uint256 loanAmount, uint256 collateralAmount, uint256 insurancePercentage);
    event LoanRepaid(address indexed borrower, uint256 loanAmount);
    event CollateralLiquidated(address indexed borrower, uint256 insurancePaid);

    modifier onlyOwner() {
        require(tx.origin == owner, "Not owner");
        _;
    }

    constructor() {
        owner = tx.origin;
    }

    function initiateLoan(uint256 _loanAmount, uint256 _collateralAmount, uint256 _insurancePercentage) external  {
        require(loans[tx.origin].loanAmount == 0, "Existing loan found");
        require(_insurancePercentage <= 100, "Invalid insurance percentage");

        // Record the loan
        Loan storage _loan = loans[tx.origin];
        _loan.borrower = tx.origin;
        _loan.loanAmount = _loanAmount;
        _loan.collateralAmount = _collateralAmount;
        _loan.insurancePercentage = _insurancePercentage;

        loanList.push(_loan);

        emit LoanInitiated(tx.origin, _loanAmount, _collateralAmount, _insurancePercentage);
    }

    function checkCollateralValue() external onlyOwner returns (uint256){
        // Iterate over all loans and check collateral values
        uint256 insurancePayout = 0;
        for (uint i = 0; i < loanList.length; i++) {
            Loan storage loan = loanList[i];
            if (loan.loanAmount > 0 && !loan.isRepaid) {

                uint256 collateralValue = getCollateralValueFromOracle(loan.collateralAmount);
                uint256 threshold = (loan.collateralAmount * loan.insurancePercentage) / 100;

                if (collateralValue < threshold) {
                    insurancePayout = (loan.loanAmount * loan.insurancePercentage) / 100;
                    loan.isRepaid = true;
                    loans[loan.borrower].isRepaid = true;

                    // Pay insurance to lender
                    // payable(owner).transfer(insurancePayout);

                    emit CollateralLiquidated(loan.borrower, insurancePayout);
                    return insurancePayout;
                }
            }
        }
        return insurancePayout;
    }

    function isLoanRepaid() external view returns (bool) {
        return loans[tx.origin].isRepaid;
    }

    function getCollateralValueFromOracle(uint256 _collateralAmount) private pure returns (uint256) {
        return (_collateralAmount * 40) / 100;
    }
}
