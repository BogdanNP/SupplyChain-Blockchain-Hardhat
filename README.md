# SupplyChain Hardhat Project

Project Structure:

- `Admin`:
  - [OK] adds users
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

Contracts:

- `Users`
- `Products`
- `ObjectTransfers`

TODO:

- add product (M)
- send product to other user (V)

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

Learnings:

Revert
If a transaction reverts, from the blockchain's state of view, it's like it never happened. No changes are stored. But the transaction is still visible off-chain, as a reverted transaction - but still no changes are stored, and this includes also event emittance.

A reverted transaction is included in a block, so in that sense it's a regular transaction. So it does leave a permanent trace

Delete in dynamic array:
When you delete an element from a dynamic array, the memory it occupies is not actually freed. Instead, the element is simply marked as deleted and will not be returned when you access the array

Cheatsheet: https://docs.soliditylang.org/en/develop/cheatsheet.html
