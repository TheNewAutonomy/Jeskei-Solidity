// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./lib/SupportLib.sol";

contract JeskeiStudio {

    enum StudioType { Incorporated, Digital, Other }

    struct Studio {
        bytes32 id;
        string name;
        string description;
        address logoNft;
        address[] associates;
        address[] administrators;
        bytes32[] productions;
    }

    Studio[] private studios;
    bytes32[] private studioIds;

    function register(string memory name, string memory description, address logoNft) public {
        bytes32 id = keccak256(abi.encodePacked(name, description, logoNft, blockhash(block.number - 1)));

        Studio memory newStudio = Studio({
            id: id,
            name: name,
            description: description,
            logoNft: logoNft,
            associates: new address , // Initialize empty address array
            administrators: new address , // Initialize empty address array
            productions: new bytes32  // Initialize empty bytes32 array
        });

        // A studio always needs at least one associate and administrator
        newStudio.associates.push(msg.sender);
        newStudio.administrators.push(msg.sender);

        studios.push(newStudio);
        studioIds.push(id);
    }

    function getStudios() public view returns (bytes32[] memory) {
        return studioIds;
    }

    modifier checkStudioAssociate(bytes32 studio) {
        bool verified = false;

        for (uint256 i = 0; i < studios.length; i++) {
            if (studios[i].id == studio) {
                // Now find the associates from the studio
                for (uint256 j = 0; j < studios[i].associates.length; j++) {
                    if (studios[i].associates[j] == msg.sender) {
                        verified = true;
                        break;
                    }
                }
                break; // Exit outer loop if studio is found
            }
        }

        require(verified, "Not an associate");
        _;
    }

    modifier checkStudioAdministrator(bytes32 studio) {
        bool verified = false;

        for (uint256 i = 0; i < studios.length; i++) {
            if (studios[i].id == studio) {
                // Now find the administrators from the studio
                for (uint256 j = 0; j < studios[i].administrators.length; j++) {
                    if (studios[i].administrators[j] == msg.sender) {
                        verified = true;
                        break;
                    }
                }
                break; // Exit outer loop if studio is found
            }
        }

        require(verified, "Not an administrator");
        _;
    }
}
