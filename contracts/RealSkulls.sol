// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RealSkulls is ERC1155, Ownable {
  constructor() ERC1155("https://game.example/api/item/{id}.json") {}

  function mint(
    address to,
    uint256[] memory ids,
    uint256[] memory amounts
  ) public onlyOwner {
    _mintBatch(to, ids, amounts, "");
  }
}
