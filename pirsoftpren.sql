-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 18 Mar 2025 pada 04.06
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pirsoftpren`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `pircategory`
--

CREATE TABLE `pircategory` (
  `id` int(11) NOT NULL,
  `label` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pircategory`
--

INSERT INTO `pircategory` (`id`, `label`) VALUES
(1, 'Prototype'),
(2, 'Newly-designed parts'),
(3, 'Design Change Parts'),
(4, 'Process Change Parts'),
(5, 'Parts On Hold'),
(6, 'Mass Prod'),
(7, 'Parts of additional supplier or parts of alternate supplier'),
(8, 'Others');

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_inspection`
--

CREATE TABLE `t_inspection` (
  `inspectionId` int(11) NOT NULL,
  `akunId` int(11) NOT NULL,
  `category` int(11) NOT NULL,
  `deliveryDate` date NOT NULL,
  `deliveryQty` int(11) NOT NULL,
  `inspectionData` longtext NOT NULL,
  `inspectionDate` date NOT NULL,
  `lotNumber` varchar(64) NOT NULL,
  `partId` int(11) NOT NULL,
  `sampleQty` int(11) NOT NULL,
  `inspectorJudgement` int(1) NOT NULL DEFAULT 0,
  `checkerJudgement` int(1) NOT NULL DEFAULT 0,
  `checkerJudgementDate` date DEFAULT NULL,
  `managerJudgement` int(1) NOT NULL DEFAULT 0,
  `managerJudgementDate` date DEFAULT NULL,
  `checkerNote` varchar(1024) DEFAULT NULL,
  `checkerID` int(11) DEFAULT NULL,
  `approvalId` int(11) DEFAULT NULL,
  `approvalNote` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_menus`
--

CREATE TABLE `t_menus` (
  `id` int(11) NOT NULL,
  `label` varchar(64) NOT NULL,
  `path` varchar(64) NOT NULL,
  `access` varchar(2048) NOT NULL,
  `view` varchar(1024) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_menus`
--

INSERT INTO `t_menus` (`id`, `label`, `path`, `access`, `view`) VALUES
(1, 'New Inspection', '/home/newinspection', '[1,26,27,28,36,37,38,39]', '[1,26,27,28,36,37,38,39]'),
(2, 'Inspection Check', '/home/inspectioncheck', '[1,26,27,36,37,38]', '[1,26,27,28,36,37,38]'),
(3, 'Finish Inspection', '/home/finishinspection', '[1,26,27,31,33,36,37,38,39]', '[1,26,27,28,31,33,36,37,38,39]'),
(4, 'NG Inspection', '/home/nginspection', '[1,26,31,36,37,38]', '[1,26,31,36,37,38]'),
(5, 'Part Registration', '/home/registrasipir', '[1,26,36,37,38]', '[1,26,27,28,36,37,38]');

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_method`
--

CREATE TABLE `t_method` (
  `id` int(11) NOT NULL,
  `methodName` varchar(64) NOT NULL,
  `active` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_part`
--

CREATE TABLE `t_part` (
  `partId` int(11) NOT NULL,
  `customerName` varchar(255) NOT NULL,
  `deliveryModel` varchar(255) NOT NULL,
  `dieCavity` varchar(255) NOT NULL,
  `inspectionItem` varchar(4000) NOT NULL,
  `partName` varchar(255) NOT NULL,
  `partNumber` varchar(255) NOT NULL,
  `active` int(11) NOT NULL DEFAULT 1,
  `samplingLevel` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_role`
--

CREATE TABLE `t_role` (
  `roleId` int(11) NOT NULL,
  `roleName` varchar(64) NOT NULL,
  `active` int(11) NOT NULL DEFAULT 1,
  `home` varchar(255) NOT NULL DEFAULT '/home'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_role`
--

INSERT INTO `t_role` (`roleId`, `roleName`, `active`, `home`) VALUES
(1, 'System', 1, '/home/inspectioncheck'),
(36, 'Administrator', 1, '/home/inspectioncheck'),
(37, 'Assistant Manager', 1, '/home/inspectioncheck'),
(38, 'Checker', 1, '/home/inspectioncheck'),
(39, 'Inspector', 1, '/home/newinspection');

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_samplerange`
--

CREATE TABLE `t_samplerange` (
  `id` int(11) NOT NULL,
  `Nmin` int(11) NOT NULL,
  `Nmax` int(11) NOT NULL,
  `class_A` int(11) NOT NULL,
  `class_B` int(11) NOT NULL,
  `class_C` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_samplerange`
--

INSERT INTO `t_samplerange` (`id`, `Nmin`, `Nmax`, `class_A`, `class_B`, `class_C`) VALUES
(1, 2, 8, 2, 2, 2),
(2, 9, 15, 2, 2, 2),
(3, 16, 25, 3, 2, 2),
(4, 26, 50, 3, 3, 2),
(5, 51, 90, 5, 3, 3),
(6, 91, 150, 5, 3, 3),
(7, 151, 280, 8, 5, 3),
(8, 281, 500, 8, 5, 3),
(9, 501, 1200, 13, 5, 5),
(10, 1201, 3200, 13, 8, 5),
(11, 3201, 10000, 20, 8, 5),
(12, 10001, 0, 20, 8, 5);

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_setting`
--

CREATE TABLE `t_setting` (
  `id` int(11) NOT NULL,
  `label` varchar(64) NOT NULL,
  `path` varchar(64) NOT NULL,
  `icon` varchar(128) NOT NULL,
  `access` varchar(2048) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_setting`
--

INSERT INTO `t_setting` (`id`, `label`, `path`, `icon`, `access`) VALUES
(1, 'Users Setting', '/home/userssetting', 'mdi-account-multiple', '[1,36]'),
(2, 'Menu Setting', '/home/menusetting', 'mdi-menu', '[1,36]'),
(4, 'Inspection Setup', '/home/inspectionsetup', 'mdi-cog-outline', '[1,36,37]');

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_tool`
--

CREATE TABLE `t_tool` (
  `toolId` int(11) NOT NULL,
  `toolName` varchar(255) NOT NULL,
  `method` int(11) NOT NULL,
  `active` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_type`
--

CREATE TABLE `t_type` (
  `id` int(11) NOT NULL,
  `typeName` varchar(255) NOT NULL,
  `description` varchar(1024) NOT NULL,
  `label` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_type`
--

INSERT INTO `t_type` (`id`, `typeName`, `description`, `label`) VALUES
(1, 'matchString', 'Nilai pemeriksaan berbentuk text. Hasil judgement akan ditentukan berdasarkan kesamaan text (case incensitive).', 'Match String'),
(2, 'Option(NG/OK)', 'Nilai pemeriksaan akan berupa pilihan NG/OK sesuai kondisi produk dan secara langsung mewakili judgement.', 'Option (OK/NG)'),
(3, 'matchNumber', 'Nilai pemeriksaan akan berupa angka, judgement akan didapatkan sesuai nilai aktual harus persis sama dengan nilai standar (=).', 'Match Number'),
(4, 'numberLargerThan', 'Nilai pemeriksaan akan berupa angka, judgement akan didapatkan sesuai nilai aktual harus lebih besar dari nilai standar (>).', 'Number Larger Than'),
(5, 'numberLessThan', 'Nilai pemeriksaan akan berupa angka, judgement akan didapatkan sesuai nilai aktual harus kurang dari nilai standar (<).', 'Number Less Than'),
(6, 'numberRange', 'Nilai pemeriksaan akan berupa angka, judgement akan didapatkan sesuai nilai aktual harus lebih besar atau sama dengan nilai minimal standar dan lebih kecil atau sama dengan nilai maximal standar.', 'Number Range'),
(7, 'customNumberRange', 'Nilai pemeriksaan akan berupa angka, judgement akan didapatkan sesuai nilai aktual harus lebih besar atau sama dengan nilai minimal standar dan lebih kecil atau sama dengan nilai maximal standar berdasarkan toleransi custom.', 'Custom Number Range'),
(8, 'customOption(NG/OK)', 'Nilai pemeriksaan akan berupa pilihan NG/OK sesuai kondisi produk dan secara langsung mewakili judgement dengan custom string sebagai standar.', 'Custom Option (NG/OK)');

-- --------------------------------------------------------

--
-- Struktur dari tabel `t_user`
--

CREATE TABLE `t_user` (
  `userId` int(11) NOT NULL,
  `userName` varchar(18) NOT NULL,
  `password` varchar(1024) NOT NULL,
  `role` int(11) NOT NULL,
  `addDate` timestamp NOT NULL DEFAULT current_timestamp(),
  `sureName` varchar(64) NOT NULL,
  `active` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `t_user`
--

INSERT INTO `t_user` (`userId`, `userName`, `password`, `role`, `addDate`, `sureName`, `active`) VALUES
(1, 'system', 'U2FsdGVkX19cqanpWRmMzFocphZd7q8jM5Px7K7Onxw=', 1, '2024-11-21 06:34:13', 'MIIT Programmer', 1);

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `pircategory`
--
ALTER TABLE `pircategory`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `t_inspection`
--
ALTER TABLE `t_inspection`
  ADD PRIMARY KEY (`inspectionId`);

--
-- Indeks untuk tabel `t_menus`
--
ALTER TABLE `t_menus`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `t_method`
--
ALTER TABLE `t_method`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `t_part`
--
ALTER TABLE `t_part`
  ADD PRIMARY KEY (`partId`);

--
-- Indeks untuk tabel `t_role`
--
ALTER TABLE `t_role`
  ADD PRIMARY KEY (`roleId`);

--
-- Indeks untuk tabel `t_samplerange`
--
ALTER TABLE `t_samplerange`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `t_setting`
--
ALTER TABLE `t_setting`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `t_tool`
--
ALTER TABLE `t_tool`
  ADD PRIMARY KEY (`toolId`);

--
-- Indeks untuk tabel `t_type`
--
ALTER TABLE `t_type`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `t_user`
--
ALTER TABLE `t_user`
  ADD PRIMARY KEY (`userId`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `pircategory`
--
ALTER TABLE `pircategory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `t_inspection`
--
ALTER TABLE `t_inspection`
  MODIFY `inspectionId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `t_menus`
--
ALTER TABLE `t_menus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `t_method`
--
ALTER TABLE `t_method`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `t_part`
--
ALTER TABLE `t_part`
  MODIFY `partId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `t_role`
--
ALTER TABLE `t_role`
  MODIFY `roleId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT untuk tabel `t_samplerange`
--
ALTER TABLE `t_samplerange`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `t_setting`
--
ALTER TABLE `t_setting`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `t_tool`
--
ALTER TABLE `t_tool`
  MODIFY `toolId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `t_type`
--
ALTER TABLE `t_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `t_user`
--
ALTER TABLE `t_user`
  MODIFY `userId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
