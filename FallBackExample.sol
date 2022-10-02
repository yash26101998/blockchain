//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract FallBackExample{

    uint256 public result;

    receive() external payable{//recive function gets triggered whenever eth is sent to this contract but txn should be without a input data.
        result=1;
         
    }

    fallback() external payable{//if ther is txn with input data the fallback function will get trigered or recive function will be triggered 
        result=2;
    }
}
