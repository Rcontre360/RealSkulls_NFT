

contract("SimpleStorage", accounts => {

  const mainOwner = accounts[0]
  const RealSkulls = artifacts.require("RealSkulls");
  const Market = artifacts.require("Market");
  const SkullToken = artifacts.require("SkullToken");

  it("Should initialize properly", async () => {

  })

  it("Should mint various nfts at once", async () => {
    let rs = await RealSkulls.deployed();
    const idsToMint = [123213213, 34234234, 3424232342]
    const amounts = [1000, 1, 1]
    const balances = [] as Promise<BN>[]

    await rs.mint(mainOwner, idsToMint, amounts);
    idsToMint.forEach(async (id) => {
      balances.push(rs.balanceOf(mainOwner, id));
    });

    const res = await Promise.all(balances)
    res.forEach((balance, i) => {
      console.log(balance.toString(), amounts[i])
      assert.equal(balance.toString(), String(amounts[i]));
    })
  })

})
