let { deploy, networkConfig } = require('./utils')
const fs = require('fs')
const { expect } = require("chai")
const { ethers } = require("hardhat")
const { getSelectors, FacetCutAction } = require('./utilsDiamond.js')

async function deployRideHub(deployerAddress, test = false, integration = false)
{
    const chainId = hre.network.config.chainId // returns undefined if not local hh network
    const networkName = hre.network.name

    if (deployerAddress === undefined || deployerAddress === null)
    {
        accounts = await ethers.getSigners()
        deployerAddress = accounts[0].address // TODO: change (if needed) this address when deploying to mainnet !!!
        console.log(`Using default address`)
    }
    console.log(`Deployer address is ${deployerAddress}`)

    if (test)
    {
        if (parseInt(chainId) === 31337)
        {
            console.log("unit/integration TEST MODE")

            contractWETH9 = await deploy(
                deployerAddress,
                chainId,
                "WETH9",
                args = [],
                verify = true,
                test = test
            )

            const decimals = 18
            const initialAns = "2000000000000000000"
            contractMockV3Aggregator = await deploy(
                deployerAddress,
                chainId,
                "MockV3Aggregator",
                args = [decimals, initialAns],
                verify = true,
                test = test
            )
        }
    }

    const contractRideCut = await deploy(
        deployerAddress,
        chainId,
        "RideCut",
        args = [],
        verify = true,
        test = test
    )
    const contractRideHub = await deploy(
        deployerAddress,
        chainId,
        "RideHub",
        args = [deployerAddress, contractRideCut.address],
        verify = true,
        test = test
    )
    const contractRideInitializer = await deploy(
        deployerAddress,
        chainId,
        "RideInitializer0",
        args = [],
        verify = true,
        test = test
    )

    if (test)
    {
        FacetNamesNArgs = {
            'RideLoupe': [],
            'RideTestOwnership': [],
            'RideTestBadge': [],
            'RideTestCurrencyRegistry': [],
            'RideTestFee': [],
            'RideTestExchange': [],
            'RideTestHolding': [],
            'RideTestPenalty': [],
            'RideTestTicket': [],
            'RideTestPassenger': [],
            'RideTestRater': [],
            'RideTestDriver': [],
            'RideTestDriverRegistry': [],
            'RideTestSettings': [],
        } // NOTE: for facets, args should all be EMPTY !!!
    } else
    {
        FacetNamesNArgs = {
            'RideLoupe': [],
            'RideOwnership': [],
            'RideBadge': [],
            'RideCurrencyRegistry': [],
            'RideFee': [],
            'RideExchange': [],
            'RideHolding': [],
            'RidePenalty': [],
            'RideTicket': [],
            'RidePassenger': [],
            'RideRater': [],
            'RideDriver': [],
            'RideDriverRegistry': [],
            'RideSettings': [],
        } // NOTE: for facets, args should all be EMPTY !!!
    }

    const cut = []
    for (const FacetName in FacetNamesNArgs)
    {
        if (FacetNamesNArgs.hasOwnProperty(FacetName))
        {
            expect(FacetNamesNArgs[FacetName] === []) // must be empty args
            const contractFacet = await deploy(
                deployerAddress,
                chainId,
                FacetName,
                args = FacetNamesNArgs[FacetName],
                verify = true,
                test = test
            )
            cut.push({
                facetAddress: contractFacet.address,
                action: FacetCutAction.Add,
                functionSelectors: getSelectors(contractFacet)
            })
        }
    }

    // set init params

    // note:
    // some perspective for badgesMaxScore
    // say 1 day work 10 hours and can travel 50_000 metres per hour (Subang to KL)
    // In 1 day, distance = 500_000 metres
    // In 1 year, distance = 180_000_000 metres
    // In 5 years, distance = 900_000_000 metres

    // Newbie   ~ up to 1 day's work, 10 * 50_000 * 1 = 500_000
    // Bronze   ~ up to 1 month's work, 10 * 50_000 * 30 = 15_000_000
    // Silver   ~ up to 6 month's work, 10 * 50_000 * 30 * 6 = 90_000_000
    // Gold     ~ up to 1 year's work, 10 * 50_000 * 30 * 12 = 180_000_000
    // Platinum ~ up to 3 year's work, 10 * 50_000 * 30 * 12 * 3 = 540_000_000
    // Veteran  ~ more than 3 year's work

    const badgesMaxScore = ["500000", "15000000", "90000000", "180000000", "540000000"] // metres
    const banDuration = "604800" // 7 days // https://www.epochconverter.com/
    const forceEndDelay = "86400"; // 1 day
    const ratingMin = "1"
    const ratingMax = "5"
    const cancellationFeeUSD = ethers.utils.parseEther("5") // $5 for random search on Uber: Central Park --> Brooklyn https://www.uber.com/global/en/price-estimate/
    const baseFeeUSD = ethers.utils.parseEther("3") // $8 for random search on Uber: Central Park --> Brooklyn https://www.uber.com/global/en/price-estimate/
    const costPerMinuteUSD = ethers.utils.parseEther("0.0001") // $0 for random search on Uber: Central Park --> Brooklyn https://www.uber.com/global/en/price-estimate/
    const badgesCostPerMetreUSD =
        [
            ethers.utils.parseEther("0.0010"),
            ethers.utils.parseEther("0.0012"),
            ethers.utils.parseEther("0.0014"),
            ethers.utils.parseEther("0.0016"),
            ethers.utils.parseEther("0.0018"),
            ethers.utils.parseEther("0.0020")
        ] // $2.51 per mile for random search on Uber: Central Park --> Brooklyn https://www.uber.com/global/en/price-estimate/

    if (parseInt(chainId) !== 31337)
    {
        if (parseInt(chainId) === 137)
        {
            tokens =
                [
                    // networkConfig[chainId]["tokenWMATIC"],
                    networkConfig[chainId]["tokenPoSUSDT"],
                    networkConfig[chainId]["tokenPoSUSDC"],
                    networkConfig[chainId]["tokenPoSUST"],
                    networkConfig[chainId]["tokenPoSDAI"],
                    networkConfig[chainId]["tokenPoSWETH"],
                    networkConfig[chainId]["tokenPoSWBTC"],
                ]
            priceFeeds =
                [
                    // networkConfig[chainId]["priceFeedMATICUSD"],
                    networkConfig[chainId]["priceFeedUSDTUSD"],
                    networkConfig[chainId]["priceFeedUSDCUSD"],
                    networkConfig[chainId]["priceFeedUSTUSD"],
                    networkConfig[chainId]["priceFeedDAIUSD"],
                    networkConfig[chainId]["priceFeedETHUSD"],
                    networkConfig[chainId]["priceFeedBTCUSD"], // TODO: or use WBTC/USD one?
                ]
        } else if (parseInt(chainId) === 80001)
        {
            tokens =
                [
                    networkConfig[chainId]["tokenWMATIC"],
                    networkConfig[chainId]["tokenPoSWETH"],
                ]
            priceFeeds =
                [
                    networkConfig[chainId]["priceFeedMATICUSD"],
                    networkConfig[chainId]["priceFeedETHUSD"],
                ]
        } else if (parseInt(chainId) === 43114)
        {
            tokens =
                [
                    // networkConfig[chainId]["tokenWAVAX"],
                    networkConfig[chainId]["tokenUSDTe"],
                    networkConfig[chainId]["tokenUSDCe"],
                    networkConfig[chainId]["tokenUSTe"],
                    networkConfig[chainId]["tokenDATe"],
                    networkConfig[chainId]["tokenWETHe"],
                    networkConfig[chainId]["tokenWBTCe"],
                ]
            priceFeeds =
                [
                    // networkConfig[chainId]["priceFeedAVAXUSD"],
                    networkConfig[chainId]["priceFeedUSDTUSD"],
                    networkConfig[chainId]["priceFeedUSDCUSD"],
                    networkConfig[chainId]["priceFeedUSTUSD"],
                    networkConfig[chainId]["priceFeedDAIUSD"],
                    networkConfig[chainId]["priceFeedETHUSD"],
                    networkConfig[chainId]["priceFeedBTCUSD"], // TODO: or use WBTC/USD one?
                ]
        } else if (parseInt(chainId) === 43113)
        {
            throw new Error(`TODO: add Fuji data !!!!!!!!!!!!! find from Fuji bridge`)
            tokens =
                [
                    // networkConfig[chainId]["tokenWAVAX"],
                    networkConfig[chainId]["tokenUSDTe"],
                    networkConfig[chainId]["tokenWETHe"],
                    networkConfig[chainId]["tokenWBTCe"],
                ]
            priceFeeds =
                [
                    // networkConfig[chainId]["priceFeedAVAXUSD"],
                    networkConfig[chainId]["priceFeedUSDTUSD"],
                    networkConfig[chainId]["priceFeedETHUSD"],
                    networkConfig[chainId]["priceFeedBTCUSD"], // TODO: or use WBTC/USD one?
                ]
        } else if (parseInt(chainId) === 4 || parseInt(chainId) === 42)
        {
            tokens =
                [
                    networkConfig[chainId]["tokenWETH"],
                ]
            priceFeeds =
                [
                    networkConfig[chainId]["priceFeedETHUSD"],
                ]
        } else
        {
            throw new Error(`WARNING: Supported chains are either Ethereum or Polygon, detected: ${chainId}`)
        }
    } else
    {
        if (test)
        {
            tokens = [contractWETH9.address]
            priceFeeds = [contractMockV3Aggregator.address]
        } else
        {
            tokens = ["0xc778417e063141139fce010982780140aa0cd5ab"] // dummy as long not zero address
            priceFeeds = ["0x8A753747A1Fa494EC906cE90E9f37563A8AF630e"] // dummy as long not zero address
        }
    }

    initParams = [
        badgesMaxScore,
        banDuration,
        forceEndDelay,
        ratingMin,
        ratingMax,
        cancellationFeeUSD,
        baseFeeUSD,
        costPerMinuteUSD,
        badgesCostPerMetreUSD,
        tokens,
        priceFeeds
    ]
    let functionCall = contractRideInitializer.interface.encodeFunctionData("init", initParams)

    console.log('Cutting A RideHub Diamond 💎')
    const rideCut = await ethers.getContractAt('IRideCut', contractRideHub.address)
    // call to init function
    if (!test)
    {
        var tx = await rideCut.rideCut(cut, contractRideInitializer.address, functionCall) // ethers.constants.AddressZero, "0x"
    } else
    {
        if (!integration)
        {
            console.log("UNIT test")
            var tx = await rideCut.rideCut(cut, ethers.constants.AddressZero, "0x")
        } else
        {
            console.log("INTEGRATION test")
            var tx = await rideCut.rideCut(cut, contractRideInitializer.address, functionCall) // ethers.constants.AddressZero, "0x"
        }
    }

    console.log('tx: ', tx.hash)
    const receipt = await tx.wait()
    if (!receipt.status)
    {
        throw Error(`RideHub Diamond Upgrade Failed: ${tx.hash}`)
    }
    console.log('Completed RideHub Diamond Cut')

    console.log(`RideHub: ${contractRideHub.address}`)

    if (test)
    {
        if (parseInt(chainId) === 31337)
        {
            return [contractRideHub.address, priceFeeds[0], tokens[0]]
        } else if (parseInt(chainId) === 4 || parseInt(chainId) === 42)
        {
            return [contractRideHub.address, priceFeeds[0], tokens[0]]
        } else if (parseInt(chainId) === 80001)
        {
            return [contractRideHub.address, priceFeeds, tokens]
        } else
        {
            throw new Error(`something wrong when returning deploy data, detected chain: ${chainId}`)
        }
    } else
    {
        return [contractRideHub.address, ethers.constants.AddressZero, ethers.constants.AddressZero]
    }

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module)
{
    deployRideHub()
        .then(() => process.exit(0))
        .catch(error =>
        {
            console.error(error)
            process.exit(1)
        })
}

exports.deployRideHub = deployRideHub