<?php 
// dependencies: php7.3-zip? Not for HTML version
function localFormat($number) { return number_format((float)$number,2,",","."); }
//function inTegers($number) { return number_format((float)$number,0,",","."); }
function inCents($number) { return round((float)$number,2); }
function inTegers($number) { return round((float)$number); }

//scope: DETAILS
function createInvoice(array $PARAM, mysqli $conn)
{
	//determine intended invoice
	$PARAM2 = json_decode(json_encode($PARAM),true);
	foreach ( $PARAM as $key=>$value) {
		if ( isset($PARAM2['id_ocrm_invoices']) AND $PARAM2['id_ocrm_invoices'] != '' ) { break; };
		if ( substr($key,0,3) != 'id_' ) { continue; }
		$_giventable = substr($key,3);
		unset($_stmt_array); $_stmt_array = array();
		$_stmt_array['stmt'] = 'SELECT id_ocrm_invoices from view__'.$_giventable.'__'.$_SESSION['os_role'].' WHERE id_'.$_giventable.' = ?';
		$_stmt_array['str_types'] = 'i';
		$_stmt_array['arr_values'] = array($value);
		$PARAM2 = execute_stmt($_stmt_array,$conn,true)['result'][0];
		$PARAM2[$key] = $value; //do not forget where we came from
	}	
	$PARAM = json_decode(json_encode($PARAM2),true);
	if ( ! isset($PARAM['id_ocrm_invoices']) OR $PARAM['id_ocrm_invoices'] == '' ) {
		echo("<label><i class=\"fas fa-exclamation-triangle\"></i></label>Der Eintrag ist keiner Rechnung zugeordnet."); return; 
	}
	//get invoice data
	unset($_stmt_array); $_stmt_array = array(); unset($_table_result);
	$_stmt_array['stmt'] = 'SELECT * from view__ocrm_invoices__'.$_SESSION['os_role'].' WHERE id_ocrm_invoices = ?';
	$_stmt_array['str_types'] = 'i';
	$_stmt_array['arr_values'] = array($PARAM['id_ocrm_invoices']);
	$PARAMETER = execute_stmt($_stmt_array,$conn,true)['result'][0];
	//32 second intervals in the current year (so we get only 7 digits)
	$invno = round((time()-strtotime((new DateTime())::createFromFormat('U',time())->format('Y').'-01-01 00:00'))/32);
	$invno = substr($invno,0,strlen($invno)-3).'-'.substr($invno,-3);
	//$PARAMETER is invoice parameters
	//header
	//get attributed customer
	unset($_stmt_array); $_stmt_array = array(); unset($_table_result);
	$_stmt_array['stmt'] = 'SELECT * from view__ocrm_customers__'.$_SESSION['os_role'].' WHERE id_ocrm_customers = ?';
	$_stmt_array['str_types'] = 'i';
	$_stmt_array['arr_values'] = array($PARAMETER['id_ocrm_customers']);
	$_customer_result = execute_stmt($_stmt_array,$conn,true)['result'][0];
	if ( ! isset($_customer_result) OR sizeof($_customer_result) == 0 ) { echo("<label><i class=\"fas fa-exclamation-triangle\"></i></label>Die Rechnung ist keinem Kunde zugeordnet."); return; }
	//get attributed processes
	unset($_stmt_array); $_stmt_array = array(); unset($_table_result);
	$_stmt_array['stmt'] = 'SELECT id_ocrm_processes, UNIX_TIMESTAMP(processbegin) AS processunixbegin, UNIX_TIMESTAMP(processend) AS processunixend, processunit, processunits, processrate, processdetails, processtype, processvatrate from view__ocrm_processes__'.$_SESSION['os_role'].' WHERE id_ocrm_invoices = ? ORDER BY processtype,processbegin';
	$_stmt_array['str_types'] = 'i';
	$_stmt_array['arr_values'] = array($PARAMETER['id_ocrm_invoices']);
	$_processes_result = execute_stmt($_stmt_array,$conn,true)['result'];
	if ( ! isset($_processes_result) OR sizeof($_processes_result) == 0 ) { echo("<label><i class=\"fas fa-exclamation-triangle\"></i></label>Zu der gewählten Rechnung gibt es keine Tätigkeiten."); return; }
	$_report = '';
	$_totalnet = array(); //keys are product types
	$_totalvat = array(); //keys are product types
	$_totalunits = array(); //keys are product types
	$_earliest = 9999999999;
	$_latest = 0;
	$_oldtype = '';
	$_processtable='';
	$_totalnetamount = array(); //keys are vatrates
	$_totalvatamount = array(); //keys are vatrates
    $_totalnetamounttotal = 0;
	$_currentheight = 100.0;
	$_reportheight = 10;
	$_nopages = 1;
	$_em = array(); $_slashem = array(); $_marked = array();

    //create XML in parallel
    $_invoicexmlstring = file_get_contents('../../core/xml/invoice_template.xml');
    $_invoicexml = new SimpleXMLElement($_invoicexmlstring);
    //register namespaces (see https://www.php.net/manual/en/simplexmlelement.xpath.php)
    foreach($_invoicexml->getDocNamespaces() as $strPrefix => $strNamespace) {
        if(strlen($strPrefix)==0) {
            $strPrefix="a"; //Assign an arbitrary namespace prefix.
        }
        $_invoicexml->registerXPathNamespace($strPrefix,$strNamespace);
    }
    $_sectionno = 0;
	foreach ( $_processes_result as $index=>$_process ) {
		$_pos = $index+1;
		$_earliest = min($_earliest,$_process['processunixbegin']);
		$_latest = max($_latest,$_process['processunixend']);
		if ( ! isset($_totalnet[$_process['processtype']]) ) { $_totalnet[$_process['processtype']] = 0; };
		if ( ! isset($_totalvat[$_process['processtype']]) ) { $_totalvat[$_process['processtype']] = array(); };
		if ( ! isset($_totalvat[$_process['processtype']][$_process['processvatrate']]) ) { $_totalvat[$_process['processtype']][$_process['processvatrate']] = 0; };
		if ( ! isset($_totalunits[$_process['processtype']]) ) { $_totalunits[$_process['processtype']] = array(); };
		if ( ! isset($_totalunits[$_process['processtype']][$_process['processunit']]) ) { $_totalunits[$_process['processtype']][$_process['processunit']] = 0; };
        if ( ! isset($_totalnetamount[$_process['processvatrate']]) ) { $_totalnetamount[$_process['processvatrate']] = 0; }
		//collect and sort info
		if ( (new DateTime())::createFromFormat('U',$_process['processunixbegin'])->format('d.m.Y') == (new DateTime())::createFromFormat('U',$_process['processunixend'])->format('d.m.Y') ) { $_dayend = ''; } else { $_dayend = 'd.m.Y '; };
		$_em[$index] = ''; $_slashem[$index] = '';
		if ( $_process['id_ocrm_processes'] == $PARAM['id_ocrm_processes'] ) { $_em[$index] = '<span class="marked">'; $_slashem[$index] = '</span>'; };
		$_reportpart = (new DateTime())::createFromFormat('U',$_process['processunixbegin'])->format('d.m.Y H:i').' - '.(new DateTime())::createFromFormat('U',$_process['processunixend'])->format($_dayend.'H:i').': '.$_process['processdetails'].'<br />';
		$_noreportlines = round(strlen($_reportpart)/105+0.5);
		$_reportheight += $_noreportlines*4.6;
		if ( $_reportheight > 260) { 
			$_report .= "
				</div>
				<div class=\"invoice_page invoicereport\">
			";
			$_reportheight = 5+$_nolines*4.6;
		}		
		$_report .= $_em[$index].$_reportpart.$_slashem[$index];
		switch($_process['processunit']) {
			case 'h':
				//compute if no value is given
				if ( $_process['processunits'] == '' ) { $_process['processunits'] = ( $_process['processunixend'] - $_process['processunixbegin'] )/3600; };
				//no break: the following has to be applied in any case
			default:
				$_process['total'] = inCents($_process['processunits'])*$_process['processrate'];
				$_totalunits[$_process['processtype']][$_process['processunit']] += inCents($_process['processunits']);
				$_totalnet[$_process['processtype']] += inCents($_process['total']);
				$_totalnetamount[$_process['processvatrate']] += inCents($_process['total']);
				$_totalvat[$_process['processtype']][$_process['processvatrate']] += (float)$_process['processvatrate']/100*inCents($_process['total']);
				break;
		}
		//count one line per 55 characters in "Tätigkeit"
		$_nolines = round(strlen($_process['processtype'].': '.$_process['processdetails'])/55+0.5);
		if ( $PARAMETER['invoicedetailed'] == "ja" ) { $_currentheight += $_nolines*4.6; }
		//check if we need new page
		if ( $_currentheight > 260) { 
			$_nopages += 1;
			$_processtable .= "
					</table>
				</div>
				<div class=\"invoice_page\">
					<div class=\"invoicepagenumber\">".$_nopages."</div>	
					<table>
						<thead>
							<tr><th>Pos.</th><th>Tätigkeit</th><th>Datum</th><th>Preis/Einheit</th><th>Einheiten</th><th>Preis</th></tr>
						</thead>
			";
			$_currentheight = 5+$_nolines*4.6;
		}
		//add to table
		$_marked[$index] = '';
		if ( $_process['id_ocrm_processes'] == $PARAM['id_ocrm_processes'] ) { $_marked[$index] = 'marked'; };
		if ( $PARAMETER['invoicedetailed'] == "ja" ) {
            $_processtable .= '<tr class="'.$_marked[$index].'"><td>'.$_pos.'</td><td class="justify">'.$_process['processtype'].': '.$_process['processdetails'].'</td><td>'.(new DateTime())::createFromFormat('U',$_process['processunixend'])->format('d.m.Y').'</td><td>'.localFormat($_process['processrate']).'</td><td>'.localFormat(inCents($_process['processunits'])).str_replace('1','',$_process['processunit']).'</td><td>'.localFormat(inCents($_process['total'])).'</td></tr>';
            //xml part:
            $ISCT = $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction')->addChild('ram:IncludedSupplyChainTradeLineItem');
                $ADLD = $ISCT->addChild('ram:AssociatedDocumentLineDocument');
                    $ADLD->addChild('ram:LineID',$_pos);
                $STP = $ICST->addChild('ram:SpecifiedTradeProduct');
                    $STP->addChild('ram:SellerAsignedID');
                    $STP->addChild('ram:Name',$_process['processtype'].': '.$_process['processdetails']);
                $SLTA = $ICST->addChild('ram:SpecifiedLineTradeAgreement');
                    $NPPTP = $SLTA->addChild('ram:NetPriceProductTradePrice');
                        $NPPTP->addChild('ram:ChargeAmount',$_process['processrate']);
                    $GPPTP = $SLTA->addChild('ram:GrossPriceProductTradePrice');
                        $GPPTP->addChild('ram:ChargeAmount',$_process['processrate']+(float)$_process['processvatrate']/100*$_process['processrate']);
                $SLTD = $ICST->addChild('ram:SpecifiedLineTradeDelivery');
                    $BQ = $SLTD->addChild('ram:BilledQuantity',$_process['processunits']);
                    if ( $_process['processunit'] == 1 ) {
                        $BQ->addAttribute('unitCode','H87');
                    }
                    if ( $_process['processunit'] == 'h' ) {
                        $BQ->addAttribute('unitCode','LH');
                    }
                $SLTS = $ICST->addChild('ram:SpecifiedLineTradeSettlement');
                if ( (float)$PARAMETER['invoicevat'] > 0 ) {
                    $ATT = $SLTS->addChild('ram:ApplicableTradeTax');
                    $ATT->addChild('ram:TypeCode','VAT');
                    $ATT->addChild('ram:CategoryCode','S');
                    $ATT->addChild('ram:RateApplicablePercent',inCent($_process['processvatrate']));
                }
                    $STSLMS = $SLTS->addChild('ram:SpecifiedTradeSettlementLineMonetarySummation');
                        $STSLMS->addChild('ram:LineTotalAmount',inCents($_process['total']));
        }
		if ( ! isset($_processes_result[$_pos]) OR $_processes_result[$_pos]['processtype'] != $_process['processtype'] ) {
            $_sectionno += 1;
			$oldtype = $_process['processtype'];
			//count one line per 55 characters in "Tätigkeit"
			$_currentheight += 9.2;
			$_processtable .= '<tr><th>&nbsp;</th><th>'.$oldtype.'</th><th>&nbsp;</th><th>&nbsp;</th><th>'.inTegers($_totalunits[$oldtype]['1']).' | '.localFormat(inCents($_totalunits[$oldtype]['h'])).'h</th><th>'.localFormat(inCents($_totalnet[$oldtype])).'</th></tr><tr><td>&nbsp;</td></tr>';
            //xml part:
            if ( $PARAMETER['invoicedetailed'] == "nein" ) {
                $ISCT = $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction')->addChild('ram:IncludedSupplyChainTradeLineItem');
                    $ADLD = $ISCT->addChild('ram:AssociatedDocumentLineDocument');
                        $ADLD->addChild('ram:LineID',$_sectionno);
                    $STP = $ICST->addChild('ram:SpecifiedTradeProduct');
                        $STP->addChild('ram:SellerAsignedID');
                        $STP->addChild('ram:Name',$_oldtype);
                    $SLTA = $ICST->addChild('ram:SpecifiedLineTradeAgreement');
                        $NPPTP = $SLTA->addChild('ram:NetPriceProductTradePrice');
                            if ( $_totalunits[$oldtype]['1']*$_totalunits[$oldtype]['h'] == 0 ) {
                                $_units = max($_totalunits[$oldtype]['1']*$_totalunits[$oldtype]['h']);
                                if ( $_totalunits[$oldtype]['1'] > 0 ) { $_unit = 'H87'; } else { $_unit = 'LH'; }
                                $_productprice = $_totalnet[$_oldtype]/$_units; 
                            }
                            $NPPTP->addChild('ram:ChargeAmount',$_productprice);
                        $GPPTP = $SLTA->addChild('ram:GrossPriceProductTradePrice');
                            $GPPTP->addChild('ram:ChargeAmount',$_productprice+(float)$_process['processvatrate']/100*$_productprice);
                    $SLTD = $ICST->addChild('ram:SpecifiedLineTradeDelivery');
                        $BQ = $SLTD->addChild('ram:BilledQuantity',$_units);
                        $BQ->addAttribute('unitCode',$_unit);
                    $SLTS = $ICST->addChild('ram:SpecifiedLineTradeSettlement');
                    if ( (float)$PARAMETER['invoicevat'] > 0 ) {
                        $ATT = $SLTS->addChild('ram:ApplicableTradeTax');
                        $ATT->addChild('ram:TypeCode','VAT');
                        $ATT->addChild('ram:CategoryCode','S');
                        $ATT->addChild('ram:RateApplicablePercent',inCents($_process['processvatrate']));
                    }
                        $STSLMS = $SLTS->addChild('ram:SpecifiedTradeSettlementLineMonetarySummation');
                            $STSLMS->addChild('ram:LineTotalAmount',inCents($_totalnet[$_oldtype]));
            } 
		};
	}
	foreach ($_totalnetamount as $_partialnet ) { $_totalnetamounttotal += $_partialnet; }
	foreach ($_totalvat as $_partialvat ) { 
		foreach ($_partialvat as $vatrate=>$partialvatrate) {
			if ( ! isset($_totalvatamount[$vatrate]) ) { $_totalvatamount[$vatrate] = $partialvatrate; } else { $_totalvatamount[$vatrate] += $partialvatrate; }
		}
	}
	if ( $_currentheight > 230) { 
		$_nopages += 1;
		$_processtable .= "
				</table>
			</div>
			<div class=\"invoice_page\">
				<div class=\"invoicepagenumber\">".$_nopages."</div>	
				<table>
					<thead>
						<tr><th>Pos.</th><th>Tätigkeit</th><th>Datum</th><th>Preis/Einheit</th><th>Einheiten</th><th>Preis</th></tr>
					</thead>
		";
		if ( $PARAMETER['invoicedetailed'] == "ja" ) { $_currentheight = 5+$_nolines*4.6; } else { $_currentheight = 5; }
	}
    //do not show any vat if invoicevat = 0 ("Kleinunternhemerregelung")
    if ( (float)$PARAMETER['invoicevat'] > 0 ) {
        $_processtable .= '<tr><th>&nbsp;</th><th>&nbsp;</th><th>&nbsp;</th><th>&nbsp;</th><th>Netto</th><th>'.localFormat(inCents($_totalnetamounttotal)).'</th></tr>';
        $_totalgrossamount = $_totalnetamounttotal;
        foreach ($_totalvatamount as $vatrate=>$partialvatamount ) {
            $_processtable .= '<tr><th>&nbsp;</th><th>&nbsp;</th><th>&nbsp;</th><th>&nbsp;</th><th>MwSt '.$vatrate.'%</th><th>'.localFormat(inCents($partialvatamount)).'</th></tr>';
            $_totalgrossamount += $partialvatamount;
            //xml part
            $ATT = $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement')[0]->addChild('ram:ApplicableTradeTax');
            $ATT->addChild('ram:CalculatedAmount',$partialvatamount);
            $ATT->addChild('ram:TypeCode','VAT');
            $ATT->addChild('ram:BasisAmount',$_totalnetamount[$vatrate]);
            $ATT->addChild('ram:CategoryCode','S');
            $ATT->addChild('ram:RateApplicablePercent',$vatrate);
        }
        $_processtable .= '<tr><th>&nbsp;</th><th>&nbsp;</th><th>&nbsp;</th><th>&nbsp;</th><th>Gesamt</th><th>'.localFormat(inCents($_totalgrossamount)).'</th></tr>';
    } else {
        $_processtable .= '<tr><th>&nbsp;</th><th>&nbsp;</th><th>&nbsp;</th><th>&nbsp;</th><th>Gesamt</th><th>'.localFormat(inCents($_totalnetamounttotal)).'</th></tr>';
        $_totalgrossamount = $_totalnetamounttotal;
    }
	//test if inovice has already been finished and changed
	$_copy = '';
	if ( $PARAMETER['invoicefinished'] == "ja" ) {
		if ( $PARAMETER['invoiceamount'] != (string)inCents($_totalgrossamount) OR $PARAMETER['invoicevat'] != (string)(inCents($_totalgrossamount)-inCents($_totalnetamounttotal)) ) {
			echo("<label><i class=\"fas fa-exclamation-triangle\"></i></label>Die Rechnung wurde nach Erstellung geändert. Wenn die Änderungen legitim sind, ändern Sie den Status der Rechnung auf unerstellt und erstellen Sie sie erneut."); return; 
		} else {
			$_copy = " - Kopie";
		}
	} else {
		$PARAMETER['invoicenumber'] = $PARAMETER['id_ocrm_invoices'].'R'.$invno;
		unset($_stmt_array); $_stmt_array = array(); unset($_table_result);
		$_stmt_array['stmt'] = "UPDATE view__ocrm_invoices__".$_SESSION['os_role']." SET invoicefinished='ja', invoicenumber=?, invoiceamount=?, invoicevat=? WHERE id_ocrm_invoices = ?";
		$_stmt_array['str_types'] = 'sssi';
		$_stmt_array['arr_values'] = array();
		$_stmt_array['arr_values'][] = (string)$PARAMETER['invoicenumber'];
		$_stmt_array['arr_values'][] = (string)inCents($_totalgrossamount);
		$_stmt_array['arr_values'][] = (string)(inCents($_totalgrossamount)-inCents($_totalnetamounttotal));
		$_stmt_array['arr_values'][] = $PARAMETER['id_ocrm_invoices'];
		_execute_stmt($_stmt_array,$conn);
	}
	//get (first) active id
	unset($_stmt_array); $_stmt_array = array(); unset($_table_result);
	$_stmt_array['stmt'] = "SELECT * from view__ocrm_identity__".$_SESSION['os_role']." WHERE idactive = 'ja';";
	$_myid = execute_stmt($_stmt_array,$conn,true)['result'][0];
    //set header fields
    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID')[0][0] = $PARAMETER['invoicenumber'];
    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString')[0][0] = (new DateTime($PARAMETER['invoicedate']))->format('Ymd');
    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:Content')[0][0] = $PARAMETER['invoicemessage'];
    if ( (float)$PARAMETER['invoicevat'] == 0 ) {
        $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:Content')[0][0] .= " Als Kleinunternehmen nach § 19 Abs. 1 UStG weist ".$_myid['name']." keine Umsatzsteuer aus.";
    }
    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:Content')[1][0] = $_myid['idname'].PHP_EOL.$_myid['idstreet'].PHP_EOL.$_myid['idpostcode'].' '.$_myid['idcity'].PHP_EOL.'USt-ID: '.$_myid['idvattaxnr'];

    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID')[0][0] = $_myid['idduns'];
    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:Name')[0][0] = $_myid['idname'];
    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode')[0][0] = $_myid['idpostcode'];
    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:LineOne')[0][0] = $_myid['idstreet'];
    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CityName')[0][0] = $_myid['idcity'];
    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID')[0][0] = $_myid['idvattaxnr'];

    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:ID')[0][0] = $_customer_result['code'];
    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:Name')[0][0] = $_customer_result['name'];
    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode')[0][0] = $_customer_result['postcode'];
    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:LineOne')[0][0] = $_customer_result['street'];
    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CityName')[0][0] = $_customer_result['city'];

    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/ram:DateTimeString')[0][0] = (new DateTime())::createFromFormat('U',$_latest)->format('Ymd');
    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/ram:DateTimeString')[0][0] = (new DateTime($PARAMETER['invoicedate']))->modify('+'.$PARAMETER['invoicetarget'].' days')->format('Ymd');

    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:LineTotalAmount')[0][0] = $_totalnetamounttotal;
    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount')[0][0] = $_totalnetamounttotal;
    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount')[0][0] = $_totalgrossamount-$_totalnetamounttotal;
    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount')[0][0] = $_totalgrossamount;
    $_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:DuePayableAmount')[0][0] = $_totalgrossamount;

    if ( (float)$PARAMETER['invoicevat'] == 0 ) {
        unset($_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount')[0]);
        unset($_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount')[0]);
        unset($_invoicexml->xpath('/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount')[0]);
    }
	?>
    <script type="text/javascript" src="/js/ocrm.js"></script>
    <img hidden src="" onerror="exportXMLBase64('<?php echo($PARAMETER['invoicenumber']); ?>',null,'<?php base64_encode($_invoicexml->asXML()); ?>')"> 
	<link rel="stylesheet" type="text/css" href="/css/ocrm_invoice.css">
	<?php includeFunctions('DETAILS',$conn); ?>	
	<form class="db_options function" method="POST" action="" onsubmit="callFunction(this,'dbAction','message'); return false;">
		<input type="text" hidden value="<?php html_echo($PARAMETER['id_ocrm_invoices']); ?>" name="id_ocrm_invoices" class="inputid" />
	</form>
	<div class="invoice_wrapper">
		<div class="invoiceheader">
			<div class="invoicecc"></div>
			<div class="invoiceaddress">
				<div class="myidentity"><?php echo($_myid['idname'].' | '.$_myid['idstreet'].' | '.$_myid['idpostcode'].' '.$_myid['idcity']); ?></div>
				<div class="invoicename"><?php html_echo($_customer_result['name']); ?></div>
				<div class="invoicecontact"><?php html_echo($_customer_result['contact']); ?></div>
				<div class="invoicestreet"><?php html_echo($_customer_result['street']); ?></div>
				<div class="invoicecity"><?php html_echo($_customer_result['postcode'].' '.$_customer_result['city']); ?></div>
			</div>
			<div class="invoicedata">
				<table>
				<tr><td>Rechnungsnummer</td><td><?php echo($PARAMETER['invoicenumber']); ?></td></tr>
				<tr><td>Auftragssnummer</td><td><?php echo($PARAMETER['id_ocrm_proposals']); ?></td></tr>
				<tr><td>Datum</td><td><?php echo((new DateTime($PARAMETER['invoicedate']))->format('d.m.Y')); ?></td></tr>
				<tr><td>Kundennummer</td><td><?php echo($_customer_result['code']); ?></td></tr>
				<tr><td>Leistungs-/Lieferdatum</td><td><?php echo((new DateTime())::createFromFormat('U',$_earliest)->format('d.m.Y').' - '.(new DateTime())::createFromFormat('U',$_latest)->format('d.m.Y')); ?></td></tr>
				<tr><td>Seite</td><td>1/<?php echo($_nopages); ?></td></tr>
				</table>
			</div>
		</div> <!-- end of invoiceheader -->
		<h2>Rechnung<?php echo($_copy); ?></h2>
		<table>
			<thead>
				<tr><th>Pos.</th><th>Tätigkeit</th><th>Datum</th><th>Preis/Einheit</th><th>Einheiten</th><th>Preis</th></tr>
			</thead>
			<?php echo($_processtable); ?>
		</table>
        <?php if ( (float)$PARAMETER['invoicevat'] == 0 ) { ?>
		<div>Als Kleinunternehmen nach § 19 Abs. 1 UStG weist <?php echo($_myid['name']); ?> keine Umsatzsteuer aus.</div>
        <?php } ?>
		<div>Bitte überweisen Sie den Rechnungsbetrag von <strong><?php echo(localFormat(inCents($_totalgrossamount))); ?> €</strong> bis <strong><?php echo((new DateTime($PARAMETER['invoicedate']))->modify('+'.$PARAMETER['invoicetarget'].' days')->format('d.m.Y')); ?></strong> unter Angabe der Rechnungsnummer.</div>
		<div><?php echo($PARAMETER['invoicemessage']); ?></div>
	</div> <!-- end of invoice_wrapper -->
	<div class="invoice_page invoicereport">
		<h3>Arbeitsbericht</h3>
	<?php echo($_report); ?>
	</div>
<?php }

//scope: DETAILS
function createProposal(array $PARAM, mysqli $conn)
{
	//determine intended proposal
	$PARAM2 = json_decode(json_encode($PARAM),true);
	foreach ( $PARAM as $key=>$value) {
		if ( isset($PARAM2['id_ocrm_proposals']) AND $PARAM2['id_ocrm_proposals'] != '' ) { break; };
		if ( substr($key,0,3) != 'id_' ) { continue; }
		$_giventable = substr($key,3);
		unset($_stmt_array); $_stmt_array = array();
		$_stmt_array['stmt'] = 'SELECT id_ocrm_proposals from view__'.$_giventable.'__'.$_SESSION['os_role'].' WHERE id_'.$_giventable.' = ?';
		$_stmt_array['str_types'] = 'i';
		$_stmt_array['arr_values'] = array($value);
		$PARAM2 = execute_stmt($_stmt_array,$conn,true)['result'][0];
		$PARAM2[$key] = $value; //do not forget where we came from
	}	
	$PARAM = json_decode(json_encode($PARAM2),true);
	if ( ! isset($PARAM['id_ocrm_proposals']) OR $PARAM['id_ocrm_proposals'] == '' ) {
		echo("<label><i class=\"fas fa-exclamation-triangle\"></i></label>Der Eintrag ist keinem Angebot zugeordnet."); return; 
	}
	//get proposal data
	unset($_stmt_array); $_stmt_array = array(); unset($_table_result);
	$_stmt_array['stmt'] = 'SELECT * from view__ocrm_proposals__'.$_SESSION['os_role'].' WHERE id_ocrm_proposals = ?';
	$_stmt_array['str_types'] = 'i';
	$_stmt_array['arr_values'] = array($PARAM['id_ocrm_proposals']);
	$PARAMETER = execute_stmt($_stmt_array,$conn,true)['result'][0];
	//32 second intervals in the current year (so we get only 7 digits)
	$invno = round((time()-strtotime((new DateTime())::createFromFormat('U',time())->format('Y').'-01-01 00:00'))/32);
	$invno = substr($invno,0,strlen($invno)-3).'-'.substr($invno,-3);
	//$PARAMETER is proposal parameters
	//header
	//get attributed customer
	unset($_stmt_array); $_stmt_array = array(); unset($_table_result);
	$_stmt_array['stmt'] = 'SELECT * from view__ocrm_customers__'.$_SESSION['os_role'].' WHERE id_ocrm_customers = ?';
	$_stmt_array['str_types'] = 'i';
	$_stmt_array['arr_values'] = array($PARAMETER['id_ocrm_customers']);
	$_customer_result = execute_stmt($_stmt_array,$conn,true)['result'][0];
	if ( ! isset($_customer_result) OR sizeof($_customer_result) == 0 ) { echo("<label><i class=\"fas fa-exclamation-triangle\"></i></label>Das Angebot ist keinem Kunde zugeordnet."); return; }
	//get attributed processes
	unset($_stmt_array); $_stmt_array = array(); unset($_table_result);
	$_stmt_array['stmt'] = 'SELECT id_ocrm_processes, UNIX_TIMESTAMP(processbegin) AS processunixbegin, UNIX_TIMESTAMP(processend) AS processunixend, processunit, processunits, processrate, processdetails, processtype, processvatrate from view__ocrm_processes__'.$_SESSION['os_role'].' WHERE id_ocrm_proposals = ? ORDER BY processtype,processbegin';
	$_stmt_array['str_types'] = 'i';
	$_stmt_array['arr_values'] = array($PARAMETER['id_ocrm_proposals']);
	$_processes_result = execute_stmt($_stmt_array,$conn,true)['result'];
	if ( ! isset($_processes_result) OR sizeof($_processes_result) == 0 ) { echo("<label><i class=\"fas fa-exclamation-triangle\"></i></label>Zum gewählten Angebot gibt es keine Tätigkeiten."); return; }
	$_report = '';
	$_totalnet = array();
	$_totalvat = array();
	$_totalunits = array();
	$_earliest = 9999999999;
	$_latest = 0;
	$_oldtype = '';
	$_processtable='';
	$_totalnetamount = 0;
	$_totalvatamount = array();
	$_currentheight = 100.0;
	$_nopages = 1;
	$_marked = array();
	foreach ( $_processes_result as $index=>$_process ) {
		$_pos = $index+1;
		$_earliest = min($_earliest,$_process['processunixbegin']);
		$_latest = max($_latest,$_process['processunixend']);
		if ( ! isset($_totalnet[$_process['processtype']]) ) { $_totalnet[$_process['processtype']] = 0; };
		if ( ! isset($_totalvat[$_process['processtype']]) ) { $_totalvat[$_process['processtype']] = array(); };
		if ( ! isset($_totalvat[$_process['processtype']][$_process['processvatrate']]) ) { $_totalvat[$_process['processtype']][$_process['processvatrate']] = 0; };
		if ( ! isset($_totalunits[$_process['processtype']]) ) { $_totalunits[$_process['processtype']] = array(); };
		if ( ! isset($_totalunits[$_process['processtype']][$_process['processunit']]) ) { $_totalunits[$_process['processtype']][$_process['processunit']] = 0; };
		//collect and sort info
		switch($_process['processunit']) {
			case 'h':
				//compute if no value is given
				if ( $_process['processunits'] == '' ) { $_process['processunits'] = ( $_process['processunixend'] - $_process['processunixbegin'] )/3600; };
				//no break: the following has to be applied in any case
			default:
				$_process['total'] = inCents($_process['processunits'])*$_process['processrate'];
				$_totalunits[$_process['processtype']][$_process['processunit']] += inCents($_process['processunits']);
				$_totalnet[$_process['processtype']] += inCents($_process['total']);
				$_totalvat[$_process['processtype']][$_process['processvatrate']] += (float)$_process['processvatrate']/100*inCents($_process['total']);
				break;
		}
		//count one line per 55 characters in "Tätigkeit"
		$_nolines = round(strlen($_process['processtype'].': '.$_process['processdetails'])/55+0.5);
		$_currentheight += $_nolines*4.6;
		//check if we need new page
		if ( $_currentheight > 230) { 
			$_nopages += 1;
			$_processtable .= "
					</table>
				</div>
				<div class=\"invoice_page\">
					<div class=\"invoicepagenumber\">".$_nopages."</div>	
					<table>
						<thead>
							<tr><th>Pos.</th><th>Tätigkeit</th><th>Datum</th><th>Preis/Einheit</th><th>Einheiten</th><th>Preis</th></tr>
						</thead>
			";
			$_currentheight = 5+$_nolines*4.6;
		}
		//add to table
		$_marked[$index] = '';
		if ( $_process['id_ocrm_processes'] == $PARAM['id_ocrm_processes'] ) { $_marked[$index] = 'marked'; };
		$_processtable .= '<tr class="'.$_marked[$index].'"><td>'.$_pos.'</td><td class="justify">'.$_process['processtype'].': '.$_process['processdetails'].'</td><td>'.(new DateTime())::createFromFormat('U',$_process['processunixend'])->format('d.m.Y').'</td><td>'.localFormat($_process['processrate']).'</td><td>'.localFormat(inCents($_process['processunits'])).str_replace('1','',$_process['processunit']).'</td><td>'.localFormat(inCents($_process['total'])).'</td></tr>';
		if ( ! isset($_processes_result[$_pos]) OR $_processes_result[$_pos]['processtype'] != $_process['processtype'] ) {
			$oldtype = $_process['processtype'];
			//count one line per 55 characters in "Tätigkeit"
			$_currentheight += 9.2;
			$_processtable .= '<tr><th>&nbsp;</th><th>'.$oldtype.'</th><th>&nbsp;</th><th>&nbsp;</th><th>'.inTegers($_totalunits[$oldtype]['1']).' | '.localFormat(inCents($_totalunits[$oldtype]['h'])).'h</th><th>'.localFormat(inCents($_totalnet[$oldtype])).'</th></tr><tr><td>&nbsp;</td></tr>';
		};
	}
	foreach ($_totalnet as $_partialnet ) { $_totalnetamount += $_partialnet; }
	foreach ($_totalvat as $_partialvat ) { 
		foreach ($_partialvat as $vatrate=>$partialvatrate) {
			if ( ! isset($_totalvatamount[$vatrate]) ) { $_totalvatamount[$vatrate] = $partialvatrate; } else { $_totalvatamount[$vatrate] += $partialvatrate; }
		}
	}
	if ( $_currentheight > 200) { 
		$_nopages += 1;
		$_processtable += "
				</table>
			</div>
			<div class=\"invoice_page\">
				<div class=\"invoicepagenumber\">".$_nopages."</div>	
				<table>
					<thead>
						<tr><th>Pos.</th><th>Tätigkeit</th><th>Datum</th><th>Preis/Einheit</th><th>Einheiten</th><th>Preis</th></tr>
					</thead>
		";
		$_currentheight = 5+$_nolines*4.6;
	}
	$_processtable .= '<tr><th>&nbsp;</th><th>&nbsp;</th><th>&nbsp;</th><th>&nbsp;</th><th>Netto</th><th>'.localFormat(inCents($_totalnetamount)).'</th></tr>';
	$_totalgrossamount = $_totalnetamount;
	foreach ($_totalvatamount as $vatrate=>$partialvatamount ) {
		$_processtable .= '<tr><th>&nbsp;</th><th>&nbsp;</th><th>&nbsp;</th><th>&nbsp;</th><th>MwSt '.$vatrate.'%</th><th>'.localFormat(inCents($partialvatamount)).'</th></tr>';
		$_totalgrossamount += $partialvatamount;
	}
	$_processtable .= '<tr><th>&nbsp;</th><th>&nbsp;</th><th>&nbsp;</th><th>&nbsp;</th><th>Gesamt</th><th>'.localFormat(inCents($_totalgrossamount)).'</th></tr>';
	//test if inovice has already been finished and changed
	$_copy = '';
	if ( $PARAMETER['proposalfinished'] == "ja" ) {
		if ( $PARAMETER['proposalamount'] != (string)inCents($_totalgrossamount) OR $PARAMETER['proposalvat'] != (string)(inCents($_totalgrossamount)-inCents($_totalnetamount)) ) {
			echo("<label><i class=\"fas fa-exclamation-triangle\"></i></label>Das Angebot wurde nach Erstellung geändert. Wenn die Änderungen legitim sind, ändern Sie den Status des Angebots auf unerstellt und erstellen Sie es erneut."); return; 
		} else {
			$_copy = " - Kopie";
		}
	} else {
		$PARAMETER['proposalnumber'] = $PARAMETER['id_ocrm_proposals'].'A'.$invno;
		unset($_stmt_array); $_stmt_array = array(); unset($_table_result);
		$_stmt_array['stmt'] = "UPDATE view__ocrm_proposals__".$_SESSION['os_role']." SET proposalfinished='ja', proposalnumber=?, proposalamount=?, proposalvat=? WHERE id_ocrm_proposals = ?";
		$_stmt_array['str_types'] = 'sssi';
		$_stmt_array['arr_values'] = array();
		$_stmt_array['arr_values'][] = (string)$PARAMETER['proposalnumber'];
		$_stmt_array['arr_values'][] = (string)inCents($_totalgrossamount);
		$_stmt_array['arr_values'][] = (string)(inCents($_totalgrossamount)-inCents($_totalnetamount));
		$_stmt_array['arr_values'][] = $PARAMETER['id_ocrm_proposals'];
		_execute_stmt($_stmt_array,$conn);
	}
	//get (first) active id
	unset($_stmt_array); $_stmt_array = array(); unset($_table_result);
	$_stmt_array['stmt'] = "SELECT * from view__ocrm_identity__".$_SESSION['os_role']." WHERE idactive = 'ja';";
	$_myid = execute_stmt($_stmt_array,$conn,true)['result'][0];	
	?>
	<link rel="stylesheet" type="text/css" href="/css/ocrm_invoice.css">
	<?php includeFunctions('DETAILS',$conn); ?>	
	<form class="db_options function" method="POST" action="" onsubmit="callFunction(this,'dbAction','message'); return false;">
		<input type="text" hidden value="<?php html_echo($PARAMETER['id_ocrm_proposals']); ?>" name="id_ocrm_proposals" class="inputid" />
	</form>
	<div class="invoice_wrapper">
		<div class="invoiceheader">
			<div class="invoicecc"></div>
			<div class="invoiceaddress">
				<div class="myidentity"><?php echo($_myid['idname'].' | '.$_myid['idstreet'].' | '.$_myid['idpostcode'].' '.$_myid['idcity']); ?></div>
				<div class="invoicename"><?php html_echo($_customer_result['name']); ?></div>
				<div class="invoicecontact"><?php html_echo($_customer_result['contact']); ?></div>
				<div class="invoicestreet"><?php html_echo($_customer_result['street']); ?></div>
				<div class="invoicecity"><?php html_echo($_customer_result['postcode'].' '.$_customer_result['city']); ?></div>
			</div>
			<div class="invoicedata">
				<table>
				<tr><td>Angebotsnummer</td><td><?php echo($PARAMETER['proposalnumber']); ?></td></tr>
				<tr><td>Datum</td><td><?php echo((new DateTime($PARAMETER['proposaldate']))->format('d.m.Y')); ?></td></tr>
				<tr><td>Kundennummer</td><td><?php echo($_customer_result['code']); ?></td></tr>
				<tr><td>Leistungs-/Lieferdatum</td><td><?php echo((new DateTime())::createFromFormat('U',$_earliest)->format('d.m.Y').' - '.(new DateTime())::createFromFormat('U',$_latest)->format('d.m.Y')); ?></td></tr>
				<tr><td>Seite</td><td>1/<?php echo($_nopages); ?></td></tr>
				</table>
			</div>
		</div>
		<h2>Angebot<?php echo($_copy); ?></h2>
		<p>Sehr geehrte(r) <?php html_echo($_customer_result['contact']); ?>,</p>
		<?php echo($PARAMETER['proposaltext']); ?>
		<div>Ich danke für Ihre Anfrage und biete wie folgt an:</div>
		<table>
			<thead>
				<tr><th>Pos.</th><th>Tätigkeit</th><th>Datum</th><th>Preis/Einheit</th><th>Einheiten</th><th>Preis</th></tr>
			</thead>
			<?php echo($_processtable); ?>
		</table>
		<div>Ich würde mich über eine Auftragserteilung freuen und sichere Ihnen eine sorgfältige Ausführung zu.</div>
	</div>
<?php } 

//scope: TABLES
function viewBook(array $PARAM, mysqli $conn) {
	$rnd = rand(0,2147483647);
	//get tax type data
	unset($_stmt_array); $_stmt_array = array(); unset($_taxtype);
	$_stmt_array['stmt'] = "SELECT idtaxtype from view__ocrm_identity__".$_SESSION['os_role']." WHERE idactive = 'ja';";
	$_taxtype = execute_stmt($_stmt_array,$conn,true)['result'][0]['idtaxtype']; //first index, then keynames
	?>
	<link rel="stylesheet" type="text/css" href="/css/ocrm_book.css">
	<?php includeFunctions('OCRM_BOOK',$conn); //OCRM_BOOK (new!) ?> 
	<div class="db_headline_wrapper"><h2 class="db_headline"><i class="fas fa-book"></i> Buchungen nach <?php echo($_taxtype); ?>-Besteuerung</h2></div>
	<div class="book_settings">	
		<form method="POST" action="" onsubmit="callFunction(this,'_createBook','book_wrapper_<?php echo($rnd); ?>'); return false;">
			<label for="bookbegin<?php echo($rnd); ?>">von </label>
			<input type="date" name="bookbegin" id="bookbegin<?php echo($rnd); ?>" value="<?php echo((new DateTime())::createFromFormat('U',time())->format('Y').'-01-01'); ?>"><br><br>
			<label for="bookbegin<?php echo($rnd); ?>"> bis </label>
			<input type="date" name="bookend" id="bookend<?php echo($rnd); ?>" value="<?php echo((new DateTime())::createFromFormat('U',time())->format('Y-m-d')); ?>"><br><br>
			<label for="submitBook<?php echo($rnd); ?>" class="showbook"> <b>anzeigen</b> </label>
			<input type="submit" id="submitBook<?php echo($rnd); ?>" hidden /><br><br>
		</form>
	</div>
	<div class="clear"></div>
	<div class="book_wrapper" id="book_wrapper_<?php echo($rnd); ?>"></div>
	<?php
}

function _createBook(array $PARAM, mysqli $conn) {
	//get tax type data
	unset($_stmt_array); $_stmt_array = array(); unset($_taxtype);
	$_stmt_array['stmt'] = "SELECT idtaxtype from view__ocrm_identity__".$_SESSION['os_role']." WHERE idactive = 'ja';";
	$_taxtype = execute_stmt($_stmt_array,$conn,true)['result'][0]['idtaxtype']; //first index, then keynames
	//get expenses data
	if ( $_taxtype == "Soll" ) { $_datetype = "expensedate"; } else { $_datetype = "expensepaid"; }
	unset($_stmt_array); $_stmt_array = array(); unset($_table_result);
	$_stmt_array['stmt'] = 'SELECT expensetype as type,expensename AS name,'.$_datetype.' as date,-expensecost as amount,-expensevat AS vat from view__ocrm_expenses__'.$_SESSION['os_role'].' WHERE expensedate BETWEEN ? AND ?';
	$_stmt_array['str_types'] = 'ss';
	$_stmt_array['arr_values'] = array($PARAM['bookbegin'],$PARAM['bookend']);
	$_table_result = execute_stmt($_stmt_array,$conn,true)['result']; //first index, then keynames
	if ( ! is_array($_table_result) ) { $_table_result = array (); };
	//get revenues data
	unset($_stmt_array); $_stmt_array = array();
	if ( $_taxtype == "Soll" ) {
		$_stmt_array['stmt'] = "SELECT 'Einnahme' as type,invoicenumber AS name,invoicedate as date,invoiceamount as amount,invoicevat AS vat,invoicevatrate as revenuevatrate from view__ocrm_invoices__".$_SESSION['os_role']." WHERE invoicedate BETWEEN ? AND ? AND invoicefinished = 'ja'";
	} else {
		$_stmt_array['stmt'] = "SELECT 'Einnahme' as type,revenuename AS name,revenuedate as date,revenueamount as amount,revenuevat AS vat,revenuevatrate from view__ocrm_revenues__".$_SESSION['os_role']." WHERE revenuedate BETWEEN ? AND ?";
	}
	$_stmt_array['str_types'] = 'ss';
	$_stmt_array['arr_values'] = array($PARAM['bookbegin'],$PARAM['bookend']);
	$_rev = execute_stmt($_stmt_array,$conn,true);
	if ( is_array($_rev['result']) ) {
		$_table_result = array_merge($_table_result,$_rev['result']); //first index, then keynames
	}
 	//$_table_result = array_merge($_table_result,execute_stmt($_stmt_array,$conn,true)['result']); //first index, then keynames
	array_multisort(array_column($_table_result,'date'),$_table_result); //sort by date ascending
	$_net = 0;
	$_vatexpense = 0;
	$_vatrevenue = array();
	$_vat = 0;
	?>
	<table>
		<thead>
			<tr><th>Datum</th><th>Kostenart</th><th>Beschreibung</th><th>Betrag</th><th>MwSt</th><th>MwSt-Satz</th></tr>
		</thead>
		<tbody>
			<?php foreach ( $_table_result  as $_result ) {
				?>
				<tr><td><?php echo(_cleanup($_result['date'])); ?></td><td><?php echo($_result['type']); ?></td><td><?php echo($_result['name']); ?></td><td><?php echo(_cleanup($_result['amount'])); ?></td><td><?php echo(_cleanup($_result['vat'])); ?></td><td><?php echo(_cleanup($_result['revenuevatrate'])); ?></td></tr>
				<?php
				$_net += $_result['amount'];
				$_vat += $_result['vat'];
				$_vatexpense += min(0,$_result['vat']);
				if ( isset($_result['revenuevatrate']) AND $_result['revenuevatrate'] != '' ) {
					if ( ! isset($_vatrevenue[$_result['revenuevatrate']]) ) { $_vatrevenue[$_result['revenuevatrate']] = $_result['vat']; } else { $_vatrevenue[$_result['revenuevatrate']] += max(0,$_result['vat']); }
				}
			}
			?>
			<tr><th></th><th></th><th>Summe</th><th><?php echo(_cleanup($_net)); ?></th><th><?php echo(_cleanup($_vat)); ?></th></tr>
			<tr><th></th><th></th><th></th><th>Vorsteuerabzug</th><th><?php echo(_cleanup(-$_vatexpense)); ?></th></tr>
			<?php foreach ( $_vatrevenue as $_vatrate=>$_vatamount ) {
			?>
				<tr><th></th><th></th><th></th><th>Umsatzsteuer <?php echo(_cleanup($_vatrate).'%'); ?></th><th><?php echo(_cleanup($_vatamount)); ?></th></tr>
			<?php
			}
			?>
		</tbody>
	</table>
	<?php
}


?>



