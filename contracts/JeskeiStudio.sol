// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

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

    mapping(bytes32 => Studio) private studios;
    bytes32[] private studioIds;
    mapping(bytes32 => mapping(address => bool)) private isAssociate;
    mapping(bytes32 => mapping(address => bool)) private isAdministrator;

    event StudioRegistered(bytes32 id, string name, string description, address logoNft);

    function register(string memory name, string memory description, address logoNft) public {
        bytes32 id = keccak256(abi.encodePacked(name, description, logoNft, blockhash(block.number - 1)));

        require(studios[id].id == 0, "Studio already exists");

        Studio storage newStudio = studios[id];
        newStudio.id = id;
        newStudio.name = name;
        newStudio.description = description;
        newStudio.logoNft = logoNft;
        newStudio.associates.push(msg.sender);
        newStudio.administrators.push(msg.sender);

        studioIds.push(id);
        isAssociate[id][msg.sender] = true;
        isAdministrator[id][msg.sender] = true;

        emit StudioRegistered(id, name, description, logoNft);
    }

    function getStudios() public view returns (bytes32[] memory) {
        return studioIds;
    }

    modifier checkStudioAssociate(bytes32 studio) {
        require(isAssociate[studio][msg.sender], "Not an associate");
        _;
    }

    modifier checkStudioAdministrator(bytes32 studio) {
        require(isAdministrator[studio][msg.sender], "Not an administrator");
        _;
    }
}
