// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

const { deployRideHub } = require("../../../scripts/deployRideHub.js")

if (parseInt(chainId) === 31337)
{
    describe("RideLibOwnership", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
            rideHubAddress = contractAddresses[0]
            contractRideOwnership = await ethers.getContractAt('RideTestOwnership', rideHubAddress)
        })

        describe("_requireIsContractOwner", function ()
        {
            it("Should allow pass if caller is owner", async function ()
            {
                expect(await contractRideOwnership.requireIsOwner_()).to.equal(true)
            })
            it("Should revert if caller is not owner", async function ()
            {
                contractRideOwnership1 = await ethers.getContractAt('RideTestOwnership', rideHubAddress, accounts[1].address)
                await expect(contractRideOwnership1.requireIsOwner_()).to.revertedWith("not contract owner")
            })
        })

        describe("_contractOwner", function ()
        {
            it("Should return contract owner", async function ()
            {
                expect(await contractRideOwnership.getOwner_()).to.equal(accounts[0].address)
            })
        })

        describe("_setContractOwner", function ()
        {
            it("Should set new owner", async function ()
            {
                var tx = await contractRideOwnership.setOwner_(accounts[1].address)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideOwnership.getOwner_()).to.equal(accounts[1].address)
            })
        })
    })

    describe("RideOwnership", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
            rideHubAddress = contractAddresses[0]
            contractRideOwnership = await ethers.getContractAt('RideTestOwnership', rideHubAddress)
        })

        describe("owner", function ()
        {
            it("Should return contract owner", async function ()
            {
                expect(await contractRideOwnership.owner()).to.equal(accounts[0].address)
            })
        })

        describe("transferOwnership", function ()
        {
            it("Should set new owner", async function ()
            {
                var tx = await contractRideOwnership.transferOwnership(accounts[1].address)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideOwnership.owner()).to.equal(accounts[1].address)
            })
        })
    })
}