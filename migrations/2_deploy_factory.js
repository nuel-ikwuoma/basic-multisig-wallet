const WalletFactory = artifacts.require("WalletFactory");

const network = "development";
module.exports = function (deployer, network) {
  deployer.deploy(WalletFactory);
};
