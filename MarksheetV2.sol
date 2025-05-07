// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MarksheetStorage.sol";

contract MarksheetV2 is MarksheetStorage {
    event StudentAdded(uint256 studentId, string name);
    event MarksUpdated(uint256 studentId);
    
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
    
    // Update student marks with Science subject added
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
        
        emit MarksUpdated(_id);
    }
    
    // Get student details including science marks
    function getStudent(uint256 _id) external view returns (
        uint256 id,
        string memory name,
        uint256 englishMarks,
        uint256 hindiMarks,
        uint256 mathMarks,
        uint256 scienceMarks,
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
            student.scienceMarks,
            student.percentage
        );
    }
    
    // Get all student IDs
    function getAllStudentIds() external view returns (uint256[] memory) {
        return studentIds;
    }
    
    // Get contract version
    function getVersion() external pure returns (string memory) {
        return "V2";
    }
}