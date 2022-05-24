import json

from brownie import accounts
from brownie.network.gas.strategies import GasNowScalingStrategy
from brownie.project import load as load_project
from brownie.project.main import get_loaded_projects
from brownie import Token

# set a throwaway admin account here
DEPLOYER = accounts.add("3a6cc04a788500e4745a81e796eb50f34217267e32cd06eb80aac0176e91574b")
REQUIRED_CONFIRMATIONS = 1
NEED_DEPLOY_TOKEN = True

# deployment settings
# most settings are taken from `contracts/pools/{POOL_NAME}/pooldata.json`
POOL_NAME = "pool1"

# temporary owner address
POOL_OWNER = "0x892a2b7cF919760e148A0d33C1eb0f44D3b383f8"
GAUGE_OWNER = "0x892a2b7cF919760e148A0d33C1eb0f44D3b383f8"


MINTER = "0x892a2b7cF919760e148A0d33C1eb0f44D3b383f8"

project = get_loaded_projects()[0]
deploy_result = []

# POOL_OWNER = "0xeCb456EA5365865EbAb8a2661B0c503410e9B347"  # PoolProxy
# GAUGE_OWNER = "0x519AFB566c05E00cfB9af73496D00217A630e4D5"  # GaugeProxy
def deployToken(coins):
    tokens = []
    erc20_deployer = getattr(project, "Token")
    for coin in coins:
        result = erc20_deployer.deploy(coin["name"], coin["name"], coin["decimals"], 100000000, _tx_params())
        tokens.append(result)
        deploy_result.append("%s address: %s" %(coin["name"], result))
    return tokens

def deployDavos():
    erc20_deployer = getattr(project, "Token")
    davos = erc20_deployer.deploy("DAVOS", "DAVOS", 100000000, _tx_params())

    deploy_result.append("%s address: %s" %("Davos", davos))

    farm_deployer = getattr(project, "Farm")
    farm = farm_deployer.deploy(davos, _tx_params())
    deploy_result.append("%s address: %s" %("Farm", farm))

    lp = "0x305DF5070840F852Aa8a83B97e0AFAe8A6d9AA49";
    farm.setWeights([lp], [1], _tx_params())
    davos.approve(farm, 1e27, _tx_params())
    farm.addReward(1000 * 1e18, 86400 * 18, _tx_params())

    for result in deploy_result:
        print(result)

def _tx_params():
    return {
        "from": DEPLOYER,
        "required_confs": REQUIRED_CONFIRMATIONS
        # "gas_price": GasNowScalingStrategy("standard", "fast"),
    } 


def main():
    deployDavos()
    return

    balance = DEPLOYER.balance()

    # load data about the deployment from `pooldata.json`
    contracts_path = project._path.joinpath("contracts/pools")
    with contracts_path.joinpath(f"{POOL_NAME}/pooldata.json").open() as fp:
        pool_data = json.load(fp)

    swap_name = next(i.stem for i in contracts_path.glob(f"{POOL_NAME}/StableSwap*"))
    swap_deployer = getattr(project, swap_name)
    token_deployer = getattr(project, pool_data.get("lp_contract"))

    # if NEED_DEPLOY_TOKEN:
    #     underlying_coins = deployToken(pool_data["coins"])
    # else:
    underlying_coins = [i["underlying_address"] for i in pool_data["coins"]]
    # print("underlying_coins", underlying_coins)
    wrapped_coins = [i.get("wrapped_address", i["underlying_address"]) for i in pool_data["coins"]]

    base_pool = None
    if "base_pool" in pool_data:
        with contracts_path.joinpath(f"{pool_data['base_pool']}/pooldata.json").open() as fp:
            base_pool_data = json.load(fp)
            base_pool = base_pool_data["swap_address"]

    # deploy the token
    token_args = pool_data["lp_constructor"]
    print(1, token_args["name"], token_args["symbol"]);
    print(_tx_params())
    print(token_args, pool_data.get("lp_contract"))
    token = token_deployer.deploy(token_args["name"], token_args["symbol"], _tx_params())
    deploy_result.append("%s address: %s" %(pool_data.get("lp_contract"), token))

    # deploy the pool
    abi = next(i["inputs"] for i in swap_deployer.abi if i["type"] == "constructor")
    args = pool_data["swap_constructor"]
    args.update(
        _coins=wrapped_coins,
        _underlying_coins=underlying_coins,
        _pool_token=token,
        _base_pool=base_pool,
        _owner=POOL_OWNER,
    )
    deployment_args = [args[i["name"]] for i in abi] + [_tx_params()]

    swap = swap_deployer.deploy(*deployment_args)
    deploy_result.append("StableSwapPool1 address: %s" %swap)
    # set the minter
    token.set_minter(swap, _tx_params())

    # deploy the liquidity gauge
    # LiquidityGaugeV3 = load_project("curvefi/curve-dao-contracts@1.2.0").LiquidityGaugeV3
    # LiquidityGaugeV3.deploy(token, MINTER, GAUGE_OWNER, _tx_params())

    # deploy the zap
    zap_name = next((i.stem for i in contracts_path.glob(f"{POOL_NAME}/Deposit*")), None)
    if zap_name is not None:
        zap_deployer = getattr(project, zap_name)

        abi = next(i["inputs"] for i in zap_deployer.abi if i["type"] == "constructor")
        args = {
            "_coins": wrapped_coins,
            "_underlying_coins": underlying_coins,
            "_token": token,
            "_pool": swap,
            "_curve": swap,
        }
        deployment_args = [args[i["name"]] for i in abi] + [_tx_params()]

        zap_deployer.deploy(*deployment_args)

    # deploy the rate calculator
    rate_calc_name = next(
        (i.stem for i in contracts_path.glob(f"{POOL_NAME}/RateCalculator*")), None
    )
    if rate_calc_name is not None:
        rate_calc_deployer = getattr(project, rate_calc_name)
        rate_calc_deployer.deploy(_tx_params())

    print(f"Gas used in deployment: {(balance - DEPLOYER.balance()) / 1e18:.4f} ETH")
    for result in deploy_result:
        print(result)
