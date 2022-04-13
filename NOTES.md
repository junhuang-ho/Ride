# Some notes for developer reference

# Wallet Standards
### BIP-39
Official: https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki
Blog Guide of how MetaMask does things: https://levelup.gitconnected.com/blockchain-series-how-metamask-creates-accounts-a8971b21a74b
- Few things to note about this blog explanation
- 1. Other accounts (private-public keys) derived by hashing original private key
- 2. Password used to encrypt private key and stored locally. Then user can reveal private key by typing password. I assume same encrpytion for seed phrase
- 3. Does not explain how password is used as "login" to wallet.

### BIP-32 & BIP-44
Used to make wallet more user friendly?: https://vault12.com/securemycrypto/crypto-security-basics/bip39/bip32-and-bip44

BIP-32: https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki

BIP-44: https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki


# read emitted event history?
https://github.com/simolus3/web3dart/blob/a97de62fbe8ccc04c29d3c726484cccd5a9522fe/lib/src/core/filters.dart#L67
web3dart event calling, there is from & to block that can get event history

https://github.com/simolus3/web3dart/blob/10151b108fde49dfa7f4f1a5452e38837639df5f/example/contracts.dart#L70
example of how to use if not already implemented 

or use The Graph:

good blog post explaining how to setup: https://ethereum.org/en/developers/tutorials/the-graph-fixing-web3-data-querying/#the-graph-server

long-term is using The Graph Network (instead of a Hosted Service), which would reduce costs as no need to maintain server & only pay as users query (pay-per-usage).

# Encrypt data before send to blockchain

1. Good tutorial explaining the steps to encrypt data (in JS): https://github.com/pubkey/eth-crypto/blob/master/tutorials/encrypted-message.md
2. Flutter equivalent libraries for the main steps in above tutorial (please double confirm these are the libraries)
    - sign data with sender's private key, similar to web3dart ? : https://pub.dev/packages/web3dart
    - encryption of data using receiver's public key (note some are hashing algo which is not the same as encryption): https://pub.dev/packages/webcrypto   OR    https://pub.dev/packages/encrypt
    - decryption of data on receiver's side and signature verification using same libraries.

# fuse.io wallet_core
fuse.io's wallet core. Its based on web3dart but they made it simple to use? I think mainly to interact with fuse.io stuff not sure if we need that. But they also have The Graph integration which is good for us so maybe can get some ideas from here.

https://pub.dev/packages/wallet_core

# deep-linking for Mobile wallet (dont rmb why not using)
https://pub.dev/packages/walletconnect_dart


# need running ipfs node to view ipfs content? No.
https://stackoverflow.com/a/60936496

.. so means mobile can also read as long can access gateway?

# IPFS Mobile

ipfs docs: https://docs.ipfs.io/
good ipfs learning resource: https://research.protocol.ai/tutorials/resnetlab-on-tour/
ipfs mobile docs: https://github.com/ipfs-shipyard/gomobile-ipfs
ipfs mobile design guidelines: https://jkosem.gitbook.io/ipfs-mobile-guidelines/design/design-strategy


go-mobile: https://medium.com/stack-me-up/meet-the-coolest-tech-marriage-flutter-go-369cf11367c9
https://github.com/golang/go/wiki/Mobile
interesting: https://github.com/ipfs/devgrants/blob/8233f7df4a219122bcf31eaea289d654406e4443/targeted-grants/open-street-map-ipfs.md

# Decentralized Identifier (DID)
https://en.wikipedia.org/wiki/Decentralized_identifier

https://github.com/mustafarefaey/private-stamp

https://www.idena.io/

https://nomios.io/

https://docs.google.com/presentation/d/1HbydOI0w-T_FY23zCACAyHmzDq1ZvyG2tklpPSm6OQQ/edit#slide=id.g5c86d26719_1_22

https://github.com/ipfs/camp

https://ceramic.network/

from: https://docs.ipfs.io/concepts/usage-ideas-examples/#proof-of-ownership

non DID based: https://polygon.technology/polygon-id/

# Interesting Chains

0. Bitcoin (no smart contracts)
0. Ethereum - uses nakamoto concensus mechanism, NCM (smart contracts)

0. Cardano (uses Haskell smart contracts)
0. Polkadot (launch Solidity smart contracts via Moonbeam)
1. Polygon, NCM (can launch solidity smart contracts)
2. Avalanche - uses diff avalanche/snowman concesus mechanism (can launch solidity smart contracts)
3. Near, NCM (on Layer 2, Aurora layer) (launch solidity smart contract via Aurora)
4. The Graph ( mainly for indexing )
5. Filecoin
6. Chainlink
7. Arbitrum
8. Optimium
9. Algorand


# Tokenomics
 1. What makes a token a security? - would be heavily regulated
 - if a token features and markets the potential to make a profit (revenue share or price appreciation) in the future
 - gains its value from external, tradable asset
 
 2. What makes a token a utility?
 - issued by devs to fund the project where the token would be utilized
 - buying into the future use of the service/product
 - not designed as investment (hodl)
 
 3. Which category does RIDE fall under?
 - Utility: used as trip fare, no hodl
 - Utility: by its nature, buying the token to fund the project development
 
 4. All options to distribute token
 - ICO (Initial Coin Offering) - risk of small number of holders with large amount each
 - CEX (a portion of supply reserved for selling): Binance, KuCoin | supports Polygon?
 - DEX (a portion of supply reserved to provide liquidity): Uniswap, Curve Finance | or Polygon support equivalent?
 - Airdrop: if want to, how?
 
 1. dont start governance until RIDE token is fairly distributed?
2. incentive for passengers to pay in RIDE for trips: subsidies passenger, they get discount on fares. so if fare cost USD 5 and 1 RIDE == 1 USD, then trip in RIDE costs 5 RIDE, but passenger pays 4 RIDE, driver receives 5 RIDE (1 RIDE coming from protocol - minted). Maybe dont need to subsidies if the non-fee in (3) is a strong enough incentive.
3. incentive for drivers to accept RIDE for trips: protocol dont charge a fee.
4. applicants that sign up to be drivers get certain RIDE token reward?
5. from (2), say we cap max RIDE supply to 100, and initial mint is 40 where 20 goes to devs and 20 goes to public/exchange, and the remaining 60 use as subsidy for passengers that would be minted on the go.
6. only can start voting once a certain level of fair distribution of RIDE tokens is reached.
7. reward voters with RIDE tokens for participating in governance.
8. burn? - Burning usually relates to operating fees, so that the more an asset is used, the faster its tokens are burned.
9. does it require mass adoption (economies of scales) to function at its best?
10. How to distribute tokens? X% dev team (broken down into few parts where token release linked to roadmap of project, can also do something like after roadmap complete only open governance - must be proper distributed), Y% public/exchanges, Z% reserved as reward over time for abc tasks/interation with dapp.

### references
https://101blockchains.com/tokenomics/
https://medium.datadriveninvestor.com/tokenomics-1c79f2b796e4
https://medium.com/@wmougayar/tokenomics-a-business-guide-to-token-usage-utility-and-value-b19242053416
https://www.finextra.com/blogposting/20638/understanding-tokenomics-the-real-value-of-crypto
https://dcxlearn.com/economics/tokenomics-a-guide-to-utility-business-and-value-2/
https://www.vardhamaninfotech.com/blog/understanding-tokenomics-a-complete-guide/
https://coinmarketcap.com/alexandria/article/what-is-tokenomics
https://timesofindia.indiatimes.com/business/cryptocurrency/blockchain/tokenomics-demand-and-supply-of-cryptocurrencies/articleshow/87273549.cms?from=mdr

# Ride Payment System

 in general, different tokens bridge a bit differently from Ethereum to Polygon. Do RideHub only supports PoS, unless token only has Plasma (like MATIC) or which ever more popular.
 
 Ride Payment System – Summary

1. Currently focus on 1 chain - Polygon. This means Mapping/Bridging concepts do not have to be considered for now.
2. By default, contracts deployed on Polygon are using PoS security model: https://docs.polygon.technology/docs/home/architecture/security-models/
Note that this means RIDE token created on Polygon is by default PoS (unless customized, see link)
3. Which type of security model token should RideHub support? 
Ans: Tokens can be bridged from Ethereum to Polygon via PoS or Plasma security model. The effects of the different security model is mainly seen during withdrawal of Polygon to Ethereum chain. Hence, RideHub can support any type of security model. More on bridging: https://docs.polygon.technology/docs/develop/ethereum-polygon/getting-started

4. Refer to this mapping link to check which tokens that were bridged from Ethereum to Polygon are PoS/Plasma: https://docs.polygon.technology/docs/develop/network-details/mapped-tokens/

5. In future if want to bridge RIDE from Polygon to Ethereum, it is recommended to use PoS if security is not a major concern.

6. What factors influence which token to support by RideHub? Mainly popularity and probability of it being used/utilized rather than being "hodl". https://polygonscan.com/tokens

ERC20 Tokens for RideHub to support:
(chain native token)
1. MATIC | Plasma | https://polygonscan.com/address/0x0000000000000000000000000000000000001010

(stable tokens)
2. USDT | PoS | https://polygonscan.com/address/0xc2132d05d31c914a87c6611c10748aeb04b58e8f
3. USDC | PoS | https://polygonscan.com/address/0x2791bca1f2de4661ed88a30c99a7a9449aa84174
4. UST | check, not bridged?
5. DAI | PoS & Plasma, PoS seems more volume | PoS: https://polygonscan.com/address/0x8f3cf7ad23cd3cadbd9735aff958023239c6a063 | Plasma: https://polygonscan.com/address/0x84000b263080BC37D1DD73A29D92794A6CF1564e

(other tokens)
6. wETH | PoS & Plasma, PoS seems more volume | PoS: https://polygonscan.com/address/0x7ceb23fd6bc0add59e62ac25578270cff1b9f619 | Plasma: https://polygonscan.com/address/0x8cc8538d60901d19692F5ba22684732Bc28F54A3
7. wBTC | PoS | https://polygonscan.com/address/0x1bfd67037b42cf73acf2047067bd4f2c47d9bfd6

(RideHub native)
8. RIDE | PoS | to-be-deployed

A note on RIDE:
1. Should only be deployed on one chain, this case Polygon.
2. If want to use on other chain, go through bridge, probably use PoS security model.
3. Study if need add special functions to Ride.sol if in future want make it mappable/bridgeable to Ethereum: https://docs.polygon.technology/docs/develop/ethereum-polygon/mintable-assets#what-are-the-requirements-to-be-satisfied

Questions:
1. If deploy protocol on one security model, can switch to another?

# Wallet Standard
- EIP712 Message Signing Standard

# Ride - Decentralized Ride-Sharing Platform


concepts: https://drive.google.com/file/d/1X_cKidSHa8rusZzfMmBAWRBCW4Max90r/view?usp=sharing

wallet concept: https://drive.google.com/file/d/1Ck_wjPYNB9G-w7sXwUZpCdCkmnnQFH1T/view?usp=sharing

useful links:

https://rinkeby.etherscan.io/

https://eth-converter.com/

https://www.epochconverter.com/

wallet integrate with Polygon: https://docs.polygon.technology/docs/integrate/quickstart/

EIP1559 way of sending transactions for wallet: https://docs.polygon.technology/docs/develop/eip1559-transactions/how-to-send-eip1559-transactions

Polygon gas station: https://docs.polygon.technology/docs/develop/tools/polygon-gas-station

in addition to google maps, check out 
1. HERE we go (strong competitor to google maps): https://developer.here.com/
2. 2. OpenStreetMaps (open source maps): https://www.openstreetmap.org/#map=7/3.464/101.635

8. Study if need add special functions to Ride.sol if in future want make it mappable/bridgeable to Ethereum: https://docs.polygon.technology/docs/develop/ethereum-polygon/mintable-assets#what-are-the-requirements-to-be-satisfied
Ans: yes need add special fns, and need a child contract in Ethereum as well.
Ans2: this is like ERC20Wrapper?


# RIDE Token Specs

 1. ERC20
 2. ERC20Permit (single transaction)
 3. ERC20Votes (governance compatible)
 4. Non-Upgradable (no proxy, no diamond)
 5. if want extend functionality in future, use ERC20Wrapper
 
Typical way to increase allowance is to call approve more than once. Safe way to do is call approve then increaseAllowance/decreaseAllowance.

### ERC20 notes

Tutorial: https://ethereum.org/en/developers/tutorials/erc20-annotated-code/

1. use SafeERC20 library (we need in case non-compliant tokens like BNB or OMG is used in contract? - see transfer fn: https://etherscan.io/address/0xb8c77482e45f1f44de1745f52c74426c631bdd52#code)

https://docs.openzeppelin.com/contracts/4.x/api/token/erc20#SafeERC20

https://forum.openzeppelin.com/t/safeerc20-tokentimelock-wrappers/396/2

https://forum.openzeppelin.com/t/making-sure-i-understand-how-safeerc20-works/2940

https://blog.goodaudience.com/binance-isnt-erc-20-7645909069a4

2. Permit
https://ethereum.stackexchange.com/questions/110157/why-do-we-grant-access-to-our-funds-instead-of-just-sending-them-to-the-smart-co

https://docs.openzeppelin.com/contracts/4.x/api/token/erc20#ERC20Permit
https://github.com/OpenZeppelin/openzeppelin-contracts/issues/3145
https://forum.openzeppelin.com/t/erc20permit-and-eip-still-in-draft-why/21136
https://soliditydeveloper.com/erc20-permit
https://eips.ethereum.org/EIPS/eip-2612
https://github.com/ethereum/EIPs/issues/2613
https://eips.ethereum.org/EIPS/eip-712

# ERC777

 1. default operator would be RideHub contract address
 
 2. for current scope, does NOT need to use authorizeOperator as currently RIDE only affiliated with RideHub.
 
3. Note On Gas Consumption
Dapps and wallets SHOULD first estimate the gas required when sending, minting, or burning tokens —using `eth_estimateGas` —to avoid running out of gas during the transaction.

4. for "deposit" into RideHub
- externally, "send" [YES]
- externally, "operatorSend" [x] (functionally the same as "send", might as well use send)
- implemented within RideHub fn, "send" [x] (from == RideHub, as to also RideHub, so just sending funds from RideHub to RideHub, no use)
- implemented within RideHub fn, "operatorSend" [x] (functionally the same as external "send", might as well use "send"), (would fail if ppl revoke RideHub as operator, but then whats the point?)

5. for "withdraw" from RideHub
- externally "send" & "operatorSend" [x] (holder always caller, cannot withdraw anything from RideHub)
- implemented within RideHub fn, "send" [YES]
- implemented within RideHub fn, "operatorSend" [x] (functionally, no different from implemented within RideHub fn, "send")

# Diamond Pattern

[Do I Need To Do Anything Besides Standard Deployment Of Diamond? - DINTDABSDOD?] 

1. DiamondLoupeFacet.sol
 - all functions for purpose of analyzing a Diamond. Usually used in explorer/scanning tools like The Loupe.
 - DINTDABSDOD? No.
 
 2. DiamondCutFacet.sol
 -  contains only an external "shell" fn of diamondCut of which, implementation in LibDiamond.sol
  - DINTDABSDOD? No. Unless making immutable Diamond, then use remove fn to remove DiamondCutFacet.sol itself.
  
  3. Diamond.sol
  - the constructor sets contract (Diamond.sol) owner.. AND manually adds "initial" facets. By default, adds DiamondCutFacet.sol because without this facet, cannot add other facets dynamically after Diamond deployment. Note can add other facets via constructor as well, but best practice to add after (dynamically).
  - fallback fn to call facets fn (actively used during production).
  - can receive base coin via receive fn
  - DINTDABSDOD? No. Only use THIS address with facet's abi during production.
  
  4. DiamondInit.sol - init stuff on every cut through the main contract address (delegateCall). If called externally (not through main contract's delegateCall), the states it changes wont register on main contract.
  
  5. OwnershipFacet.sol
  - sets contract (Diamond.sol) owner AND returns current owner of contract
   - DINTDABSDOD? Currently is like onlyOwner, Need edit for multisig/governance ownership. See PieDAO? Ask?
  
  6. LibDiamond.sol
  - contains Diamond.sol 's struct Diamond Storage (DS) and fns
  - contains basic owner / set owner fns
  - contains diamond cut fns
  - contains initialization fns
  - basically Standard Deployment Of Diamond related contract fns (as above)
     - DINTDABSDOD? No. (Unless want use to store custom facet's fn in a DS pattern? - research needed on DS pattern, note facet fns can sit in their own contracts like normal)
  
     
NOTE: any facet that is not cut into the diamond (main) can NOT affect the diamond's facet state variable. Example, `diamondInit.init`

## gas efficiency tests

1. internal getter fn vs no internal getter fn (concept applies beyond internal fns)
```
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

library TestLib {
    bytes32 constant STORAGE_POSITION_BADGE = keccak256("ds.badge");

    struct StorageBadge {
        mapping(uint256 => uint256) badgeToBadgeMaxScore;
    }

    function _storageBadge() internal pure returns (StorageBadge storage s) {
        bytes32 position = STORAGE_POSITION_BADGE;
        assembly {
            s.slot := position
        }
    }

    function _setBadgeToBadgeMaxScore(uint256 _index, uint256 _value) internal {
        StorageBadge storage s1 = _storageBadge();
        s1.badgeToBadgeMaxScore[_index] = _value;
    }

    function _getBadgeMaxScore(uint256 _badge) internal view returns (uint256) {
        return _storageBadge().badgeToBadgeMaxScore[_badge];
    }
}

contract Test1 {
    function getBadgeMaxScore1(uint256 _badge) external view returns (uint256) {
        return TestLib._storageBadge().badgeToBadgeMaxScore[_badge];
    }
}

contract Test2 {
    function getBadgeMaxScore1(uint256 _badge) external view returns (uint256) {
        return TestLib._getBadgeMaxScore(_badge);
    }
}
// Deploy Test1: 135019 gas
// Deploy Test2: 138901 gas

// Execute Test1: 24004 gas
// Execute Test2: 24047 gas
```
