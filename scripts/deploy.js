const { ethers } = require("hardhat");
require('dotenv').config()
async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    const Token = await ethers.getContractFactory("Lockup");
    // const token = await Token.deploy();
    const token = await Token.deploy("0xD28B6408d3571B12812cDD6b2b3DcD8B007e3345", "0x5ccDDC1962CCc16e58D0B902598965321807726f");
  
    console.log("Token address:", token.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
