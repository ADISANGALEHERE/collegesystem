// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MarksheetStorage {
    // Storage structure for our upgradable contract
    struct Student {
        uint256 id;
        string name;
        uint256 englishMarks;
        uint256 hindiMarks;
        uint256 mathMarks;
        uint256 scienceMarks;
        uint256 percentage;
        bool isPassed;
    }
    
    // Mapping from student ID to Student struct
    mapping(uint256 => Student) internal students;
    
    // Array to keep track of all student IDs
    uint256[] internal studentIds;
    
    // Address of the owner
    address internal owner;
    
    // Address of the current implementation contract
    address internal implementation;
}