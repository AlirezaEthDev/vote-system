// SPDX-License-Identifier: MIT`

pragma experimental ABIEncoderV2;

pragma solidity ^0.5.12;

library voteLibrary{

    

}

contract voteSystem{

    address constant public trustedAccount = 0xF3ca7784b075Bbc683Aaeb18C11E47E5ee3f3350; //This address can change for each project using this contract!

    event newCandidateAdded( string fullname , uint40 id , uint8 voteID );

    struct candidate{

        bytes firstname;
        bytes lastname;
        uint40 id;
        uint8 voteID;

    }

    mapping( uint8 => candidate ) private candidateList;

    constructor( candidate[] memory listOfCandidates ) public {

        require( tx.origin == trustedAccount , "Just the trusted account can deploy vote system!");
        for ( uint i = 0 ; i < listOfCandidates.length ; i++ ){

            candidateList[listOfCandidates[i].voteID] = candidate( listOfCandidates[i].firstname , listOfCandidates[i].lastname , listOfCandidates[i].id , listOfCandidates[i].voteID );
            emit newCandidateAdded( string( abi.encodePacked( listOfCandidates[i].firstname , listOfCandidates[i].lastname ) ) , listOfCandidates[i].id , listOfCandidates[i].voteID );

        }

    }

    function viewList( uint8 candidateVoteID) external view returns( candidate memory ){

        return (candidateList[ candidateVoteID ]);

    }

}