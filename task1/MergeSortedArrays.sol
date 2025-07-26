// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MergeSortedArrays{
        /**
     * @dev 合并两个有序数组为一个有序数组
     * @param arr1 第一个有序数组
     * @param arr2 第二个有序数组
     * @return 合并后的有序数组
     */
     function mergeSortedArrays(uint256[] memory arr1, uint256[] memory arr2)public pure   returns (uint256[] memory){
        uint256 len1 = arr1.length;
        uint256 len2 = arr2.length;
        uint256[] memory result = new uint256[](len1+len2);
                uint256 i = 0; // arr1的索引
        uint256 j = 0; // arr2的索引
        uint256 k = 0; // result的索引
                // 比较两个数组的元素，将较小的放入结果数组
        while(i<len1&&j<len2){
            if(arr1[i]<=arr2[j]){
                result[k] = arr1[i];
                i++;
            }
            else{
                result[k] = arr2[j];
                j++;
            }
            k++;
        }
        // 剩余元素放入数组
        while (i<len1){
            result[k]=arr1[i];
            i++;
            k++;
        }
        while(j<len2){
            result[k]=arr2[j];
            j++;
            k++;
        }
        return result;
     }
}