import {RealSkullsContract, MarketContract} from "../types/truffle-contracts";

type Network = "develop" | "ropsten" | "mainnet";


const migrateFunction3 = (artifacts: Truffle.Artifacts, web3: Web3) => {
  const RealSkulls = artifacts.require("RealSkulls");
  const Market = artifacts.require("Market");
  const SkullToken = artifacts.require("SkullToken");
  return async (
    deployer: Truffle.Deployer,
    network: Network,
    accounts: string[]
  ) => {
    await deployer.deploy(RealSkulls);
    await deployer.deploy(SkullToken);
    await deployer.deploy(Market, RealSkulls.address);
  };
};

module.exports = migrateFunction3;
