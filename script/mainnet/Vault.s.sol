// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Vault} from "../../src/Vault.sol";
import {WETH} from "../../src/mock/WETH.sol";

contract VaultScript is Script {
    WETH public weth;
    Vault public vault;

    function setUp() public {
        weth = new WETH();
    }

    function run() public {
        vm.startBroadcast();
        vault = new Vault(weth);
        console.log("Vault Deployed : %s", address(vault));
        vm.stopBroadcast();
        console.log("\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
    }
}
