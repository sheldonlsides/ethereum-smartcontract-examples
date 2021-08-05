// SPDX-License-Identifier: MIT

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