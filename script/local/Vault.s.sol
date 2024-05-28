// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Vault} from "../../src/Vault.sol";
import {StandardTokenMock} from "../../src/mock/StandardTokenMock.sol";
import {WETH} from "../../src/mock/WETH.sol";

contract VaultScript is Script {
    address public admin = makeAddr("admin");
    address public player1 = makeAddr("player1");
    address public player2 = makeAddr("player2");

    Vault public vault;
    StandardTokenMock public mockToken;
    WETH public weth;

    function setUp() public {
        vm.deal(player1, 50 ether); // Prefill
        vm.deal(player2, 50 ether); // Prefill

        mockToken = new StandardTokenMock(player1, 50 ether, "Mock Token", "MCT", 18);
        weth = new WETH();
    }

    function run() public {
        vm.startPrank(admin);
        vault = new Vault(weth);
        console.log("Vault Deployed : %s", address(vault));
        vm.stopPrank();
        console.log("\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");

        vm.startPrank(player1);
        vault.depositETH{value: 10 ether}();
        console.log("Deposited : %s", vault.usersETH(player1));
        console.log("\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");

        vault.withdrawETH(2 ether);
        console.log("Withdrawan 2 Ether");
        console.log("Remaining Balance : %s ETH", vault.usersETH(player1));
        console.log("\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");

        vault.withdrawETH(8 ether);
        console.log("Withdrawan 8 Ether");
        console.log("Remaining Balance : %s ETH", vault.usersETH(player1));
        console.log("\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");

        mockToken.approve(address(vault), 50 ether);
        console.log("Approved MockTokens by player1 for vault contract");
        console.log("\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");

        vault.depositTokens(address(mockToken), 10 ether);
        console.log("Deposited : %s Mock Tokens", vault.usersTokens(player1, address(mockToken)));
        console.log("\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");

        vault.withdrawTokens(address(mockToken), 2 ether);
        console.log("Withdrawan 2 Mock Tokens");
        console.log("Remaining Balance : %s MCT", vault.usersTokens(player1, address(mockToken)));
        console.log("\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");

        vault.withdrawTokens(address(mockToken), 8 ether);
        console.log("Withdrawan 8 MockTokens");
        console.log("Remaining Balance : %s MCT", vault.usersTokens(player1, address(mockToken)));
        console.log("\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");

        vault.depositETH{value: 10 ether}();
        console.log("Deposited : %s", vault.usersETH(player1));
        console.log("\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");

        vault.wrapETH(2 ether);
        console.log("Wrapped : %s ETH to wETH", vault.usersTokens(player1, address(weth)));
        console.log("User's Remaining balance : %s ETH", vault.usersETH(player1));
        console.log("\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
        vm.stopPrank();
    }
}
