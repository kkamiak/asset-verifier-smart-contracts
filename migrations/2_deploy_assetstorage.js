var AssetStorage = artifacts.require("./AssetStorage.sol");

module.exports = function(deployer, network) {
    deployer.deploy(AssetStorage);
};
