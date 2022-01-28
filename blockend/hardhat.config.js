require("@nomiclabs/hardhat-waffle")
require("@nomiclabs/hardhat-etherscan")
require('hardhat-deploy')
require('solidity-coverage')
require('hardhat-contract-sizer')
require("hardhat-deploy-ethers")
require("hardhat-gas-reporter")
require('dotenv').config()

module.exports = {
    solidity: {
        compilers:
            [
                { version: "0.8.0" }, // MUST SAME AS .sol FILES VERSION !!! IF NOT HAVE VERIFY ISSUE !!!
                { version: "0.8.2" },
                { version: "0.5.11" },
                { version: "0.4.24" }, // for mocks
                // { version: "0.4.16" },
                { version: "0.6.6" } // for mocks
            ],
        settings: {
            optimizer: {
                enabled: true,
                runs: 200,
            },
        },
    },
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {
            chainId: 31337,
            // // If you want to do some forking, uncomment this
            // forking: {
            //   url: RPC_URL_MAINNET
            // }
        },
        localhost: {},
        rinkeby: {
            chainId: 4,
            url: process.env.RPC_URL_RINKEBY,
            accounts: {
                mnemonic: process.env.MNEMONIC_0,
            },
            saveDeployments: true,
        },
        kovan: {
            chainId: 42,
            url: process.env.RPC_URL_KOVAN,
            accounts: {
                mnemonic: process.env.MNEMONIC_0,
            },
            saveDeployments: true,
        },
        goerli: {
            chainId: 5,
            url: process.env.RPC_URL_GOERLI,
            accounts: {
                mnemonic: process.env.MNEMONIC_0,
            },
            saveDeployments: true,
        },
        polygon_mumbai: {
            chainId: 80001,
            url: process.env.RPC_URL_MUMBAI, // "https://rpc-mumbai.maticvigil.com/",
            accounts: {
                mnemonic: process.env.MNEMONIC_0,
            },
            saveDeployments: true,
        },
        // polygon-mainnet: {
        //     url: "https://polygon-rpc.com/",
        //     // accounts: {
        //     //     mnemonic: process.env.MNEMONIC_0,
        //     // },
        //     saveDeployments: true,
        // },
    },
    etherscan: {
        // apiKey: process.env.API_KEY_ETHERSCAN
        apiKey: process.env.API_KEY_POLYGONSCAN // actually no such thing polygonscan is powered by etherscan: https://github.com/nomiclabs/hardhat/issues/1727#issuecomment-931250893
    },
    gasReporter: {
        // enabled: (process.env.REPORT_GAS) ? true : false,
        currency: "USD",
        coinmarketcap: process.env.COINMARKETCAP_API_KEY,

        // token: "ETH",
        // gasPriceApi: process.env.GAS_PRICE_API_ETH,
        token: "MATIC",
        gasPriceApi: process.env.GAS_PRICE_API_MATIC,
    },
    namedAccounts: { // by hardhat-deploy
        deployer: {
            default: 0
        }
    },
    mocha: {
        timeout: 20000 // 20000
    }
}