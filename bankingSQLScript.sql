CREATE DATABASE `bank01` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE bank01;

-- bank01.Branch definition

CREATE TABLE `Branch` (
  `branchID` int NOT NULL AUTO_INCREMENT,
  `officeAddress` varchar(255) DEFAULT NULL,
  `branchName` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`branchID`)
);


-- bank01.Department definition

CREATE TABLE `Department` (
  `did` int NOT NULL AUTO_INCREMENT,
  `dname` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`did`)
);


-- bank01.Branch_has definition

CREATE TABLE `Branch_has` (
  `branchID` int NOT NULL,
  `did` int NOT NULL,
  PRIMARY KEY (`branchID`,`did`),
  KEY `Branch_has_FK_1` (`did`),
  CONSTRAINT `Branch_has_FK` FOREIGN KEY (`branchID`) REFERENCES `Branch` (`branchID`),
  CONSTRAINT `Branch_has_FK_1` FOREIGN KEY (`did`) REFERENCES `Department` (`did`) #DEPARTMENTS AND BRANCHES RARELY CHANGE, WOULD NOT WANT TO ACCIDENTLY RE-CONFIGURE THESE
);


-- bank01.Customer definition

CREATE TABLE `Customer` (
  `cid` int NOT NULL AUTO_INCREMENT,
  `fname` varchar(100) DEFAULT NULL,
  `lname` varchar(100) DEFAULT NULL,
  `SSN` varchar(15) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`cid`),
  UNIQUE KEY `Customer_UN` (`email`,`username`,`SSN`)
);
INSERT INTO Customer (cid,SSN) VALUES (11,'(427)-26-8806');
SELECT * FROM Customer;
CREATE VIEW Customer_View AS SELECT cid,fname,lname,username,SSN FROM Customer;
SELECT * FROM Customer_View;

-- bank01.Employee definition

CREATE TABLE `Employee` (
  `eid` int NOT NULL AUTO_INCREMENT,
  `salary` decimal(10,0) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `position` varchar(100) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `fname` varchar(100) DEFAULT NULL,
  `lname` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`eid`),
  UNIQUE KEY `Employee_UN` (`username`)
);


-- bank01.Checkings_Account definition

CREATE TABLE `Checkings_Account` (
  `aid` int NOT NULL AUTO_INCREMENT,
  `accType` varchar(10) DEFAULT NULL,
  `balance` decimal(10,0) DEFAULT NULL,
  `overdraftAmount` decimal(10,0) DEFAULT NULL,
  `cid` int DEFAULT NULL,
  PRIMARY KEY (`aid`),
  KEY `Checkings_Account_FK` (`cid`),
  CONSTRAINT `Checkings_Account_FK` FOREIGN KEY (`cid`) REFERENCES `Customer` (`cid`) ON DELETE CASCADE #CUSTOMERS CAN DELETE THEIR ACCOUNTS
);

CREATE INDEX IX_CheckingsAccount_cid #Finding cid when accessing checkings. Quicker to sort through all the cid's if Indexed.
ON Checkings_Account(cid);

CREATE INDEX IX_SavingsAccount_cid #Finding cid when accessing savings. Quicker to sort through all the cid's if Indexed
ON Savings_Account(cid);

CREATE INDEX IX_InsurancePolicy_eid #A lot of employees under the Insurance Policy. Index to sort through the eid's.
ON Insurance_Policy(eid);



-- bank01.Insurance_Policy definition

CREATE TABLE `Insurance_Policy` (
  `pname` varchar(100) NOT NULL,
  `policyType` varchar(100) DEFAULT NULL,
  `cost` decimal(10,0) DEFAULT NULL,
  `eid` int NOT NULL,
  `age` int DEFAULT NULL,
  PRIMARY KEY (`pname`,`eid`),
  KEY `Insurance_Policy_FK` (`eid`),
  CONSTRAINT `Insurance_Policy_FK` FOREIGN KEY (`eid`) REFERENCES `Employee` (`eid`) #WOULDN'T WANT INSURANCE TO BE ABLE TO DELETE/UPDATE AN EMPLOYEES ID, THEY JUST KNOW IT
);


-- bank01.Manager definition

CREATE TABLE `Manager` (
  `did` int NOT NULL,
  `eid` int NOT NULL,
  `branchID` int NOT NULL,
  PRIMARY KEY (`did`,`eid`,`branchID`),
  UNIQUE KEY `Manager_UN` (`eid`),
  KEY `Manager_FK` (`branchID`),
  CONSTRAINT `Manager_FK` FOREIGN KEY (`branchID`) REFERENCES `Branch` (`branchID`),
  CONSTRAINT `Manager_FK_1` FOREIGN KEY (`did`) REFERENCES `Department` (`did`),
  CONSTRAINT `Manager_FK_2` FOREIGN KEY (`eid`) REFERENCES `Employee` (`eid`) ON DELETE CASCADE  #EMPLOYEE IDs CAN CHANGE OR DELETED WHEN LEAVING THE JOB
);

-- bank01.Savings_Account definition

CREATE TABLE `Savings_Account` (
  `aid` int NOT NULL AUTO_INCREMENT,
  `accType` varchar(10) DEFAULT NULL,
  `balance` decimal(10,0) DEFAULT NULL,
  `interestRate` int DEFAULT NULL,
  `cid` int DEFAULT NULL,
  PRIMARY KEY (`aid`),
  KEY `Savings_Account_FK` (`cid`),
  CONSTRAINT `Savings_Account_FK` FOREIGN KEY (`cid`) REFERENCES `Customer` (`cid`) ON DELETE CASCADE #CUSTOMERS CAN DELETE THEIR ACCOUNTS
);

-- bank01.Serves definition

CREATE TABLE `Serves` (
  `branchID` int NOT NULL,
  `cid` int NOT NULL,
  PRIMARY KEY (`branchID`,`cid`),
  KEY `Serves_FK_1` (`cid`),
  CONSTRAINT `Serves_FK` FOREIGN KEY (`branchID`) REFERENCES `Branch` (`branchID`),
  CONSTRAINT `Serves_FK_1` FOREIGN KEY (`cid`) REFERENCES `Customer` (`cid`) 
);

-- bank01.Works_In definition

CREATE TABLE `Works_In` (
  `did` int NOT NULL,
  `eid` int NOT NULL,
  PRIMARY KEY (`did`,`eid`),
  KEY `Works_In_FK_1` (`eid`),
  CONSTRAINT `Works_In_FK` FOREIGN KEY (`did`) REFERENCES `Department` (`did`), 
  CONSTRAINT `Works_In_FK_1` FOREIGN KEY (`eid`) REFERENCES `Employee` (`eid`)
  );