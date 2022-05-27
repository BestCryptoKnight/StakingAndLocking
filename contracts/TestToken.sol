pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract TestToken is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("ERC20 Token Sample1", "Test1") {
        _mint(msg.sender, 10000000000000000000 * 10**18 );
    }

    receive() external payable { }
}