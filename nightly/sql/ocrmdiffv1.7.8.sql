-- Messages in invoices
ALTER TABLE `ocrm_invoices` ADD COLUMN `invoicemessage` TEXT DEFAULT NULL;
INSERT  INTO `ocrm_invoices_permissions` (`keymachine`,`keyreadable`,`realid`,`typelist`,`edittype`) VALUES ('invoicemessage','Nachricht','18','TEXT','EDITOR');
