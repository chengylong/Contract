// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BinarySearch {
    
    /**
     * @dev 在有序数组中查找目标值
     * @param arr 有序数组（升序）
     * @param target 要查找的目标值
     * @return 如果找到目标值返回其索引，否则返回-1
     */
    function binarySearch(uint256[] memory arr, uint256 target) 
        public 
        pure 
        returns (int256) 
    {
        uint256 left = 0;
        uint256 right = arr.length;
        
        // 处理空数组的情况
        if (right == 0) {
            return -1;
        }
        
        // 处理只有一个元素的情况
        if (right == 1) {
        return arr[0] == target ? int256(0) : -1;        }
        
        right = right - 1; // 将right设置为最后一个元素的索引
        
        while (left <= right) {
            uint256 mid = left + (right - left) / 2;
            
            if (arr[mid] == target) {
                return int256(mid);
            } else if (arr[mid] < target) {
                left = mid + 1;
            } else {
                if (mid == 0) {
                    return -1; // 防止下溢
                }
                right = mid - 1;
            }
        }
        
        return -1; // 未找到目标值
    }
}