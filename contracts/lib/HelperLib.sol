// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// A library is like a contract with reusable code, which can be called by other contracts.
// Deploying common code can reduce gas costs.
library HelperLib{
	
	function convert(uint amount, uint conversionRate) public pure returns (uint convertedAmount)
	{
		return amount * conversionRate;
	}

	// Converts a uint256 to its ASCII string decimal representation
    function toString(uint256 value) internal pure returns (string memory) {
        // If the value is zero, return "0"
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        // Count the number of digits in the number
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        // Create a buffer to hold the number as a string
        bytes memory buffer = new bytes(digits);
        // Convert each digit to a character
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        // Return the final string
        return string(buffer);
    }

    // Concatenates two strings and returns the result
    function concatenate(string memory str1, string memory str2) public pure returns (string memory) {
        return string(abi.encodePacked(str1, str2));
    }
}
