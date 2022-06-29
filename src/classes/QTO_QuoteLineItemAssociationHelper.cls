/**
 * @description	   : This Class contains Logic that maps CustomerDocumentLineItem to QuoteLineItem. 
 *				This class is called from QTO_QuoteLineItemAssociationController.
 * @author			: Raj Kamdar
 * @group			 : 
 * @last modified on  : 12-15-2020
 * @last modified by  : Raj Kamdar
 * Modifications Log 
 * Ver   Date		 Author	   Modification
 * 1.0   11-25-2020   Raj Kamdar   Initial Version
**/

public without sharing class  QTO_QuoteLineItemAssociationHelper {
	
	public Static final String ATTRIBUTE_VISIBILITY = 'Yes';
	public Static final String ATTRIBUTE_LABEL = 'G2R site';
	public Static final String ATTRIBUTE_INDICATOR = 'Item';
	public Static Map<Id,List<Apttus_Proposal__Proposal_Line_Item__c>> qLIForAssociationCDLIMap = new Map<Id,List<Apttus_Proposal__Proposal_Line_Item__c>>();
	public Static List<Apttus_Proposal__Proposal__c> quoteListFromRef = new List<Apttus_Proposal__Proposal__c>();
 
	public Static final List<String> APPROVAL_STAGES_LIST = new List<String>{'Approved', 'Published - In Progress', 'Published - Ready', 'Call-off Ready'};
	
   /**
	* @description: This method creates a Map of CustomerDocument and their corresponding CustomerDocumentLineItem
	* @author Akanksha Triveri
	* @param objCDOIdSet 
	* @return Map<Id, List<Customer_Document_Line_Items__c>> 
	**/
	public static Map<Id,List<Customer_Document_Line_Items__c>> getAllCDLIfromCD(Set<Id> objCDOIdSet){
		System.debug('Get all CDLI from CD');
		System.debug('Input: '+objCDOIdSet);
		Map<Id,List<Customer_Document_Line_Items__c>> custDocLineItemMap = new Map<Id,List<Customer_Document_Line_Items__c>>();
		for(Id customerDocumentId: objCDOIdSet){
			custDocLineItemMap.put(customerDocumentId,new List<Customer_Document_Line_Items__c>());
		}
		for (Customer_Document_Line_Items__c custDoclineItem: [SELECT id, Site__c,High_level_Product__c,Customer_Document__c FROM Customer_Document_Line_Items__c WHERE Customer_Document__r.id IN:objCDOIdSet]){  
			if(custDocLineItemMap.containsKey(custDoclineItem.Customer_Document__c)){
				custDocLineItemMap.get(custDoclineItem.Customer_Document__c).add(custDoclineItem);
			}else{
				custDocLineItemMap.put(custDoclineItem.Customer_Document__c ,new list<Customer_Document_Line_Items__c>{custDoclineItem}); 
			}
		}																	
		system.debug('custDocLineItemMap'+custDocLineItemMap);
		return custDocLineItemMap;
	}
	
	 /**
	 * @description: This method creates a Map of CustomerDocument and their corresponding CustomerDocumentLineItem
	 * @author Akanksha Triveri
	 * @param custId 
	 * @return Map<Id, List<Customer_Document_Line_Items__c>> 
	 **/
	 public static Map<Id,List<Customer_Document_Line_Items__c>> getAllCDLIfromCDOId(Id custId){
		
		Map<Id,List<Customer_Document_Line_Items__c>> custDocLineItemMap = new Map<Id,List<Customer_Document_Line_Items__c>>();
		for (Customer_Document_Line_Items__c custDoclineItem: [SELECT id, Site__c,High_level_Product__c,Customer_Document__c FROM Customer_Document_Line_Items__c WHERE Customer_Document__r.id =: custId]){  
			if(custDocLineItemMap.containsKey(custDoclineItem.Customer_Document__c)){
				custDocLineItemMap.get(custDoclineItem.Customer_Document__c).add(custDoclineItem);
			}else{
				custDocLineItemMap.put(custDoclineItem.Customer_Document__c ,new list<Customer_Document_Line_Items__c>{custDoclineItem}); 
			}
		}																	
		
		return custDocLineItemMap;
	}

	/**
	* @description: This method get QuoteLineItems based on applicable filters on Customer-Facing Attribute & filters on Quote
	* TBD - SOQL should be single
	* @author Akanksha Triveri
	* @param accountSet 
	* @param quoteIdList 
	* @param isAccountList 
	* @return List<Customer_facing_Attribute__c> 
	**/
	public static List<Customer_facing_Attribute__c> getAllFilteredQLIList(Set<Id> accountSet ,Set<Id> quoteIdList,boolean isAccountList){
		String query;
		system.debug('isAccountList=='+isAccountList);
		if(isAccountList){
		 query = 'SELECT Quote__r.Id, Quote__r.Name, Quote__r.Apttus_Proposal__Proposal_Name__c, Attribute_Label__c, Attribute_Value__c,' 
			+'Quote__r.Apttus_QPConfig__PONumber__c, Quote_Line_Item__r.id, Quote_Line_Item__r.Product_Code__c, Quote_Line_Item__r.External_Reference__c,' 
			+ 'Quote_Line_Item__r.Apttus_Proposal__Proposal__r.id'
			+ ' FROM Customer_facing_Attribute__c WHERE Attribute_Visibility__c = : ATTRIBUTE_VISIBILITY AND Attribute_Label__c = :ATTRIBUTE_LABEL'
			+ ' AND Attribute_Indicator__c = : ATTRIBUTE_INDICATOR AND Quote__r.Sold_To_Party__c IN : accountSet'
			+ ' AND Quote__r.Apttus_Proposal__Approval_Stage__c IN  : APPROVAL_STAGES_LIST';
		}else{
		  query = 'SELECT Quote__r.Id, Quote__r.Name, Quote__r.Apttus_Proposal__Proposal_Name__c, Attribute_Label__c, Attribute_Value__c,' 
			+'Quote__r.Apttus_QPConfig__PONumber__c, Quote_Line_Item__r.id, Quote_Line_Item__r.Product_Code__c, Quote_Line_Item__r.External_Reference__c,' 
			+ 'Quote_Line_Item__r.Apttus_Proposal__Proposal__r.id'
			+ ' FROM Customer_facing_Attribute__c WHERE Attribute_Visibility__c = : ATTRIBUTE_VISIBILITY AND Attribute_Label__c = :ATTRIBUTE_LABEL'
			+ ' AND Attribute_Indicator__c = : ATTRIBUTE_INDICATOR AND Quote__r.Id IN : quoteIdList'
			+ ' AND Quote__r.Apttus_Proposal__Approval_Stage__c IN  : APPROVAL_STAGES_LIST';
		}
		return Database.query(query);
	}

	/**
	* @description: This method fitler QuoteLineItem based on SiteCode and External References
	* @author Akanksha Triveri
	* @param filteredCFAList 
	* @return Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>> 
	**/
	public static Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>> createFilteredQLIMap(List<Customer_facing_Attribute__c> filteredCFAList){
		
		Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>> filteredQLIMap =new Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>>();
		
		for(Customer_facing_Attribute__c cfAObj : filteredCFAList){
			String key = cfAObj.Attribute_Value__c + '-' +cfAObj.Quote_Line_Item__r.External_Reference__c;
			if(filteredQLIMap.containsKey(key)){
				filteredQLIMap.get(key).add(cfAObj.Quote_Line_Item__r);
			}
			else{
				filteredQLIMap.put(key,new List<Apttus_Proposal__Proposal_Line_Item__c> {cfAObj.Quote_Line_Item__r}); 
			}
		}
		return filteredQLIMap;
	}

	/**
	* @description: This method maps CustomerDocumentLineItem to QuoteLineItems
	* @author Akanksha Triveri
	* @param custDocLineItemMap 
	* @param qLIMap 
	* @return Map<Id, Set<Id>> 
	**/
	public static Map<Id,Set<Id>> fetchMatchedQLIfromCDLI(Map<Id,List<Customer_Document_Line_Items__c>> custDocLineItemMap ,Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>> qLIMap){
		Set<Id> associatedQuoteSet = new Set<Id>();
		Set<Id> qLIForAssociationCDLI = new Set<Id>();
		Map<Id,Set<Id>> qLIForAssociationCDMap = new Map<Id,Set<Id>>();
		Set<ID> quoteIDSet = new Set<ID>();
		system.debug('HS***5' + qLIMap);
		
	   // Map<Id,Apttus_Proposal__Proposal_Line_Item__c> qLIForNoAssociationCDLI = new Map<Id,Apttus_Proposal__Proposal_Line_Item__c>();
		//CD for loop starts
		for(Id custDocId :custDocLineItemMap.keySet()){
			List<Customer_Document_Line_Items__c> custDocLineItemList  = custDocLineItemMap.get(custDocId);
			//CDLI for loop starts
			for(Customer_Document_Line_Items__c custDocLineItem :custDocLineItemList){
				
				String siteCode = getSiteCode(custDocLineItem.Site__c);
				
				if(custDocLineItem.Site__c != null && custDocLineItem.High_level_Product__c != null && siteCode != null){
					
					String key = siteCode +'-'+ custDocLineItem.High_level_Product__c;
					System.debug('Key:' +key);
					if(qLIMap.containsKey(key)){
						System.debug('Found Key');
						List<Apttus_Proposal__Proposal_Line_Item__c> qLIList = qLIMap.get(key);
						if(qLIList != null && qLIList.size()==1){
							qLIForAssociationCDLI.add(qLIList[0].Apttus_Proposal__Proposal__r.id);
						}else if(qLIList != null && qLIList.size()> 1){
							
						  //QTO_Utility.createLogs('Multiple Quote LineItems found ',custDocId, custDocLineItem.id);
						  //QTO_Exception_Configuration__mdt logMetadata = new QTO_Exception_Configuration__mdt();
						  //logMetadata = QTO_Utility.fetchLogMetadata(421);
						  //QTO_Utility.createLogs(logMetadata.QTO_Return_Description__c,custDocId,null,String.valueOf(logMetadata.QTO_Return_Code__c),logMetadata.QTO_Return_Type__c);
						  }
						//create CDLI and QLI junction object record
						QTO_AutomateAssociationHelper.finalQLIForAssociationCDLIMap.put(custDocLineItem.id,qLIList);
					} 
					else{
						//QTO_Utility.createLogs('No Corresponding QuoteLineITem found ',custDocId, custDocLineItem.id);  
						 // QTO_Exception_Configuration__mdt logMetadata = new QTO_Exception_Configuration__mdt();
						  //logMetadata = QTO_Utility.fetchLogMetadata(421);
						  //QTO_Utility.createLogs(logMetadata.QTO_Return_Description__c,custDocId,null,String.valueOf(logMetadata.QTO_Return_Code__c),logMetadata.QTO_Return_Type__c);
					}
				}else{
					//QTO_Exception_Configuration__mdt logMetadata = new QTO_Exception_Configuration__mdt();
						  //logMetadata = QTO_Utility.fetchLogMetadata(421);
						  //QTO_Utility.createLogs(logMetadata.QTO_Return_Description__c,custDocId,null,String.valueOf(logMetadata.QTO_Return_Code__c),logMetadata.QTO_Return_Type__c);
						  
					//QTO_Utility.createLogs('Site or Product Code doesnt exist ',custDocId, custDocLineItem.id);  
				}
			}  //CDLI for loop End
			if(qLIForAssociationCDLI.size()<custDocLineItemList.size()){
				//QTO_Exception_Configuration__mdt logMetadata = new QTO_Exception_Configuration__mdt();
				//logMetadata = QTO_Utility.fetchLogMetadata(421);
				//QTO_Utility.createTask(custDocId,logMetadata.QTO_Return_Description__c,logMetadata.QTO_Return_Code__c,logMetadata.QTO_Task_Subject__c,logMetadata.QTO_Tasks_Priority__c,logMetadata.QTO_Tasks_Due_Date__c,logMetadata.QTO_Tasks_Status__c,logMetadata.QTO_Investigating_Group__c);
			}
			qLIForAssociationCDMap.put(custDocId, qLIForAssociationCDLI);
		} //CD for loop End
		return qLIForAssociationCDMap;
	}

	/**
	* @description: This method get siteCodeValue -Example of Value of Site could be 920110 ISSY LES MX (CENTRE)
	* This method would fetch characters after first space.
	* @author Akanksha Triveri
	* @param site 
	* @return String 
	**/
	public static String getSiteCode(String site){
		
		if(site == null)
			return null;
		
		List<String> siteData  = site.split(' ');
		String siteCode = null;
		
		if(siteData != null && siteData[0] != null){
			siteCode = siteData[0];
		}
		return siteCode;
		
	}

	/**
	* @description : create record for CDLI to QLI junction object
	* @author Akanksha Triveri
	* @param qLICDLIMap 
	* @return List<QTO_Customer_Document_Quote_Line__c> 
	**/
	public static List<QTO_Customer_Document_Quote_Line__c> getCustDocLineItemQuoteLine(Map<Id,List<Apttus_Proposal__Proposal_Line_Item__c>> qLICDLIMap){
		List<QTO_Customer_Document_Quote_Line__c> jnObjList = new List<QTO_Customer_Document_Quote_Line__c>();
		for(Id cdLinetItemId : qLICDLIMap.keySet()){
			for(Apttus_Proposal__Proposal_Line_Item__c qLI :qLICDLIMap.get(cdLinetItemId)){			
				QTO_Customer_Document_Quote_Line__c junctionObj = new QTO_Customer_Document_Quote_Line__c();
				junctionObj.QTO_Customer_Document_Line_Items__c =cdLinetItemId;  
				junctionObj.QTO_Proposal_Line_Item__c =  qLI.id;  
				jnObjList.add(junctionObj);
			}	  
		}	
		return jnObjList;   
	}

   /**
   * @description : Associate Agreements to Customer Document
   * @author Akanksha Triveri
   * @param customerDocId 
   * @param agreementIdList 
   * @param mapAgreementWrapper 
   * @return List<QTO_Customer_Document_Agreement__c> 
   **/
   public static List<QTO_Customer_Document_Agreement__c> associateAgreementWithCD( Id customerDocId, Set<Id> agreementIdList,Map<Id,QTO_AssociationOutputWrapper.AgreementAssociationWrapper> mapAgreementWrapper){
	   
	// insert the junction object record
		List<QTO_Customer_Document_Agreement__c> associationRecordList = new  List<QTO_Customer_Document_Agreement__c>();
		system.debug('agreementIdList---->'+agreementIdList);
		system.debug('mapAgreementWrapper---->'+mapAgreementWrapper);
	   for(Id agreementId :agreementIdList){
		  QTO_Customer_Document_Agreement__c associationRecord = new QTO_Customer_Document_Agreement__c();
				associationRecord.QTO_Customer_Document__c= customerDocId;
				associationRecord.QTO_Agreement__c = agreementId;
				associationRecordList.add(associationRecord);
			   if(mapAgreementWrapper.containsKey(agreementId)){
				   associationRecord.QTO_Source__c = mapAgreementWrapper.get(agreementId).source;
				   associationRecord.QTO_Agreement_Ref_in_PDF__c = mapAgreementWrapper.get(agreementId).reference;
			   }
		}	
		system.debug('associationRecordList--->'+associationRecordList);
		return associationRecordList;
	}
	
	  /**
	  * @description : directly associate the quote ref to CD
	  * @author Akanksha Triveri
	  * @param custDocId 
	  * @param quoteIds 
	  * @return Set<Id> 
	  **/
	  public static Set<Id> callAssociationCDToQuotes(Id custDocId,Set<Id> quoteIds){
		List<Customer_facing_Attribute__c> cFAList = new List<Customer_facing_Attribute__c>();
		Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>> filteredQLIMap =new Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>>();   
		Map<Id,Set<Id>> qLIForAssociationCDMap = new Map<Id,Set<Id>>();
		 Map<Id,List<Customer_Document_Line_Items__c>> custDocLineItemMap = new Map<Id,List<Customer_Document_Line_Items__c>>();	 
		 // map of CDO - CDLI List
		 custDocLineItemMap = getAllCDLIfromCDOId(custDocId);  
		  system.debug('HS***1 CDLI Map' + custDocLineItemMap);
		  //get CFA lines based on quote set and filters
		cFAList = getAllFilteredQLIList(null,quoteIds,false);
		system.debug('HS***2' + cFAList);
		  System.debug('CFA Size: '+cFAList.size());
		// create map of filtered QLI - KEY, list of QLI
		filteredQLIMap = createFilteredQLIMap(cFAList); 
		 system.debug('HS***3 QLI MAP' + filteredQLIMap);
		  System.debug('Map Keys: '+filteredQLIMap.keySet());
		// to match the CDLI records from QLI record 
		qLIForAssociationCDMap = fetchMatchedQLIfromCDLI(custDocLineItemMap,filteredQLIMap);
		  // return Set of Quote Ids to be mapped
		return qLIForAssociationCDMap.get(custDocId);  
		 
	  }
   
	 /**
	 * @description : associate the quotes  to CD
	 * @author Akanksha Triveri
	 * @param custId 
	 * @param quoteIdSet 
	 * @param mapMatchedQuoteReferences 
	 * @return List<Customer_Document_Junction__c> 
	 **/
	 public static List<Customer_Document_Junction__c> associateQuoteWithCD( Id custId ,Set<Id> quoteIdSet,Map<Id,String> mapMatchedQuoteReferences){
		// insert the junction object record
		System.debug('Received quote IDs to associate: '+quoteIdSet);
		List<Customer_Document_Junction__c> associationRecordList = new  List<Customer_Document_Junction__c>();
		 for(Id quoteId :quoteIdSet){			 
			Customer_Document_Junction__c associationRecord = new Customer_Document_Junction__c();
				associationRecord.Customer_Document__c = custId;
				associationRecord.Quote_Proposal__c = quoteId;
				 if(mapMatchedQuoteReferences.containsKey(quoteId)){
					 associationRecord.QTO_Quote_Ref_in_PDF__c = mapMatchedQuoteReferences.get(quoteId);
				 }
				associationRecordList.add(associationRecord);
		}	
		return associationRecordList;
	}
  
}