// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./libraries/utils/RideLibAccessControl.sol";
import "./libraries/utils/RideLibCutAndLoupe.sol";

import "./facets/utils/RideCut.sol";

contract RideHub {
    constructor(address _owner, address _rideCutFacet) payable {
        RideLibAccessControl._setupRole(
            RideLibAccessControl.DEFAULT_ADMIN_ROLE,
            _owner
        );
        RideLibAccessControl._setupRole(
            RideLibAccessControl.MAINTAINER_ROLE,
            _owner
        );
        RideLibAccessControl._setupRole(
            RideLibAccessControl.STRATEGIST_ROLE,
            _owner
        );
        RideLibAccessControl._setupRole(
            RideLibAccessControl.REVIEWER_ROLE,
            _owner
        );

        // Add the rideCut external function from the RideCut.sol
        RideCut.FacetCut[] memory cut = new RideCut.FacetCut[](1);
        bytes4[] memory functionSelectors = new bytes4[](1);
        functionSelectors[0] = RideCut.rideCut.selector;
        cut[0] = RideCut.FacetCut({
            facetAddress: _rideCutFacet,
            action: RideCut.FacetCutAction.Add,
            functionSelectors: functionSelectors
        });
        RideLibCutAndLoupe.rideCut(cut, address(0), "");
    }

    // Find facet for function that is called and execute the
    // function if a facet is found and return any value.
    fallback() external payable {
        RideLibCutAndLoupe.StorageCutAndLoupe storage s1;
        bytes32 position = RideLibCutAndLoupe.STORAGE_POSITION_CUTANDLOUPE;
        // get diamond storage
        assembly {
            s1.slot := position
        }
        // get facet from function selector
        // address facet = s1.selectorToFacetAndPosition[msg.sig].facetAddress; // diamond-3 implementation
        address facet = address(bytes20(s1.facets[msg.sig])); // diamond-2 implementation
        require(facet != address(0), "RideHub: Function does not exist");
        // Execute external function from facet using delegatecall and return any value.
        assembly {
            // copy function selector and any arguments
            calldatacopy(0, 0, calldatasize())
            // execute function call using the facet
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            // get any return value
            returndatacopy(0, 0, returndatasize())
            // return any return value or error back to the caller
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    receive() external payable {}
}
