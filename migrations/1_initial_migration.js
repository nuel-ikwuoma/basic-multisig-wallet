const Migrations = artifacts.require("Migrations");

const network = "development";

module.exports = function (deployer, network) {
  deployer.deploy(Migrations);
};
