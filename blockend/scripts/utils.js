const { ethers } = require("hardhat")
const fs = require("fs")

const networkConfig = {
    default: {
        name: "hardhat",
    },
    31337: {
        name: "localhost",
    },
    1: {
        name: "mainnet",
        tokenWETH: "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
        priceFeedETHUSD: "0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419",
    },
    4: {
        name: "rinkeby",
        tokenWETH: "0xc778417e063141139fce010982780140aa0cd5ab",
        priceFeedETHUSD: "0x8A753747A1Fa494EC906cE90E9f37563A8AF630e",
    },
    42: {
        name: "kovan",
        tokenWETH: "0xd0a1e359811322d97991e03f863a0c30c2cf029c",
        priceFeedETHUSD: "0x9326BFA02ADD2366b30bacB125260Af641031331",

    },
    5: {
        name: "goerli",
        tokenWETH: "0x0bb7509324ce409f7bbc4b701f932eaca9736ab7",
    },
    137: {
        name: "polygon-mainnet",
        // tokenWMATIC: "0x0d500b1d8e8ef31e21c99d1db9a6444d3adf1270", // not sure PoS or Plasma | not as popular as others, maybe no support?
        tokenPoSUSDT: "0xc2132d05d31c914a87c6611c10748aeb04b58e8f",
        tokenPoSUSDC: "0x2791bca1f2de4661ed88a30c99a7a9449aa84174",
        tokenPoSUST: "0x692597b009d13c4049a947cab2239b7d6517875f",
        tokenPoSDAI: "0x8f3cf7ad23cd3cadbd9735aff958023239c6a063",
        // tokenPlasmaDAI: "0x84000b263080BC37D1DD73A29D92794A6CF1564e",
        tokenPoSWETH: "0x7ceb23fd6bc0add59e62ac25578270cff1b9f619",
        // tokenPlasmaWETH: "0x8cc8538d60901d19692F5ba22684732Bc28F54A3",
        tokenPoSWBTC: "0x1bfd67037b42cf73acf2047067bd4f2c47d9bfd6",
        priceFeedMATICUSD: "0xAB594600376Ec9fD91F8e885dADF0CE036862dE0",
        priceFeedUSDTUSD: "0x0A6513e40db6EB1b165753AD52E80663aeA50545",
        priceFeedUSDCUSD: "0xfE4A8cc5b5B2366C1B58Bea3858e81843581b2F7",
        priceFeedUSTUSD: "0x2D455E55e8Ad3BA965E3e95e7AaB7dF1C671af19",
        priceFeedDAIUSD: "0x4746DeC9e833A82EC7C2C1356372CcF2cfcD2F3D",
        priceFeedETHUSD: "0xF9680D99D6C9589e2a93a78A04A279e509205945",
        priceFeedBTCUSD: "0xc907E116054Ad103354f2D350FD2514433D57F6f",
        priceFeedWBTCUSD: "0xDE31F8bFBD8c84b5360CFACCa3539B938dd78ae6",
        // priceFeedRIDEUSD: "",
    },
    80001: {
        name: "polygon-mumbai",
        tokenWMATIC: "0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889",
        tokenPoSWETH: "0xA6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa",
        tokenPlasmaWETH: "0x4DfAe612aaCB5b448C12A591cD0879bFa2e51d62",
        tokenERC20Dummy: "0xfe4F5145f6e09952a5ba9e956ED0C25e3Fa4c7F1",
        tokenERC20Test: "0x2d7882beDcbfDDce29Ba99965dd3cdF7fcB10A1e",
        priceFeedMATICUSD: "0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada",
        priceFeedUSDTUSD: "0x92C09849638959196E976289418e5973CC96d645",
        priceFeedUSDCUSD: "0x572dDec9087154dC5dfBB1546Bb62713147e0Ab0",
        // priceFeedUSTUSD: "",
        priceFeedDAIUSD: "0x0FCAa9c899EC5A91eBc3D5Dd869De833b06fB046",
        priceFeedETHUSD: "0x0715A7794a1dc8e42615F059dD6e406A6594651A",
        priceFeedBTCUSD: "0x007A22900a3B98143368Bd5906f8E17e9867581b",
        // priceFeedRIDEUSD: "",
    },
    43114: {
        name: "avalanche-mainnet",
    },
    43113: {
        name: "avalanche-fuji",
    },
}

const developmentChains = ["hardhat", "localhost"]

const getNetworkIdFromName = async (networkIdName) =>
{
    for (const id in networkConfig)
    {
        if (networkConfig[id]['name'] == networkIdName)
        {
            return id
        }
    }
    return null
}

const autoFundCheck = async (contractAddr, networkName, linkTokenAddress, additionalMessage) =>
{
    const chainId = await getChainId()
    console.log("Checking to see if contract can be auto-funded with LINK:")
    const amount = networkConfig[chainId]['fundAmount']
    //check to see if user has enough LINK
    const accounts = await ethers.getSigners()
    const signer = accounts[0]
    const LinkToken = await ethers.getContractFactory("LinkToken")
    const linkTokenContract = new ethers.Contract(linkTokenAddress, LinkToken.interface, signer)
    const balanceHex = await linkTokenContract.balanceOf(signer.address)
    const balance = await web3.utils.toBN(balanceHex._hex).toString()
    const contractBalanceHex = await linkTokenContract.balanceOf(contractAddr)
    const contractBalance = await web3.utils.toBN(contractBalanceHex._hex).toString()
    if (balance > amount && amount > 0 && contractBalance < amount)
    {
        //user has enough LINK to auto-fund
        //and the contract isn't already funded
        return true
    } else
    { //user doesn't have enough LINK, print a warning
        console.log("Account doesn't have enough LINK to fund contracts, or you're deploying to a network where auto funding isnt' done by default")
        console.log("Please obtain LINK via the faucet at https://" + networkName + ".chain.link/, then run the following command to fund contract with LINK:")
        console.log("npx hardhat fund-link --contract " + contractAddr + " --network " + networkName + additionalMessage)
        return false
    }
}

const verify_ = async (chainId, contractName, contractDeployed, args, skip = false, test = false) =>
{
    if (parseInt(chainId) !== 31337)
    {
        try
        {
            if (!skip)
            {
                console.log("Sleeping...")
                await sleep(100000) // 1 min zZZ
                console.log("Awake...")
            }

            // WARNING: might need wait awahile for block confirmations !!!
            await hre.run("verify:verify", { // https://hardhat.org/plugins/nomiclabs-hardhat-etherscan.html#using-programmatically
                address: contractDeployed.address,
                constructorArguments: args,
            })
            if (!test)
            {
                console.log(`Verifying\t| Verified ${contractName} on ${networkConfig[chainId]["name"]}: ${contractDeployed.address}`)
            }
        } catch (err)
        {
            console.log(err)
        }
    } else
    {
        if (!test)
        {
            console.log(`Verifying\t| No verification needed for ${networkConfig[chainId].name} local deployment`)
        }
    }
}

const deploy = async (deployer, chainId, contractName, args = [], verify = false, test = false) =>
{
    const dir = `./deployments/${networkConfig[chainId]["name"]}`
    const saveDir = `${dir}/${contractName}.json`

    if (fs.existsSync(saveDir))
    {
        // Skipping
        const deployedContract = fs.readFileSync(saveDir)
        const deployedContractJSON = JSON.parse(deployedContract)
        if (!test)
        {
            console.log(`Skipping\t| ${contractName} already deployed on ${networkConfig[chainId]["name"]}: ${deployedContractJSON.address}`)
        }


        const deployedContractMain = await ethers.getContractAt(contractName, deployedContractJSON.address)

        await verify_(chainId, contractName, deployedContractMain, args, skip = true, test = test)

        return deployedContractMain
    } else
    {
        // Deploying
        const contract = await ethers.getContractFactory(contractName, deployer)
        const contractDeployed = await contract.deploy(...args)
        if (parseInt(chainId) !== 31337)
        {
            tx = await contractDeployed.deployTransaction.wait(5)
        } else
        {
            await contractDeployed.deployed()
        }
        if (!test)
        {
            console.log(`Deploying\t| Deployed ${contractName} on ${networkConfig[chainId]["name"]}: ${contractDeployed.address}`)
        }
        // Saving
        if (parseInt(chainId) !== 31337)
        {
            if (!fs.existsSync(dir))
            {
                fs.mkdirSync(dir, { recursive: true });
            }

            // get abi
            const contractArtifactList = getFiles((__dirname.substring(0, __dirname.lastIndexOf("/"))).concat("/artifacts/contracts"))
            const fileName = `${contractName}.json`
            let contractArtifactsDir
            for (let i = 0; i < contractArtifactList.length; i++)
            {
                if (contractArtifactList[i].endsWith(fileName))
                {
                    contractArtifactsDir = contractArtifactList[i]
                }
            }
            const contractArtifacts = fs.readFileSync(contractArtifactsDir)
            const contractArtifactsJSON = JSON.parse(contractArtifacts)

            const json = JSON.stringify({
                address: contractDeployed.address,
                abi: contractArtifactsJSON.abi,
            })

            // save
            fs.writeFileSync(saveDir, json, function (err)
            {
                if (err)
                {
                    console.log(err)
                }
            })
            if (!test)
            {
                console.log(`Saving\t\t| Saved to ${saveDir}`)
            }
        } else
        {
            if (!test)
            {
                console.log(`Saving\t\t| No saving needed for ${networkConfig[chainId]["name"]} local deployment`)

            }
        }

        // Verify
        if (verify)
        {
            await verify_(chainId, contractName, contractDeployed, args, skip = false, test = test)
        }

        return contractDeployed
    }
}

function getFiles(dir, files_)
{
    files_ = files_ || [];
    var files = fs.readdirSync(dir);
    for (var i in files)
    {
        var name = dir + '/' + files[i];
        if (fs.statSync(name).isDirectory())
        {
            getFiles(name, files_);
        } else
        {
            files_.push(name);
        }
    }
    return files_;
}

function sleep(ms)
{
    return new Promise(resolve => setTimeout(resolve, ms))
}

module.exports = {
    networkConfig,
    getNetworkIdFromName,
    autoFundCheck,
    developmentChains,
    deploy
}