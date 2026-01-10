-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 10, 2026 at 03:15 AM
-- Server version: 10.3.39-MariaDB-log-cll-lve
-- PHP Version: 8.1.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `musicbvk_pawpal_db_azri`
--
CREATE DATABASE IF NOT EXISTS `musicbvk_pawpal_db_azri` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `musicbvk_pawpal_db_azri`;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_adoptions`
--

CREATE TABLE `tbl_adoptions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `submission_id` int(11) NOT NULL,
  `motivation` text NOT NULL,
  `update_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_donations`
--

CREATE TABLE `tbl_donations` (
  `donation_id` int(11) NOT NULL,
  `pet_id` varchar(50) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `donation_type` enum('Money','Food','Medical') NOT NULL,
  `amount` decimal(10,2) DEFAULT 0.00,
  `description` text DEFAULT NULL,
  `donor_name` varchar(255) NOT NULL,
  `donor_email` varchar(255) NOT NULL,
  `donor_phone` varchar(20) NOT NULL,
  `donation_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_donations`
--

INSERT INTO `tbl_donations` (`donation_id`, `pet_id`, `user_id`, `donation_type`, `amount`, `description`, `donor_name`, `donor_email`, `donor_phone`, `donation_date`) VALUES
(1, '1', '1', 'Food', 0.00, 'i love eat food', 'azri', 'azri@gmail.com', '0194444555', '2026-01-09 12:29:16'),
(2, '1', '1', 'Medical', 0.00, 'i wanna give him vaccine for the animal\n', 'azri', 'azri@gmail.com', '0194444555', '2026-01-10 00:22:00'),
(3, '', '', 'Money', 10.00, 'Billplz Transaction ID: 07319645d39a6340 | Donation for Pet ID: ', '', '', '', '2026-01-10 00:29:14'),
(4, '', '', 'Money', 10.00, 'Billplz Transaction ID: 67c4af008fdde282 | Donation for Pet ID: ', '', '', '', '2026-01-10 00:32:22'),
(5, '', '', 'Money', 100.00, 'Billplz Transaction ID: 14a6cda674428f49 | Donation for Pet ID: ', '', '', '', '2026-01-10 00:35:25');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pets`
--

CREATE TABLE `tbl_pets` (
  `pet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_name` varchar(100) NOT NULL,
  `pet_type` varchar(50) NOT NULL,
  `category` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `image_paths` varchar(50) NOT NULL,
  `lat` varchar(50) NOT NULL,
  `lng` varchar(50) NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `age` int(2) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `health` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_pets`
--

INSERT INTO `tbl_pets` (`pet_id`, `user_id`, `pet_name`, `pet_type`, `category`, `description`, `image_paths`, `lat`, `lng`, `created_at`, `age`, `gender`, `health`) VALUES
(1, 1, 'gayes', 'Dog', 'Donation Request', 'this gayes, he need money', '[\"pawpal/assets/uploads/pet_1_1.png\",\"pawpal/asset', '6.4811498', '100.5089173', '2026-01-09 12:26:46.866666', 0, 'Male', 'Healthy');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_profile`
--

CREATE TABLE `tbl_profile` (
  `user_id` int(11) NOT NULL,
  `profile_img` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_profile`
--

INSERT INTO `tbl_profile` (`user_id`, `profile_img`) VALUES
(1, 'pawpal/assets/profile/profile_1.png');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `password` varchar(225) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `reg_date` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `user_credit` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `email`, `name`, `password`, `phone`, `reg_date`, `user_credit`) VALUES
(1, 'azri@gmail.com', 'azri', '7c4a8d09ca3762af61e59520943dc26494f8941b', '0194444555', '2025-11-02 09:27:23.965748', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `pet_id` (`pet_id`);

--
-- Indexes for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  ADD PRIMARY KEY (`donation_id`),
  ADD KEY `pet_id` (`pet_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `donation_date` (`donation_date`);

--
-- Indexes for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD PRIMARY KEY (`pet_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `tbl_profile`
--
ALTER TABLE `tbl_profile`
  ADD PRIMARY KEY (`user_id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  MODIFY `donation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  MODIFY `pet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  ADD CONSTRAINT `tbl_adoptions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tbl_adoptions_ibfk_2` FOREIGN KEY (`pet_id`) REFERENCES `tbl_pets` (`pet_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD CONSTRAINT `tbl_pets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_profile`
--
ALTER TABLE `tbl_profile`
  ADD CONSTRAINT `tbl_profile_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
--
-- Database: `musicbvk_pawpal_db_faiz`
--
CREATE DATABASE IF NOT EXISTS `musicbvk_pawpal_db_faiz` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `musicbvk_pawpal_db_faiz`;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_adoptions`
--

CREATE TABLE `tbl_adoptions` (
  `adoption_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `motivation_message` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_adoptions`
--

INSERT INTO `tbl_adoptions` (`adoption_id`, `user_id`, `pet_id`, `motivation_message`, `created_at`) VALUES
(1, 12, 9, 'i have to admit totty is soo cute', '2026-01-09 12:58:51'),
(2, 12, 1, 'i just lost my dog and tannie really reminds me of him T_T', '2026-01-09 17:43:25'),
(3, 12, 6, 'Simba really seems playful and affectionate. My daughter really loves having playful and affectionate animal', '2026-01-09 18:23:11'),
(4, 12, 7, 'i meann look at the bow... HE IS SOO CUTE', '2026-01-09 19:40:13');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_donations`
--

CREATE TABLE `tbl_donations` (
  `donation_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `donation_type` varchar(50) NOT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_donations`
--

INSERT INTO `tbl_donations` (`donation_id`, `user_id`, `pet_id`, `donation_type`, `amount`, `created_at`) VALUES
(1, 12, 2, 'Money', 20.00, '2026-01-09 09:28:42'),
(2, 12, 2, 'Money', 90.00, '2026-01-09 09:52:53'),
(3, 12, 2, 'Medical', NULL, '2026-01-09 10:21:07'),
(4, 12, 2, 'Food', NULL, '2026-01-09 10:21:13'),
(5, 12, 2, 'Money', 100.00, '2026-01-09 10:21:23'),
(6, 12, 2, 'Money', 20.00, '2026-01-09 17:52:29'),
(7, 12, 2, 'Money', 10.00, '2026-01-09 17:54:11'),
(8, 12, 2, 'Money', 10.00, '2026-01-09 17:55:53'),
(9, 12, 2, 'Money', 3.00, '2026-01-09 17:58:18'),
(10, 12, 2, 'Money', 4.00, '2026-01-09 18:06:17');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pets`
--

CREATE TABLE `tbl_pets` (
  `pet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_name` varchar(100) NOT NULL,
  `pet_type` varchar(50) NOT NULL,
  `pet_gender` varchar(10) DEFAULT NULL,
  `pet_age` float DEFAULT NULL,
  `pet_health` varchar(50) DEFAULT NULL,
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

INSERT INTO `tbl_pets` (`pet_id`, `user_id`, `pet_name`, `pet_type`, `pet_gender`, `pet_age`, `pet_health`, `category`, `description`, `image_paths`, `lat`, `lng`, `created_at`) VALUES
(1, 10, 'Tannie', 'Dog', 'male', 3, 'Healthy', 'Adoption', 'Energetic and Loves running', '[\"assets/pets/pet_1_1.png\",\"assets/pets/pet_1_2.png\"]', '6.4605127', '100.4993932', '2025-12-06 01:33:12'),
(2, 10, 'Bami', 'Dog', 'male', 2.5, 'Healthy', 'Donation', 'Loves playing outside', '[\"assets/pets/pet_2_1.png\",\"assets/pets/pet_2_2.png\"]', '6.4605127', '100.4993932', '2025-12-06 01:34:18'),
(3, 10, 'Rocket', 'Other', 'male', 3, 'Injured', 'Help/Rescue', 'Found injured, needs care', '[\"assets/pets/pet_3_1.png\",\"assets/pets/pet_3_2.png\"]', '6.4605127', '100.4993932', '2025-12-06 01:35:39'),
(4, 10, 'Daisy', 'Cat', 'female', 4, 'Healthy', 'Adoption', 'Playful and cuddly', '[\"assets/pets/pet_4_1.png\",\"assets/pets/pet_4_2.png\"]', '6.4605127', '100.4993932', '2025-12-06 01:37:32'),
(5, 10, 'Luna', 'Rabbit', 'female', 6, 'Need Medical Check', 'Help/Rescue', 'Rescued from street', '[\"assets/pets/pet_5_1.png\"]', '6.4593455', '100.5007849', '2025-12-06 01:38:53'),
(6, 10, 'Simba', 'Dog', 'male', 4, 'Healthy', 'Adoption', 'Playful and affectionate', '[\"assets/pets/pet_6_1.png\"]', '6.4605127', '100.4993932', '2025-12-06 01:40:20'),
(7, 10, 'Coco', 'Dog', 'female', 5, 'Healthy', 'Adoption', 'Friendly and playful', '[\"assets/pets/pet_7_1.png\"]', '6.4605127', '100.4993932', '2025-12-06 01:41:54'),
(8, 10, 'Bella', 'Rabbit', 'female', 3, 'Recovering', 'Help/Rescue', 'Need a safe home', '[\"assets/pets/pet_8_1.png\",\"assets/pets/pet_8_2.png\"]', '6.4595282', '100.4993932', '2025-12-06 01:50:37'),
(9, 10, 'Totty', 'Other', 'male', 2.5, 'Healthy', 'Adoption', 'Cute but really a fast runner', '[\"assets/pets/pet_9_1.png\"]', '6.4593403', '100.5007934', '2025-12-06 11:31:55');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL COMMENT 'Unique ID',
  `name` varchar(100) NOT NULL COMMENT 'User''s full name ',
  `email` varchar(100) NOT NULL COMMENT 'User''s login email',
  `password` varchar(255) NOT NULL COMMENT 'Hashed password',
  `phone` varchar(20) NOT NULL,
  `image_path` text DEFAULT NULL,
  `reg_date` datetime(6) NOT NULL DEFAULT current_timestamp(6) COMMENT 'Timestamp'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `name`, `email`, `password`, `phone`, `image_path`, `reg_date`) VALUES
(1, 'faizlyana', 'faizlyana@gmail.com', '64311ac2d669ab9c8189bb66b354fa4c2cd30cb6', '123456789', NULL, '2025-11-21 17:08:29.998035'),
(10, 'fatimah', 'fatimah@gmail.com', '55af9969919e0f55f3d6ef3daaf47e6aba558859', '123456789', NULL, '2025-11-26 01:04:43.004356'),
(11, 'ali', 'ali@gmail.com', '66f4a5fdce45bed1b1b99474956e530c4671c3a7', '123456789', NULL, '2025-11-26 01:35:40.931660'),
(12, 'ahmad', 'ahmad@gmail.com', '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8', '0173049200', 'assets/profiles/12.png', '2026-01-09 10:17:46.250411'),
(13, 'faizlyana', 'faezaliyana@gmail.com', '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8', '0129387466', NULL, '2026-01-09 15:52:07.862960');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  ADD PRIMARY KEY (`adoption_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `pet_id` (`pet_id`);

--
-- Indexes for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  ADD PRIMARY KEY (`donation_id`);

--
-- Indexes for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD PRIMARY KEY (`pet_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  MODIFY `adoption_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  MODIFY `donation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  MODIFY `pet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique ID', AUTO_INCREMENT=14;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD CONSTRAINT `tbl_pets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`user_id`);
--
-- Database: `musicbvk_pawpal_db_nad`
--
CREATE DATABASE IF NOT EXISTS `musicbvk_pawpal_db_nad` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `musicbvk_pawpal_db_nad`;

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
  `donation_date` datetime DEFAULT current_timestamp(),
  `payment_status` varchar(50) NOT NULL,
  `receipt_id` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_donations`
--

INSERT INTO `tbl_donations` (`donation_id`, `user_id`, `pet_id`, `donation_type`, `amount`, `description`, `donation_date`, `payment_status`, `receipt_id`) VALUES
(1, 6, 23, 'Food', 0.00, 'I am going to donate a royal canin & purina.', '2026-01-09 15:23:11', '', ''),
(2, 6, 21, 'Money', 100.00, '', '2026-01-09 15:23:11', '', ''),
(3, 6, 19, 'Food', 0.00, 'I am donating 5 packets of whiskas', '2026-01-09 15:23:11', '', ''),
(4, 6, 21, 'Money', 230.00, '', '2026-01-09 15:23:11', '', ''),
(5, 6, 15, 'Food', 0.00, 'Donate a rabbit food', '2026-01-09 15:23:11', '', ''),
(6, 6, 11, 'Food', 0.00, 'Donate a whiskas', '2026-01-09 15:23:11', '', ''),
(7, 6, 21, 'Food', 0.00, 'I want to give cat food', '2026-01-09 15:23:11', '', ''),
(8, 5, 19, 'Food', 0.00, 'I am going to give a food to buntut', '2026-01-09 15:23:11', '', ''),
(9, 5, 21, 'Money', 10.00, '', '2026-01-09 15:23:11', '', ''),
(10, 5, 21, 'Money', 5.00, '', '2026-01-09 15:23:11', '', ''),
(11, 5, 21, 'Money', 4.00, '', '2026-01-09 15:23:11', '', ''),
(12, 5, 21, 'Money', 1.00, '', '2026-01-09 15:23:11', '', ''),
(13, 5, 20, 'Money', 1.00, '', '2026-01-09 15:23:11', '', ''),
(14, 5, 19, 'Money', 1.00, '', '2026-01-09 15:23:11', '', ''),
(15, 5, 20, 'Money', 1.00, '', '2026-01-09 15:23:11', '', ''),
(16, 5, 21, 'Money', 1.00, '', '2026-01-09 15:23:11', '', ''),
(17, 5, 21, 'Money', 2.00, '', '2026-01-09 15:23:11', '', ''),
(18, 7, 19, 'Medical', 0.00, 'send medicine', '2026-01-09 15:23:11', '', ''),
(19, 7, 21, 'Money', 1.00, '', '2026-01-09 15:23:11', '', ''),
(20, 7, 21, 'Food', 0.00, 'I want to donate a food.', '2026-01-09 15:23:11', '', ''),
(21, 7, 20, 'Money', 1.00, '', '2026-01-09 15:23:11', '', ''),
(22, 7, 21, 'Money', 2.00, '', '2026-01-09 15:23:11', '', ''),
(23, 7, 19, 'Money', 1.00, '', '2026-01-09 15:23:11', '', ''),
(24, 7, 16, 'Money', 3.00, '', '2026-01-09 15:23:11', '', ''),
(25, 7, 11, 'Money', 4.00, '', '2026-01-09 15:23:11', '', ''),
(26, 7, 19, 'Money', 3.00, '', '2026-01-09 15:23:11', '', ''),
(27, 7, 6, 'Money', 3.00, '', '2026-01-09 15:23:11', '', ''),
(28, 7, 21, 'Money', 5.00, '', '2026-01-09 15:23:11', '', ''),
(29, 7, 16, 'Money', 2.00, '', '2026-01-09 15:23:11', '', ''),
(30, 7, 11, 'Money', 3.00, '', '2026-01-09 15:23:11', '', ''),
(31, 7, 20, 'Money', 1.00, '', '2026-01-09 15:23:11', '', ''),
(32, 5, 19, 'Money', 1.00, '', '2026-01-09 15:23:11', '', ''),
(33, 5, 19, 'Money', 1.00, 'Donation for buntut', '2026-01-09 15:24:12', 'Success', 'e70ed5039c0285b7'),
(34, 5, 19, 'Money', 1.00, 'Donation for buntut', '2026-01-09 15:24:21', 'Success', 'e70ed5039c0285b7'),
(35, 1, 16, 'Money', 1.50, '', '2026-01-09 15:31:30', '', ''),
(36, 1, 16, 'Money', 1.50, 'Donation for Catty', '2026-01-09 15:32:28', 'Success', '755e8aa19870a836'),
(37, 1, 15, 'Money', 2.00, '', '2026-01-09 15:34:25', '', ''),
(38, 1, 15, 'Money', 2.00, 'Donation for WhityBit', '2026-01-09 15:34:34', 'Success', '0c38d6f0bcd64096'),
(39, 1, 11, 'Money', 2.50, '', '2026-01-09 15:40:16', 'Success', 'a996be59d52eeb89'),
(40, 1, 3, 'Money', 2.00, '', '2026-01-09 16:06:13', 'Success', '3cb9375050a28f75'),
(41, 1, 6, 'Money', 2.00, '', '2026-01-09 16:09:32', 'Success', 'f31c006f688ac1e3'),
(42, 1, 7, 'Food', 0.00, 'I want to give food to this diggy', '2026-01-09 16:14:44', '', ''),
(43, 1, 11, 'Money', 4.50, '', '2026-01-09 16:14:58', 'Success', 'f19d4be6a9110552'),
(44, 1, 3, 'Money', 3.00, '', '2026-01-09 16:24:45', 'Success', '66cf7ead17fc22e6'),
(45, 1, 11, 'Money', 7.00, '', '2026-01-09 16:30:09', 'Success', 'e28a811e63a15e5c'),
(46, 1, 11, 'Money', 4.00, '', '2026-01-09 16:30:54', 'Success', '9ebc0b240278b439'),
(47, 1, 15, 'Money', 2.00, '', '2026-01-09 17:37:52', 'Success', '280cdf59073143aa'),
(48, 5, 21, 'Money', 3.00, '', '2026-01-09 17:46:31', 'Success', '995909bd6ab40d06');

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
(1, 'nabila dz', 'nabila@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '014-6785467', '2025-11-23 12:35:00.809582', 'profile_1.jpg'),
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
  MODIFY `donation_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

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
--
-- Database: `musicbvk_pawpal_db_nadh`
--
CREATE DATABASE IF NOT EXISTS `musicbvk_pawpal_db_nadh` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `musicbvk_pawpal_db_nadh`;

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
(1, 7, 22, 'I am on semester break'),
(2, 15, 25, 'I love rabbit that is why i want to adopt one.');

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
  `donation_date` datetime DEFAULT current_timestamp(),
  `payment_status` varchar(50) NOT NULL,
  `receipt_id` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_donations`
--

INSERT INTO `tbl_donations` (`donation_id`, `user_id`, `pet_id`, `donation_type`, `amount`, `description`, `donation_date`, `payment_status`, `receipt_id`) VALUES
(1, 6, 23, 'Food', 0.00, 'I am going to donate a royal canin & purina.', '2026-01-09 15:23:11', '', ''),
(2, 6, 21, 'Money', 100.00, '', '2026-01-09 15:23:11', '', ''),
(3, 6, 19, 'Food', 0.00, 'I am donating 5 packets of whiskas', '2026-01-09 15:23:11', '', ''),
(4, 6, 21, 'Money', 230.00, '', '2026-01-09 15:23:11', '', ''),
(5, 6, 15, 'Food', 0.00, 'Donate a rabbit food', '2026-01-09 15:23:11', '', ''),
(6, 6, 11, 'Food', 0.00, 'Donate a whiskas', '2026-01-09 15:23:11', '', ''),
(7, 6, 21, 'Food', 0.00, 'I want to give cat food', '2026-01-09 15:23:11', '', ''),
(8, 5, 19, 'Food', 0.00, 'I am going to give a food to buntut', '2026-01-09 15:23:11', '', ''),
(9, 5, 21, 'Money', 10.00, '', '2026-01-09 15:23:11', '', ''),
(10, 5, 21, 'Money', 5.00, '', '2026-01-09 15:23:11', '', ''),
(16, 5, 21, 'Money', 1.00, '', '2026-01-09 15:23:11', '', ''),
(17, 5, 21, 'Money', 2.00, '', '2026-01-09 15:23:11', '', ''),
(18, 7, 19, 'Medical', 0.00, 'send medicine', '2026-01-09 15:23:11', '', ''),
(19, 7, 21, 'Money', 1.00, '', '2026-01-09 15:23:11', '', ''),
(20, 7, 21, 'Food', 0.00, 'I want to donate a food.', '2026-01-09 15:23:11', '', ''),
(21, 7, 20, 'Money', 1.00, '', '2026-01-09 15:23:11', '', ''),
(22, 7, 21, 'Money', 2.00, '', '2026-01-09 15:23:11', '', ''),
(32, 5, 19, 'Money', 1.00, '', '2026-01-09 15:23:11', '', ''),
(33, 5, 19, 'Money', 1.00, 'Donation for buntut', '2026-01-09 15:24:12', 'Success', 'e70ed5039c0285b7'),
(34, 5, 19, 'Money', 1.00, 'Donation for buntut', '2026-01-09 15:24:21', 'Success', 'e70ed5039c0285b7'),
(35, 1, 16, 'Money', 1.50, '', '2026-01-09 15:31:30', '', ''),
(36, 1, 16, 'Money', 1.50, 'Donation for Catty', '2026-01-09 15:32:28', 'Success', '755e8aa19870a836'),
(37, 1, 15, 'Money', 2.00, '', '2026-01-09 15:34:25', '', ''),
(38, 1, 15, 'Money', 2.00, 'Donation for WhityBit', '2026-01-09 15:34:34', 'Success', '0c38d6f0bcd64096'),
(39, 1, 11, 'Money', 2.50, '', '2026-01-09 15:40:16', 'Success', 'a996be59d52eeb89'),
(42, 1, 7, 'Food', 0.00, 'I want to give food to this diggy', '2026-01-09 16:14:44', '', ''),
(43, 1, 11, 'Money', 4.50, '', '2026-01-09 16:14:58', 'Success', 'f19d4be6a9110552'),
(50, 14, 26, 'Money', 5.00, '', '2026-01-09 23:28:48', 'Success', 'd1ee7cff618bfa52'),
(51, 15, 26, 'Food', 0.00, 'Pikachu want a lot of foodD', '2026-01-10 01:06:55', '', ''),
(52, 15, 26, 'Medical', 0.00, 'Need medical tools for pikachu', '2026-01-10 01:09:55', '', ''),
(54, 15, 26, 'Money', 3.00, '', '2026-01-10 01:21:41', 'Success', 'cc683e2d027ef115');

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
(23, 5, 'greyish', 'Male', 5, 'Recovering', 'Cat', 'Help/Rescue', 'Needing help for greyish because he\'s still in recovery', '[\"assets/pets/pet_23_1.png\"]', '5.4140967', '100.3285267', '2026-01-03 14:33:40'),
(24, 7, 'Blackky', 'Female', 11, 'Sick', 'Cat', 'Donation Request', 'Looking for donation for blackky', '[\"assets/pets/pet_24_1.png\"]', '5.40846', '100.2773317', '2026-01-09 21:57:51'),
(25, 1, 'Rockuish', 'Female', 8, 'Healthy', 'Rabbit', 'Adoption', 'Adoption for rockuish', '[\"assets/pets/pet_25_1.png\"]', '5.40846', '100.2773317', '2026-01-09 22:00:08'),
(26, 1, 'Mochi', 'Female', 7, 'Recovering', 'Rabbit', 'Donation Request', 'I am looking for donation to my mochi..huaa help me', '[\"assets/pets/pet_26_1.png\"]', '5.40846', '100.2773317', '2026-01-09 22:02:38');

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
(1, 'nabila dz', 'nabila@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '014-6785467', '2025-11-23 12:35:00.809582', 'profile_1.jpg'),
(2, 'syafieqah', 'syaf@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '01904567234', '2025-11-23 12:37:39.293589', NULL),
(3, 'nadhirah', 'nadhirah@gamail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '019-4523678', '2025-11-23 12:52:08.527005', NULL),
(4, 'adam', 'adam@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '019-5673456', '2025-11-23 12:54:59.758405', NULL),
(5, 'nurul syafieqah', 'nurul@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '019-4562378', '2025-11-23 13:00:56.642453', 'profile_5.jpg'),
(6, 'mayyo', 'may@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '019-6785423', '2025-11-23 13:12:37.681936', 'profile_6.jpg'),
(7, 'izzah izzati', 'izzah@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '098-12345679', '2025-12-05 16:11:49.348270', 'profile_7.jpg'),
(8, 'labubu', 'bubu@gmail.com', '20eabe5d64b0e216796e834f52d61fd0b70332fc', '012-6745367', '2026-01-02 02:09:11.241001', NULL),
(9, 'ina comei', 'lina@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '012-7653421', '2026-01-09 22:25:48.751306', 'profile_9.jpg'),
(10, 'jennie', 'jennie@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '017-7845634', '2026-01-09 22:26:31.658555', NULL),
(11, 'syakir', 'syakir@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '013-9876539', '2026-01-09 22:27:36.975273', NULL),
(12, 'abu', 'abu@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '015-9872345', '2026-01-09 22:28:17.565751', NULL),
(13, 'baby', 'baby@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '019-5674537', '2026-01-09 22:42:14.775479', NULL),
(14, 'Mocimoci', 'moci@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '0174642024', '2026-01-09 23:26:40.215139', NULL),
(15, 'pikachu coco', 'pikachu@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '017-4537861', '2026-01-10 00:27:37.561771', 'profile_15.jpg');

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
  MODIFY `adoption_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  MODIFY `donation_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  MODIFY `pet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- Database: `musicbvk_pawpal_maithilly`
--
CREATE DATABASE IF NOT EXISTS `musicbvk_pawpal_maithilly` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `musicbvk_pawpal_maithilly`;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_adoptions`
--

CREATE TABLE `tbl_adoptions` (
  `adoption_id` int(11) NOT NULL,
  `pet_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `house_type` enum('Apartment','Condo','Landed House') DEFAULT NULL,
  `owned` enum('Yes','No') NOT NULL,
  `reason` text DEFAULT NULL,
  `status` enum('Pending','Approve','Reject') NOT NULL DEFAULT 'Pending',
  `requested_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tbl_adoptions`
--

INSERT INTO `tbl_adoptions` (`adoption_id`, `pet_id`, `user_id`, `house_type`, `owned`, `reason`, `status`, `requested_date`) VALUES
(1, 5, 3, 'Landed House', 'Yes', 'I very like those kittens!', 'Approve', '2026-01-07 18:53:59'),
(5, 21, 3, 'Condo', 'No', 'I like this cat', 'Reject', '2026-01-08 15:51:17'),
(1, 5, 3, 'Landed House', 'Yes', 'I very like those kittens!', 'Approve', '2026-01-07 18:53:59'),
(5, 21, 3, 'Condo', 'No', 'I like this cat', 'Reject', '2026-01-08 15:51:17'),
(1, 5, 3, 'Landed House', 'Yes', 'I very like those kittens!', 'Approve', '2026-01-07 18:53:59'),
(5, 21, 3, 'Condo', 'No', 'I like this cat', 'Reject', '2026-01-08 15:51:17'),
(1, 5, 3, 'Landed House', 'Yes', 'I very like those kittens!', 'Approve', '2026-01-07 18:53:59'),
(5, 21, 3, 'Condo', 'No', 'I like this cat', 'Reject', '2026-01-08 15:51:17'),
(1, 5, 3, 'Landed House', 'Yes', 'I very like those kittens!', 'Approve', '2026-01-07 18:53:59'),
(5, 21, 3, 'Condo', 'No', 'I like this cat', 'Reject', '2026-01-08 15:51:17');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_donations`
--

CREATE TABLE `tbl_donations` (
  `donation_id` int(11) NOT NULL,
  `pet_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `donation_type` enum('Food','Medical','Money') DEFAULT NULL,
  `amount` double(10,2) DEFAULT 0.00,
  `description` text DEFAULT NULL,
  `donation_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tbl_donations`
--

INSERT INTO `tbl_donations` (`donation_id`, `pet_id`, `user_id`, `donation_type`, `amount`, `description`, `donation_date`) VALUES
(1, 22, 3, 'Money', 5.00, 'Cash Donation', '2026-01-04 20:54:36'),
(2, 22, 3, 'Money', 5.00, 'Cash Donation', '2026-01-04 21:00:47'),
(3, 22, 3, 'Money', 10.50, 'Cash Donation', '2026-01-05 08:44:31'),
(4, 22, 3, 'Medical', 0.00, '2 pack of pain bills', '2026-01-06 13:15:27'),
(5, 22, 3, 'Money', 10.00, 'Cash Donation', '2026-01-07 19:00:55'),
(6, 22, 3, 'Money', 10.00, 'Cash Donation', '2026-01-08 14:58:21'),
(7, 22, 3, 'Money', 10.00, 'Cash Donation', '2026-01-08 15:26:35'),
(8, 22, 3, 'Money', 10.00, 'Cash Donation', '2026-01-08 15:53:55'),
(9, 24, 1, 'Money', 50.00, 'Cash Donation', '2026-01-08 19:07:36'),
(10, 24, 2, 'Money', 20.00, 'Cash Donation', '2026-01-08 19:08:22'),
(1, 22, 3, 'Money', 5.00, 'Cash Donation', '2026-01-04 20:54:36'),
(2, 22, 3, 'Money', 5.00, 'Cash Donation', '2026-01-04 21:00:47'),
(3, 22, 3, 'Money', 10.50, 'Cash Donation', '2026-01-05 08:44:31'),
(4, 22, 3, 'Medical', 0.00, '2 pack of pain bills', '2026-01-06 13:15:27'),
(5, 22, 3, 'Money', 10.00, 'Cash Donation', '2026-01-07 19:00:55'),
(6, 22, 3, 'Money', 10.00, 'Cash Donation', '2026-01-08 14:58:21'),
(7, 22, 3, 'Money', 10.00, 'Cash Donation', '2026-01-08 15:26:35'),
(8, 22, 3, 'Money', 10.00, 'Cash Donation', '2026-01-08 15:53:55'),
(9, 24, 1, 'Money', 50.00, 'Cash Donation', '2026-01-08 19:07:36'),
(10, 24, 2, 'Money', 20.00, 'Cash Donation', '2026-01-08 19:08:22'),
(1, 22, 3, 'Money', 5.00, 'Cash Donation', '2026-01-04 20:54:36'),
(2, 22, 3, 'Money', 5.00, 'Cash Donation', '2026-01-04 21:00:47'),
(3, 22, 3, 'Money', 10.50, 'Cash Donation', '2026-01-05 08:44:31'),
(4, 22, 3, 'Medical', 0.00, '2 pack of pain bills', '2026-01-06 13:15:27'),
(5, 22, 3, 'Money', 10.00, 'Cash Donation', '2026-01-07 19:00:55'),
(6, 22, 3, 'Money', 10.00, 'Cash Donation', '2026-01-08 14:58:21'),
(7, 22, 3, 'Money', 10.00, 'Cash Donation', '2026-01-08 15:26:35'),
(8, 22, 3, 'Money', 10.00, 'Cash Donation', '2026-01-08 15:53:55'),
(9, 24, 1, 'Money', 50.00, 'Cash Donation', '2026-01-08 19:07:36'),
(10, 24, 2, 'Money', 20.00, 'Cash Donation', '2026-01-08 19:08:22'),
(1, 22, 3, 'Money', 5.00, 'Cash Donation', '2026-01-04 20:54:36'),
(2, 22, 3, 'Money', 5.00, 'Cash Donation', '2026-01-04 21:00:47'),
(3, 22, 3, 'Money', 10.50, 'Cash Donation', '2026-01-05 08:44:31'),
(4, 22, 3, 'Medical', 0.00, '2 pack of pain bills', '2026-01-06 13:15:27'),
(5, 22, 3, 'Money', 10.00, 'Cash Donation', '2026-01-07 19:00:55'),
(6, 22, 3, 'Money', 10.00, 'Cash Donation', '2026-01-08 14:58:21'),
(7, 22, 3, 'Money', 10.00, 'Cash Donation', '2026-01-08 15:26:35'),
(8, 22, 3, 'Money', 10.00, 'Cash Donation', '2026-01-08 15:53:55'),
(9, 24, 1, 'Money', 50.00, 'Cash Donation', '2026-01-08 19:07:36'),
(10, 24, 2, 'Money', 20.00, 'Cash Donation', '2026-01-08 19:08:22');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pets`
--

CREATE TABLE `tbl_pets` (
  `pet_id` int(11) NOT NULL COMMENT 'Unique ID',
  `user_id` int(11) NOT NULL COMMENT 'Foreign key to tbl_users',
  `pet_name` varchar(100) NOT NULL,
  `pet_type` varchar(50) NOT NULL,
  `gender` varchar(50) NOT NULL COMMENT 'Male/Female/Both',
  `age` varchar(50) NOT NULL,
  `category` varchar(50) NOT NULL COMMENT 'Adoption/Donation/Help',
  `health` varchar(50) NOT NULL COMMENT 'Healthy/Critical/Unknown',
  `description` text DEFAULT NULL,
  `image_paths` text DEFAULT NULL COMMENT 'JSON or comma-separated list of up to 3 paths',
  `lat` varchar(50) DEFAULT NULL COMMENT 'Latitude',
  `lng` varchar(50) DEFAULT NULL COMMENT 'Longitude',
  `created_at` datetime DEFAULT current_timestamp(),
  `is_adopted` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_pets`
--

INSERT INTO `tbl_pets` (`pet_id`, `user_id`, `pet_name`, `pet_type`, `gender`, `age`, `category`, `health`, `description`, `image_paths`, `lat`, `lng`, `created_at`, `is_adopted`) VALUES
(4, 1, 'Little White', 'Rabbit', 'Female', '1 years old', 'Help/Rescue', 'Healthy', 'Help me, my rabbit is run away from my house', '[\"image1: ../uploads/pet/pet_4_1.png\"]', '6.4606617', '100.5019317', '2025-12-06 09:00:25', 0),
(5, 1, 'Kitties', 'Cat', 'Both', '2 months', 'Adoption', 'Healthy', 'There got 4 cute kitties come adopt them.', '[\"image1: ../uploads/pet/pet_5_1.png\"]', '6.4606617', '100.5019317', '2026-01-02 11:30:46', 1),
(6, 2, 'Snoky', 'Dog', 'Male', '3 months', 'Adoption', 'Healthy', 'He is hiding under the train rail.', '[\"image1: ../uploads/pet/pet_6_1.png\"]', '6.4606617', '100.5019317', '2026-01-02 11:32:27', 0),
(21, 1, 'Mao Mao', 'Cat', 'Female', '4 months', 'Adoption', 'Healthy', 'Need someone to adopt it.', '[\"image1: ../uploads/pet/pet_21_1.png\"]', '6.4606617', '100.5019317', '2026-01-08 14:49:12', 0),
(22, 1, 'Doggie', 'Dog', 'Male', '2 years old', 'Donation Request', 'Critical', 'He is injured, please help me!', '[\"image1: ../uploads/pet/pet_22_1.png\"]', '6.4606617', '100.5019317', '2026-01-08 16:09:25', 0),
(24, 3, 'Oran', 'Cat', 'Male', '1 months', 'Donation Request', 'Critical', 'Help me, I do not have enough money to pay the bill.', '[\"image1: ../uploads/pet/pet_24_1.png\"]', '6.4606617', '100.5019317', '2026-01-08 19:04:08', 0),
(4, 1, 'Little White', 'Rabbit', 'Female', '1 years old', 'Help/Rescue', 'Healthy', 'Help me, my rabbit is run away from my house', '[\"image1: ../uploads/pet/pet_4_1.png\"]', '6.4606617', '100.5019317', '2025-12-06 09:00:25', 0),
(5, 1, 'Kitties', 'Cat', 'Both', '2 months', 'Adoption', 'Healthy', 'There got 4 cute kitties come adopt them.', '[\"image1: ../uploads/pet/pet_5_1.png\"]', '6.4606617', '100.5019317', '2026-01-02 11:30:46', 1),
(6, 2, 'Snoky', 'Dog', 'Male', '3 months', 'Adoption', 'Healthy', 'He is hiding under the train rail.', '[\"image1: ../uploads/pet/pet_6_1.png\"]', '6.4606617', '100.5019317', '2026-01-02 11:32:27', 0),
(21, 1, 'Mao Mao', 'Cat', 'Female', '4 months', 'Adoption', 'Healthy', 'Need someone to adopt it.', '[\"image1: ../uploads/pet/pet_21_1.png\"]', '6.4606617', '100.5019317', '2026-01-08 14:49:12', 0),
(22, 1, 'Doggie', 'Dog', 'Male', '2 years old', 'Donation Request', 'Critical', 'He is injured, please help me!', '[\"image1: ../uploads/pet/pet_22_1.png\"]', '6.4606617', '100.5019317', '2026-01-08 16:09:25', 0),
(24, 3, 'Oran', 'Cat', 'Male', '1 months', 'Donation Request', 'Critical', 'Help me, I do not have enough money to pay the bill.', '[\"image1: ../uploads/pet/pet_24_1.png\"]', '6.4606617', '100.5019317', '2026-01-08 19:04:08', 0),
(4, 1, 'Little White', 'Rabbit', 'Female', '1 years old', 'Help/Rescue', 'Healthy', 'Help me, my rabbit is run away from my house', '[\"image1: ../uploads/pet/pet_4_1.png\"]', '6.4606617', '100.5019317', '2025-12-06 09:00:25', 0),
(5, 1, 'Kitties', 'Cat', 'Both', '2 months', 'Adoption', 'Healthy', 'There got 4 cute kitties come adopt them.', '[\"image1: ../uploads/pet/pet_5_1.png\"]', '6.4606617', '100.5019317', '2026-01-02 11:30:46', 1),
(6, 2, 'Snoky', 'Dog', 'Male', '3 months', 'Adoption', 'Healthy', 'He is hiding under the train rail.', '[\"image1: ../uploads/pet/pet_6_1.png\"]', '6.4606617', '100.5019317', '2026-01-02 11:32:27', 0),
(21, 1, 'Mao Mao', 'Cat', 'Female', '4 months', 'Adoption', 'Healthy', 'Need someone to adopt it.', '[\"image1: ../uploads/pet/pet_21_1.png\"]', '6.4606617', '100.5019317', '2026-01-08 14:49:12', 0),
(22, 1, 'Doggie', 'Dog', 'Male', '2 years old', 'Donation Request', 'Critical', 'He is injured, please help me!', '[\"image1: ../uploads/pet/pet_22_1.png\"]', '6.4606617', '100.5019317', '2026-01-08 16:09:25', 0),
(24, 3, 'Oran', 'Cat', 'Male', '1 months', 'Donation Request', 'Critical', 'Help me, I do not have enough money to pay the bill.', '[\"image1: ../uploads/pet/pet_24_1.png\"]', '6.4606617', '100.5019317', '2026-01-08 19:04:08', 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL,
  `avatar` text DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `wallet` double(10,2) NOT NULL DEFAULT 0.00,
  `reg_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `avatar`, `name`, `email`, `password`, `phone`, `wallet`, `reg_date`) VALUES
(1, '../uploads/profile/user_1.png', 'Maithilly', 'maithilly@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '0123839789', 200.50, '2025-11-24 12:48:24'),
(2, NULL, 'Sila', 'sila@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '0178299789', 30.00, '2025-11-24 12:54:17'),
(3, '../uploads/profile/user_3.png', 'Nihan', 'nihan@gmail.com', '2891baceeef1652ee698294da0e71ba78a2a4064', '0136909892', 1123.50, '2026-01-02 14:19:25'),
(0, '../uploads/profile/user_1.png', 'Maithilly', 'maithilly@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '0123839789', 200.50, '2025-11-24 12:48:24'),
(2, NULL, 'Sila', 'sila@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '0178299789', 30.00, '2025-11-24 12:54:17'),
(3, '../uploads/profile/user_3.png', 'Nihan', 'nihan@gmail.com', '2891baceeef1652ee698294da0e71ba78a2a4064', '0136909892', 1123.50, '2026-01-02 14:19:25');
--
-- Database: `musicbvk_pugal_pawpalpet_db`
--
CREATE DATABASE IF NOT EXISTS `musicbvk_pugal_pawpalpet_db` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `musicbvk_pugal_pawpalpet_db`;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_adoptions`
--

CREATE TABLE `tbl_adoptions` (
  `request_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `requester_id` int(11) NOT NULL,
  `message` text DEFAULT NULL,
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_adoptions`
--

INSERT INTO `tbl_adoptions` (`request_id`, `pet_id`, `requester_id`, `message`, `status`, `created_at`) VALUES
(4, 3, 2, 'i like cute little rabbits', 'Approved', '2026-01-06 11:33:51'),
(5, 1, 3, 'This puppy is so cuteee', 'Approved', '2026-01-07 17:14:44'),
(6, 2, 2, 'I will take care of this dog with care and love', 'Rejected', '2026-01-07 17:29:11'),
(7, 2, 2, 'I really wanna adopt this cute dog', 'Approved', '2026-01-07 17:34:05'),
(8, 7, 1, 'I wanna adopt this cat badly', 'Rejected', '2026-01-07 17:47:11'),
(9, 7, 2, 'I want this cute little kitten', 'Approved', '2026-01-07 17:48:31'),
(10, 8, 1, 'I will take good care of this cute rabbit', 'Pending', '2026-01-07 18:09:54');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_donations`
--

CREATE TABLE `tbl_donations` (
  `donation_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `donor_id` int(11) NOT NULL,
  `donation_type` enum('Food','Medical','Money') NOT NULL,
  `detail` varchar(255) NOT NULL,
  `status` varchar(20) DEFAULT '''Pending''',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pets`
--

CREATE TABLE `tbl_pets` (
  `pet_id` int(11) NOT NULL COMMENT 'Unique ID',
  `user_id` int(11) NOT NULL COMMENT 'Foreign key to tbl_users',
  `pet_name` varchar(100) NOT NULL,
  `pet_type` varchar(50) NOT NULL,
  `age` int(11) DEFAULT NULL,
  `health` varchar(100) DEFAULT NULL,
  `gender` enum('Male','Female') DEFAULT NULL,
  `category` varchar(50) NOT NULL COMMENT 'Adoption/Donation/Help',
  `description` text NOT NULL,
  `image_paths` text NOT NULL COMMENT 'JSON or comma-separated list of up to 3 paths',
  `lat` varchar(50) NOT NULL COMMENT 'Latitude',
  `lng` varchar(50) NOT NULL COMMENT 'Longitude',
  `created_at` datetime NOT NULL,
  `adoption_status` enum('available','adopted') DEFAULT 'available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_pets`
--

INSERT INTO `tbl_pets` (`pet_id`, `user_id`, `pet_name`, `pet_type`, `age`, `health`, `gender`, `category`, `description`, `image_paths`, `lat`, `lng`, `created_at`, `adoption_status`) VALUES
(1, 1, 'Lilo', 'Dog', 3, NULL, NULL, 'Adoption', 'A dog for adoption', '[\"uploads/pet_69577f52773404.24624535.jpg\"]', '6.437935', '100.530968', '2026-01-02 16:18:26', 'adopted'),
(2, 1, 'Leo', 'Dog', 7, NULL, NULL, 'Adoption', 'a cute dog for adoption', '[\"uploads/pet_695a9bbf1b43c1.70141513.jpg\"]', '6.437935', '100.530968', '2026-01-05 00:56:31', 'adopted'),
(3, 1, 'Mimi', 'Rabbit', 8, NULL, NULL, 'Adoption', 'cute little rabbit', '[\"uploads/pet_695ab30ba356b3.45387503.jpg\"]', '6.437935', '100.530968', '2026-01-05 02:35:55', 'adopted'),
(6, 1, 'Oyen', 'Cat', 5, NULL, NULL, 'Help/Rescue', 'a cat need your help', '[\"uploads/pet_695b2315ac7126.50172975.jpg\"]', '6.436', '100.4289', '2026-01-05 10:33:57', 'available'),
(7, 3, 'Oren', 'Cat', 2, NULL, NULL, 'Adoption', 'A cute little cat for adoption', '[\"uploads/pet_695e9afa2cd176.32204532.jpg\",\"uploads/pet_695e9afa324984.34493742.jpg\"]', '6.437935', '100.530968', '2026-01-08 01:42:18', 'adopted'),
(8, 2, 'Jimi', 'Rabbit', 4, NULL, NULL, 'Adoption', 'Small white rabbit for adoption', '[\"uploads/pet_695ea133bc8399.98614017.jpg\"]', '6.437935', '100.530968', '2026-01-08 02:08:52', 'available'),
(9, 1, 'Kiki', 'Other', 1, 'Good and healthy', 'Male', 'Adoption', 'A newborn hamster for adoption', '[\"uploads/pet_695ea8333d4402.53756328.jpg\"]', '6.437935', '100.530968', '2026-01-08 02:38:43', 'available'),
(11, 1, 'Johny', 'Dog', 7, 'Fit and healthy', 'Male', 'Adoption', 'A brilliant dog', '[\"uploads/pet_695eae84894d90.71405726.jpg\"]', '6.437935', '100.530968', '2026-01-08 03:05:40', 'available'),
(12, 1, 'Sisha', 'Rabbit', 5, 'Good', 'Female', 'Donation Request', 'Needed some money to take care of this rabbit', '[\"uploads/pet_69608b5e4b3c98.16100619.jpg\"]', '6.437935', '100.530968', '2026-01-09 13:00:14', 'available');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `reg_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `profile_image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `name`, `email`, `password`, `phone`, `reg_date`, `profile_image`) VALUES
(1, 'Pugalinny', 'pugal@gmail.com', '$2y$10$6VPm5ao53aoNM4mbVtpW8u6JL4JjteZgsYIIdKBnJJrCplSMgDN9G', '01134521191', '2025-12-04 18:54:30', 'uploads/profile_696131079eef99.62335154.jpg'),
(2, 'Amira', 'amira@gmail.com', '$2y$10$1BRAV0wvvsz5LPG27bdskuAAxynfPF6JBiqwMUnjbo./FrV7aaAjG', '01112300874', '2025-12-05 15:54:34', NULL),
(3, 'Nazifah', 'ifah@gmail.com', '$2y$10$4ARnlkvFCenBxslyyEX9VuO3nw8Cj8FIzqO.AcMxgybjQOV1mEHz2', '01123907756', '2025-12-06 06:48:02', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `pet_id` (`pet_id`),
  ADD KEY `requester_id` (`requester_id`);

--
-- Indexes for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  ADD PRIMARY KEY (`donation_id`),
  ADD KEY `fk_donation_pet` (`pet_id`),
  ADD KEY `fk_donation_user` (`donor_id`);

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
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  MODIFY `donation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  MODIFY `pet_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique ID', AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  ADD CONSTRAINT `tbl_adoptions_ibfk_1` FOREIGN KEY (`pet_id`) REFERENCES `tbl_pets` (`pet_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tbl_adoptions_ibfk_2` FOREIGN KEY (`requester_id`) REFERENCES `tbl_users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  ADD CONSTRAINT `fk_donation_pet` FOREIGN KEY (`pet_id`) REFERENCES `tbl_pets` (`pet_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_donation_user` FOREIGN KEY (`donor_id`) REFERENCES `tbl_users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
