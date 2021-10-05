var property = artifacts.require("./PropertyTransfer.sol");
module.exports = function(deployer)
{
    deployer.deploy(property);
}