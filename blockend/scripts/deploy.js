let { deploy } = require('./utils')
const fs = require('fs')
const { expect } = require("chai")
const { ethers } = require("hardhat")
const { getSelectors, FacetCutAction } = require('./utilsDiamond.js')

async function deployRideHub()
{
    const chainId = hre.network.config.chainId // returns undefined if not local hh network
    const networkName = hre.network.name
    const accounts = await ethers.getSigners()
    const contractOwner = accounts[0]

    const maxSupply = ethers.utils.parseEther("100000000") // 100 mil - demo purposes
    const contractRide = await deploy(
        chainId,
        "Ride",
        args = [maxSupply],
        verify = true
    ) // note: currently NOT part of RideHub (Diamond)

    // const contractRideCut = await deploy(
    //     chainId,
    //     "RideCut",
    //     args = [],
    //     verify = true
    // )
    // const contractRideHub = await deploy(
    //     chainId,
    //     "RideHub",
    //     args = [contractOwner.address, contractRideCut.address],
    //     verify = true
    // )
    // const contractRideInitializer = await deploy(
    //     chainId,
    //     "RideInitializer0",
    //     args = [],
    //     verify = true
    // )

    // const FacetNamesNArgs = {
    //     'RideLoupe': [],
    //     'RideOwnership': [],
    //     'RideBadge': [],
    //     'RideCurrencyRegistry': [],
    //     'RideFee': [],
    //     'RideExchange': [],
    //     'RideHolding': [],
    //     'RidePenalty': [],
    //     'RideTicket': [],
    //     'RidePassenger': [],
    //     'RideRater': [],
    //     'RideDriver': [],
    //     'RideDriverRegistry': [],
    // } // NOTE: for facets, args should all be EMPTY !!!
    // const cut = []
    // for (const FacetName in FacetNamesNArgs)
    // {
    //     if (FacetNamesNArgs.hasOwnProperty(FacetName))
    //     {
    //         expect(FacetNamesNArgs[FacetName] === []) // must be empty args
    //         const contractFacet = await deploy(
    //             chainId,
    //             FacetName,
    //             args = FacetNamesNArgs[FacetName],
    //             verify = true
    //         )
    //         cut.push({
    //             facetAddress: contractFacet.address,
    //             action: FacetCutAction.Add,
    //             functionSelectors: getSelectors(contractFacet)
    //         })
    //     }
    // }

    // // set init params

    // // note:
    // // some perspective for badgesMaxScore
    // // say 1 day work 10 hours and can travel 50_000 metres per hour (Subang to KL)
    // // In 1 day, distance = 500_000 metres
    // // In 1 year, distance = 180_000_000 metres
    // // In 5 years, distance = 900_000_000 metres

    // // Newbie   ~ up to 1 day's work, 10 * 50_000 * 1 = 500_000
    // // Bronze   ~ up to 1 month's work, 10 * 50_000 * 30 = 15_000_000
    // // Silver   ~ up to 6 month's work, 10 * 50_000 * 30 * 6 = 90_000_000
    // // Gold     ~ up to 1 year's work, 10 * 50_000 * 30 * 12 = 180_000_000
    // // Platinum ~ up to 3 year's work, 10 * 50_000 * 30 * 12 * 3 = 540_000_000
    // // Veteran  ~ more than 3 year's work

    // const tokenAddress = contractRide.address
    // const badgesMaxScore = ["500000", "15000000", "90000000", "180000000", "540000000"]
    // const requestFee = ethers.utils.parseEther("5")
    // const baseFee = ethers.utils.parseEther("2")
    // const costPerMinute = ethers.utils.parseEther("0.15")
    // const badgesCostPerMetre =
    //     [
    //         ethers.utils.parseEther("0.10"),
    //         ethers.utils.parseEther("0.20"),
    //         ethers.utils.parseEther("0.30"),
    //         ethers.utils.parseEther("0.40"),
    //         ethers.utils.parseEther("0.50"),
    //         ethers.utils.parseEther("0.60")
    //     ]
    // const banDuration = "604800" // 7 days // https://www.epochconverter.com/
    // const ratingMin = "1"
    // const ratingMax = "5"

    // const initParams = [
    //     badgesMaxScore,
    //     // requestFee,
    //     // baseFee,
    //     // costPerMinute,
    //     // badgesCostPerMetre,
    //     banDuration,
    //     ratingMin,
    //     ratingMax
    // ]

    // console.log('Cutting A RideHub Diamond 💎')
    // const rideCut = await ethers.getContractAt('IRideCut', contractRideHub.address)
    // // call to init function
    // let functionCall = contractRideInitializer.interface.encodeFunctionData("init", initParams)
    // const tx = await rideCut.rideCut(cut, contractRideInitializer.address, functionCall)
    // console.log('tx: ', tx.hash)
    // const receipt = await tx.wait()
    // if (!receipt.status)
    // {
    //     throw Error(`RideHub Diamond Upgrade Failed: ${tx.hash}`)
    // }
    // console.log('Completed RideHub Diamond Cut')

    // console.log(`Ride: ${contractRide.address}`)
    // console.log(`RideHub: ${contractRideHub.address}`)

    // return contractRideHub.address
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
