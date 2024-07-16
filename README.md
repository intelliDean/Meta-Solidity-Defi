# INSURANCE AND COLLATERAL PROTECTION CONTRACT

This Solidity program is a simple implementation of "Insurance contracts" and "Collateral protection contracts." It employs the factory contract model to allow individuals to create either insurance contracts or collateral protection contracts for crypto-backed loans.

## Description

This program is written in Solidity, a programming language used for developing smart contracts on the Ethereum blockchain. The main factory contract deploys new instances of child contracts based on the user's choice. The factory can deploy either a CryptoWalletInsurance contract or a CollateralProtectionInsurance contract.

### CryptoWalletInsurance Contract

This contract helps owners of smart contract wallets stay protected from hackers. Users pay a premium, which is invested in a DeFi scheme. They can later withdraw their interest earned from these investments. In case of an insured event, users can claim their coverage amount.

### CollateralProtectionInsurance Contract

This contract provides collateral protection for crypto-backed loans. Based on the chosen insurance policy, users can get back a percentage of their loan amount if the collateral value drops. Users pay a premium, which is also invested in a DeFi scheme, and they can withdraw their interest earned.

### DeFi Scheme

A mock DeFi scheme is implemented to simulate the investment and interest earning process. Users' premiums are invested in this scheme, generating interest over time.

## CONTRACT ADDRESSES (GOERLI)

- DEFI SCHEME CONTRACT: 0xCDe7227061e299fa959c0f0a08595bAfac2D957C
- INSURANCE FACTORY CONTRACT: 0x009ee3290fb96023255313aD92dD926165f0FEb4

## Authors

Ekarika Nsemeke

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.