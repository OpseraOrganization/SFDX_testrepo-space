/****************************************
	 * Class Name : ProposalDetail
	 * Created Date: 30 oct 2017
	 * Created By : Accenture
	 * Last Modified by: Accenture
	 * Description :  Controller Class for QuoteRelatedList.cmp	
	*****************************************/
	 global with sharing class ProposalDetail{
	/*****************************
	 *Method Name: getStatusDeatils
	 *Description: To get the details of quote
	 *Parameters: current record ID
	*******************************/		
	 @AuraEnabled
		public static Apttus_Proposal__Proposal__c getStatusDeatils(Id currentRecordId) 
		 {
			Apttus_Proposal__Proposal__c relatedData;
			try{
					relatedData = [SELECT Id,Name,Apttus_Proposal__Approval_Stage__c, Analytics_Source__c FROM Apttus_Proposal__Proposal__c
									   where Id = : currentRecordId Limit : limits.getLimitQueryRows()];
				
			  }
				catch (Exception ex) {ExceptionHandler.addException(ex,CSWXGlobalConstant.ProposalDetail,CSWXGlobalConstant.getStatusDeatilsMethod);
			 return null;
		  }		
			return relatedData;
		}
	/*****************************
	 *Method Name: getProposalLineItem
	 *Description: This method will retrieve the Offer line Items for SWx and CCRE
	 *Parameters: Quote ID
	*******************************/   
	 @AuraEnabled
		public static List<Apttus_Proposal__Proposal_Line_Item__c> getProposalLineItem(Id QuoteID)
		{
		   
		   try{
				 List<Apttus_Proposal__Proposal_Line_Item__c> DetailRecord = new List<Apttus_Proposal__Proposal_Line_Item__c>();
				 String analytics_Source=[Select Analytics_Source__c  from Apttus_Proposal__Proposal__c where id=:QuoteID].Analytics_Source__c; 
				 if(analytics_Source.equalsIgnoreCase(CSWXGlobalConstant.AnalyticsSource_CCRE))
				   {
					  DetailRecord = [SELECT Id,DS_Grouping_Name__c,NokiaCPQ_Product_Name__c,  Apttus_QPConfig__LineType__c, NokiaCPQ_IsOptions__c FROM Apttus_Proposal__Proposal_Line_Item__c where  Apttus_Proposal__Proposal__c=:QuoteID  AND Apttus_Proposal__Product__r.Is_Supplementry__c = false AND NokiaCPQ_IsOptions__c =:CSWXGlobalConstant.Bundle ];
				 }
				else
				   {
					  DetailRecord = [SELECT Id,DS_Grouping_Name__c,NokiaCPQ_Product_Name__c,Product_Code__c,Apttus_Proposal__Description__c, Apttus_QPConfig__Quantity2__c,Net_Price_two_decimal__c,CurrencyIsoCode, Apttus_QPConfig__LineType__c, NokiaCPQ_IsOptions__c, Apttus_Proposal__Product__r.Name FROM Apttus_Proposal__Proposal_Line_Item__c where  Apttus_Proposal__Proposal__c=:QuoteID AND NokiaCPQ_IsOptions__c!=:CSWXGlobalConstant.Bundle];
				}
				return DetailRecord;	   
			}
		   catch(Exception ex){ ExceptionHandler.addException(ex,CSWXGlobalConstant.ProposalDetail,CSWXGlobalConstant.getProposalLineItemMethod);
				   return null;
			   }  
		   
		}
	/*****************************
	 *Method Name: getProductInfoLineItem
	 *Description: This method will retrieve the CCRE Product Info line Items
	 *Parameters: Quote ID
	*******************************/   
	 @AuraEnabled
		public static List<CCRE_product_info_line_items__c> getProductInfoLineItem(Id QuoteID)
		{
			try{
				 list<CCRE_product_info_line_items__c> productinfolineitemlist= new  list<CCRE_product_info_line_items__c>(); 
				 productinfolineitemlist=[Select Info_Type__c,   Product_Family__c,Product_Group__c, Product_Release__c,C8_date_for_product_release__c,Contracted_NEs_per_contract__c,Contracted_NEs_per_customer__c from CCRE_product_info_line_items__c where Offer__c=:QuoteID  AND (Info_Type__c!= null or Product_Family__c!= null or Product_Group__c!= null or Product_Release__c!= null or C8_date_for_product_release__c!= null or Contracted_NEs_per_contract__c!= null or Contracted_NEs_per_customer__c!= null) ];
				 return productinfolineitemlist;
			}
		   catch(Exception ex){ExceptionHandler.addException(ex,CSWXGlobalConstant.ProposalDetail,CSWXGlobalConstant.getProductInfoLineItemMethod);
				   return null;
			   }	
		 
		}
	/*****************************
	 *Method Name: getServiceInfoLineItem
	 *Description: This method will retrieve the CCRE Servive invoice Info line Items  
	 *Parameters: Quote ID
	*******************************/	
	 @AuraEnabled
		public static List<CCRE_Service_Invoice_Info_line_items__c> getServiceInfoLineItem(Id QuoteID)
		{ 
			 try{
				  list<CCRE_Service_Invoice_Info_line_items__c> serviceinfoitemlist= new  list<CCRE_Service_Invoice_Info_line_items__c>();
				  serviceinfoitemlist=[Select Id,Attribute_Label__c, Attribute_Value__c, Attribute_for_customer__c from CCRE_Service_Invoice_Info_line_items__c where Offer__c=:QuoteID  AND Attribute_for_customer__c=:CSWXGlobalConstant.Yes];
				  return serviceinfoitemlist;
			}
		   catch(Exception ex){ ExceptionHandler.addException(ex,CSWXGlobalConstant.ProposalDetail,CSWXGlobalConstant.getServiceInfoLineItemMethod);
			   return null;
			  }	
		  
		}
 /*****************************
	 *Method Name: getDocumentIdforLine
	 *Description: This method will retrieve the document Id  
	 *Parameters: Quote ID,title
	*******************************/	 
 @AuraEnabled
	public static Id getDocumentIdforLine(ID QuoteLineID,String Title)
	{ 
	  Id cvId;
	  Set<id> contentid = new Set<id>();
	  ContentVersion cv;
try{
	  List<Apttus_Proposal__Proposal_Line_Item__c> lineItems = [select id, Apttus_Proposal__Product__c, Apttus_Proposal__Proposal__r.Apttus_Proposal__Account__c from Apttus_Proposal__Proposal_Line_Item__c where id =: QuoteLineID];
	  Id productId = lineItems[0].Apttus_Proposal__Product__c;
	  if(Title.equalsIgnoreCase(CSWXGlobalConstant.VBA_and_Interdependency)){
			for(ContentDocumentLink cdl1 :[select ContentDocumentId from ContentDocumentLink where LinkedEntityId =:productId]){
				 contentid.add(cdl1.ContentDocumentId);
			}
		  cv  = [SELECT ContentDocumentId,Title FROM ContentVersion where title =:Title and ContentDocumentId IN:contentid];
		  cvId = cv.ContentDocumentId;
		}
	  return cvId;
	   }
		catch(Exception ex){ExceptionHandler.addException(ex,CSWXGlobalConstant.ProposalDetail,CSWXGlobalConstant.getDocumentIdforLineMethod);
		   return null;
		  }   
   }	 
	
  /*****************************
 *Method Name : getDocumentId
 *Description: This method will return document Id   
 *Parameters: QuoteId, Title
 *Test coverage from: 
 *******************************/
	@AuraEnabled
	public static Id getDocumentId(ID QuoteID,String Title)
	{
		try {
			/*List<ContentDocumentLink> cdl = [select ContentDocumentId from ContentDocumentLink where LinkedEntityId = :QuoteID];*/
			Set<id> contentid = new Set<id>();
			for(ContentDocumentLink cdl1 :[select ContentDocumentId from ContentDocumentLink where LinkedEntityId = :QuoteID] ){
				contentid.add(cdl1.ContentDocumentId);
			}
			ContentVersion cv  = [SELECT ContentDocumentId,Title FROM ContentVersion where title =:Title and ContentDocumentId IN:contentid];
			return cv.ContentDocumentId;
		} 
	   catch (Exception ex) {ExceptionHandler.addException(ex,CSWXGlobalConstant.ProposalDetail,CSWXGlobalConstant.getDocumentIdMethod);
		   return null;
		}
		  
	}
		 
		 /*****************************
	 *Method Name: getProposalLineItemwithMap
	 *Description: This method will retrieve the Offer line Items for SWx and CCRE
	 *Parameters: Quote ID
	*******************************/   
	 @AuraEnabled
		global static List<RetWrap> getProposalLineItemMapping(Id QuoteID)
		//global static List<AggregateResult> getProposalLineItemMapping(Id QuoteID)
		{
			try{
		  /*List<AggregateResult> groupedResults = [SELECT CurrencyIsoCode, DS_Grouping_Name__c, SUM(Net_Price_two_decimal__c) Net_Price
	  FROM Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c=:QuoteID
	  GROUP BY DS_Grouping_Name__c,CurrencyIsoCode];*/
			
		 //return groupedResults;
		 
		 Map<String, Double> CurrencyRates  =  new Map <String, Double>();
					/*for (CurrencyType cRates : [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE]) {
						  CurrencyRates.put(cRates.IsoCode, cRates.ConversionRate);
					}*/
				List<RetWrap> lstretw=new List<RetWrap>();
				RetWrap retw=new RetWrap();
				
				//Change on net price calculation after community licence change - start
				Map<String,Decimal> mapOfGroupwithNetPrice=new Map<String,Decimal>();
				List<Apttus_Proposal__Proposal_Line_Item__c> listOfLines=[SELECT CurrencyIsoCode, DS_Grouping_Name__c,Apttus_QPConfig__NetPrice__c 
	FROM Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c=:QuoteID];
				for(Apttus_Proposal__Proposal_Line_Item__c lines:listOfLines){
					if(mapOfGroupwithNetPrice.get(lines.DS_Grouping_Name__c)!=null){
						Decimal total= mapOfGroupwithNetPrice.get(lines.DS_Grouping_Name__c);
						total=total+lines.Apttus_QPConfig__NetPrice__c;
						mapOfGroupwithNetPrice.put(lines.DS_Grouping_Name__c,total);
					}
					else{
						mapOfGroupwithNetPrice.put(lines.DS_Grouping_Name__c,lines.Apttus_QPConfig__NetPrice__c);
					}
					
				}
				//Change on net price calculation after community licence change - stop 
				
				for(AggregateResult res:[SELECT CurrencyIsoCode, DS_Grouping_Name__c, SUM(Net_Price_two_decimal__c) Net_Price
	  FROM Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c=:QuoteID
	  GROUP BY DS_Grouping_Name__c,CurrencyIsoCode]){
					//Decimal outCurrencyRate = CurrencyRates.get((String)res.get(CSWXGlobalConstant.currencyISOCode));
				   // Decimal outAmount = (Decimal)res.get(CSWXGlobalConstant.netPrice) *  outCurrencyRate;
					retw=new RetWrap();
					retw.CurrencyIsoCode=(String)res.get(CSWXGlobalConstant.currencyISOCode);
					retw.DS_Grouping_Name=(String)res.get(CSWXGlobalConstant.dsGroupingName);
					if(mapOfGroupwithNetPrice.get((String)res.get(CSWXGlobalConstant.dsGroupingName))!=null){
					retw.Net_Price=mapOfGroupwithNetPrice.get((String)res.get(CSWXGlobalConstant.dsGroupingName));
					}
					lstretw.add(retw);
				}
		   return lstretw;
				
		} 
	   catch (Exception ex) {ExceptionHandler.addException(ex,CSWXGlobalConstant.ProposalDetail,CSWXGlobalConstant.getProposalLineItemMapping);
		   return null;
		}
		}
 /*****************************
	 *Method Name: getProposalLineItemGrouping
	 *Description: This method will retrieve the line Item grouping details 
	 *Parameters: Quote ID, Group
	*******************************/		 
	@AuraEnabled
		 public static map<String,List<Apttus_Proposal__Proposal_Line_Item__c>>  getProposalLineItemGrouping(Id QuoteID, List<String> CustomerGroup){
			 try{
		  map<String,List<decimal>> mapGroupToLine = new map<String,List<decimal>>();
		  map<String,List<Apttus_Proposal__Proposal_Line_Item__c>> mapGroupToProposal = new map<String,List<Apttus_Proposal__Proposal_Line_Item__c>>();
		  map<decimal ,List<Apttus_Proposal__Proposal_Line_Item__c>> mapLineToProposal = new map<decimal,List<Apttus_Proposal__Proposal_Line_Item__c>>();
		  
		  List<Apttus_Proposal__Proposal_Line_Item__c> groupList=new List<Apttus_Proposal__Proposal_Line_Item__c>(); 
		  /*groupList = [Select id,DS_Product_TechnicalInfo__c,DS_Product_Technical_Info_Level2__c,Apttus_QPConfig__LineType__c,Apttus_QPConfig__LineNumber__c,Apttus_Proposal__Product__r.Name,Product_Code__c,NokiaCPQ_Product_Name__c,Apttus_QPConfig__Quantity2__c,CurrencyIsoCode,
																			 DS_Grouping_Name__c,Net_Price_two_decimal__c from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c =: QuoteID];*/
		   
		  List<Apttus_Proposal__Proposal_Line_Item__c> proposalList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
		   List<decimal> lineList = new List<decimal>();
		   for(Apttus_Proposal__Proposal_Line_Item__c app : [Select id,DS_Product_TechnicalInfo__c,DS_Product_Technical_Info_Level2__c,Apttus_QPConfig__LineType__c,Apttus_QPConfig__LineNumber__c,Apttus_Proposal__Product__r.Name,Product_Code__c,NokiaCPQ_Product_Name__c,Apttus_QPConfig__Quantity2__c,CurrencyIsoCode,
																			 DS_Grouping_Name__c,Net_Price_two_decimal__c from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c =: QuoteID])   
		   {
			   for(string groupName : CustomerGroup){
				   if(app.DS_Grouping_Name__c == groupName){
						lineList = new List<decimal>();
					   if(mapGroupToLine.containsKey(app.DS_Grouping_Name__c )){
						   lineList = mapGroupToLine.get(groupName);
					   }
						lineList.add(app.Apttus_QPConfig__LineNumber__c);
						mapGroupToLine.put(groupName,lineList);
				   }
			   }
			   
			   proposalList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
			   if(mapLineToProposal.containsKey(app.Apttus_QPConfig__LineNumber__c)){
					proposalList = mapLineToProposal.get(app.Apttus_QPConfig__LineNumber__c);
			   }
			   proposalList.add(app);
			   mapLineToProposal.put(app.Apttus_QPConfig__LineNumber__c,proposalList);
		   }
			 
		   for(string grouping : mapGroupToLine.keyset()){
			   proposalList = new List<Apttus_Proposal__Proposal_Line_Item__c> ();
			   for(decimal lineNumber : mapGroupToLine.get(grouping)){
				   proposalList.addAll(mapLineToProposal.get(lineNumber));
			   }
			 
			   mapGroupToProposal.put(grouping,proposalList);
			   
		   }
		   
		   return mapGroupToProposal;
				 } 
	   catch (Exception ex) {ExceptionHandler.addException(ex,CSWXGlobalConstant.ProposalDetail,CSWXGlobalConstant.getProposalLineItemGrouping);
		   return null;
		}
		 }
/****************************************
	 * Class Name : RetWrap
	 * Created Date: 30 oct 2017
	 * Created By : Accenture
	 * Last Modified by: Accenture
	 * Description : Wrapper class to show line Item on Customer Portal group by Customer Grouping 
	*****************************************/   
global with sharing class RetWrap{
		@AuraEnabled public String CurrencyIsoCode{get;set;}
		@AuraEnabled public String DS_Grouping_Name{get;set;}
		@AuraEnabled public Decimal Net_Price{get;set;}
	}
	 }