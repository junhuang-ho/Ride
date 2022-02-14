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

    const contractRide = await deploy(
        deployerAddress,
        chainId,
        "Ride",
        args = [],
        verify = true,
        test = test
    )
    console.log("RIDE Token:", contractRide.address)

    expect(await contractRide.owner()).to.equal(deployerAddress)
    console.log("OWNER:", await contractRide.owner())
    var tx = await contractRide.transferOwnership(accounts[2].address)
    console.log("OWNER:", await contractRide.owner())
    var rcpt = tx.wait(6)
    console.log("OWNER:", await contractRide.owner())
    expect(await contractRide.owner()).to.equal(accounts[2].address)

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