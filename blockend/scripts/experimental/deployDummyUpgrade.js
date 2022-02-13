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

    dummyDiamondAddress = "0x93af348D9a809211D6dddC497DB1446959E36bd8" // TODO: Alter this !!! based on deployDummyDiamond.js
    diamondCutFacet = await ethers.getContractAt('IRideCut', dummyDiamondAddress, deployerAddress)
    diamondLoupeFacet = await ethers.getContractAt('RideLoupe', dummyDiamondAddress, deployerAddress)
    ownershipFacet = await ethers.getContractAt('RideOwnership', dummyDiamondAddress, deployerAddress)

    // // Add facet with all of its fn selectors

    // const contractBox3 = await deploy(
    //     deployerAddress,
    //     chainId,
    //     "Box3",
    //     args = [],
    //     verify = true,
    //     test = true
    // )

    // const selectors = getSelectors(contractBox3)

    // var tx = await diamondCutFacet.rideCut(
    //     [{
    //         facetAddress: contractBox3.address,
    //         action: FacetCutAction.Add,
    //         functionSelectors: selectors
    //     }],
    //     ethers.constants.AddressZero, '0x', { gasLimit: 800000 })

    // // Add facet with some of its fn selectors

    // const contractBox3 = await deploy(
    //     deployerAddress,
    //     chainId,
    //     "Box3",
    //     args = [],
    //     verify = true,
    //     test = true
    // )

    // const selectors = getSelectors(contractBox3).get(['store3(uint256)'])

    // var tx = await diamondCutFacet.rideCut(
    //     [{
    //         facetAddress: contractBox3.address,
    //         action: FacetCutAction.Add,
    //         functionSelectors: selectors
    //     }],
    //     ethers.constants.AddressZero, '0x', { gasLimit: 800000 })

    // // Add fn selector to existing facet - fn selector was already defined with facet deployment
    // // note: NOT realistic case

    // const contractBox3 = await deploy(
    //     deployerAddress,
    //     chainId,
    //     "Box3",
    //     args = [],
    //     verify = true,
    //     test = true
    // )

    // const selectors = getSelectors(contractBox3).get(['retrieve3()'])

    // var tx = await diamondCutFacet.rideCut(
    //     [{
    //         facetAddress: contractBox3.address,
    //         action: FacetCutAction.Add,
    //         functionSelectors: selectors
    //     }],
    //     ethers.constants.AddressZero, '0x', { gasLimit: 800000 })

    // // Add fn selector to existing facet - fn selector was NOT defined with facet deployment
    // // note: realistic case, but NOT possible with diamond cut

    // ??

    // // Remove all fn selector from facet, facet should auto removed as well
    // // note: get fn selectors from RideLoupe
    // // note: facet address must be zero address

    // selectorsFromLoupe = ["0xef1f1973", "0x4b7bec62"] // case specific !!

    // var tx = await diamondCutFacet.rideCut(
    //     [{
    //         facetAddress: ethers.constants.AddressZero, // RMB ZERO ADDRESS
    //         action: FacetCutAction.Remove,
    //         functionSelectors: selectorsFromLoupe
    //     }],
    //     ethers.constants.AddressZero, '0x', { gasLimit: 800000 })

    // // Remove some fn selector from facet, facet should remain
    // // note: get fn selectors from RideLoupe
    // // note: facet address must be zero address

    // selectorsFromLoupe = ["0xc4c38ec5"] // case specific !!

    // var tx = await diamondCutFacet.rideCut(
    //     [{
    //         facetAddress: ethers.constants.AddressZero, // RMB ZERO ADDRESS
    //         action: FacetCutAction.Remove,
    //         functionSelectors: selectorsFromLoupe
    //     }],
    //     ethers.constants.AddressZero, '0x', { gasLimit: 800000 })

    // // Replace - dodgy, dont use 

    // const contractBox3 = await deploy(
    //     deployerAddress,
    //     chainId,
    //     "Box3",
    //     args = [],
    //     verify = true,
    //     test = true
    // )

    // const selectors = getSelectors(contractBox3).get(['retrieve3()'])

    // var tx = await diamondCutFacet.rideCut(
    //     [{
    //         facetAddress: contractBox3.address,
    //         action: FacetCutAction.Replace,
    //         functionSelectors: selectors
    //     }],
    //     ethers.constants.AddressZero, '0x', { gasLimit: 800000 })

    // // Remove + Add in one cut

    // selectorsFromLoupe = ["0x4b7bec62", "0xef1f1973"] // case specific !!

    // const contractBox3 = await deploy(
    //     deployerAddress,
    //     chainId,
    //     "Box3",
    //     args = [],
    //     verify = true,
    //     test = true
    // )

    // const selectors = getSelectors(contractBox3)

    // var tx = await diamondCutFacet.rideCut(
    //     [
    //         {
    //             facetAddress: ethers.constants.AddressZero, // RMB ZERO ADDRESS
    //             action: FacetCutAction.Remove,
    //             functionSelectors: selectorsFromLoupe
    //         },
    //         {
    //             facetAddress: contractBox3.address,
    //             action: FacetCutAction.Add,
    //             functionSelectors: selectors
    //         }
    //     ],
    //     ethers.constants.AddressZero, '0x', { gasLimit: 800000 })

    // //////// Ending

    // var rcpt = await tx.wait()
    // if (!rcpt.status)
    // {
    //     throw Error(`Diamond upgrade failed: ${tx.hash}`)
    // }
    // console.log(`Diamond Upgraded`)
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