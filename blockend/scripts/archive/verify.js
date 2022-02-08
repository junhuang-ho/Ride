let { deploy } = require('./utils')
const fs = require('fs')
const { expect } = require("chai")
const { ethers } = require("hardhat")
const { getSelectors, FacetCutAction } = require('./utilsDiamond.js')

async function verifyContract()
{
    const chainId = hre.network.config.chainId // returns undefined if not local hh network
    const networkName = hre.network.name
    const accounts = await ethers.getSigners()
    const contractOwner = accounts[0]

    const FacetNamesNArgs = {
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
    }
    for (const FacetName in FacetNamesNArgs)
    {
        if (FacetNamesNArgs.hasOwnProperty(FacetName))
        {
            expect(FacetNamesNArgs[FacetName] === []) // must be empty args
            const contractFacet = await deploy(
                chainId,
                FacetName,
                args = FacetNamesNArgs[FacetName],
                verify = true
            )
        }
    }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module)
{
    verifyContract()
        .then(() => process.exit(0))
        .catch(error =>
        {
            console.error(error)
            process.exit(1)
        })
}

exports.verifyContract = verifyContract