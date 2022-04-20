import pytest
import brownie
from web3 import Web3
import eth_abi


location_package = Web3.toHex(
    Web3.solidityKeccak(
        ["bytes"], ["0x" + eth_abi.encode_abi(["string"], ["package location"]).hex()]
    )
)

location_destination = Web3.toHex(
    Web3.solidityKeccak(
        ["bytes"],
        ["0x" + eth_abi.encode_abi(["string"], ["destination location"]).hex()],
    )
)

def main():
    print("START")
    print(location_package)
    print(location_destination)
    print("END")