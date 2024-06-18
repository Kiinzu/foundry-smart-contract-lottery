// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
import {LinkToken} from "../test/mocks/LinkToken.sol";

contract HelperConfig is Script{
    // struct NetworkConfig{
    //     uint256 entranceFee;
    //     uint256 interval;
    //     address vrfCoordinator;
    //     bytes32 gasLane;
    //     uint64 subscriptionId;
    //     uint32 callbackGasLimit;
    //     address link;
    //     uint256 deployerKey;
    // }

    struct NetworkConfig{
        uint64 subscriptionId;
        bytes32 gasLane;
        uint256 interval;
        uint256 entranceFee;
        uint32 callbackGasLimit;
        address vrfCoordinator;
        address link;
    }

    // uint256 public constant DEFAULT_ANVIL_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if(block.chainid == 11155111){
            activeNetworkConfig = geetSepoliaEthConfig();
            console.log("Sepolia ETH Network");
        }else{
            activeNetworkConfig = getOrCreateAnvilEthConfig();
            console.log("Anvil ETH Network");
        }
    }

    function geetSepoliaEthConfig() public view returns(NetworkConfig memory){
        return NetworkConfig({
            subscriptionId: 0,
            gasLane: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
            interval: 30,
            entranceFee: 0.01 ether,
            callbackGasLimit: 500000,
            vrfCoordinator: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B,
            link: 0x779877A7B0D9E8603169DdbD7836e478b4624789
            // deployerKey: vm.envUint("PRUVATE_KEY")
        });
    }

    function getOrCreateAnvilEthConfig() public returns(NetworkConfig memory){
        if(activeNetworkConfig.vrfCoordinator != address(0)){
            return activeNetworkConfig;
        }
        uint96 baseFee = 0.25 ether;
        uint96 gasPriceLink = 1e9; // 1 gwei
        vm.startBroadcast();
        VRFCoordinatorV2Mock vrfCoordinatorMock = new VRFCoordinatorV2Mock(baseFee, gasPriceLink);
        LinkToken link = new LinkToken();
        vm.stopBroadcast();

        return NetworkConfig({
            subscriptionId: 0,
            gasLane: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
            interval: 30,
            entranceFee: 0.01 ether,
            callbackGasLimit: 500000,
            vrfCoordinator: address(vrfCoordinatorMock),
            link: address(link)
            // deployerKey: DEFAULT_ANVIL_KEY
        });
    }
}
