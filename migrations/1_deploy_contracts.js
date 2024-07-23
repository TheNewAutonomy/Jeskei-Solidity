const ConvertLib = artifacts.require("ConvertLib");
const JAKReferenceCoin = artifacts.require("JAKReferenceCoin");
const JeskeiAsset = artifacts.require("JeskeiAsset");
const JeskeiAccount = artifacts.require("JeskeiAccount");
const JeskeiStudio = artifacts.require("JeskeiStudio");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, JAKReferenceCoin);
  deployer.deploy(JAKReferenceCoin);
  deployer.deploy(JeskeiAsset);
  deployer.deploy(JeskeiAccount);
  deployer.deploy(JeskeiStudio);
};
