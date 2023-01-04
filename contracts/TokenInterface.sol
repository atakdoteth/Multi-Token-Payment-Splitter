//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

abstract contract TokenInterface {
    function balanceOf(address account) virtual external view returns (uint256);
    function transfer(address to, uint256 amount) virtual external returns (bool);
    function transferFrom(address from,address to,uint256 amount) virtual external returns (bool);
}