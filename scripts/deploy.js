const main = async () => {

    const warrantyContractFactory = await hre.ethers.getContractFactory("Warranty");
    const warrantyContract = await warrantyContractFactory.deploy("Blockchain-based-Warranty");
    await warrantyContract.deployed();

    console.log("Contract deployed to:", warrantyContract.address);

    //calling contract functions

    //register transaction
    let r_tx = await warrantyContract.registerProduct("Krishna Idol", "Golden and black in color", 7189, 2, 45);
    await r_tx.wait();
    console.log("Done, product registered")

    //buying transaction
    let b_tx = await warrantyContract.buyProduct(1,  {value: hre.ethers.utils.parseEther('0.2')}); //since function is payable we are passing ether
    await b_tx.wait();
    console.log("Done, product bought")

    const balance = await hre.ethers.provider.getBalance(warrantyContract.address);
    console.log("Contract balance:", hre.ethers.utils.formatEther(balance));

    //add delivery tx
}

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
}

runMain();