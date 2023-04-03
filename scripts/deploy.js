
const deploy = async () =>{
    const [deployers]=await ethers.getSigners();
    console.log("Deploying contract with", deployers.address)

    const PlatziPunk = await ethers.getContractFactory("PlatziPunk");
    const deployed = await PlatziPunk.deploy();

    console.log("Platzi Punks was deployed at: ",deployed.address);
};

deploy().then(()=>process.exit(0)).catch(error=>{
    console.log(error);
    process.exit(1);
})