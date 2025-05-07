// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MarksheetStorage.sol";

contract MarksheetV1 is MarksheetStorage {
    event StudentAdded(uint256 studentId, string name);
    event MarksUpdated(uint256 studentId);
    
    function initialize() external {
        require(owner == address(0), "Contract already initialized");
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    // Add a new student
    function addStudent(uint256 _id, string memory _name) external onlyOwner {
        require(students[_id].id == 0, "Student already exists");
        
        Student storage newStudent = students[_id];
        newStudent.id = _id;
        newStudent.name = _name;
        
        studentIds.push(_id);
        
        emit StudentAdded(_id, _name);
    }
    
    // Update student marks
    function updateMarks(
        uint256 _id, 
        uint256 _englishMarks, 
        uint256 _hindiMarks, 
        uint256 _mathMarks
    ) external onlyOwner {
        require(students[_id].id != 0, "Student does not exist");
        require(_englishMarks <= 100, "English marks should be <= 100");
        require(_hindiMarks <= 100, "Hindi marks should be <= 100");
        require(_mathMarks <= 100, "Math marks should be <= 100");
        
        Student storage student = students[_id];
        student.englishMarks = _englishMarks;
        student.hindiMarks = _hindiMarks;
        student.mathMarks = _mathMarks;
        
        // Calculate percentage out of 300
        uint256 totalMarks = _englishMarks + _hindiMarks + _mathMarks;
        student.percentage = (totalMarks * 100) / 300;
        
        emit MarksUpdated(_id);
    }
    
    // Get student details
    function getStudent(uint256 _id) external view returns (
        uint256 id,
        string memory name,
        uint256 englishMarks,
        uint256 hindiMarks,
        uint256 mathMarks,
        uint256 percentage
    ) {
        Student memory student = students[_id];
        require(student.id != 0, "Student does not exist");
        
        return (
            student.id,
            student.name,
            student.englishMarks,
            student.hindiMarks,
            student.mathMarks,
            student.percentage
        );
    }
    
    // Get all student IDs
    function getAllStudentIds() external view returns (uint256[] memory) {
        return studentIds;
    }
    
    // Get contract version
    function getVersion() external pure returns (string memory) {
        return "V1";
    }
}