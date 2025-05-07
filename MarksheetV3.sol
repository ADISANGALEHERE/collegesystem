// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MarksheetStorage.sol";

contract MarksheetV3 is MarksheetStorage {
    event StudentAdded(uint256 studentId, string name);
    event MarksUpdated(uint256 studentId, bool passed);
    
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
    
    // Update student marks with pass/fail status
    function updateMarks(
        uint256 _id, 
        uint256 _englishMarks, 
        uint256 _hindiMarks, 
        uint256 _mathMarks,
        uint256 _scienceMarks
    ) external onlyOwner {
        require(students[_id].id != 0, "Student does not exist");
        require(_englishMarks <= 100, "English marks should be <= 100");
        require(_hindiMarks <= 100, "Hindi marks should be <= 100");
        require(_mathMarks <= 100, "Math marks should be <= 100");
        require(_scienceMarks <= 100, "Science marks should be <= 100");
        
        Student storage student = students[_id];
        student.englishMarks = _englishMarks;
        student.hindiMarks = _hindiMarks;
        student.mathMarks = _mathMarks;
        student.scienceMarks = _scienceMarks;
        
        // Calculate percentage out of 400
        uint256 totalMarks = _englishMarks + _hindiMarks + _mathMarks + _scienceMarks;
        student.percentage = (totalMarks * 100) / 400;
        
        // Determine pass/fail status (>60% = pass)
        student.isPassed = student.percentage > 60;
        
        emit MarksUpdated(_id, student.isPassed);
    }
    
    // Get complete student details including pass/fail status
    function getStudent(uint256 _id) external view returns (
        uint256 id,
        string memory name,
        uint256 englishMarks,
        uint256 hindiMarks,
        uint256 mathMarks,
        uint256 scienceMarks,
        uint256 percentage,
        bool isPassed
    ) {
        Student memory student = students[_id];
        require(student.id != 0, "Student does not exist");
        
        return (
            student.id,
            student.name,
            student.englishMarks,
            student.hindiMarks,
            student.mathMarks,
            student.scienceMarks,
            student.percentage,
            student.isPassed
        );
    }
    
    // Get all student IDs
    function getAllStudentIds() external view returns (uint256[] memory) {
        return studentIds;
    }
    
    // Get only passed students
    function getPassedStudents() external view returns (uint256[] memory) {
        uint256 count = 0;
        
        // First, count passed students
        for (uint256 i = 0; i < studentIds.length; i++) {
            if (students[studentIds[i]].isPassed) {
                count++;
            }
        }
        
        // Create array of proper size
        uint256[] memory passedIds = new uint256[](count);
        
        // Fill the array
        uint256 index = 0;
        for (uint256 i = 0; i < studentIds.length; i++) {
            if (students[studentIds[i]].isPassed) {
                passedIds[index] = studentIds[i];
                index++;
            }
        }
        
        return passedIds;
    }
    
    // Get contract version
    function getVersion() external pure returns (string memory) {
        return "V3";
    }
}