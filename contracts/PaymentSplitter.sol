//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./TokenInterface.sol";

contract PaymentSplitter is Ownable{

    address[] public tokenContracts;
    address payable[] public wallets;

    function addTokenAddress(address tokenContract) external onlyOwner{
        tokenContracts.push(tokenContract);
    } 

    function addWalletAddress(address payable walletAddress) external onlyOwner{
        wallets.push(walletAddress);
    } 

    function hasBalance(address tokenContract) public view returns(bool){
        uint256 balance = TokenInterface(tokenContract).balanceOf(msg.sender);
        if(balance > 0){
            return true;
        }else{
            return false;
        }
    }

    function withdrawToken(address tokenContract) internal {
       
        uint256 balance = TokenInterface(tokenContract).balanceOf(msg.sender);
        uint256 payPerPerson = balance / wallets.length;

        for(uint256 i = 0; i < wallets.length; ++i){
            TokenInterface(tokenContract).transfer(wallets[i], payPerPerson);
        }
    }

    function withdraw() external{
        
        for(uint256 i = 0; i < tokenContracts.length; ++i){
            if(hasBalance(tokenContracts[i])){
                withdrawToken(tokenContracts[i]);
            }
        }

        uint256 balance = address(this).balance;
        uint256 payPerPerson = balance / wallets.length;

        for(uint256 i = 0; i < wallets.length; ++i){
            wallets[i].transfer(payPerPerson); 
        }       
    }
}