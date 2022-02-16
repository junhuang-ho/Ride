let { deploy, networkConfig } = require('../utils')
const fs = require('fs')
const { expect } = require("chai")
const { ethers } = require("hardhat")

const {
    getSelectors,
    FacetCutAction,
    removeSelectors,
    findAddressPositionInFacets
} = require('../utilsDiamond.js')

async function testWait(deployerAddress, test = false, integration = false)
{
    const chainId = hre.network.config.chainId // returns undefined if not local hh network
    const networkName = hre.network.name

    if (deployerAddress === undefined || deployerAddress === null)
    {
        accounts = await ethers.getSigners()
        deployerAddress = accounts[0].address // TODO: change (if needed) this address when deploying to mainnet !!!
        console.log(`Using default address`)
    }
    console.log(`Deployer address is ${deployerAddress}`)

    // let abi = ["function setAdministrationAddress(address _administration)"]
    // let iface = new ethers.utils.Interface(abi)
    // encoded_fn = iface.encodeFunctionData("setAdministrationAddress", ["0x35570FdCDB45292F1ee1D34816F1E24D040C7F4d"])
    // description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("set administration contract"))

    // let abi = ["function registerFiat(string memory _code)"]
    // let iface = new ethers.utils.Interface(abi)
    // encoded_fn = iface.encodeFunctionData("registerFiat", ["USC"])
    // description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("test1"))

    // address = "0x6a6F8Fb957538B5d4e7016cb331bE64788e53A83"
    // contractBox = await ethers.getContractAt("Box3", address)
    // selectorsBox = getSelectors(contractBox)
    // abi = ["function rideCut((address facetAddress, uint8 action, bytes4[] functionSelectors)[] calldata _rideCut, address _init, bytes calldata _calldata)"]
    // iface = new ethers.utils.Interface(abi)
    // encoded_fn = iface.encodeFunctionData("rideCut",
    //     [
    //         [{
    //             facetAddress: address,
    //             action: FacetCutAction.Add,
    //             functionSelectors: selectorsBox
    //         }],
    //         ethers.constants.AddressZero,
    //         '0x',
    //     ]) // , { gasLimit: 800000 }
    // description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("test box 222"))

    address = "0x6a6F8Fb957538B5d4e7016cb331bE64788e53A83"
    contractBox = await ethers.getContractAt("Box3", address)
    selectorsBox = getSelectors(contractBox)
    abi = ["function rideCut((address facetAddress, uint8 action, bytes4[] functionSelectors)[] calldata _rideCut, address _init, bytes calldata _calldata)"]
    iface = new ethers.utils.Interface(abi)
    encoded_fn = iface.encodeFunctionData("rideCut",
        [
            [{
                facetAddress: ethers.constants.AddressZero,
                action: FacetCutAction.Remove,
                functionSelectors: selectorsBox
            }],
            ethers.constants.AddressZero,
            '0x',
        ]) // , { gasLimit: 800000 }
    description_hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("test box 2222"))

    console.log("encoded fn:", encoded_fn)
    console.log("desc hash:", description_hash)


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module)
{
    testWait()
        .then(() => process.exit(0))
        .catch(error =>
        {
            console.error(error)
            process.exit(1)
        })
}

exports.testWait = testWait