const API_URL = process.env.API_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const SC_CONTRACT_ADDRESS = process.env.SC_CONTRACT_ADDRESS;

class UserRoles {
  static Admin = 0;
  static Manufacturer = 1;
  static Supplier = 2;
  static Vendor = 3;
  static Customer = 4;
}

const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("SupplyChain", function () {
  async function deploySupplyChainContract() {
    const name = "Bogdan";
    const email = "bogdan@gmail.com";
    const [owner] = await ethers.getSigners();

    const UsersContract = await ethers.getContractFactory("Users");
    const usersContract = await UsersContract.deploy(name, email);

    const SupplyChain = await ethers.getContractFactory("SupplyChain");
    const supplyChain = await SupplyChain.deploy(usersContract.getAddress());
    return { supplyChain, usersContract, owner, name, email };
  }

  describe("Deployment", function () {
    it("Should set the right name", async function () {
      const { supplyChain, _, owner, name } = await loadFixture(
        deploySupplyChainContract
      );
      const user = await supplyChain.getUser(owner.address);
      expect(user.name).to.equal(name);
    });

    it("Should set the right email", async function () {
      const { supplyChain, _, owner, __, email } = await loadFixture(
        deploySupplyChainContract
      );
      const user = await supplyChain.getUser(owner.address);
      expect(user.email).to.equal(email);
    });

    it("Should set the right owner", async function () {
      const { supplyChain, _, owner } = await loadFixture(
        deploySupplyChainContract
      );
      const user = await supplyChain.getUser(owner.address);
      expect(user.id).to.equal(owner.address);
    });

    it("Should set the right role", async function () {
      const { supplyChain, _, owner } = await loadFixture(
        deploySupplyChainContract
      );
      const user = await supplyChain.getUser(owner.address);
      expect(user.role).to.equal(0);
    });
  });

  describe("Users", function () {
    it("Add Manufacturer", async function () {
      const { supplyChain, usersContract } = await loadFixture(
        deploySupplyChainContract
      );
      const [_, manufacturer] = await ethers.getSigners();
      const manufacturerName = "Manufacturer Name";
      const manufacturerEmail = "manufacturer@gmail.com";
      const newManufacturer = {
        id: manufacturer.address,
        name: manufacturerName,
        email: manufacturerEmail,
        role: UserRoles.Manufacturer,
      };

      await expect(supplyChain.addUser(newManufacturer))
        .to.emit(usersContract, "NewUser")
        .withArgs(
          manufacturer.address,
          manufacturerName,
          manufacturerEmail,
          UserRoles.Manufacturer
        );
    });

    it("Add Supplier", async function () {
      const { supplyChain, usersContract } = await loadFixture(
        deploySupplyChainContract
      );
      const [_, supplier] = await ethers.getSigners();
      const supplierName = "Supplier Name";
      const supplierEmail = "supplier@gmail.com";
      const newSupplier = {
        role: UserRoles.Supplier,
        id: supplier.address,
        name: supplierName,
        email: supplierEmail,
      };

      await expect(supplyChain.addUser(newSupplier))
        .to.emit(usersContract, "NewUser")
        .withArgs(
          supplier.address,
          supplierName,
          supplierEmail,
          UserRoles.Supplier
        );
    });

    it("Add Vendor", async function () {
      const { supplyChain, usersContract } = await loadFixture(
        deploySupplyChainContract
      );
      const [_, vendor] = await ethers.getSigners();
      const vendorName = "Vendor Name";
      const vendorEmail = "vendor@gmail.com";
      const newVendor = {
        role: UserRoles.Vendor,
        id: vendor.address,
        name: vendorName,
        email: vendorEmail,
      };

      await expect(supplyChain.addUser(newVendor))
        .to.emit(usersContract, "NewUser")
        .withArgs(vendor.address, vendorName, vendorEmail, UserRoles.Vendor);
    });

    it("Not Admin Tries to Add User", async function () {
      const { supplyChain } = await loadFixture(deploySupplyChainContract);
      const [owner, user, otherAccount] = await ethers.getSigners();
      const userName = "User Name";
      const userEmail = "user@gmail.com";
      const newUser = {
        role: UserRoles.Manufacturer,
        id: user.address,
        name: userName,
        email: userEmail,
      };

      const otherUser = {
        role: UserRoles.Manufacturer,
        id: otherAccount.address,
        name: userName,
        email: userEmail,
      };

      await supplyChain.connect(owner).addUser(newUser);

      await expect(
        supplyChain.connect(user).addUser(otherUser)
      ).to.be.revertedWith("Only admin can add other users");
    });
  });

  function getManufacturer(manufacturerId) {
    const newManufacturer = {
      id: manufacturerId,
      name: "Manufacturer Name",
      email: "manufacturer@gmail.com",
      role: UserRoles.Manufacturer,
    };
    return newManufacturer;
  }

  function getSupplier(supplierId) {
    const newSupplier = {
      id: supplierId,
      name: "Supplier Name",
      email: "supplier@gmail.com",
      role: UserRoles.Manufacturer,
    };
    return newSupplier;
  }

  function getVendor(vendorId) {
    const newVendor = {
      id: vendorId,
      name: "Vendor Name",
      email: "vendor@gmail.com",
      role: UserRoles.Vendor,
    };
    return newVendor;
  }

  describe("Products", function () {
    it("Manufacturer adds a product type", async function () {
      const { supplyChain } = await loadFixture(deploySupplyChainContract);
      const [_, manufacturer] = await ethers.getSigners();
      const newManufacturer = await getManufacturer(manufacturer.address);
      await supplyChain.addUser(newManufacturer);

      const newProductType = {
        name: "product type",
        id: "1",
        details: ["1", "2"],
      };

      await expect(
        supplyChain.connect(manufacturer).addProductType(newProductType)
      )
        .to.emit(supplyChain, "NewProductType")
        .withArgs(newProductType.name, newProductType.id);
    });

    it("Manufacturer adds a product", async function () {
      const { supplyChain } = await loadFixture(deploySupplyChainContract);
      const [_, manufacturer] = await ethers.getSigners();
      const newManufacturer = await getManufacturer(manufacturer.address);
      await supplyChain.addUser(newManufacturer);

      const newProductType = {
        id: "1",
        name: "product type",
        details: ["1", "2"],
      };

      await supplyChain.connect(manufacturer).addProductType(newProductType);

      const newProduct = {
        name: "product",
        productType: newProductType,
        barcodeId: "1",
        manufacturerName: newManufacturer.name,
        manufacturerId: newManufacturer.id,
        manufacturingDate: 333,
        expirationDate: 444,
        isBatch: true,
        batchCount: 12,
        composition: ["1", "2"],
      };

      await expect(supplyChain.connect(manufacturer).addProduct(newProduct))
        .to.emit(supplyChain, "NewProduct")
        .withArgs(
          newProduct.name,
          newProduct.manufacturerName,
          newProduct.barcodeId,
          newProduct.manufacturingDate,
          newProduct.expirationDate
        );
    });

    it("Not Manufacturer adds a product", async function () {
      const { supplyChain } = await loadFixture(deploySupplyChainContract);
      const [_, vendor] = await ethers.getSigners();
      const newVendor = await getVendor(vendor.address);
      await supplyChain.addUser(newVendor);

      const newProductType = {
        name: "product type",
        id: "1",
        details: ["1", "2"],
      };

      const newProduct = {
        name: "product",
        productType: newProductType,
        barcodeId: "1",
        manufacturerName: newVendor.name,
        manufacturerId: newVendor.id,
        manufacturingDate: 333,
        expirationDate: 444,
        isBatch: true,
        batchCount: 12,
        composition: ["1", "2"],
      };

      await expect(
        supplyChain.connect(vendor).addProduct(newProduct)
      ).to.be.revertedWith("Manufacturer role required");
    });

    it("Manufacturer creates a sell request for a product, supplier accepts", async function () {
      const { supplyChain } = await loadFixture(deploySupplyChainContract);
      const [_, manufacturer, supplier] = await ethers.getSigners();
      const newManufacturer = getManufacturer(manufacturer.address);
      const newSupplier = getSupplier(supplier.address);
      await supplyChain.addUser(newManufacturer);
      await supplyChain.addUser(newSupplier);
      const newProductType = {
        name: "product type",
        id: "1",
        details: ["1", "2"],
      };

      await supplyChain.connect(manufacturer).addProductType(newProductType);

      const newProduct = {
        name: "product",
        productType: newProductType,
        barcodeId: "1",
        manufacturerName: newManufacturer.name,
        manufacturerId: newManufacturer.id,
        manufacturingDate: 333,
        expirationDate: 444,
        isBatch: true,
        batchCount: 12,
        composition: ["1", "2"],
      };

      await expect(supplyChain.connect(manufacturer).addProduct(newProduct))
        .to.emit(supplyChain, "NewProduct")
        .withArgs(
          newProduct.name,
          newProduct.manufacturerName,
          newProduct.barcodeId,
          newProduct.manufacturingDate,
          newProduct.expirationDate
        );

      await expect(
        supplyChain
          .connect(manufacturer)
          .createSellRequest(supplier.address, "1", 1)
      )
        .to.emit(supplyChain, "ProductOwnershipTransferRequest")
        .withArgs(
          newProduct.name,
          newProduct.manufacturerName,
          newProduct.barcodeId,
          newSupplier.name,
          newSupplier.email,
          newManufacturer.name,
          newManufacturer.email,
          1
        );

      await expect(
        supplyChain
          .connect(supplier)
          .acceptSellRequest(manufacturer.address, "1", 1, true)
      )
        .to.emit(supplyChain, "ProductOwnershipTransferResponse")
        .withArgs(
          newProduct.name,
          newProduct.manufacturerName,
          newProduct.barcodeId,
          newSupplier.name,
          newSupplier.email,
          newManufacturer.name,
          newManufacturer.email,
          1,
          "ACCEPTED"
        );
    });

    it("Manufacturer creates a sell request for a product, supplier rejects", async function () {
      const { supplyChain } = await loadFixture(deploySupplyChainContract);
      const [_, manufacturer, supplier] = await ethers.getSigners();
      const newManufacturer = getManufacturer(manufacturer.address);
      const newSupplier = getSupplier(supplier.address);
      await supplyChain.addUser(newManufacturer);
      await supplyChain.addUser(newSupplier);
      const newProductType = {
        name: "product type",
        id: "1",
        details: ["1", "2"],
      };

      await supplyChain.connect(manufacturer).addProductType(newProductType);

      const newProduct = {
        name: "product",
        productType: newProductType,
        barcodeId: "1",
        manufacturerName: newManufacturer.name,
        manufacturerId: newManufacturer.id,
        manufacturingDate: 333,
        expirationDate: 444,
        isBatch: true,
        batchCount: 12,
        composition: ["1", "2"],
      };

      await expect(supplyChain.connect(manufacturer).addProduct(newProduct))
        .to.emit(supplyChain, "NewProduct")
        .withArgs(
          newProduct.name,
          newProduct.manufacturerName,
          newProduct.barcodeId,
          newProduct.manufacturingDate,
          newProduct.expirationDate
        );

      await expect(
        supplyChain
          .connect(manufacturer)
          .createSellRequest(supplier.address, "1", 1)
      )
        .to.emit(supplyChain, "ProductOwnershipTransferRequest")
        .withArgs(
          newProduct.name,
          newProduct.manufacturerName,
          newProduct.barcodeId,
          newSupplier.name,
          newSupplier.email,
          newManufacturer.name,
          newManufacturer.email,
          1
        );

      await expect(
        supplyChain
          .connect(supplier)
          .acceptSellRequest(manufacturer.address, "1", 1, false)
      )
        .to.emit(supplyChain, "ProductOwnershipTransferResponse")
        .withArgs(
          newProduct.name,
          newProduct.manufacturerName,
          newProduct.barcodeId,
          newSupplier.name,
          newSupplier.email,
          newManufacturer.name,
          newManufacturer.email,
          1,
          "REJECTED"
        );
    });

    it("Manufacturer creates a product", async function () {
      const { supplyChain } = await loadFixture(deploySupplyChainContract);
      const [_, manufacturer] = await ethers.getSigners();
      const newManufacturer = getManufacturer(manufacturer.address);
      await supplyChain.addUser(newManufacturer);

      const newProductType1 = {
        id: "1",
        name: "product type",
        details: ["1", "2"],
      };
      const newProductType2 = {
        id: "2",
        name: "product type 2",
        details: ["3", "4"],
      };

      const newProductType3 = {
        id: "3",
        name: "product type 3",
        details: ["5", "6"],
      };

      await supplyChain.connect(manufacturer).addProductType(newProductType1);
      await supplyChain.connect(manufacturer).addProductType(newProductType2);
      await supplyChain.connect(manufacturer).addProductType(newProductType3);

      const newProduct1 = {
        name: "product 1",
        productType: newProductType1,
        barcodeId: "1",
        manufacturerName: newManufacturer.name,
        manufacturerId: newManufacturer.id,
        manufacturingDate: 333,
        expirationDate: 444,
        isBatch: true,
        batchCount: 12,
        composition: ["1", "2"],
      };

      const newProduct2 = {
        name: "product 2",
        productType: newProductType2,
        barcodeId: "2",
        manufacturerName: newManufacturer.name,
        manufacturerId: newManufacturer.id,
        manufacturingDate: 333,
        expirationDate: 444,
        isBatch: true,
        batchCount: 12,
        composition: ["1", "2"],
      };

      supplyChain.connect(manufacturer).addProduct(newProduct1);
      supplyChain.connect(manufacturer).addProduct(newProduct2);

      const productQuantity1 = {
        productType: newProductType1,
        quantity: 12,
      };

      const productQuantity2 = {
        productType: newProductType2,
        quantity: 12,
      };

      const recepie = {
        productQuantities: [productQuantity1, productQuantity2],
        result: newProductType3,
        quantityResult: 5,
        composition: ["12", "13"],
      };

      await expect(
        supplyChain
          .connect(manufacturer)
          .createProduct(recepie, "Test Create Product")
      )
        .to.emit(supplyChain, "NewProduct")
        .withArgs(
          "Test Create Product",
          newManufacturer.name,
          "2",
          parseInt(Date.now() / 100000) * 100,
          parseInt(Date.now() / 100000) * 100 + 86400
        );

      const userLinkedProduct2 = await supplyChain.userLinkedProducts(
        manufacturer.address,
        2
      );
      const userLinkedProduct1 = await supplyChain.userLinkedProducts(
        manufacturer.address,
        1
      );
      const userLinkedProduct0 = await supplyChain.userLinkedProducts(
        manufacturer.address,
        0
      );

      console.log(userLinkedProduct2, userLinkedProduct1, userLinkedProduct0);

      const product0 = await supplyChain.products(0);
      const product1 = await supplyChain.products(1);
      const product2 = await supplyChain.products(2);
      console.log(product0);
      console.log(product1);
      console.log(product2);
    });
  });
});

// Maybe will be useful:

// supplyChain.on("NewUser", async (...newUser) => {
//   const [name, email, role] = newUser;
//   expect(name).to.equal(manufacturerName);
//   expect(email).to.equal(manufacturerEmail);
//   expect(role.toNumber()).to.equal(UserRoles.Manufacturer);
// });

// supplyChain.on("NewProductType", async (...newProductType_) => {
//   const [name, id] = newProductType_;
//   expect(name).to.equal(newProductType.name);
//   expect(id).to.equal(newProductType.id);
// });

// supplyChain.on("NewProduct", async (...newProduct_) => {
//   const [
//     name,
//     manufacturerName,
//     barcodeId,
//     manufacturingDate,
//     expirationDate,
//   ] = newProduct_;
//   expect(name).to.equal(newProductType.name);
//   expect(manufacturerName).to.equal(newProductType.manufacturerName);
//   expect(barcodeId).to.equal(newProduct.barcodeId);
//   expect(manufacturingDate).to.equal(newProduct.manufacturingDate);
//   expect(expirationDate).to.equal(newProduct.expirationDate);
// });

// supplyChain.on(
//   "ProductOwnershipTransferRequest",
//   async (...ownershipTransfer_) => {
//     const [
//       name,
//       manufacturerName,
//       barcodeId,
//       buyerName,
//       buyerEmail,
//       transferTime,
//     ] = ownershipTransfer_;
//     expect(name).to.equal(newProduct.name);
//     expect(manufacturerName).to.equal(newProduct.manufacturerName);
//     expect(barcodeId).to.equal(newProduct.barcodeId);
//     expect(buyerName).to.equal(newSupplier.name);
//     expect(buyerEmail).to.equal(newSupplier.email);
//     expect(transferTime).to.equal(1);
//   }
// );

// supplyChain.on(
//   "ProductOwnershipTransferResponse",
//   async (...ownershipTransfer_) => {
//     const [
//       name,
//       manufacturerName,
//       barcodeId,
//       buyerName,
//       buyerEmail,
//       transferTime,
//       status,
//     ] = ownershipTransfer_;
//     expect(name).to.equal(newProduct.name);
//     expect(manufacturerName).to.equal(newProduct.manufacturerName);
//     expect(barcodeId).to.equal(newProduct.barcodeId);
//     expect(buyerName).to.equal(newSupplier.name);
//     expect(buyerEmail).to.equal(newSupplier.email);
//     expect(transferTime).to.equal(1);
//     expect(status).to.equal("ACCEPTED");
//   }
// );
