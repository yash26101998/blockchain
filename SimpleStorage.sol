// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;// we can only use compiler version above this

// pragma solidity ^0.8.0;
// pragma solidity >=0.8.0 <0.9.0;

contract SimpleStorage {// way to declare a contract

    uint256 favoriteNumber;//This will not show after deployment as there is no public keyword attached to it.

    struct People { // we created a object here
        uint256 favoriteNumber;
        string name;
    }
    // uint256[] public anArray;
    People[] public people;//People is used as datatype

    mapping(string => uint256) public nameToFavoriteNumber;//it is like a dictionary key value pairs are used

    function store(uint256 _favoriteNumber) public {//_favoriteNumber is a parameter need to be passed at the time of deployment
        favoriteNumber = _favoriteNumber;
    }
    
    function retrieve() public view returns (uint256){//function will not consume gas as we have used view
        return favoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));//pushing favoritnumber and name i array
        nameToFavoriteNumber[_name] = _favoriteNumber;//assigning name as key and favorite number as value.
    }
}