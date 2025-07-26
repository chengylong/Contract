// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract IntToRoman{
    uint16[] values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
    string[] enums = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"];
    function intToRoman(uint  num )public view returns (string memory){
        if(num <= 0 || num >= 4000){
            return "Invalid Input";
        }
        string memory roman = "";
          for (uint i = 0; i < values.length; i++) {
            while(num >= values[i]){
                num -= values[i];
                roman = string.concat(roman, enums[i]);
            }
          }
    return roman;
    }
}