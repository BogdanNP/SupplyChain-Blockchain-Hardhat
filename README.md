# SupplyChain Hardhat Project

Project Structure:

- `Admin`:
  - adds users
  - confirms recepies
- `Base Manufacturer`:
  - adds products
  - sells products
- `Manufacturer`:
  - adds recepies
    - waits for the recepies to by confirmed by the `Admin`
  - buys products
  - transforms the products by using the recepies and creates other products
  - sells products
- `Supplier`:
  - buys products
  - sells products
- `Vendor`:
  - buys products
  - sell products (in smaller quantity)
- `Client`:
  - buys products(in smaller quantity)

TODO:

- add product (M)
- send product to other user (V)

*

System Requirements:

- Node Version: `v16.20.2`
- NPM Version: `8.19.9`

Other requirements:

- Alchemy account
- Etherscan account
- Metamask account

To run the project, you need to install these dependencies:

```shell
npm install --save-dev "hardhat@^2.19.1" "@nomicfoundation/hardhat-toolbox@^4.0.0"
npm install dotenv --save
```

To run the tests:

```shell
npx hardhat test tests/SupplyChain.test.js --network hardhat
```

To deploy the contracts:

```shell
npx hardhat run scripts/deploy_supply_chain.js --network sepolia
```

Useful commands:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```
