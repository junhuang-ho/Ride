// note: unit testing in local network
// npx hardhat coverage --testfiles "test/*.js"

const { expect, assert } = require("chai")
const { ethers, waffle } = require("hardhat")
const hre = require("hardhat")
const chainId = hre.network.config.chainId

let { deploy, networkConfig } = require('../../scripts/utils')
const { deployDummyDiamond } = require("../../scripts/experimental/deployDummyDiamond.js")

const {
    getSelectors,
    FacetCutAction,
    removeSelectors,
    findAddressPositionInFacets
} = require('../../scripts/utilsDiamond.js')

if (parseInt(chainId) === 31337)
{
    describe("Diamond Upgrade", function ()
    {
        before(async function ()
        {
            accounts = await ethers.getSigners()
            admin = accounts[0].address
            person1 = accounts[1].address

            addresses = await deployDummyDiamond(admin, true, true)
            dummyDiamondAddress = addresses[0]
            diamondCutFacet = await ethers.getContractAt('IRideCut', dummyDiamondAddress)
            diamondLoupeFacet = await ethers.getContractAt('RideLoupe', dummyDiamondAddress)
            ownershipFacet = await ethers.getContractAt('RideOwnership', dummyDiamondAddress)
        })

        describe("Add", function ()
        {
            it("Should add facet with all of its fn selectors", async function ()
            {
                contractBox3 = await deploy(
                    admin,
                    chainId,
                    "Box3",
                    args = [],
                    verify = true,
                    test = true
                )

                selectorsBox3 = getSelectors(contractBox3)

                var tx = await diamondCutFacet.rideCut(
                    [{
                        facetAddress: contractBox3.address,
                        action: FacetCutAction.Add,
                        functionSelectors: selectorsBox3
                    }],
                    ethers.constants.AddressZero, '0x', { gasLimit: 800000 })
                var rcpt = await tx.wait()
                if (!rcpt.status)
                {
                    throw Error(`Diamond upgrade failed: ${tx.hash}`)
                }

                assert.sameMembers(await diamondLoupeFacet.facetFunctionSelectors(contractBox3.address), selectorsBox3)
            })
            /**
             * note 1: 
             * we can add facets with only SOME of its function selectors (although not practical),
             * just filter the function selectors of the deployed facet using scripts/utilsDiamond.js
             * refer test/01_integration/diamondTest.js
             * 
             * note 2:
             * do not add functions to existing facet in diamond !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
             */
        })

        describe("Remove", function ()
        {
            it("Should remove selected function selectors", async function ()
            {
                selectorsSpecific = selectorsBox3[1] // case specific !!

                var tx = await diamondCutFacet.rideCut(
                    [{
                        facetAddress: ethers.constants.AddressZero, // RMB ZERO ADDRESS
                        action: FacetCutAction.Remove,
                        functionSelectors: [selectorsSpecific]
                    }],
                    ethers.constants.AddressZero, '0x', { gasLimit: 800000 })

                var rcpt = await tx.wait()
                if (!rcpt.status)
                {
                    throw Error(`Diamond upgrade failed: ${tx.hash}`)
                }

                assert.sameMembers((await diamondLoupeFacet.facetFunctionSelectors(contractBox3.address)), [selectorsBox3[0]])
            })
            /**
             * note:
             * if remove all function selectors from a facet, the facet itself also auto removed
             * also, facet address input to cut is zero address !!!
             */
        })

        describe("Replace", function ()
        {
            it("NOTE: Replace should not be used - dodgy")
        })

        describe("Remove + Add: same facet, different function selectors", function ()
        {
            it("Should remove facet then add a new facet", async function ()
            {
                contractBox4 = await deploy(
                    admin,
                    chainId,
                    "Box4",
                    args = [],
                    verify = true,
                    test = true
                )

                selectorsBox4 = getSelectors(contractBox4)

                var tx = await diamondCutFacet.rideCut(
                    [
                        {
                            facetAddress: ethers.constants.AddressZero, // RMB ZERO ADDRESS
                            action: FacetCutAction.Remove,
                            functionSelectors: [selectorsBox3[0]]
                        },
                        {
                            facetAddress: contractBox4.address,
                            action: FacetCutAction.Add,
                            functionSelectors: selectorsBox4
                        }
                    ],
                    ethers.constants.AddressZero, '0x', { gasLimit: 800000 })
                var rcpt = await tx.wait()
                if (!rcpt.status)
                {
                    throw Error(`Diamond upgrade failed: ${tx.hash}`)
                }

                assert.sameMembers((await diamondLoupeFacet.facetFunctionSelectors(contractBox4.address)), selectorsBox4)
                expect((await diamondLoupeFacet.facetFunctionSelectors(contractBox3.address)).length).to.equal(0)
            })
        })
    })
}