// SPDX-License-Identifier: MIT`

pragma experimental ABIEncoderV2;

pragma solidity ^0.5.12;

library voteLibrary{

    struct voteCounting{

        uint8 voteID;
        uint voteCount;

    }

    function voteCounter( voteCounting[] memory countResult ) external view returns( uint ) {

        return countResult.length;

    }

}

contract voteSystem{

    address constant public trustedAccount = 0xF3ca7784b075Bbc683Aaeb18C11E47E5ee3f3350; //This address can change for each project using this contract!
    uint public startOfVotePeriod;
    uint public endOfVotePeriod;

    event newCandidateAdded( string fullname , uint40 id , uint8 voteID );
    event votePeriodUpdate( uint startAt , uint endAt );
    event newVoteTo( bytes votedCandidate , uint candidatesVoteID , address voter );

    struct candidate{

        bytes firstname;
        bytes lastname;
        uint40 id;
        uint8 voteID;
        uint voteCount;

    }

    mapping( uint8 => candidate ) private candidateList;

    modifier onlyTrustedAccount( address accountAddress ) {

        require( trustedAccount == accountAddress , "Just the trusted account has access to do this task!" );
        _;

    }

    constructor( candidate[] memory listOfCandidates ) public {

        require( tx.origin == trustedAccount , "Just the trusted account can deploy vote system!");
        for ( uint i = 0 ; i < listOfCandidates.length ; i++ ){

            candidateList[listOfCandidates[i].voteID] = candidate( listOfCandidates[i].firstname , listOfCandidates[i].lastname , listOfCandidates[i].id , listOfCandidates[i].voteID , listOfCandidates[i].voteCount );

            emit newCandidateAdded( string( abi.encodePacked( listOfCandidates[i].firstname , listOfCandidates[i].lastname ) ) , listOfCandidates[i].id , listOfCandidates[i].voteID );

        }

    }

    function viewList( uint8 candidateVoteID) external view returns( candidate memory ){

        return ( candidateList[ candidateVoteID ] );

    }

    function setVotePeriod( uint startTime , uint endTime ) external onlyTrustedAccount( msg.sender ) {

        require( startOfVotePeriod == 0 || block.timestamp < startOfVotePeriod , "Reset the vote period is not allowed!" );
        
        startOfVotePeriod = startTime;
        endOfVotePeriod = endTime;

        emit votePeriodUpdate( startOfVotePeriod , endOfVotePeriod );

    }

    function voteTo( uint8 candidateVoteID ) external {

        require( block.timestamp >= startOfVotePeriod && block.timestamp =< endOfVotePeriod , "Out of vote period!" );
        
        uint codeSize;

        assembly {

            codeSize := extcodesize( msg.sender );

        }

        if( codeSize == 0){

            candidateList[ candidateVoteID ].voteCount++;

            emit newVoteTo( abi.encodePacked( candidateList[ candidateVoteID ].firstname , candidateList[ candidateVoteID ].lastname ) ,
                            candidateList[ candidateVoteID ].voteID , msg.sender );

        }else{

            revert( "Smart contract is not allowed to vote!" );

        }

    }

//    function voteCounting(  )

}