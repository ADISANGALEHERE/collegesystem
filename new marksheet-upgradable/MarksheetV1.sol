// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract V1Marksheet {
    struct Student {
        string name;
        uint english;
        uint hindi;
        uint math;
        uint percentage; // out of 300
    }

    mapping(uint => Student) public students;

    function addStudent(uint id, string memory name, uint english, uint hindi, uint math) public {
        require(english <= 100 && hindi <= 100 && math <= 100, "Marks must be <= 100");
        uint total = english + hindi + math;
        uint percentage = (total * 100) / 300;

        students[id] = Student(name, english, hindi, math, percentage);
    }

    function getStudent(uint id) public view returns (Student memory) {
        return students[id];
    }
}
