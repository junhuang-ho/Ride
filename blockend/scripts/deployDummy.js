let { deploy } = require('./utils')
const { ethers } = require("hardhat")

async function deployDummy(test = false, testWithInit = false)
{
    const chainId = hre.network.config.chainId // returns undefined if not local hh network
    const networkName = hre.network.name
    const accounts = await ethers.getSigners()

    const contract = await deploy(
        chainId,
        "Greeter",
        args = ["Hello World!"],
        verify = true,
    )

    console.log(`Contract: ${contract.address}`)

    return contract.address
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module)
{
    deployDummy()
        .then(() => process.exit(0))
        .catch(error =>
        {
            console.error(error)
            process.exit(1)
        })
}

exports.deployDummy = deployDummy