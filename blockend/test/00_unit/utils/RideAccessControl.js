// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect } = require("chai")
const { ethers } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

let { deploy, networkConfig } = require('../../../scripts/utils')

if (parseInt(chainId) === 31337)
{
    describe("RideLibAccessControl", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()

            deployRideAccessControl = await deploy(
                accounts[0],
                chainId,
                "RideTestAccessControl",
                args = [],
                verify = true,
                test = true
            )

            contractRideAccessControl = await ethers.getContractAt('RideTestAccessControl', deployRideAccessControl.address, accounts[0].address)

            TEST_ROLE_1 = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("TEST_ROLE_1"))
            TEST_ROLE_2 = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("TEST_ROLE_2"))
            TEST_ROLE_3 = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("TEST_ROLE_3"))
            TEST_ROLE_4 = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("TEST_ROLE_4"))
            TEST_ROLE_5 = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("TEST_ROLE_5"))
        })

        describe("DEFAULT_ADMIN_ROLE", function ()
        {
            it("Should return zero bytes (hash)", async function ()
            {
                expect(await contractRideAccessControl.getDefaultAdminRole_()).to.equal(ethers.constants.HashZero)
            })
        })

        describe("_requireOnlyRole", function ()
        {
            it("Should revert if caller dont have role", async function ()
            {
                await expect(contractRideAccessControl.requireOnlyRole_(TEST_ROLE_1)).to.be.reverted //With(`AccessControl: account ${accounts[0].address} is missing role ${TEST_ROLE_1}`)
            })
            it("Should allow pass if caller has role", async function ()
            {
                expect(await contractRideAccessControl.sRolesAdmin(TEST_ROLE_1)).to.equal(ethers.constants.HashZero)
                expect(await contractRideAccessControl.sRolesMember(TEST_ROLE_1, accounts[0].address)).to.equal(false)

                var tx = await contractRideAccessControl.ssRoles(TEST_ROLE_1, ethers.constants.HashZero, accounts[0].address, true)
                var rcpt = await tx.wait()

                expect(await contractRideAccessControl.sRolesAdmin(TEST_ROLE_1)).to.equal(ethers.constants.HashZero)
                expect(await contractRideAccessControl.sRolesMember(TEST_ROLE_1, accounts[0].address)).to.equal(true)
            })
        })

        describe("_hasRole", function ()
        {
            it("Should return false if no role", async function ()
            {
                expect(await contractRideAccessControl.hasRole_(TEST_ROLE_2, accounts[0].address)).to.equal(false)
            })
            it("Should return true if have role", async function ()
            {
                var tx = await contractRideAccessControl.ssRoles(TEST_ROLE_2, ethers.constants.HashZero, accounts[0].address, true)
                var rcpt = await tx.wait()

                expect(await contractRideAccessControl.hasRole_(TEST_ROLE_2, accounts[0].address)).to.equal(true)
            })
        })

        describe("_getRoleAdmin", function ()
        {
            it("Should return admin role of role being quering", async function ()
            {
                expect(await contractRideAccessControl.getRoleAdmin_(TEST_ROLE_2)).to.equal(ethers.constants.HashZero)

                var tx = await contractRideAccessControl.ssRoles(TEST_ROLE_2, TEST_ROLE_1, accounts[0].address, true)
                var rcpt = await tx.wait()

                expect(await contractRideAccessControl.getRoleAdmin_(TEST_ROLE_2)).to.equal(TEST_ROLE_1)
            })
        })

        describe("_setRoleAdmin", function ()
        {
            it("Should set admin role for role", async function ()
            {
                var tx = await contractRideAccessControl.setRoleAdmin_(TEST_ROLE_2, TEST_ROLE_3)
                var rcpt = await tx.wait()

                expect(await contractRideAccessControl.getRoleAdmin_(TEST_ROLE_2)).to.equal(TEST_ROLE_3)
            })
        })

        describe("_grantRole", function ()
        {
            it("Should set role to address", async function ()
            {
                expect(await contractRideAccessControl.hasRole_(TEST_ROLE_4, accounts[0].address)).to.equal(false)

                var tx = await contractRideAccessControl.grantRole_(TEST_ROLE_4, accounts[0].address)
                var rcpt = await tx.wait()

                expect(await contractRideAccessControl.hasRole_(TEST_ROLE_4, accounts[0].address)).to.equal(true)

            })
        })

        describe("_revokeRole", function ()
        {
            it("Should remove role from address", async function ()
            {
                var tx = await contractRideAccessControl.revokeRole_(TEST_ROLE_4, accounts[0].address)
                var rcpt = await tx.wait()

                expect(await contractRideAccessControl.hasRole_(TEST_ROLE_4, accounts[0].address)).to.equal(false)
            })
        })

        describe("_setupRole", function ()
        {
            it("Should set role to address", async function ()
            {
                expect(await contractRideAccessControl.hasRole_(TEST_ROLE_5, accounts[0].address)).to.equal(false)

                var tx = await contractRideAccessControl.setupRole_(TEST_ROLE_5, accounts[0].address)
                var rcpt = await tx.wait()

                expect(await contractRideAccessControl.hasRole_(TEST_ROLE_5, accounts[0].address)).to.equal(true)
            })
        })
    })

    describe("RideAccessControl", function ()
    {
        describe("hasRole", function ()
        {
            it("Should return false if no role", async function ()
            {
                expect(await contractRideAccessControl.hasRole(TEST_ROLE_2, accounts[1].address)).to.equal(false)
            })
            it("Should return true if have role", async function ()
            {
                var tx = await contractRideAccessControl.ssRoles(TEST_ROLE_2, ethers.constants.HashZero, accounts[1].address, true)
                var rcpt = await tx.wait()

                expect(await contractRideAccessControl.hasRole(TEST_ROLE_2, accounts[1].address)).to.equal(true)
            })
        })

        describe("getRoleAdmin", function ()
        {
            it("Should return admin role of role being quering", async function ()
            {
                expect(await contractRideAccessControl.getRoleAdmin(TEST_ROLE_4)).to.equal(ethers.constants.HashZero)

                var tx = await contractRideAccessControl.ssRoles(TEST_ROLE_4, TEST_ROLE_1, accounts[1].address, true)
                var rcpt = await tx.wait()

                expect(await contractRideAccessControl.getRoleAdmin(TEST_ROLE_4)).to.equal(TEST_ROLE_1)
            })
        })

        describe("grantRole", function ()
        {
            it("Should revert if caller if not admin of quering role", async function ()
            {
                await expect(contractRideAccessControl.grantRole(TEST_ROLE_5, accounts[1].address)).to.be.reverted
            })
            it("Should set role to address", async function ()
            {
                expect(await contractRideAccessControl.hasRole_(TEST_ROLE_5, accounts[1].address)).to.equal(false)

                var tx = await contractRideAccessControl.ssRoles(TEST_ROLE_1, ethers.constants.HashZero, accounts[0].address, true)
                var rcpt = await tx.wait()
                var tx = await contractRideAccessControl.ssRoles(TEST_ROLE_5, TEST_ROLE_1, accounts[0].address, true)
                var rcpt = await tx.wait()

                var tx = await contractRideAccessControl.grantRole(TEST_ROLE_5, accounts[1].address)
                var rcpt = await tx.wait()

                expect(await contractRideAccessControl.hasRole_(TEST_ROLE_5, accounts[1].address)).to.equal(true)

            })
        })

        describe("revokeRole", function ()
        {
            it("Should revert if caller if not admin of quering role", async function ()
            {
                contractRideAccessControl1 = await ethers.getContractAt('RideTestAccessControl', deployRideAccessControl.address, accounts[1].address)
                await expect(contractRideAccessControl1.revokeRole(TEST_ROLE_5, accounts[1].address)).to.be.reverted
            })
            it("Should remove role from address", async function ()
            {
                var tx = await contractRideAccessControl.revokeRole(TEST_ROLE_5, accounts[1].address)
                var rcpt = await tx.wait()

                expect(await contractRideAccessControl.hasRole_(TEST_ROLE_5, accounts[1].address)).to.equal(false)
            })
        })

        describe("renounceRole", function ()
        {
            it("Should remove role from caller's address", async function ()
            {
                expect(await contractRideAccessControl.hasRole(TEST_ROLE_2, accounts[1].address)).to.equal(true)

                var tx = await contractRideAccessControl1.renounceRole(TEST_ROLE_2)
                var rcpt = await tx.wait()

                expect(await contractRideAccessControl.hasRole(TEST_ROLE_2, accounts[1].address)).to.equal(false)
            })
        })
    })
}