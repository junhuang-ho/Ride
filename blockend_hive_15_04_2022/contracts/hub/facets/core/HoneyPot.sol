//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/LibHoneyPot.sol";
import "../../libraries/core/LibCurrencyRegistry.sol";
import "../../libraries/core/LibRunnerDetail.sol";
import "../../libraries/utils/LibAccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";

import "../../interfaces/IHubLibraryEvents.sol";

// TODO: keep an eye out for SafeERC20Permit

contract HoneyPot is IHubLibraryEvents, ReentrancyGuard {
    using SafeERC20 for IERC20;

    event NectarDeposited(address indexed sender, uint256 amount);

    function depositNectar(
        uint256 _amount,
        uint256 _deadline,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external {
        require(_amount > 0, "HoneyPot: zero amount");
        address token = LibCurrencyRegistry
            ._storageCurrencyRegistry()
            .nativeToken;

        IERC20Permit(token).permit(
            msg.sender,
            address(this),
            _amount,
            _deadline,
            _v,
            _r,
            _s
        );
        IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);

        address hive = LibRunnerDetail
            ._storageRunnerDetail()
            .runnerToRunnerDetail[msg.sender]
            .hive;

        LibHoneyPot.StorageHoneyPot storage s1 = LibHoneyPot._storageHoneyPot();

        s1.hiveToHoney[hive] += _amount;
        s1.runnerToHiveToContribution[msg.sender][hive] += _amount;

        emit NectarDeposited(msg.sender, _amount);
    }

    event HoneySupplied(
        address indexed sender,
        address indexed receiver,
        uint256 amount
    );

    function supplyHoney(address _receiver, uint256 _amount) external {
        LibAccessControl._requireOnlyRole(LibAccessControl.HIVE_ROLE);
        require(_amount > 0, "HoneyPot: zero amount");

        LibHoneyPot.StorageHoneyPot storage s1 = LibHoneyPot._storageHoneyPot();

        require(
            s1.hiveToHoney[msg.sender] >= _amount,
            "HoneyPot: insufficient funds"
        );

        s1.hiveToHoney[msg.sender] -= _amount;

        address token = LibCurrencyRegistry
            ._storageCurrencyRegistry()
            .nativeToken;

        IERC20(token).safeTransfer(_receiver, _amount);

        emit HoneySupplied(msg.sender, _receiver, _amount);
    }

    function getHoney(address _hive) external view returns (uint256) {
        return LibHoneyPot._storageHoneyPot().hiveToHoney[_hive];
    }

    function getRunnerHoneyContribution(address _runner, address _hive)
        external
        view
        returns (uint256)
    {
        return
            LibHoneyPot._storageHoneyPot().runnerToHiveToContribution[_runner][
                _hive
            ];
    }
}
