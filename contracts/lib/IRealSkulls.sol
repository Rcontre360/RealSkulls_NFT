// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

interface IRealSkulls is IERC1155 {
  function mint(address to, uint256 amount) external;

  function getSupply(uint256 tokenId) external view returns (uint256);
}
