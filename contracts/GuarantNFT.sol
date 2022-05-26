// contracts/NFT.sol
// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract GuarantNFT is ERC721URIStorage {
    constructor() ERC721("Guarant NFT", "GIR") {}
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    function createToken(address recipient) public returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        _mint(recipient, newItemId);

        return newItemId;
    }
}
