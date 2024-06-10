// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library VoteLibrary{
    // Constants
    address constant public TRUSTED_ACCOUNT = 0xF3ca7784b075Bbc683Aaeb18C11E47E5ee3f3350;
    bytes4 constant public MAGIC_VALUE = 0x1626ba7e;

    // Structs
    struct VoteCounting{
        uint8 voteID;
        uint voteCount;
    }

    // Functions
    function voteCounter(VoteCounting[] calldata countResult) external view returns(VoteCounting[] memory) {
        // Sort the vote counts
        VoteCounting[] memory sortedCountResult = new VoteCounting[](countResult.length);// Calldata array is read-only. So we need to use another array instead countResult!
        for (uint i = 0 ; i < countResult.length ; i++) {
            sortedCountResult[i] = countResult[i];
        }
        VoteCounting memory tempCounting;
        for (uint i = 0 ; i < sortedCountResult.length ; i++) {
            for (uint j = i + 1 ; j < sortedCountResult.length ; j++) {
                if (sortedCountResult[i].voteCount < sortedCountResult[j].voteCount) {
                    tempCounting = sortedCountResult[i];
                    sortedCountResult[i] = sortedCountResult[j];
                    sortedCountResult[j] = VoteCounting(tempCounting.voteID, tempCounting.voteCount);
                }
            }
        }
        return sortedCountResult;
    }
    
    function isValidSignature(bytes32 hash, bytes calldata signature) external view returns (bytes4) {
        address signer = recoverSignature(hash, signature);
        if (signer == TRUSTED_ACCOUNT) {
            return 0x1626ba7e;
        }else{
            return 0xffffffff;
        }
    }

    function recoverSignature(bytes32 hash, bytes memory signature) public pure returns(address) {
        // Is signature an Ethereum signature
        require(signature.length == 65 , "01");//01: Signature length is not valid!

        // Validate the provided Ethereum signature (signature)
        uint8 v = uint8( signature[ 64 ] );
        bytes32 r;
        bytes32 s;
        assembly {
            r := mload( add( signature , 0x20 ) )
            s := mload( add( signature , 0x40 ) )
        }
        require(uint256( s ) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
                    "02");// 02: The 's' value of the signature is not valid!
        require(v == 27 || v == 28, "03");// 03: The 'v' value of the signature is not valid!

        // Recover the signer's address from the signature
        address signer = ecrecover(hash, v, r, s);

        // Validate the structure of the recovered address
        require( signer != address( 0x0 ), "04");// 04: The signer address is not valid!
        return signer;
    }
}

contract VoteSystem{
    // Constants
    address constant public TRUSTED_ACCOUNT = 0xF3ca7784b075Bbc683Aaeb18C11E47E5ee3f3350; // This address can change for each project using this contract!
    uint public startOfVotePeriod;
    uint public endOfVotePeriod;
    uint public candidateCounter=0;

    // Structs
    struct Candidate{
        bytes firstname;
        bytes lastname;
        uint40 id;
        uint8 voteID;
        uint voteCount;
    }

    // Events
    event NewCandidateAdded(bytes fullname, uint40 id, uint8 voteID);
    event VotePeriodUpdate(uint startAt, uint endAt);
    event NewVoteTo(bytes votedCandidate, uint candidatesVoteID, address voter);

    // Mappings
    mapping(uint8 => Candidate) private candidateList;
    mapping(address => bool) private revoteCheck;

    // Modifiers
    modifier onlyTrustedAccount(address accountAddress) {
        require( TRUSTED_ACCOUNT == accountAddress, "05" );// 05: Just the trusted account has access to do this task!
        _;
    }

    // Functions
    function addCandidateList(Candidate[] calldata listOfCandidates) external onlyTrustedAccount(msg.sender) {
        candidateCounter = 0;
        for (uint i = 0 ; i < listOfCandidates.length ; i++) {
            candidateList[listOfCandidates[i].voteID] = Candidate(listOfCandidates[i].firstname, listOfCandidates[i].lastname, listOfCandidates[i].id, listOfCandidates[i].voteID, listOfCandidates[i].voteCount);
            candidateCounter++;
            emit NewCandidateAdded(abi.encodePacked(listOfCandidates[i].firstname, listOfCandidates[i].lastname), listOfCandidates[i].id, listOfCandidates[i].voteID);
        }
    }

    function viewList(uint8 candidateVoteID) external view returns(Candidate memory) {
        return (candidateList[candidateVoteID]);
    }

    function setVotePeriod(uint startTime, uint endTime) external onlyTrustedAccount(msg.sender) {
        // Ensures that this function is executed before the voting period starts
        require(startOfVotePeriod == 0 || block.timestamp < startOfVotePeriod, "06");// 06: Reset the vote period is not allowed!
        // Sets the start and end times for voting
        startOfVotePeriod = startTime;
        endOfVotePeriod = endTime;
        emit VotePeriodUpdate(startOfVotePeriod, endOfVotePeriod);
    }

    function voteTo(uint8 candidateVoteID, bytes32 voteHash, bytes calldata trustedAccountSignature) external {
        // Ensures that this function only executed during the voting period
        require(startOfVotePeriod!= 0 && block.timestamp >= startOfVotePeriod && block.timestamp <= endOfVotePeriod, "07");// 07: Out of vote period!
        //Validate revote
        require(!revoteCheck[ msg.sender ], "08");// 08: Revoting is not allowed!
        //Validate signature
        bytes4 validationResult = VoteLibrary.isValidSignature(voteHash, trustedAccountSignature);
        require(validationResult == 0x1626ba7e, "09");// 09: You are not an eligible voter!
        //Count the vote
        uint codeSize;
        address msgSender = msg.sender;
        assembly {
            codeSize := extcodesize( msgSender )
        }
        require(codeSize == 0, "10");// 10: Smart contract is not allowed to vote!
        candidateList[candidateVoteID].voteCount++;
        revoteCheck[msg.sender] = true;
        emit NewVoteTo(abi.encodePacked(candidateList[candidateVoteID].firstname, candidateList[candidateVoteID].lastname),candidateList[candidateVoteID].voteID, msg.sender);
    }

    function countVote() external view returns(VoteLibrary.VoteCounting[] memory) {
        // Instantiation of an array with type of the library's struct
        VoteLibrary.VoteCounting[] memory voteCountingArray;
        voteCountingArray = new VoteLibrary.VoteCounting[](candidateCounter);
        for (uint8 i = 0 ; i < candidateCounter ; i++) {
            voteCountingArray[i] = VoteLibrary.VoteCounting(candidateList[i + 1].voteID, candidateList[i + 1].voteCount);
        }
        return VoteLibrary.voteCounter(voteCountingArray);
    }
}