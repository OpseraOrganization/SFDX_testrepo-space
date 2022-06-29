/****************************************
 * Class Name : AccountTriggerHelper
 * Created Date: 26 December 2016
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 26 December 2016
 * Description : 1. add a "Default" checkbox on the Account object 
		 2. the "Default" field should only display on the Legal Entity page layout (only editable by global process and system admins) 
		 3. need validation to ensure one default legal entity for a given 301 account 
		 4. logic to update the Default legal entity from one LE to another LE 
		 5. logic to set the Default LE value if the LE is the first one created 
		 6. logic to set the most recent LE to the default IF it is not a specific default defined in the custom setting 
		 7. custom setting which stores the specific Default LE values which cannot change (e.g. Verizon Wireless) 
		 8. logic to prevent someone changing the default LE for one defined in the custom setting (must be changed in custom setting first - manual admin process) 
		 9. prevent user from changing LE on opportunity if a default LE is specified for the respective 301 account
 * Test Class: 
 *****************************************/
public with sharing class AccountTriggerHelper{
  //Map to store Customer Id vs input LE records
  private static Map<string,List<account>> customerIdVsLegalEntity;
  //Map to store Customer Id vs existing LE records
  private static Map<string,List<account>> customerIdVsExitstngLegalEntity;
  //Map to store Customer Id vs Default legal Entity record
  private static Map<string,Account> defaultLegalEntity;
  //Map to store Customer Id vs Customer record
  private static Map<string,Account> customerMap;
  //List to store all Legal Entities need to update for maintaning default
  private static List<Account> updateLEList;
   //List to store all Legal Entities Ids need to update for maintaning default
  private static Set<String> updateLEIdSet;
  
  /********************
  *Method Name: computeDS
  *Parameter: Legal Entity List
  *Description: Used to handle before Insert activities
		  1. compute Maps for choose default legal entity Method
  *******************/
  public static void computeDS(List<Account> legalEntityList){ 
	try{
	  customerIdVsLegalEntity = new Map<string,List<account>>();
	  customerIdVsExitstngLegalEntity = new Map<string,List<account>>();
	  defaultLegalEntity = new Map<string,Account>();
	  updateLEList = new list<Account>();
	  updateLEIdSet = new Set<String>();
	  
	  for(Account lEntity : legalEntityList){
		if(customerIdVsLegalEntity.containsKey(lEntity.ParentId)){
		  customerIdVsLegalEntity.get(lEntity.ParentId).add(lEntity); 
		  } 
		else{
		  customerIdVsLegalEntity.put(lEntity.ParentId,new list<Account>{lEntity});  
		  }
	  }
	  
	  for(Account customer: [select Id,name,AccountNumber,
				(select Id,name,AccountNumber,Default_Legal_Entity__c,parentId from ChildAccounts order by Default_Legal_Entity__c desc limit 2000) 
				from account 
				where Id In : customerIdVsLegalEntity.keySet() 
				limit : customerIdVsLegalEntity.size()]){
		
		for(Account lEntity : customer.ChildAccounts){
		  if(customerIdVsExitstngLegalEntity.containsKey(lEntity.ParentId)){
			customerIdVsExitstngLegalEntity.get(lEntity.ParentId).add(lEntity);  
			}
		  else
		  {
			customerIdVsExitstngLegalEntity.put(lEntity.ParentId,new list<Account>{lEntity});
			}
		}			
	  }
	  System.debug('customerIdVsExitstngLegalEntity....'+customerIdVsExitstngLegalEntity);
	}catch(Exception exc){
	  ExceptionHandler.addException(exc,GlobalConstants.ACCOUNTTRIGGERHELPER ,GlobalConstants.COMPUTE_DS);
	}
  }
  
  /********************
  *Method Name: chooseDefaultLegalEntity
  *Parameter: Legal Entity List
  *Description: Used to handle before Insert activities
		  1. Compute Maps for choose default legal entity 
		  2. Fetch all existing Legal entity for Customers available in input data
		  3. Choose default for Customers available in input data
  *******************/ 
  public static void chooseDefaultLegalEntity(List<Account> legalEntityList){ 
	try{	   
	  system.debug('Inside chooseDefaultLegalEntity....'+legalEntityList);
	  computeDS(legalEntityList);
	  Set<string> customerIdset = new Set<string>();
	  Boolean leFoundInCS = false;
	  customerMap = new Map<string,Account>([select Id,name,accountnumber from account 
						where Id In : customerIdVsLegalEntity.keySet() 
						limit : customerIdVsLegalEntity.size()]);
	  
	  system.debug('customerIdVsLegalEntity....'+customerIdVsLegalEntity);
	  //Existing legal entities for customer
	  AggregateResult[] arList = [select Count(Id) cnt,parent.accountnumber,parentId from account 
				  where parentId In : customerIdVsLegalEntity.keySet() 
				  group by parent.accountnumber,parentId
				  limit : customerIdVsLegalEntity.size()];
	  
	  system.debug('AggregateResult....'+arList );
	  
	  if(arList.size()>0){
		system.debug('Inside AggregateResult....');
		for(AggregateResult ar : arList){
		  
		  Integer legalEntityCount = Integer.valueOf(ar.get(GlobalConstants.ACCOUNTCOUNT));
		  string customerId = ar.get(GlobalConstants.PARENTID)+'';
		  string customerNumber = ar.get(GlobalConstants.CNUMBER)+'';
		  string defaultLEfromSetting = null; 
		  customerIdset.add(customerId); 
		  system.debug('customerId' + customerId);
		  system.debug('customerNumber ....'+customerNumber );
		  if(customerNumber!=NULL && Default_Legal_Entity__c.getValues(customerNumber )!=NULL){
			defaultLEfromSetting = Default_Legal_Entity__c.getValues(customerNumber).default__c;
		  }
		  system.debug('defaultLEfromSetting ....'+defaultLEfromSetting);
		  
		  for(Account lEntity : customerIdVsExitstngLegalEntity.get(customerId)){  
			 system.debug('1. lEntity Name ......'+lEntity.name);
			 if((!String.isBlank(defaultLEfromSetting)) && defaultLEfromSetting.equals(lEntity.accountNumber)){
			   system.debug('Inside found custom setting....');
			   lEntity.Default_Legal_Entity__c = true;
			   system.debug('Trigger.newMap......'+Trigger.newMap);
			   if(Trigger.newMap==NULL || (Trigger.newMap!=NULL && !Trigger.newMap.containsKey(lEntity.Id))){
				 if(!updateLEIdSet.contains(lEntity.Id)){
				   updateLEList.add(lEntity);
				   updateLEIdSet.add(lEntity.Id);
				 }
			   }
			   system.debug('1. updateLEList......'+updateLEList);
			   leFoundInCS = true;
			   break;
			 }else if(lEntity.Default_Legal_Entity__c){
			  if(defaultLegalEntity.containsKey(lEntity.ParentId)){
				defaultLegalEntity.get(lEntity.ParentId).Default_Legal_Entity__c = false;
			  }
			  defaultLegalEntity.put(lEntity.ParentId,lEntity);   
			  system.debug('Trigger.newMap......'+Trigger.newMap);
			  if(Trigger.newMap==NULL || (Trigger.newMap!=NULL && !Trigger.newMap.containsKey(lEntity.Id))){
				if(!updateLEIdSet.contains(lEntity.Id)){
				   updateLEList.add(lEntity);
				   updateLEIdSet.add(lEntity.Id);
				 }
			  }
			  system.debug('2. updateLEList......'+updateLEList);
			 }else{
			  //Do Nothing
			  //To solve novasuite report
			  System.debug('legal Entity Record'+lEntity);
			 }
		  }
		  
		  system.debug('leFoundInCS...'+leFoundInCS);
		  if(leFoundInCS){
			for(Account legalEntity : customerIdVsLegalEntity.get(customerId)){
			  if(!defaultLEfromSetting.equals(legalEntity.AccountNumber)){
				legalEntity.Default_Legal_Entity__c = false;  
				}
			}
			system.debug('Inside leFoundInCS...'+leFoundInCS);
			for(Account lEntity : customerIdVsExitstngLegalEntity.get(customerId)){
			   system.debug('Inside leFoundInCS for loop on existing...');
			   if(lEntity.Default_Legal_Entity__c && !defaultLEfromSetting.equals(lEntity.AccountNumber)){
				 system.debug('Inside leFoundInCS for loop on existing fonnd lentity true...'+lEntity);
				 lEntity.Default_Legal_Entity__c = false;
				 if(Trigger.newMap==NULL || (Trigger.newMap!=NULL && !Trigger.newMap.containsKey(lEntity.Id))){
				   if(!updateLEIdSet.contains(lEntity.Id)){
					 updateLEList.add(lEntity);
					 updateLEIdSet.add(lEntity.Id);
				   }
				 }
			   }
			} 
			break;
		  }else{
			system.debug('Not found in custom setting....');
			system.debug('defaultLegalEntity values....'+defaultLegalEntity);
			updateDefaultLEforNewCustomer(customerId,customerMap.get(customerId).AccountNumber); 
		  }
		} 
	  }
	   
	   //Not exist any legalEntity for this accounts  
	   for(String customerId : customerIdVsLegalEntity.keySet()){
		 if(!customerIdset.contains(customerId)){
		  updateDefaultLEforNewCustomer(customerId,customerMap.get(customerId).AccountNumber);  
		 }  
	   } 
	   
	   if(updateLEList.size()>0){
		 system.debug('updateLEList...'+updateLEList);
		 system.debug('Trigger.new....'+Trigger.new);
		 update updateLEList;
	   }
	 }catch(Exception exc){
	   ExceptionHandler.addException(exc,GlobalConstants.ACCOUNTTRIGGERHELPER ,GlobalConstants.CHOOSE_DEFAULT_LEGAL_ENTITY );
	 }
  }
  
  /********************
  *Method Name: updateDefaultLEforNewCustomer
  *Parameter: Legal Entity List
  *Description: Used to handle before Insert activities
		  1. Update the default legal entity from input data
  *******************/ 
  @testvisible
  private static void updateDefaultLEforNewCustomer(string customerId,string customerNumber){
	try{
	   system.debug('Inside updateDefaultLEforNewCustomer...'+customerId+'....'+customerNumber);
	   Boolean defaltFound = false;
	   String defaultLEfromSetting=null;
	  
	   if(customerNumber!=NULL && Default_Legal_Entity__c.getValues(customerNumber)!=NULL){
		 defaultLEfromSetting = Default_Legal_Entity__c.getValues(customerNumber).default__c;
	   }
	   
	   for(Account lEntity : customerIdVsLegalEntity.get(customerId)){
		 system.debug('Inside for loop...');
		 system.debug('defaultLEfromSetting' + defaultLEfromSetting);
		 system.debug('lEntity.AccountNumber' + lEntity.AccountNumber);
		 boolean xyz = (!String.isBlank(defaultLEfromSetting)) && defaultLEfromSetting.equals(lEntity.AccountNumber);
		 system.debug('xyz'+xyz);
		 system.debug('count out');
		 if((!String.isBlank(defaultLEfromSetting)) && defaultLEfromSetting.equals(lEntity.AccountNumber)){
		   system.debug('count in');
		   defaltFound = true;
		   system.debug('defaultLegalEntity.get(lEntity.ParentId)' + defaultLegalEntity.get(lEntity.ParentId));
		   defaultLegalEntity.get(lEntity.ParentId).Default_Legal_Entity__c = false;		
		   defaultLegalEntity.put(lEntity.ParentId,lEntity);
		   lEntity.Default_Legal_Entity__c = true; 
		   break;
		 }else if(lEntity.Default_Legal_Entity__c){
		  system.debug('Inside updateDefaultLEforNewCustomer....'+lEntity);
		  defaltFound = true; 
		  if(defaultLegalEntity.containsKey(lEntity.ParentId)){
			system.debug('Inside updateDefaultLEforNewCustomer....defaultLegalEntity...'+defaultLegalEntity +'....defaultLEfromSetting ...'+defaultLEfromSetting );
			if(defaultLEfromSetting != NULL && defaultLegalEntity.get(lEntity.ParentId).accountnumber.equals(defaultLEfromSetting)){
			  lEntity.Default_Legal_Entity__c = false;
			}else{
			  defaultLegalEntity.get(lEntity.ParentId).Default_Legal_Entity__c = false;
			}
		  }
		  defaultLegalEntity.put(lEntity.ParentId,lEntity);   
		}else{
		  //Do Nothing
		  //To solve novasuite report
		  System.debug('legal Entity Record'+lEntity);
		}
	  }
	  
	  if(!defaltFound && (!defaultLegalEntity.containsKey(customerId))){
		customerIdVsLegalEntity.get(customerId).get(0).Default_Legal_Entity__c = true;
	  }
	}catch(Exception exc){
	  System.debug('Exception....'+exc);
	  ExceptionHandler.addException(exc,GlobalConstants.ACCOUNTTRIGGERHELPER ,GlobalConstants.UPDATE_DEFAULT_LE_FOR_NEWCUSTOMER );
	}
  }
  
  /********************
  *Method Name: validateDefaultLegalEntity
  *Parameter: Legal Entity List
  *Description: Used to handle before Insert activities
		1. Check if updation of legal entity is valid or not
  *******************/ 
  public static List<Account> validateDefaultLegalEntity(List<Account> changedLElist){
	System.debug('Inside validateDefaultLegalEntity....');
	List<Account> validLEs = new  List<Account>();
	try{
	  for(Account lEntity : changedLElist){
		Account oldLE =  (Account)Trigger.oldMap.get(lEntity.Id);
		System.debug('oldLE ....'+oldLE );
		if(oldLE.Default_Legal_Entity__c && (!lEntity.Default_Legal_Entity__c)){
		  lEntity.addError(System.label.Default_Legal_Entity_Error);  
		}else{
		  validLEs.add(lEntity);
		}   
	  } 
	}catch(Exception exc){
	  ExceptionHandler.addException(exc,GlobalConstants.ACCOUNTTRIGGERHELPER ,GlobalConstants.VALIDATE_DEFAULT_LEGALENTITY );
	}
	return validLEs;
  }
  
  /********************
  *Method Name: checkParentIdChanges
  *Parameter: Legal Entity List
  *Description: Used to handle after update activities
		1. Check if parent customer of legal entity is changed or not
  *******************/ 
  public static List<Account> checkParentIdChanges(List<Account> lEList){
	System.debug('Inside checkParentIdChanges....');
	List<Account> validLEs = new  List<Account>();
	try{
	  for(Account lEntity : lEList){
		Account oldLE =  (Account)Trigger.oldMap.get(lEntity.Id);
		System.debug('oldLE ....'+oldLE.parentId );
		System.debug('lEntity ....'+lEntity.parentId );
		if((oldLE.parentId == NULL && lEntity.parentId!= NULL) || !oldLE.parentId.equals(lEntity.parentId)){
		  validLEs.add(lEntity);
		}   
	  } 
	}catch(Exception exc){
	  ExceptionHandler.addException(exc,GlobalConstants.ACCOUNTTRIGGERHELPER ,GlobalConstants.VALIDATE_DEFAULT_LEGALENTITY );
	}
	return validLEs;
  }
  
  /********************
  *Method Name: computeLegalEntityList
  *Parameter: Account List
  *Return : List of Legal Entity type of account
  *Description: Used to handle before Update activities
	  1. Filter out Legal Entity List
  *******************/
  public static List<Account> computeLegalEntityList(List<Account> accountList){
	List<Account> legalEntityList = new List<Account>();
	try{
	  Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosById();
	  System.debug('Inside AccountTriggerHandler .....');
	  for(Account acc : accountList){
		System.debug('Inside AccountTriggerHandler.computeLegalEntityList .....'+acc.recordTypeId);
		if(rtMap.get(acc.RecordTypeId).getName().equals(GlobalConstants.LEGAL_ENTITY) && !String.isBlank(acc.parentId)){
		  legalEntityList.add(acc);   
		}
	  }
	}catch(Exception exc){
	  ExceptionHandler.addException(exc,GlobalConstants.ACCOUNTTRIGGERHANDLER ,GlobalConstants.COMPUTE_LEGALENTITY_LIST );
	}
	return legalEntityList;
  }

  /*****************************
  *Method Name: updateOpportunityLegaEnitities
  *Description: SalesProcess Req-870: Tadd account legalentity and end customer legal entity in opportunities which does not have any.
  *Parameters: Account newlist
  *Test coverage from: AccountTriggerHelperTest
  *******************************/
  public static void updateOpportunityLegaEnitities(List<Account> validLEList){
	try{
	  list<string> parentIdList = new list<String>();
	  for(Account le : validLEList){
		parentIdList.add(le.parentId);
	  }
	  Id batchInstanceId = Database.executeBatch(new UpdateOpportunityLegalEntitiesBatch(parentIdList));
	}catch(Exception Ex){
	  ExceptionHandler.addException(Ex,GlobalConstants.ACCOUNTTRIGGERHANDLER, GlobalConstants.UPDATE_OPPTY_ACCOUNT_UPDATE);
	}
  }
  
  /*****************************
  *Method Name: validateLEDeactivation
  *Description: Req-1450: Inactive LE should not be default Legal Entity
  *Parameters: Account newlist
  *Test coverage from: AccountTriggerHelperTest
  *******************************/
  public static void validateLEDeactivation(List<Account> lEList, Map<Id,Account> oldAccountMap){
	System.debug('Inside validateLEDeactivation...');
	List<Account> validLEList = new List<Account>();
	String defaultLEfromSetting = NULL;
	Map<string, Account> validCustomerNumberMap = new Map<string, Account>();
	List<string> invalidCustomerNumberList = new List<string>();
	try{
	  for(Account le : lEList){
		if(!le.active__c && oldAccountMap.get(le.Id).active__c){
		  if(le.Default_Legal_Entity__c){
			//TO DO Check if Default Legal Entity is mentioned in Custom Setting
			if(le.Parent_Account_Number__c!=NULL && Default_Legal_Entity__c.getValues(le.Parent_Account_Number__c)!=NULL){
			   defaultLEfromSetting = Default_Legal_Entity__c.getValues(le.Parent_Account_Number__c).default__c;
			}
			
			if(defaultLEfromSetting != NULL){
			  //send an email
			  invalidCustomerNumberList.add(le.Parent_Account_Number__c);
			}else{
			  //le.Default_Legal_Entity__c = false;
			  validCustomerNumberMap.put(le.Parent_Account_Number__c, le);
			}
			
		  }
		}
	  }
	  System.debug('validCustomerNumberMap: '+validCustomerNumberMap);
	  if(validCustomerNumberMap.size()>0){
		//TO DO call a future method to make some other active LE as default
		 System.enqueueJob(new ChangeDefaultLegalEntity(validCustomerNumberMap,invalidCustomerNumberList));
	  }
	}catch(Exception Ex){
	   // ExceptionHandler.addException(Ex,GlobalConstants.ACCOUNTTRIGGERHANDLER, GlobalConstants.UPDATE_OPPTY_ACCOUNT_UPDATE);
	}
  }
  
/**********************************************************************************************************************
* author: Accenture
* Date: March-2017
* Param: Map<ID, Account> accNewMap, Map<ID, Account> accOldMap
* Return: void
* Description: Checks if account is moved to a new territory or deleted from a territory
* High Level Process : 
**********************************************************************************************************************	
  public static void accountTerritoryMovement(Map<ID, Account> accNewMap, Map<ID, Account> accOldMap)
  {
	Set<Id> territoryIds = new Set<Id>();
	for(Id accId : accNewMap.keySet())
	{
	   String oldL7 = accOldMap.get(accId).SFDC_L7TerritoryID__c;
	   String newL7 = accNewMap.get(accId).SFDC_L7TerritoryID__c;
	   
	   // Moving Account to a new territory
	   if(oldL7 != null && newL7 != null && Id.valueOf(oldL7) != Id.valueOf(newL7))
	   {				
		 territoryIds.add(Id.valueOf(oldL7));
	   }
	   
	   // Removing Account from territory
	   if(oldL7 != null && newL7 == null)
	   {
		 territoryIds.add(Id.valueOf(oldL7));
	   }
	}
	
	if(!territoryIds.isEmpty())
	{
	  AccountTerritoryMovementHelper.unShareFiles(territoryIds);
	}
	else
	{
	  System.debug('<< No Account territory movement or deletion >>');
	}
  }  */
  
   /********************
  *Method Name: computeProspectList
  *Parameter: Account List
  *Return : List of prospect type of accounts Id
  *Description: Used to handle before Update activities
	  1. Filter out Prospect List
  *******************/
  public static List<String> computeProspectList(List<Account> accountList){
	List<String> prospectIdList = new List<String>();
	try{
	  Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosById();
	  System.debug('Inside AccountTriggerHandler .....');
	  for(Account acc : accountList){
		System.debug('Inside AccountTriggerHandler.computeLegalEntityList .....'+acc.recordTypeId);
		if(rtMap.get(acc.RecordTypeId).getName().equals(GlobalConstants.PROSPECT)){
		  prospectIdList.add(acc.Id); 
		}
	  }
	}catch(Exception exc){
	  ExceptionHandler.addException(exc,GlobalConstants.ACCOUNTTRIGGERHANDLER ,GlobalConstants.COMPUTE_LEGALENTITY_LIST );
	}
	return prospectIdList;
  }
  
   /*
  * @description  Check BusinessPartnerRole field update on account.
  * @param	  newAct new account updated data, oldAct old account data befor update
  * @return	  
  */
   
  public static void SupplierEmailAlert(Map<Id,Account> newAct, Map<Id,Account> oldAct){
	Set<Id> scIdSet = new Set<Id>();
	Set<Id> sctIdSet = new Set<Id>();
	List<String> Addresses = new List<String>();
	String  newValue;
	String  oldValue;
	String AccountName;
	String templateName = NCP_Constants.EMAIL_TEMPLATE_SW_INTEGRATOR_EMAIL;
	
	String parentName = [SELECT Id,Name FROM RecordType WHERE SObjectType = 'ServiceContract' and DeveloperName =:NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT limit 1].Name;
	for(Id accountId: oldAct.keySet()){
	  if ((newAct.get(accountId).BusinessPartnerRole__c == NCP_Constants.BUSINESS_PARTNER_ROLE || oldAct.get(accountId).BusinessPartnerRole__c == NCP_Constants.BUSINESS_PARTNER_ROLE ) &&  newAct.get(accountId).BusinessPartnerRole__c <> oldAct.get(accountId).BusinessPartnerRole__c
		&& (newAct.get(accountId).BusinessPartnerRole__c != null && oldAct.get(accountId).BusinessPartnerRole__c != null)){
		  newValue = newAct.get(accountId).BusinessPartnerRole__c;
		  oldValue = oldAct.get(accountId).BusinessPartnerRole__c;
		  AccountName = newAct.get(accountId).name;
		  for(ServiceContract sc:[Select Id,(Select NCP_Team_Member__c From Service_Contract_Team__r) From ServiceContract Where  Account.Id=:accountId and RecordType.Name =: parentName]){
			for (NCP_Service_Contract_Team__c teamMember : sc.Service_Contract_Team__r) {
			  Addresses.add(teamMember.NCP_Team_Member__c);
			}
		  }
		}
	}
	
	sendEmailTemplate(templateName,Addresses, newValue, oldValue, AccountName);  
	
  }
  
  /*
  * @description  Send Email to suppliers
  * @param	  templateName template Id, Id user Id, newAct new account updated data, oldAct old account data befor update
  * @return	  
  */
  public static void sendEmailTemplate(String templateName ,List<String> toEmails, String newValue, String oldValue, String accountName) {
	if((!String.isBlank(newValue) && !String.isBlank(oldValue) && !String.isBlank(accountName)) && toEmails.size() > 0) {
	  EmailTemplate emailTemplate = new EmailTemplate(); 
	  
	  OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];
	  emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where DeveloperName =:templateName];
	  
	  String htmlBody = emailTemplate.HtmlValue;
	  htmlBody = htmlBody.replace('{!Account.Name}', accountName);
	  htmlBody = htmlBody.replace('{!BusinessPartnerRoleOldValue}', oldValue);
	  htmlBody = htmlBody.replace('{!BusinessPartnerRoleNewValue}', newValue);
	  
	  Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
	  email.setOrgWideEmailAddressId(owa.id);
	  email.setToAddresses(toEmails);
	  email.setSaveAsActivity(false);
	  email.setHtmlBody(htmlBody);
	  
	  Messaging.sendEmail(new Messaging.SingleEmailmessage[] {email});
	}
	
  }
}