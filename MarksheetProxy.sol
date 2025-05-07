// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MarksheetStorage.sol";

contract MarksheetProxy is MarksheetStorage {
    event Upgraded(address indexed implementation);
    
    constructor(address _implementation) {
        owner = msg.sender;
        implementation = _implementation;
    }
    
    // Modifier to restrict functions to owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    // Function to upgrade the implementation contract
    function upgradeTo(address newImplementation) external onlyOwner {
        require(newImplementation != address(0), "Invalid implementation address");
        implementation = newImplementation;
        emit Upgraded(newImplementation);
    }
    
    // Fallback function to delegate calls to the implementation contract
    fallback() external payable {
        address _impl = implementation;
        require(_impl != address(0), "Implementation contract not set");
        
        assembly {
            // Copy msg.data
            calldatacopy(0, 0, calldatasize())
            
            // Call implementation contract
            let result := delegatecall(gas(), _impl, 0, calldatasize(), 0, 0)
            
            // Copy the returned data
            returndatacopy(0, 0, returndatasize())
            
            // Forward the result
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }
    
    // Receive function
    receive() external payable {}
}