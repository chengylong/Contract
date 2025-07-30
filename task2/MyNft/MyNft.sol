// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    
    Counters.Counter private _tokenIds;
    
    // 事件定义
    event NFTMinted(address indexed to, uint256 indexed tokenId, string url);
    
    // 构造函数
    constructor(string memory name, string memory symbol) ERC721(name, symbol) Ownable(msg.sender) {
        // 设置合约部署者为所有者
    }
    
    // 铸造NFT函数
    function mintNFT(address recipient, string memory url) 
        public 
        onlyOwner 
        returns (uint256) 
    {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        
        _mint(recipient, newTokenId);
        _setTokenURI(newTokenId, url);
        
        emit NFTMinted(recipient, newTokenId, url);
        
        return newTokenId;
    }
    
    // 设置Token URI的内部函数
    function _setTokenURI(uint256 tokenId, string memory uri) internal {
         require(ownerOf(tokenId) != address(0), "URI query for nonexistent token");
        _tokenURIs[tokenId] = uri;
    }
    
    // 存储Token URI的映射
    mapping(uint256 => string) private _tokenURIs;
    
    // 批量铸造NFT
    function batchMintNFT(address recipient, string[] memory tokenURIs) 
        public 
        onlyOwner 
        returns (uint256[] memory) 
    {
        uint256[] memory tokenIds = new uint256[](tokenURIs.length);
        
        for (uint256 i = 0; i < tokenURIs.length; i++) {
            _tokenIds.increment();
            uint256 newTokenId = _tokenIds.current();
            
            _mint(recipient, newTokenId);
            _setTokenURI(newTokenId, tokenURIs[i]);
            
            tokenIds[i] = newTokenId;
            
            emit NFTMinted(recipient, newTokenId, tokenURIs[i]);
        }
        
        return tokenIds;
    }
    
    // 获取当前tokenId
    function getCurrentTokenId() public view returns (uint256) {
        return _tokenIds.current();
    }
    
    // 获取NFT总数
    function getTotalSupply() public view returns (uint256) {
        return _tokenIds.current();
    }
    
    // 重写必要的函数
    function tokenURI(uint256 tokenId) 
        public 
        view 
        override(ERC721) 
        returns (string memory) 
    {
        require(ownerOf(tokenId) != address(0), "URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }
    
    function supportsInterface(bytes4 interfaceId) 
        public 
        view 
        override(ERC721) 
        returns (bool) 
    {
        return super.supportsInterface(interfaceId);
    }
}