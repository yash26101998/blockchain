// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;

    // Could we make this constant?  /* hint: no! We should make it immutable! */
    //address public /* immutable */ i_owner;
    uint256 public constant MINIMUM_USD = 50 * 1e18;//constant keyword is used to become gas efficient as the value throughout the contract remain same
    //instead of storing it into storage it stre it into byte code of contract
    

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "You need to spend more ETH!");//.getconversion rate is from the library
        // require(PriceConverter.getConversionRate(msg.value) >= MINIMUM_USD, "You need to spend more ETH!");//value is amound they sent
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);//sender is adress of the payer
    }
    
    function getVersion() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        return priceFeed.version();

    }
    //we only want to send money to the owner of the contract or the person who deployed the contract
    //function callmerightaway{}//we can use a function but now it needs to execution so we can use a constructor
    address public immutable i_owner;//immutable is used to be gas efficient
    //instead of storing it into storage it stre it into byte code of contract
    //imutable and constant variable cant be changed later

    constructor(){//constructor is like a function it is called when you deploy a contract
        i_owner=msg.sender; 
    }
    
    function withdraw() public onlyOwner {//only Owner represents the that call the modifier
    //it is gonna be orange because from this i am gaining ethereum
        //require(msg.sender==owner,"sender is not owner")//if we want to use this line of code at multiple places we can use modifiers    

        for(uint256 funderIndex=0; funderIndex<funders.length;funderIndex++){
            address funder=funders[funderIndex];
            addressToAmountFunded[funder]=0; 
        }
        //we need to reset the array to make funders a blank arraya as i am withdrawing
        //initialising a completely new array with 0 objects
        funders=new address [](0);//0 mentions no of objects
        //three ways to withdraw fund transfer,send,call

        //1. Transfer
        //msg.sender.transfer(address(this).balance);//this keyword is used for the whole contract
        //msg.sender is adsress type but we need a payable address so we add payble keyword
        payable(msg.sender).transfer(address(this).balance);

        //2.Send:This returns a bool
        //payable(msg.sender).send(address(this).balance);//but we want it to give an error if my txn is not succesfull
        bool sendSuccess=payable(msg.sender).send(address(this).balance);
        require(sendSuccess,"send failed!");
        ///Transfer and send have capped gas(2300) wheras call does not have a capped gas

        //3. call it returns two thing and a bool and data from function called 
        (bool callSuccess,)=payable(msg.sender).call{value: address(this).balance}("");//paranthesis is for function call
        require(callSuccess,"call Failed!");//(call is the recommended way to send the ethereum)
    }
    
    modifier onlyOwner{
        //require(msg.sender==i_owner,"sender is not owner");//we have to store the string that is gas inefficent so we will use error
        if(msg.sender!=i_owner){revert NotOwner();}
        _;//_ represents  execute the above line first and then the rest of code in withdraw function

    }
    // what if someone sends it eth without calling the fund function just sending through metamask

    receive() external payable{
        fund();
    }

    fallback() external payable{
        fund();
    }

    
    
    }