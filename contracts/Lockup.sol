
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
pragma solidity ^0.8.0;

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
    function createPair(address tokenA, address tokenB) external returns (address pair);
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

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
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

    // default divisor is 10
    uint8 public divisor = 10;

    uint8 public rewardClaimInterval = 12;

    uint256 public totalStaked;

    uint8 public claimFee = 10; // the default claim fee is 10

    address treasureWallet;

    enum LockDuration { NoneLock, OneMonth, ThreeMonth, SixMonth, OneYear, Irreversible }

    struct UserInfo {
        LockDuration duration;
        uint256 amount;
        uint8 boost;
        uint256 stakedTime;
        uint256 lastClaimed;
        uint256 blockListIndex;
    }

    struct BlockInfo {
        uint256 blockNumber;
        uint256 totalStaked;
    }

    mapping(address => UserInfo) public stakedUserList;

    BlockInfo[] public blockList;

    IPancakeV2Router public router;
    address public pair;

    constructor (
        IERC20 _stakingToken
    ) {
        stakingToken = _stakingToken;
        totalSupply = uint256(IERC20Metadata(address(stakingToken)).totalSupply());
        IPancakeV2Router _newPancakeRouter = IPancakeV2Router(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        router = _newPancakeRouter;
    }

    function setRewardPoolBalance(uint256 _balance) external onlyOwner {
        rewardPoolBalance = _balance;
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
    }

    function setRewardInterval (uint8 _interval) external onlyOwner {
        rewardClaimInterval = _interval;
    }

    function setClaimFee(uint8 fee) external onlyOwner {
        claimFee = fee;
    }

    function deposit(LockDuration duration, uint256 amount) public {
        require(amount > 0, "amount should be bigger than zero!");
        uint256 len = blockList.length;
        totalStaked += amount;

        // when blocList is empty
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

        UserInfo storage user = stakedUserList[msg.sender];

        user.amount =user.amount.add(amount);
        user.blockListIndex = blockList.length - 1;
        user.stakedTime = block.timestamp;
        user.boost = getBoost(duration);
        user.duration = duration;

        if(duration == LockDuration.Irreversible) {
            dealWithIrreversibleAmount(amount);
        }
        
    }

    function getBoost(LockDuration duration) internal pure returns (uint8) {
        if (duration == LockDuration.NoneLock) return 1;
        else if (duration == LockDuration.OneMonth) return 2;
        else if (duration == LockDuration.ThreeMonth) return 3;
        else if (duration == LockDuration.SixMonth) return 4;
        else if (duration == LockDuration.OneYear) return 5;
        else return 10;
    }

    function getDuration(LockDuration duration) internal pure returns (int256) {
        if (duration == LockDuration.NoneLock) return 0;
        else if (duration == LockDuration.OneMonth) return 30 days;
        else if (duration == LockDuration.ThreeMonth) return 90 days;
        else if (duration == LockDuration.SixMonth) return 180 days;
        else if (duration == LockDuration.OneYear) return 365 days;
        else return -1;
    }

    function dealWithIrreversibleAmount(uint256 amount) internal {

    }

    function withDraw() public {
        if(!isWithDrawable()) return;
        if(!claimReward()) return;
        UserInfo storage user = stakedUserList[msg.sender];

        uint256 len = blockList.length;
        totalStaked = totalStaked.sub(user.amount);

        if(blockList[len-1].blockNumber == block.number) { 
            blockList[len-1].totalStaked = totalStaked;
        } else {
            blockList.push(BlockInfo({
                blockNumber : block.number,
                totalStaked : totalStaked
            }));
        }
        
    }

    function isWithDrawable() public view returns(bool) {
        UserInfo storage user = stakedUserList[msg.sender];
        int256 duration = getDuration(user.duration);
        // when Irreversible mode
        if (duration == -1) return false;
        if (uint256(duration) <= block.timestamp - user.stakedTime) return true;
        else return false;
    }

    function calculateReward() public view {

    }

    function claimReward() public returns(bool) {

    }

}