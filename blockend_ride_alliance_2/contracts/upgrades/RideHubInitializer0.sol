// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "../hub/libraries/core/RideLibFee.sol";
import "../hub/libraries/core/RideLibRater.sol";
import "../hub/libraries/core/RideLibDriverDetails.sol";
import "../hub/libraries/core/RideLibDriver.sol";
import "../hub/libraries/core/RideLibTicket.sol";
import "../hub/libraries/core/RideLibPenalty.sol";
import "../hub/libraries/core/RideLibHolding.sol";
import "../hub/libraries/core/RideLibExchange.sol";
import "../hub/libraries/core/RideLibPassenger.sol";
import "../hub/libraries/core/RideLibDriverRegistry.sol";
import "../hub/libraries/core/RideLibCurrencyRegistry.sol";
import "../hub/libraries/utils/RideLibCutAndLoupe.sol";

// It is exapected that this contract is customized if you want to deploy your diamond
// with data from a deployment script. Use the init function to initialize state variables
// of your diamond. Add parameters to the init funciton if you need to.

// ways to call fns from another facet (without knowing address)
// 1. use delegatecall: https://eip2535diamonds.substack.com/p/how-to-share-functions-between-facets
// 2. make those external fns internal and move them to library,
//    then make external fns in respective facets that call those internal fns
//    (can import library and just use the fns needed instead of inheriting)

contract RideHubInitializer0 {
    function init(
        uint256 _ratingMin,
        uint256 _ratingMax,
        address[] memory _tokens,
        address[] memory _priceFeeds
    ) external {
        // setup
        RideLibRater._setRatingBounds(_ratingMin, _ratingMax);
        RideLibDriverRegistry._burnFirstDriverId();

        // setup fiat (or crypto)
        bytes32 keyX = RideLibCurrencyRegistry._registerFiat("USD");

        require(
            _tokens.length == _priceFeeds.length,
            "RideInitializer0: Number of tokens and price feeds must equal"
        );
        for (uint256 i = 0; i < _tokens.length; i++) {
            // setup crypto (or fiat)
            bytes32 keyY = RideLibCurrencyRegistry._registerCrypto(_tokens[i]);
            // setup pair
            RideLibExchange._addXPerYPriceFeed(keyX, keyY, _priceFeeds[i]);
        }

        // note: for frontend, call RideCurrencyRegistry.setupFiatWithFee/setupCryptoWithFee --> RideExchange.addXPerYPriceFeed
    }
}
