require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");
const dotenv = require("dotenv");

dotenv.config();

module.exports = {
    solidity: "0.8.9",
    networks:{
        // hardhat: {
        //     chainId: 1337
        //   },
        mumbai: {
            url: `https://polygon-mumbai.g.alchemy.com/v2/${process.env.POLYGON_MUMBAI}`,
            // url: process.env.POLYGON_MUMBAI,
            accounts: [`${process.env.PRIVATE_KEY}`],
        }
    },
    etherscan:{
        apiKey: `${process.env.API_KEY}`,
    },
}