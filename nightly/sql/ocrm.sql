-- MySQL dump 10.17  Distrib 10.3.22-MariaDB, for debian-linux-gnueabihf (armv8l)
--
-- Host: localhost    Database: ocrm
-- ------------------------------------------------------
-- Server version	10.3.22-MariaDB-0+deb10u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ocrm_customers`
--

DROP TABLE IF EXISTS `ocrm_customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_customers` (
  `id_ocrm_customers` int(11) NOT NULL AUTO_INCREMENT,
  `changedat` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `changedby` int(11) DEFAULT NULL,
  `code` varchar(8) DEFAULT replace(replace(replace(ucase(left(to_base64(unhex(sha(concat(current_timestamp(),rand())))),8)),'/','1'),'+','2'),'=','3'),
  `id_ocrm_processes` int(11) DEFAULT NULL,
  `id_ocrm_expenses` int(11) DEFAULT NULL,
  `id_ocrm_revenues` int(11) DEFAULT NULL,
  `id_ocrm_invoices` int(11) DEFAULT NULL,
  `id_ocrm_proposals` int(11) DEFAULT NULL,
  `name` varchar(80) DEFAULT NULL,
  `street` varchar(80) DEFAULT NULL,
  `postcode` int(11) DEFAULT NULL,
  `city` varchar(40) DEFAULT NULL,
  `contact` varchar(80) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `commentary` text DEFAULT NULL,
  PRIMARY KEY (`id_ocrm_customers`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ocrm_customers`
--

LOCK TABLES `ocrm_customers` WRITE;
/*!40000 ALTER TABLE `ocrm_customers` DISABLE KEYS */;
/*!40000 ALTER TABLE `ocrm_customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ocrm_customers_permissions`
--

DROP TABLE IF EXISTS `ocrm_customers_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_customers_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `keymachine` varchar(40) DEFAULT NULL,
  `keyreadable` varchar(255) DEFAULT NULL,
  `realid` decimal(6,3) DEFAULT NULL,
  `typelist` varchar(40) DEFAULT NULL,
  `edittype` varchar(60) DEFAULT NULL,
  `defaultvalue` text DEFAULT NULL,
  `referencetag` varchar(40) DEFAULT NULL,
  `role_0` int(11) DEFAULT 0,
  `restrictrole_0` text DEFAULT NULL,
  `role_1` int(11) DEFAULT 0,
  `restrictrole_1` text DEFAULT NULL,
  `role_6` int(11) DEFAULT 0,
  `restrictrole_6` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ocrm_customers_permissions`
--

LOCK TABLES `ocrm_customers_permissions` WRITE;
/*!40000 ALTER TABLE `ocrm_customers_permissions` DISABLE KEYS */;
INSERT INTO `ocrm_customers_permissions` VALUES (1,'changedat','_none_',NULL,'TIMESTAMP','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(2,'changedby','_none_',NULL,'VARCHAR(40)','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(3,'code','Code',NULL,'VARCHAR(8)','ID','(REPLACE(REPLACE(REPLACE(upper(LEFT(to_base64(UNHEX(sha1(CONCAT(NOW(),RAND())))),8)),\'/\',\'1\'),\'+\',\'2\'),\'=\',\'3\'))',NULL,6,NULL,0,NULL,0,NULL),(4,'name','Firmenname',4.000,'VARCHAR(80)','TEXT',NULL,NULL,0,NULL,0,NULL,0,NULL),(5,'street','Straße und Hausnummer',5.000,'VARCHAR(80)','TEXT',NULL,NULL,0,NULL,0,NULL,0,NULL),(6,'postcode','PLZ',6.000,'INT','INTEGER',NULL,NULL,0,NULL,0,NULL,0,NULL),(7,'city','Stadt',7.000,'VARCHAR(40)','TEXT',NULL,NULL,0,NULL,0,NULL,0,NULL),(8,'contact','Ansprechpartner',8.000,'VARCHAR(80)','TEXT',NULL,NULL,0,NULL,0,NULL,0,NULL),(9,'phone','Telefon',9.000,'VARCHAR(20)','TEXT; MULTIPLE',NULL,NULL,0,NULL,0,NULL,0,NULL),(10,'commentary','Kommentar',10.000,'TEXT','EDITOR',NULL,NULL,0,NULL,0,NULL,0,NULL);
/*!40000 ALTER TABLE `ocrm_customers_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ocrm_customers_references`
--

DROP TABLE IF EXISTS `ocrm_customers_references`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_customers_references` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `referencetag` varchar(40) DEFAULT NULL,
  `depends_on_key` varchar(80) DEFAULT NULL,
  `depends_on_value` varchar(80) DEFAULT NULL,
  `allowed_values` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ocrm_customers_references`
--

LOCK TABLES `ocrm_customers_references` WRITE;
/*!40000 ALTER TABLE `ocrm_customers_references` DISABLE KEYS */;
INSERT INTO `ocrm_customers_references` VALUES (1,'_none_',NULL,NULL,NULL);
/*!40000 ALTER TABLE `ocrm_customers_references` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ocrm_expenses`
--

DROP TABLE IF EXISTS `ocrm_expenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_expenses` (
  `id_ocrm_expenses` int(11) NOT NULL AUTO_INCREMENT,
  `changedat` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `changedby` int(11) DEFAULT NULL,
  `code` varchar(8) DEFAULT replace(replace(replace(ucase(left(to_base64(unhex(sha(concat(current_timestamp(),rand())))),8)),'/','1'),'+','2'),'=','3'),
  `id_ocrm_customers` int(11) DEFAULT NULL,
  `id_ocrm_processes` int(11) DEFAULT NULL,
  `id_ocrm_revenues` int(11) DEFAULT NULL,
  `id_ocrm_invoices` int(11) DEFAULT NULL,
  `id_ocrm_proposals` int(11) DEFAULT NULL,
  `expensename` text DEFAULT NULL,
  `expensecost` decimal(7,2) DEFAULT NULL,
  `expensevat` decimal(7,2) DEFAULT NULL,
  `expensedate` date DEFAULT current_timestamp(),
  PRIMARY KEY (`id_ocrm_expenses`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ocrm_expenses`
--

LOCK TABLES `ocrm_expenses` WRITE;
/*!40000 ALTER TABLE `ocrm_expenses` DISABLE KEYS */;
/*!40000 ALTER TABLE `ocrm_expenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ocrm_expenses_permissions`
--

DROP TABLE IF EXISTS `ocrm_expenses_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_expenses_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `keymachine` varchar(40) DEFAULT NULL,
  `keyreadable` varchar(255) DEFAULT NULL,
  `realid` decimal(6,3) DEFAULT NULL,
  `typelist` varchar(40) DEFAULT NULL,
  `edittype` varchar(60) DEFAULT NULL,
  `defaultvalue` text DEFAULT NULL,
  `referencetag` varchar(40) DEFAULT NULL,
  `role_0` int(11) DEFAULT 0,
  `restrictrole_0` text DEFAULT NULL,
  `role_1` int(11) DEFAULT 0,
  `restrictrole_1` text DEFAULT NULL,
  `role_6` int(11) DEFAULT 0,
  `restrictrole_6` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ocrm_expenses_permissions`
--

LOCK TABLES `ocrm_expenses_permissions` WRITE;
/*!40000 ALTER TABLE `ocrm_expenses_permissions` DISABLE KEYS */;
INSERT INTO `ocrm_expenses_permissions` VALUES (1,'changedat','_none_',NULL,'TIMESTAMP','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(2,'changedby','_none_',NULL,'VARCHAR(40)','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(3,'code','Code',NULL,'VARCHAR(8)','ID','(REPLACE(REPLACE(REPLACE(upper(LEFT(to_base64(UNHEX(sha1(CONCAT(NOW(),RAND())))),8)),\'/\',\'1\'),\'+\',\'2\'),\'=\',\'3\'))',NULL,6,NULL,0,NULL,0,NULL),(4,'expensename','Zweck',4.000,'TEXT','TEXT',NULL,NULL,0,NULL,0,NULL,0,NULL),(5,'expensecost','Preis',5.000,'DECIMAL(7,2)','FLOAT',NULL,NULL,0,NULL,0,NULL,0,NULL),(6,'expensevat','inkl. MwSt.',6.000,'DECIMAL(7,2)','FLOAT',NULL,NULL,0,NULL,0,NULL,0,NULL),(7,'expensedate','Datum',7.000,'DATE','DATE','(NOW())',NULL,0,NULL,0,NULL,0,NULL);
/*!40000 ALTER TABLE `ocrm_expenses_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ocrm_expenses_references`
--

DROP TABLE IF EXISTS `ocrm_expenses_references`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_expenses_references` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `referencetag` varchar(40) DEFAULT NULL,
  `depends_on_key` varchar(80) DEFAULT NULL,
  `depends_on_value` varchar(80) DEFAULT NULL,
  `allowed_values` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ocrm_expenses_references`
--

LOCK TABLES `ocrm_expenses_references` WRITE;
/*!40000 ALTER TABLE `ocrm_expenses_references` DISABLE KEYS */;
INSERT INTO `ocrm_expenses_references` VALUES (1,'_none_',NULL,NULL,NULL);
/*!40000 ALTER TABLE `ocrm_expenses_references` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ocrm_invoices`
--

DROP TABLE IF EXISTS `ocrm_invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_invoices` (
  `id_ocrm_invoices` int(11) NOT NULL AUTO_INCREMENT,
  `changedat` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `changedby` int(11) DEFAULT NULL,
  `code` varchar(8) DEFAULT replace(replace(replace(ucase(left(to_base64(unhex(sha(concat(current_timestamp(),rand())))),8)),'/','1'),'+','2'),'=','3'),
  `id_ocrm_customers` int(11) DEFAULT NULL,
  `id_ocrm_processes` int(11) DEFAULT NULL,
  `id_ocrm_expenses` int(11) DEFAULT NULL,
  `id_ocrm_revenues` int(11) DEFAULT NULL,
  `id_ocrm_proposals` int(11) DEFAULT NULL,
  `invoicedate` date DEFAULT current_timestamp(),
  `invoicefinished` varchar(8) DEFAULT 'nein',
  `invoicevatrate` decimal(4,2) DEFAULT 19.00,
  `invoicename` varchar(40) DEFAULT NULL,
  `invoicenumber` varchar(20) DEFAULT NULL,
  `invoiceamount` decimal(7,2) DEFAULT NULL,
  `invoicevat` decimal(7,2) DEFAULT NULL,
  `invoicetarget` int(11) DEFAULT 30,
  PRIMARY KEY (`id_ocrm_invoices`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ocrm_invoices`
--

LOCK TABLES `ocrm_invoices` WRITE;
/*!40000 ALTER TABLE `ocrm_invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `ocrm_invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ocrm_invoices_permissions`
--

DROP TABLE IF EXISTS `ocrm_invoices_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_invoices_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `keymachine` varchar(40) DEFAULT NULL,
  `keyreadable` varchar(255) DEFAULT NULL,
  `realid` decimal(6,3) DEFAULT NULL,
  `typelist` varchar(40) DEFAULT NULL,
  `edittype` varchar(60) DEFAULT NULL,
  `defaultvalue` text DEFAULT NULL,
  `referencetag` varchar(40) DEFAULT NULL,
  `role_0` int(11) DEFAULT 0,
  `restrictrole_0` text DEFAULT NULL,
  `role_1` int(11) DEFAULT 0,
  `restrictrole_1` text DEFAULT NULL,
  `role_6` int(11) DEFAULT 0,
  `restrictrole_6` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ocrm_invoices_permissions`
--

LOCK TABLES `ocrm_invoices_permissions` WRITE;
/*!40000 ALTER TABLE `ocrm_invoices_permissions` DISABLE KEYS */;
INSERT INTO `ocrm_invoices_permissions` VALUES (1,'changedat','_none_',NULL,'TIMESTAMP','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(2,'changedby','_none_',NULL,'VARCHAR(40)','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(3,'code','Code',NULL,'VARCHAR(8)','ID','(REPLACE(REPLACE(REPLACE(upper(LEFT(to_base64(UNHEX(sha1(CONCAT(NOW(),RAND())))),8)),\'/\',\'1\'),\'+\',\'2\'),\'=\',\'3\'))',NULL,6,NULL,0,NULL,0,NULL),(4,'invoicedate','Datum',4.000,'DATE','DATE','(NOW())',NULL,0,NULL,0,NULL,0,NULL),(5,'invoicefinished','Rechnung erstellt?',5.000,'VARCHAR(8)','LIST','\'nein\'','_invoicefinished',0,NULL,0,NULL,0,NULL),(6,'invoicevatrate','MwSt-Satz',4.500,'DECIMAL(4,2)','LIST','\'19.00\'','_invoicevat',0,NULL,0,NULL,0,NULL),(7,'invoicename','Bezeichnung (intern)',3.500,'VARCHAR(40)','TEXT',NULL,NULL,0,NULL,0,NULL,0,NULL),(9,'invoicenumber','Rechnungsnummer',9.000,'VARCHAR(20)','LIST',NULL,'_invoiceempty',0,NULL,0,NULL,0,NULL),(10,'invoiceamount','Rechnungsbetrag (inkl. MwSt)',10.000,'DECIMAL(7,2)','FLOAT',NULL,'_invoiceempty',0,NULL,0,NULL,0,NULL),(11,'invoicevat','davon MwSt',11.000,'DECIMAL(7,2)','FLOAT',NULL,'_invoiceempty',0,NULL,0,NULL,0,NULL),(12,'invoicetarget','Zahlungsziel (Tage)',6.000,'INT','INTEGER','30',NULL,0,NULL,0,NULL,0,NULL);
/*!40000 ALTER TABLE `ocrm_invoices_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ocrm_invoices_references`
--

DROP TABLE IF EXISTS `ocrm_invoices_references`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_invoices_references` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `referencetag` varchar(40) DEFAULT NULL,
  `depends_on_key` varchar(80) DEFAULT NULL,
  `depends_on_value` varchar(80) DEFAULT NULL,
  `allowed_values` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ocrm_invoices_references`
--

LOCK TABLES `ocrm_invoices_references` WRITE;
/*!40000 ALTER TABLE `ocrm_invoices_references` DISABLE KEYS */;
INSERT INTO `ocrm_invoices_references` VALUES (1,'_none_',NULL,NULL,NULL),(2,'_invoicefinished',NULL,NULL,'[\"\",\"ja\",\"nein\"]'),(3,'_invoicevat',NULL,NULL,'[\"\",\"7.00\",\"19.00\"]'),(4,'_invoiceempty',NULL,NULL,'[\"\"]');
/*!40000 ALTER TABLE `ocrm_invoices_references` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ocrm_processes`
--

DROP TABLE IF EXISTS `ocrm_processes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_processes` (
  `id_ocrm_processes` int(11) NOT NULL AUTO_INCREMENT,
  `changedat` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `changedby` int(11) DEFAULT NULL,
  `code` varchar(8) DEFAULT replace(replace(replace(ucase(left(to_base64(unhex(sha(concat(current_timestamp(),rand())))),8)),'/','1'),'+','2'),'=','3'),
  `id_` int(11) DEFAULT NULL,
  `id_ocrm_customers` int(11) DEFAULT NULL,
  `id_ocrm_expenses` int(11) DEFAULT NULL,
  `id_ocrm_revenues` int(11) DEFAULT NULL,
  `id_ocrm_invoices` int(11) DEFAULT NULL,
  `id_ocrm_proposals` int(11) DEFAULT NULL,
  `processbegin` datetime DEFAULT current_timestamp(),
  `processend` datetime DEFAULT current_timestamp(),
  `processrate` decimal(7,2) DEFAULT NULL,
  `processdetails` text DEFAULT NULL,
  `processtype` varchar(40) DEFAULT 'Support',
  `processunit` varchar(8) DEFAULT 'h',
  `processvatrate` decimal(4,2) DEFAULT 19.00,
  `processunits` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`id_ocrm_processes`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ocrm_processes`
--

LOCK TABLES `ocrm_processes` WRITE;
/*!40000 ALTER TABLE `ocrm_processes` DISABLE KEYS */;
/*!40000 ALTER TABLE `ocrm_processes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ocrm_processes_permissions`
--

DROP TABLE IF EXISTS `ocrm_processes_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_processes_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `keymachine` varchar(40) DEFAULT NULL,
  `keyreadable` varchar(255) DEFAULT NULL,
  `realid` decimal(6,3) DEFAULT NULL,
  `typelist` varchar(40) DEFAULT NULL,
  `edittype` varchar(60) DEFAULT NULL,
  `defaultvalue` text DEFAULT NULL,
  `referencetag` varchar(40) DEFAULT NULL,
  `role_0` int(11) DEFAULT 0,
  `restrictrole_0` text DEFAULT NULL,
  `role_1` int(11) DEFAULT 0,
  `restrictrole_1` text DEFAULT NULL,
  `role_6` int(11) DEFAULT 0,
  `restrictrole_6` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ocrm_processes_permissions`
--

LOCK TABLES `ocrm_processes_permissions` WRITE;
/*!40000 ALTER TABLE `ocrm_processes_permissions` DISABLE KEYS */;
INSERT INTO `ocrm_processes_permissions` VALUES (1,'changedat','_none_',NULL,'TIMESTAMP','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(2,'changedby','_none_',NULL,'VARCHAR(40)','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(3,'code','Code',NULL,'VARCHAR(8)','ID','(REPLACE(REPLACE(REPLACE(upper(LEFT(to_base64(UNHEX(sha1(CONCAT(NOW(),RAND())))),8)),\'/\',\'1\'),\'+\',\'2\'),\'=\',\'3\'))',NULL,6,NULL,0,NULL,0,NULL),(5,'processbegin','Leistungs-/Lieferbeginn',5.000,'DATETIME','DATETIME','(NOW())',NULL,0,NULL,0,NULL,0,NULL),(6,'processend','Leistungs-/Lieferende',6.000,'DATETIME','DATETIME','(NOW())',NULL,0,NULL,0,NULL,0,NULL),(7,'processunit','Einheit',7.000,'VARCHAR(8)','LIST','\'h\'','_processunit',0,NULL,0,NULL,0,NULL),(8,'processrate','Preis pro Einheit',8.000,'DECIMAL(7,2)','EXTENSIBLE LIST',NULL,'_processrate',0,NULL,0,NULL,0,NULL),(9,'processdetails','Details',9.000,'TEXT','FREE',NULL,NULL,0,NULL,0,NULL,0,NULL),(11,'processtype','Typ',4.000,'VARCHAR(40)','LIST','\'Support\'','_processtype',0,NULL,0,NULL,0,NULL),(14,'processvatrate','Mwst-Satz',8.500,'DECIMAL(4,2)','LIST','\'19.00\'','_processvatrate',0,NULL,0,NULL,0,NULL),(15,'processunits','Anzahl',7.500,'DECIMAL(4,2)','FLOAT',NULL,NULL,0,NULL,0,NULL,0,NULL);
/*!40000 ALTER TABLE `ocrm_processes_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ocrm_processes_references`
--

DROP TABLE IF EXISTS `ocrm_processes_references`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_processes_references` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `referencetag` varchar(40) DEFAULT NULL,
  `depends_on_key` varchar(80) DEFAULT NULL,
  `depends_on_value` varchar(80) DEFAULT NULL,
  `allowed_values` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ocrm_processes_references`
--

LOCK TABLES `ocrm_processes_references` WRITE;
/*!40000 ALTER TABLE `ocrm_processes_references` DISABLE KEYS */;
INSERT INTO `ocrm_processes_references` VALUES (1,'_none_',NULL,NULL,NULL),(2,'_processtype',NULL,NULL,'[\"Beratung\",\"Hardwarekauf\",\"Betriebssysteme/eingebettete Systeme\",\"Netzwerk\",\"Programmierung\",\"Software-Installation inkl. OS\",\"Webinhalte\",\"Support\"]'),(3,'_processunit','processtype','Beratung','[\"1\",\"h\"]'),(4,'_processunit','processtype','Hardwarekauf','[\"1\"]'),(5,'_processunit','processtype','Betriebssysteme/eingebettete Systeme','[\"1\",\"h\"]'),(6,'_processunit','processtype','Netzwerk','[\"h\"]'),(7,'_processunit','processtype','Programmierung','[\"1\",\"h\"]'),(8,'_processunit','processtype','Software-Installation inkl. OS','[\"1\",\"h\"]'),(9,'_processunit','processtyoe','Webinhalte','[\"1\",\"h\"]'),(10,'_processunit','processtype','Support','[\"h\"]'),(11,'_processrate',NULL,NULL,'[\"25.00\",\"34.30\",\"39.00\",\"49.00\",\"69.00\",\"89.00\"]'),(12,'_processvatrate',NULL,NULL,'[\"\",\"7.00\",\"19.00\"]');
/*!40000 ALTER TABLE `ocrm_processes_references` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ocrm_proposals`
--

DROP TABLE IF EXISTS `ocrm_proposals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_proposals` (
  `id_ocrm_proposals` int(11) NOT NULL AUTO_INCREMENT,
  `changedat` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `changedby` int(11) DEFAULT NULL,
  `code` varchar(8) DEFAULT replace(replace(replace(ucase(left(to_base64(unhex(sha(concat(current_timestamp(),rand())))),8)),'/','1'),'+','2'),'=','3'),
  `id_ocrm_customers` int(11) DEFAULT NULL,
  `id_ocrm_processes` int(11) DEFAULT NULL,
  `id_ocrm_expenses` int(11) DEFAULT NULL,
  `id_ocrm_revenues` int(11) DEFAULT NULL,
  `id_ocrm_invoices` int(11) DEFAULT NULL,
  `proposalname` varchar(40) DEFAULT NULL,
  `proposaldate` date DEFAULT current_timestamp(),
  `proposalvatrate` decimal(4,2) DEFAULT 19.00,
  `proposalfinished` varchar(8) DEFAULT 'nein',
  `proposalnumber` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_ocrm_proposals`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ocrm_proposals`
--

LOCK TABLES `ocrm_proposals` WRITE;
/*!40000 ALTER TABLE `ocrm_proposals` DISABLE KEYS */;
/*!40000 ALTER TABLE `ocrm_proposals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ocrm_proposals_permissions`
--

DROP TABLE IF EXISTS `ocrm_proposals_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_proposals_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `keymachine` varchar(40) DEFAULT NULL,
  `keyreadable` varchar(255) DEFAULT NULL,
  `realid` decimal(6,3) DEFAULT NULL,
  `typelist` varchar(40) DEFAULT NULL,
  `edittype` varchar(60) DEFAULT NULL,
  `defaultvalue` text DEFAULT NULL,
  `referencetag` varchar(40) DEFAULT NULL,
  `role_0` int(11) DEFAULT 0,
  `restrictrole_0` text DEFAULT NULL,
  `role_1` int(11) DEFAULT 0,
  `restrictrole_1` text DEFAULT NULL,
  `role_6` int(11) DEFAULT 0,
  `restrictrole_6` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ocrm_proposals_permissions`
--

LOCK TABLES `ocrm_proposals_permissions` WRITE;
/*!40000 ALTER TABLE `ocrm_proposals_permissions` DISABLE KEYS */;
INSERT INTO `ocrm_proposals_permissions` VALUES (1,'changedat','_none_',NULL,'TIMESTAMP','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(2,'changedby','_none_',NULL,'VARCHAR(40)','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(3,'code','Code',NULL,'VARCHAR(8)','ID','(REPLACE(REPLACE(REPLACE(upper(LEFT(to_base64(UNHEX(sha1(CONCAT(NOW(),RAND())))),8)),\'/\',\'1\'),\'+\',\'2\'),\'=\',\'3\'))',NULL,6,NULL,0,NULL,0,NULL),(4,'proposalname','Bezeichnung (intern)',4.000,'VARCHAR(40)','TEXT',NULL,NULL,0,NULL,0,NULL,0,NULL),(5,'proposaldate','Datum',5.000,'DATE','DATE','(NOW())',NULL,0,NULL,0,NULL,0,NULL),(6,'proposalvatrate','MwSt.-Satz',6.000,'DECIMAL(4,2)','LIST','\'19.00\'','_proposalvatrate',0,NULL,0,NULL,0,NULL),(7,'proposalfinished','Angebot erstellt?',7.000,'VARCHAR(8)','LIST','\'nein\'','_proposalfinished',0,NULL,0,NULL,0,NULL),(8,'proposalnumber','Angebotsnummer',8.000,'VARCHAR(20)','LIST',NULL,'_proposalempty',0,NULL,0,NULL,0,NULL);
/*!40000 ALTER TABLE `ocrm_proposals_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ocrm_proposals_references`
--

DROP TABLE IF EXISTS `ocrm_proposals_references`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_proposals_references` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `referencetag` varchar(40) DEFAULT NULL,
  `depends_on_key` varchar(80) DEFAULT NULL,
  `depends_on_value` varchar(80) DEFAULT NULL,
  `allowed_values` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ocrm_proposals_references`
--

LOCK TABLES `ocrm_proposals_references` WRITE;
/*!40000 ALTER TABLE `ocrm_proposals_references` DISABLE KEYS */;
INSERT INTO `ocrm_proposals_references` VALUES (1,'_none_',NULL,NULL,NULL),(2,'_proposalvatrate',NULL,NULL,'[\"\",\"7.00\",\"19.00\"]'),(3,'_proposalfinished',NULL,NULL,'[\"\",\"ja\",\"nein\"]'),(4,'_proposalempty',NULL,NULL,'[\"\"]');
/*!40000 ALTER TABLE `ocrm_proposals_references` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ocrm_revenues`
--

DROP TABLE IF EXISTS `ocrm_revenues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_revenues` (
  `id_ocrm_revenues` int(11) NOT NULL AUTO_INCREMENT,
  `changedat` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `changedby` int(11) DEFAULT NULL,
  `code` varchar(8) DEFAULT replace(replace(replace(ucase(left(to_base64(unhex(sha(concat(current_timestamp(),rand())))),8)),'/','1'),'+','2'),'=','3'),
  `id_ocrm_customers` int(11) DEFAULT NULL,
  `id_ocrm_processes` int(11) DEFAULT NULL,
  `id_ocrm_expenses` int(11) DEFAULT NULL,
  `id_ocrm_invoices` int(11) DEFAULT NULL,
  `id_ocrm_proposals` int(11) DEFAULT NULL,
  `revenuename` varchar(40) DEFAULT NULL,
  `revenuedate` date DEFAULT current_timestamp(),
  `revenueamount` decimal(7,2) DEFAULT NULL,
  `revenuevat` decimal(7,2) DEFAULT NULL,
  `revenuevatrate` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`id_ocrm_revenues`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ocrm_revenues`
--

LOCK TABLES `ocrm_revenues` WRITE;
/*!40000 ALTER TABLE `ocrm_revenues` DISABLE KEYS */;
/*!40000 ALTER TABLE `ocrm_revenues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ocrm_revenues_permissions`
--

DROP TABLE IF EXISTS `ocrm_revenues_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_revenues_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `keymachine` varchar(40) DEFAULT NULL,
  `keyreadable` varchar(255) DEFAULT NULL,
  `realid` decimal(6,3) DEFAULT NULL,
  `typelist` varchar(40) DEFAULT NULL,
  `edittype` varchar(60) DEFAULT NULL,
  `defaultvalue` text DEFAULT NULL,
  `referencetag` varchar(40) DEFAULT NULL,
  `role_0` int(11) DEFAULT 0,
  `restrictrole_0` text DEFAULT NULL,
  `role_1` int(11) DEFAULT 0,
  `restrictrole_1` text DEFAULT NULL,
  `role_6` int(11) DEFAULT 0,
  `restrictrole_6` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ocrm_revenues_permissions`
--

LOCK TABLES `ocrm_revenues_permissions` WRITE;
/*!40000 ALTER TABLE `ocrm_revenues_permissions` DISABLE KEYS */;
INSERT INTO `ocrm_revenues_permissions` VALUES (1,'changedat','_none_',NULL,'TIMESTAMP','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(2,'changedby','_none_',NULL,'VARCHAR(40)','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(3,'code','Code',NULL,'VARCHAR(8)','ID','(REPLACE(REPLACE(REPLACE(upper(LEFT(to_base64(UNHEX(sha1(CONCAT(NOW(),RAND())))),8)),\'/\',\'1\'),\'+\',\'2\'),\'=\',\'3\'))',NULL,6,NULL,0,NULL,0,NULL),(4,'revenuename','Grund',4.000,'VARCHAR(40)','TEXT',NULL,NULL,0,NULL,0,NULL,0,NULL),(5,'revenuedate','Datum',5.000,'DATE','DATE','(NOW())',NULL,0,NULL,0,NULL,0,NULL),(6,'revenueamount','Betrag',6.000,'DECIMAL(7,2)','FLOAT',NULL,NULL,0,NULL,0,NULL,0,NULL),(7,'revenuevat','inkl. MwSt.',7.000,'DECIMAL(7,2)','FLOAT',NULL,NULL,0,NULL,0,NULL,0,NULL);
/*!40000 ALTER TABLE `ocrm_revenues_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ocrm_revenues_references`
--

DROP TABLE IF EXISTS `ocrm_revenues_references`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_revenues_references` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `referencetag` varchar(40) DEFAULT NULL,
  `depends_on_key` varchar(80) DEFAULT NULL,
  `depends_on_value` varchar(80) DEFAULT NULL,
  `allowed_values` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ocrm_revenues_references`
--

LOCK TABLES `ocrm_revenues_references` WRITE;
/*!40000 ALTER TABLE `ocrm_revenues_references` DISABLE KEYS */;
INSERT INTO `ocrm_revenues_references` VALUES (1,'_none_',NULL,NULL,NULL);
/*!40000 ALTER TABLE `ocrm_revenues_references` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `os_tables`
--

LOCK TABLES `os_tables` WRITE;
/*!40000 ALTER TABLE `os_tables` DISABLE KEYS */;
INSERT INTO `os_tables` VALUES (9,'building','ocrm_customers','Kunden','[6]','[6]',NULL),(10,'hammer','ocrm_processes','Tätigkeiten','[6]','[6]',NULL),(11,'shopping-cart','ocrm_expenses','Ausgaben','[6]','[6]',NULL),(12,'money-bill-wave','ocrm_revenues','Einnahmen','[6]','[6]',NULL),(13,'comment-dollar','ocrm_invoices','Rechnungen','[6]','[6]','[\"\"]'),(14,'bullhorn','ocrm_proposals','Angebote','[6]','[6]',NULL);
/*!40000 ALTER TABLE `os_tables` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `os_functions`
--

LOCK TABLES `os_functions` WRITE;
/*!40000 ALTER TABLE `os_functions` DISABLE KEYS */;
INSERT INTO `os_functions` VALUES (10,'receipt','createInvoice','Rechnung erstellen','DETAILS','details invoice','[0]','_popup_'),(11,'user-tie','createProposal','Angebot erstellen','DETAILS','details invoice','[0]','_popup_'),(12,'book','viewBook','Buch anzeigen','OCRM_BOOK','details book','[0]','_popup_');
/*!40000 ALTER TABLE `os_functions` ENABLE KEYS */;
UNLOCK TABLES;

-- Dump completed on 2020-05-15  8:31:28
