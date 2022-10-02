// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";//this is a github file to get price conversion

// Why is this a library and not abstract?
// Why not an interface?
library PriceConverter {//creating a library to use in fund me
    // We could make this public, but then we'd have to deploy it
    function getPrice() internal view returns (uint256) {//internal keyword is used in library
        // Goerli ETH / USD Address
        // https://docs.chain.link/docs/ethereum-addresses/
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e//address is copied from chainlink website in ethereum data feeds
        );
        (, int256 answer, , , ) = priceFeed.latestRoundData();//AggregatorV#interface file function
        // ETH/USD rate in 18 digit
        return uint256(answer * 1e18);//to convert into wei
    }

    // 1000000000
    function getConversionRate(uint256 ethAmount)
        internal
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;//two wei will give us 36 zeros and we want it in usd so divison
        // the actual ETH/USD conversion rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }
}
