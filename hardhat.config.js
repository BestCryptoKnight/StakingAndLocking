/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 require("@nomiclabs/hardhat-waffle");
 require("@nomiclabs/hardhat-etherscan");
 require('hardhat-contract-sizer');
 require('dotenv').config()
 
 module.exports = {
   networks: {
     bnb: {
       url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
       chainId: 97,
       accounts: [`${process.env.PRIVATE_KEY}`]
     },
     kovan: {
      url: "https://kovan.infura.io/v3/66184b0d11d84613ae4721803d5a8560",
      chainId: 42,
      accounts: [`${process.env.PRIVATE_KEY}`]
    },
     mainbsc: {
       url: "https://bsc-dataseed.binance.org/",
       chainId: 56,
       accounts: [`${process.env.PRIVATE_KEY}`]
     },
     avalancheTest: {
       url: 'https://api.avax-test.network/ext/bc/C/rpc',
       gasPrice: 225000000000,
       chainId: 43113,
       accounts: [`${process.env.PRIVATE_KEY}`]
     },
     avalancheMain: {
       url: 'https://api.avax.network/ext/bc/C/rpc',
       gasPrice: 225000000000,
       chainId: 43114,
       accounts: [`${process.env.PRIVATE_KEY}`]
     }
   },
   etherscan: {
    //  apiKey: "NURDXE28N6MM9VI216UCSEBZVV5IA7UWSS" // for ether net work
    //  apiKey: "N2E5BV7EU18ZEFEMGM8YS5NBPPQH9QJK3Q"
    apiKey: "BCT83TFQ1QJ7XPRIVG2V82YVF6SVTRVNDE"
   },
   solidity: {
     version: "0.8.0",
     settings: {
       optimizer: {
         enabled: true,
         runs: 1,
       },
     },
 
   },
   contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: true,
    strict: true,
    only: [':ERC20$'],
  }
 };
 