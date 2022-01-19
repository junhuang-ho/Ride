// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

const { deployRideHub } = require("../../scripts/deploy.js")

if (parseInt(chainId) === 31337)
{
    describe("RideBadge", function ()
    {
        before(async function ()
        {
            // rideHubAddress = await deployRideHub()
            rideBadge = await ethers.getContractAt("RideBadge", rideHubAddress)
        })

        describe("")
    })
}