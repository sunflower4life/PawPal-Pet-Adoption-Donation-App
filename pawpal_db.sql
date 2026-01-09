-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 09, 2026 at 05:09 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pawpal_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_adoptions`
--

CREATE TABLE `tbl_adoptions` (
  `adoption_id` int(5) NOT NULL,
  `user_id` int(5) NOT NULL,
  `pet_id` int(5) NOT NULL,
  `motivation_message` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_adoptions`
--

INSERT INTO `tbl_adoptions` (`adoption_id`, `user_id`, `pet_id`, `motivation_message`) VALUES
(1, 7, 22, 'I am on semester break');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_donations`
--

CREATE TABLE `tbl_donations` (
  `donation_id` int(5) NOT NULL,
  `user_id` int(5) NOT NULL,
  `pet_id` int(5) NOT NULL,
  `donation_type` varchar(50) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `description` varchar(500) NOT NULL,
  `payment_status` varchar(50) NOT NULL,
  `receipt_id` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_donations`
--

INSERT INTO `tbl_donations` (`donation_id`, `user_id`, `pet_id`, `donation_type`, `amount`, `description`, `payment_status`, `receipt_id`) VALUES
(1, 6, 23, 'Food', 0.00, 'I am going to donate a royal canin & purina.', '', ''),
(2, 6, 21, 'Money', 100.00, '', '', ''),
(3, 6, 19, 'Food', 0.00, 'I am donating 5 packets of whiskas', '', ''),
(4, 6, 21, 'Money', 230.00, '', '', ''),
(5, 6, 15, 'Food', 0.00, 'Donate a rabbit food', '', ''),
(6, 6, 11, 'Food', 0.00, 'Donate a whiskas', '', ''),
(7, 6, 21, 'Food', 0.00, 'I want to give cat food', '', ''),
(8, 5, 19, 'Food', 0.00, 'I am going to give a food to buntut', '', ''),
(9, 5, 21, 'Money', 10.00, '', '', ''),
(10, 5, 21, 'Money', 5.00, '', '', ''),
(11, 5, 21, 'Money', 4.00, '', '', ''),
(12, 5, 21, 'Money', 1.00, '', '', ''),
(13, 5, 20, 'Money', 1.00, '', '', ''),
(14, 5, 19, 'Money', 1.00, '', '', ''),
(15, 5, 20, 'Money', 1.00, '', '', ''),
(16, 5, 21, 'Money', 1.00, '', '', ''),
(17, 5, 21, 'Money', 2.00, '', '', ''),
(18, 7, 19, 'Medical', 0.00, 'send medicine', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pets`
--

CREATE TABLE `tbl_pets` (
  `pet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_name` varchar(100) NOT NULL,
  `pet_gender` varchar(50) NOT NULL,
  `pet_age` int(5) NOT NULL,
  `pet_health` varchar(50) NOT NULL,
  `pet_type` varchar(50) NOT NULL,
  `category` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `image_paths` text NOT NULL,
  `lat` varchar(50) NOT NULL,
  `lng` varchar(50) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_pets`
--

INSERT INTO `tbl_pets` (`pet_id`, `user_id`, `pet_name`, `pet_gender`, `pet_age`, `pet_health`, `pet_type`, `category`, `description`, `image_paths`, `lat`, `lng`, `created_at`) VALUES
(3, 6, 'Snoppy', '', 0, '', 'Dog', 'Donation Request', 'Open for donation including food', '[\"assets/pets/pet_3_1.png\",\"assets/pets/pet_3_2.png\",\"assets/pets/pet_3_3.png\"]', '6.4484867', '100.5096783', '2025-12-05 13:47:57'),
(4, 6, 'Greyishhi', '', 0, '', 'Cat', 'Donation Request', 'Looking for donation to help greyish get the food', '[\"assets/pets/pet_4_1.png\",\"assets/pets/pet_4_2.png\",\"assets/pets/pet_4_3.png\"]', '6.4484867', '100.5096783', '2025-12-05 14:13:41'),
(5, 6, 'Labubu', '', 0, '', 'Cat', 'Help/Rescue', 'Looking for stray cat in changlun area', '[\"assets/pets/pet_5_1.png\"]', '6.4484867', '100.5096783', '2025-12-05 15:47:19'),
(6, 7, 'Broo', '', 0, '', 'Cat', 'Donation Request', 'Looking for donation for food', '[\"assets/pets/pet_6_1.png\"]', '6.4484867', '100.5096783', '2025-12-05 16:13:02'),
(7, 7, 'Diggy', '', 0, '', 'Dog', 'Help/Rescue', 'Help diggy bla bla bla', '[\"assets/pets/pet_7_1.png\",\"assets/pets/pet_7_2.png\"]', '6.4484867', '100.5096783', '2025-12-05 20:54:28'),
(11, 7, 'kitty', '', 0, '', 'Cat', 'Donation Request', 'Looking for donation for kitty', '[\"assets/pets/pet_11_1.png\"]', '6.1248633', '100.3667933', '2025-12-06 02:19:32'),
(14, 7, 'Rabitty', '', 0, '', 'Rabbit', 'Adoption', 'Looking for adoption during weekday only', '[\"assets/pets/pet_14_1.png\",\"assets/pets/pet_14_2.png\"]', '6.1248633', '100.3667933', '2025-12-06 04:08:09'),
(15, 7, 'WhityBit', '', 0, '', 'Rabbit', 'Donation Request', 'Looking for adoption', '[\"assets/pets/pet_15_1.png\",\"assets/pets/pet_15_2.png\",\"assets/pets/pet_15_3.png\"]', '6.1248633', '100.3667933', '2025-12-06 04:21:32'),
(16, 5, 'Catty', '', 0, '', 'Cat', 'Donation Request', 'Looking for donation', '[\"assets/pets/pet_16_1.png\",\"assets/pets/pet_16_2.png\",\"assets/pets/pet_16_3.png\"]', '6.4484867', '100.5096783', '2025-12-06 12:01:52'),
(17, 5, 'Rabbitty', '', 0, '', 'Rabbit', 'Adoption', 'Looking for adoption', '[\"assets/pets/pet_17_1.png\"]', '6.4484867', '100.5096783', '2025-12-06 12:04:27'),
(18, 8, 'Bitty', '', 0, '', 'Rabbit', 'Adoption', 'looking for adoption for rabbity', '[\"assets/pets/pet_18_1.png\"]', '6.46749', '100.5072583', '2026-01-02 03:07:01'),
(19, 8, 'buntut', 'Female', 5, 'Healthy', 'Rabbit', 'Donation Request', 'Looking for donation', '[\"assets/pets/pet_19_1.png\"]', '6.46749', '100.5072583', '2026-01-02 03:13:44'),
(20, 8, 'Blackky', 'Female', 6, 'Healthy', 'Cat', 'Donation Request', 'Looking for donation for blackky', '[\"assets/pets/pet_20_1.png\"]', '6.5097417', '100.42039', '2026-01-03 14:25:09'),
(21, 7, 'Coppy', 'Female', 7, 'Recovering', 'Rabbit', 'Donation Request', 'Looking for donation for coppy because shes still in her recovery from sick', '[\"assets/pets/pet_21_1.png\"]', '6.5097417', '100.42039', '2026-01-03 14:29:08'),
(22, 7, 'Bibi', 'Male', 11, 'Healthy', 'Cat', 'Adoption', 'Looking for adoption for 3 weeks', '[\"assets/pets/pet_22_1.png\"]', '5.4140967', '100.3285267', '2026-01-03 14:31:30'),
(23, 5, 'greyish', 'Male', 5, 'Recovering', 'Cat', 'Help/Rescue', 'Needing help for greyish because he\'s still in recovery', '[\"assets/pets/pet_23_1.png\"]', '5.4140967', '100.3285267', '2026-01-03 14:33:40');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(5) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `reg_date` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `profile_image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `name`, `email`, `password`, `phone`, `reg_date`, `profile_image`) VALUES
(1, 'nabila', 'nabila@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '014-6785467', '2025-11-23 12:35:00.809582', NULL),
(2, 'syafieqah', 'syaf@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '01904567234', '2025-11-23 12:37:39.293589', NULL),
(3, 'nadhirah', 'nadhirah@gamail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '019-4523678', '2025-11-23 12:52:08.527005', NULL),
(4, 'adam', 'adam@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '019-5673456', '2025-11-23 12:54:59.758405', NULL),
(5, 'nurul syafieqah', 'nurul@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '019-4562378', '2025-11-23 13:00:56.642453', 'profile_5.jpg'),
(6, 'mayyo', 'may@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '019-6785423', '2025-11-23 13:12:37.681936', 'profile_6.jpg'),
(7, 'izzah izzati', 'izzah@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '098-12345679', '2025-12-05 16:11:49.348270', 'profile_7.jpg'),
(8, 'labubu', 'bubu@gmail.com', '20eabe5d64b0e216796e834f52d61fd0b70332fc', '012-6745367', '2026-01-02 02:09:11.241001', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  ADD PRIMARY KEY (`adoption_id`);

--
-- Indexes for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  ADD PRIMARY KEY (`donation_id`);

--
-- Indexes for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD PRIMARY KEY (`pet_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  MODIFY `adoption_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  MODIFY `donation_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  MODIFY `pet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
