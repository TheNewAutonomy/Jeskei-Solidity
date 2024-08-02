// contracts/JeskeiAsset.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Asset is ERC721URIStorage, Ownable {
    enum AssetTypeEnum { Video, Audio, Script, Object, Film_Score, Physical_Asset, Other }
    enum FilmRatingEnum { G, PG, PG13, R, NC17 }

    uint256 private _nextTokenId;
    AssetTypeEnum private _assetType;
    string private _description;
    FilmRatingEnum private _filmRating;
    bool private _availableToUse;
    bool private _availableToBuy;
    string[] private _tags;
    address[] private _associations; // List of Productions that have rights to use this asset

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) Ownable(msg.sender) {}

    function createAsset(
        address assetCreator_,
        string memory tokenURI_,
        AssetTypeEnum assetType_,
        string memory description_,
        FilmRatingEnum filmRating_,
        bool availableToUse_,
        bool availableToBuy_,
        string[] memory tags_,
        address[] memory associations_
    ) public onlyOwner returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _mint(assetCreator_, tokenId);
        _setTokenURI(tokenId, tokenURI_);
        _assetType = assetType_;
        _description = description_;
        _filmRating = filmRating_;
        _availableToUse = availableToUse_;
        _availableToBuy = availableToBuy_;
        _tags = tags_;
        _associations = associations_;
        
        return tokenId;
    }

    // Getter functions for public view
    function assetType() public view returns (AssetTypeEnum) {
        return _assetType;
    }

    function description() public view returns (string memory) {
        return _description;
    }

    function filmRating() public view returns (FilmRatingEnum) {
        return _filmRating;
    }

    function availableToUse() public view returns (bool) {
        return _availableToUse;
    }

    function availableToBuy() public view returns (bool) {
        return _availableToBuy;
    }

    function getTags() public view returns (string[] memory) {
        return _tags;
    }

    function getAssociations() public view returns (address[] memory) {
        return _associations;
    }

    // Setter functions with access control for the owner
    function setAssetType(AssetTypeEnum assetType_) public onlyOwner {
        _assetType = assetType_;
    }

    function setDescription(string memory description_) public onlyOwner {
        _description = description_;
    }

    function setFilmRating(FilmRatingEnum filmRating_) public onlyOwner {
        _filmRating = filmRating_;
    }

    function setAvailableToUse(bool availableToUse_) public onlyOwner {
        _availableToUse = availableToUse_;
    }

    function setAvailableToBuy(bool availableToBuy_) public onlyOwner {
        _availableToBuy = availableToBuy_;
    }

    function setTags(string[] memory tags_) public onlyOwner {
        _tags = tags_;
    }

    function setAssociations(address[] memory associations_) public onlyOwner {
        _associations = associations_;
    }
}
