//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import {RideLibCurrencyRegistry} from "../../libraries/core/RideLibCurrencyRegistry.sol";
import {RideLibHolding} from "../../libraries/core/RideLibHolding.sol";
import {RideLibTicket} from "../../libraries/core/RideLibTicket.sol";

import {IRideHolding} from "../../interfaces/core/IRideHolding.sol";

contract RideHolding is IRideHolding, ReentrancyGuard {
    /**
     * placeDeposit allows users to deposit token into RideHub contract
     *
     * @dev call token contract's "approve" first
     *
     * @param _amount | unit in token
     *
     * @custom:event TokensDeposited
     */
    function depositTokens(bytes32 _key, uint256 _amount) external override {
        RideLibCurrencyRegistry._requireCurrencySupported(_key);
        RideLibCurrencyRegistry._requireIsCrypto(_key);
        require(_amount > 0, "zero amount");
        address token = address(bytes20(_key)); // convert to address
        // require(token != address(0), "zero token address"); // checked at currency registration

        require(
            IERC20(token).allowance(msg.sender, address(this)) >= _amount,
            "check token allowance"
        );
        bool sent = IERC20(token).transferFrom(
            msg.sender,
            address(this),
            _amount
        );
        require(sent, "tx failed");

        RideLibHolding._storageHolding().userToCurrencyKeyToHolding[msg.sender][
                _key
            ] += _amount;

        emit TokensDeposited(msg.sender, _amount);
    }

    /**
     * removeDeposit allows users to remove token from RideHub contract
     *
     * @custom:event TokensRemoved
     */
    function withdrawTokens(bytes32 _key, uint256 _amount)
        external
        override
        nonReentrant
    {
        RideLibTicket._requireNotActive();
        RideLibCurrencyRegistry._requireCurrencySupported(_key);
        RideLibCurrencyRegistry._requireIsCrypto(_key);
        require(_amount > 0, "zero amount");
        address token = address(bytes20(_key)); // convert to address
        // require(token != address(0), "zero token address"); // checked at currency registration

        RideLibHolding.StorageHolding storage s1 = RideLibHolding
            ._storageHolding();
        require(
            s1.userToCurrencyKeyToHolding[msg.sender][_key] >= _amount,
            "insufficient holdings"
        );
        require(
            IERC20(token).balanceOf(address(this)) >= _amount,
            "contract insufficient funds"
        ); // note: if no bugs then this should never be called

        s1.userToCurrencyKeyToHolding[msg.sender][_key] -= _amount;
        bool sent = IERC20(token).transfer(msg.sender, _amount);
        // bool sent = token.transferFrom(address(this), msg.sender, _amount);
        require(sent, "tx failed");

        emit TokensRemoved(msg.sender, _amount);
    }

    function getHolding(address _user, bytes32 _key)
        external
        view
        override
        returns (uint256)
    {
        RideLibCurrencyRegistry._requireCurrencySupported(_key);
        return
            RideLibHolding._storageHolding().userToCurrencyKeyToHolding[_user][
                _key
            ];
    }
}
