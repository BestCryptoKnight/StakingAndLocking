pragma solidity ^0.8.0;

library SafeMath {

    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }


    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }


    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }


    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

 
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) { 
        uint256 size; assembly { size := extcodesize(account) } return size > 0;
    }
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");(bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
        
    }
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
        
    }
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
        
    }
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }
    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) { return returndata; } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {revert(errorMessage);}
        }
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {return msg.sender;}
    function _msgData() internal view virtual returns (bytes calldata) {this; return msg.data;}
}

abstract contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }   
    
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }


   function getTime() public view returns (uint256) {
        return block.timestamp;
    }

}

interface IPancakeV2Factory {
       event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IPancakeV2Router {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}


interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

contract Lockup is Ownable {
    using SafeMath for uint256;
    using Address for address;

    IERC20 public stakingToken;
    uint256 public totalSupply;

    uint256 public distributionPeriod = 10;

    uint256 public rewardPoolBalance = 10000000000;

    // balance of this contract should be bigger than thresholdMinimum
    uint256 public thresholdMinimum = 10 ** 11;

    // default divisor is 6
    uint8 public divisor = 6;

    uint8 public rewardClaimInterval = 12;

    uint256 public totalStaked;

    uint8 public claimFee = 100; // the default claim fee is 10

    address treasureWallet;
    uint256 claimFeeAmount;
    uint256 claimFeeAmountLimit;

    address deadAddress = 0x000000000000000000000000000000000000dEaD;
    address rewardWallet;

    struct StakeInfo {
        int128 duration;  // -1: irreversible, others: reversible (0, 30, 90, 180, 365 days which means lock periods)
        uint256 amount; // staked amount
        uint256 stakedTime; // initial staked time
        uint256 lastClaimed; // last claimed time
        uint256 blockListIndex; // blockList id which is used in calculating rewards
        bool available;     // if diposit, true: if withdraw, false
        string name;    // unique id of the stake
    }

    struct BlockInfo {
        uint256 blockNumber;
        uint256 totalStaked;
    }

    mapping(bytes32 => StakeInfo) public stakedUserList;
    mapping (address => bytes32[]) public userInfoList; // container of user's id
    BlockInfo[] public blockList;

    IPancakeV2Router public router;
    address public pair;

    event Deposit(address indexed user, string name, uint256 amount);
    event Withdraw(address indexed user, string name, uint256 amount);
    event Compound(address indexed user, string name, uint256 amount);
    event NewDeposit(address indexed user, string name, uint256 amount);
    event SendToken(address indexed token, address indexed sender, uint256 amount);
    event ClaimReward(address indexed user, uint256 amount);

    constructor (
        IERC20 _stakingToken
    ) {
        stakingToken = _stakingToken;
        totalSupply = uint256(IERC20Metadata(address(stakingToken)).totalSupply());
        IPancakeV2Router _newPancakeRouter = IPancakeV2Router(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        router = _newPancakeRouter;

        // default is 10000 amount of tokens
        claimFeeAmountLimit = 10000 * 10 ** IERC20Metadata(address(stakingToken)).decimals();
    }

    function string2byte32(string memory name) private pure returns(bytes32) {
        return keccak256(abi.encodePacked(name));
    }

    function isExistStakeId(string memory name) public view returns (bool) {
        return stakedUserList[string2byte32(name)].available;
    }

    function setRewardPoolBalance(uint256 _balance) external onlyOwner {
        rewardPoolBalance = _balance;
    }

    function setTreasuryWallet(address walletAddr) external onlyOwner {
        treasureWallet = walletAddr;
    }

    function setClaimFeeAmountLimit(uint256 val) external onlyOwner {
        claimFeeAmountLimit = val * 10 ** IERC20Metadata(address(stakingToken)).decimals();
    }

    function setDistributionPeriod(uint256 _period) external onlyOwner {
        distributionPeriod = _period;
    }

    function setDivisor (uint8 _divisor) external onlyOwner {
        divisor = _divisor;
    }

    function sendToken (address token, address sender, uint256 amount) external onlyOwner {
        require(uint256(IERC20Metadata(token).balanceOf(address(this)))>= amount, "Insufficient amount in this contract");
        if(address(stakingToken) == token) {
            require(uint256(IERC20Metadata(token).balanceOf(address(this))) - amount >= thresholdMinimum, "Insufficient amount in this contract");
        }
        IERC20Metadata(address(token)).transfer(sender, amount);
        emit SendToken(token, sender, amount);
    }

    function setRewardInterval (uint8 _interval) external onlyOwner {
        rewardClaimInterval = _interval;
    }

    function setClaimFee(uint8 fee) external onlyOwner {
        claimFee = fee;
    }

    function updateBlockList(uint256 amount, bool isPush) private {
        uint256 len = blockList.length;
        if(isPush) totalStaked = totalStaked.add(amount);
        else       totalStaked = totalStaked.sub(amount);

        if(len - 1 < 0) {
            blockList.push(BlockInfo({
                blockNumber : block.number,
                totalStaked : totalStaked
            }));
        } else {
            // when the reward is not accumulated yet
            if(blockList[len-1].blockNumber == block.number) { 
                blockList[len-1].totalStaked = totalStaked;
            } else {
                blockList.push(BlockInfo({
                    blockNumber : block.number,
                    totalStaked : totalStaked
                }));
            }
        }
    }

    function updateStakedList(string memory name, int128 duration, uint256 amount, bool available) private {
        bytes32 key = string2byte32(name); 
        StakeInfo storage info = stakedUserList[key];
        info.available = available;
        if(!available) return;
        info.amount =info.amount.add(amount);
        info.blockListIndex = blockList.length - 1;
        info.stakedTime = block.timestamp;
        info.duration = duration;
        info.name = name;
    }

    function updateUserList(string memory name, bool isPush) private {
        bytes32 key = string2byte32(name);
        if(isPush)
            userInfoList[_msgSender()].push(key);
        else {
            // remove user id from the userList
            for (uint256 i = 0; i < userInfoList[_msgSender()].length; i++) {
                if (userInfoList[_msgSender()][i] == key) {
                    userInfoList[_msgSender()][i] = userInfoList[_msgSender()][userInfoList[_msgSender()].length - 1];
                    userInfoList[_msgSender()].pop();
                    break;
                }
            }
        }
    }

    function deposit(string memory name, int128 duration, uint256 amount) public {
        require(amount > 0, "amount should be bigger than zero!");
        require(!isExistStakeId(name), "This id is already existed!");

        updateBlockList(amount, true);
        updateStakedList(name, duration, amount, true);
        updateUserList(name, true);

        if(duration == -1) {    //irreversible mode
            dealWithIrreversibleAmount(amount);
        } else {
            stakingToken.transferFrom(_msgSender(), address(this), amount);
        }
        emit Deposit(_msgSender(), name, amount);
    }

    function withdraw(string memory name) public {
        require(!isExistStakeId(name), "This id is already existed!");
        require(isWithDrawable(name), "Lock period is not expired!");
        _claimReward(name, false);
        uint256 amount = stakedUserList[string2byte32(name)].amount;
        updateBlockList(amount, false);
        updateStakedList(name, 0, 0, false);
        updateUserList(name, false);
        stakingToken.transfer(_msgSender(), amount);
        emit Withdraw(_msgSender(), name, amount);
    }

    function getBoost(int128 duration) internal pure returns (uint8) {
        if (duration == -1) return 10;
        else if (duration == 0) return 1;
        else if (duration < 30) return 2;
        else if (duration < 90) return 3;
        else if (duration < 180) return 4;
        else return 5;
    }

    function dealWithIrreversibleAmount(uint256 amount) internal {

    }

    function isWithDrawable(string memory name) public view returns(bool) {
        StakeInfo storage stakeInfo = stakedUserList[string2byte32(name)];
        // when Irreversible mode
        if (stakeInfo.duration == -1) return false;
        if (uint256(uint128(stakeInfo.duration) * 1 days) <= block.timestamp - stakeInfo.stakedTime * 1 days) return true;
        else return false;
    }

    function _calculateReward(string memory name) private view returns(uint256) {
        require(!isExistStakeId(name), "This id is already existed!");
        StakeInfo storage stakeInfo = stakedUserList[string2byte32(name)];
        uint256 blockIndex = stakeInfo.blockListIndex;
        uint256 stakedAmount = stakeInfo.amount;
        uint256 reward = 0;
        uint256 boost = getBoost(stakeInfo.duration);
        for (uint256 i = blockIndex; i < blockList.length; i++) {
            uint256 _totalStaked = blockList[i].totalStaked;
            reward += (rewardPoolBalance * stakedAmount * boost / distributionPeriod  / _totalStaked / divisor );
        }
        return reward;
    }

    function calculateReward(string memory name) public view returns(uint256) {
        uint256 reward = _calculateReward(name);
        return reward - reward * claimFee / 1000;
    }
    
    function claimReward(string memory name) public {
        _claimReward(name, true);
    }

    function _claimReward(string memory name, bool ignoreClaimInterval) private {
        require(!isExistStakeId(name), "This id is already existed!");
        if(!ignoreClaimInterval) {
            require(!isClaimable(name), "Claim lock period is not expired!");
        }
        uint256 reward = _calculateReward(name);
        bytes32 key = string2byte32(name); 
        StakeInfo storage info = stakedUserList[key];
        info.blockListIndex = block.number;
        info.lastClaimed = block.timestamp;
        stakingToken.transfer(_msgSender(), reward - reward * claimFee / 1000);

        // send teasureWallet when the total amount sums up to the limit value
        if(claimFeeAmount + reward * claimFee / 1000 > claimFeeAmountLimit) {
            stakingToken.transfer(treasureWallet, claimFeeAmount + reward * claimFee / 1000);
            claimFeeAmount = 0;
        } else {
            claimFeeAmount += reward * claimFee / 1000;
        }

        emit ClaimReward(_msgSender(), reward - reward * claimFee / 1000);
    }

    function isClaimable(string memory name) public view returns(bool) {
        StakeInfo storage stakeInfo = stakedUserList[string2byte32(name)];
        uint256 lastClaimed = stakeInfo.lastClaimed;
        if(block.timestamp - lastClaimed >= rewardClaimInterval * 1 hours) return true;
        else return false;
    }

    function compound(string memory name) public {
        require(!isExistStakeId(name), "This id is already existed!");
        require(!isClaimable(name), "Claim lock period is not expired!");
        uint256 reward = _calculateReward(name);
        updateBlockList(reward, true);
        bytes32 key = string2byte32(name);
        StakeInfo storage info = stakedUserList[key];
        info.blockListIndex = block.number;
        info.lastClaimed = block.timestamp;
        info.amount += reward;
        info.duration++;

        emit Compound(_msgSender(), name, reward);
    }

    function newDeposit(string memory name, int128 duration) public {
        require(!isExistStakeId(name), "This id is already existed!");
        require(!isClaimable(name), "Claim lock period is not expired!");
        uint256 reward = _calculateReward(name);
        updateBlockList(reward, true);
        updateStakedList(name, duration, reward, true);
        updateUserList(name, true);

        emit NewDeposit(_msgSender(), name, reward);
    }

    function getUserStakedInfo() public view returns (uint256, string[] memory) {
        bytes32[] memory userInfo = userInfoList[_msgSender()];
        uint256 len = userInfo.length;
        string[] memory resVal = new string[](len);
        for (uint256 i = 0; i < userInfo.length; i++) {
            StakeInfo memory info = stakedUserList[userInfo[i]];
            resVal[i] = info.name;
        }

        return (len, resVal);
    }

    function claimMulti(string[] memory ids) public {
        for (uint256 i = 0; i < ids.length; i++) {
            claimReward(ids[i]);
        }
    }

    function newCompound(string[] memory ids) public {
        for (uint256 i = 0; i < ids.length; i++) {
            compound(ids[i]);
        }
    }

}