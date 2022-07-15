const main = async () => {

    const [owner, randomPerson] = await hre.ethers.getSigners();
    const warrantyContractFactory = await hre.ethers.getContractFactory("Warranty");
    const warrantyContract = await warrantyContractFactory.deploy("Blockchain-based-Warranty");
    await warrantyContract.deployed();
    console.log("Contract deployed to:", warrantyContract.address);
    console.log("Contract deployed by:", owner.address);

    //calling contract functions

    //register transaction
    const r_tx = await warrantyContract.registerProduct("Krishna Idol", "Golden and black in color", 7189, 2);
    await r_tx.wait();
    console.log("DOne registered")

    //buying transaction
    const b_tx = await warrantyContract.connect(randomPerson).buyProduct(1,  {value: hre.ethers.utils.parseEther('0.2')}); //since function is payable we are passing ether
    await b_tx.wait();
    console.log("Done bought")
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