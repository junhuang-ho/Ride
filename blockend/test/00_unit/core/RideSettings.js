// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

const { deployRideHub } = require("../../../scripts/deployRideHub.js")

if (parseInt(chainId) === 31337)
{
    describe("RideLibSettings", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
            rideHubAddress = contractAddresses[0]
            contractRideSettings = await ethers.getContractAt('RideTestSettings', rideHubAddress)
        })

        describe("_setAdministrationAddress", function ()
        {
            it("Should set value", async function ()
            {
                expect(await contractRideSettings.sAdministration_()).to.equal(ethers.constants.AddressZero)

                var tx = await contractRideSettings.setAdministrationAddress_(accounts[1].address)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideSettings.sAdministration_()).to.equal(accounts[1].address)
            })
        })
    })

    describe("RideSettings", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
            rideHubAddress = contractAddresses[0]
            contractRideSettings = await ethers.getContractAt('RideTestSettings', rideHubAddress)
        })

        describe("setAdministrationAddress", function ()
        {
            it("Should set value", async function ()
            {
                expect(await contractRideSettings.sAdministration_()).to.equal(ethers.constants.AddressZero)

                var tx = await contractRideSettings.setAdministrationAddress(accounts[1].address)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideSettings.sAdministration_()).to.equal(accounts[1].address)
            })
        })

        describe("getAdministrationAddress", function ()
        {
            it("Should get value", async function ()
            {
                expect(await contractRideSettings.getAdministrationAddress()).to.equal(accounts[1].address)
            })
        })
    })
}