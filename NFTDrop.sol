// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
/**
 * @title NFTDrop
 * @dev NFT Contract
 */
contract NFTDrop is ERC721A, Ownable, ReentrancyGuard {

    event FreeEth(address, string);

    string public constant PROVENANCE_HASH = "";
    uint16 public constant MAX_SUPPLY = 1000;

    uint256 public salePrice = 0.01 ether;
    string public baseURI;
    bool public revealed;

    constructor() 
        ERC721A("C0smic", "CSMC")
        Ownable()
        ReentrancyGuard() 
    {}
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }
    //mint
    function mint(uint256 amount) public payable{
        require(amount > 0, "Amount to mint must be greater than 0");
        require(msg.value == salePrice * amount, "Invalid Payment amount");
        _safeMint(msg.sender, amount);
    }

    //whitelist

    //setPrice
    function setPrice(uint256 newPrice) public onlyOwner
    {
        salePrice = newPrice;
    }

    //set royalty

    //do reveal
    function reveal(string calldata newBaseURI) public onlyOwner {
        require(!revealed, "Already revealed");
        baseURI = newBaseURI;
        revealed = true;
    }

    //fallback
    receive() external payable
    {
        emit FreeEth(msg.sender, string(abi.encodePacked("Thanks for the ETH: ", msg.value)));
    }

    //transfer out
    function withdrawTo(address to, uint256 amount) public onlyOwner
    {
        require(to != address(0), "Cannot withdraw to 0x0 address");
        if (amount == 0) {  //withdraw full balance if amount = 0
            amount = address(this).balance;
        }
        Address.sendValue(payable(to), amount);
    }
}
