// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// These files are dynamically created at test time
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/JAKReferenceCoin.sol";

contract TestJAKReferenceCoin {

  function testInitialBalanceUsingDeployedContract() public {
    JAKReferenceCoin jakReferenceCoin = JAKReferenceCoin(DeployedAddresses.JAKReferenceCoin());

    uint expected = 10000;

    Assert.equal(jakReferenceCoin.getBalance(tx.origin), expected, "Owner should have 10000 JAKReferenceCoin initially");
  }

  function testInitialBalanceWithNewJAKReferenceCoin() public {
    JAKReferenceCoin jakReferenceCoin = new JAKReferenceCoin();

    uint expected = 10000;

    Assert.equal(jakReferenceCoin.getBalance(tx.origin), expected, "Owner should have 10000 JAKReferenceCoin initially");
  }
}
