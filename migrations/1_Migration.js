
const voteSystem = artifacts.require("./VoteSystem.sol");
const voteLibrary = artifacts.require("./VoteLibrary.sol");

module.exports = function(deployer) {
  deployer.deploy(voteLibrary);
  deployer.link(voteLibrary, voteSystem);
  deployer.deploy(voteSystem);
}
