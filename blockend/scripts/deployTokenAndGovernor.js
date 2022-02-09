let { deploy, networkConfig } = require('./utils')
const fs = require('fs')
const { expect } = require("chai")
const { ethers } = require("hardhat")

async function deployTokenAndGovernor(deployerAddress, test = false, integration = false)
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

    const maxSupply = ethers.utils.parseEther("100000000") // 100 mil - demo purposes // TODO
    const contractRide = await deploy(
        deployerAddress,
        chainId,
        "Ride",
        args = [],
        verify = true,
        test = test
    )

    const minDelay = 1 // in seconds - demo purposes // TODO
    const contractRideTimelock = await deploy(
        deployerAddress,
        chainId,
        "RideTimelock",
        args = [minDelay, [], []], // proposer & executor roles are blank for now, we grant the roles later
        verify = true,
        test = test
    )

    const votingDelay = 1 // blocks // TODO
    const votingPeriod = 10 // blocks // TODO
    const proposalThreshold = 0 // value in terms of voting power // TODO
    const quorumPercentage = 4
    const contractRideGovernor = await deploy(
        deployerAddress,
        chainId,
        "RideGovernor",
        args = [contractRide.address, contractRideTimelock.address, votingDelay, votingPeriod, proposalThreshold, quorumPercentage],
        verify = true,
        test = test
    )

    expect(await contractRideGovernor.votingDelay()).to.equal(votingDelay)
    expect(await contractRideGovernor.votingPeriod()).to.equal(votingPeriod)
    expect(await contractRideGovernor.proposalThreshold()).to.equal(proposalThreshold)

    // lets grant some roles
    roleProposer = await contractRideTimelock.PROPOSER_ROLE()
    roleExecutor = await contractRideTimelock.EXECUTOR_ROLE()
    roleAdmin = await contractRideTimelock.TIMELOCK_ADMIN_ROLE()

    expect(await contractRideTimelock.hasRole(roleAdmin, contractRideTimelock.address)).to.equal(true)
    expect(await contractRideTimelock.hasRole(roleAdmin, deployerAddress)).to.equal(true)

    var tx = await contractRideTimelock.grantRole(roleProposer, contractRideGovernor.address)
    var rcpt = await tx.wait()
    var tx = await contractRideTimelock.grantRole(roleExecutor, ethers.constants.AddressZero) // anyone can execute
    var rcpt = await tx.wait()
    var tx = await contractRideTimelock.revokeRole(roleAdmin, deployerAddress) // TODO: test same as renounceRole
    var rcpt = await tx.wait()
    // contractRideTimelock.renounceRole(roleAdmin, deployerAddress)

    expect(await contractRideTimelock.hasRole(roleAdmin, contractRideTimelock.address)).to.equal(true)
    expect(await contractRideTimelock.hasRole(roleAdmin, deployerAddress)).to.equal(false)
    // await expect(contractRideTimelock.grantRole(roleAdmin, deployerAddress)).to.revertedWith(`AccessControl: account ${deployerAddress} is missing role ${roleAdmin}`)

    console.log(`Ride: ${contractRide.address}`)
    console.log(`RideTimelock: ${contractRideTimelock.address}`)
    console.log(`RideGovernor: ${contractRideGovernor.address}`)

    return [contractRide.address, contractRideTimelock.address, contractRideGovernor.address]
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module)
{
    deployTokenAndGovernor()
        .then(() => process.exit(0))
        .catch(error =>
        {
            console.error(error)
            process.exit(1)
        })
}

exports.deployTokenAndGovernor = deployTokenAndGovernor