// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "../hub/libraries/core/LibRunnerRegistry.sol";
import "../hub/libraries/core/LibCurrencyRegistry.sol";
import "../hub/libraries/core/LibExchange.sol";
import "../hub/libraries/core/LibJobBoard.sol";
import "../hub/libraries/core/LibRater.sol";
import "../hub/libraries/core/LibHiveFactory.sol";

// ways to call fns from another facet (without knowing address)
// 1. use delegatecall: https://eip2535diamonds.substack.com/p/how-to-share-functions-between-facets
// 2. make those external fns internal and move them to library,
//    then make external fns in respective facets that call those internal fns
//    (can import library and just use the fns needed instead of inheriting)

contract HubInitializer0 {
    function init(
        address _nativeToken,
        uint256 _hiveCreationCount,
        uint256 _jobLifespan,
        uint256 _minDisputeDuration,
        uint256 _ratingMin,
        uint256 _ratingMax,
        address[] memory _tokens,
        address[] memory _priceFeeds
    ) external {
        // setup
        LibRunnerRegistry._burnFirstRunnerId();

        LibJobBoard._setJobLifespan(_jobLifespan);
        LibJobBoard._setMinDisputeDuration(_minDisputeDuration);
        LibRater._setRatingBounds(_ratingMin, _ratingMax);

        LibHiveFactory._setHiveCreationCount(_hiveCreationCount);

        // set native token
        LibCurrencyRegistry._setNativeToken(_nativeToken);

        // setup fiat (or crypto)
        bytes32 keyX = LibCurrencyRegistry._registerFiat("USD");

        require(
            _tokens.length == _priceFeeds.length,
            "HubInitializer0: number of tokens and price feeds must equal"
        );
        for (uint256 i = 0; i < _tokens.length; i++) {
            // setup crypto (or fiat)
            bytes32 keyY = LibCurrencyRegistry._registerCrypto(_tokens[i]);
            // setup pair
            LibExchange._addXPerYPriceFeed(keyX, keyY, _priceFeeds[i]);
        }

        // note: dont call _deriveXPerYPriceFeed here, do externally
    }
}
