pragma solidity ^0.4.24;

import "./StandardToken.sol";
import "./Ownable.sol";
import "./SafeMath.sol";

/**
 * @title SimpleToken
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `StandardToken` functions.
 */

contract Gerc is StandardToken, Ownable {
    using SafeMath for uint256;

    string public constant name = "Game Eternal Role Chain";
    string public constant symbol = "GERC";
    uint8 public constant decimals = 3;
    //总配额1000亿
    uint256 constant INITIAL_SUPPLY = 100000000000 * (10 ** uint256(decimals));
    //设置GERC代币官网短URL(32字节以内)，供管理平台自动查询
    string public website = "www.gerc.club";
    //设置GERC代币icon短URL(32字节以内)，供管理平台自动查询
    string public icon = "/css/gerc.png";

    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
    constructor() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
        emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);    
    }

    /**
     * airdorp in batch
     */
    function airdrop(address[] payees, uint256 airdropValue) public onlyOwner returns(bool) {
        uint256 _size = payees.length;       
        uint256 amount = airdropValue.mul(_size);
        require(amount <= balances[owner], "balance error"); 

        for (uint i = 0; i<_size; i++) {
            if (payees[i] == address(0)) {
                amount = amount.sub(airdropValue);
                continue;   
            }
            balances[payees[i]] = balances[payees[i]].add(airdropValue);
            emit Transfer(owner, payees[i], airdropValue);
        }        
        balances[owner] = balances[owner].sub(amount);
        return true;
    }

    /**
     * 设置token官网和icon信息
     */
    function setWebInfo(string _website, string _icon) public onlyOwner returns(bool){
        website = _website;
        icon = _icon;
        return true;
    }
}