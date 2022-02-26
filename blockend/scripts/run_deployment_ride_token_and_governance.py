import scripts.deploy_ride_token_and_governance as deploy_ride_token_and_governance
import scripts.utils as utils


def main():
    deployer = utils.get_account(index=0)
    deploy_ride_token_and_governance.main(deployer)
