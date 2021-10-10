// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

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

  function buyToken(
    uint256 tokenId,
    address payTokenAddress,
    uint256 tokenAmount
  ) public payable {
    uint256 amount = getPrice(tokenId, payTokenAddress);
    if (address(0) != payTokenAddress) {
      IERC20 tokenContract = IERC20(payTokenAddress);
      tokenContract.transferFrom(_msgSender(), owner(), amount);
    } else {
      //use native token
      require(amount == msg.value);
      payable(owner()).transfer(msg.value);
    }
    _transfer(_msgSender(), tokenId, tokenAmount);
    soldSkulls[tokenId] = _msgSender();
  }

  function _transfer(
    address recipient,
    uint256 tokenId,
    uint256 tokenAmount
  ) internal {
    require(recipient != address(0), "Cannot send to this address");
    require(soldTo(tokenId) == address(0));

    IERC1155 realSkullContract = IERC1155(realSkullsAddress);

    realSkullContract.safeTransferFrom(
      address(this),
      recipient,
      tokenId,
      tokenAmount,
      ""
    );
  }

  function soldTo(uint256 tokenId) public view returns (address) {
    return soldSkulls[tokenId];
  }
}
