/*******************************
Class Name: salesorderreporting_trigger_helper
Modified by: HCL
Modified Date: 8th Mar 2021
Description: This class will handle the logic implemented on salesorderreporting_trigger
*******************************/
public class salesorderreporting_trigger_helper {

	//============================================================================================= 
	// Method Name: UpdateCQNumber
	// Purpose: This method method will analysis the CQNumber and update it
	// Author: Rakesh Dandae
	// ============================================================================================
	//	 
	public void UpdateCQNumber(list<Sales_Order_Reporting__c> salesOrderList){
		
		Set<String> CQNumberSet = new Set<String>();
		Set<String> DQNumberSet = new Set<String>();
		Map<String, Id> cqMap = new Map<String, Id>();
		Map<String, Id> CQ_AccMap = new Map<String, Id>();
		Map<String, Id> OfferMap = new Map<String, Id>();
		Map<String, Id> Offer_AccMap = new Map<String, Id>();
		Map<String, Id> cqrepMap = new Map<String, Id>();
		List<Sales_Order_Reporting__c> updateList = new List<Sales_Order_Reporting__c>();
		Map<String, Id> OfferidMap = new Map<String, Id>();
		Map<String, Id> idMap = new Map<String, Id>();
		Boolean check;
		String qt;
		
		System.debug('salesOrderList'+salesOrderList);
		//Id DefaultAccountId = [select Id from Account where AccountNumber = :system.label.Default_SalesOrder_Account].Id;
		try{
			for(Sales_Order_Reporting__c so : salesOrderList){
	
	if (so.Order__c <> null) {
		check=validate(so.Order__c);
		if(check==true){
			qt=so.Order__c.replace('.Q',' Q ');
			DQNumberSet.add(qt);
		}
		else
		CQNumberSet.add(so.Order__c);	 
	}else{
		so.Account__c = system.label.Default_SalesOrder_Account;
	}
			}
	system.debug('DQNumberSet'+DQNumberSet);
			system.debug('CQNumberSet'+CQNumberSet);
			if((CQNumberSet.size() > 0 || !CQNumberSet.isEmpty()) || (DQNumberSet.size() > 0 || !DQNumberSet.isEmpty())  ){
	
	String soql1 = 'SELECT Id, Apttus_Proposal__Opportunity__c, NokiaCPQ_Proposal_Id__c,Apttus_Proposal__Account__c FROM Apttus_Proposal__Proposal__c WHERE (NokiaCPQ_Proposal_Id__c IN: CQNumberSet) OR (NokiaCPQ_Proposal_Id__c IN: DQNumberSet)';
	String soql2 = 'SELECT Id, CQ_Number__c FROM Surround_CQ_Reporting__c WHERE CQ_Number__c IN: CQNumberSet';
	String soql_offer = 'Select Id, Offer_Number__c,Opportunity__c,	Opportunity__r.AccountId from Offer__c where Offer_Number__c in : CQNumberSet';
	List<Apttus_Proposal__Proposal__c> cqList = Database.query(soql1);
	List<Surround_CQ_Reporting__c> cqrepList = Database.query(soql2);
	List<Offer__c> OfferList = Database.query(soql_offer);
	system.debug('cqList: '+cqList);
	system.debug('cqrepList: '+cqrepList);
	if(cqList.size() > 0 && !cqList.isEmpty()){
		for(Apttus_Proposal__Proposal__c cq : cqList){
			cqMap.put(cq.NokiaCPQ_Proposal_Id__c, cq.Apttus_Proposal__Opportunity__c);
			idMap.put(cq.NokiaCPQ_Proposal_Id__c, cq.Id);
			CQ_AccMap.put(cq.NokiaCPQ_Proposal_Id__c, cq.Apttus_Proposal__Account__c);
		}
		system.debug('cqMap: '+cqMap);
		system.debug('idMap: '+idMap);
		system.debug('CQ_AccMap: '+CQ_AccMap);
		if(cqrepList.size() > 0 && !cqrepList.isEmpty()){
			for(Surround_CQ_Reporting__c cqrep : cqrepList){
				
				cqrepMap.put(cqrep.CQ_Number__c, cqrep.Id);
			}
			system.debug('cqrepMap: '+cqrepMap);
		}
		
		for(Sales_Order_Reporting__c so : salesOrderList){
			system.debug('salesOrderList: '+salesOrderList);
			if(!DQNumberSet.isEmpty())
			{
			 String qp= so.Order__c.replace('.Q',' Q ');  
			if(idMap.get(qp) <> null ){
				so.Contracted_Quote__c = idMap.get(qp);
				so.Opportunity__c = cqMap.get(qp);
				so.Account__c = CQ_AccMap.get(qp);
				so.Actual_CQ_Number__c=qp;
			}
			}
			if(!CQNumberSet.isEmpty())
			{
		 if(idMap.get(so.Order__c) <> null ){
				so.Contracted_Quote__c = idMap.get(so.Order__c);
				so.Opportunity__c = cqMap.get(so.Order__c);
				so.Account__c = CQ_AccMap.get(so.Order__c);
				so.Actual_CQ_Number__c=so.Order__c;
			} 
			if(cqrepMap.get(so.Order__c) <> null){
				so.Surround_CQ_Reporting__c = cqrepMap.get(so.Order__c);
			}
			}
			system.debug('SO: '+so);
		}
		
	}
	 if(OfferList.size() > 0 && !OfferList.isEmpty()){
		 for(Offer__c ofr : OfferList){
			OfferMap.put(Ofr.Offer_Number__c, ofr.Opportunity__c);
			offeridMap.put(Ofr.Offer_Number__c, ofr.Id);
			Offer_AccMap.put(Ofr.Offer_Number__c, ofr.Opportunity__r.AccountId);
		}
		
		for(Sales_Order_Reporting__c so : salesOrderList){
			
			if(OfferMap.get(so.Order__c) <> null ){
				
				so.Opportunity__c = OfferMap.get(so.Order__c);
				so.Account__c = Offer_AccMap.get(so.Order__c);
			}
		
			system.debug('SO: '+so);
		}
	 }
	
			}
		}
		catch(exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CL_salesorderreporting_trigger_helper, GlobalConstants.M_UpdateCQNumber);
		}
		
	}
	
	//============================================================================================= 
	// Method Name: CheckCQChange
	// Purpose: This method method will analysis the OfferNumber, if changed, call method decideOnOfferNumber
	// Author: Rakesh Dandae
	// ============================================================================================
	public void CheckCQChange(Map<Id, Sales_Order_Reporting__c> oldMap, Map<Id, Sales_Order_Reporting__c> newMap){
		Set<Id> salesOrderIdSet = new Set<Id>();
		
		try{
			List<Sales_Order_Reporting__c> updateList = new List<Sales_Order_Reporting__c>();
			for(Id id : oldMap.keySet()){
	salesOrderIdSet.add(id);
	
			}
			
			for(Id id : salesOrderIdSet){
	
	if(newMap.get(id).Order__c <> null && newMap.get(id).Order__c <> oldMap.get(id).Order__c){
		updateList.add(newMap.get(id));
	}
	
			}
			if(!updateList.IsEmpty()){
	UpdateCQNumber(updateList);
			}
		}
		catch(exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CL_salesorderreporting_trigger_helper, GlobalConstants.M_CheckCQChange);
		}
	}
	
	//============================================================================================= 
	// Method Name: Currencychange
	// Purpose: This method method calculate the currency values for EUR and USD fields based on Dated Exchange Rates
	// Author: Rakesh Dandae
	// ============================================================================================
	
	Public void Currencychange(List<Sales_Order_reporting__c> salesorderlist){
		
		List<String> currency_list = new List<String>();
		map<string,string> so_nfc_map = new map<string,string>();
		map<string,decimal> Der_map = new map<string,decimal>();
		map<string,decimal> usd_der_map = new map<string,decimal>();  
		List<Sales_Order_reporting__c> so_list = new list<Sales_Order_reporting__c>();
		Date maxdate = system.today();
		Date mindate = system.today();
		
		try{
			for(Sales_Order_reporting__c so_rec : salesorderlist){
	
	if(so_rec.currencyisocode <> null){
		currency_list.add(so_rec.currencyisocode);
		Date createdDate = so_rec.CreatedDate == null ? system.today() : so_rec.CreatedDate.date();
		if(createdDate >= maxdate ){
			maxdate = createdDate;
		}
		if(createdDate <= mindate){
			mindate = createdDate;
		}
		
	}
			}
			
			system.debug('mindate: ' + mindate);
			system.debug('maxdate: ' + maxdate);
			system.debug('currency list: ' + currency_list);
			
			List<Nokia_Financial_Calendar__c> nfc = new  List<Nokia_Financial_Calendar__c>([select id, End_Date__c,Start_Date__c,name from Nokia_Financial_Calendar__c
								where Start_Date__c <= :maxdate and End_Date__c >= :mindate]);
			
			system.debug('nfc: ' + nfc);
			
			for(Sales_Order_reporting__c so : salesorderlist){
	
	for(Nokia_Financial_Calendar__c nfc_rec :  nfc){
		Date createdDate = so.CreatedDate == null ? system.today() : so.CreatedDate.date();
		system.debug('so.CreatedDate.date: '+ createdDate);
		system.debug('nfc_rec.Start_Date__c: ' + nfc_rec.Start_Date__c);
		system.debug('nfc_rec.End_Date__c: ' + nfc_rec.End_Date__c);
		
		if(createdDate >= nfc_rec.Start_Date__c && createdDate <= nfc_rec.End_Date__c){
			
			so_nfc_map.put(so.ALU_Order_Number__c,nfc_rec.id);
			
		}
	}
			}
			
			system.debug('so_nfc_map: ' + so_nfc_map);
			
			for( Dated_exchange_rates__c der : [select id, exchange_rate__c, currencyisocode,DER_Period__c from Dated_exchange_rates__c
			where DER_Period__c in :nfc and (currencyisocode in : currency_list or CurrencyIsoCode=:GlobalConstants.USD )]){
				
				String concat_per_curr = der.DER_Period__c + der.currencyisocode;
				if( !der.CurrencyIsoCode.equalsignorecase(GlobalConstants.USD)){		   
					der_map.put(concat_per_curr, der.exchange_rate__c);			
				}else{
					usd_der_map.put(concat_per_curr, der.exchange_rate__c);
				}			
			}
			
			system.debug('der_map:' + der_map);
			system.debug('usd_der_map: ' + usd_der_map);
			for(Sales_Order_reporting__c so_rep : salesorderlist){
	
	system.debug('so_nfc_map: ' + so_nfc_map.get(so_rep.ALU_Order_Number__c));
	
	if(so_nfc_map.get(so_rep.ALU_Order_Number__c)<> null && so_nfc_map.containskey(so_rep.ALU_Order_Number__c)){
		system.debug('entered first if');
		String per_curr = so_nfc_map.get(so_rep.ALU_Order_Number__c) + so_rep.CurrencyIsoCode;
		string per_usd = so_nfc_map.get(so_rep.ALU_Order_Number__c) + GlobalConstants.USD;
		if(der_map.get(per_curr) <> null && der_map.containskey(per_curr) && usd_der_map.get(per_usd) <> null && !so_rep.CurrencyIsoCode.equalsignorecase(GlobalConstants.USD)){
			system.debug('Non Usd loop');
			
			if(so_rep.CurrencyIsoCode.equalsignorecase(GlobalConstants.EUR)){
				so_rep.PO_Amount_EUR__c = so_rep.PO_Amount__c;
			}else{
				so_rep.PO_Amount_EUR__c = (so_rep.PO_Amount__c / der_map.get(per_curr)).setscale(2);
			}
			
			if(so_rep.CurrencyIsoCode.equalsignorecase(GlobalConstants.EUR)){
				so_rep.PO_Amount_USD__c = ( so_rep.PO_Amount__c * usd_der_map.get(per_usd)).setscale(2);
			} else {
				so_rep.PO_Amount_USD__c = ((so_rep.PO_Amount__c / der_map.get(per_curr)) * usd_der_map.get(per_usd)).setscale(2);
			}
			
		} 
		else if(usd_der_map.get(per_usd) <> null && so_rep.CurrencyIsoCode.equalsignorecase(GlobalConstants.USD)){
			system.debug('loop usd');
			
			so_rep.PO_Amount_EUR__c = (so_rep.PO_Amount__c / usd_der_map.get(per_curr)).setscale(2);
			so_rep.PO_Amount_USD__c = so_rep.PO_Amount__c;
			system.debug('so_rep.PO_Amount_EUR__c: '+so_rep.PO_Amount_EUR__c);
			system.debug('PO_Amount_USD__c: '+so_rep.PO_Amount_USD__c);
		}
		
	}
	
			}
		} catch(exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CL_salesorderreporting_trigger_helper, GlobalConstants.M_Currencychange);
		}
		
		
	}
	
	//============================================================================================= 
	// Method Name: Updatecurrencychange
	// Purpose: This method method calculate the currency values for EUR and USD fields based on Dated Exchange Rates
	// Author: Rakesh Dandae
	// ============================================================================================
	
	Public void Updatecurrencychange(List<Sales_Order_reporting__c> salesorderlist, Map<Id,Sales_Order_reporting__c> oldSalesOrderMap){
		system.debug('entered Updatecurrencychange in helper');
		List<Sales_Order_reporting__c> newSOList = new List<Sales_Order_reporting__c>(); 
		
		try{
			for(Sales_Order_reporting__c SORec :salesOrderList){	 
				if(oldSalesOrderMap.get(SORec.id).PO_Amount__c != SORec.PO_Amount__c || oldSalesOrderMap.get(SORec.id).CurrencyISOCode != SORec.CurrencyISOCode){
					newSOList.add(SORec); 
				}	
			}
			system.debug('newSOList: ' + newSOList);
			if(newSOList.size() > 0){
				Currencychange(newSOList);
			}
		}
		
		catch(exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CL_salesorderreporting_trigger_helper, GlobalConstants.M_Updatecurrencychange);
		}
	}
	
	//============================================================================================= 
	// Method Name: validate
	// Purpose: This method is to match the quote number to determine whether it is a Direct Quote
	// Author: Selva
	// ============================================================================================
	
	 public Boolean validate(String CQ_Number){
		Boolean result;
		try{
		String CQRegex= '^[0-9]{2}\\.+[A-Z]{2}\\.[0-9]{6}\\.Q[0-9]{1,3}$';
		
		Pattern MyPattern= Pattern.compile(CQRegex);
		
		Matcher Mymatcher= MyPattern.matcher(CQ_Number);
		
		result = Mymatcher.matches();
		}
		
		catch(exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CL_salesorderreporting_trigger_helper, GlobalConstants.M_validate);
		}
		
		return result;
	}
}