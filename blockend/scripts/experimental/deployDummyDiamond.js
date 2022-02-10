let { deploy, networkConfig } = require('../utils')
const fs = require('fs')
const { expect } = require("chai")
const { ethers } = require("hardhat")
const { getSelectors, FacetCutAction } = require('../utilsDiamond.js')

async function deployDummyDiamond(deployerAddress, test = false, integration = false)
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

    FacetNamesNArgs = {
        'RideLoupe': [],
        'RideOwnership': [],
        'Greeter': [],
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

    console.log('Cutting A Dummy Diamond 💎')
    const rideCut = await ethers.getContractAt('IRideCut', contractRideHub.address)
    var tx = await rideCut.rideCut(cut, ethers.constants.AddressZero, "0x")
    var rcpt = await tx.wait()
    if (!rcpt.status)
    {
        throw Error(`Dummy Diamond Upgrade Failed: ${tx.hash}`)
    }
    console.log('Completed RideHub Diamond Cut')

    console.log("DummyDiamond:", contractRideHub.address)

    return [contractRideHub.address]
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module)
{
    deployDummyDiamond()
        .then(() => process.exit(0))
        .catch(error =>
        {
            console.error(error)
            process.exit(1)
        })
}

exports.deployDummyDiamond = deployDummyDiamond