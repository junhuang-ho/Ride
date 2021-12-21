//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./RideCost.sol";

// import "hardhat/console.sol";

/// @title Base contract for Passenger and Driver of RideHub
contract RideBase is RideCost, ReentrancyGuard, Initializable {
    ERC20 public token;

    bool public initialized;

    mapping(address => uint256) public addressToDeposit;
    mapping(address => bool) public addressToActive;
    mapping(address => uint256) public addressToBanEndTimestamp;

    /**
     * lifetime cumulative values of drivers
     */
    struct DriverReputation {
        uint256 id;
        string uri;
        uint256 maxMetresPerTrip;
        uint256 metresTravelled;
        uint256 countStart;
        uint256 countEnd;
        uint256 totalRating;
        uint256 countRating;
    }
    mapping(address => DriverReputation) public addressToDriverReputation;

    /**
     * @dev if a ticket exists (details not 0) in tixIdToTicket, then it is considered active
     *
     * @custom:TODO: Make it loopable so that can list to drivers?
     */
    struct Ticket {
        address passenger;
        address driver;
        uint256 badge;
        bool strict;
        uint256 metres;
        uint256 fare;
        bool tripStart;
        uint256 forceEndTimestamp;
    }
    mapping(bytes32 => Ticket) internal tixIdToTicket;

    struct EndDetails {
        address driver;
        bool reached;
    }
    mapping(bytes32 => EndDetails) internal tixToEndDetails;

    event InitializedRideBase(address token, address deployer);
    event TokensDeposited(address sender, uint256 amount);
    event TokensRemoved(address sender, uint256 amount);
    event TokensTransferred(
        bytes32 indexed tixId,
        uint256 amount,
        address decrease,
        address increase
    );
    event TicketCleared(bytes32 indexed tixId);
    event UserBanned(address banned, uint256 until);
    event ApplicantApproved(address applicant);

    /**
     * @dev order of execution of modifiers when used in functions is left to right
     */

    modifier notDriver() {
        require(
            addressToDriverReputation[msg.sender].id == 0,
            "caller is driver"
        );
        _;
    }

    modifier notActive() {
        require(!addressToActive[msg.sender], "caller is active");
        _;
    }

    modifier driverMatchTixDriver(bytes32 _tixId, address _driver) {
        require(
            _driver == tixIdToTicket[_tixId].driver,
            "driver not match tix driver"
        );
        _;
    }

    modifier tripNotStart(bytes32 _tixId) {
        require(!tixIdToTicket[_tixId].tripStart, "trip already started");
        _;
    }

    modifier tripInProgress(bytes32 _tixId) {
        require(tixIdToTicket[_tixId].tripStart, "trip not started");
        _;
    }

    modifier forceEndAllowed(bytes32 _tixId) {
        require(
            block.timestamp > tixIdToTicket[_tixId].forceEndTimestamp,
            "too early"
        );
        _;
    }

    modifier notBan() {
        require(
            block.timestamp >= addressToBanEndTimestamp[msg.sender],
            "still banned"
        );
        _;
    }

    modifier initializedRideBase() {
        require(initialized, "not init RideBase");
        _;
    }

    /**
     * initializeRideBase initializes parameters of RideHub
     *
     * @dev to be run instantly after deployment
     *
     * @param _tokenAddress     | Ride token address
     * @param _badgesMaxScores  | Refer RideBadge.sol
     * @param _requestFee       | Refer RideCost.sol
     * @param _baseFare         | Refer RideCost.sol
     * @param _costPerMetre     | Refer RideCost.sol
     * @param _costPerMinute    | Refer RideCost.sol
     * @param _banDuration      | Refer RideCost.sol
     *
     * @custom:event InitializedRideBase
     */
    function initializeRideBase(
        address _tokenAddress,
        uint256[] memory _badgesMaxScores,
        uint256 _requestFee,
        uint256 _baseFare,
        uint256[] memory _costPerMetre,
        uint256 _costPerMinute,
        uint256 _banDuration
    ) external onlyOwner initializer {
        token = ERC20(_tokenAddress);
        setBadgesMaxScores(_badgesMaxScores);
        setRequestFee(_requestFee);
        setBaseFare(_baseFare);
        setCostPerMetre(_costPerMetre);
        setCostPerMinute(_costPerMinute);
        setBanDuration(_banDuration);

        initialized = true;

        emit InitializedRideBase(_tokenAddress, msg.sender);
    }

    /**
     * placeDeposit allows users to deposit token into RideHub contract
     *
     * @dev call token contract's "approve" first
     *
     * @param _amount | unit in token
     *
     * @custom:event TokensDeposited
     */
    function placeDeposit(uint256 _amount) external initializedRideBase {
        require(_amount > 0, "0 amount");
        require(
            token.allowance(msg.sender, address(this)) >= _amount,
            "check token allowance"
        );
        bool sent = token.transferFrom(msg.sender, address(this), _amount);
        require(sent, "tx failed");

        addressToDeposit[msg.sender] += _amount;

        emit TokensDeposited(msg.sender, _amount);
    }

    /**
     * removeDeposit allows users to remove token from RideHub contract
     *
     * @custom:event TokensRemoved
     */
    function removeDeposit() external notActive nonReentrant {
        uint256 amount = addressToDeposit[msg.sender];
        require(amount > 0, "deposit empty");
        require(
            token.balanceOf(address(this)) >= amount,
            "contract insufficient funds"
        );
        addressToDeposit[msg.sender] = 0;
        bool sent = token.transfer(msg.sender, amount);
        // bool sent = token.transferFrom(address(this), msg.sender, amount);
        require(sent, "tx failed");

        emit TokensRemoved(msg.sender, amount);
    }

    //////////////////////////////////////////////////////////////////////////////////
    ///// ---------------------------------------------------------------------- /////
    ///// ------------------------- internal functions ------------------------- /////
    ///// ---------------------------------------------------------------------- /////
    //////////////////////////////////////////////////////////////////////////////////

    /**
     * _transfer rebalances _amount tokens from one address to another
     *
     * @param _tixId Ticket ID
     * @param _amount | unit in token
     * @param _decrease address to decrease tokens by
     * @param _increase address to increase tokens by
     *
     * @custom:event TokensTransferred
     */
    function _transfer(
        bytes32 _tixId,
        uint256 _amount,
        address _decrease,
        address _increase
    ) internal {
        addressToDeposit[_decrease] -= _amount;
        addressToDeposit[_increase] += _amount;

        emit TokensTransferred(_tixId, _amount, _decrease, _increase);
    }

    /**
     * _cleanUp clears ticket information and set active status of users to false
     *
     * @param _tixId Ticket ID
     * @param _passenger passenger's address
     * @param _driver driver's address
     *
     * @custom:event TicketCleared
     */
    function _cleanUp(
        bytes32 _tixId,
        address _passenger,
        address _driver
    ) internal {
        delete tixIdToTicket[_tixId];
        delete tixToEndDetails[_tixId];
        addressToActive[_passenger] = false;
        addressToActive[_driver] = false;

        emit TicketCleared(_tixId);
    }

    /**
     * _temporaryBan user
     *
     * @param _address address to be banned
     *
     * @custom:event UserBanned
     */
    function _temporaryBan(address _address) internal {
        uint256 banUntil = block.timestamp + banDuration;
        addressToBanEndTimestamp[_address] = banUntil;

        emit UserBanned(_address, banUntil);
    }

    //////////////////////////////////////////////////////////////////////////////////
    ///// ---------------------------------------------------------------------- /////
    ///// --------------------------- admin functions -------------------------- /////
    ///// ---------------------------------------------------------------------- /////
    //////////////////////////////////////////////////////////////////////////////////

    /// @custom:TODO: backup fn if pax or driver didn't force end

    /**
     * passBackgroundCheck of driver applicants
     *
     * @param _driver applicant
     * @param _uri information of applicant
     *
     * @custom:event ApplicantApproved
     */
    function passBackgroundCheck(address _driver, string memory _uri)
        external
        onlyOwner
        initializedRideBase
    {
        require(
            bytes(addressToDriverReputation[_driver].uri).length == 0,
            "uri already set"
        );
        addressToDriverReputation[_driver].uri = _uri;

        emit ApplicantApproved(_driver);
    }
}
