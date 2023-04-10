// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./Base64.sol";
import "./PlatziPunkDna.sol";

contract PlatziPunk is ERC721,ERC721Enumerable, PlatziPunkDNA{

    using Counters for Counters.Counter;
    using Strings for uint256;
     Counters.Counter private _idCounter;
     uint256 public maxSupply;   
     mapping (uint =>uint) public tokenDNA;

    constructor(uint _maxSupply) ERC721("PlatziPunk","PPNFT"){
        maxSupply=_maxSupply;
    }


    function mint() public {
        
        uint256 current = _idCounter.current();
        require(current<=maxSupply, "Doesn't Platzi Punk availabel :_( ");
        tokenDNA[current]=deterministicPseudoRandom(current,msg.sender);
        _safeMint(msg.sender, current);
        _idCounter.increment();
    }

    function _baseURI() internal pure override returns (string memory){
        return "https://avataaars.io/";
    }

    function _paramsURI(uint256 _dna) internal view returns (string memory){
         string memory params;
         params = string (abi.encodePacked(
            "accesoriesType=",
            getAccesoriesType(_dna),
            "&clothesColor=",
            getClotheColor(_dna),
            "&clotheType=",
            getClotheType(_dna),
            "&eyeType=",
            getEyeType(_dna),
            "&eyeBrowType=",
            getEyeBrowType(_dna),
            "&facialHairColor=",
            getFacialHairColor(_dna),
            "&facialHairType=",
            getFacialHairType(_dna),
            "&hairColor=", 
            getHairColor(_dna),
            "&hatColor=",
            getHatColor(_dna),
            "&graphicType=",
            getGraphicType(_dna),
            "&mouthType=",
            getMouthType(_dna),
            "&skinColor=",
            getSkinColor(_dna)
           

         ));
         return string(abi.encodePacked(params, "&topType=",
            getTopType(_dna)));
    }

    function imageByDNA(uint256 _dna) public view returns (string memory){
        string memory baseURI = _baseURI();
        string memory paramsURI = _paramsURI(_dna);

        return string (abi.encodePacked(baseURI,"?",paramsURI));
    }

    function tokenURI(uint256 tokenId)
    public 
    view 
    override
    returns (string memory){
        require(_exists(tokenId),"Token doesn't exist");

        uint256 dna = tokenDNA[tokenId];
        string memory image = imageByDNA(dna);

        string memory jsonURI = Base64.encode(
            abi.encodePacked(
                   '{ "name": "PlatziPunks #',
                tokenId.toString(),
                '", "description": "Platzi Punks are randomized Avataaars stored on chain to teach DApp development on Platzi", "image": "',
                image,
                '"}'
            )
        );
        return string(abi.encodePacked("data:application/json;base64",jsonURI));
    }
    //Override required 
    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}