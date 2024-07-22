// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Asset.sol";
import "./Studio.sol";

contract JeskeiProduction {

    enum AgeRating{ G, PG, PG13, R, NC17 }

    struct Production {
        bytes32 id;
        string name;
        string description;
        AgeRating ageRating;
        bytes32[] assets;
        bytes32 studio;
        uint256 view_Wei;
    }

    Production[] private productions;
    mapping(bytes32 => uint) private productionIndex;
    mapping(bytes32 => uint) private fees;

    modifier onlyExistingProduction(bytes32 productionId) {
        require(productionIndex[productionId] != 0 || (productions.length > 0 && productions[0].id == productionId), "Production does not exist");
        _;
    }

    function createProduction(bytes32 studio, string memory name, string memory description, AgeRating age_Rating) public {
        bytes32 id = keccak256(abi.encodePacked(name, description, age_Rating, studio, blockhash(block.number - 1)));
        Production memory newProduction;
        newProduction.id = id;
        newProduction.name = name;
        newProduction.ageRating = age_Rating;
        newProduction.studio = studio;
        productions.push(newProduction);
        productionIndex[id] = productions.length - 1;
    }

    function deleteProduction(bytes32 productionId) public onlyExistingProduction(productionId) {
        uint index = productionIndex[productionId];
        uint lastIndex = productions.length - 1;

        if (index != lastIndex) {
            productions[index] = productions[lastIndex];
            productionIndex[productions[index].id] = index;
        }

        productions.pop();
        delete productionIndex[productionId];
    }

    function transferProduction(bytes32 productionId, bytes32 targetStudio) public onlyExistingProduction(productionId) {
        uint index = productionIndex[productionId];
        productions[index].studio = targetStudio;
    }

    function addAsset(bytes32 productionId, bytes32 assetId) public onlyExistingProduction(productionId) {
        uint index = productionIndex[productionId];
        productions[index].assets.push(assetId);
    }

    function addAssets(bytes32 productionId, bytes32[] memory assetIds) public onlyExistingProduction(productionId) {
        uint index = productionIndex[productionId];
        for (uint i = 0; i < assetIds.length; i++) {
            productions[index].assets.push(assetIds[i]);
        }
    }

    function removeAsset(bytes32 productionId, bytes32 assetId) public onlyExistingProduction(productionId) {
        uint index = productionIndex[productionId];
        uint assetIndex = 0;
        bytes32[] storage assets = productions[index].assets;

        for (uint i = 0; i < assets.length; i++) {
            if (assets[i] == assetId) {
                assetIndex = i;
                break;
            }
        }

        for (uint i = assetIndex; i < assets.length - 1; i++) {
            assets[i] = assets[i + 1];
        }
        assets.pop();
    }

    function getStudioProductions(bytes32 studioId) public view returns (bytes32[] memory) {
        uint count = 0;
        for (uint i = 0; i < productions.length; i++) {
            if (productions[i].studio == studioId) {
                count++;
            }
        }

        bytes32[] memory studioProductions = new bytes32[](count);
        uint index = 0;
        for (uint i = 0; i < productions.length; i++) {
            if (productions[i].studio == studioId) {
                studioProductions[index] = productions[i].id;
                index++;
            }
        }

        return studioProductions;
    }
}
