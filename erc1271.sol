// SPDX-License-Identifier: MIT`

pragma solidity ^0.5.12;

contract erc1271{

    address constant public owner = 0xF3ca7784b075Bbc683Aaeb18C11E47E5ee3f3350;
    bytes4 constant internal MAGICVALUE = 0x1626ba7e;

    function isValidSignature( bytes32 _hash , bytes calldata _signature ) external view returns ( bytes4 ){

        address signer = recoverSignature( _hash , _signature );

        if( signer == owner ){

            return 0x1626ba7e;

        }else{

            return 0xffffffff;

        }

    }

    function recoverSignature( bytes32 _hash , bytes memory _signature ) public pure returns( address ){

        require( _signature.length == 65 , "Signature length is not valid!" );

        uint8 v = uint8( _signature[ 64 ] );
        bytes32 r;
        bytes32 s;

        assembly {

            r := mload( add( _signature , 0x20 ) )
            s := mload( add( _signature , 0x40 ) )

        }

        require( uint256( s ) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0 ,
                    " The 's' value of the signature is not valid! " );
        require( v == 27 || v == 28 , " The 'v' value of the signature is not valid! " );

        address signer = ecrecover( _hash , v , r , s );

        require( signer != address( 0x0 ) , " The signer address is not valid! " );

        return signer;

    }

}