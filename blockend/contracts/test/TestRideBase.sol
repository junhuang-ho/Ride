//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "../ride/RideBase.sol";

contract TestRideBase is RideBase {
    function tixIdToTicket_(bytes32 _tixId)
        public
        view
        returns (Ticket memory)
    {
        return tixIdToTicket[_tixId];
    }

    function tixToDriverEnd_(bytes32 _tixId)
        public
        view
        returns (DriverEnd memory)
    {
        return tixToDriverEnd[_tixId];
    }

    function notDriver_() public view notDriver returns (bool) {
        return true;
    }

    function notActive_() public view notActive returns (bool) {
        return true;
    }

    function driverMatchTixDriver_(address _driver)
        public
        view
        driverMatchTixDriver(_driver)
        returns (bool)
    {
        return true;
    }

    function tripNotStart_() public view tripNotStart returns (bool) {
        return true;
    }

    function tripInProgress_() public view tripInProgress returns (bool) {
        return true;
    }

    function forceEndAllowed_() public view forceEndAllowed returns (bool) {
        return true;
    }

    function notBan_() public view notBan returns (bool) {
        return true;
    }

    function initializedRideBase_()
        public
        view
        initializedRideBase
        returns (bool)
    {
        return true;
    }

    function _transfer_(
        bytes32 _tixId,
        uint256 _amount,
        address _decrease,
        address _increase
    ) public {
        _transfer(_tixId, _amount, _decrease, _increase);
    }

    function _cleanUp_(
        bytes32 _tixId,
        address _passenger,
        address _driver
    ) public {
        _cleanUp(_tixId, _passenger, _driver);
    }

    function _temporaryBan_(address _address) public {
        _temporaryBan(_address);
    }

    function setter_initialized(bool _bool) public {
        initialized = _bool;
    }

    function setter_addressToDeposit(address _addr, uint256 _uint256) public {
        addressToDeposit[_addr] = _uint256;
    }

    function setter_addressToTixId(address _addr, bytes32 _tixId) public {
        addressToTixId[_addr] = _tixId;
    }

    function setter_addressToBanEndTimestamp(address _addr, uint256 _uint256)
        public
    {
        addressToBanEndTimestamp[_addr] = _uint256;
    }

    function setter_addressToDriverReputation(
        address _addr,
        uint256 _id,
        string memory _uri,
        uint256 _maxMetresPerTrip,
        uint256 _metresTravelled,
        uint256 _countStart,
        uint256 _countEnd,
        uint256 _totalRating,
        uint256 _countRating
    ) public {
        addressToDriverReputation[_addr] = DriverReputation({
            id: _id,
            uri: _uri,
            maxMetresPerTrip: _maxMetresPerTrip,
            metresTravelled: _metresTravelled,
            countStart: _countStart,
            countEnd: _countEnd,
            totalRating: _totalRating,
            countRating: _countRating
        });
    }

    function setter_tixIdToTicket(
        bytes32 _tixId,
        address _passenger,
        address _driver,
        uint256 _badge,
        bool _strict,
        uint256 _metres,
        uint256 _fare,
        bool _tripStart,
        uint256 _forceEndTimestamp
    ) public {
        tixIdToTicket[_tixId] = Ticket({
            passenger: _passenger,
            driver: _driver,
            badge: _badge,
            strict: _strict,
            metres: _metres,
            fare: _fare,
            tripStart: _tripStart,
            forceEndTimestamp: _forceEndTimestamp
        });
    }

    function setter_tixToDriverEnd(
        bytes32 _tixId,
        address _driver,
        bool _reached
    ) public {
        tixToDriverEnd[_tixId] = DriverEnd({
            driver: _driver,
            reached: _reached
        });
    }
}
