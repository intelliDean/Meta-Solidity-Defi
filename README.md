
# WALLET INSURANCE & COLLATERAL PROTECTION CONTRACT

This Solidity contract is an insurance factory contract that implements wallet insurance contracts and collateral protection contracts. It also indirectly has an investment contract called the DefiScheme contract.

## Description
This smart contract is written in Solidity. The main contract is the factory contract, allowing users to create their own wallet insurance contract and pay for insurance. When a user pays for insurance, that money is invested into the defi scheme contract. Also, users can apply for loans with collateral. User can choose their collateral protection scheme, either by half (50%) or full (100%) when the collateral value drops.

## CryptoWalletInsurance Contract
- This contract helps owners of smart contract wallets stay protected from hackers. Users pay an insurance fee, which is invested in a DeFi scheme. They can later withdraw the interest they have earned from these investments. In case of an insured event, users can claim their coverage amount.

## CollateralProtectionInsurance Contract
- This contract provides collateral protection for crypto-backed loans. Based on the chosen insurance policy, users can get back a percentage of their loan amount if the collateral value drops. Users pay a premium, which is also invested in a DeFi scheme, and they can withdraw their interest earned.

## DeFi Scheme
- A mock DeFi scheme is implemented to simulate the investment and interest-earning process. User's insurance is invested in this scheme, generating interest over time.

## CONTRACT ADDRESSES (SEPOLIA)
- DEFI SCHEME CONTRACT: 0x8D7ed871532EE425508939B7ef28bef4E908953f
- INSURANCE FACTORY CONTRACT: 0x5EaF68dAbc26B62F340790c3414accef6aaa98B3

## Authors
Michael Dean Oyewole

## License
This project is licensed under the MIT License - see the LICENSE.md file for details.
