let { deploy, networkConfig } = require('./utils')
const fs = require('fs')
const { expect } = require("chai")
const { ethers } = require("hardhat")

const { deployTokenAndGovernor } = require("./deployTokenAndGovernor.js")
const { deployRideHub } = require("./deployRideHub.js")

async function deployEndToEnd(deployerAddress, test = false, integration = false)
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

    addressesTokenNGovernor = await deployTokenAndGovernor(deployerAddress, false, false)
    addressRideToken = addressesTokenNGovernor[0]
    addressRideTimelock = addressesTokenNGovernor[1]
    addressRideGovernor = addressesTokenNGovernor[2]

    addressesRideHub = await deployRideHub(deployerAddress, false, false)
    addressRideHub = addressesRideHub[0]

    contractRideToken = await ethers.getContractAt("Ride", addressRideToken, deployerAddress)
    contractRideTimelock = await ethers.getContractAt("RideTimelock", addressRideTimelock, deployerAddress)
    contractRideGovernor = await ethers.getContractAt("RideGovernor", addressRideGovernor, deployerAddress)
    contractOwnership = await ethers.getContractAt("RideOwnership", addressRideHub, deployerAddress)
    contractCurrencyRegistry = await ethers.getContractAt("RideCurrencyRegistry", addressRideHub, deployerAddress)

    // initialization steps TODO

    // 1. tokenomics strategy (if not done already in Ride contract)

    ////////////////////////////////////////////////////////////////////////////////////////
    ///// ---------------------------------------------------------------------------- /////
    ///// ----------- TODO: initialize RIDE tokenomics strategy, if needed ----------- /////
    ///// ---------------------------------------------------------------------------- /////
    ////////////////////////////////////////////////////////////////////////////////////////
    /// example:
    /// const supply = ethers.utils.parseEther("100000000") // 100 mil - demo purposes // TODO
    /// var tx = await contractRideToken.mint(deployerAddress, supply)
    /// var rcpt = tx.wait()

    /// var tx = await contractRideToken.delegate(deployerAddress) // self delegate
    /// var rcpt = await tx.wait()

    if (test)
    {
        supply = 100
        person1 = accounts[1].address
        person2 = accounts[2].address
        person3 = accounts[3].address
        person4 = accounts[4].address
        person5 = accounts[5].address
        var tx = await contractRideToken.mint(deployerAddress, supply)
        var rcpt = tx.wait()
        var tx = await contractRideToken.mint(person1, supply)
        var rcpt = tx.wait()
        var tx = await contractRideToken.mint(person2, supply)
        var rcpt = tx.wait()
        var tx = await contractRideToken.mint(person3, supply)
        var rcpt = tx.wait()
        var tx = await contractRideToken.mint(person4, supply)
        var rcpt = tx.wait()
        var tx = await contractRideToken.mint(person5, supply)
        var rcpt = tx.wait()
    }
    ///// ---------------------------------------------------------------------------- /////
    ////////////////////////////////////////////////////////////////////////////////////////

    // 2. setup RideHub to support RIDE token (besides step to add priceFeed - or maybe token would be deployed sometime before RideHub, in that case would have priceFeed)

    var tx = await contractCurrencyRegistry.registerCrypto(addressRideToken)
    var rcpt = await tx.wait()

    // 3. transfer RideHub ownership to governor

    expect(await contractOwnership.owner()).to.equal(deployerAddress)
    var tx = await contractOwnership.transferOwnership(addressRideTimelock)
    var rcpt = tx.wait()
    expect(await contractOwnership.owner()).to.equal(addressRideTimelock)

    return [addressRideToken, addressRideTimelock, addressRideGovernor, addressRideHub]
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module)
{
    deployEndToEnd()
        .then(() => process.exit(0))
        .catch(error =>
        {
            console.error(error)
            process.exit(1)
        })
}

exports.deployEndToEnd = deployEndToEnd