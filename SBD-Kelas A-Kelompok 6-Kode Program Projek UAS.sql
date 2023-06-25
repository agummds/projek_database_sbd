-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 25, 2023 at 02:34 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.0.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rumah_sakit`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ResetAntrian` ()   BEGIN
    DECLARE currentDate DATE;
    DECLARE lastid_antri INT;
    SET currentDate = CURDATE();
    
    -- Mengambil nomor antrian terakhir pada tanggal saat ini
    SELECT MAX(id_antri) INTO lastid_antri FROM antri_poli WHERE Tanggal = currentDate;
    
    -- Jika nomor antrian terakhir adalah NULL, set nomor antrian menjadi 1
    IF lastid_antri IS NULL THEN
        SET lastid_antri = 0;
    END IF;
    
    -- Reset nomor antrian menjadi 1 pada tanggal saat ini
    UPDATE antri_poli SET id_antri = 1 WHERE Tanggal = currentDate;
    
    -- Setelah reset, perbarui nomor antrian untuk tanggal-tanggal berikutnya
    UPDATE antri_poli SET id_antri = id_antri + 1 WHERE Tanggal > currentDate;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `antri_poli`
--

CREATE TABLE `antri_poli` (
  `idRev` char(3) NOT NULL,
  `Tanggal` date NOT NULL,
  `Jam` time DEFAULT NULL,
  `id_antri` int(6) NOT NULL,
  `NoAntri` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `antri_poli`
--

INSERT INTO `antri_poli` (`idRev`, `Tanggal`, `Jam`, `id_antri`, `NoAntri`) VALUES
('A01', '2023-06-01', '10:00:00', 1, 5),
('A02', '2023-06-01', '10:30:00', 2, 7),
('A03', '2023-06-01', '11:00:00', 3, 8),
('A04', '2023-06-26', '11:17:00', 11, 9);

-- --------------------------------------------------------

--
-- Table structure for table `biaya`
--

CREATE TABLE `biaya` (
  `idRev` char(3) NOT NULL,
  `idBiaya` char(2) NOT NULL,
  `Pelayanan` varchar(20) NOT NULL,
  `Biaya` char(12) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `biaya`
--

INSERT INTO `biaya` (`idRev`, `idBiaya`, `Pelayanan`, `Biaya`) VALUES
('A01', 'C1', 'Rawat Inap', 'Rp 3500000'),
('A03', 'C2', 'Rontgen', 'Rp 800000'),
('A02', 'D1', 'Kemoterapi', 'Rp 5000000');

-- --------------------------------------------------------

--
-- Table structure for table `dokter`
--

CREATE TABLE `dokter` (
  `idDok` char(3) NOT NULL,
  `idPoli` char(4) NOT NULL,
  `namaDok` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dokter`
--

INSERT INTO `dokter` (`idDok`, `idPoli`, `namaDok`) VALUES
('AK1', 'PPA1', 'Muhammad'),
('OR1', 'POP1', 'Fazya'),
('PD1', 'PPD1', 'Yumna');

-- --------------------------------------------------------

--
-- Table structure for table `pasien`
--

CREATE TABLE `pasien` (
  `idRev` char(3) NOT NULL,
  `NoRM` int(5) NOT NULL,
  `Nama` varchar(20) NOT NULL,
  `KTP` bigint(16) NOT NULL,
  `alamat` varchar(30) DEFAULT NULL,
  `berat` int(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pasien`
--

INSERT INTO `pasien` (`idRev`, `NoRM`, `Nama`, `KTP`, `alamat`, `berat`) VALUES
('A01', 1, 'Rifqi Khairon', 1371098756384900, 'INDARUNG', 60),
('A02', 2, 'Muhammad Yusuf', 1371098756384902, 'PASAR BARU', 50),
('A03', 3, 'Dimas Nanda Caesar', 1371098756384943, 'BELIMBING', 56);

-- --------------------------------------------------------

--
-- Table structure for table `pegawai`
--

CREATE TABLE `pegawai` (
  `idPeg` char(3) NOT NULL,
  `idPoli` char(4) NOT NULL,
  `namaPeg` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pegawai`
--

INSERT INTO `pegawai` (`idPeg`, `idPoli`, `namaPeg`) VALUES
('PI1', 'PPA1', 'Rifqi'),
('PJ1', 'PPD1', 'Rehan'),
('PJ2', 'MG11', 'Agum'),
('PR1', 'POP1', 'Vanessa');

-- --------------------------------------------------------

--
-- Table structure for table `poli`
--

CREATE TABLE `poli` (
  `idPoli` char(4) NOT NULL,
  `nama_poli` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `poli`
--

INSERT INTO `poli` (`idPoli`, `nama_poli`) VALUES
('MG11', 'Mata'),
('NE30', 'Neurologi'),
('POP1', 'Orthopedi'),
('PPA1', 'Anak'),
('PPD1', 'Penyakit Dalam');

-- --------------------------------------------------------

--
-- Table structure for table `reservasi`
--

CREATE TABLE `reservasi` (
  `idRev` char(3) NOT NULL,
  `idPoli` char(4) NOT NULL,
  `idDok` char(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservasi`
--

INSERT INTO `reservasi` (`idRev`, `idPoli`, `idDok`) VALUES
('A01', 'POP1', 'OR1'),
('A02', 'PPA1', 'AK1'),
('A03', 'PPD1', 'PD1'),
('A04', 'POP1', 'AK1');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `antri_poli`
--
ALTER TABLE `antri_poli`
  ADD PRIMARY KEY (`id_antri`),
  ADD KEY `idRev` (`idRev`);

--
-- Indexes for table `biaya`
--
ALTER TABLE `biaya`
  ADD PRIMARY KEY (`idBiaya`),
  ADD KEY `idRev` (`idRev`);

--
-- Indexes for table `dokter`
--
ALTER TABLE `dokter`
  ADD PRIMARY KEY (`idDok`),
  ADD KEY `idPoli` (`idPoli`);

--
-- Indexes for table `pasien`
--
ALTER TABLE `pasien`
  ADD PRIMARY KEY (`NoRM`),
  ADD KEY `idRev` (`idRev`);

--
-- Indexes for table `pegawai`
--
ALTER TABLE `pegawai`
  ADD PRIMARY KEY (`idPeg`),
  ADD KEY `idPoli` (`idPoli`);

--
-- Indexes for table `poli`
--
ALTER TABLE `poli`
  ADD PRIMARY KEY (`idPoli`);

--
-- Indexes for table `reservasi`
--
ALTER TABLE `reservasi`
  ADD PRIMARY KEY (`idRev`),
  ADD KEY `idPoli` (`idPoli`),
  ADD KEY `idDok` (`idDok`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `antri_poli`
--
ALTER TABLE `antri_poli`
  MODIFY `id_antri` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `pasien`
--
ALTER TABLE `pasien`
  MODIFY `NoRM` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `antri_poli`
--
ALTER TABLE `antri_poli`
  ADD CONSTRAINT `antri_poli_ibfk_1` FOREIGN KEY (`idRev`) REFERENCES `reservasi` (`idRev`);

--
-- Constraints for table `biaya`
--
ALTER TABLE `biaya`
  ADD CONSTRAINT `biaya_ibfk_1` FOREIGN KEY (`idRev`) REFERENCES `reservasi` (`idRev`);

--
-- Constraints for table `dokter`
--
ALTER TABLE `dokter`
  ADD CONSTRAINT `dokter_ibfk_1` FOREIGN KEY (`idPoli`) REFERENCES `poli` (`idPoli`);

--
-- Constraints for table `pasien`
--
ALTER TABLE `pasien`
  ADD CONSTRAINT `pasien_ibfk_1` FOREIGN KEY (`idRev`) REFERENCES `reservasi` (`idRev`);

--
-- Constraints for table `pegawai`
--
ALTER TABLE `pegawai`
  ADD CONSTRAINT `pegawai_ibfk_1` FOREIGN KEY (`idPoli`) REFERENCES `poli` (`idPoli`);

--
-- Constraints for table `reservasi`
--
ALTER TABLE `reservasi`
  ADD CONSTRAINT `reservasi_ibfk_1` FOREIGN KEY (`idPoli`) REFERENCES `poli` (`idPoli`),
  ADD CONSTRAINT `reservasi_ibfk_2` FOREIGN KEY (`idDok`) REFERENCES `dokter` (`idDok`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
