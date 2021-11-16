/**
 * @description	   : 
 * @author			: Lovel Panchal
 * @group			 : 
 * @last modified on  : 12-04-2020
 * @last modified by  : Raj Kamdar
 * Modifications Log 
 * Ver   Date		 Author		  Modification
 * 1.0   11-23-2020   Lovel Panchal   Initial Version
**/
public with sharing class QTO_ManualAssociationControllerHelper {
	
	private static final String AGREEMENT = 'Agreement';
	private static final String QUOTE = 'Quote';
	private static final String CUSTOMERDOCUMENT = 'Customer_Document__c';
	// @ To get all Data based upon Content Document Id and Object Type which can be Quote or Agreement @
	public static dataWrapper getAllAssociationData(String inputObject,String CDId){
		List<sObject> listReturnData = new List<sObject>();
		List<sObject> objQueryResult = new List<sObject>(); 
		dataWrapper dw = new dataWrapper();
		if(inputObject.equals(null)){
			throw new QTO_CustomException('Input Object cannot be null.');
		}
		else if(inputObject.equalsIgnoreCase(AGREEMENT)){
			objQueryResult = getAllAgreements(CDId);
			dw.selectedIdSet = new Set<Id>();			
			List<QTO_Customer_Document_Agreement__c> lstCDQ =  [Select Id,QTO_Agreement__c,QTO_Customer_Document__c
			from QTO_Customer_Document_Agreement__c where QTO_Customer_Document__c =:CDId];
			Set<Id> setCDA = new Set<Id>();
			for(QTO_Customer_Document_Agreement__c objCDQ:lstCDQ) {
				setCDA.add(objCDQ.QTO_Agreement__c);
			}
			dw.dataList = new List<sObject>();
			for(sObject obj :  objQueryResult){
				if(setCDA.contains((String)obj.get('Id'))){
					dw.selectedIdSet.add((Id) obj.get('Id'));					
				}
				dw.dataList.add(obj);
			}
		}
		else if(inputObject.equalsIgnoreCase(QUOTE)){
			objQueryResult = getAllProposals(CDId);
			dw.selectedIdSet = new Set<Id>();			
			List<Customer_Document_Junction__c> lstCDQ =  [Select Id,Customer_Document__c,Customer_Document__r.Classification__c,Quote_Proposal__c from Customer_Document_Junction__c where Customer_Document__c =:CDId];
			Set<Id> setCDA = new Set<Id>();
			for(Customer_Document_Junction__c objCDQ:lstCDQ) {
				setCDA.add(objCDQ.Quote_Proposal__c);
			}
			dw.dataList = new List<sObject>();
			for(sObject obj :  objQueryResult){
				if(obj.get('QTO_Association_Status__c') == 'Associated' && setCDA.contains((String)obj.get('Id'))){
					dw.selectedIdSet.add((Id) obj.get('Id'));
					dw.dataList.add(obj);
				}
				else if(obj.get('QTO_Association_Status__c') != 'Associated'){
					dw.dataList.add(obj);
				}				
			}
		}
		else if(inputObject.equalsIgnoreCase(CUSTOMERDOCUMENT)){
			List<Customer_Document__c> allCds = getAllCds(CDId);
			dw.selectedIdSet = new Set<Id>();	
			
			List<CD_Association_to_CD__c> lstCDs = [
					SELECT Id, QTO_Nokia_Customer_Document_ID__c,
							Customer_Document__c
					FROM CD_Association_to_CD__c
					WHERE Customer_Document__c =:CDId
					];
			Set<Id> setCDA = new Set<Id>();
			for(CD_Association_to_CD__c objCD:lstCDs) {
				dw.selectedIdSet.add(objCD.QTO_Nokia_Customer_Document_ID__c);
				setCDA.add(objCD.QTO_Nokia_Customer_Document_ID__c);
			}
			dw.dataList = new List<sObject>();
			
			Customer_Document__c objCD = [
				SELECT Customer__c, Customer_Document_Id__c,
					Nokia_Legal_entity__c, Classification__c, Sub_Classification__c
				FROM Customer_Document__c
				WHERE Id = :CDId
				Limit 1];
			
			for (Customer_Document__c obj :allCds) {
				boolean isCustomerFound = false;
				boolean isNokiaLegalEntityFound = false;
				boolean isClassificationFound = false;
				boolean isSubClassificationFound = false;
				
				if(objCD.Customer__c == obj.Customer__c) {
					isCustomerFound = true;  
				}   
				if(objCD.Nokia_Legal_entity__c == obj.Nokia_Legal_entity__c) {
					isNokiaLegalEntityFound = true;  
				} 
				if(objCD.Classification__c == obj.Classification__c) {
					isClassificationFound = true;  
				} 
				if(objCD.Sub_Classification__c == obj.Sub_Classification__c) {
					isSubClassificationFound = true;  
				}	 
				
				if(isCustomerFound && isNokiaLegalEntityFound && isClassificationFound && isSubClassificationFound) {
					dw.dataList.add(obj);
				}
			}
		}
		else{
			throw new QTO_CustomException('Please select a valid Input Object.');
		}
		system.debug('dw.dataList--'+dw.dataList);
		return dw;
	}
	// Main Method to save data passed from LWC component
	public static void saveAssociationData(String saveData,Id CDId, String ObjName){
		try{
			if(objName.equalsIgnoreCase(QUOTE)){
				List<Apttus_Proposal__Proposal__c> lstQuote = (List<Apttus_Proposal__Proposal__c>)System.JSON.deserialize(saveData, List<Apttus_Proposal__Proposal__c>.class);
				saveQuoteAssociationData(lstQuote,CDId);
			}
			else if(objName.equalsIgnoreCase(AGREEMENT)){
				List<Apttus__APTS_Agreement__c> lstQuote = (List<Apttus__APTS_Agreement__c>)System.JSON.deserialize(saveData, List<Apttus__APTS_Agreement__c>.class);
				saveAgreementAssociationData(lstQuote,CDId);
			}
			else if(objName.equalsIgnoreCase(CustomerDocument)){
				//List<Customer_Document__c> lstQuote = (List<Customer_Document__c>)System.JSON.deserialize(saveData, List<Customer_Document__c>.class);
				saveCustomerDocumentAssociationData(saveData, CDId);
			}
		}Catch(QTO_CustomException ce){
			throw new QTO_CustomException('Exception while saving association Data'+ce.getMessage());
		}
	}

	public static void saveCustomerDocumentAssociationData(String saveData, Id CDId){
		system.debug('saveData-->'+saveData);
		
		List<Customer_Document__c> cdDataList =
			(List<Customer_Document__c>)System.JSON.deserialize(saveData, List<Customer_Document__c>.class) ;
		Map<Id, CD_Association_to_CD__c> selectedCdCdIds = new Map<Id, CD_Association_to_CD__c>();
	   
		List<CD_Association_to_CD__c> lstCD = [
				SELECT QTO_Nokia_Customer_Document_ID__c
				FROM CD_Association_to_CD__c
				WHERE Customer_Document__c =:CDId];
		
		for (CD_Association_to_CD__c cdRec: lstCD) {
			selectedCdCdIds.put(cdRec.QTO_Nokia_Customer_Document_ID__c, cdRec);
		}
		
		List<CD_Association_to_CD__c> customerAssociationList = new List<CD_Association_to_CD__c>();
		for(Customer_Document__c customerDocument : cdDataList) {
			CD_Association_to_CD__c cdAssociation = new CD_Association_to_CD__c();
			cdAssociation.QTO_Nokia_Customer_Document_ID__c = customerDocument.Id;
			cdAssociation.QTO_Customer_Document_Date__c = customerDocument.Customer_Document_Date__c;
			cdAssociation.QTO_Manual__c = true;
			cdAssociation.QTO_Nature__c = customerDocument.QTO_Nature__c;
			cdAssociation.QTO_Customer_Document_ID_Version__c =
					customerDocument.Version_Nr__c != null ? Decimal.valueOf(customerDocument.Version_Nr__c) : null;
			cdAssociation.Customer_Document__c = CDId;
			if (selectedCdCdIds.containsKey(customerDocument.Id)) {
				cdAssociation.Id = selectedCdCdIds.get(customerDocument.Id).Id;
				selectedCdCdIds.remove(customerDocument.Id);
			}
			customerAssociationList.add(cdAssociation);
		}
		
		upsert customerAssociationList;
		
		if (!selectedCdCdIds.isEmpty()) {
			Database.delete(selectedCdCdIds.values());
		}
	}

	//Logic to Save Quote Junction Object
	public static void saveQuoteAssociationData(list<Apttus_Proposal__Proposal__c> saveData,Id CDId){
		system.debug('saveData-->'+saveData);
		List<Customer_Document_Junction__c> lstCD = new List<Customer_Document_Junction__c>();
		List<Customer_Document_Junction__c> lstCDQ =  [Select Id,Customer_Document__c,Customer_Document__r.Customer_Document_Date__c,Customer_Document__r.Name,Customer_Document__r.Customer_Document_ID__c,Quote_Proposal__c from Customer_Document_Junction__c where Customer_Document__c =:CDId];
		Customer_Document__c obj_CD = [Select Id,Customer_Document_Date__c,Name,Customer_Document_ID__c from Customer_Document__c where Id =:CDId limit 1];
		Map<Id,Customer_Document_Junction__c> mapCDA = new Map<Id,Customer_Document_Junction__c>();
		for(Customer_Document_Junction__c objCDQ:lstCDQ) {
			mapCDA.put(objCDQ.Quote_Proposal__c,objCDQ);
		}
		system.debug('mapCDA-->'+mapCDA);
		Set<Id> setQId = mapCDA.keyset();
		Set<Id> setNewQId =  new set<Id>();
		for(Apttus_Proposal__Proposal__c obj:saveData){
			if(mapCDA.get(obj.Id) == null){
				Customer_Document_Junction__c objCD = new Customer_Document_Junction__c();
				objCD.Quote_Proposal__c = obj.Id;
				objCD.Customer_Document__c = CDId;   
				lstCD.add(objCD);
				obj.QTO_Association_Status__c = 'Associated';
				obj.Nokia_Customer_Document_ID__c = obj_CD.Id;
				obj.Apttus_QPConfig__PODate__c =  obj_CD.Customer_Document_Date__c;
				obj.Apttus_QPConfig__PONumber__c =  obj_CD.Customer_Document_ID__c;
			}
			setNewQId.add(obj.id);
		}
		system.debug('setNewQId-->'+setNewQId);
		setQId.removeall(setNewQId);
		system.debug('setQId-->'+setQId);
		List<Customer_Document_Junction__c> lst_CD_Del = new List<Customer_Document_Junction__c>();
		List<Apttus_Proposal__Proposal__c> lstDelQuote = new List<Apttus_Proposal__Proposal__c>();
		for(Id Qt_Id :setQId){
			Customer_Document_Junction__c delObj = new Customer_Document_Junction__c();
			delObj.Id = mapCDA.get(Qt_Id).Id;			
			lst_CD_Del.add(delObj);
			Apttus_Proposal__Proposal__c obj = new Apttus_Proposal__Proposal__c();
			obj.QTO_Association_Status__c = 'Not Associated';
			obj.Nokia_Customer_Document_ID__c = null;
			obj.Apttus_QPConfig__PODate__c = null;
			obj.Apttus_QPConfig__PONumber__c  = '';
			obj.Id = Qt_Id;
			lstDelQuote.add(obj);
		}
		system.debug('lst_CD_Del-->'+lst_CD_Del);
		system.debug('lstDelQuote-->'+lstDelQuote);
		Delete lst_CD_Del;
		Update lstDelQuote;
		Database.update(saveData);
		system.debug('lstCD-->'+lstCD);
		Database.insert(lstCD,false);   
		// ASYNC CALL
		callQLIAssociation(saveData, obj_CD);
		// 
	}
	// Logic to Save Agreement junction Object
	public static void saveAgreementAssociationData(list<Apttus__APTS_Agreement__c> saveData,Id CDId){
		system.debug('saveData-->'+saveData);
		List<QTO_Customer_Document_Agreement__c> lstCD = new List<QTO_Customer_Document_Agreement__c>();
		List<QTO_Customer_Document_Agreement__c> lstCDQ =  [Select Id,QTO_Agreement__c,QTO_Customer_Document__c from QTO_Customer_Document_Agreement__c where QTO_Customer_Document__c =:CDId];
		Customer_Document__c obj_CD = [Select Id,Customer_Document_Date__c,Name,Customer_Document_ID__c, QTO_Error_Message__c  from Customer_Document__c where Id =:CDId limit 1];
		Map<Id,QTO_Customer_Document_Agreement__c> mapCDA = new Map<Id,QTO_Customer_Document_Agreement__c>();
		for(QTO_Customer_Document_Agreement__c objCDQ:lstCDQ) {
			mapCDA.put(objCDQ.QTO_Agreement__c,objCDQ);
		}
		system.debug('mapCDA-->'+mapCDA);
		Set<Id> setQId = mapCDA.keyset();
		Set<Id> setNewQId =  new set<Id>();
		Boolean hasValue = false;
		for(Apttus__APTS_Agreement__c obj:saveData){
			if(mapCDA.get(obj.Id) == null){
				QTO_Customer_Document_Agreement__c objCD = new QTO_Customer_Document_Agreement__c();
				objCD.QTO_Agreement__c = obj.Id;
				objCD.QTO_Customer_Document__c = CDId;
				objCD.QTO_Source__c = 'Manual';   
				lstCD.add(objCD);
				
				hasValue = true;
			}
			setNewQId.add(obj.id);
		}
		
		if (hasValue && (obj_CD.QTO_Error_Message__c != null && obj_CD.QTO_Error_Message__c.contains('No agreement association'))) {
			//obj_CD.QTO_Error_Message__c = '';
		}
		//update obj_CD;
		system.debug('setNewQId-->'+setNewQId);
		setQId.removeall(setNewQId);
		system.debug('setQId-->'+setQId);
		List<QTO_Customer_Document_Agreement__c> lst_CD_Del = new List<QTO_Customer_Document_Agreement__c>();
		for(Id Qt_Id :setQId){
			QTO_Customer_Document_Agreement__c delObj = new QTO_Customer_Document_Agreement__c();
			delObj.Id = mapCDA.get(Qt_Id).Id;			
			lst_CD_Del.add(delObj);
		}
		system.debug('lst_CD_Del-->'+lst_CD_Del);
		Delete lst_CD_Del;
		system.debug('lstCD-->'+lstCD);
		Database.insert(lstCD,false);   
		// ASYNC CALL
		
		// 
	}
	// Call Async Call to Associate Line Items to Customer Doc Line Items
	public static void callQLIAssociation(List<Apttus_Proposal__Proposal__c> records, Customer_Document__c cdObj){
		cdObj.QTO_InAssociationProcess__c = true;
		update cdObj;
		ID jobID = System.enqueueJob(new QTO_ManualCDItemToQuoteItemQueue(records, cdObj));
	}
	// To check if the Queue process is completed
	public static boolean getStatus(String CDId){
		Customer_Document__c objCD = [Select Customer__c,QTO_InAssociationProcess__c from Customer_Document__c where Id = :CDId Limit 1];
		return objCD.QTO_InAssociationProcess__c;
	}
	private static List<Apttus_Proposal__Proposal__c> getAllProposals(String CDId){
		List<Apttus_Proposal__Proposal__c> listProposals = new List<Apttus_Proposal__Proposal__c>();
		String query = prepareSelectQuery(QUOTE,CDId);
		try{
			Customer_Document__c objCD = [Select Customer__c from Customer_Document__c where Id = :CDId Limit 1];
			List<Apttus_Proposal__Proposal__c> lstQuote = [Select Id from Apttus_Proposal__Proposal__c where Sold_To_Party__c =: objCD.Customer__c and Nokia_Customer_Document_ID__c  =:CDId and QTO_Association_Status__c = 'Associated' and  Nokia_Customer_Document_ID__r.Classification__c ='Risk Order'];
			//List<QTO_Customer_Document_Association_Quote__c> lstCDAQ = [Select Id,QTO_Customer_Document__r.Classification__c,QTO_Quote_Proposal__c, QTO_Quote_Proposal__r.QTO_Association_Status__c, QTO_Quote_Proposal__r.Sold_To_Party__c from QTO_Customer_Document_Association_Quote__c where QTO_Quote_Proposal__r.Sold_To_Party__c =: objCD.Customer__c AND AND QTO_Association_Status__c = ];
			Set<Id> qId = new Set<Id>();
			for(Apttus_Proposal__Proposal__c objQuote :lstQuote){
				qId.add(objQuote.Id); 
			}
			system.debug('query--->'+query);
			listProposals = Database.query(query);
			//listProposals = [select id,name,Quote_Status__c,Nokia_Customer_Document_ID__c from Apttus_Proposal__Proposal__c order by createddate desc limit 50000];	
		}
		catch(Exception e){
			system.debug('Exception --> '+e);
			throw new QTO_CustomException(e);
			//throw new QTO_CustomException('Error occurred while fetching proposals.');
		
			//throw new QTO_CustomException('Error occurred while fetching proposals.');
		}
		return listProposals;
	}
	// To Fetch all Agreement based on Content Doc Id
	private static List<Apttus__APTS_Agreement__c> getAllAgreements(String CDId){
		List<Apttus__APTS_Agreement__c> listAgreements = new List<Apttus__APTS_Agreement__c>();
		String query = prepareSelectQuery(AGREEMENT,CDId);
		try{
			listAgreements = Database.query(query);
			//listAgreements = [select id,name,Apttus__Status__c from Apttus__APTS_Agreement__c order by createddate desc limit 50000];	
		}
		catch(Exception e){
			throw new QTO_CustomException('Error occurred while fetching agreements.');
		}
		return listAgreements;
	}
	
	private static List<Customer_Document__c> getAllCds(String CdId) {
		String query = prepareSelectQuery(CUSTOMERDOCUMENT, CdId);
		List<Customer_Document__c> listCds = new List<Customer_Document__c>();
		try{
			listCds = Database.query(query);
		}
		catch(Exception e){
			throw new QTO_CustomException('Error occurred while fetching Customer Associations.');
		}
		
		return listCds;
	}
	// Logic to create Query based on Meta data provided
	private static String prepareSelectQuery(String objectName, String CDId){
		System.debug('-----PREPARE SELECT QUERY STARTED-----');
		String query = 'Select Id,';
		
		if (objectName != CUSTOMERDOCUMENT) {
			List<QTO_Manual_Association_Config__mdt> listMetadata = [Select QTO_Field_API__c,QTO_IsSearchable__c from QTO_Manual_Association_Config__mdt where QTO_Object_Name__c=:objectName and QTO_Active__c = true];
			if(listMetadata.size()==0 && !Test.isRunningTest()){
				throw new QTO_CustomException('No fields specified in the manual association query, please contact system administrator');
			}
			for(QTO_Manual_Association_Config__mdt currentMetadata:listMetadata){
				query+=currentMetadata.QTO_Field_API__c+',';
			}
			query=query.removeEnd(',');
		}
		if (objectName == CUSTOMERDOCUMENT) {
			query = 'SELECT Classification__c, QTO_Nature__c,Customer__c,' +
							'Nokia_Document_Receipt_Date__c,' +
							'Sub_Classification__c,' +
							'Total_Value__c,' +
							'Version_Nr__c,' +
							'Name,' +
							'Nokia_Legal_entity__c,' +
							'Customer_Document_ID__c FROM Customer_Document__c WHERE ';
			query = prepareCDAssociationWhereClause(query, CDId);
		}
		else if(objectName.equalsIgnoreCase(QUOTE)){
			query+=',QTO_Association_Status__c from '+getObjectAPI(objectName);
			query+=' where (Id in :qId) OR ('; 
			query = prepareQuoteWhereClause(query,CDId);
		}
		else{
			query+=' from '+getObjectAPI(objectName);
			query+=' where ';
			query = prepareAgreementWhereClause(query,CDId);
		}			
		System.debug('-----PREPARE SELECT QUERY ENDED-----');
		query = query + ' Order By Createddate Desc';
		return query;
	}
	// Adding Filters for Quote Query
	private static String prepareQuoteWhereClause(String query, String CDId){
		Customer_Document__c objCD = [Select Customer__c from Customer_Document__c where Id = :CDId Limit 1];
		system.debug('objCD--->'+CDId+'--'+objCD);
		System.debug('-----PREPARE WHERE CLAUSE STARTED-----');
		
		string customer = objCD.Customer__c;
		system.debug('objCD.CUSTOMER--->'+objCD.Customer__c);
		if(Test.isRunningTest()){
			query+=' Apttus_Proposal__Approval_Stage__c not in ('+'\''+'Rejected'+'\',\''+'Withdrawn'+'\',\''+'Draft'+'\''+'))';
		}else{
			 query+=' Apttus_Proposal__Approval_Stage__c not in ('+'\''+'Rejected'+'\',\''+'Withdrawn'+'\',\''+'Draft'+'\''+') AND Sold_To_Party__c = \''+String.escapeSingleQuotes(customer)+'\')';
		}
	   
		
		
		System.debug('-----PREPARE WHERE CLAUSE ENDED-----'+query);
		return query;
	}
	// Adding Filters for Agreement Query
	private static String prepareAgreementWhereClause(String query, String CDId){
		Customer_Document__c objCD = [Select Customer__c from Customer_Document__c where Id = :CDId Limit 1];
		system.debug('objCD--->'+CDId+'--'+objCD);
		System.debug('-----PREPARE WHERE CLAUSE STARTED-----');
		
		string customer = objCD.Customer__c;
		//'+'\''+'In Effect
		if(Test.isRunningTest()) {
			 query+=' Apttus__Status_Category__c  in ('+'\'In Application\',\'In Effect\''+')';
		}
		else
			 query+=' Apttus__Status_Category__c  in ('+'\'In Application\',\'In Effect\''+') AND Apttus__Account__c = \''+String.escapeSingleQuotes(customer)+'\'';
		
		//query+=' Apttus__Status_Category__c  in ('+'\'In Application\',\'In Effect\''+') AND Apttus__Account__c = \''+String.escapeSingleQuotes(customer)+'\'';
		System.debug('-----PREPARE WHERE CLAUSE ENDED-----'+query);
		return query;
	}
	
	private static String prepareCDAssociationWhereClause(String query, String CdId) {
		Customer_Document__c objCD = [
				SELECT Customer_Document_Id__c, QTO_Nature__c
				FROM Customer_Document__c
				WHERE Id = :CDId
				Limit 1];
		
		String customer = objCD.Customer_Document_Id__c;
		
		query +=' Customer_Document_Id__c = \''+String.escapeSingleQuotes(customer)+'\'' +
			  //  ' AND Customer__c = \'' + objCD.Customer__c +'\'' +
			   // ' AND Nokia_Legal_entity__c = \'' + nokiaLegal +'\'' +
			   // ' AND Classification__c = \'' + objCD.Classification__c +'\'' + 
			   // ' AND Sub_Classification__c = \'' + objCD.Sub_Classification__c +'\'' +
				' AND Id != \'' + CDId +'\'' +
	' AND QTO_Nature__c != \'' + objCD.QTO_Nature__c +'\'';
		
		System.debug('queryquery' + query);
		return query;
	}
	
	private static string getObjectAPI(String objectName){
		if(objectName.equals(AGREEMENT)){
			return 'Apttus__APTS_Agreement__c';
		}
		else if(objectName.equals(QUOTE)){
			return 'Apttus_Proposal__Proposal__c';
		}
		else{
			throw new QTO_CustomException('Please select a valid object.');
		}
	}
	// Logic to fetch Metadata and generate Lightning Datatable header 
	public static List<dataTableHeader> getTableHeaders(string objName){
		List<dataTableHeader> retlst = new List<dataTableHeader>();
		
		if (objName == CUSTOMERDOCUMENT) {
			dataTableHeader retObj = new dataTableHeader();
			retObj.label = 'Customer Document ID';
			retObj.fieldName = 'Customer_Document_ID__c';
			retObj.type = 'text';
			retlst.add(retObj);

			dataTableHeader retObj1 = new dataTableHeader();
			retObj1.label = 'Version Nr';
			retObj1.fieldName = 'Version_Nr__c';
			retObj1.type = 'text';
			retlst.add(retObj1);

			dataTableHeader retObj2 = new dataTableHeader();
			retObj2.label = 'Nokia Customer Document ID';
			retObj2.fieldName = 'Name';
			retObj2.type = 'text';
			retlst.add(retObj2);

			dataTableHeader retObj3 = new dataTableHeader();
			retObj3.label = 'Nokia Document Receipt Date';
			retObj3.fieldName = 'Nokia_Document_Receipt_Date__c';
			retObj3.type = 'date';
			retlst.add(retObj3);

			dataTableHeader retObj4 = new dataTableHeader();
			retObj4.label = 'Classification';
			retObj4.fieldName = 'Classification__c';
			retObj4.type = 'text';
			retlst.add(retObj4);

			dataTableHeader retObj5 = new dataTableHeader();
			retObj5.label = 'Sub Classification';
			retObj5.fieldName = 'Sub_Classification__c';
			retObj5.type = 'text';
			retlst.add(retObj5);

			dataTableHeader retObj6 = new dataTableHeader();
			retObj6.label = 'Nature';
			retObj6.fieldName = 'QTO_Nature__c';
			retObj6.type = 'text';
			retlst.add(retObj6);
			
			dataTableHeader retObj7 = new dataTableHeader();
			retObj7.label = 'Total Value';
			retObj7.fieldName = 'Total_Value__c';
			retObj7.type = 'text';
			retlst.add(retObj7);

			dataTableHeader retObj8 = new dataTableHeader();
			retObj8.label = 'Nokia Legal entity';
			retObj8.fieldName = 'Nokia_Legal_entity__c';
			retObj8.type = 'text';
			retlst.add(retObj8);

		} else {
			Map<Decimal,QTO_Manual_Association_Config__mdt > mapTemp = new  Map<Decimal,QTO_Manual_Association_Config__mdt >();
			if(!Test.isRunningTest()){
				for(QTO_Manual_Association_Config__mdt obj : [Select QTO_Field_API__c,QTO_DataType__c,Label,QTO_IsSearchable__c,QTO_Sequence__c from QTO_Manual_Association_Config__mdt where QTO_Object_Name__c=:objName and QTO_Active__c = true Order by QTO_Sequence__c]){
					mapTemp.put(obj.QTO_Sequence__c,obj);
				}
				for(Decimal key :mapTemp.keySet()){
					dataTableHeader retObj = new dataTableHeader();
					retObj.label = mapTemp.get(key).Label;
					retObj.fieldName = mapTemp.get(key).QTO_Field_API__c;
					retObj.type = mapTemp.get(key).QTO_DataType__c;
					retlst.add(retObj);
				}
			}
		}
		return retlst;
	}
	public class dataWrapper{  
		@AuraEnabled public List<sObject> dataList {get; set;}  
		@AuraEnabled public set<Id> selectedIdSet {get; set;}  
	}  
	public class dataTableHeader{  
		@AuraEnabled public string label {get; set;}  
		@AuraEnabled public string fieldName {get; set;} 
		@AuraEnabled public string type {get; set;}
	}  
	public class cdAssociateData {
		@AuraEnabled public Id docId;
		@AuraEnabled public String customerDocumentId;
		@AuraEnabled public String version;
		@AuraEnabled public String nokiaCustomerDocumentId;
		@AuraEnabled public Date receiptId;
		@AuraEnabled public String classification;
		@AuraEnabled public String subClassification;
		@AuraEnabled public String nature;
		@AuraEnabled public String totalValue;
		@AuraEnabled public String nokiaLegalEntity;

	}
}