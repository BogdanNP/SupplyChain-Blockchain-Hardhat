require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const { ALCHEMY_API_URL, SEPOLIA_PRIVATE_KEY } = process.env;
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  defaultNetwork: "sepolia",
  allowUnlimitedContractSize: true,
  settings: {
    optimizer: {
      enabled: true,
      runs: 200,
    },
  },
  networks: {
    hardhat: {
      blockGasLimit: 10000000,
    },
    sepolia: {
      url: ALCHEMY_API_URL,
      accounts: [SEPOLIA_PRIVATE_KEY],
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: ETHERSCAN_API_KEY,
  },
};
