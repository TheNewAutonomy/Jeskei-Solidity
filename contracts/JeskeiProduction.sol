// contracts/JeskeiAsset.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Production is ERC721URIStorage, Ownable {
    enum FilmRatingEnum { G, PG, PG13, R, NC17 }

    struct ProductionAssets {
        bytes32 id;
        address assetAddress; // 0x000.. for assets without an address
        uint256 view_Wei;
    }

    uint256 private _nextTokenId;
    string private _description;
    FilmRatingEnum private _filmRating;
    string[] private _tags;
    uint256 private _view_Wei; // Must be at least the sum of all listed assets

    ProductionAssets[] private assets;
    
    event ProductionCreated(uint256 tokenId, address indexed creator, string tokenURI, string description, FilmRatingEnum filmRating, uint256 viewWei, string[] tags);
    event DescriptionUpdated(string oldDescription, string newDescription);
    event FilmRatingUpdated(FilmRatingEnum oldRating, FilmRatingEnum newRating);
    event TagsUpdated(string[] oldTags, string[] newTags);
    event ViewWeiUpdated(uint256 oldViewWei, uint256 newViewWei);

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) Ownable(msg.sender) {
        transferOwnership(msg.sender);
    }

    function createProduction(
        address productionCreator_,
        string memory tokenURI_,
        string memory description_,
        FilmRatingEnum filmRating_,
        uint256 viewWei_,
        string[] memory tags_
    ) public onlyOwner returns (uint256) {
        require(viewWei_ > 0, "View cost must be greater than zero");

        uint256 tokenId = _nextTokenId++;
        _mint(productionCreator_, tokenId);
        _setTokenURI(tokenId, tokenURI_);
        _description = description_;
        _filmRating = filmRating_;
        _tags = tags_;
        _view_Wei = viewWei_;
        
        emit ProductionCreated(tokenId, productionCreator_, tokenURI_, description_, filmRating_, viewWei_, tags_);

        return tokenId;
    }

    // Getter functions to make the properties publicly viewable
    function getDescription() public view returns (string memory) {
        return _description;
    }

    function getFilmRating() public view returns (FilmRatingEnum) {
        return _filmRating;
    }

    function getTags() public view returns (string[] memory) {
        return _tags;
    }

    function getViewWei() public view returns (uint256) {
        return _view_Wei;
    }

    // Owner-only functions to update the properties
    function updateDescription(string memory newDescription) public onlyOwner {
        emit DescriptionUpdated(_description, newDescription);
        _description = newDescription;
    }

    function updateFilmRating(FilmRatingEnum newFilmRating) public onlyOwner {
        emit FilmRatingUpdated(_filmRating, newFilmRating);
        _filmRating = newFilmRating;
    }

    function updateTags(string[] memory newTags) public onlyOwner {
        emit TagsUpdated(_tags, newTags);
        _tags = newTags;
    }

    function updateViewWei(uint256 newViewWei) public onlyOwner {
        require(newViewWei > 0, "View cost must be greater than zero");
        emit ViewWeiUpdated(_view_Wei, newViewWei);
        _view_Wei = newViewWei;
    }

    // Additional functions to manage ProductionAssets can be added here
}
