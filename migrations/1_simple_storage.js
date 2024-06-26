const AgriDataMarketplaceMock = artifacts.require("AgriDataMarketplaceMock");
const fixedPrice = web3.utils.toWei('1', 'ether'); // Adjust to a sensible value

module.exports = function(deployer) {
    deployer.deploy(AgriDataMarketplaceMock, fixedPrice);
};
