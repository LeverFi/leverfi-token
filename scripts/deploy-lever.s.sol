// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {Vm} from "forge-std/Vm.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {Lever2} from "../contracts/Lever2.sol";

contract DeployLeverScript is Script {
    function run() public {
        vm.startBroadcast();
        Lever2 lever2 = new Lever2();
        console.log("Deployed Lever2 implementation -> ", address(lever2));
    }
}
