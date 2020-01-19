pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, TimedCrowdsale {

    constructor(
        uint rate, // rate in TKNbits
        uint goal, // token minimum goal, in wei
        address payable wallet, // sale bene wallet for Ether
        PupperCoin token // the PupperCoin that the token sale will work with
        uint openingTime, // opening time in unix epoch seconds
        uint closingTime // clsoing time in unix epoch seconds
    )
        RefundableCrowdsale(goal)
        Crowdsale(rate, wallet, token)
        TimeCrowdsale(openingTime, closingTime)
        public
    {
        // this is a crowdsale that is only open for a
        // certain amount of time and 
        // will refund the money if we dont hit the goal
        
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet // this address receives the ETH from the sale
    )
        public
    {
        // create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);

        // create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        PupperCoinSale pupper_sale = new PupperCoinSale(1, wallet, token);
        pupper_sale_address = address(pupper_sale);
        uint goal != 0;

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
