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
    const SupplyChain = await ethers.getContractFactory("SupplyChain");
    const supplyChain = await SupplyChain.deploy(name, email);
    return { supplyChain, owner, name, email };
  }

  describe("Deployment", function () {
    it("Should set the right name", async function () {
      const { supplyChain, owner, name } = await loadFixture(
        deploySupplyChainContract
      );
      const user = await supplyChain.users(owner.address);
      expect(user.name).to.equal(name);
    });

    it("Should set the right email", async function () {
      const { supplyChain, owner, _, email } = await loadFixture(
        deploySupplyChainContract
      );
      const user = await supplyChain.users(owner.address);
      expect(user.email).to.equal(email);
    });

    it("Should set the right owner", async function () {
      const { supplyChain, owner } = await loadFixture(
        deploySupplyChainContract
      );
      const user = await supplyChain.users(owner.address);
      expect(user.id_).to.equal(owner.address);
    });

    it("Should set the right role", async function () {
      const { supplyChain, owner } = await loadFixture(
        deploySupplyChainContract
      );
      const user = await supplyChain.users(owner.address);
      expect(user.role).to.equal(0);
    });
  });

  describe("Add Users", function () {
    it("Add Manufacturer", async function () {
      const { supplyChain } = await loadFixture(deploySupplyChainContract);
      const [_, manufacturer] = await ethers.getSigners();
      const manufacturerName = "Manufacturer Name";
      const manufacturerEmail = "manufacturer@gmail.com";
      const newManufacturer = {
        id_: manufacturer.address,
        name: manufacturerName,
        email: manufacturerEmail,
        role: UserRoles.Manufacturer,
      };

      supplyChain.on("NewUser", async (...newUser) => {
        const [name, email, role] = newUser;
        expect(name).to.equal(manufacturerName);
        expect(email).to.equal(manufacturerEmail);
        expect(role.toNumber()).to.equal(UserRoles.Manufacturer);
      });

      await supplyChain.addParty(newManufacturer);
    });

    it("Add Supplier", async function () {
      const { supplyChain } = await loadFixture(deploySupplyChainContract);
      const [_, supplier] = await ethers.getSigners();
      const supplierName = "Supplier Name";
      const supplierEmail = "supplier@gmail.com";
      const newSupplier = {
        role: UserRoles.Supplier,
        id_: supplier.address,
        name: supplierName,
        email: supplierEmail,
      };

      supplyChain.on("NewUser", async (...newUser) => {
        const [name, email, role] = newUser;
        expect(name).to.equal(supplierName);
        expect(email).to.equal(supplierEmail);
        expect(role.toNumber()).to.equal(UserRoles.Supplier);
      });

      supplyChain.addParty(newSupplier);
    });

    it("Add Vendor", async function () {
      const { supplyChain } = await loadFixture(deploySupplyChainContract);
      const [_, vendor] = await ethers.getSigners();
      const vendorName = "Vendor Name";
      const vendorEmail = "vendor@gmail.com";
      const newVendor = {
        role: UserRoles.Vendor,
        id_: vendor.address,
        name: vendorName,
        email: vendorEmail,
      };

      supplyChain.on("NewUser", async (...newUser) => {
        const [name, email, role] = newUser;
        expect(name).to.equal(vendorName);
        expect(email).to.equal(vendorEmail);
        expect(role.toNumber()).to.equal(UserRoles.Vendor);
      });

      supplyChain.addParty(newVendor);
    });

    it("Not Admin Tries to Add User", async function () {
      const { supplyChain } = await loadFixture(deploySupplyChainContract);
      const [owner, user, otherAccount] = await ethers.getSigners();
      const userName = "User Name";
      const userEmail = "user@gmail.com";
      const newUser = {
        role: UserRoles.Manufacturer,
        id_: user.address,
        name: userName,
        email: userEmail,
      };

      const otherUser = {
        role: UserRoles.Manufacturer,
        id_: otherAccount.address,
        name: userName,
        email: userEmail,
      };

      await supplyChain.connect(owner).addParty(newUser);

      await expect(
        supplyChain.connect(user).addParty(otherUser)
      ).to.be.revertedWith("Only admin can add other users");
    });
  });

  function getManufacturer(manufacturerAddress) {
    const newManufacturer = {
      id_: manufacturerAddress,
      name: "Manufacturer Name",
      email: "manufacturer@gmail.com",
      role: UserRoles.Manufacturer,
    };
    return newManufacturer;
  }

  function getVendor(vendorAddress) {
    const newVendor = {
      id_: vendorAddress,
      name: "Vendor Name",
      email: "vendor@gmail.com",
      role: UserRoles.Vendor,
    };
    return newVendor;
  }

  describe("Add Products", function () {
    it("Manufacturer adds a product", async function () {
      const { supplyChain } = await loadFixture(deploySupplyChainContract);
      const [_, manufacturer] = await ethers.getSigners();
      const newManufacturer = await getManufacturer(manufacturer.address);
      await supplyChain.addParty(newManufacturer);

      const newProduct = {
        name: "product",
        barcodeId: "1",
        manufacturerName: newManufacturer.name,
        manufacturer: newManufacturer.id_,
        manufacturingDate: 333,
        expirationDate: 444,
        composition: ["1", "2"],
      };

      supplyChain.on("NewProduct", async (...newProduct_) => {
        const [
          name,
          manufacturerName,
          barcodeId,
          manufacturingDate,
          expirationDate,
        ] = newProduct_;
        expect(name).to.equal(newProduct.name);
        expect(manufacturerName).to.equal(newProduct.manufacturerName);
        expect(barcodeId).to.equal(newProduct.barcodeId);
        expect(manufacturingDate).to.equal(newProduct.manufacturingDate);
        expect(expirationDate).to.equal(newProduct.expirationDate);
      });

      await supplyChain.connect(manufacturer).addProduct(newProduct);
    });

    it("Not Manufacturer adds a product", async function () {
      const { supplyChain } = await loadFixture(deploySupplyChainContract);
      const [_, vendor] = await ethers.getSigners();
      const newVendor = await getVendor(vendor.address);
      await supplyChain.addParty(newVendor);

      const newProduct = {
        name: "product",
        barcodeId: "1",
        manufacturerName: newVendor.name,
        manufacturer: newVendor.id_,
        manufacturingDate: 333,
        expirationDate: 444,
        composition: ["1", "2"],
      };

      await expect(
        supplyChain.connect(vendor).addProduct(newProduct)
      ).to.be.revertedWith("Manufacturer role required");
    });
  });
});
