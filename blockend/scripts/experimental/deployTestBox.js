let { deploy, networkConfig } = require('../utils')
const fs = require('fs')
const { expect } = require("chai")
const { ethers } = require("hardhat")

async function deployTestBox(deployerAddress, test = false, integration = false)
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

    const contractBox = await deploy(
        deployerAddress,
        chainId,
        "Box",
        args = [],
        verify = true,
        test = test
    )

    const contractBox2 = await deploy(
        deployerAddress,
        chainId,
        "Box2",
        args = [],
        verify = true,
        test = test
    )

    console.log(`Box: ${contractBox.address}`)
    console.log(`Box2: ${contractBox2.address}`)

    return [contractBox.address, contractBox2.address]
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module)
{
    deployTestBox()
        .then(() => process.exit(0))
        .catch(error =>
        {
            console.error(error)
            process.exit(1)
        })
}

exports.deployTestBox = deployTestBox