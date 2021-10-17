import {
  MarketInstance,
  RealSkullsInstance,
  SkullTokenInstance,
  MockTokenInstance,
} from "../types/truffle-contracts";
import {abi as RealSkullsABI} from "../client/src/contracts/RealSkulls.json";
import {shouldThrowAsync} from "./utils";

contract("Market", (accounts) => {
  const mainOwner = accounts[0];
  const RealSkulls = artifacts.require("RealSkulls");
  const Market = artifacts.require("Market");
  const SkullToken = artifacts.require("SkullToken");
  const MockToken = artifacts.require("MockToken");

  let market: MarketInstance,
    realSkulls: RealSkullsInstance,
    token: SkullTokenInstance,
    mock: MockTokenInstance;

  before(async () => {
    const instances = await Promise.all([
      Market.deployed(),
      SkullToken.deployed(),
      MockToken.deployed(),
    ]);
    market = instances[0];
    token = instances[1];
    mock = instances[2];
    const realSkullsAddress = await market.realSkullsContract();
    realSkulls = new web3.eth.Contract(
      RealSkullsABI as unknown as AbiItem,
      realSkullsAddress
    ) as unknown as RealSkullsInstance;
    await token.transfer(market.address, 10000000);
  });

  it("Should set and get prices accordingly", async () => {
    const price = "100";
    await market.setPrice(SkullToken.address, price);
    const priceGet = await market.getPrice(SkullToken.address);
    assert.equal(price, priceGet.toString());
  });

  it("Should mint tokens for a price and give nft+tokens", async () => {
    const price = 100;
    const amount = 10;
    const buyer = accounts[2]

    await mock.transfer(buyer, price * amount);
    await mock.approve(market.address, price * amount, {from: buyer});
    await market.setPrice(mock.address, price);
    await market.mint(mock.address, 10, {from: buyer});
    const [buyerBalance, tokenGiven, contractBalance] = await Promise.all([
      token.balanceOf(buyer),
      market.tokenForRealSkulls(),
      mock.balanceOf(market.address),
    ]);

    assert.equal(buyerBalance.toString(), tokenGiven.toString());
    assert.equal(contractBalance.toString(), String(price * amount));
  });

  it("Should not retrieve nonexistent price", async () => {
    const price = "100";
    await market.setPrice(SkullToken.address, price);
    shouldThrowAsync(market.getPrice(accounts[1]));
  });
});
