-- MySQL dump 10.18  Distrib 10.3.27-MariaDB, for debian-linux-gnueabihf (armv8l)
--
-- Host: localhost    Database: ocrm
-- ------------------------------------------------------
-- Server version	10.3.27-MariaDB-0+deb10u1

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
  `id_ocrm_identity` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_ocrm_customers`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `expensepaid` date DEFAULT NULL,
  `id_ocrm_identity` int(11) DEFAULT NULL,
  `expensetype` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id_ocrm_expenses`)
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ocrm_identity`
--

DROP TABLE IF EXISTS `ocrm_identity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_identity` (
  `id_ocrm_identity` int(11) NOT NULL AUTO_INCREMENT,
  `changedat` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `changedby` varchar(40) DEFAULT NULL,
  `code` varchar(8) DEFAULT replace(replace(replace(ucase(left(to_base64(unhex(sha(concat(current_timestamp(),rand())))),8)),'/','1'),'+','2'),'=','3'),
  `id_ocrm_customers` int(11) DEFAULT NULL,
  `id_ocrm_processes` int(11) DEFAULT NULL,
  `id_ocrm_expenses` int(11) DEFAULT NULL,
  `id_ocrm_revenues` int(11) DEFAULT NULL,
  `id_ocrm_invoices` int(11) DEFAULT NULL,
  `id_ocrm_proposals` int(11) DEFAULT NULL,
  `idname` varchar(60) DEFAULT NULL,
  `idstreet` varchar(60) DEFAULT NULL,
  `idpostcode` int(11) DEFAULT NULL,
  `idcity` varchar(60) DEFAULT NULL,
  `idtaxtype` varchar(8) DEFAULT 'Soll',
  `idtaxnr` varchar(20) DEFAULT NULL,
  `idvattaxnr` varchar(20) DEFAULT NULL,
  `idactive` varchar(8) DEFAULT 'nein',
  PRIMARY KEY (`id_ocrm_identity`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ocrm_identity_permissions`
--

DROP TABLE IF EXISTS `ocrm_identity_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_identity_permissions` (
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
-- Table structure for table `ocrm_identity_references`
--

DROP TABLE IF EXISTS `ocrm_identity_references`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocrm_identity_references` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `referencetag` varchar(40) DEFAULT NULL,
  `depends_on_key` varchar(80) DEFAULT NULL,
  `depends_on_value` varchar(80) DEFAULT NULL,
  `allowed_values` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `invoicepaid` date DEFAULT NULL,
  `id_ocrm_identity` int(11) DEFAULT NULL,
  `invoicedetailed` varchar(8) DEFAULT 'ja',
  PRIMARY KEY (`id_ocrm_invoices`)
) ENGINE=InnoDB AUTO_INCREMENT=188 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `id_ocrm_identity` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_ocrm_processes`)
) ENGINE=InnoDB AUTO_INCREMENT=284 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `proposalamount` decimal(7,2) DEFAULT NULL,
  `proposalvat` decimal(7,2) DEFAULT NULL,
  `proposalaccepted` varchar(8) DEFAULT 'nein',
  `id_ocrm_identity` int(11) DEFAULT NULL,
  `proposaltext` text DEFAULT NULL,
  PRIMARY KEY (`id_ocrm_proposals`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `id_ocrm_identity` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_ocrm_revenues`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Insert ocrm default data
--

INSERT INTO `ocrm_customers_permissions` VALUES (1,'changedat','_none_',NULL,'TIMESTAMP','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(2,'changedby','_none_',NULL,'VARCHAR(40)','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(3,'code','Code',NULL,'VARCHAR(8)','ID','(REPLACE(REPLACE(REPLACE(upper(LEFT(to_base64(UNHEX(sha1(CONCAT(NOW(),RAND())))),8)),\'/\',\'1\'),\'+\',\'2\'),\'=\',\'3\'))',NULL,6,NULL,0,NULL,0,NULL),(4,'name','Firmenname',4.000,'VARCHAR(80)','TEXT',NULL,NULL,0,NULL,0,NULL,0,NULL),(5,'street','Straße und Hausnummer',5.000,'VARCHAR(80)','TEXT',NULL,NULL,0,NULL,0,NULL,0,NULL),(6,'postcode','PLZ',6.000,'INT','INTEGER',NULL,NULL,0,NULL,0,NULL,0,NULL),(7,'city','Stadt',7.000,'VARCHAR(40)','TEXT',NULL,NULL,0,NULL,0,NULL,0,NULL),(8,'contact','Ansprechpartner',8.000,'VARCHAR(80)','TEXT',NULL,NULL,0,NULL,0,NULL,0,NULL),(9,'phone','Telefon',9.000,'VARCHAR(20)','TEXT; MULTIPLE',NULL,NULL,0,NULL,0,NULL,0,NULL),(10,'commentary','Kommentar',10.000,'TEXT','EDITOR',NULL,NULL,0,NULL,0,NULL,0,NULL);
INSERT INTO `ocrm_customers_references` VALUES (1,'_none_',NULL,NULL,NULL);
INSERT INTO `ocrm_expenses_permissions` VALUES (1,'changedat','_none_',NULL,'TIMESTAMP','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(2,'changedby','_none_',NULL,'VARCHAR(40)','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(3,'code','Code',NULL,'VARCHAR(8)','ID','(REPLACE(REPLACE(REPLACE(upper(LEFT(to_base64(UNHEX(sha1(CONCAT(NOW(),RAND())))),8)),\'/\',\'1\'),\'+\',\'2\'),\'=\',\'3\'))',NULL,6,NULL,0,NULL,0,NULL),(4,'expensename','Zweck',4.000,'TEXT','TEXT',NULL,NULL,0,NULL,0,NULL,0,NULL),(5,'expensecost','Preis',5.000,'DECIMAL(7,2)','FLOAT',NULL,NULL,0,NULL,0,NULL,0,NULL),(6,'expensevat','inkl. MwSt.',6.000,'DECIMAL(7,2)','FLOAT',NULL,NULL,0,NULL,0,NULL,0,NULL),(7,'expensedate','Datum',7.000,'DATE','DATE','(NOW())',NULL,0,NULL,0,NULL,0,NULL);
INSERT INTO `ocrm_expenses_references` VALUES (1,'_none_',NULL,NULL,NULL);
INSERT INTO `ocrm_invoices_permissions` VALUES (1,'changedat','_none_',NULL,'TIMESTAMP','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(2,'changedby','_none_',NULL,'VARCHAR(40)','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(3,'code','Code',NULL,'VARCHAR(8)','ID','(REPLACE(REPLACE(REPLACE(upper(LEFT(to_base64(UNHEX(sha1(CONCAT(NOW(),RAND())))),8)),\'/\',\'1\'),\'+\',\'2\'),\'=\',\'3\'))',NULL,6,NULL,0,NULL,0,NULL),(4,'invoicedate','Datum',4.000,'DATE','DATE','(NOW())',NULL,0,NULL,0,NULL,0,NULL),(5,'invoicefinished','Rechnung erstellt?',5.000,'VARCHAR(8)','LIST','\'nein\'','_invoicefinished',0,NULL,0,NULL,0,NULL),(6,'invoicevatrate','MwSt-Satz',4.500,'DECIMAL(4,2)','LIST','\'19.00\'','_invoicevat',0,NULL,0,NULL,0,NULL),(7,'invoicename','Bezeichnung (intern)',3.500,'VARCHAR(40)','TEXT',NULL,NULL,0,NULL,0,NULL,0,NULL),(9,'invoicenumber','Rechnungsnummer',9.000,'VARCHAR(20)','LIST',NULL,'_invoiceempty',0,NULL,0,NULL,0,NULL),(10,'invoiceamount','Rechnungsbetrag (inkl. MwSt)',10.000,'DECIMAL(7,2)','FLOAT',NULL,'_invoiceempty',0,NULL,0,NULL,0,NULL),(11,'invoicevat','davon MwSt',11.000,'DECIMAL(7,2)','FLOAT',NULL,'_invoiceempty',0,NULL,0,NULL,0,NULL),(12,'invoicetarget','Zahlungsziel (Tage)',6.000,'INT','INTEGER','30',NULL,0,NULL,0,NULL,0,NULL);
INSERT INTO `ocrm_invoices_references` VALUES (1,'_none_',NULL,NULL,NULL),(2,'_invoicefinished',NULL,NULL,'[\"\",\"ja\",\"nein\"]'),(3,'_invoicevat',NULL,NULL,'[\"\",\"7.00\",\"19.00\"]'),(4,'_invoiceempty',NULL,NULL,'[\"\"]');
INSERT INTO `ocrm_processes_permissions` VALUES (1,'changedat','_none_',NULL,'TIMESTAMP','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(2,'changedby','_none_',NULL,'VARCHAR(40)','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(3,'code','Code',NULL,'VARCHAR(8)','ID','(REPLACE(REPLACE(REPLACE(upper(LEFT(to_base64(UNHEX(sha1(CONCAT(NOW(),RAND())))),8)),\'/\',\'1\'),\'+\',\'2\'),\'=\',\'3\'))',NULL,6,NULL,0,NULL,0,NULL),(5,'processbegin','Leistungs-/Lieferbeginn',5.000,'DATETIME','DATETIME','(NOW())',NULL,0,NULL,0,NULL,0,NULL),(6,'processend','Leistungs-/Lieferende',6.000,'DATETIME','DATETIME','(NOW())',NULL,0,NULL,0,NULL,0,NULL),(7,'processunit','Einheit',7.000,'VARCHAR(8)','LIST','\'h\'','_processunit',0,NULL,0,NULL,0,NULL),(8,'processrate','Preis pro Einheit',8.000,'DECIMAL(7,2)','EXTENSIBLE LIST',NULL,'_processrate',0,NULL,0,NULL,0,NULL),(9,'processdetails','Details',9.000,'TEXT','FREE',NULL,NULL,0,NULL,0,NULL,0,NULL),(11,'processtype','Typ',4.000,'VARCHAR(40)','LIST','\'Support\'','_processtype',0,NULL,0,NULL,0,NULL),(14,'processvatrate','Mwst-Satz',8.500,'DECIMAL(4,2)','LIST','\'19.00\'','_processvatrate',0,NULL,0,NULL,0,NULL),(15,'processunits','Anzahl',7.500,'DECIMAL(4,2)','FLOAT',NULL,NULL,0,NULL,0,NULL,0,NULL);
INSERT INTO `ocrm_processes_references` VALUES (1,'_none_',NULL,NULL,NULL),(2,'_processtype',NULL,NULL,'[\"Beratung\",\"Hardwarekauf\",\"Betriebssysteme/eingebettete Systeme\",\"Netzwerk\",\"Programmierung\",\"Software-Installation inkl. OS\",\"Webinhalte\",\"Support\"]'),(3,'_processunit','processtype','Beratung','[\"1\",\"h\"]'),(4,'_processunit','processtype','Hardwarekauf','[\"1\"]'),(5,'_processunit','processtype','Betriebssysteme/eingebettete Systeme','[\"1\",\"h\"]'),(6,'_processunit','processtype','Netzwerk','[\"h\"]'),(7,'_processunit','processtype','Programmierung','[\"1\",\"h\"]'),(8,'_processunit','processtype','Software-Installation inkl. OS','[\"1\",\"h\"]'),(9,'_processunit','processtyoe','Webinhalte','[\"1\",\"h\"]'),(10,'_processunit','processtype','Support','[\"h\"]'),(11,'_processrate',NULL,NULL,'[\"25.00\",\"34.30\",\"39.00\",\"49.00\",\"69.00\",\"89.00\"]'),(12,'_processvatrate',NULL,NULL,'[\"\",\"7.00\",\"19.00\"]');
INSERT INTO `ocrm_proposals_permissions` VALUES (1,'changedat','_none_',NULL,'TIMESTAMP','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(2,'changedby','_none_',NULL,'VARCHAR(40)','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(3,'code','Code',NULL,'VARCHAR(8)','ID','(REPLACE(REPLACE(REPLACE(upper(LEFT(to_base64(UNHEX(sha1(CONCAT(NOW(),RAND())))),8)),\'/\',\'1\'),\'+\',\'2\'),\'=\',\'3\'))',NULL,6,NULL,0,NULL,0,NULL),(4,'proposalname','Bezeichnung (intern)',4.000,'VARCHAR(40)','TEXT',NULL,NULL,0,NULL,0,NULL,0,NULL),(5,'proposaldate','Datum',5.000,'DATE','DATE','(NOW())',NULL,0,NULL,0,NULL,0,NULL),(6,'proposalvatrate','MwSt.-Satz',6.000,'DECIMAL(4,2)','LIST','\'19.00\'','_proposalvatrate',0,NULL,0,NULL,0,NULL),(7,'proposalfinished','Angebot erstellt?',7.000,'VARCHAR(8)','LIST','\'nein\'','_proposalfinished',0,NULL,0,NULL,0,NULL),(8,'proposalnumber','Angebotsnummer',8.000,'VARCHAR(20)','LIST',NULL,'_proposalempty',0,NULL,0,NULL,0,NULL);
INSERT INTO `ocrm_proposals_references` VALUES (1,'_none_',NULL,NULL,NULL),(2,'_proposalvatrate',NULL,NULL,'[\"\",\"7.00\",\"19.00\"]'),(3,'_proposalfinished',NULL,NULL,'[\"\",\"ja\",\"nein\"]'),(4,'_proposalempty',NULL,NULL,'[\"\"]');
INSERT INTO `ocrm_revenues_permissions` VALUES (1,'changedat','_none_',NULL,'TIMESTAMP','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(2,'changedby','_none_',NULL,'VARCHAR(40)','NONE',NULL,'_none_',0,NULL,0,NULL,0,NULL),(3,'code','Code',NULL,'VARCHAR(8)','ID','(REPLACE(REPLACE(REPLACE(upper(LEFT(to_base64(UNHEX(sha1(CONCAT(NOW(),RAND())))),8)),\'/\',\'1\'),\'+\',\'2\'),\'=\',\'3\'))',NULL,6,NULL,0,NULL,0,NULL),(4,'revenuename','Grund',4.000,'VARCHAR(40)','TEXT',NULL,NULL,0,NULL,0,NULL,0,NULL),(5,'revenuedate','Datum',5.000,'DATE','DATE','(NOW())',NULL,0,NULL,0,NULL,0,NULL),(6,'revenueamount','Betrag',6.000,'DECIMAL(7,2)','FLOAT',NULL,NULL,0,NULL,0,NULL,0,NULL),(7,'revenuevat','inkl. MwSt.',7.000,'DECIMAL(7,2)','FLOAT',NULL,NULL,0,NULL,0,NULL,0,NULL);
INSERT INTO `ocrm_revenues_references` VALUES (1,'_none_',NULL,NULL,NULL);
INSERT INTO `os_tables` VALUES (NULL,'building','ocrm_customers','Kunden','[6]','[6]',NULL,NULL),(NULL,'hammer','ocrm_processes','Tätigkeiten','[6]','[6]',NULL,NULL),(NULL,'shopping-cart','ocrm_expenses','Ausgaben','[6]','[6]',NULL,NULL),(NULL,'money-bill-wave','ocrm_revenues','Einnahmen','[6]','[6]','[\"ocrm_invoices__invoicedate\",\"ocrm_invoices__invoiceamount\"]',NULL),(NULL,'comment-dollar','ocrm_invoices','Rechnungen','[6]','[6]','[\"ocrm_revenues__revenuedate\",\"ocrm_revenues__revenueamount\"]',NULL),(NULL,'bullhorn','ocrm_proposals','Angebote','[6]','[6]',NULL,NULL),(NULL,'address-card','ocrm_identity','Identität','[6]',NULL,NULL,NULL);
INSERT INTO `os_functions` VALUES (NULL,'receipt','createInvoice','Rechnung erstellen','DETAILS','details invoice','[0]','_popup_',NULL),(NULL,'user-tie','createProposal','Angebot erstellen','DETAILS','details invoice','[0]','_popup_',NULL),(NULL,'book','viewBook','Buch anzeigen','TABLES','details book','[0]','_popup_',NULL);

-- Dump completed on 2022-03-14 13:05:37
