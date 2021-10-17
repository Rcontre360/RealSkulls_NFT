// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20 {
  constructor() ERC20("Mock", "MOCK") {
    _mint(msg.sender, 100000 * 10**18);
  }
}
