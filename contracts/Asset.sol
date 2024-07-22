// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract JeskeiAsset {
    enum AssetType{ Video, Audio, Script, Object, Film_Score, Physical_Asset, Other }

    struct Asset {
        bytes32 id;
        AssetType asset_type;
        address owner;
        LocationType locationType;
        string location;
    }

    enum LocationType{ Onchain, IPFS, Offchain, Other }
    Asset[] assets;

    function register(AssetType _asset_type, address _owner, uint _locationType, string memory _location) public {
        
        bytes32 id = keccak256(abi.encodePacked(_asset_type, _owner, _locationType, _location, blockhash(block.number - 1)));

        LocationType locationType;
        string memory location;

        if (_locationType == 0) {
            locationType = LocationType.Onchain;
            location = location;
        } else if (_locationType == 1) {
            locationType = LocationType.IPFS;
            location = location;
        } else if (_locationType == 2) {
            locationType = LocationType.Offchain;
            location = location;
        } else if (_locationType == 3) {
            locationType = LocationType.Other;
            location = location;
        }
        
        Asset memory newAsset = Asset(id, _asset_type, _owner, locationType, location);

        assets.push(newAsset);
    }
}
