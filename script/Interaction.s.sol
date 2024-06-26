// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
import {LinkToken} from "../test/mocks/LinkToken.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract CreateSubscription is Script{

    function CreateSubscriptionUsingConfig() public returns(uint64){
        HelperConfig helperConfig = new HelperConfig();
        (, , , , ,address vrfCoordinator,) = helperConfig.activeNetworkConfig();
        return createSubscription(vrfCoordinator);
    }

    function createSubscription(address vrfCoordinator) public returns(uint64){
        console.log("Creating subscription on ChainId: ",block.chainid);
        vm.startBroadcast();
        uint64 subId = VRFCoordinatorV2Mock(vrfCoordinator).createSubscription();
        vm.stopBroadcast();
        console.log("Your Sub Id is: ",subId);
        console.log("Please update subscriptionId in HelperConfig.s.sol");
        return subId;
    }

    function run() external returns(uint64){
        return CreateSubscriptionUsingConfig();
    }
}

contract FundSubscription is Script{
    uint96 public constant FUND_AMOUNT = 3 ether;

    function FundSubscriptionUsingConfig() public{
        HelperConfig helperConfig = new HelperConfig();
        (uint64 subId , , , , ,address vrfCoordinator, address link ) = helperConfig.activeNetworkConfig();
        fundSubscription(vrfCoordinator, subId, link);
    }

    function fundSubscription(address vrfCoordinator, uint64 subId, address link) public{
        console.log("Funding subscription on ChainId: ",block.chainid);
        console.log("Using VRFCoordinator: ",vrfCoordinator);   
        console.log("Using chainid for link: ",block.chainid);
        if (block.chainid == 31337){
            vm.startBroadcast();
            VRFCoordinatorV2Mock(vrfCoordinator).fundSubscription(subId, FUND_AMOUNT);
            vm.stopBroadcast();
        }else {
            vm.startBroadcast();
            LinkToken(link).transferAndCall(vrfCoordinator, FUND_AMOUNT, abi.encode(subId));
            vm.stopBroadcast();
        }
    }

    function run() external{
        FundSubscriptionUsingConfig();
    }
}


contract AddConsumer is Script{

    function addConsumer(
        address raffle,
        address vrfCoordinator,
        uint64 subId
    ) public {
        console.log("Adding consumer on ChainId: ",block.chainid);
        console.log("Using vrfCoordingator: ",vrfCoordinator);
        vm.startBroadcast();
        VRFCoordinatorV2Mock(vrfCoordinator).addConsumer(subId, raffle);
        vm.stopBroadcast();
    }

    function addConsumerUsingConfig(address raffle) public{
        HelperConfig helperConfig = new HelperConfig();
        (uint64 subId, , , , ,address vrfCoordinator, ) = helperConfig.activeNetworkConfig();
        addConsumer(raffle, vrfCoordinator, subId);
    }

    function run() external {
        address raffle = DevOpsTools.get_most_recent_deployment(
            "Raffle",
            block.chainid
        );
        addConsumerUsingConfig(raffle);
    }
}