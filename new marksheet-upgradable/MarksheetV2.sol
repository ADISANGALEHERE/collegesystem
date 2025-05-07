// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract V2Marksheet {
    struct Student {
        string name;
        uint english;
        uint hindi;
        uint math;
        uint percentage; // same slot as V1
        uint science;    // new slot in V2
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

        students[id] = Student(name, english, hindi, math, percentage, science);
    }

    function getStudent(uint id) public view returns (Student memory) {
        return students[id];
    }
}
