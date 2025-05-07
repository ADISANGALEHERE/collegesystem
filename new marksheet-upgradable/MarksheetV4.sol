// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract V4Marksheet {

    struct MarksHistory {
        uint english;
        uint hindi;
        uint math;
        uint science;
        uint percentage;
        uint timestamp;
        address transactionSender; // Store address instead of string
    }

    struct Student {
        string name;
        uint currentEnglish;
        uint currentHindi;
        uint currentMath;
        uint currentPercentage;
        uint currentScience;
        MarksHistory[] history;
    }

    mapping(uint => Student) public students;

    // Add or Update student marks and track history
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

        // Store previous marks in history
        if (bytes(students[id].name).length > 0) {
            MarksHistory memory prevHistory = MarksHistory({
                english: students[id].currentEnglish,
                hindi: students[id].currentHindi,
                math: students[id].currentMath,
                science: students[id].currentScience,
                percentage: students[id].currentPercentage,
                timestamp: block.timestamp,
                transactionSender: tx.origin // Track the transaction sender address
            });
            students[id].history.push(prevHistory);
        }

        // Update student data
        students[id].name = name;
        students[id].currentEnglish = english;
        students[id].currentHindi = hindi;
        students[id].currentMath = math;
        students[id].currentScience = science;
        students[id].currentPercentage = percentage;
    }

    // View student details with full history
    function getStudent(uint id) public view returns (Student memory) {
        return students[id];
    }

    // Get the history of a student with all previous versions of marks
    function getStudentHistory(uint id) public view returns (MarksHistory[] memory) {
        return students[id].history;
    }
}
