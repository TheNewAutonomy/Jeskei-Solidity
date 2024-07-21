// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Asset.sol";
import "./Studio.sol";

contract JeskeiProduction {

    enum AgeRating{ G, PG, PG13, R, NC17 }

    struct Production {
        bytes20 id;
        string name;
        string description;
        AgeRating ageRating;
        bytes20[] assets;
        bytes20 studio;
        uint256 view_Wei;
    }

    Production[] private productions;

    mapping(bytes20 => uint) fees;

    function createProduction(bytes20 studio, string memory name, string memory description, uint age_Rating) public {
        bytes20 id = keccak256(name, description, age_Rating, studio, block.blockhash(block.number - 1));
        Production memory newProduction = Production(id, name, description, age_Rating, studio);
        productions.push(newProduction);
    }

    function deleteProduction(bytes20 productionId) public {
        uint element = 0;

        for (uint256 i = 0; i < productions.length; i++) {
            if (productions[i].id == productionId) {
                element = i;
            }
        }

        for (uint i = element; i < productions.length - 1; i++) {
            productions[i] = productions[i + 1];
        }
        productions.pop(); // Remove the last element

    }

    function transferProduction(bytes20 productionId, bytes20 targetStudio) public {
        for (uint256 i = 0; i < productions.length; i++) {
            if (productions[i].id == productionId) {
                productions.studio = targetStudio;
            }
        }
    }

    function addAsset(bytes20 productionId, bytes20 assetId) public
    {
        for (uint256 i = 0; i < productions.length; i++) {
            if (productions[i].id == productionId) {
                productions[i].assets.push(assetId);
            }
        }
    }

    function addAssets(bytes20 productionId, bytes20[] memory assetIds) public
    {
        for (uint256 i = 0; i < productions.length; i++) {
            if (productions[i].id == productionId) {
                productions[i].assets.push(assetIds);
            }
        }
    }

    function removeAsset(bytes20 productionId, bytes20 assetId) public
    {
        for (uint256 i = 0; i < productions.length; i++) {
            if (productions[i].id == productionId) {
                
                uint256 assetIndex = 0;

                for (uint256 j = 0; j < productions[i].assets.length; j++) {
                    if (productions[i].assets[j].id == assetId) {
                        assetIndex = j;
                    }
                }

                for (uint j = assetIndex; j < productions[i].assets.length - 1; j++) {
                    productions[i].assets[j] = productions[i].assets[j + 1];
                }
                productions[i].assets.pop(); // Remove the last element
            }
        }
    }


    function getStudioProductions(bytes20 studioId) public view returns (bytes20 [] memory) {

        bytes20 studioProductions;
        
        for (uint256 i = 0; i < productions.length; i++) {
            if (productions[i].studio == studioId) {
                studioProductions.push(productions[i].id);
            }
        }
        return studioProductions;
    }

}