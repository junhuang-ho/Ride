// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./libraries/utils/RideLibAllianceAccessControl.sol";
import "./libraries/utils/RideLibAllianceCutAndLoupe.sol";

import "./facets/utils/RideAllianceCut.sol";

contract RideAllianceFactory {
    constructor(address _multisig, address _rideCutFacet) payable {
        RideLibAllianceAccessControl._setupRole(
            RideLibAllianceAccessControl.DEFAULT_ADMIN_ROLE,
            _multisig
        ); // required for initial deployment setup
        RideLibAllianceAccessControl._setupRole(
            RideLibAllianceAccessControl.MAINTAINER_ROLE,
            _multisig
        ); // required for initial deployment setup
        RideLibAllianceAccessControl._setupRole(
            RideLibAllianceAccessControl.STRATEGIST_ROLE,
            _multisig
        ); // required for initial deployment setup

        // Add the rideCut external function from the RideAllianceCut.sol
        RideAllianceCut.FacetCut[] memory cut = new RideAllianceCut.FacetCut[](
            1
        );
        bytes4[] memory functionSelectors = new bytes4[](1);
        functionSelectors[0] = RideAllianceCut.rideCut.selector;
        cut[0] = RideAllianceCut.FacetCut({
            facetAddress: _rideCutFacet,
            action: RideAllianceCut.FacetCutAction.Add,
            functionSelectors: functionSelectors
        });
        RideLibAllianceCutAndLoupe.rideCut(cut, address(0), "");
    }

    // Find facet for function that is called and execute the
    // function if a facet is found and return any value.
    fallback() external payable {
        RideLibAllianceCutAndLoupe.StorageAllianceCutAndLoupe storage s1;
        bytes32 position = RideLibAllianceCutAndLoupe
            .STORAGE_POSITION_ALLIANCECUTANDLOUPE;
        // get diamond storage
        assembly {
            s1.slot := position
        }
        // get facet from function selector
        // address facet = s1.selectorToFacetAndPosition[msg.sig].facetAddress; // diamond-3 implementation
        address facet = address(bytes20(s1.facets[msg.sig])); // diamond-2 implementation
        require(facet != address(0), "RideFactory: Function does not exist");
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
