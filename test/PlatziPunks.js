const {expect }  = require("chai");
const { string } = require("hardhat/internal/core/params/argumentTypes");


describe('Platzi Punks Contract',()=>{
    const setup = async ({maxSupply = 10000})=>{
        const [owner]= await ethers.getSigners();
        const PlatziPunks = await ethers.getContractFactory("PlatziPunk");
        const deployed = await PlatziPunks.deploy(maxSupply);
    

    return {
        owner,
        deployed,

    };
};
    describe('Deployment',()=>{
        it('Asignamos al max supply para pasar parametros',async ()=>{
            const maxSupply = 4000;
            const {deployed}= await setup({maxSupply});
            const returnedMaxSupply=await deployed.maxSupply();
            expect(maxSupply).to.equal(returnedMaxSupply);
        })
    })

    describe("Minting",()=>{
        it('Mints a new token and assigns it to owner', async ()=>{
            const {owner,deployed}=await setup ({});
            await deployed.mint();
            const ownerOfMinted = await deployed.ownerOf(0);
            expect (ownerOfMinted).to.equal(owner.address);
        });

        it("Has a mintin limit" , async () => {
            const maxSupply = 2;
            const { deployed }= await setup({ maxSupply });
            
            await Promise.all([
                deployed.mint(),
                deployed.mint()
            ])
            

            await expect(deployed.mint()).not.to.be.revertedWith(
                "No hay tokens disponibles "
                ); 
        });
    });

    describe("Token uri",()=>{
        it('returns valid metadata',async()=>{
            const {deployed} = await setup({});

            await deployed.mint();
            const tokenURI= await deployed.tokenURI(0);
            const stringfiedTokenURI = await tokenURI.toString();
            const [,base64JSON]=stringfiedTokenURI.split(
                "data:application/json;base64"
            );
            const stringfiedMetaData = await Buffer.from(base64JSON,"base64").toString("ascii");
            const metadata = JSON.parse(stringfiedMetaData);
            expect(metadata).to.have.all.keys("name","description","image")
        })
    })
});