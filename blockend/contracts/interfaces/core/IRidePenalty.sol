// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IRidePenalty {
    event SetBanDuration(address indexed sender, uint256 _banDuration);

    function setBanDuration(uint256 _banDuration) external;

    function getBanDuration() external view returns (uint256);

    function getAddressToBanEndTimestamp(address _address)
        external
        view
        returns (uint256);

    event UserBanned(address indexed banned, uint256 from, uint256 to);
}
