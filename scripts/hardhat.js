const hre = require("hardhat");

async function main () {

    const Wallet = await hre.ethers.getContractFactory('Wallet');
    const wallet = await Wallet.deploy();

    await wallet.deployed();

    console.log("Wallet deployed to address " + wallet.address);
}

main().catch((err) => {
    console.error(err);
    process.exitCode = 1;
});