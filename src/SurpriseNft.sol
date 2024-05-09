// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol"; // this is used to emncode the metadata . metadata-> to be made as json object-> the json pobject is encoded by base64 to json tokenuri
import {Surprise} from "./enum.sol";

contract SurpriseNft is ERC721 {
    uint256 private s_tokenCounter;
    string private s_carSvgImageUri;
    string private s_motorbikeSvgImageUri;

    mapping(uint256 => Surprise) private s_tokenIdToSurprise;

    constructor(
        string memory carSvgImageUri,
        string memory motorbikeSvgImageUri
    ) ERC721("Surprise NFT", "SN") {
        s_tokenCounter = 1;
        s_carSvgImageUri = carSvgImageUri;
        s_motorbikeSvgImageUri = motorbikeSvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        if (s_tokenCounter % 2 == 0) {
            s_tokenIdToSurprise[s_tokenCounter] = Surprise.CAR;
        } else {
            s_tokenIdToSurprise[s_tokenCounter] = Surprise.MOTORBIKE;
        }
        s_tokenCounter++;
    }

    function flipSurpriseForLucky(uint256 tokenId) public {
        if (tokenId % 5 == 0) {
            s_tokenIdToSurprise[s_tokenCounter] = Surprise.CAR;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToSurprise[tokenId] == Surprise.CAR) {
            imageURI = s_carSvgImageUri;
        } else {
            imageURI = s_motorbikeSvgImageUri;
        }
        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name(),
                                '", "description":"An NFT that reflects the surprise to the  owner, 100% on Chain!", ',
                                '"attributes": [{"trait_type": "excitement", "value": 100}], "image":"',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    //Getters:

    function getSurpriseWithTokenId(uint256 tokenId) public returns (Surprise) {
        return s_tokenIdToSurprise[tokenId];
    }
}
