// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//1.投票合约
contract Voting{
    mapping (string=>uint) private votes;
    // 管理map中的key
    string[] private candidates;
    // 判断候选人是否已存在
    function isCandidateExist(string memory name) private view returns (bool){
        for (uint i = 0; i < candidates.length; i++) {
    if (keccak256(bytes(candidates[i])) == keccak256(bytes(name))) {
    return true;
        }
        }
    return false;
}
    // 投票
    function vote(string memory name) public {
        if (!isCandidateExist(name)){
            candidates.push(name);
        }
        votes[name]++;
    }
    //查询票数
    function getVotes(string memory name)public view returns (uint){
        return votes[name];

    }
    //重置所有候选人票数
    function resetVotes() public {
        for (uint i =0; i<candidates.length; i++) 
        {
            votes[candidates[i]] = 0;
        }
    }    
}