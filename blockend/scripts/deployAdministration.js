let { deploy, networkConfig } = require('./utils')
const fs = require('fs')
const { expect } = require("chai")
const { ethers } = require("hardhat")
const { getSelectors, FacetCutAction } = require('./utilsDiamond.js')

async function deployAdministration(deployerAddress, test = false, integration = false, waitBlocks = 10)
{
    const chainId = hre.network.config.chainId // returns undefined if not local hh network
    const networkName = hre.network.name
    if (test)
    {
        waitBlocks = 1
    }

    if (deployerAddress === undefined || deployerAddress === null)
    {
        accounts = await ethers.getSigners()
        deployerAddress = accounts[0].address // TODO: change (if needed) this address when deploying to mainnet !!!
        console.log(`Using default address`)
    }
    console.log(`Deployer address is ${deployerAddress}`)

    const contractRideCut = await deploy(
        deployerAddress,
        chainId,
        "RideCutAccessControl",
        args = [],
        verify = true,
        test = test
    )
    const contractAdministration = await deploy(
        deployerAddress,
        chainId,
        "RideAdministration",
        args = [deployerAddress, contractRideCut.address],
        verify = true,
        test = test
    )

    FacetNamesNArgs = {
        'RideLoupe': [],
        'RideOwnership': [],
        'RideDriverAssistant': [],
    } // NOTE: for facets, args should all be EMPTY !!!

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

    console.log('Cutting A RideAdministration Diamond 💎')
    const rideCut = await ethers.getContractAt('IRideCut', contractAdministration.address)
    var tx = await rideCut.rideCut(cut, ethers.constants.AddressZero, "0x")
    console.log('tx: ', tx.hash)
    const receipt = await tx.wait(waitBlocks)
    if (!receipt.status)
    {
        throw Error(`RideAdministration Diamond Upgrade Failed: ${tx.hash}`)
    }
    console.log('Completed RideAdministration Diamond Cut')

    console.log(`RideAdministration: ${contractAdministration.address}`)

    return [contractAdministration.address]

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module)
{
    deployAdministration()
        .then(() => process.exit(0))
        .catch(error =>
        {
            console.error(error)
            process.exit(1)
        })
}

exports.deployAdministration = deployAdministration