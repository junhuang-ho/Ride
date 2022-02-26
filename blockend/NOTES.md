install python packages into brownie env: pipx inject eth-brownie <--package-->
ref: https://stackoverflow.com/a/70340195

selecting python env in vs code: https://stackoverflow.com/a/53807784

example of adding a network:
~$ brownie networks add Ethereum rinkeby-alchemy chainid=4 explorer='https://api-rinkeby.etherscan.io/api' host='https://eth-rinkeby.alchemyapi.io/v2/$WEB3_ALCHEMY_PROJECT_ID' name='Rinkeby Testnet (Alchemy)'