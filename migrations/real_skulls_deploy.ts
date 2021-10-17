import {RealSkullsContract, MarketContract} from "../types/truffle-contracts";

type Network = "develop" | "ropsten" | "mainnet";


const migrateFunction3 = (artifacts: Truffle.Artifacts, web3: Web3) => {
  const RealSkulls = artifacts.require("RealSkulls");
  const Market = artifacts.require("Market");
  const SkullToken = artifacts.require("SkullToken");
  const MockToken = artifacts.require("MockToken");
  return async (
    deployer: Truffle.Deployer,
    network: Network,
    accounts: string[]
  ) => {
    await deployer.deploy(MockToken);
    await deployer.deploy(SkullToken);
    await deployer.deploy(Market, SkullToken.address, 10);
    await deployer.deploy(RealSkulls, Market.address);
  };
};

module.exports = migrateFunction3;
