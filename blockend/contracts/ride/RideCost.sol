//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "./RideBadge.sol";

/// @title Sets RideHub's costs
contract RideCost is RideBadge {
    uint256 public requestFee;
    uint256 public baseFare;
    uint256 public costPerMinute;
    uint256 public banDuration;
    mapping(uint256 => uint256) public badgeToCostPerMetre;

    /**
     * setRequestFee sets request fee
     *
     * @param _requestFee | unit in token
     */
    function setRequestFee(uint256 _requestFee) public onlyOwner {
        requestFee = _requestFee; // input format: token in Wei
    }

    /**
     * setBaseFare sets base fare
     *
     * @param _baseFare | unit in token
     */
    function setBaseFare(uint256 _baseFare) public onlyOwner {
        baseFare = _baseFare; // input format: token in Wei
    }

    /**
     * setCostPerMinute sets cost per minute
     *
     * @param _costPerMinute | unit in token
     */
    function setCostPerMinute(uint256 _costPerMinute) public onlyOwner {
        costPerMinute = _costPerMinute; // input format: token in Wei
    }

    /**
     * setBanDuration sets user ban duration
     *
     * @param _banDuration | unit in unix timestamp | https://docs.soliditylang.org/en/v0.8.10/units-and-global-variables.html#time-units
     */
    function setBanDuration(uint256 _banDuration) public onlyOwner {
        banDuration = _banDuration;
    }

    /**
     * setCostPerMetre sets cost per metre
     *
     * @param _costPerMetre | unit in token
     */
    function setCostPerMetre(uint256[] memory _costPerMetre) public onlyOwner {
        require(
            _costPerMetre.length == badgesCount,
            "_costPerMetre.length must be equal Badges"
        );
        for (uint256 i = 0; i < _costPerMetre.length; i++) {
            badgeToCostPerMetre[i] = _costPerMetre[i]; // input format: token in Wei // rounded down
        }
    }
}
