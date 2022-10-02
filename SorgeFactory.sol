// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.0;

import "./SimpleStorage.sol"; // importing the SimpleStorage.file ./ means this directory

contract StorageFactory {
    
    SimpleStorage[] public simpleStorageArray;
    
    function createSimpleStorageContract() public {//it will create a new simple storage  contract every time
        SimpleStorage simpleStorage = new SimpleStorage();//passing a new SimpleStorage contract everytime as a new object
        simpleStorageArray.push(simpleStorage);//pushing it into apublic array
    }
    
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {// a index and number will pe passed at the time of deployment as argument
        // Address //both of them are needed to deploy the contract
        // ABI //application binary interface
        // SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(_simpleStorageNumber);
        simpleStorageArray[_simpleStorageIndex].store(_simpleStorageNumber);//.store is a function of Simplestorage which we are using here
        //in the array we are using adress and storing our favorite Number at that place if there are 2 contract only o and 1 can be used
        // I have passed _simpleStorageNumber as a argument to parameter of _favoriteNumber
    }
    
    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        // return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrieve();
        return simpleStorageArray[_simpleStorageIndex].retrieve();//using retrive function from simple storage
    }
}