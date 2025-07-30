// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract MyERC20Token {
// 代币基本信息
    string public name; //代币名称
    string public symbol; //代币符号
    uint8 public decimals; //铸币位数
    uint256 public totalSupply;//铸币数量

        //0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
    //0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
    //0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
    // 10000000000000000000 -10

    // 合约所有者
    address public  owner;

    // 余额映射
    mapping (address => uint256) public balanceOf;

    // 授权映射
    mapping (address => mapping (address => uint256)) public allowance;

    // 事件定义
    event Transfer(address indexed from,address indexed to,uint256 value);

    event Approval(address indexed owner,address indexed spender,uint256 value);

    event Mint(address indexed to,uint256 amount);

    // 修饰符：所有者才能调用
    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    // 构造函数
    constructor(string memory _name,string memory _symbol, uint8 _decimals, uint256 _totalSupply){
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply * 10 ** uint256(decimals);
    }

    // 查询账户余额
    // function balanceOf(address account) public view returns (uint256 balance) {
    //     return balanceOf(account);
    // }

    // 转账方法
    function transfer(address to, uint256 amount ) public returns (bool success){
        // 校验有效地址
        require(to!=address(0),"Transfer to zero address");
        // 校验余额是否足够转账
        require(balanceOf[msg.sender]>= amount,"Insufficient balance");
        // 更新余额
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        // 触发事件
        emit Transfer(msg.sender, to, amount);
        return true;
        
    }

    // 授权函数
    function approve (address spender, uint256 amount) public returns (bool success){
        // 校验地址
        require(spender != address(0), "Approve to zero address");
        // 更新授权
        allowance[msg.sender][spender] = amount;
        // 触发事件
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // 代扣转账函数
    function transferFrom(address from, address to, uint256 amount) public returns (bool){
        // 校验地址
         require(from != address(0), "Transfer from zero address");
        require(to != address(0), "Transfer to zero address");
        // 校验余额和认证账户
        require(balanceOf[from] >= amount, "Insufficient balance");
        require(allowance[from][msg.sender] >= amount, "Insufficient allowance");
        // 更新余额和授权
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        allowance[from][msg.sender] -= amount;
        emit Transfer(from, to, amount);
        return true;
    }
    
    // 查询授权额度
    // function allowance (address owner, address spender) public view returns (uint256){
    //     return allowance[owner][spender];
    // }

    // 增发代币函数（所有者可调用）
    function mint(address to,uint256 amount) public onlyOwner {
        require(to != address(0), "Mint to zero address");
        _mint(to, amount);
    }

    // 内部铸币函数
    function _mint(address to, uint256 amount) internal {
        balanceOf[to] += amount;
        totalSupply += amount;
        emit Mint(to, amount);
        emit Transfer(address(0), to, amount);
    }

    // 销毁代币方法
    function burn(uint amount) public {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        totalSupply += amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    // 查询总供应量
    // function totalSupply() public view returns (uint256){
    //     return totalSupply;
    // }
}