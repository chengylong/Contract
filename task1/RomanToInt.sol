// 4.用 solidity 实现罗马数字转数整数
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract RomanToInt{
    mapping(bytes1 => uint) romanMap;
    constructor() {
    romanMap["I"] = 1;
    romanMap["V"] = 5;
    romanMap["X"] = 10;
    romanMap["L"] = 50;
    romanMap["C"] = 100;
    romanMap["D"] = 500;
    romanMap["M"] = 1000;
    }
    function romanToInt (string memory str) public view returns (uint) {
        bytes memory s = bytes(str);
        uint result = 0;
	    uint len = s.length;
        for (uint i =0; i <len; i++) {
            if(i<len-1&&romanMap[s[i]]<romanMap[s[i+1]]){
                result -= romanMap[s[i]];
            }else{
                result += romanMap[s[i]];

            }
        }
        return result;
}
}