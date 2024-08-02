// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract JeskeiAccount {
    Account[] accounts;

    struct Account {
        address account_address;
        bool bProducer;
        bool bConsumer;
        bool bInvestor;
        string email;
        string name;
        string profile_description;
        address profileNft;
    }

    constructor() {
    }

    function register(bool producer, bool consumer, bool investor, string memory email, string memory name, string memory description, address profileNft) public {
        Account memory newAccount = Account(msg.sender, producer, consumer, investor, email, name, description, profileNft);
        accounts.push(newAccount);
    }
}