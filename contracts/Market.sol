// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./lib/IRealSkulls.sol";

contract Market is Ownable {
  address public realSkullsAddress;
  mapping(uint256 => address) public soldSkulls;
  mapping(uint256 => mapping(address => uint256)) private _prices;

  constructor(address _realSkullsAddress) {
    realSkullsAddress = _realSkullsAddress;
  }

  function setPrice(
    uint256 tokenId,
    address paymentToken,
    uint256 price
  ) public onlyOwner {
    _prices[tokenId][paymentToken] = price;
  }

  function getPrice(uint256 tokenId, address paymentToken)
    public
    view
    returns (uint256)
  {
    return _prices[tokenId][paymentToken];
  }

  function buyTokens(
    uint256[] memory tokens,
    uint256[] memory tokensAmount,
    address payTokenAddress
  ) public payable {
    _payTokens(tokens, tokensAmount, payTokenAddress);
    _transfer(_msgSender(), tokens, tokensAmount);
  }

  function mintAndBuyToken(
    uint256[] memory tokens,
    uint256[] memory tokensAmount,
    address payTokenAddress
  ) public payable {
    IRealSkulls realSkullContract = IRealSkulls(realSkullsAddress);
    _payTokens(tokens, tokensAmount, payTokenAddress);
    realSkullContract.mint(_msgSender(), tokens, tokensAmount);
  }

  function _payTokens(
    uint256[] memory tokens,
    uint256[] memory tokensAmount,
    address payTokenAddress
  ) public payable {
    require(tokens.length == tokensAmount.length, "INVALID_INPUT");

    IERC20 tokenContract = IERC20(payTokenAddress);
    uint256 payAmount = 0;

    for (uint256 i = 0; i < tokens.length; i++) {
      uint256 price = getPrice(tokens[i], payTokenAddress) * tokensAmount[i];
      require(soldTo(tokens[i]) == address(0) && price > 0, "TOKEN_SOLD");
      payAmount += getPrice(tokens[i], payTokenAddress) * tokensAmount[i];
      soldSkulls[tokens[i]] = _msgSender();
    }

    if (address(0) != payTokenAddress) {
      require(tokenContract.balanceOf(_msgSender()) >= payAmount, "NO_MONEY");
      tokenContract.transferFrom(_msgSender(), owner(), payAmount);
    } else {
      //use native token
      require(payAmount >= msg.value, "NO_MONEY");
      payable(owner()).transfer(msg.value);
    }
  }

  function _transfer(
    address recipient,
    uint256[] memory tokens,
    uint256[] memory tokensAmount
  ) internal {
    require(
      recipient != address(0) && tokens.length == tokensAmount.length,
      "INVALID_INPUT"
    );
    IRealSkulls realSkullContract = IRealSkulls(realSkullsAddress);

    realSkullContract.safeBatchTransferFrom(
      address(this),
      recipient,
      tokens,
      tokensAmount,
      ""
    );
  }

  function soldTo(uint256 tokenId) public view returns (address) {
    return soldSkulls[tokenId];
  }
}
