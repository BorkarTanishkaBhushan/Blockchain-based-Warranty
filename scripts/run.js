const main = async () => {

    const [owner, randomPerson] = await hre.ethers.getSigners();
    const warrantyContractFactory = await hre.ethers.getContractFactory("Warranty");
    const warrantyContract = await warrantyContractFactory.deploy();
    await warrantyContract.deployed();
    console.log("Contract deployed to:", warrantyContract.address);
    console.log("Contract deployed by:", owner.address);

    //calling contract functions
    const r_tx = await warrantyContract.registerProduct("Krishna Idol", "Golden and black in color", "7189", "20");
    await r_tx.wait();

    
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