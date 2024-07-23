const JAKReferenceCoin = artifacts.require("JAKReferenceCoin");

contract('JAKReferenceCoin', (accounts) => {
  it('should put 10000 JAKReferenceCoin in the first account', async () => {
    const jakReferenceCoinInstance = await JAKReferenceCoin.deployed();
    const balance = await jakReferenceCoinInstance.getBalance.call(accounts[0]);

    assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
  });
  it('should call a function that depends on a linked library', async () => {
    const jakReferenceCoinInstance = await JAKReferenceCoin.deployed();
    const jakCoinBalance = (await jakReferenceCoinInstance.getBalance.call(accounts[0])).toNumber();
    const jakCoinEthBalance = (await jakReferenceCoinInstance.getBalanceInEth.call(accounts[0])).toNumber();

    assert.equal(jakCoinEthBalance, 2 * jakCoinBalance, 'Library function returned unexpected function, linkage may be broken');
  });
  it('should send coin correctly', async () => {
    const jakReferenceCoinInstance = await JAKReferenceCoin.deployed();

    // Setup 2 accounts.
    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    // Get initial balances of first and second account.
    const accountOneStartingBalance = (await jakReferenceCoinInstance.getBalance.call(accountOne)).toNumber();
    const accountTwoStartingBalance = (await jakReferenceCoinInstance.getBalance.call(accountTwo)).toNumber();

    // Make transaction from first account to second.
    const amount = 10;
    await jakReferenceCoinInstance.sendCoin(accountTwo, amount, { from: accountOne });

    // Get balances of first and second account after the transactions.
    const accountOneEndingBalance = (await jakReferenceCoinInstance.getBalance.call(accountOne)).toNumber();
    const accountTwoEndingBalance = (await jakReferenceCoinInstance.getBalance.call(accountTwo)).toNumber();

    assert.equal(accountOneEndingBalance, accountOneStartingBalance - amount, "Amount wasn't correctly taken from the sender");
    assert.equal(accountTwoEndingBalance, accountTwoStartingBalance + amount, "Amount wasn't correctly sent to the receiver");
  });
});
