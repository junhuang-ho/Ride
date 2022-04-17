//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../templates/HiveGovernanceToken.sol";
import "../../templates/HiveTimelock.sol";
import "../../templates/HiveGovernor.sol";
import "./LibHiveGovernanceTokenMachine.sol";
import "./LibHiveTimelockMachine.sol";
import "./LibHiveGovernorMachine.sol";

import "../utils/LibAccessControl.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

library LibHiveFactory {
    bytes32 constant STORAGE_POSITION_HIVEFACTORY = keccak256("ds.hivefactory");

    struct StorageHiveFactory {
        uint256 count;
        mapping(bytes32 => address) hiveKeyToHiveGovernanceToken;
        mapping(bytes32 => address) hiveKeyToHiveTimelock;
        mapping(bytes32 => address) hiveKeyToHiveGovernor;
        uint256 hiveCreationCount;
        uint256 hiveCurrentOrder; // to be reset after every deployment
        bytes32 currentSalt;
        bytes32 currentHiveKey;
    }

    function _storageHiveFactory()
        internal
        pure
        returns (StorageHiveFactory storage s)
    {
        bytes32 position = STORAGE_POSITION_HIVEFACTORY;
        assembly {
            s.slot := position
        }
    }

    function _requireCorrectOrder(uint256 _order) internal view {
        require(
            _storageHiveFactory().hiveCurrentOrder == _order,
            "LibHiveFactory: wrong hive creation order"
        );
    }

    function _incrementOrder() internal {
        _storageHiveFactory().hiveCurrentOrder += 1;
    }

    event HiveCreationCountSet(address indexed sender, uint256 count);

    function _setHiveCreationCount(uint256 _count) internal {
        LibAccessControl._requireOnlyRole(LibAccessControl.STRATEGIST_ROLE);

        _storageHiveFactory().hiveCreationCount = _count;

        emit HiveCreationCountSet(msg.sender, _count);
    }

    function _resetHiveOrder() internal {
        _storageHiveFactory().hiveCurrentOrder = 0;
    }

    function _getSalt(string memory _name, string memory _symbol)
        internal
        view
        returns (bytes32)
    {
        return keccak256(abi.encode(_getCount(), _name, _symbol));
    }

    function _getHiveKey(string memory _name, string memory _symbol)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(_name, _symbol));
    }

    function _getCount() internal view returns (uint256) {
        return _storageHiveFactory().count;
    }

    // function _getAddress(bytes memory bytecode, bytes32 _salt)
    //     public
    //     view
    //     returns (address)
    // {
    //     bytes32 hash = keccak256(
    //         abi.encodePacked(
    //             bytes1(0xff),
    //             address(this),
    //             _salt,
    //             keccak256(bytecode)
    //         )
    //     );

    //     return address(uint160(uint256(hash))); // NOTE: cast last 20 bytes of hash to address
    // }
}
