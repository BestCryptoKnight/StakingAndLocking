pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

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

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

contract TestToken  {
    IPancakeV2Router public router;
    address public pair;
    address public pair2;

    constructor() {
        IPancakeV2Router _newPancakeRouter = IPancakeV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        router = _newPancakeRouter;
        pair = IPancakeV2Factory(router.factory()).getPair(address(0xD28B6408d3571B12812cDD6b2b3DcD8B007e3345), 0x9b6AFC6f69C556e2CBf79fbAc1cb19B75E6B51E2);
        if (pair == address(0)) {
            pair = IPancakeV2Factory(router.factory()).createPair(
                address(0xD28B6408d3571B12812cDD6b2b3DcD8B007e3345), // Token
                0x9b6AFC6f69C556e2CBf79fbAc1cb19B75E6B51E2 // USDC
            );
        }

        pair2 = IPancakeV2Factory(router.factory()).getPair(address(0xD28B6408d3571B12812cDD6b2b3DcD8B007e3345), _newPancakeRouter.WETH());
        if (pair2 == address(0)) {
            pair2 = IPancakeV2Factory(router.factory()).createPair(
                address(0xD28B6408d3571B12812cDD6b2b3DcD8B007e3345), // Token
                _newPancakeRouter.WETH() // USDC
            );
        }
        IERC20Metadata(address(0xD28B6408d3571B12812cDD6b2b3DcD8B007e3345)).approve(address(router), 999999999999999999999999);

        IERC20Metadata(address(0x9b6AFC6f69C556e2CBf79fbAc1cb19B75E6B51E2)).approve(address(router), 999999999999999999999999);
        IERC20Metadata(address(_newPancakeRouter.WETH())).approve(address(router), 999999999999999999999999);

        
    }

    function liqui() public {
        router.addLiquidity(0xD28B6408d3571B12812cDD6b2b3DcD8B007e3345,
             0x9b6AFC6f69C556e2CBf79fbAc1cb19B75E6B51E2,
              100000000, 100000000, 0, 0, msg.sender, block.timestamp);
        
    }

    function liqui2(uint256 val, uint256 val2) public {
        router.addLiquidityETH{value: val2}(0xD28B6408d3571B12812cDD6b2b3DcD8B007e3345, val, 0, 0, msg.sender, block.timestamp);
    }

    function swapTokensForUSDC(uint256 amount) public {
        // generate the uniswap pair path of token -> weth
        /// for test
        
        ////
        
        address[] memory path = new address[](2);
        path[0] = address(0xD28B6408d3571B12812cDD6b2b3DcD8B007e3345);
        path[1] = address(0x9b6AFC6f69C556e2CBf79fbAc1cb19B75E6B51E2);  // usdc address
        IERC20Metadata(address(0xD28B6408d3571B12812cDD6b2b3DcD8B007e3345)).approve(address(router), amount);
        router.swapExactTokensForTokens(amount, 0, path, address(this), block.timestamp);
    }

    function swapTokensForNative(uint256 amount) public {
        // generate the uniswap pair path of token -> weth
        /// for test
        
        ////
        address[] memory path = new address[](2);
        path[0] = 0xD28B6408d3571B12812cDD6b2b3DcD8B007e3345;
        path[1] = router.WETH();

        IERC20Metadata(address(0xD28B6408d3571B12812cDD6b2b3DcD8B007e3345)).approve(address(router), amount);

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amount,
            0, // accept any amount of ETH
            path,
            msg.sender,
            block.timestamp
        );
    }

    receive() external payable { }
}