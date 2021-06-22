const Wallet = artifacts.require("Wallet");

module.exports = async function (deployer, _network, [acct1, acct2, acct3, ..._]) {
  await deployer.deploy(Wallet, [acct1, acct2, acct3], 2);
  const wallet = Wallet.deployed();
};
