// SPDX-License-Identifier: UNLICENSED
/**
 *Submitted for verification at Etherscan.io on 2019-05-09
 */

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Farm is Ownable {
    IERC20 public davos;
    using SafeMath for uint;
    using SafeERC20 for IERC20;

    struct PoolInfo {
        uint weight;
        uint davosPerShare;
        uint aPerBReward;
        uint totalStake;
    }

    struct UserInfo {
        uint256 amount;     // How many LP tokens the user has provided.
        uint256 rewardDebt; // Reward debt.
    }

    uint constant MAG = 1e18; 

    mapping(address => PoolInfo) public pools;
    mapping(address => mapping(address => UserInfo)) public users;

    uint public rewardPerWeight;
    uint public rewardRate;
    uint public finishBlock;
    uint public lastUpdateBlock;
    uint public totalWeight;
    uint public mintRate;

    event ClaimReward(address user, uint amount);
    event AddReward(uint amount, uint duration);
    event Stake(address user, address lp, uint amount);
    event Withdraw(address user, address lp, uint amount);
    event SetWeights(address pool, uint weight);

    constructor(IERC20 _davos) {
        davos = _davos;
    }

    modifier _updateBlock() {
        uint applicableBlock = block.number > finishBlock ? finishBlock: block.number;
        if(totalWeight > 0) {
            rewardPerWeight = rewardPerWeight.add(applicableBlock.sub(lastUpdateBlock).mul(mintRate).mul(1e12).div(totalWeight));
        }
        lastUpdateBlock = applicableBlock;
        _;
    }

    function setWeights(address[] calldata _pools, uint[] calldata _weights) onlyOwner external _updateBlock {
        require(_pools.length == _weights.length);
        uint cnt = _pools.length;
        for(uint i = 0; i < cnt;i++) {
            _updatePool(_pools[i]);
            totalWeight = totalWeight.sub(pools[_pools[i]].weight);
            pools[_pools[i]].weight = _weights[i];
            totalWeight = totalWeight.add(_weights[i]);
            emit SetWeights(_pools[i], _weights[i]);
        }
    }

    function _updatePool(address poolAddress) private {
        PoolInfo storage pool = pools[poolAddress];
        if(pool.totalStake > 0) {
            pool.davosPerShare = pool.davosPerShare.add(rewardPerWeight.sub(pool.aPerBReward).mul(pool.weight).div(1e12).mul(MAG).div(pool.totalStake));
        }
        pool.aPerBReward = rewardPerWeight;
    }

    function pending(address poolAddress, address userAddress) external view returns(uint) {
        PoolInfo storage pool = pools[poolAddress];
        UserInfo storage user = users[poolAddress][userAddress];
        
        if (totalWeight > 0 && pool.totalStake > 0 && user.amount > 0) {
            uint applicableBlock = block.number > finishBlock ? finishBlock: block.number;
            uint _rewardPerWeight = rewardPerWeight.add(applicableBlock.sub(lastUpdateBlock).mul(mintRate).mul(1e12).div(totalWeight));
            uint256 davosPerShare =  pool.davosPerShare.add(_rewardPerWeight.sub(pool.aPerBReward).mul(pool.weight).div(1e12).mul(MAG).div(pool.totalStake));

            return user.amount.mul(davosPerShare.sub(user.rewardDebt)).div(MAG);
        }
        return 0;
    }

    function stake(address poolAddress, uint amount) external _updateBlock {
        PoolInfo storage pool = pools[poolAddress];
        UserInfo storage user = users[poolAddress][msg.sender];
        require(pool.weight > 0, "NOT SUPPORT NOW");
        _updatePool(poolAddress);
        if(user.amount > 0) {
            uint256 pendingAmount = user.amount.mul(pool.davosPerShare.sub(user.rewardDebt)).div(MAG);
            if (pendingAmount > 0) {
                safeDavosTransfer(msg.sender, pendingAmount);
            }
        }

        if(amount > 0) {
            IERC20(poolAddress).safeTransferFrom(msg.sender, address(this), amount);
            user.amount = user.amount.add(amount);
            pool.totalStake = pool.totalStake.add(amount);
        }

        user.rewardDebt = pool.davosPerShare;
        emit Stake(msg.sender, poolAddress, amount);
    }


    function withdraw(address poolAddress, uint amount) external _updateBlock {
        PoolInfo storage pool = pools[poolAddress];
        UserInfo storage user = users[poolAddress][msg.sender];
        require(user.amount >= amount, "INVALID AMOUNT");
        _updatePool(poolAddress);

        uint256 pendingAmount = user.amount.mul(pool.davosPerShare.sub(user.rewardDebt)).div(MAG);
        if (pendingAmount > 0) {
            safeDavosTransfer(msg.sender, pendingAmount);
        }

        if(amount > 0) {
            IERC20(poolAddress).safeTransfer(msg.sender, amount);
            user.amount = user.amount.sub(amount);
            pool.totalStake = pool.totalStake.sub(amount);
        }

        user.rewardDebt = pool.davosPerShare;
        emit Withdraw(msg.sender, poolAddress, amount);
    }

    function addReward(uint amount, uint duration) onlyOwner external _updateBlock {
        require(block.number.add(duration) >= finishBlock, "CAN NOT DECREASE DURATION");
        davos.safeTransferFrom(msg.sender, address(this), amount);
        if(block.number > finishBlock) {
            mintRate = amount.div(duration); 
        } else {
            uint remain = finishBlock.sub(block.number).mul(mintRate);
            mintRate = remain.add(amount).div(duration);
        }
        lastUpdateBlock = block.number;
        finishBlock = block.number.add(duration);
        emit AddReward(amount, duration);
    }

    function safeDavosTransfer(address to, uint256 amount) internal {
        uint256 balance = davos.balanceOf(address(this));
        if (amount > balance) {
            davos.safeTransfer(to, balance);
            emit ClaimReward(to, balance);
        } else {
            davos.safeTransfer(to, amount);
            emit ClaimReward(to, amount);
        }
    }
}
