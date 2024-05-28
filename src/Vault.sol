// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {WETH} from "./mock/WETH.sol";

contract Vault is ReentrancyGuard {
    using SafeERC20 for IERC20;

    WETH public wETH;
    mapping(address => uint256) public usersETH;
    mapping(address => mapping(address => uint256)) public usersTokens;

    event EthDeposited(address indexed depositor, uint256 amount);
    event TokenDeposited(address indexed token, address indexed depositor, uint256 amount);
    event ETHWithdrawn(address indexed withdrawer, uint256 amount);
    event TokensWithdrawn(address indexed token, address indexed withdrawer, uint256 amount);
    event EthWrapped(address indexed user, uint256 amount);
    event EthUnwrapped(address indexed user, uint256 amount);

    error AddressZero();
    error InvalidAmount();

    constructor(WETH _weth) {
        wETH = _weth;
    }

    receive() external payable {}

    function depositETH() external payable nonReentrant {
        usersETH[msg.sender] += msg.value;
        emit EthDeposited(msg.sender, msg.value);
    }

    function withdrawETH(uint256 amount) external nonReentrant {
        address sender = msg.sender;
        if (usersETH[sender] < amount) {
            revert InvalidAmount();
        }
        usersETH[sender] -= amount;
        payable(sender).transfer(amount);
        emit ETHWithdrawn(sender, amount);
    }

    function depositTokens(address token, uint256 amount) external nonReentrant {
        if (token == address(0)) {
            revert AddressZero();
        }

        if (amount == 0) {
            revert InvalidAmount();
        }

        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        usersTokens[msg.sender][token] += amount;
        emit TokenDeposited(token, msg.sender, amount);
    }

    function withdrawTokens(address token, uint256 amount) external nonReentrant {
        if (token == address(0)) {
            revert AddressZero();
        }

        if (usersTokens[msg.sender][token] < amount) {
            revert InvalidAmount();
        }

        usersTokens[msg.sender][token] -= amount;
        IERC20(token).safeTransfer(msg.sender, amount);
        emit TokensWithdrawn(token, msg.sender, amount);
    }

    function wrapETH(uint256 amount) external nonReentrant {
        address wrapper = msg.sender;
        if (usersETH[wrapper] < amount) {
            revert InvalidAmount();
        }
        usersETH[wrapper] -= amount;
        usersTokens[wrapper][address(wETH)] += amount;
        wETH.deposit{value: amount}();
        emit EthWrapped(wrapper, amount);
    }

    function unwrapETH(uint256 amount) external {
        address wrapper = msg.sender;
        if (usersTokens[wrapper][address(wETH)] < amount) {
            revert InvalidAmount();
        }
        usersETH[wrapper] += amount;
        usersTokens[wrapper][address(wETH)] -= amount;
        wETH.withdraw(amount);
        emit EthUnwrapped(wrapper, amount);
    }
}
