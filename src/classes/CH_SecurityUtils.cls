/** 
 * About 
 * ----- 
 * @Description   : Case Handling Security Utility Class. 
 * @TestClass	: CH_SecurityUtils_Test.
 * @Project	: Case Handling.
 * @Modification Log : 
 *  Created  : 2019 10 30 – tiago.almeida@nokia.com
 * ----- 
**/
public without sharing class CH_SecurityUtils {
	
	/**
	 * @description : Method that checks if a user has one or all Permission Sets and Profile.
	 * @param	  : Id userId
	 * @param	  : String profileName
	 * @param	  : List<String> permissionSetList
	 * @param	  : Boolean mustHaveAll
	 * @return	: Boolean
	**/
	public static final string replacevalue ='\\b\\d{1,4}:\\d{0,4}:\\d{0,4}:\\d{0,4}:\\d{0,4}:\\d{0,4}:\\d{0,4}:\\d{3}\\.\\d{3}\\.\\d{3}\\.\\d{3}\\b';
	public static Boolean checkUserPermissions(Id userId, List<String> profileList, List<String> permissionSetList, Boolean mustHaveAll) {
		Boolean result = false;
		if(!profileList.isEmpty()) {
			List<User> oUserList = DML_SObject.doQuery(
	'SELECT Profile.Name ' +
	'FROM User ' +
	'WHERE Id = "' + userId  + '" AND Profile.Name in ' + DML_SObject.listToString(profileList)
			);
			result = !oUserList.isEmpty();
		}
		if(!permissionSetList.isEmpty()) {
			List<PermissionSetAssignment> oPermissionSetAssignmentList = DML_SObject.doQuery(
	'SELECT PermissionSet.Name ' +
	'FROM PermissionSetAssignment ' +
	'WHERE AssigneeId = "' + userId  + '" AND PermissionSet.Name in ' + DML_SObject.listToString(permissionSetList)
			);
			result = mustHaveAll ? result && oPermissionSetAssignmentList.size() == permissionSetList.size() : result || !oPermissionSetAssignmentList.isEmpty();
		}
		return result;
	}
	
	/**
	 * @description : Method that checks if a user has access to a specific object.
	 * @param	  : Id userId
	 * @param	  : Id ObjectId
	 * @param	  : Boolean hasRead
	 * @param	  : Boolean hasEdit
	 * @param	  : Boolean hasDelete
	 * @param	  : Boolean mustHaveAll
	 * @return	: Boolean
	**/
	public static Boolean checkUserAccess(Id userId, Id ObjectId, Boolean hasRead, Boolean hasEdit, Boolean hasDelete, Boolean mustHaveAll) {
		Boolean result = false;
		if(userId != null && ObjectId != null) {
			UserRecordAccess oURA = [
	SELECT RecordId, HasReadAccess, HasEditAccess, HasDeleteAccess, HasTransferAccess, MaxAccessLevel 
	FROM UserRecordAccess WHERE RecordId = :ObjectId AND UserId = :userId
			];
			result = hasRead ? (mustHaveAll ? (result && oURA.HasReadAccess) : (result || oURA.HasReadAccess)) : result;
			result = hasEdit ? (mustHaveAll ? (result && oURA.HasEditAccess) : (result || oURA.HasEditAccess)) : result;
			result = hasDelete ? (mustHaveAll ? (result && oURA.HasDeleteAccess) : (result || oURA.HasDeleteAccess)) : result;
		}
		return result;
	}
	
	/**
	 * @description : Method used to scramble any text field.
	 * @param	  : String value
	 * @return	: String value
	**/
	public static String scrambleText(String value) {
		if(value != null && value != '') {
			// Phones
			value = value.replaceAll('\\(\\d{3}\\)[^.:\n]?\\d{3}[^.:\n]?\\d{4}','(xxx) xxx xxxx');
			//MAC
			value = value.replaceAll(replacevalue,'xx:xxx:::x:x:xx:xxx.xxx.xxx.xxx');
			value = value.replaceAll(replacevalue,'xx:xxxx:x:x:xxx::xxxx:xxx.xxx.xxx.xxx');
			value = value.replaceAll(replacevalue,'xxxx:xxx:xxxx:xx:xxx::x:xxx.xxx.xxx.xxx');
			value = value.replaceAll(replacevalue,'xxxx:xxxx:::xxxx:xxxx:xx:xxx.xxx.xxx.xxx');
			value = value.replaceAll(replacevalue,'xxx:xxxx:x:xxx:x:xxxx::xxx.xxx.xxx.xxx');
			//806 new patterns added
			value = value.replaceAll('\\(\\d{3}\\)[^.:\n]?\\d{3}[^.:\n]?\\d{4}','(xxx)xxx xxxx');
			value = value.replaceAll('\\b\\d{3}\\b[^.:\n]?\\d{3}[^.:\n]?\\d{4}\\b','xxx xxx xxxx');
			value = value.replaceAll('\\b\\d{3}\\b[^.:\n]?\\d{4}\\b','xxx xxxx');
			//International Phone number		 
			value = value.replaceAll('\\+\\d{13}','+xxxxxxxxxxxxx');//+31235256677
			value = value.replaceAll('\\+\\d{12}','+xxxxxxxxxxxx');// +031235256677
			value = value.replaceAll('\\+\\d{11}','+xxxxxxxxxxx');//+0031235256677
			value = value.replaceAll('\\+\\(\\d{2}\\)\\d{9}','+(xx)xxxxxxxxx');//+(31)235256677
			value = value.replaceAll('\\+\\(\\d{3}\\)\\d{9}','+(xxx)xxxxxxxxx');//+(031)235256677
			value = value.replaceAll('\\+\\(\\d{4}\\)\\d{9}','+(xxxx)xxxxxxxxx');//+(0031)235256677
			value = value.replaceAll('\\+\\d{3}\\(\\d{1}\\)\\d{10}','+xxx(x)xxxxxxxxxx');//+31(0)235256677
			value = value.replaceAll('\\+\\d{2}\\(\\d{1}\\)\\d{9}','+xx(x)xxxxxxxxx');//+031(0)235256677
			value = value.replaceAll('\\+\\d{3}\\(\\d{1}\\)\\d{9}','+xxx(x)xxxxxxxxx');//+003(0)1235256677
			value = value.replaceAll('\\+\\(\\d{2}\\)\\(\\d{1}\\)\\d{9}','+(xx)(x)xxxxxxxxx');//+(31)(0)235256677
			value = value.replaceAll('\\+\\(\\d{3}\\)\\(\\d{1}\\)\\d{9}','+(xxx)(x)xxxxxxxxx');//+(031)(0)235256677
			value = value.replaceAll('\\+\\(\\d{4}\\)\\(\\d{1}\\)\\d{9}','+(xxxx)(x)xxxxxxxxx');//+(0031)(0)235256677
			value = value.replaceAll('\\b\\d{3}-\\d{7}\\b','xxx-xxxxxxx');//023-5256677
			value = value.replaceAll('\\b\\d{10}\\b','xxxxxxxxxx');//0235256677
			value = value.replaceAll('\\b\\d{2}\\s\\d{2}\\s\\d{2}\\s\\d{2}\\s\\d{2}\\b','xx xx xx xx xx');//01 47 87 11 11
			value = value.replaceAll('\\+\\d{2}\\s\\d{1}\\s\\d{2}\\s\\d{2}\\s\\d{2}\\s\\d{2}','+xx x xx xx xx xx');//+33 1 47 87 11 11
			value = value.replaceAll('\\+\\d{2}\\s\\(\\d{1}\\)\\d{1}\\s\\d{2}\\s\\d{2}\\s\\d{2}\\s\\d{2}','+xx (x)x xx xx xx xx');//+33 (0)1 47 87 11 11
			value = value.replaceAll('\\b\\d{1}\\s\\d{3}\\s\\d{2}\\s\\d{2}\\s\\d{2}','x xxx xx xx xx');//0 800 11 22 33
			value = value.replaceAll('\\b\\d{1}\\s\\d{3}\\s\\d{3}\\s\\d{3}','x xxx xxx xxx');//0 800 111 222
		}
		return value;
	}
	
	/**
	 * @description : Method used to set the right Security Groups to the Case.
	 * @param   : List<Case> newCaseList
	 * @param   : Map<Id, Case> oldCaseMap
	**/
	public static void setCaseSecurityGroups(List<Case> newCaseList, Map<Id, Case> oldCaseMap) {
		Set<Id> accountIdSet = new Set<Id>();
		Set<Id> productIdSet = new Set<Id>();
		List<Case> oCaseList = new List<Case>();
		//Get Valid Cases
		if(newCaseList != null && !newCaseList.isEmpty()){
			for(Case newCase : newCaseList) {
		Case oldCase = (oldCaseMap != null && oldCaseMap.containsKey(newCase.Id) ? oldCaseMap.get(newCase.Id) : null);
		if(((newCase.CH_RecordTypeCheck__c || newCase.HWS_RecordTypeCheck__c) && newCase.Status != 'Cancelled') && oldCase == null || (oldCase !=null && (newCase.ProductId != oldCase.ProductId || newCase.AccountId != oldCase.AccountId || newCase.Country__c != oldCase.Country__c || newCase.CH_LawfullIntercept_CALEA__c != oldCase.CH_LawfullIntercept_CALEA__c))) {			oCaseList.add(newCase);
			oCaseList.add(newCase);
			accountIdSet.add(newCase.AccountId);
			if(newCase.ProductId != null)productIdSet.add(newCase.ProductId);
		}
			} 
		}
		//
		if(!oCaseList.isEmpty()) {
			//Using Global/Common query as part of Code Optimization -- 27615
			Map<Id, Account> oAccountMap = !accountIdSet.isEmpty() ? CH_Utils.getAccountMap(accountIdSet) : null;
			//Using Global/Common query as part of Code Optimization -- 27616
			Map<Id, Product2> oProductMap = !productIdSet.isEmpty() ? CH_Utils.getProductMap(productIdSet) : null;
			List<CH_SecurityRule__c> oSecurityModelList = [
	SELECT Id, CH_SecurityGroup__c, CH_GWCSecurityGroup__c, CH_AccountNumber__c, CH_AccountCustomerCompliance__c, CH_ContractNumber__c,CH_LawfulInterceptCALEA__c,
		CH_NokiaProductId__c, CH_Country__c, CH_CARESServiceAgreement__c, CH_3rdPartySecurityGroup__c, CH_OrderofExecution__c
	FROM CH_SecurityRule__c WHERE CH_Active__c = true ORDER BY CH_OrderofExecution__c DESC
			];
			//Go through Cases and see if they correspond to the Custom Object Conditions
			for(Case oCase : oCaseList) {
	String sGWCSecurityGroup		= '';
	String sSecurityGroup	= '';
	String s3rdPartySecurityGroup   = '';
	Account oAccount = oCase.AccountId != null && oAccountMap.containsKey(oCase.AccountId)?oAccountMap.get(oCase.AccountId):null;
	if(oCase.CH_RecordTypeDevName__c != 'CH_Problem' && oAccount != null) {
		String sProductId = oCase.ProductId != null && oProductMap.containsKey(oCase.ProductId)?oProductMap.get(oCase.ProductId).NCP_Nokia_Product_Id__c:'';
		String sCustomerCompliance = oAccount.Customer_Compliance__c;
		//Custom Object Conditions
		for(CH_SecurityRule__c oSecurityModel : oSecurityModelList) {
			if((oSecurityModel.CH_AccountNumber__c != null || oSecurityModel.CH_AccountCustomerCompliance__c != null || oSecurityModel.CH_NokiaProductId__c != null || oSecurityModel.CH_Country__c != null
			|| oSecurityModel.CH_ContractNumber__c != null || oSecurityModel.CH_CARESServiceAgreement__c != null) && 
		(oSecurityModel.CH_AccountNumber__c == null || oSecurityModel.CH_AccountNumber__c == '' || smartCompare(oSecurityModel.CH_AccountNumber__c, oAccount.AccountNumber)) &&
		(oSecurityModel.CH_AccountCustomerCompliance__c == null || oSecurityModel.CH_AccountCustomerCompliance__c == '' || smartCompare(oSecurityModel.CH_AccountCustomerCompliance__c, sCustomerCompliance)) &&
		(oSecurityModel.CH_NokiaProductId__c == null || oSecurityModel.CH_NokiaProductId__c == '' || oCase.ProductId != null && smartCompare(oSecurityModel.CH_NokiaProductId__c, sProductId)) &&
		(oSecurityModel.CH_Country__c == null || oSecurityModel.CH_Country__c == '' || smartCompare(oSecurityModel.CH_Country__c, oCase.Country__c)) &&
		(oSecurityModel.CH_CARESServiceAgreement__c == null || oSecurityModel.CH_CARESServiceAgreement__c == '' || smartCompare(oSecurityModel.CH_CARESServiceAgreement__c, oCase.CH_CARES_ServiceAgreement__c)) &&
		(oSecurityModel.CH_ContractNumber__c == null || oSecurityModel.CH_ContractNumber__c == '' || smartCompare(oSecurityModel.CH_ContractNumber__c, oCase.CH_ServiceContractNumber__c))
		&& (oSecurityModel.CH_LawfulInterceptCALEA__c == oCase.CH_LawfullIntercept_CALEA__c)		
	)  {
		if(s3rdPartySecurityGroup == '' && oSecurityModel.CH_3rdPartySecurityGroup__c != '' && oSecurityModel.CH_3rdPartySecurityGroup__c != null) {
			s3rdPartySecurityGroup  = oSecurityModel.CH_3rdPartySecurityGroup__c;
		}
		else if(sGWCSecurityGroup == '' && sSecurityGroup == '') {
			sGWCSecurityGroup	= oSecurityModel.CH_GWCSecurityGroup__c != '' && oSecurityModel.CH_GWCSecurityGroup__c != null  ? oSecurityModel.CH_GWCSecurityGroup__c	 : sGWCSecurityGroup;
			sSecurityGroup	= oSecurityModel.CH_SecurityGroup__c != '' && oSecurityModel.CH_SecurityGroup__c != null		? oSecurityModel.CH_SecurityGroup__c		: sSecurityGroup;
		}
		if(s3rdPartySecurityGroup != '' && sGWCSecurityGroup != '' && sSecurityGroup != '') {
			break;
		}
	}
			}
		}
	oCase.CH_GWC_SecurityGroup__c   = sGWCSecurityGroup != '' ? sGWCSecurityGroup : Label.CH_CaseGenericGWCSecurityGroup;
	oCase.CH_SecurityGroup__c	= sSecurityGroup	!= '' ? sSecurityGroup  : Label.CH_CaseGenericSecurityGroup;
	if(oCase.CH_RecordTypeDevName__c != 'CH_Problem') oCase.CH_3rdPartySecurityGroup__c = s3rdPartySecurityGroup;
			}
			
		   
		}
 }
	/**
	 * @description : Method used to create a new Line for the Security Rules to match the renewal of the Service Contract.
	 * @param	  : List<ServiceContract> oServiceContractList
	**/
	public static void createNewSecurityRules(List<ServiceContract> oServiceContractList) {
		Id recordTypeId = Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
		Map<String, String> previousContractIdToServiceContractNumberMap = new Map<String, String>();
		for(ServiceContract oServiceContract : oServiceContractList) {
			if(oServiceContract.RecordTypeId.equals(recordTypeId) && oServiceContract.CH_CDB_PreviousContractId__c != null
			&& oServiceContract.CH_CDB_PreviousContractId__c != '' && !oServiceContract.CH_CDB_PreviousContractId__c.contains(',')) {
	previousContractIdToServiceContractNumberMap.put(oServiceContract.CH_CDB_PreviousContractId__c, oServiceContract.ContractNumber);
			}
		}
		if(!previousContractIdToServiceContractNumberMap.isEmpty()) {
			Map<String, String> previousContractNumberToServiceContractNumberMap = new Map<String, String>();
			for(ServiceContract previousServiceContract: [SELECT Id, ContractNumber, CH_CDB_ContractId__c FROM ServiceContract WHERE CH_CDB_ContractId__c IN :previousContractIdToServiceContractNumberMap.keySet()]) {
	previousContractNumberToServiceContractNumberMap.put(previousServiceContract.ContractNumber, previousContractIdToServiceContractNumberMap.get(previousServiceContract.CH_CDB_ContractId__c));
			}
			if(!previousContractNumberToServiceContractNumberMap.isEmpty()) {
	List<CH_SecurityRule__c> newSecurityRules = new List<CH_SecurityRule__c>();
	for(CH_SecurityRule__c oSecurityRule : [
		SELECT Id, CH_SecurityGroup__c, CH_GWCSecurityGroup__c, CH_AccountNumber__c, CH_AccountCustomerCompliance__c, CH_ContractNumber__c,
		 CH_NokiaProductId__c, CH_Country__c, CH_CARESServiceAgreement__c, CH_3rdPartySecurityGroup__c, CH_OrderofExecution__c
		FROM CH_SecurityRule__c WHERE CH_Active__c = true AND CH_ContractNumber__c IN :previousContractNumberToServiceContractNumberMap.keySet()
	]) {
		newSecurityRules.add(new CH_SecurityRule__c(
			CH_SecurityGroup__c = oSecurityRule.CH_SecurityGroup__c,
			CH_GWCSecurityGroup__c = oSecurityRule.CH_GWCSecurityGroup__c,
			CH_AccountNumber__c = oSecurityRule.CH_AccountNumber__c,
			CH_AccountCustomerCompliance__c = oSecurityRule.CH_AccountCustomerCompliance__c,
			CH_ContractNumber__c = previousContractNumberToServiceContractNumberMap.get(oSecurityRule.CH_ContractNumber__c),
			CH_NokiaProductId__c = oSecurityRule.CH_NokiaProductId__c,
			CH_Country__c = oSecurityRule.CH_Country__c,
			CH_CARESServiceAgreement__c = oSecurityRule.CH_CARESServiceAgreement__c,
			CH_3rdPartySecurityGroup__c = oSecurityRule.CH_3rdPartySecurityGroup__c,
			CH_OrderofExecution__c = oSecurityRule.CH_OrderofExecution__c
		));
	}
	if(!newSecurityRules.isEmpty()) {
		insert newSecurityRules;
	}
			}
		}
	}

	private static boolean smartCompare(String sourceField, String targetField) {
		boolean reverse = false;
		if(sourceField != null) {
			sourceField.remove(' ');
			if(sourceField.contains('!=')) {
	sourceField.remove('!=');
	reverse = true;
			}
		}
		return (reverse?sourceField!=targetField:sourceField==targetField);
	}
	
	Public Static void deletMembersOnCasesBasedonSecurityGroups(List<Case> newCaseList, Map<Id, Case> oldCaseMap) {
		//Changes added for NOKIASC-36964
		Map<Id,Case> getOldCaseMap=new Map<Id,Case>();
		Set<Id> getCaseIds=new Set<Id>();
		Set<Id> getSecGrpId=new Set<Id>();
		Set<Id> getUserIds=new Set<Id>();
		Set<String> getSecurityGroups =new Set<String>();
		List<Case> oCaseList = new List<Case>();
		//Get Valid Cases
		if(newCaseList != null && !newCaseList.isEmpty()){
			for(Case newCase : newCaseList) {
				Case oldCase = (oldCaseMap != null && oldCaseMap.containsKey(newCase.Id) ? oldCaseMap.get(newCase.Id) : null);
				 if((newCase.CH_RecordTypeCheck__c && newCase.Status != 'Cancelled') && oldCase == null || (oldCase !=null && (newCase.ProductId != oldCase.ProductId || newCase.AccountId != oldCase.AccountId || newCase.Country__c != oldCase.Country__c || newCase.EntitlementId != oldCase.EntitlementId  || newCase.CH_LawfullIntercept_CALEA__c != oldCase.CH_LawfullIntercept_CALEA__c))) {
					oCaseList.add(newCase);
					if(oldCase!=null){ getOldCaseMap.Put(oldCase.Id,oldCase);   }//Changes added for NOKIASC-36964
					
				}
			} 
		}
		//
		if(!oCaseList.isEmpty()) {
			//Changes added for NOKIASC-36964
			if(oCaseList!=null && !getOldCaseMap.values().IsEmpty()){
				for(Case getList:oCaseList){
					Case getOldCase = (getOldCaseMap != null && getOldCaseMap.containsKey(getList.Id) ? getOldCaseMap.get(getList.Id) : null);
					if(getOldCase !=null && getList.CH_RecordTypeCheck__c && getOldCase.CH_GWC_SecurityGroup__c !=getList.CH_GWC_SecurityGroup__c ||
					   getOldCase.CH_SecurityGroup__c !=getList.CH_SecurityGroup__c ||
					   getOldCase.CH_3rdPartySecurityGroup__c !=getList.CH_3rdPartySecurityGroup__c  ){
						   getCaseIds.add(getList.Id);
						   getUserIds.add(getList.OwnerId);
						   getSecurityGroups.add(getList.CH_GWC_SecurityGroup__c);
						   getSecurityGroups.add(getList.CH_SecurityGroup__c);
						   getSecurityGroups.add(getList.CH_3rdPartySecurityGroup__c);
					   }
				}
			}
			if(!getCaseIds.IsEmpty() && getCaseIds.Size()>0){
				for(CaseTeamMember getmembers:[select id,ParentID,Parent.CH_Workgroup__r.Name,Parent.CH_Workgroup__c , memberID ,Parent.OwnerID, 
											   TeamRoleId,TeamRole.Name, member.Name from CaseTeamMember Where ParentID IN : getCaseIds]){
												   getUserIds.add(getmembers.memberID);
											   }
				if(!getUserIds.IsEmpty() && getUserIds.Size()>0 && !getSecurityGroups.IsEmpty() && getSecurityGroups.Size()>0){
					for(Group getScGrp : [SELECT Id, DeveloperName,Name FROM Group Where Name IN :getSecurityGroups]){ getSecGrpId.add(getScGrp.Id); }
					System.debug('## User Size is : ' +getUserIds.size()+' and group size is: '+getSecGrpId.Size());
					System.debug('## Users are  : ' +getUserIds+' and group size is: '+getSecGrpId);
					if(getSecGrpId.Size()>0){ CH_ClearGroupUserCases.execute(getUserIds,getSecGrpId, getCaseIds);}
				}
			}
		}
	}
}