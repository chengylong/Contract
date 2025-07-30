// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";

contract BeggingContract is Ownable{
     // 记录每个捐赠者的捐赠金额
    mapping(address => uint256) public donations;

    // 记录总捐赠金额
    uint256 public totalDonations;

    // 记录捐赠者数量
    uint256 public donorCount;

    // 记录所有捐赠者地址
    address[] public donors;

    // 事件定义
    event DonationReceived(address indexed donor, uint256 amount, string message);
    event FundsWithdrawn(address indexed owner, uint256 amount);

        // 构造函数
    constructor() Ownable(msg.sender) {
        totalDonations = 0;
        donorCount = 0;
    }

    // 捐赠函数 允许用户发送以太币
    function donate() public payable {
         require(msg.value > 0, "Donation amount must be greater than 0");
        // 记录捐赠信息
        if(donations[msg.sender]== 0){
            //新捐赠者
            donorCount ++;
            donors.push(msg.sender);
        }
        //更新捐赠金额
        donations[msg.sender] += msg.value;
        totalDonations += msg.value;

        // 触发事件
        emit DonationReceived(msg.sender, msg.value, "Thank you for your donation!");
    
    }
    // 提取所有资金，所有者可调用
    function withdraw() public onlyOwner{
         require(address(this).balance > 0, "No funds to withdraw");
         uint256 amount = address(this).balance;
         //转移资金给所有者
         (bool success,) = payable (owner()).call{value:amount}("");
         require(success, "Transfer failed");
         // 触发事件
        emit FundsWithdrawn(owner(), amount);
    }
    // 提取指定金额，所有者可调用
    function withdrawAmount(uint256 amount) public onlyOwner{
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= address(this).balance, "Insufficient balance");
        // 转移资金给所有者
        (bool success, ) = payable(owner()).call{value: amount}("");
        require(success, "Transfer failed");
        
        // 触发事件
        emit FundsWithdrawn(owner(), amount);
    }
        // 查询某个地址的捐赠金额
    function getDonation(address donor) public view returns(uint256){
        return donations[donor];
    }
        // 查询合约余额
    function getContractBalance() public view returns (uint256){
        return address(this).balance;
    }
        // 查询捐赠者总数
    function getDonorCount() public view returns (uint256) {
        return donorCount;
    }
    
    // 查询所有捐赠者地址
    function getAllDonors() public view returns (address[] memory) {
        return donors;
    }
    // 接收以太币的回退函数
    receive() external payable {
        donate();
    }
    
    // 防止意外发送以太币
    fallback() external payable {
        donate();
    }
}