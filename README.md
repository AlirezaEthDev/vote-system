# Vote System Contract
# Overview

This is a Solidity contract for a vote system. It allows for the creation of candidates, setting of voting periods, and casting of votes. The contract includes several functions for managing the vote system, including adding candidates, setting the voting period, and counting votes.

# Key Features

Candidate Management: The contract allows for the addition of candidates with their names, IDs, and vote IDs.

Voting Period Management: The contract allows for the setting of a start and end time for the voting period.

Vote Cast: The contract allows for the casting of votes by eligible voters.

Vote Count: The contract includes a function for counting the votes and returning the results.

Vote Validate: The vote of each eligible voter, signed by the trusted account, is verified by the contract. The contract uses the functions of ERC-1271 to validate the signature, determining whether the voter is eligible or not. If eligible, the contract counts the vote; otherwise, the vote is ignored.

Only EOA: This vote system is designed to only allow externally owned accounts (EOAs) to participate in voting. Smart contracts are not permitted to cast votes.

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

`Trusted Account`: Trusted account is the election organizer and observer. It also checks whether the voter is eligible (allowed to vote) or not. Moreover, this account is responsible for adding candidates, setting the voting period, and managing the vote counting process. The contract requires it to manage the vote system.

# Key Protocol

Vote Validation:

The protocol of vote validation is based on ERC-1271 and involves the following steps:

1) Signature Generation:
   * The trusted account generates a signature using its Ethereum private key for each vote that it detects the voter is eligible (allowed to vote).
   * The signature is sent back along with the vote to the voter.
   * The voter sends the signed vote to the contract.
2) Signature Verification:
   * The `isValidSignature()` function in the `VoteLibrary` (called by `voteTo()` function in `VoteSystem` contract at the voting time) checks if the signature provided with a vote matches the trusted account's signature.
   * If the signature is valid, the function returns a specific magic value (`0x1626ba7e`) and that means the voter is eligible.
   * If the magic value returned, contract increments the vote count for the corresponding candidate.
3) Revote Prevention:
   * The `voteTo()` function in the `VoteSystem` contract checks if the voter has not voted before (using the `revoteCheck` mapping).
   * If the voter has already voted, the function prevents them from voting again.
        

# License

This contract is licensed under the MIT License. Please note that this README file is a basic template and may need to be customized to fit the specific needs of your project.



