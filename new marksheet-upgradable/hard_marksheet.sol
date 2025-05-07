// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MarksheetManagement {
    address public owner;
    bool public paused = false;

    mapping(address => bool) private teachers;

    struct Student {
        string name;
        uint256 rollNumber;
        bool registered;
    }

    struct Marksheet {
        uint256[] subjectMarks;
        uint256 totalMarks;
        string grade;
        uint256 lastUpdated;
    }

    mapping(address => Student) public students;
    mapping(address => Marksheet) private marksheets;

    event StudentRegistered(address indexed studentAddress, string name, uint256 rollNumber);
    event MarksAssigned(address indexed studentAddress, uint256[] marks, string grade);
    event MarksUpdated(address indexed studentAddress, uint256[] oldMarks, uint256[] newMarks);
    event ContractPaused(address indexed by);
    event ContractUnpaused(address indexed by);
    event TeacherAdded(address indexed teacher);
    event TeacherRemoved(address indexed teacher);

    modifier onlyOwner() {
        require(msg.sender == owner, "Access Denied: Only owner");
        _;
    }

    modifier onlyTeacher() {
        require(teachers[msg.sender], "Access Denied: Only teacher");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    constructor() {
        owner = msg.sender;
        teachers[msg.sender] = true; // deployer is a teacher by default
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }

    function addTeacher(address teacher) public onlyOwner {
        require(!teachers[teacher], "Already a teacher");
        teachers[teacher] = true;
        emit TeacherAdded(teacher);
    }

    function removeTeacher(address teacher) public onlyOwner {
        require(teachers[teacher], "Not a teacher");
        teachers[teacher] = false;
        emit TeacherRemoved(teacher);
    }

    function pause() public onlyOwner {
        paused = true;
        emit ContractPaused(msg.sender);
    }

    function unpause() public onlyOwner {
        paused = false;
        emit ContractUnpaused(msg.sender);
    }

    function registerStudent(address studentAddr, string memory name, uint256 rollNumber) public onlyOwner whenNotPaused {
        require(!students[studentAddr].registered, "Student already registered");
        students[studentAddr] = Student(name, rollNumber, true);
        emit StudentRegistered(studentAddr, name, rollNumber);
    }

    function assignMarks(address studentAddr, uint256[] memory subjectMarks) public onlyTeacher whenNotPaused {
        require(students[studentAddr].registered, "Student not registered");
        require(subjectMarks.length > 0, "No marks provided");

        uint256 total = 0;
        for (uint256 i = 0; i < subjectMarks.length; i++) {
            require(subjectMarks[i] <= 100, "Invalid mark: must be <= 100");
            total += subjectMarks[i];
        }

        string memory grade = calculateGrade(total / subjectMarks.length);

        if (marksheets[studentAddr].lastUpdated != 0) {
            emit MarksUpdated(studentAddr, marksheets[studentAddr].subjectMarks, subjectMarks);
        } else {
            emit MarksAssigned(studentAddr, subjectMarks, grade);
        }

        marksheets[studentAddr] = Marksheet(subjectMarks, total, grade, block.timestamp);
    }

    function getMarksheet(address studentAddr) public view returns (
        string memory name,
        uint256 rollNumber,
        uint256[] memory subjectMarks,
        uint256 totalMarks,
        string memory grade,
        uint256 lastUpdated
    ) {
        require(students[studentAddr].registered, "Student not registered");
        Student memory s = students[studentAddr];
        Marksheet memory m = marksheets[studentAddr];
        return (s.name, s.rollNumber, m.subjectMarks, m.totalMarks, m.grade, m.lastUpdated);
    }

    function calculateGrade(uint256 average) internal pure returns (string memory) {
        if (average >= 90) return "A+";
        else if (average >= 80) return "A";
        else if (average >= 70) return "B";
        else if (average >= 60) return "C";
        else if (average >= 50) return "D";
        else return "F";
    }

    function isTeacher(address account) public view returns (bool) {
        return teachers[account];
    }
}
