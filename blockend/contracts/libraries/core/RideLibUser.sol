//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {RideLibTicket} from "../../libraries/core/RideLibTicket.sol";

library RideLibUser {
    bytes32 constant STORAGE_POSITION_USER = keccak256("ds.user");

    struct StorageUser {
        ERC20 token;
        mapping(address => uint256) addressToDeposit;
    }

    function _storageUser() internal pure returns (StorageUser storage s) {
        bytes32 position = STORAGE_POSITION_USER;
        assembly {
            s.slot := position
        }
    }

    function requireNotActive() internal view {
        RideLibTicket.StorageTicket storage s1 = RideLibTicket._storageTicket();
        require(s1.addressToTixId[msg.sender] == 0, "caller is active");
    }

    event TokensTransferred(
        address indexed decrease,
        bytes32 indexed tixId,
        address increase,
        uint256 amount
    );

    /**
     * _transfer rebalances _amount tokens from one address to another
     *
     * @param _tixId Ticket ID
     * @param _amount | unit in token
     * @param _decrease address to decrease tokens by
     * @param _increase address to increase tokens by
     *
     * @custom:event TokensTransferred
     *
     * not use msg.sender instead of _decrease param? in case admin is required to sort things out
     */
    function _transfer(
        bytes32 _tixId,
        uint256 _amount,
        address _decrease,
        address _increase
    ) internal {
        StorageUser storage s1 = _storageUser();

        s1.addressToDeposit[_decrease] -= _amount;
        s1.addressToDeposit[_increase] += _amount;

        emit TokensTransferred(_decrease, _tixId, _increase, _amount); // note decrease is sender
    }
}
