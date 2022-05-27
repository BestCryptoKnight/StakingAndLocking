const { ethers } = require("hardhat");
require('dotenv').config()
async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    const Token = await ethers.getContractFactory("Lockup");
    // const token = await Token.deploy();
    const token = await Token.deploy("0x3D6Eb75458A8536DD8397012c52DF14785FDc5f4", "0x5ccDDC1962CCc16e58D0B902598965321807726f");
  
    console.log("Token address:", token.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
