from brownie import accounts, network, config, convert

ENV_LOCAL_BLOCKS = ["development", "ganache-local"]
ENV_LOCAL_FORKS = ["mainnet-ethereum-fork"]
FACET_CUT_ACTIONS = {"Add": 0, "Replace": 1, "Remove": 2}

ZERO_ADDRESS = "0x0000000000000000000000000000000000000000"
ZERO_BYTES32 = "0x0000000000000000000000000000000000000000000000000000000000000000"
ZERO_CALLDATAS = b""

PROPOSAL_STATE = [
    "Pending",
    "Active",
    "Canceled",
    "Defeated",
    "Succeeded",
    "Queued",
    "Expired",
    "Executed",
]


def get_account(index=None, id=None):
    if index:
        return accounts[index]
    if id:
        # using real account registered in brownie (metamask_acc1): run to view: ~$ brownie accounts list
        return accounts.load(id)
    if (
        network.show_active() in ENV_LOCAL_BLOCKS
        or network.show_active() in ENV_LOCAL_FORKS
    ):
        return accounts[0]
    return accounts.add(config["wallets"]["from_key"])  # from_key


def get_function_selectors(contract):
    return list(contract.signatures.values())


def pad_address_right(address):
    address_padded = str(
        convert.datatypes.HexString(
            convert.to_bytes(address, type_str="bytes32"), "bytes32",
        )
    )
    pad_right_length = len(address_padded) - len(address)

    return address + "0" * pad_right_length
