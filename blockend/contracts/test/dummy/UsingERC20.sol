//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

// import "hardhat/console.sol";

contract UsingERC20s {
    using SafeERC20 for IERC20;

    address token;
    mapping(address => uint256) public userToBalance;

    constructor(address _token) {
        token = _token;
    }

    function deposit(uint256 _amount) external {
        require(_amount > 0, "zero amount");
        bool sent = IERC20(token).transferFrom(
            msg.sender,
            address(this),
            _amount
        );
        require(sent, "tx failed");
        userToBalance[msg.sender] = _amount;
    }

    function depositSafe(uint256 _amount) external {
        require(_amount > 0, "zero amount");
        IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);
        // require(sent, "tx failed");
        userToBalance[msg.sender] = _amount;
    }

    function depositWtihPermit(
        uint256 _amount,
        uint256 _deadline,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external {
        require(_amount > 0, "zero amount");

        IERC20Permit(token).permit(
            msg.sender,
            address(this),
            _amount,
            _deadline,
            _v,
            _r,
            _s
        );
        bool sent = IERC20(token).transferFrom(
            msg.sender,
            address(this),
            _amount
        );
        require(sent, "tx failed");
        userToBalance[msg.sender] = _amount;
    }
}
