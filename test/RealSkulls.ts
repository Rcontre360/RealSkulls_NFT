import {RealSkullsInstance} from '../types/truffle-contracts'


contract("RealSkulls", accounts => {

  const mainOwner = accounts[0]
  const RealSkulls = artifacts.require("RealSkulls");
  const Market = artifacts.require("Market");
  const SkullToken = artifacts.require("SkullToken");
  let rs: RealSkullsInstance;

  beforeEach(async () => {
    rs = await RealSkulls.deployed()
  })

  it("Should initialize properly", async () => {

  })

  it("Should mint various nfts at once", async () => {
    const receiver = accounts[2];
    const amount = 10;

    await rs.mint(receiver, amount);
    const currentId = await rs.currentId();
    assert.equal(currentId.toString(), String(amount));
  })

  it("Should record correct balances", async () => {
    const amount = 10;
    const supply: Promise<BN>[] = []
    for (let i = 0; i < amount; i++)
      supply.push(rs.getSupply(i));

    const res = await Promise.all(supply)
    assert.deepEqual(res.map(r => r.toString()), (new Array(10).fill('1')))
  })

})
