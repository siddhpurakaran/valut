// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Basic Token Mock
contract StandardTokenMock is ERC20 {
    uint8 immutable myDecimals;
    string myName;
    string mySymbol;

    constructor(
        address initialAccount,
        uint256 initialBalance,
        string memory name,
        string memory symbol,
        uint8 decimals
    ) ERC20("mock token", "mock token") {
        _mint(initialAccount, initialBalance);
        myDecimals = decimals;
        myName = name;
        mySymbol = symbol;
    }

    function name() public view virtual override returns (string memory) {
        return myName;
    }

    function symbol() public view virtual override returns (string memory) {
        return mySymbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return myDecimals;
    }

    function mint(address to, uint256 amount) external returns (uint256) {
        _mint(to, amount);
        return amount;
    }

    function burn(address from, uint256 amount) external returns (uint256) {
        _burn(from, amount);
        return amount;
    }
}
