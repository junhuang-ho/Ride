//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/RideLibAllianceFund.sol";
import "../../libraries/core/RideLibCurrencyRegistry.sol";
import "../../libraries/core/RideLibDriverDetails.sol";
import "../../libraries/utils/RideLibAccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";

// TODO: keep an eye out for SafeERC20Permit

contract RideAllianceFund is ReentrancyGuard {
    using SafeERC20 for IERC20;

    event AllianceFunded(address indexed sender, uint256 amount);

    function fundAlliancePermit(
        uint256 _amount,
        uint256 _deadline,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external {
        require(_amount > 0, "RideAllianceFund: zero amount");
        address token = RideLibCurrencyRegistry
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

        address alliance = RideLibDriverDetails
            ._storageDriverDetails()
            .driverToDriverDetails[msg.sender]
            .alliance;

        RideLibAllianceFund.StorageAllianceFund storage s1 = RideLibAllianceFund
            ._storageAllianceFund();

        s1.allianceToFunds[alliance] += _amount;
        s1.driverToAllianceToContribution[msg.sender][alliance] += _amount;

        emit AllianceFunded(msg.sender, _amount);
    }

    event FundsTransferred(
        address indexed sender,
        address indexed receiver,
        uint256 amount
    );

    function transferFunds(address _receiver, uint256 _amount) external {
        RideLibAccessControl._requireOnlyRole(
            RideLibAccessControl.ALLIANCE_ROLE
        );
        require(_amount > 0, "RideAllianceFund: zero amount");

        RideLibAllianceFund.StorageAllianceFund storage s1 = RideLibAllianceFund
            ._storageAllianceFund();

        require(
            s1.allianceToFunds[msg.sender] >= _amount,
            "RideAllianceFund: insufficient funds"
        );

        s1.allianceToFunds[msg.sender] -= _amount;

        address token = RideLibCurrencyRegistry
            ._storageCurrencyRegistry()
            .nativeToken;

        IERC20(token).safeTransfer(_receiver, _amount);

        emit FundsTransferred(msg.sender, _receiver, _amount);
    }
}
