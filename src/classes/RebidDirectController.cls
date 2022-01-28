/*********************************
* Class: RebidDirectController
* Description: Contains logic to update Quote Number as per the versioning logic for rebided quotes.
*   
**********************************/
public without sharing class RebidDirectController {
	/*******************************
Method Name: rebidQuote
Description:  
Parameters: Quote/Proposal record id
*******************************/
	@AuraEnabled
	public static string rebidQuote(String quoteId1){
		String returnMessage = 'EXCEPTION';
		String REBID='Rebid'; 
		String RETURNREBID=  'REBID'; 
		String quoteName = ''; 
		String DIRECT_CPQ='Direct CPQ';
		
		String INDIRECT_CPQ='Indirect CPQ';
		String cust='The quote cannot be created as another user was active. Please try again';
		String cqid;
		String quoteid;
		String revId;
		String firstpart;
		String newfirstpart;
		String lastpart;
		String newlastpart;
		Boolean vzw = FALSE;
		Boolean MaxChar = FALSE;  
		Map<String,String> numberToAlpha= new Map<String,String>{'1'=>'B','2'=>'C','3'=>'D','4'=>'E','5'=>'F','6'=>'G','7'=>'H','8'=>'I','9'=>'J','10'=>'K','11'=>'L','12'=>'M','13'=>'N','14'=>'O','15'=>'P','16'=>'Q','17'=>'R','18'=>'S','19'=>'T','20'=>'U','21'=>'V','22'=>'W','23'=>'X','24'=>'Y','25'=>'Z'};
		List<Apttus_Proposal__Proposal__c> cqlist = new List<Apttus_Proposal__Proposal__c>();
		Apttus_Proposal__Proposal__c cqquote = new Apttus_Proposal__Proposal__c();
		//added as a part of defect 2044
		cqquote = [Select Apttus_Proposal__Proposal_Name__c,Apttus_Proposal__Description__c,Quote_Stage__c,NokiaCPQ_Accreditation_Maintenance_Type__c,Project_Price_List_Number__c,Apttus_Proposal__Primary__c,NokiaCPQ_Direct_Shipping_Location__c,Apttus_QPConfig__ConfigurationFinalizedDate__c,NokiaCPQ_End_Customer__c,Maintenance_Y2__c,SSP__c,SRS__c,Maintenance_Y1__c,Reprice_In_Progress__c,NokiaCPQ_Needs_Reprice__c,NokiaCPQ_Last_Reprice__c,Submitted_Date__c,CQ_No_of_Days_Until_Due__c,Time_Dimension__c,Dimensions_2__c,Dimension_1__c,CQ_Total_Sales_Order_PO_Amount__c,CQ_FSO_Received__c,CQ_No_of_Sales_Orders__c,Dimensions_3__c,CQ_Initial_Pricing_Date__c,CQ_First_Sales_Order_Received_Date__c,NokiaCPQ_Total_CNP__c,Nokia_CPQ_SW_IRP_Discount__c,NokiaCPQ_Total_CLP__c,CQ_Customer_Project_Site_State__c,CQ_Customer_Project_Site_City__c,Account_Legal_Entity__c,CQ_Customer_Request_Number__c,CQ_Customer_Project_Code__c,NokiaCPQ_Net_Amount_Quote__c,Is_Classic_Pricing__c,Apttus_Proposal__Primary_Contact__c,NokiaCPQ_Maintenance_Level__c,CQ_Due_Date__c,Apttus_Proposal__Proposal_Expiration_Date__c,Apttus_QPConfig__PriceListId__c,
		Link_to_Service_Scope_of_Work__c,CQ_Sales_Lead__c,Price_List__c,NokiaCPQ_Existing_IONMaint_Contract__c,NokiaCPQ_Contract_Start_Date__c,Contract_Start_Date__c,NokiaCPQ_Partner_Sales_Manager__c,
		PricingmanagerUser__c,NokiaCPQQuote_Start_Date__c,NokiaCPQ_has_Partner_Certified__c,NokiaCPQ_Is_Maintenance_Quote__c,NokiaCPQ_LEO_Discount__c,
		Warranty_credit__c,CurrencyIsoCode,NokiaCPQ_No_of_Years__c,NokiaCPQ_SRS_Level__c,NokiaCPQ_SSP_Level__c,NokiaCPQ_Maintenance_Type__c,isFirstRebidQuote__c,
		RecordTypeId,Apttus_Proposal__Approval_Stage__c,NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c,NokiaCPQ_Portfolio__c,Parent_Rebid_Quote__c,Quote_Type__c,
		NokiaCPQ_Proposal_Id__c,Apttus_Proposal__Opportunity__c,Apttus_Proposal__Account__c	   
		 FROM Apttus_Proposal__Proposal__c 
		 WHERE Id =: quoteId1 LIMIT 1];
		if(cqquote.Apttus_Proposal__Approval_Stage__c==REBID){
			returnMessage=RETURNREBID;
			return returnMessage;
		}else{ 
			Apttus_Proposal__Proposal__c newquote = cqquote.clone(false,true,false,false);
			newquote.Parent_Rebid_Quote__c=cqquote.Parent_Rebid_Quote__c!=null?cqquote.Parent_Rebid_Quote__c:quoteId1;
			try{
	insert   newquote;
			}catch(DmlException e){
				if(e.getMessage().contains('UNABLE_TO_LOCK_ROW')){
	  return cust;
				}
			}
			try{
			if(cqquote.isFirstRebidQuote__c==false){
				cqid = cqquote.NokiaCPQ_Proposal_Id__c;		
				//Parse the QuoteId to get the firstpart for Query
				if(cqid.substring(cqid.length() - 1 , cqid.length()) == GlobalConstants.ONE){
					firstpart = cqid.substring(0, cqid.length() - 2);		   
				}
				else{
					firstpart = cqid.substring(0, cqid.length() - 1);		
					newfirstpart = GlobalConstants.WILDCARD_SEARCH+firstpart+GlobalConstants.WILDCARD_SEARCH;
					cqlist = [SELECT NokiaCPQ_Proposal_Id__c FROM Apttus_Proposal__Proposal__c  WHERE NokiaCPQ_Proposal_Id__c LIKE :newfirstpart  ORDER BY CreatedDate DESC];
					quoteid = cqlist[0].NokiaCPQ_Proposal_Id__c;  
				}	  
				//Parse the QuoteId to get the last Char for Revision
				if(quoteid.substring(quoteid.length() - 1 , quoteid.length()) == GlobalConstants.ONE)
				{
					lastpart = quoteid.substring(quoteid.length() - 2 , quoteid.length() - 1);
					vzw = TRUE;
				}
				else
					lastpart = quoteid.substring(quoteid.length() - 1 , quoteid.length());		
				//Check whether the Revision has reached the Max limit
				if(GlobalConstants.ZEE == lastpart)
					MaxChar = TRUE;
				else
					newlastpart = getNextChar(lastpart);		
				//Check for VzW Quote to add '1' at the end
				if(vzw)
					revId = firstpart+newlastpart+GlobalConstants.ONE;
				else
					revId = firstpart+newlastpart;
			}else{
				cqlist = [SELECT NokiaCPQ_Proposal_Id__c FROM Apttus_Proposal__Proposal__c  WHERE id=:quoteId1];
				quoteid = cqlist[0].NokiaCPQ_Proposal_Id__c; 
			}
			if(!MaxChar)
			{
				//Apttus_Proposal__Proposal__c newquote = cqquote.clone(false,true,false,false);
				//get child quotes of parent being rebided
				list<Apttus_Proposal__Proposal__c> childQuotesList=[SELECT id,NokiaCPQ_Proposal_Id__c,Name FROM Apttus_Proposal__Proposal__c WHERE Parent_Rebid_Quote__c=:cqquote.id ORDER BY CreatedDate  DESC];
				//added by Surinder for direct/indirect
				if(cqquote.Quote_Type__c==DIRECT_CPQ || cqquote.Quote_Type__c==INDIRECT_CPQ){
					newquote.DI_Rebid__c = TRUE;
				   // newquote.Apttus_Proposal__Proposal_Name__c= cqquote.Apttus_Proposal__Proposal_Name__c ;
					newquote.RecordTypeId = cqquote.RecordTypeId;
					if(cqquote.isFirstRebidQuote__c==true){
					if(childQuotesList.size()==0){
						// this is first quote
						newquote.NokiaCPQ_Proposal_Id__c = cqquote.NokiaCPQ_Proposal_Id__c+ ' '+ 'A' ;
						quoteName =  cqquote.Apttus_Proposal__Proposal_Name__c+ ' '+ 'A' ;
					}else{
						//already quotes exist. take the latest one 
						newquote.NokiaCPQ_Proposal_Id__c = cqquote.NokiaCPQ_Proposal_Id__c+ ' '+ numberToAlpha.get(string.valueof(childQuotesList.size())) ;
						//ITCCPQ:1615					   
						if(cqquote.Apttus_Proposal__Proposal_Name__c==cqquote.Apttus_Proposal__Proposal_Name__c.removeEnd(cqquote.Apttus_Proposal__Proposal_Name__c.right(1))){
							 quoteName=cqquote.Apttus_Proposal__Proposal_Name__c.removeEnd(cqquote.Apttus_Proposal__Proposal_Name__c.right(2))+ ' '+ newquote.NokiaCPQ_Proposal_Id__c.right(1) ;
						  }else{
							  quoteName=cqquote.Apttus_Proposal__Proposal_Name__c+ ' '+ newquote.NokiaCPQ_Proposal_Id__c.right(1) ;
						  }
					}	
					}else{
						newquote.NokiaCPQ_Proposal_Id__c = revId;					   
					   //ITCCPQ:1615					   
						  quoteName=cqquote.Apttus_Proposal__Proposal_Name__c.removeEnd(cqquote.Apttus_Proposal__Proposal_Name__c.right(2))+ ' '+ newquote.NokiaCPQ_Proposal_Id__c.right(1) ;
					}
					
					newquote.Apttus_Proposal__Approval_Stage__c = GlobalConstants.CQ_STATUS_DRAFT;
					newquote.Parent_Rebid_Quote__c=cqquote.Parent_Rebid_Quote__c!=null?cqquote.Parent_Rebid_Quote__c:quoteId1;
					newquote.CurrencyIsoCode=cqquote.CurrencyIsoCode;
				}				
				Database.SaveResult savedResults = Database.update(newquote, false);	
				Boolean someFailure = false;
				if (!savedResults.isSuccess()) {
					someFailure = true;
					for (Database.Error err: savedResults.getErrors()) {
						String msg = err.getMessage();
						returnMessage = msg.replaceAll(GlobalConstants.QUOTES,GlobalConstants.BLANK_VALUE);
					}
				}
				if (!someFailure) {
					Boolean isSuccess = false; 
					// copy line items and configuration.
					isSuccess = Apttus_qpconfig.QPConfigWebService.copyProductConfiguration(cqquote.id, newquote.id);
					// copy site phase quanity
					cloneSitePhaseQuanity(cqquote.id, newquote.id);
					//updateQuote(quoteId1,cqlist,true,null);
					updateQuote(newquote.id,[SELECT id,isFirstRebidQuote__c,Apttus_Proposal__Proposal_Name__c FROM Apttus_Proposal__Proposal__c WHERE id=:newquote.id],false,quoteName);
					returnMessage = newquote.id;			 
				}	 
			}
			else
				returnMessage = GlobalConstants.CQ_MAXREVISIONERROR;			
			return returnMessage;
			
			}
			Catch(Exception ex)
{
ExceptionHandler.addException(ex,GlobalConstants.CQ_REBIDQUOTECONTROLLER , GlobalConstants.CQ_REBIDQUOTE);
returnMessage = ex.getMessage();
return returnMessage;
} 
		}
	}
	
	/*******************************
Method Name: getNextChar
Description:  
Parameters: Last Character of QuoteId
*******************************/
	public static String getNextChar(String oldChar) {
		String key = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
		Integer index = key.indexOfChar(oldChar.charAt(0));
		return index == -1? null: key.substring(index+1, index+2);
	} 
	
	/*******************************
Method Name: updateQuote
Description:  
Parameters: old QuoteId
*******************************/
	public static void updateQuote(String recId, List<Apttus_Proposal__Proposal__c> quoList,boolean updateStage,String name){
		List<Apttus_Proposal__Proposal__c> quoUpdateList = new List<Apttus_Proposal__Proposal__c>();
		try{			
			for(Apttus_Proposal__Proposal__c cq : quoList){
				if(cq.Id==recId){				   
					if(name!=null){
						cq.Apttus_Proposal__Proposal_Name__c = name;
					}
				}
				cq.isFirstRebidQuote__c=false;   
				quoUpdateList.add(cq);
			}
			Database.update(quoUpdateList,false);
		}
		Catch(Exception ex){  
			ExceptionHandler.addException(ex,GlobalConstants.CQ_REBIDQUOTECONTROLLER , GlobalConstants.CQ_UPDATEQUOTE);
		}
	} 
	
	public static void cloneSitePhaseQuanity(Id oldQuote, Id clonedQuote){
		List<CPQ_Site_Phase_and_Quantity__c> listToInsert= new List<CPQ_Site_Phase_and_Quantity__c>();
		list<Apttus_Config2__LineItem__c> listLineItems= new list<Apttus_Config2__LineItem__c>();
		list<Apttus_Config2__LineItem__c> listLineItemsCloned= new list<Apttus_Config2__LineItem__c>();
		Set<Id> configIDs= new Set<Id>();
		Set<Id> configIDsCloned= new Set<Id>();
	  Map<String,list<CPQ_Site_Phase_and_Quantity__c>> lineWithSitePhase= new Map<String,list<CPQ_Site_Phase_and_Quantity__c>>();
		Map<String,list<CPQ_Site_Phase_and_Quantity__c>> lineIdWithSitePhase= new Map<String,list<CPQ_Site_Phase_and_Quantity__c>>();
	  Set<Id> lineIds= new Set<Id>();
	 for(Apttus_Config2__ProductConfiguration__c config: [SELECT id FROM Apttus_Config2__ProductConfiguration__c WHERE Apttus_Config2__BusinessObjectRefId__c=:oldQuote]){
		configIDs.add(config.id);
	 }
	 if(configIDs!=null){
	   listLineItems=[SELECT id,Apttus_Config2__LineNumber__c,Apttus_Config2__ProductId__c,Apttus_Config2__ProductOptionId__c,Name FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c IN:configIDs];  
		 for(Apttus_Config2__LineItem__c obj:listLineItems){
			 lineIds.add(obj.id);
		 }
		}
	if(lineIds!=null){
		for(CPQ_Site_Phase_and_Quantity__c rec:[SELECT id,Name,Line_Item__c,NCPQ_Phase__c,NCPQ_Quantity__c,NCPQ_Site__c FROM CPQ_Site_Phase_and_Quantity__c WHERE Line_Item__c IN:lineIds]){
			if(!lineIdWithSitePhase.containsKey(rec.Line_Item__c)){
				lineIdWithSitePhase.put(rec.Line_Item__c, new list<CPQ_Site_Phase_and_Quantity__c>{rec});
			}else{
				lineIdWithSitePhase.get(rec.Line_Item__c).add(rec);
			}  
		}
	}
	if(listLineItems!=null){
	if(!lineIdWithSitePhase.isEmpty()){
		for(Apttus_Config2__LineItem__c obj:listLineItems){
			String key= obj.Apttus_Config2__LineNumber__c +'-'+ obj.Apttus_Config2__ProductId__c +'-'+ obj.Apttus_Config2__ProductOptionId__c;
			lineWithSitePhase.put(key,lineIdWithSitePhase.get(obj.id));			
		} 
	}
}	   
		// cloned quote
		for(Apttus_Config2__ProductConfiguration__c configCloned: [SELECT id FROM Apttus_Config2__ProductConfiguration__c WHERE Apttus_Config2__BusinessObjectRefId__c=:clonedQuote]){
			configIDsCloned.add(configCloned.id);
		}
		if(configIDsCloned!=null){
		 listLineItemsCloned=[SELECT id,Apttus_Config2__LineNumber__c,Apttus_Config2__ProductId__c,Apttus_Config2__ProductOptionId__c,Name FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c IN:configIDsCloned]; 
		}
		 try{
			if(listLineItemsCloned!=null){
			for(Apttus_Config2__LineItem__c obj1:listLineItemsCloned){
				String cloneKey=obj1.Apttus_Config2__LineNumber__c +'-'+ obj1.Apttus_Config2__ProductId__c +'-'+ obj1.Apttus_Config2__ProductOptionId__c;
				if(lineWithSitePhase.get(cloneKey)!=null){
				for(CPQ_Site_Phase_and_Quantity__c obj2:lineWithSitePhase.get(cloneKey)){
					CPQ_Site_Phase_and_Quantity__c copyRec =obj2.clone(false,true);// new CPQ_Site_Phase_and_Quantity__c();
					copyRec.Line_Item__c = obj1.Id;
					listToInsert.add(copyRec);
				}
			}
				
			}
		}
			if(!listToInsert.isEmpty()){
				Database.insert(listToInsert,false);
			}
		}
		Catch(Exception ex){  
			ExceptionHandler.addException(ex,GlobalConstants.CQ_REBIDQUOTECONTROLLER , GlobalConstants.CQ_UPDATEQUOTE);
		}
	
	}
	
	
}