# SupplyChain Blockchain Hardhat Project

The reason of creating a supply chain system on blockchain is to offer to the final customer an option to verify the history of a product from its raw materials. The system stores data on blockchain which does not allow others to alter the information.

This project represents a basic system for a supply chain which enstablish the traceability for food products.

This project tracks the creation of a new product. The creation of a product is divided in 2 cases:

- Production of a base product, the manufacturer inserts its details: product type, production date and expiration date.
- The product is a composed product, depends on other products which were created by a manufacturer. In this case the creator of the product must have all the ingredients required in the stock. The transformation of the products to create a new one are stored as a `Recipe`.

This project lets the users to transfer products between them. The seller chooses which product they want to sell and to whom they want to sell to(they pick the buyer). Then, the buyer can see the transfer as being in pending and only them can accept or refuse the transfer.

The key functionality is to trace back any product registered in the system. This can be done by searching a product by its barcode (any product created has a unique barcode). The system will check its ingredients and search for their details. The search will end when base product ingredients are found.

Other functionality is to block a product which could be contaminated in order to avoid using it in other components.

User Types:

- `Admin`: The autorithy which checks the quality of products and controls the actors of the supply chain.
- `Manufacturer`: Can create new products.
- `Supplier`: Buys more products and sells them to other participants.
- `Vendor`: Sells products in small quantity to the consumer.

## Functionalities:

- Add User (Admin)
- Register / Login User (Anybody with a MetaMask account)
- Add ProductType / Created at the project init or can be added by an Admin
- Add Recipe / Created at the project init
- Add Product (Manufacturer)
  - Insert base product details
  - Transform other products to create a new one
- Sell Product (Any user)
  - Create Sell Request
  - Accept / Decline
  - Transfer Object
- Trace Product (Anybody with a MetaMask account)
- Block Product (Admin)

## System Architecture

![System Architecture](/images/system-architecture.png)

## Smart Contracts:

- `Users` + `UsersInterface`: stores data about users registered in the system
- `Products` + `ProductsInterface`: stores data about product types, recipes, products, users stock of products, products transfers
- `SupplyChain`: creates a connection between `Users` and `Products`. Takes data about users and uses them in functionalities which implies products or transfers.
- `Types`: declares all the data structures used in other smart contracts.

![Smart Contracts UML Diagram](/images/smart-contracts-uml.png)

## Product Trace

Data about products are saved in a global list which could be accessed by the product barcode. The barcodes of a product's ingredients are saved in other global list (parent list) which could be accesed by the product barcode.
<picture>

<source media="(prefers-color-scheme: light)" srcset="https://github.com/BogdanNP/SupplyChain-Blockchain-Hardhat/blob/master/images/smart-contracts-uml.png">
![Product List and Parent/Ingredeints List](/images/lists.png)
</picture>
To check a product history the list of products and the list of ingredients will be checked recursively until finding base products. The search of a product's ingredients will be a tree of products.
![Product Tree](/images/product-tree.png)

## System Requirements:

- Node Version: `v16.20.2`
- NPM Version: `8.19.9`

To run the project, you need to install these dependencies:

```shell
npm install --save-dev "hardhat@^2.19.1" "@nomicfoundation/hardhat-toolbox@^4.0.0"
npm install dotenv --save
```

Other requirements:

- Metamask account (required)
- Alchemy account (optional)
- Etherscan account (optional)

## How to run:

- Open terminal, and run a local environment for the blockchain:
  - `npx hardhat node --network localhost`
- Open new terminal and deploy blockchain smart-contracts:
  - `npx hardhat run scripts/deploy_supply_chain.js`
- Start the front-end:
  - `npm start`

Run the tests:

```shell
npx hardhat test tests/SupplyChain.test.js --network hardhat
```

Deploy the contracts:

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

## Learnings:

Revert:  
If a transaction reverts, from the blockchain's state of view, it's like it never happened. No changes are stored. But the transaction is still visible off-chain, as a reverted transaction - but still no changes are stored, and this includes also event emittance.

A reverted transaction is included in a block, so in that sense it's a regular transaction. So it does leave a permanent trace

Delete in dynamic array:  
When you delete an element from a dynamic array, the memory it occupies is not actually freed. Instead, the element is simply marked as deleted and will not be returned when you access the array

Cheatsheet: https://docs.soliditylang.org/en/develop/cheatsheet.html

The "is" keyword: is used for inheritance in Solidity (https://docs.soliditylang.org/en/develop/contracts.html#inheritance)

Memory, Calldata, Storage: https://docs.alchemy.com/docs/when-to-use-storage-vs-memory-vs-calldata-in-solidity#:~:text=Memory%20is%20used%20to%20store,data%20permanently%20on%20the%20blockchain.

msg.sender (sender of the message):  
The person who's currently connecting with the contract, or the contract which is creating the call to other contract.
That's why we need to send myAccount address when we make a call from SupplyChain.sol to Products.sol or any other contract.
https://stackoverflow.com/questions/48562483/solidity-basics-what-msg-sender-stands-for
