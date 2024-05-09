// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {SurpriseNft} from "../src/SurpriseNft.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";
import {console} from "forge-std/console.sol";

contract DeployNft is Script {
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY =
        0xac0944bcc38a17e39ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff98;

    uint256 public deployerKey;

    function run() external returns (SurpriseNft) {
        if (block.chainid == 31337) {
            deployerKey = DEFAULT_ANVIL_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("PRIVATE_KEY");
        }
        string memory motorbikeSvg = vm.readFile("./image/motorbike.svg");
        string memory carSvg = vm.readFile("./image/car.svg");

        vm.startBroadcast(deployerKey);
        SurpriseNft surpriseNft = new SurpriseNft(
            svgToImageURI(motorbikeSvg),
            svgToImageURI(carSvg)
        );
        vm.stopBroadcast();
        return surpriseNft;
    }

    function svgToImageURI(
        string memory svg
    ) public pure returns (string memory) {
        string memory baseURI = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg))) // Removing unnecessary type castings, this line can be resumed as follows : 'abi.encodePacked(svg)'
        );
        return string(abi.encodePacked(baseURI, svgBase64Encoded));
    }
}
