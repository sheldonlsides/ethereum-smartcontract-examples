// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

contract MyContract {
    string public myString = 'hello world';
    
    constructor(string memory name) {
        myString = name;
    }
    
    function setString(string memory str) public {
        myString = str;
    }
}