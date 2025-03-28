-- openStatAdmin-log started 25.03.2025 09:40:13
ALTER TABLE `ocrm_identity` ADD COLUMN IF NOT EXISTS `idduns` VARCHAR(10);
INSERT  INTO `ocrm_identity_permissions` (`keymachine`,`keyreadable`,`typelist`,`edittype`,`role_0`) VALUES ('idduns','DUNS','VARCHAR(10)','TEXT','0');
-- openStatAdmin-log finished 25.03.2025 09:44:15
-- openStatAdmin-log started 26.03.2025 16:10:45
ALTER TABLE `ocrm_invoices` ADD COLUMN IF NOT EXISTS `invoicecorrection` VARCHAR(20) DEFAULT NULL;
INSERT  INTO `ocrm_invoices_permissions` (`keymachine`,`keyreadable`,`realid`,`typelist`,`edittype`,`role_0`) VALUES ('invoicecorrection','korrigiert','9.2','VARCHAR(20)','TEXT','0');
-- openStatAdmin-log finished 26.03.2025 16:14:04
