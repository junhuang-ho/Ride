// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat");
const chainId = hre.network.config.chainId

if (parseInt(chainId) === 31337) {
    describe("RideControl", function () {
        beforeEach(async function () {
            const RideControl = await ethers.getContractFactory("TestRideControl")
            const rideControl = await RideControl.deploy()
            rideControlContract = await rideControl.deployed()
        })
    })
}