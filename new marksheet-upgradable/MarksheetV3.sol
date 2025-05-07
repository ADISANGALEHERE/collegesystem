// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract V3Marksheet {
    struct Student {
        string name;
        uint english;
        uint hindi;
        uint math;
        uint percentage; // same slot as V1
        uint science;    // same slot as V2
        bool isPass;     // new slot in V3
    }

    mapping(uint => Student) public students;

    function addOrUpdateStudent(
        uint id,
        string memory name,
        uint english,
        uint hindi,
        uint math,
        uint science
    ) public {
        require(english <= 100 && hindi <= 100 && math <= 100 && science <= 100, "Marks must be <= 100");

        uint total = english + hindi + math + science;
        uint percentage = (total * 100) / 400;
        bool isPass = percentage >= 60;

        students[id] = Student(name, english, hindi, math, percentage, science, isPass);
    }

    function updateScienceMarks(uint id, uint science) public {
        require(science <= 100, "Science marks must be <= 100");

        Student storage s = students[id];
        s.science = science;

        uint total = s.english + s.hindi + s.math + s.science;
        s.percentage = (total * 100) / 400;
        s.isPass = s.percentage >= 60;
    }

    function getStudent(uint id) public view returns (Student memory) {
        return students[id];
    }
}
