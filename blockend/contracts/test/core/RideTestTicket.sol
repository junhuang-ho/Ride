//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideTicket} from "../../facets/core/RideTicket.sol";
import {RideLibTicket} from "../../libraries/core/RideLibTicket.sol";

contract RideTestTicket is RideTicket {
    function sUserToTixId_(address _user) external view returns (bytes32) {
        return RideLibTicket._storageTicket().userToTixId[_user];
    }

    function sTixIdToTicket_(bytes32 _tixId)
        external
        view
        returns (RideLibTicket.Ticket memory)
    {
        return RideLibTicket._storageTicket().tixIdToTicket[_tixId];
    }

    function sTixToDriverEnd_(bytes32 _tixId)
        external
        view
        returns (RideLibTicket.DriverEnd memory)
    {
        return RideLibTicket._storageTicket().tixToDriverEnd[_tixId];
    }

    function ssUserToTixId_(address _user, bytes32 _tixId) external {
        RideLibTicket._storageTicket().userToTixId[_user] = _tixId;
    }

    function ssTixIdToTicket_(
        bytes32 _tixId,
        address _passenger,
        address _driver,
        uint256 _badge,
        bool _strict,
        uint256 _metres,
        bytes32 _keyLocal,
        bytes32 _keyPay,
        uint256 _cancellationFee,
        uint256 _fare,
        bool _tripStart
    ) external {
        RideLibTicket.StorageTicket storage s1 = RideLibTicket._storageTicket();
        s1.tixIdToTicket[_tixId].passenger = _passenger;
        s1.tixIdToTicket[_tixId].driver = _driver;
        s1.tixIdToTicket[_tixId].badge = _badge;
        s1.tixIdToTicket[_tixId].strict = _strict;
        s1.tixIdToTicket[_tixId].metres = _metres;
        s1.tixIdToTicket[_tixId].keyLocal = _keyLocal;
        s1.tixIdToTicket[_tixId].keyPay = _keyPay;
        s1.tixIdToTicket[_tixId].cancellationFee = _cancellationFee;
        s1.tixIdToTicket[_tixId].fare = _fare;
        s1.tixIdToTicket[_tixId].tripStart = _tripStart;
    }

    function ssTixIdToTicket_2(bytes32 _tixId, uint256 _forceEndTimestamp)
        external
    {
        RideLibTicket.StorageTicket storage s1 = RideLibTicket._storageTicket();
        s1.tixIdToTicket[_tixId].forceEndTimestamp = _forceEndTimestamp;
    }

    function ssTixToDriverEnd_(
        bytes32 _tixId,
        address _driver,
        bool _reached
    ) external {
        RideLibTicket._storageTicket().tixToDriverEnd[_tixId] = RideLibTicket
            .DriverEnd({driver: _driver, reached: _reached});
    }

    function requireNotActive_() external view returns (bool) {
        RideLibTicket._requireNotActive();
        return true;
    }

    function cleanUp_(
        bytes32 _tixId,
        address _passenger,
        address _driver
    ) external {
        RideLibTicket._cleanUp(_tixId, _passenger, _driver);
    }

    // getUserToTixId(address _user) returns (bytes32);
    // getTixIdToTicket(bytes32 _tixId) returns (RideLibTicket.Ticket memory);
    // getTixToDriverEnd(bytes32 _tixId) returns (RideLibTicket.DriverEnd memory);
}
