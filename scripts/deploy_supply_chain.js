async function main() {
  const TypesContract = await ethers.getContractFactory("Types");
  const types = await TypesContract.deploy();
  console.log("Types address:", await types.getAddress());

  const Users = await ethers.getContractFactory("Users");
  const users = await Users.deploy("Bogdan", "bogdan@gmail.com");
  console.log("Users address:", await users.getAddress());

  const Products = await ethers.getContractFactory("Products");
  const products = await Products.deploy();
  console.log("Products address:", await products.getAddress());

  const SupplyChain = await ethers.getContractFactory("SupplyChain");
  const supply_chain = await SupplyChain.deploy(users.getAddress());
  console.log("SupplyChain address:", await supply_chain.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
