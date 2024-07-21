const Account = artifacts.require("Account");
const Asset = artifacts.require("Asset");
const Studio = artifacts.require("Studio");

module.exports = function(deployer) {
  deployer.deploy(Account);
  deployer.deploy(Asset);
  deployer.deploy(Studio);
};
