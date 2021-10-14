import {MarketInstance, RealSkullsInstance} from '../types/truffle-contracts'
import {shouldThrowAsync} from './utils'

contract("Market", accounts => {

  const mainOwner = accounts[0]
  const RealSkulls = artifacts.require("RealSkulls");
  const Market = artifacts.require("Market");
  const SkullToken = artifacts.require("SkullToken");

  let market: MarketInstance, realSkulls: RealSkullsInstance;

  beforeEach(async () => {
    const instances = await Promise.all([
      Market.deployed(),
      RealSkulls.deployed(),
    ])
    market = instances[0];
    realSkulls = instances[1];
  })

  it("Should initialize properly", async () => {
    const realSkullsAddress = await market.realSkullsAddress()
    assert.equal(realSkullsAddress, RealSkulls.address);
  });

  it("Should set and get prices accordingly", async () => {
    const price = '100'
    await market.setPrice(1, SkullToken.address, price);
    const priceGet = await market.getPrice(1, SkullToken.address);
    assert.equal(price, priceGet.toString());
  })

  it("Should not retrieve nonexistent price", async () => {
    const price = '100'
    await market.setPrice(1, SkullToken.address, price);
    shouldThrowAsync(market.getPrice(1, accounts[1]))
  })

  it("Should mint and buy tokens", async () => {
  })
})

