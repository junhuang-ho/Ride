// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IRidePenalty {
    function setBanDuration(uint256 _banDuration) external;

    function getBanDuration() external view returns (uint256);

    function getAddressToBanEndTimestamp(address _address)
        external
        view
        returns (uint256);
}
