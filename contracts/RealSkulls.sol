// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RealSkulls is ERC1155, Ownable {
  uint256 public currentId;
  mapping(uint256 => uint256) private _tokenSupply;

  constructor() ERC1155("https://game.example/api/item/{id}.json") {}

  function mint(address to, uint256 amount) public onlyOwner {
    for (uint256 i = 0; i < amount; i++) {
      _mint(to, currentId, 1, "");
      _tokenSupply[currentId]++;
      currentId++;
    }
  }

  function getSupply(uint256 tokenId) public view returns (uint256) {
    return _tokenSupply[tokenId];
  }
}
