// // note: unit testing in local network
// // npx hardhat coverage --testfiles "test/*.js"

// const { expect } = require("chai")
// const { ethers } = require("hardhat")
// const hre = require("hardhat")
// const chainId = hre.network.config.chainId

// const { deployRideHub } = require("../../scripts/deployRideHub.js")

// if (parseInt(chainId) === 31337)
// {
//     describe("RideHub", function ()
//     {
//         before(async function ()
//         {
//             accounts = await ethers.getSigners()
//             admin = accounts[0].address
//             driver = accounts[1].address
//             passenger = accounts[2].address

//             contractAddresses = await deployRideHub(admin, true, true)
//             rideHubAddress = contractAddresses[0]
//             mockV3AggregatorAddress = contractAddresses[1]

//             // contracts required to be called by Admin for setup and others
//             contractRideBadge = await ethers.getContractAt('RideTestBadge', rideHubAddress, admin)
//             contractRidePenalty = await ethers.getContractAt('RideTestPenalty', rideHubAddress, admin)
//             contractRidePenalty = await ethers.getContractAt('RideTestPenalty', rideHubAddress, admin)

//             // contracts required to be called by Driver
//             contractRideDriver = await ethers.getContractAt('RideTestDriver', rideHubAddress, driver)
//             contractRideDriverRegistry = await ethers.getContractAt('RideTestDriverRegistry', rideHubAddress, driver)

//             // contracts required to be called by Passenger
//             contractRidePassenger = await ethers.getContractAt('RideTestPassenger', rideHubAddress, passenger)
//         })

//         describe("", function ()
//         {
//             it("Should", async function ()
//             {
//             })
//         })
//     })
// }