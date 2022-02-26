import scripts.deploy_ride_hub as deploy_ride_hub
import scripts.utils as utils

def main():
    deployer = utils.get_account(index=0)
    deploy_ride_hub.main(deployer)
