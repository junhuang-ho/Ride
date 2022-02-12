// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

const { deployAdministration } = require("../../../scripts/deployAdministration.js")

if (parseInt(chainId) === 31337)
{
    describe("RideDriverAssistant", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployAdministration(accounts[0].address, true, false)
            administrationAddress = contractAddresses[0]
            contractRideDriverAssistant = await ethers.getContractAt('RideDriverAssistant', administrationAddress)
        })

        describe("getDriverURI", function ()
        {
            it("Should get driver URI", async function ()
            {
                expect((await contractRideDriverAssistant.getDriverURI(accounts[1].address)).toString()).to.equal("")
            })
        })

        describe("approveApplicant", function ()
        {
            it("Should set applicant uri", async function ()
            {
                expect((await contractRideDriverAssistant.getDriverURI(accounts[1].address)).toString()).to.equal("")

                var tx = await contractRideDriverAssistant.approveApplicant(accounts[1].address, "testme123")
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect((await contractRideDriverAssistant.getDriverURI(accounts[1].address)).toString()).to.equal("testme123")
            })
            it("Should revert if uri already set", async function ()
            {
                await expect(contractRideDriverAssistant.approveApplicant(accounts[1].address, "testme456")).to.revertedWith("uri already set")
            })
        })
    })
}