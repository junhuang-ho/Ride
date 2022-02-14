let { deploy, networkConfig } = require('../utils')
const fs = require('fs')
const { expect } = require("chai")
const { ethers } = require("hardhat")

async function testWait(deployerAddress, test = false, integration = false)
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

    // const contractTestERC20 = await deploy(
    //     deployerAddress,
    //     chainId,
    //     "TestERC20",
    //     args = [69, [], []],
    //     verify = true,
    //     test = test
    // )
    // console.log("TestERC20:", contractTestERC20.address)

    const minDelay = 1 // in seconds - demo purposes // TODO
    const contractRideTimelock = await deploy(
        deployerAddress,
        chainId,
        "RideTimelock",
        args = [minDelay, [], []], // proposer & executor roles are blank for now, we grant the roles later
        verify = true,
        test = test
    )
    console.log("RideTimelock:", contractRideTimelock.address)

    console.log("END")

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module)
{
    testWait()
        .then(() => process.exit(0))
        .catch(error =>
        {
            console.error(error)
            process.exit(1)
        })
}

exports.testWait = testWait