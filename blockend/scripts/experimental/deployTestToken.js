let { deploy, networkConfig } = require('../utils')
const fs = require('fs')
const { expect } = require("chai")
const { ethers } = require("hardhat")

async function deployTestToken(deployerAddress, test = false, integration = false)
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

    const contractRide = await deploy(
        deployerAddress,
        chainId,
        "Ride",
        args = [],
        verify = true,
        test = test
    )

    const contractUsingERC20s = await deploy(
        deployerAddress,
        chainId,
        "UsingERC20s",
        args = [contractRide.address],
        verify = true,
        test = test
    )

    console.log(`Ride: ${contractRide.address}`)
    console.log(`UsingERC20s: ${contractUsingERC20s.address}`)

    return [contractRide.address, contractUsingERC20s.address]
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module)
{
    deployTestToken()
        .then(() => process.exit(0))
        .catch(error =>
        {
            console.error(error)
            process.exit(1)
        })
}

exports.deployTestToken = deployTestToken