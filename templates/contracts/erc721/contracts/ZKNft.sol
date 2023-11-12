// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./verifier.sol";

contract ZKNft is ERC721, Ownable, Verifier {
    mapping(uint256 => uint256) private _idOwners;
    mapping(uint256 => bytes32) private _userHashes;
    address private adminOwner;

    uint256 public nftCount;

    uint256 public val;

    event IdTransfer(
        uint256 indexed from,
        uint256 indexed to,
        uint256 indexed tokenId
    );

    constructor() ERC721("ZK NFT", "ZKNFT") {
        adminOwner = msg.sender;
        nftCount = 0;
    }

    function setVal(uint256 _val) public {
        val = _val;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "";
    }

    function registerUser(uint256 _userId, bytes32 _hash) external onlyOwner {
        _userHashes[_userId] = _hash;
    }

    function idOwnerOf(uint256 tokenId) public view returns (address, uint256) {
        if (ownerOf(tokenId) == adminOwner) {
            return (adminOwner, _idOwners[tokenId]);
        } else {
            return (ownerOf(tokenId), 0);
        }
    }

    function idTransfer(
        uint256 from,
        uint256 to,
        uint256 tokenId,
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint256[1] memory input
    ) public {
        require(_idOwners[tokenId] == from, "ZKNft: from is not id owner");
        require(verifyProof(a, b, c, input), "ZKNft: invalid proof");
        require(
            ownerOf(tokenId) == adminOwner,
            "ZKNft: adminOwner is not owner"
        );
        require(
            input[0] == uint256(_userHashes[tokenId]),
            "ZKNft: invalid hash"
        );

        _idOwners[tokenId] = to;
        emit IdTransfer(from, to, tokenId);
    }

    function mint(uint256 userId) public onlyOwner {
        nftCount += 1;
        uint256 tokenId = nftCount;
        _mint(adminOwner, tokenId);
        require(_userHashes[userId] != bytes32(0));
        _idOwners[tokenId] = userId;
        emit IdTransfer(0, userId, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint256[1] memory input
    ) public virtual {
        require(from == adminOwner, "ZKNft: from is not adminOwner");
        require(
            ownerOf(tokenId) == adminOwner,
            "ZKNft: adminOwner is not owner"
        );
        require(verifyProof(a, b, c, input), "ZKNft: invalid proof");
        require(
            input[0] == uint256(_userHashes[tokenId]),
            "ZKNft: invalid hash"
        );

        _idOwners[tokenId] = 0;
        safeTransferFrom(from, to, tokenId);
    }
}
