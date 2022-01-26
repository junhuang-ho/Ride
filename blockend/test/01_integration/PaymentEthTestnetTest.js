// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers, waffle } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

const { deployRideHub } = require("../../scripts/deployRideHub.js")

if (parseInt(chainId) === 4 || parseInt(chainId) === 42)
{
    describe("Successful Trip - Payment Focus", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            admin = accounts[0].address
            driver = accounts[1].address // pre-registration is considered an applicant
            passenger = accounts[2].address
            other = accounts[9].address

            pkAdmin = "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
            pkDriver = "0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d"
            pkPassenger = "0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a"
            pkOther = "0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6"

            contractAddresses = await deployRideHub(admin, true, true)
            rideHubAddress = contractAddresses[0]
            mockV3AggregatorAddress = contractAddresses[1]
            wETH9Address = contractAddresses[2]

            // contracts required to be called by Admin for setup and others
            contractRideDriverRegistryA = await ethers.getContractAt('IRideDriverRegistry', rideHubAddress, admin)

            // contracts required to be called by Driver
            contractRideDriverD = await ethers.getContractAt('IRideDriver', rideHubAddress, driver)
            contractRideDriverRegistryD = await ethers.getContractAt('IRideDriverRegistry', rideHubAddress, driver)
            contractRideHoldingD = await ethers.getContractAt('IRideHolding', rideHubAddress, driver)
            contractWETH9D = await ethers.getContractAt('WETH9', wETH9Address, driver)

            // contracts required to be called by Passenger
            contractRidePassengerP = await ethers.getContractAt('IRidePassenger', rideHubAddress, passenger)
            contractRideHoldingP = await ethers.getContractAt('IRideHolding', rideHubAddress, passenger)
            contractWETH9P = await ethers.getContractAt('WETH9', wETH9Address, passenger)

            // for view, any address can call
            contractRideBadgeO = await ethers.getContractAt('IRideBadge', rideHubAddress, other)
            contractRideCurrencyRegistryO = await ethers.getContractAt('IRideCurrencyRegistry', rideHubAddress, other)
            contractRideExchangeO = await ethers.getContractAt('IRideExchange', rideHubAddress, other)
            contractRideHoldingO = await ethers.getContractAt('IRideHolding', rideHubAddress, other)
            contractRideTicketO = await ethers.getContractAt('IRideTicket', rideHubAddress, other)
            contractRidePenaltyO = await ethers.getContractAt('IRidePenalty', rideHubAddress, other)
            contractWETH9O = await ethers.getContractAt('WETH9', wETH9Address, other)

            keyLocal = await contractRideCurrencyRegistryO.getKeyFiat("USD")
            keyPay = await contractRideCurrencyRegistryO.getKeyCrypto(wETH9Address)

            sendAmountInETH = "7000"
            approveAmountInWETH = "5000"
            estimatedMinutes = 2
            estimatedMetres = 100
        })

        describe("Driver registration succeed", function ()
        {
            it("Should successfully register applicant", async function ()
            {
                expect((await contractRideBadgeO.getDriverToDriverReputation(driver)).id).to.equal(0)
                expect((await contractRideBadgeO.getDriverToDriverReputation(driver)).uri).to.equal("")
                expect((await contractRideBadgeO.getDriverToDriverReputation(driver)).maxMetresPerTrip).to.equal(0)
                expect((await contractRideBadgeO.getDriverToDriverReputation(driver)).metresTravelled).to.equal(0)
                expect((await contractRideBadgeO.getDriverToDriverReputation(driver)).countStart).to.equal(0)
                expect((await contractRideBadgeO.getDriverToDriverReputation(driver)).countEnd).to.equal(0)
                expect((await contractRideBadgeO.getDriverToDriverReputation(driver)).totalRating).to.equal(0)
                expect((await contractRideBadgeO.getDriverToDriverReputation(driver)).countRating).to.equal(0)

                applicationDocumentsURI = "testDocs" // applicant submits (driver)
                var tx = await contractRideDriverRegistryA.approveApplicant(driver, applicationDocumentsURI)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                var tx = await contractRideDriverRegistryD.registerAsDriver(500)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect((await contractRideBadgeO.getDriverToDriverReputation(driver)).id).to.equal(1)
                expect((await contractRideBadgeO.getDriverToDriverReputation(driver)).uri).to.equal(applicationDocumentsURI)
                expect((await contractRideBadgeO.getDriverToDriverReputation(driver)).maxMetresPerTrip).to.equal(500)
                expect((await contractRideBadgeO.getDriverToDriverReputation(driver)).metresTravelled).to.equal(0)
                expect((await contractRideBadgeO.getDriverToDriverReputation(driver)).countStart).to.equal(0)
                expect((await contractRideBadgeO.getDriverToDriverReputation(driver)).countEnd).to.equal(0)
                expect((await contractRideBadgeO.getDriverToDriverReputation(driver)).totalRating).to.equal(0)
                expect((await contractRideBadgeO.getDriverToDriverReputation(driver)).countRating).to.equal(0)
            })
        })

        describe("Deposit", function ()
        {
            it("Should allow driver deposit", async function ()
            {
                // convert ETH to wETH
                expect(await contractWETH9O.balanceOf(driver)).to.equal(0)

                wallet = new ethers.Wallet(pkDriver, waffle.provider)
                var tx = await wallet.sendTransaction({ to: wETH9Address, value: ethers.utils.parseEther(sendAmountInETH) })
                var rcpt = await tx.wait()

                expect(await contractWETH9O.balanceOf(driver)).to.equal(ethers.utils.parseEther(sendAmountInETH))

                // approve RideHub
                var tx = await contractWETH9D.approve(rideHubAddress, ethers.utils.parseEther(approveAmountInWETH))
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                // deposit
                expect(await contractRideHoldingO.getHolding(driver, keyPay)).to.equal(0)

                var tx = await contractRideHoldingD.depositTokens(keyPay, ethers.utils.parseEther(approveAmountInWETH))
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideHoldingO.getHolding(driver, keyPay)).to.equal(ethers.utils.parseEther(approveAmountInWETH))
            })

            it("Should allow passenger deposit", async function ()
            {
                // convert ETH to wETH
                expect(await contractWETH9O.balanceOf(passenger)).to.equal(0)

                wallet = new ethers.Wallet(pkPassenger, waffle.provider)
                var tx = await wallet.sendTransaction({ to: wETH9Address, value: ethers.utils.parseEther(sendAmountInETH) })
                var rcpt = await tx.wait()

                expect(await contractWETH9O.balanceOf(passenger)).to.equal(ethers.utils.parseEther(sendAmountInETH))

                // approve RideHub
                var tx = await contractWETH9P.approve(rideHubAddress, ethers.utils.parseEther(approveAmountInWETH))
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                // deposit
                expect(await contractRideHoldingO.getHolding(passenger, keyPay)).to.equal(0)

                var tx = await contractRideHoldingP.depositTokens(keyPay, ethers.utils.parseEther(approveAmountInWETH))
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideHoldingO.getHolding(passenger, keyPay)).to.equal(ethers.utils.parseEther(approveAmountInWETH))
            })
        })

        describe("Driver indicates destination reached - passenger agrees", function ()
        {
            it("Should end as described", async function ()
            {
                expect(await contractRideTicketO.getUserToTixId(passenger)).to.equal(ethers.constants.HashZero)
                expect(await contractRideTicketO.getUserToTixId(driver)).to.equal(ethers.constants.HashZero)

                expect(await contractRideHoldingO.getHolding(passenger, keyPay)).to.equal(ethers.utils.parseEther(approveAmountInWETH))
                expect(await contractRideHoldingO.getHolding(driver, keyPay)).to.equal(ethers.utils.parseEther(approveAmountInWETH))

                // passenger request ticket
                var tx = await contractRidePassengerP.requestTicket(keyLocal, keyPay, 0, false, estimatedMinutes, estimatedMetres)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                tixId = rcpt.logs[0].topics[2]
                expect(await contractRideTicketO.getUserToTixId(passenger)).to.equal(tixId)

                // driver accept ticket
                var tx = await contractRideDriverD.acceptTicket(keyLocal, keyPay, tixId, 0)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)
                expect(await contractRideTicketO.getUserToTixId(driver)).to.equal(tixId)

                // driver reaches passenger location

                // passenger starts trip, scan QR code etc
                var tx = await contractRidePassengerP.startTrip(driver)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                // "destination" reached

                // driver ends trip
                var tx = await contractRideDriverD.endTripDrv(true)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                // passenger agress, ends trip, and gives rating
                var tx = await contractRidePassengerP.endTripPax(true, 4)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                // pay tokens are transferred from passenger to driver
                expect(await contractRideHoldingO.getHolding(passenger, keyPay)).to.be.below(ethers.utils.parseEther(approveAmountInWETH))
                expect(await contractRideHoldingO.getHolding(driver, keyPay)).to.be.above(ethers.utils.parseEther(approveAmountInWETH))

                // system cleans up, trip complete
                expect(await contractRideTicketO.getUserToTixId(passenger)).to.equal(ethers.constants.HashZero)
                expect(await contractRideTicketO.getUserToTixId(driver)).to.equal(ethers.constants.HashZero)
            })
        })

        describe("Withdrawal", function ()
        {
            it("Should allow driver withdrawal", async function ()
            {
                // withdraw ALL tokens
                currentDrvHolding = await contractRideHoldingO.getHolding(driver, keyPay)

                var tx = await contractRideHoldingD.withdrawTokens(keyPay, currentDrvHolding)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideHoldingO.getHolding(driver, keyPay)).to.equal(0)

                expect(await contractWETH9O.balanceOf(driver)).to.be.above(ethers.utils.parseEther("3000"))
            })

            it("Should allow passenger withdrawal", async function ()
            {
                // withdraw ALL tokens
                currentPaxHolding = await contractRideHoldingO.getHolding(passenger, keyPay)

                var tx = await contractRideHoldingP.withdrawTokens(keyPay, currentPaxHolding)
                var rcpt = await tx.wait()
                expect(tx.confirmations).to.equal(1)

                expect(await contractRideHoldingO.getHolding(passenger, keyPay)).to.equal(0)

                expect(await contractWETH9O.balanceOf(passenger)).to.be.above(ethers.utils.parseEther("3000"))
                // expect(await waffle.provider.getBalance(passenger)).to.be.above(ethers.utils.parseEther("3000"))
            })
        })
    })
}