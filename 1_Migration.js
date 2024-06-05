
const voteSystem = artifacts.require("./voteSystem.sol");
const voteLibrary = artifacts.require("./voteLibrary.sol");

module.exports = function(deployer) {

  const candidate1 = {

    firstname : Buffer.from( "Alireza" , "utf-8" ),
    lastname : Buffer.from( "Kiakojouri" , "utf-8" ),
    id : 3657700005,
    voteID : 1,
    voteCount : 0

  }

  const candidate2 = {

    firstname : Buffer.from( "Babak" , "utf-8" ),
    lastname : Buffer.from( "Arjmand" , "utf-8" ),
    id : 856325654,
    voteID : 2,
    voteCount : 0

  }

  const candidate3 = {

    firstname : Buffer.from( "Pedram" , "utf-8" ),
    lastname : Buffer.from( "Nazeri" , "utf-8" ),
    id : 8754553465,
    voteID : 3,
    voteCount : 0
    
  }

  const listOfCandidates = [ candidate1 , candidate2 , candidate3 ];

  deployer.deploy( voteLibrary );
  deployer.link( voteLibrary , voteSystem );
  deployer.deploy( voteSystem , listOfCandidates );

}