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

    const FacetNamesNArgs = {
        'RideHoldingV2': [],
    } // NOTE: for facets, args should all be EMPTY !!!
    const cut = []
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
            // cut.push({
            //     facetAddress: contractFacet.address,
            //     action: FacetCutAction.Add,
            //     functionSelectors: getSelectors(contractFacet)
            // })
            cut.push({
                facetAddress: contractFacet.address,
                action: FacetCutAction.Add,
                functionSelectors: getSelectors(contractFacet)
            })
        }
    }


    console.log('Cutting A RideHub Diamond 💎')
    const rideCut = await ethers.getContractAt('IRideCut', "0xfD304E75A5b4f180aD0af8a2aF94aCEa82419eC6")

    const tx = await rideCut.rideCut(cut, ethers.constants.AddressZero, "0x", { gasLimit: 800000 })
    console.log('tx: ', tx.hash)
    const receipt = await tx.wait()
    if (!receipt.status)
    {
        throw Error(`RideHub Diamond Upgrade Failed: ${tx.hash}`)
    }
    console.log('Completed RideHub Diamond Cut')
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