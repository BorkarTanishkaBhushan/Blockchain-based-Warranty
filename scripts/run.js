const main = async () => {

    const warrantyContractFactory = await hre.ethers.getContractFactory("Warranty");
    const warrantyContract = await warrantyContractFactory.deploy();
    await warrantyContract.deployed();
    console.log("Contract deployed to:", warrantyContract.address);

}

const runMain = async () => {
    try{
        await main();
        process.exit(0);
    }catch (error){
        console.log(error)
        process.exit(1)
    }
}

runMain();