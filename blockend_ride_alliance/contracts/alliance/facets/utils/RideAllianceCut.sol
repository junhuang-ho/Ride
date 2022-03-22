// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "../../libraries/utils/RideLibAllianceCutAndLoupe.sol";
import "../../libraries/utils/RideLibAllianceAccessControl.sol";

contract RideAllianceCut {
    enum FacetCutAction {
        Add,
        Replace,
        Remove
    }

    struct FacetCut {
        address facetAddress;
        FacetCutAction action;
        bytes4[] functionSelectors;
    } // just a data structure, not storing anything

    event Cut(FacetCut[] _rideCut, address _init, bytes _calldata);

    /// @notice Add/replace/remove any number of functions and optionally execute
    ///         a function with delegatecall
    /// @param _rideCut Contains the facet addresses and function selectors
    /// @param _init The address of the contract or facet to execute _calldata
    /// @param _calldata A function call, including function selector and arguments
    ///                  _calldata is executed with delegatecall on _init
    function rideCut(
        FacetCut[] calldata _rideCut,
        address _init,
        bytes calldata _calldata
    ) external {
        RideLibAllianceAccessControl._requireOnlyRole(
            RideLibAllianceAccessControl.MAINTAINER_ROLE
        );

        RideLibAllianceCutAndLoupe.StorageAllianceCutAndLoupe
            storage ds = RideLibAllianceCutAndLoupe
                ._storageAllianceCutAndLoupe();
        uint256 originalSelectorCount = ds.selectorCount;
        uint256 selectorCount = originalSelectorCount;
        bytes32 selectorSlot;
        // Check if last selector slot is not full
        // "selectorCount & 7" is a gas efficient modulo by eight "selectorCount % 8"
        if (selectorCount & 7 > 0) {
            // get last selectorSlot
            // "selectorCount >> 3" is a gas efficient division by 8 "selectorCount / 8"
            selectorSlot = ds.selectorSlots[selectorCount >> 3];
        }
        // loop through diamond cut
        for (uint256 facetIndex; facetIndex < _rideCut.length; facetIndex++) {
            (selectorCount, selectorSlot) = RideLibAllianceCutAndLoupe
                ._addReplaceRemoveFacetSelectors(
                    selectorCount,
                    selectorSlot,
                    _rideCut[facetIndex].facetAddress,
                    _rideCut[facetIndex].action,
                    _rideCut[facetIndex].functionSelectors
                );
        }
        if (selectorCount != originalSelectorCount) {
            ds.selectorCount = uint16(selectorCount);
        }
        // If last selector slot is not full
        // "selectorCount & 7" is a gas efficient modulo by eight "selectorCount % 8"
        if (selectorCount & 7 > 0) {
            // "selectorCount >> 3" is a gas efficient division by 8 "selectorCount / 8"
            ds.selectorSlots[selectorCount >> 3] = selectorSlot;
        }
        emit Cut(_rideCut, _init, _calldata);
        RideLibAllianceCutAndLoupe._initializeRideCut(_init, _calldata);
    }
}
