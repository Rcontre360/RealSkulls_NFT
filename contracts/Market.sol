// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./lib/IRealSkulls.sol";
import "./RealSkulls.sol";

contract Market is Ownable {
  RealSkulls public realSkullsContract;
  address public skullTokenAddress;
  uint256 public tokenForRealSkulls;
  mapping(uint256 => address) private _soldSkulls;
  mapping(address => uint256) private _prices;

  constructor(address _skullTokenAddress, uint256 _tokenForRealSkulls) {
    realSkullsContract = new RealSkulls(address(this));
    skullTokenAddress = _skullTokenAddress;
    tokenForRealSkulls = _tokenForRealSkulls;
  }

  function setPrice(address paymentToken, uint256 price) public onlyOwner {
    _prices[paymentToken] = price;
  }

  function getPrice(address paymentToken) public view returns (uint256) {
    return _prices[paymentToken];
  }

  function soldTo(uint256 tokenId) public view returns (address) {
    return _soldSkulls[tokenId];
  }

  function mint(address payTokenAddress, uint256 amount) public payable {
    IERC20 skullTokenContract = IERC20(skullTokenAddress);

    _payTokens(payTokenAddress, amount);
    realSkullsContract.mint(_msgSender(), amount);
    skullTokenContract.transfer(_msgSender(), tokenForRealSkulls);
  }

  function _payTokens(address payTokenAddress, uint256 amount) public payable {
    require(amount > 0, "INVALID_INPUT");
    require(getPrice(payTokenAddress) > 0, "INVALID_INPUT");

    IERC20 tokenContract = IERC20(payTokenAddress);
    uint256 payAmount = getPrice(payTokenAddress) * amount;

    if (address(0) != payTokenAddress) {
      require(tokenContract.balanceOf(_msgSender()) >= payAmount, "NO_MONEY");
      tokenContract.transferFrom(_msgSender(), address(this), payAmount);
    } else {
      //use native token
      require(payAmount >= msg.value, "NO_MONEY");
    }
  }
}
