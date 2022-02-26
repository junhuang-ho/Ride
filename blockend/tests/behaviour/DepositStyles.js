// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers, waffle } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

const ethSigUtil = require('eth-sig-util')
const { fromRpcSig } = require('ethereumjs-util')

let { deploy, networkConfig } = require('../../scripts/utils')
const { deployRideHub } = require("../../scripts/deployRideHub.js")

// useful link: https://ethereum.org/en/developers/tutorials/erc20-annotated-code/#allowance-functions

if (parseInt(chainId) === 31337)
{
    describe("Deposit patterns", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            admin = accounts[0].address
            person1 = accounts[1].address // pre-registration is considered an applicant
            person2 = accounts[2].address
            other = accounts[9].address

            contractAddresses = await deployRideHub(admin, true, true)
            rideHubAddress = contractAddresses[0]

            const contractRide = await deploy(
                admin,
                chainId,
                "Ride",
                args = [],
                verify = true,
                test = true
            )

            // admin setup for RideHub contract
            contractRideHoldingA = await ethers.getContractAt('IRideHolding', rideHubAddress, admin)
            contractRideCurrencyRegistryA = await ethers.getContractAt('IRideCurrencyRegistry', rideHubAddress, admin)

            // setup RIDE token to be supported in RideHub as currency
            var tx = await contractRideCurrencyRegistryA.registerCrypto(contractRide.address)
            var rcpt = await tx.wait()

            keyLocal = await contractRideCurrencyRegistryA.getKeyFiat("USD")
            keyPay = await contractRideCurrencyRegistryA.getKeyCrypto(contractRide.address)

            // do some minting
            contractRideA = await ethers.getContractAt('Ride', contractRide.address, admin)

            mintAmount = 100
            var tx = await contractRideA.mint(admin, mintAmount)
            var rcpt = await tx.wait()
        })

        describe("depositTokens - using approve method, applies to any ERC20 token", function ()
        {
            it("Should deposit tokens into RideHub under two transaction calls", async function ()
            {
                depositAmount1 = 30

                expect(await contractRideA.balanceOf(admin)).to.equal(mintAmount)
                expect(await contractRideA.balanceOf(rideHubAddress)).to.equal(0)
                expect(await contractRideA.allowance(admin, rideHubAddress)).to.equal(0)
                expect(await contractRideHoldingA.getHolding(admin, keyPay)).to.equal(0)

                // approve
                var tx = await contractRideA.approve(rideHubAddress, depositAmount1)
                var rcpt = await tx.wait()

                expect(await contractRideA.balanceOf(admin)).to.equal(mintAmount)
                expect(await contractRideA.balanceOf(rideHubAddress)).to.equal(0)
                expect(await contractRideA.allowance(admin, rideHubAddress)).to.equal(depositAmount1)
                expect(await contractRideHoldingA.getHolding(admin, keyPay)).to.equal(0)

                // deposit
                var tx = await contractRideHoldingA.depositTokens(keyPay, depositAmount1)
                var rcpt = await tx.wait()

                expect(await contractRideA.balanceOf(admin)).to.equal(mintAmount - depositAmount1)
                expect(await contractRideA.balanceOf(rideHubAddress)).to.equal(depositAmount1)
                expect(await contractRideA.allowance(admin, rideHubAddress)).to.equal(0)
                expect(await contractRideHoldingA.getHolding(admin, keyPay)).to.equal(depositAmount1)
            })
            /**
             * NOTE: Security best practices - as applied to RideHub
             * 1. Always call depositTokens on total amount approved
             * 2. Never call approve more than once before depositTokens is called
             * refer: https://ethereum.org/en/developers/tutorials/erc20-annotated-code/#allowance-functions
             */
        })

        describe("depositTokens - using increaseAllowance method, applies to any token that follows OZ's ERC20 pattern", function ()
        {
            it("Should deposit tokens into RideHub under two transaction calls", async function ()
            {
                depositAmount2 = 5

                // increaseAllowance
                var tx = await contractRideA.increaseAllowance(rideHubAddress, depositAmount2)
                var rcpt = await tx.wait()

                expect(await contractRideA.balanceOf(admin)).to.equal(mintAmount - depositAmount1)
                expect(await contractRideA.balanceOf(rideHubAddress)).to.equal(depositAmount1)
                expect(await contractRideA.allowance(admin, rideHubAddress)).to.equal(depositAmount2)
                expect(await contractRideHoldingA.getHolding(admin, keyPay)).to.equal(depositAmount1)

                // deposit
                var tx = await contractRideHoldingA.depositTokens(keyPay, depositAmount2)
                var rcpt = await tx.wait()

                expect(await contractRideA.balanceOf(admin)).to.equal(mintAmount - depositAmount1 - depositAmount2)
                expect(await contractRideA.balanceOf(rideHubAddress)).to.equal(depositAmount1 + depositAmount2)
                expect(await contractRideA.allowance(admin, rideHubAddress)).to.equal(0)
                expect(await contractRideHoldingA.getHolding(admin, keyPay)).to.equal(depositAmount1 + depositAmount2)
            })
            /**
             * NOTE: Security best practices - as applied to RideHub
             * 1. Always call depositTokens on total amount approved
             * 2. Never call approve more than once before depositTokens is called
             * refer: https://ethereum.org/en/developers/tutorials/erc20-annotated-code/#allowance-functions
             */
        })

        describe("depositTokensPermit - applies to any token that extends ERC20Permit, preferred way", function ()
        {
            it("Should deposit tokens into RideHub under ONE transaction call", async function ()
            {
                depositAmount3 = 5

                // sign transaction
                deadline = "1675651904"

                const Permit = [
                    { name: 'owner', type: 'address' },
                    { name: 'spender', type: 'address' },
                    { name: 'value', type: 'uint256' },
                    { name: 'nonce', type: 'uint256' },
                    { name: 'deadline', type: 'uint256' },
                ];

                const EIP712Domain = [
                    { name: 'name', type: 'string' },
                    { name: 'version', type: 'string' },
                    { name: 'chainId', type: 'uint256' },
                    { name: 'verifyingContract', type: 'address' },
                ];
                name_ = "Ride"
                version = "1"
                nonce = 0
                spender = rideHubAddress
                value = depositAmount3
                owner = admin

                const buildData = (chainId, verifyingContract, deadline, nonce) => ({
                    primaryType: 'Permit',
                    types: { EIP712Domain, Permit },
                    domain: { name: name_, version: version, chainId: chainId, verifyingContract: verifyingContract },
                    message: { owner: owner, spender: spender, value: value, nonce: nonce, deadline: deadline },
                })

                pk = "ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
                const hex = Buffer.from(pk, 'hex')

                const data = buildData(chainId, contractRideA.address, deadline, nonce);
                const signature = ethSigUtil.signTypedMessage(hex, { data })
                const { v, r, s } = fromRpcSig(signature)

                // deposit
                var tx = await contractRideHoldingA.depositTokensPermit(keyPay, value, deadline, v, r, s)
                var rcpt = tx.wait()

                expect(await contractRideA.balanceOf(admin)).to.equal(mintAmount - depositAmount1 - depositAmount2 - depositAmount3)
                expect(await contractRideA.balanceOf(rideHubAddress)).to.equal(depositAmount1 + depositAmount2 + depositAmount3)
                expect(await contractRideA.allowance(admin, rideHubAddress)).to.equal(0)
                expect(await contractRideHoldingA.getHolding(admin, keyPay)).to.equal(depositAmount1 + depositAmount2 + depositAmount3)
            })
        })
    })
}