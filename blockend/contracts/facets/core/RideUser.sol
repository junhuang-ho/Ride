//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import {RideLibUser} from "../../libraries/core/RideLibUser.sol";

import {IRideUser} from "../../interfaces/core/IRideUser.sol";

contract RideUser is IRideUser, ReentrancyGuard {
    /**
     * placeDeposit allows users to deposit token into RideHub contract
     *
     * @dev call token contract's "approve" first
     *
     * @param _amount | unit in token
     *
     * @custom:event TokensDeposited
     */
    function placeDeposit(uint256 _amount) external override {
        require(_amount > 0, "0 amount");
        RideLibUser.StorageUser storage s1 = RideLibUser._storageUser();
        require(address(s1.token) != address(0), "zero token address");
        require(
            s1.token.allowance(msg.sender, address(this)) >= _amount,
            "check token allowance"
        );
        bool sent = s1.token.transferFrom(msg.sender, address(this), _amount);
        require(sent, "tx failed");

        s1.addressToDeposit[msg.sender] += _amount;

        emit TokensDeposited(msg.sender, _amount);
    }

    /**
     * removeDeposit allows users to remove token from RideHub contract
     *
     * @custom:event TokensRemoved
     */
    function removeDeposit() external override nonReentrant {
        RideLibUser.requireNotActive();
        RideLibUser.StorageUser storage s1 = RideLibUser._storageUser();
        uint256 amount = s1.addressToDeposit[msg.sender];
        require(amount > 0, "deposit empty");
        require(address(s1.token) != address(0), "zero token address");
        require(
            s1.token.balanceOf(address(this)) >= amount,
            "contract insufficient funds"
        );

        s1.addressToDeposit[msg.sender] = 0;
        bool sent = s1.token.transfer(msg.sender, amount);
        // bool sent = token.transferFrom(address(this), msg.sender, amount);
        require(sent, "tx failed");

        emit TokensRemoved(msg.sender, amount);
    }

    //////////////////////////////////////////////////////////////////////////////////
    ///// ---------------------------------------------------------------------- /////
    ///// -------------------------- getter functions -------------------------- /////
    ///// ---------------------------------------------------------------------- /////
    //////////////////////////////////////////////////////////////////////////////////

    function getTokenAddress() external view override returns (address) {
        return address(RideLibUser._storageUser().token);
    }

    function getAddressToDeposit(address _address)
        external
        view
        override
        returns (uint256)
    {
        return RideLibUser._storageUser().addressToDeposit[_address];
    }
}
