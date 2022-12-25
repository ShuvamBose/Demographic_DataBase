-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 17, 2022 at 04:29 PM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `demographic_db`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AllUserData` ()   BEGIN
DECLARE done INT DEFAULT 0;
DECLARE id,age,phone bigint;
DECLARE sex varchar(2);
DECLARE amount float;
DECLARE name, state, pid,bankname VARCHAR(30);
DECLARE cur CURSOR FOR SELECT user.id,user.name,age_cal(age.id),user.state,user.phone,gender.sex,passport.pid,banks.bankname, banks.amount FROM user,age,gender,passport,banks WHERE banks.id=user.id AND passport.id=user.id AND gender.id=user.id AND age.id=user.id;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

OPEN cur ;
label: LOOP
FETCH cur INTO id,name,age,state,phone,sex,pid,bankname,amount;
INSERT INTO alldata VALUES (id,name,age,state,phone,sex,pid,bankname,amount) ;
IF done = 1 THEN LEAVE label;

END IF;
END LOOP ;
CLOSE cur;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `location_updater` (IN `my_id` BIGINT)   BEGIN

UPDATE passport SET state = (SELECT state FROM user WHERE user.id= my_id) WHERE passport.id=my_id;

END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `age_cal` (`my_id` BIGINT) RETURNS INT(11)  BEGIN
DECLARE my_value integer;
SELECT -1*(YEAR(age.dob)-YEAR(CURDATE())) INTO my_value FROM age WHERE age.id= my_id;
RETURN my_value;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `age`
--

CREATE TABLE `age` (
  `id` bigint(20) NOT NULL,
  `dob` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `age`
--

INSERT INTO `age` (`id`, `dob`) VALUES
(123456, '1989-05-19'),
(123457, '1934-09-19'),
(123458, '2008-11-12'),
(123459, '1957-02-17'),
(123460, '2004-07-28'),
(123461, '2009-06-24'),
(123462, '2019-10-13'),
(123463, '2010-11-15'),
(123464, '1922-01-01'),
(123465, '2007-03-31'),
(123466, '1985-12-13'),
(123467, '1978-01-15'),
(123468, '2010-05-10'),
(123469, '1943-01-11');

-- --------------------------------------------------------

--
-- Table structure for table `alldata`
--

CREATE TABLE `alldata` (
  `id` bigint(20) DEFAULT NULL,
  `name` varchar(32) NOT NULL,
  `age` bigint(20) DEFAULT NULL,
  `state` varchar(32) NOT NULL,
  `phone` bigint(20) NOT NULL,
  `sex` varchar(2) DEFAULT NULL,
  `pid` varchar(16) DEFAULT NULL,
  `bankname` varchar(12) DEFAULT NULL,
  `amount` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `alldata`
--

INSERT INTO `alldata` (`id`, `name`, `age`, `state`, `phone`, `sex`, `pid`, `bankname`, `amount`) VALUES
(123463, 'Aadhithiya KS', 12, 'Tamil Nadu', 6127945721, 'M', 'FF74X', 'IDFC', 7800960),
(123456, 'Mahesh Raj', 33, 'Karnataka', 7887882598, 'M', '﻿XA34T', 'HDFC', 10000),
(123460, 'Pratyush Kumar', 18, 'Bihar', 8917008197, 'M', 'LA20O', 'DHFL', 98765400),
(123461, 'Siddharth Q', 13, 'Kerala', 8707238406, 'M', 'LX69P', 'CANARA', 49999.1),
(123465, 'Tanish', 15, 'Rajasthan', 6740120393, 'F', 'EX99Q', 'ICICI', 230000),
(123459, 'Vishwas Singh', 65, 'Bihar', 6127934216, 'M', 'HS45D', 'SBI', 30000.4),
(123458, 'Vaishnavi M', 14, 'Karnataka', 7979948063, 'F', 'BA78H', 'CORP', 2000),
(123458, 'Vaishnavi M', 14, 'Karnataka', 7979948063, 'F', 'BA78H', 'CORP', 2000);

-- --------------------------------------------------------

--
-- Table structure for table `banks`
--

CREATE TABLE `banks` (
  `id` bigint(20) DEFAULT NULL,
  `bankname` varchar(10) DEFAULT NULL,
  `username` varchar(32) NOT NULL,
  `dob` date DEFAULT NULL,
  `amount` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `banks`
--

INSERT INTO `banks` (`id`, `bankname`, `username`, `dob`, `amount`) VALUES
(123457, 'HDFC', 'AJ_666', '1934-09-19', 45000.2),
(123463, 'IDFC', 'AK_333', '2010-11-15', 7800960),
(123462, 'SBI', 'AN_012', '2019-10-13', 1500),
(123464, 'MAX', 'AR_909', '1922-01-01', 8999.99),
(123456, 'HDFC', 'MR_789', '1989-05-19', 1009),
(123460, 'DHFL', 'PK_121', '2004-07-28', 98765400),
(123461, 'CANARA', 'SQ_454', '2009-06-24', 49999.1),
(123465, 'ICICI', 'TH_356', '2007-03-31', 230000),
(123459, 'SBI', 'VK_888', '1957-02-17', 30000.4),
(123458, 'CORP', 'VM_123', '2008-11-12', 2000);

--
-- Triggers `banks`
--
DELIMITER $$
CREATE TRIGGER `bank_amt_restrict` BEFORE UPDATE ON `banks` FOR EACH ROW BEGIN

IF (new.amount < 500) THEN
	signal sqlstate '45000' set message_text = "Min. amt required to be kept is 500 !"; 
 END IF;
 END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `gender`
--

CREATE TABLE `gender` (
  `id` bigint(20) NOT NULL,
  `sex` varchar(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `gender`
--

INSERT INTO `gender` (`id`, `sex`) VALUES
(123456, 'M'),
(123457, 'F'),
(123458, 'F'),
(123459, 'M'),
(123460, 'M'),
(123461, 'M'),
(123462, 'F'),
(123463, 'M'),
(123464, 'F'),
(123465, 'F'),
(123466, 'M'),
(123467, 'M'),
(123468, 'M'),
(123469, 'F');

-- --------------------------------------------------------

--
-- Table structure for table `nri`
--

CREATE TABLE `nri` (
  `id` bigint(20) DEFAULT NULL,
  `nri_status` varchar(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `nri`
--

INSERT INTO `nri` (`id`, `nri_status`) VALUES
(123456, 'Y'),
(123457, 'Y'),
(123458, 'Y');

-- --------------------------------------------------------

--
-- Table structure for table `passport`
--

CREATE TABLE `passport` (
  `pid` varchar(10) NOT NULL,
  `sex` varchar(2) DEFAULT NULL,
  `id` bigint(20) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  `state` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `passport`
--

INSERT INTO `passport` (`pid`, `sex`, `id`, `dob`, `name`, `state`) VALUES
('BA78H', 'F', 123458, '2008-11-12', 'Vaishnavi M', 'Karnataka'),
('EX99Q', 'F', 123465, '2007-03-31', 'Tanish', 'Rajasthan\r'),
('FF74X', 'M', 123463, '2010-11-15', 'Aadhithiya KS', 'Tamil Nadu\r'),
('HS45D', 'M', 123459, '1957-02-17', 'Vishwas Singh', 'Bihar\r'),
('KK12J', 'M', 123468, '2010-05-10', 'Yakshit Reddy', 'Hyderabad\r'),
('LA20O', 'M', 123460, '2004-07-28', 'Pratyush Kumar', 'Bihar\r'),
('LX69P', 'M', 123461, '2009-06-24', 'Siddharth Q', 'Kerala\r'),
('PO13W', 'M', 123466, '1985-12-13', 'Pooshpal ', 'Gujarat\r'),
('WA53Z', 'M', 123467, '1978-01-15', 'Shuvam Bose', 'West Bengal\r'),
('ZE00Y', 'F', 123469, '1943-01-11', 'Auranagazeb', 'New Delhi\r'),
('﻿XA34T', 'M', 123456, '1989-05-19', 'Mahesh Raj', 'Karnataka');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` bigint(20) NOT NULL,
  `name` varchar(32) NOT NULL,
  `state` varchar(32) NOT NULL,
  `phone` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `name`, `state`, `phone`) VALUES
(123456, 'Mahesh Raj', 'Karnataka', 7887882598),
(123457, 'Arnav J', 'Karnataka', 6128259811),
(123458, 'Vaishnavi M', 'Karnataka', 7979948063),
(123459, 'Vishwas Singh', 'Bihar', 6127934216),
(123460, 'Pratyush Kumar', 'Bihar', 8917008197),
(123461, 'Siddharth Q', 'Kerala', 8707238406),
(123462, 'Anirudh Nair', 'Kerala', 7120721195),
(123463, 'Aadhithiya KS', 'Tamil Nadu', 6127945721),
(123464, 'Anirudh Ramesh', 'Tamil Nadu', 6127917400),
(123465, 'Tanish', 'Rajasthan', 6740120393),
(123466, 'Pooshpal ', 'Gujarat', 6740120394),
(123467, 'Shuvam Bose', 'West Bengal', 8707238776),
(123468, 'Yakshit Reddy', 'Hyderabad', 6127946921),
(123469, 'Auranagazeb', 'New Delhi', 7279948063);

-- --------------------------------------------------------

--
-- Table structure for table `wanted`
--

CREATE TABLE `wanted` (
  `id` bigint(20) DEFAULT NULL,
  `wanted_status` varchar(10) DEFAULT 'NOT NULL'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `wanted`
--

INSERT INTO `wanted` (`id`, `wanted_status`) VALUES
(123457, 'Yes'),
(123456, 'Yes'),
(123469, 'Yes');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `age`
--
ALTER TABLE `age`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `alldata`
--
ALTER TABLE `alldata`
  ADD KEY `id` (`id`);

--
-- Indexes for table `banks`
--
ALTER TABLE `banks`
  ADD PRIMARY KEY (`username`),
  ADD KEY `id` (`id`);

--
-- Indexes for table `gender`
--
ALTER TABLE `gender`
  ADD PRIMARY KEY (`id`,`sex`);

--
-- Indexes for table `nri`
--
ALTER TABLE `nri`
  ADD KEY `id` (`id`);

--
-- Indexes for table `passport`
--
ALTER TABLE `passport`
  ADD PRIMARY KEY (`pid`),
  ADD KEY `id` (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `wanted`
--
ALTER TABLE `wanted`
  ADD KEY `id` (`id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `age`
--
ALTER TABLE `age`
  ADD CONSTRAINT `age_ibfk_1` FOREIGN KEY (`id`) REFERENCES `user` (`id`);

--
-- Constraints for table `alldata`
--
ALTER TABLE `alldata`
  ADD CONSTRAINT `alldata_ibfk_1` FOREIGN KEY (`id`) REFERENCES `user` (`id`);

--
-- Constraints for table `banks`
--
ALTER TABLE `banks`
  ADD CONSTRAINT `banks_ibfk_1` FOREIGN KEY (`id`) REFERENCES `user` (`id`);

--
-- Constraints for table `gender`
--
ALTER TABLE `gender`
  ADD CONSTRAINT `gender_ibfk_1` FOREIGN KEY (`id`) REFERENCES `user` (`id`);

--
-- Constraints for table `nri`
--
ALTER TABLE `nri`
  ADD CONSTRAINT `nri_ibfk_1` FOREIGN KEY (`id`) REFERENCES `user` (`id`);

--
-- Constraints for table `passport`
--
ALTER TABLE `passport`
  ADD CONSTRAINT `passport_ibfk_1` FOREIGN KEY (`id`) REFERENCES `user` (`id`);

--
-- Constraints for table `wanted`
--
ALTER TABLE `wanted`
  ADD CONSTRAINT `wanted_ibfk_1` FOREIGN KEY (`id`) REFERENCES `user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
