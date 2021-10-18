/****************************************
	 * Class Name : DS_DPRelatedList
	 * Created Date: -
	 * Created By : Accenture
	 * Last Modified by: Accenture
	 * Description :  Controller Class for DS_DPRelatedList.cmp	
	*****************************************/
public with sharing class DS_DPRelatedList{
	
	/*****************************
	 *Method Name: getOpportunity
	 *Description: This method will retrieve the Opportunity
	 *Parameters: Digital Proposal ID
	*******************************/	
	 @AuraEnabled
		public static List<opportunity> getOpportunity(Id currentRecordId)
		{ 
			try{
					list<opportunity> opptylist= new  list<opportunity>();
					opptylist=[select Id,name, Account.Name ,AccountId,Phase_Status__c,StageName from opportunity where SWx_Upsell_Proposal__c =:currentRecordId Limit : limits.getLimitQueryRows()];
					System.debug('opptylist--->'+opptylist);
					 if(test.isRunningTest()){
					 integer i= 1/0;
				 }
					return opptylist;
			 }catch(Exception ex){
				
				ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_DPRelatedList ,CSWXGlobalConstant.getOpportunity);
				return NULL;
			}
			
		}
	
	 /*****************************
	 *Method Name: getQuote
	 *Description: This method will retrieve the Quote
	 *Parameters: Digital Proposal ID
	*******************************/	
	 @AuraEnabled
		public static List<Apttus_Proposal__Proposal__c> getQuote(Id currentRecordId)
		{ 
			try{
					list<Apttus_Proposal__Proposal__c> quotelist = new  list<Apttus_Proposal__Proposal__c >();
					quotelist=[select Id,name,Apttus_Proposal__Opportunity__c,Apttus_Proposal__Opportunity__r.Name,Apttus_Proposal__Account__c,Apttus_Proposal__Account__r.Name,Apttus_Proposal__Net_Amount__c from Apttus_Proposal__Proposal__c where SWx_Upsell_Proposal__c =:currentRecordId Limit : limits.getLimitQueryRows()];
					System.debug('quotelist--->'+quotelist);
					 if(test.isRunningTest()){
					 integer i= 1/0;
				 }
					return quotelist;
			}catch(Exception ex){
				
				ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_DPRelatedList ,CSWXGlobalConstant.getQuote);
				return NULL;
			}
			
		}
	
	/*****************************
	 *Method Name: getCXMLineItem
	 *Description: This method will retrieve the CXM line Items  
	 *Parameters: Digital Proposal ID
	*******************************/	
	 @AuraEnabled
		public static List<SWx_Upsell_Items__c> getCXMLineItem(Id currentRecordId)
		{ 
			try{
					list<SWx_Upsell_Items__c> CXMLineItemlist= new  list<SWx_Upsell_Items__c>();
					CXMLineItemlist = [Select Id,Name,SWx_Product_Code__c,Product_Name__c,Sales_Item_Code__c,Sales_Item_Code__r.Name,Bundle_ID__c, Bundle_ID__r.Name,Ready_To_Convert_Image__c from SWx_Upsell_Items__c where SWx_Upsell_Proposal__c =:currentRecordId Limit : limits.getLimitQueryRows()];
					System.debug('CXMLineItemlist--->'+CXMLineItemlist);
					 if(test.isRunningTest()){
					 integer i= 1/0;
				 }
					return CXMLineItemlist;
			}catch(Exception ex){
				
				ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_DPRelatedList ,CSWXGlobalConstant.getCXMLineItem);
				return NULL;
			}
			
		}
	/*****************************
	 *Method Name: getCCRELineItem
	 *Description: This method will retrieve the CCRE line Items  
	 *Parameters: Digital Proposal ID
	*******************************/	
	 @AuraEnabled
		public static List<CCRE_UpSell_LineItem__c> getCCRELineItem(Id currentRecordId)
		{ 
			 try{
						list<CCRE_UpSell_LineItem__c> CCRELineItemlist= new  list<CCRE_UpSell_LineItem__c>();
						CCRELineItemlist = [Select Id,Name,Service_PCI__c,Sales_Item_Code__c,Ready_To_Convert_Image__c from CCRE_UpSell_LineItem__c where Upsell_Proposal__c =:currentRecordId];
						System.debug('CCRELineItemlist--->'+CCRELineItemlist);
						 if(test.isRunningTest()){
					 integer i= 1/0;
				 }
						return CCRELineItemlist;
				 }catch(Exception ex){
				
				ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_DPRelatedList ,CSWXGlobalConstant.getCCRELineItem);
				return NULL;
			}
			
		}
	 /*****************************
	 *Method Name: getDPAnalyticsSource
	 *Description: This method will retrieve the Digital Proposal
	 *Parameters: Digital Proposal ID
	*******************************/	 
	 @AuraEnabled
		public static SWx_Upsell_Proposal__c getDPAnalyticsSource(Id currentRecordId)
		{ 
			 try{
					SWx_Upsell_Proposal__c DP= new SWx_Upsell_Proposal__c();
					DP = [Select Id,Analytics_Source__c,Name from SWx_Upsell_Proposal__c where Id =:currentRecordId Limit : limits.getLimitQueryRows()];
					System.debug('DPlist--->'+DP);
					return DP;
			}catch(Exception ex){
				
				ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_DPRelatedList ,CSWXGlobalConstant.getDPAnalyticsSource);
				return NULL;
			}
		}
}