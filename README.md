# Vote System Contract
# Overview

This is a Solidity contract for a vote system. It allows for the creation of candidates, setting of voting periods, and casting of votes. The contract includes several functions for managing the vote system, including adding candidates, setting the voting period, and counting votes.

# Key Features

Candidate Management: The contract allows for the addition of candidates with their names, IDs, and vote IDs.

Voting Period Management: The contract allows for the setting of a start and end time for the voting period.

Vote Casting: The contract allows for the casting of votes by eligible voters.

Vote Counting: The contract includes a function for counting the votes and returning the results.

# Usage

To use this contract, you will need to deploy it to a blockchain network such as Ethereum. You can then interact with the contract using a web3-enabled client such as MetaMask.

# Contract Structure

Library:
A library for managing vote counting and validation functions.

Interface (Not developed yet):
An interface defining the required functions for a voting contract.

Main Contract:
A contract implementing the voting interface and utilizing the library for counting votes.
          
# Project Description:

Library: 

`VoteLibrary` contains structs for voters and candidates, along with functions for validating candidates and processing votes.

Interface (Not developed yet):

`IVotingSystem` defines the required functions for a voting system contract.

Main Contract:

`VotingSystem` implements the voting interface, manages voters and candidates, and uses the library functions for voting logic.

# Library

 Functions:

The `VoteLibrary` library contains three functions:
1) `voteCounter(VoteCounting[] calldata countResult)`:
   * This function takes an array of VoteCounting structs as input.
   * It sorts the vote counts in ascending order.
   * The sorted array is returned.
2) `isValidSignature(bytes32 hashOfVote, bytes calldata signatureOfTrustedAccount)`:
   * This function takes a hash of a vote and a signature from the trusted account as input.
   * It recovers the signer's address from the signature.
   * If the recovered address matches the trusted account, it returns a specific magic value (`0x1626ba7e`). Otherwise, it returns `0xffffffff`.
3) `recoverSignature(bytes32 hashOfVote, bytes memory signatureOfTrustedAccount)`:
   * This function takes a hash of a vote and a signature from the trusted account as input.
   * It validates the signature by checking its length, the `s` value, and the `v` value.
   * If the signature is valid, it recovers the signer's address from the signature.
   * The function returns the recovered signer's address.

# Smart Contract

Functions:

`addCandidateList()`: Adds a list of candidates to the contract.

`viewList()`: Returns the details of a specific candidate.

`setVotePeriod()`: Sets the start and end times for the voting period.

`voteTo()`: Casts a vote for a specific candidate.

`countVote()`: Returns the vote count for each candidate.

****************************************************************

Events: 

`NewCandidateAdded`: Triggered when a new candidate is added to the contract.

`VotePeriodUpdate`: Triggered when the voting period is updated.

`NewVoteTo`: Triggered when a vote is cast.

*****************************************************************

Requirements:

`Trusted Account`: The contract requires a trusted account to manage the vote system. This account is responsible for adding candidates, setting the voting period, and managing the vote counting process.

# License

This contract is licensed under the MIT License. Please note that this README file is a basic template and may need to be customized to fit the specific needs of your project.



