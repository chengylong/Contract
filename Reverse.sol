// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//2.反转字符串
contract Reverse
{
      function    reverse(string memory str) public  pure returns (string memory){
        bytes  memory strBytes = bytes(str);
        for (uint i =0; i<strBytes.length/2; i++) 
        {
          bytes1 temp =   strBytes[i] ;
          strBytes[i] = strBytes[strBytes.length - 1 - i];
          strBytes[strBytes.length - 1 - i] = temp;
        }
        return string(strBytes);
    }
}