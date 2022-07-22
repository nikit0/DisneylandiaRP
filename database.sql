-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.4.13-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Copiando estrutura do banco de dados para disneylandiarp
CREATE DATABASE IF NOT EXISTS `disneylandiarp` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `disneylandiarp`;

-- Copiando estrutura para tabela disneylandiarp.vrp_homes_permissions
CREATE TABLE IF NOT EXISTS `vrp_homes_permissions` (
  `home` varchar(50) NOT NULL,
  `user_id` int(11) NOT NULL,
  `owner` int(1) NOT NULL DEFAULT 0,
  `tax` int(11) NOT NULL,
  `garage` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`home`,`user_id`),
  KEY `home` (`home`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela disneylandiarp.vrp_srv_data
CREATE TABLE IF NOT EXISTS `vrp_srv_data` (
  `dkey` varchar(100) NOT NULL,
  `dvalue` text DEFAULT NULL,
  PRIMARY KEY (`dkey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela disneylandiarp.vrp_users
CREATE TABLE IF NOT EXISTS `vrp_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `whitelisted` tinyint(1) DEFAULT NULL,
  `banned` tinyint(1) DEFAULT NULL,
  `garagem` int(4) DEFAULT 4,
  `pets` varchar(50) NOT NULL,
  `groups` text NOT NULL DEFAULT '[]',
  `vip_time` int(11) NOT NULL DEFAULT 0,
  `steam` text NOT NULL,
  `priority` int(4) NOT NULL DEFAULT 0,
  `coins` int(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `whitelisted` (`whitelisted`) USING BTREE,
  KEY `banned` (`banned`) USING BTREE,
  KEY `garagem` (`garagem`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela disneylandiarp.vrp_users_banned
CREATE TABLE IF NOT EXISTS `vrp_users_banned` (
  `user_id` int(11) DEFAULT NULL,
  `hacker` int(11) DEFAULT NULL,
  `identifier` varchar(100) NOT NULL,
  PRIMARY KEY (`identifier`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela disneylandiarp.vrp_user_data
CREATE TABLE IF NOT EXISTS `vrp_user_data` (
  `user_id` int(11) NOT NULL,
  `dkey` varchar(100) NOT NULL,
  `dvalue` text DEFAULT NULL,
  PRIMARY KEY (`user_id`,`dkey`),
  CONSTRAINT `fk_user_data_users` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela disneylandiarp.vrp_user_identities
CREATE TABLE IF NOT EXISTS `vrp_user_identities` (
  `user_id` int(11) NOT NULL,
  `registration` varchar(20) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `registration` (`registration`),
  KEY `phone` (`phone`),
  CONSTRAINT `fk_user_identities_users` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela disneylandiarp.vrp_user_ids
CREATE TABLE IF NOT EXISTS `vrp_user_ids` (
  `identifier` varchar(100) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`identifier`),
  KEY `fk_user_ids_users` (`user_id`),
  CONSTRAINT `fk_user_ids_users` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela disneylandiarp.vrp_user_inventory
CREATE TABLE IF NOT EXISTS `vrp_user_inventory` (
  `user_id` int(11) NOT NULL,
  `itemlist` text DEFAULT NULL,
  `max` int(11) NOT NULL DEFAULT 6,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `inventory_users` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela disneylandiarp.vrp_user_moneys
CREATE TABLE IF NOT EXISTS `vrp_user_moneys` (
  `user_id` int(11) NOT NULL,
  `wallet` int(11) DEFAULT NULL,
  `bank` int(11) DEFAULT NULL,
  `paypal` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_user_moneys_users` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela disneylandiarp.vrp_user_vehicles
CREATE TABLE IF NOT EXISTS `vrp_user_vehicles` (
  `user_id` int(11) NOT NULL,
  `vehicle` varchar(100) NOT NULL,
  `detido` int(1) NOT NULL DEFAULT 0,
  `time` varchar(24) NOT NULL DEFAULT '0',
  `engine` int(4) NOT NULL DEFAULT 1000,
  `body` int(4) NOT NULL DEFAULT 1000,
  `fuel` int(3) NOT NULL DEFAULT 100,
  `ipva` int(11) NOT NULL,
  `rental_time` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`,`vehicle`),
  CONSTRAINT `fk_user_vehicles_users` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela disneylandiarp.vrp_vehicles
CREATE TABLE IF NOT EXISTS `vrp_vehicles` (
  `spawn` text DEFAULT NULL,
  `name` text DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `class` text DEFAULT NULL,
  `type` mediumtext DEFAULT NULL,
  `stock` int(11) NOT NULL,
  `hash` text DEFAULT NULL,
  `chestweight` int(11) DEFAULT NULL,
  `banned` tinyint(1) DEFAULT NULL,
  `race_class` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
