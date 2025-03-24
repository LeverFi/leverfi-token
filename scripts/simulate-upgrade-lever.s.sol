// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {Vm} from "forge-std/Vm.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {Lever} from "../contracts/Lever.sol";
import {TimelockController} from "../contracts/TimelockController.sol";

contract SimulateUpgradeLeverScript is Script {
    TimelockController public timelockController = TimelockController(payable(0xf29900Bb8F0f12726d4Ec5F7D511ebC44be06E09));
    address public _leverProxy = 0x4B5f49487ea7B3609b1aD05459BE420548789f1f;
    address public operator = 0xa2F5acBA956A226e91C87B0F4c2215534332Fa5b;

    function setUp() public {
        console.log("TimelockController delay:", timelockController.getMinDelay());
    }

    function run() public {
        // ================== Upgrade ==================
        console.log("");

        bytes memory upgradeToData = abi.encodeWithSignature("upgradeTo(address)", 0xc5985E73DD78d60D4AB193db30778593Ea4CCfFD);
        console.log("upgradeTo(address):");
        console.logBytes(upgradeToData);

        vm.startPrank(operator, operator);
        console.log("Scheduling upgrade(address)...");
        timelockController.schedule(
            _leverProxy,
            0,
            upgradeToData,
            bytes32(0),
            bytes32(0),
            timelockController.getMinDelay()
        );

        // ================== Mint ==================
        console.log("");

        bytes memory mintData = abi.encodeWithSignature("mint(address,uint256)", address(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF), 1e18);
        console.log("mint() - data");
        console.logBytes(mintData);

        console.log("Scheduling mint(to,address)...");
        timelockController.schedule(
            _leverProxy,
            0,
            mintData,
            bytes32(0),
            bytes32(0),
            timelockController.getMinDelay()
        );

        // ================== Executes ==================
        console.log("");

        console.log("Time warp forward: +", timelockController.getMinDelay() + 1);
        vm.warp(block.timestamp + timelockController.getMinDelay() + 1);

        console.log("Executing upgrade(address)...");
        timelockController.execute(
            _leverProxy,
            0,
            upgradeToData,
            bytes32(0),
            bytes32(0)
        );

        console.log("Executing mint(to,address)...");
        timelockController.execute(
            _leverProxy,
            0,
            mintData,
            bytes32(0),
            bytes32(0)
        );

        console.log("");
        console.log("Total Supply after:", Lever(_leverProxy).totalSupply());
    }
}