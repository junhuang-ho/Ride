// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

const { deployRideHub } = require("../../../scripts/deployRideHub.js")

if (parseInt(chainId) === 31337)
{
    describe("RideLibPassenger", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
            rideHubAddress = contractAddresses[0]
            contractRideDriver = await ethers.getContractAt('RideTestDriver', rideHubAddress)
            contractRidePassenger = await ethers.getContractAt('RideTestPassenger', rideHubAddress)
            contractRideTestTicket = await ethers.getContractAt('RideTestTicket', rideHubAddress)
            contractRideBadge = await ethers.getContractAt('RideTestBadge', rideHubAddress)

            tixId = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("test123"))
            keyLocal = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("USD"))
            keyPay = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("ETH"))

            var tx = await contractRideTestTicket.ssTixIdToTicket_(
                tixId, accounts[0].address, accounts[1].address, 0, false, 3,
                keyLocal, keyPay, 4, 2, false
            )
            var rcpt = await tx.wait()

            var tx = await contractRideTestTicket.ssTixIdToTicket_2(
                tixId, 1234
            )
            var rcpt = await tx.wait()

            var tx = await contractRideTestTicket.ssUserToTixId_(
                accounts[0].address, tixId
            )
            var rcpt = await tx.wait()
        })

        describe("_requirePaxMatchTixPax", function ()
        {
            it("Should allow pass if pax match pax ticket", async function ()
            {
                expect(await contractRidePassenger.requirePaxMatchTixPax_()).to.equal(true)
            })
            it("Should revert if pax not match pax ticket", async function ()
            {
                contractRidePassenger2 = await ethers.getContractAt('RideTestPassenger', rideHubAddress, accounts[1].address)
                await expect(contractRidePassenger2.requirePaxMatchTixPax_()).to.revertedWith("pax not match tix pax")
            })
        })

        describe("_requireTripNotStart", function ()
        {
            it("Should allow pass if trip not start", async function ()
            {
                expect(await contractRidePassenger.requireTripNotStart_()).to.equal(true)
            })
            it("Should revert if trip started", async function ()
            {
                var tx = await contractRideTestTicket.ssTixIdToTicket_(
                    tixId, accounts[0].address, accounts[1].address, 0, false, 3,
                    keyLocal, keyPay, 4, 2, true
                )
                var rcpt = await tx.wait()

                await expect(contractRidePassenger.requireTripNotStart_()).to.revertedWith("trip already started")
            })
        })

        describe("_requireTripInProgress", function ()
        {
            it("Should allow pass if trip in progress", async function ()
            {
                expect(await contractRidePassenger.requireTripInProgress_()).to.equal(true)
            })
            it("Should revert if trip not started", async function ()
            {
                var tx = await contractRideTestTicket.ssTixIdToTicket_(
                    tixId, accounts[0].address, accounts[1].address, 0, false, 3,
                    keyLocal, keyPay, 4, 2, false
                )
                var rcpt = await tx.wait()

                await expect(contractRidePassenger.requireTripInProgress_()).to.revertedWith("trip not started")
            })
        })

        describe("_requireForceEndAllowed", function ()
        {
            it("Should allow pass if current time more than timestamp", async function ()
            {
                expect(await contractRidePassenger.requireForceEndAllowed_()).to.equal(true)
            })
            it("Should revert if current time not more than timestamp", async function ()
            {
                var tx = await contractRideTestTicket.ssTixIdToTicket_2(
                    tixId, 2208988800
                )
                var rcpt = await tx.wait()

                await expect(contractRidePassenger.requireForceEndAllowed_()).to.revertedWith("too early")
            })
        })
    })

    describe("RidePassenger", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            contractAddresses = await deployRideHub(accounts[0].address, true, false)
            rideHubAddress = contractAddresses[0]
            mockV3AggregatorAddress = contractAddresses[1]
            contractRideDriver = await ethers.getContractAt('RideTestDriver', rideHubAddress)
            contractRidePassenger = await ethers.getContractAt('RideTestPassenger', rideHubAddress)
            contractRideTicket = await ethers.getContractAt('RideTestTicket', rideHubAddress)
            contractRideBadge = await ethers.getContractAt('RideTestBadge', rideHubAddress)
            contractRideExchange = await ethers.getContractAt('RideTestExchange', rideHubAddress)
            contractRideRater = await ethers.getContractAt('RideTestRater', rideHubAddress)
            contractRideHolding = await ethers.getContractAt('RideTestHolding', rideHubAddress)
            contractRideFee = await ethers.getContractAt('RideTestFee', rideHubAddress)
            contractRideCurrencyRegistry = await ethers.getContractAt('RideTestCurrencyRegistry', rideHubAddress)

            tixId = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("test123"))
            keyLocal = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("USD"))
            keyPay = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("ETH"))
            priceFeed = "0x8A753747A1Fa494EC906cE90E9f37563A8AF630e" // address
            badges = [10000, 100000, 500000, 1000000, 2000000]

            var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToSupported_(
                keyLocal, true
            )
            var rcpt = await tx.wait()
            var tx = await contractRideCurrencyRegistry.ssCurrencyKeyToSupported_(
                keyPay, true
            )
            var rcpt = await tx.wait()

            var tx = await contractRideExchange.ssXToYToXPerYPriceFeed_(
                keyLocal, keyPay, mockV3AggregatorAddress
            )
            var rcpt = await tx.wait()

            var tx = await contractRideRater.setRatingBounds_(1, 5)
            var rcpt = await tx.wait()

            var tx = await contractRideFee.setCancellationFee_(keyLocal, 5)
            var rcpt = await tx.wait()
            var tx = await contractRideFee.setBaseFee_(keyLocal, 5)
            var rcpt = await tx.wait()
            var tx = await contractRideFee.setCostPerMinute_(keyLocal, 5)
            var rcpt = await tx.wait()
            var tx = await contractRideFee.setCostPerMetre_(keyLocal, [3, 4, 5, 6, 7, 8])
            var rcpt = await tx.wait()
        })

        describe("requestTicket", function ()
        {
            it("Should revert if holding not more than cancellation fee or fare", async function ()
            {
                var tx = await contractRideHolding.ssUserToCurrencyKeyToHolding_(accounts[0].address, keyPay, "4")
                var rcpt = await tx.wait()
                await expect(contractRidePassenger.requestTicket(keyLocal, keyPay, 0, false, 500, 500)).to.revertedWith("passenger's holding < cancellationFee or fare")
            })
            it("Should set ticket details", async function ()
            {
                var tx = await contractRideHolding.ssUserToCurrencyKeyToHolding_(accounts[0].address, keyPay, "8888888888888")
                var rcpt = await tx.wait()
                var tx = await contractRidePassenger.requestTicket(keyLocal, keyPay, 1, true, 2, 3)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                tixId_ = rcpt.logs[0].topics[2]

                expect(await contractRideTicket.sUserToTixId_(accounts[0].address)).to.equal(tixId_)

                expect((await contractRideTicket.sTixIdToTicket_(tixId_)).passenger).to.equal(accounts[0].address)
                expect((await contractRideTicket.sTixIdToTicket_(tixId_)).driver).to.equal(ethers.constants.AddressZero)
                expect((await contractRideTicket.sTixIdToTicket_(tixId_)).strict).to.equal(true)
                expect((await contractRideTicket.sTixIdToTicket_(tixId_)).badge).to.equal(1)
                expect((await contractRideTicket.sTixIdToTicket_(tixId_)).metres).to.equal(3)
                expect((await contractRideTicket.sTixIdToTicket_(tixId_)).keyLocal).to.equal(keyLocal)
                expect((await contractRideTicket.sTixIdToTicket_(tixId_)).keyPay).to.equal(keyPay)
                expect((await contractRideTicket.sTixIdToTicket_(tixId_)).cancellationFee).to.not.equal(0)
                expect((await contractRideTicket.sTixIdToTicket_(tixId_)).fare).to.not.equal(0)
                expect((await contractRideTicket.sTixIdToTicket_(tixId_)).tripStart).to.equal(false)
                expect((await contractRideTicket.sTixIdToTicket_(tixId_)).forceEndTimestamp).to.equal(0)
            })
        })

        describe("cancelRequest", function ()
        {
            // uses helper functions only
        })

        describe("startTrip", function ()
        {
            it("Should set driver reputation and ticket detail", async function ()
            {
                var tx = await contractRideTicket.ssTixIdToTicket_(
                    tixId_, accounts[0].address, accounts[1].address, 1, false, 3,
                    keyLocal, keyPay, 4, 2, false
                )
                var rcpt = await tx.wait()

                var tx = await contractRideTicket.ssTixIdToTicket_2(
                    tixId_, 0
                )
                var rcpt = await tx.wait()

                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[1].address)).countStart).to.equal(0)
                expect((await contractRideTicket.sTixIdToTicket_(tixId_)).tripStart).to.equal(false)
                expect((await contractRideTicket.sTixIdToTicket_(tixId_)).forceEndTimestamp).to.equal(0)

                var tx = await contractRidePassenger.startTrip(accounts[1].address)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[1].address)).countStart).to.equal(1)
                expect((await contractRideTicket.sTixIdToTicket_(tixId_)).tripStart).to.equal(true)
                expect((await contractRideTicket.sTixIdToTicket_(tixId_)).forceEndTimestamp).to.not.equal(0)
            })
        })

        describe("endTripPax", function ()
        {
            it("Should revert if driver is zero address", async function ()
            {
                var tx = await contractRideTicket.ssTixIdToDriverEnd_(
                    tixId_, ethers.constants.AddressZero, true
                )
                var rcpt = await tx.wait()
                await expect(contractRidePassenger.endTripPax(false, 3)).to.revertedWith("driver must end trip")
            })
            it("Should revert if passenger does not agree", async function ()
            {
                var tx = await contractRideTicket.ssTixIdToDriverEnd_(
                    tixId_, accounts[1].address, true
                )
                var rcpt = await tx.wait()
                await expect(contractRidePassenger.endTripPax(false, 3)).to.revertedWith("pax must agree destination reached or not - indicated by driver")
            })
            it("Should set driver reputation details", async function ()
            {
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[1].address)).metresTravelled).to.equal(0)
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[1].address)).countEnd).to.equal(0)

                var tx = await contractRidePassenger.endTripPax(true, 3)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[1].address)).metresTravelled).to.not.equal(0)
                expect((await contractRideBadge.sDriverToDriverReputation_(accounts[1].address)).countEnd).to.equal(1)
            })
        })

        describe("forceEndPax", function ()
        {
            it("Should revert if driver end details not set", async function ()
            {
                var tx = await contractRidePassenger.requestTicket(keyLocal, keyPay, 1, true, 2, 3)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                tixId_ = rcpt.logs[0].topics[2]

                var tx = await contractRideTicket.ssTixIdToTicket_(
                    tixId_, accounts[0].address, accounts[1].address, 1, false, 3,
                    keyLocal, keyPay, 4, 2, false
                )

                var rcpt = await tx.wait()

                var tx = await contractRidePassenger.startTrip(accounts[1].address)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                var rcpt = await tx.wait()
                var tx = await contractRideTicket.ssTixIdToTicket_2(
                    tixId_, 1234
                )

                var tx = await contractRideTicket.ssTixIdToDriverEnd_(
                    tixId_, accounts[1].address, true
                )
                var rcpt = await tx.wait()

                await expect(contractRidePassenger.forceEndPax()).to.revertedWith("driver ended trip")
            })
            it("Should allow pass if driver end details set", async function ()
            {
                var tx = await contractRideTicket.ssTixIdToDriverEnd_(
                    tixId_, ethers.constants.AddressZero, true
                )
                var rcpt = await tx.wait()

                var tx = await contractRidePassenger.forceEndPax()
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)
            })
        })
    })
}