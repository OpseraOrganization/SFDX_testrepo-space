/*******************************************************************
 * Class Name : CAPS_TestDataUtil 
 * Created Date: 11 July 2018
 * Created By : TCS
 * Descsription: CAPS integration related test data utility class
********************************************************************/
@isTest
public class CAPS_TestDataUtil {
	/*
	Create custom settings records
	*/
	public static void createCustomSettingsData(){	  
	
		CH_Settings__c chSet1;
		List<CH_Settings__c> chSettingsList = new List<CH_Settings__c>();
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'BaseUrl';
		chSet1.SettingValue__c = 'https://capsv.nokia.com';
		chSettingsList.add(chSet1);
		
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'RunFreqInMinuteCAPSStatusUpdateBatch';
		chSet1.SettingValue__c = '0';
		chSettingsList.add(chSet1);
		
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'CAPSEndUserforPUT';
		chSet1.SettingValue__c = 'CAPSCLI';
		chSettingsList.add(chSet1);
		
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'CAPSSecret';
		chSet1.SettingValue__c = 'Njc2Nzg=';
		chSettingsList.add(chSet1);
		
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'CAPSSignatureKey';
		chSet1.SettingValue__c = 'Njc2Nzg=';
		chSettingsList.add(chSet1);
		
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'LimitOfListSize';
		chSet1.SettingValue__c = '98';
		chSettingsList.add(chSet1);
		
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'NokiaUserName';
		chSet1.SettingValue__c = 'rajupadh';
		chSettingsList.add(chSet1);
		
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'RetentionDayForDelete';
		chSet1.SettingValue__c = '1';
		chSettingsList.add(chSet1);
		
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'RetentionDaysNonSensitive';
		chSet1.SettingValue__c = '730';
		chSettingsList.add(chSet1);
		
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'StorageUrl';
		chSet1.SettingValue__c = '/93f6cc8e/api/log/attachments/';
		chSettingsList.add(chSet1);
		
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'StorageUrl1';
		chSet1.SettingValue__c = '/93f6cc8e/api/log/attachments';
		chSettingsList.add(chSet1);
		
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'LimitFromCHAttachmentTrigger';
		chSet1.SettingValue__c = '90';
		chSettingsList.add(chSet1);
		
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'EnableCHAttachmentTrigger';
		chSet1.SettingValue__c = 'Yes';
		chSettingsList.add(chSet1);
		
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'SpecificTimeForOnhold';
		chSet1.SettingValue__c = '3';
		chSettingsList.add(chSet1);
		
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'S3SignUrl';
		chSet1.SettingValue__c = '/93f6cc8e/api/s3sign';
		chSettingsList.add(chSet1);
		
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'ExpirationTimeAdded';
		chSet1.Description__c = 'ExpirationTimeAdded';
		chSet1.SettingValue__c = '60';
		chSettingsList.add(chSet1);
		
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'SendAttachmentToNAIP';
		chSet1.SettingValue__c = 'Yes';
		chSettingsList.add(chSet1); 
		
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'CAPSInstance';
		chSet1.SettingValue__c = '93f6cc8e';
		chSettingsList.add(chSet1);
		
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'AttachmentNumberinEachJobAutoDelete';
		chSet1.SettingValue__c = '50';
		chSettingsList.add(chSet1);
		
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'AttachmentNumberinEachJobManualDelete';
		chSet1.SettingValue__c = '50';
		chSettingsList.add(chSet1);
		
		chSet1 = new CH_Settings__c();
		chSet1.Name = 'CAPSVS3SignAPIV4Url';
		chSet1.SettingValue__c = 'https://capsv.nokia.com/93f6cc8e/api/s3signv4';
		chSettingsList.add(chSet1);
		
		insert chSettingsList;
	}
	
	
	/*
	Create CH_Attachment__c records
	*/
	public static List<CH_Attachment__c> createCHAttachmentRecord(Integer size, String classification, String caseId){
		List<CH_Attachment__c> attachmentList = new List<CH_Attachment__c>();
		for(integer i=0;i<size;i++){
			CH_Attachment__c chAtachObj = new CH_Attachment__c();
			chAtachObj.Name = 'Test Attachment ' + i;
			chAtachObj.File_Name__c ='Test' + i+'encrypted.zip';
			chAtachObj.CH_FileType__c ='encrypted';
			chAtachObj.AttachmentID__c = 'kfgaskfgasieug' + i;
			chAtachObj.Case__c = caseId;
			chAtachObj.CH_Classification__c = classification;
			chAtachObj.CH_Description__c = 'Test' +i;
			chAtachObj.CH_Puropse__c = 'Test' +i;
			chAtachObj.CH_Service_Class__c = 'CARE';
			chAtachObj.CH_Size__c = 12;
			chAtachObj.CH_Status__c = 'uploading';
			chAtachObj.CH_Uploaded__c = system.now();
			chatachObj.CH_MarkForDelete__c =True;
			chAtachObj.Customer_Visible__c = True;
			attachmentList.add(chAtachObj);
		}
		return attachmentList;
	}
	/*
Create Case records
*/
	public static List<Case> createCaseRecord(Integer size){
		//Create Custom Setting Data 
		//Creating Custom Setting Data for Valid Account Name
		CH_AccountName__c accauth = new CH_AccountName__c();
		accauth.CH_InvalidName__c = 'Nokia';
		accauth.CH_ValidName__c = 'Nokia-OYJ';
		insert accauth;
		//CH_ENTITLEMENT_UTIL_TEST.createCustomSettingData();
		//create Product List.
		List<Product2> productlist =new List<Product2>();
		productlist =CAPS_TestDataUtil.createProductRecord(2);
		insert productlist;
		
		Id customerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		//Create Parent Account Record
		Account parentAccount = new Account();
		parentAccount.RecordTypeId = customerRecordTypeId;
		parentAccount.Customer_Compliance__c = 'US_ALTICE';
		parentAccount.Name = 'Test Parent Account';
		insert parentAccount;
		system.debug('parentAccount.Customer_Compliance__c --> ' + parentAccount.Customer_Compliance__c);
		
		//Create Account Reacord.
		Account accObjCust = new Account();
		accObjCust.RecordTypeId = customerRecordTypeId;
		accObjCust.Name = 'Test Customer Account';
		accObjCust.ParentId = parentAccount.Id;
		insert accObjCust;
		System.assertNotEquals(accObjCust.Id, null);
		system.debug('accObjCust.Parent.Customer_Compliance__c --> ' + accObjCust.Parent.Customer_Compliance__c);
		system.debug('accObjCust.LE_Customer_Compliance__c --> ' + accObjCust.LE_Customer_Compliance__c);
		
		//Create Contact Obj.  
		contact contactObj = new Contact();
		contactObj.lastname = 'Test Contact';
		
		contactObj.Email = 'test@someaddress.com';
		contactObj.Market__c = 'MARKET EUROPE';
		insert contactObj;
		
		List<Case> caseList = new List<Case>();
		for(integer i=0;i<size;i++){
			Case caseObj = new Case();
			caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
			caseObj.Description = 'test'+i;
			caseObj.Subject = 'test' +i;
			caseObj.Severity__c = 'Minor';
			caseObj.Status = 'Assigned';
			caseObj.Priority='Low';
			caseObj.Type='Incident';
			caseObj.CH_InitialDiagnosis__c = 'testt';
			caseobj.CH_Caused_By__c='Customer';
			caseobj.CH_Cause_Type__c = 'Operational';
			caseobj.CH_Solution_Available__c = 'Yes';
			caseobj.CH_Outage__c = 'No';
			caseobj.CH_SecurityGroup__c ='Test1234' +i;
			caseobj.CH_IssueOccurenceDate__c =system.now().addMinutes(-1440);
			caseobj.CH_AssignedDate__c= system.today().addDays(-1);
			caseobj.Country__c = 'United States of America';
			caseobj.ProductId=productlist[0].id;
			caseobj.ContactId=contactObj.Id;
			caseobj.AccountId=accObjCust.Id;
			System.debug('caseobj.ProductId'+caseobj.ProductId+'caseobj.Country__c'+caseobj.Country__c);
			caseobj.CH_OutageStartDate__c =System.now().addMinutes(-1440);
			caseobj.CH_OutageEndDate__c  = System.now().addMinutes(-1439);
			caseList.add(caseObj);
		}
		return caseList;
	} 
	
	
  public static List<Case> createCaseRecord1(Integer size,String productId,String Accountid,String entiid,String asid,String ParentProductId,string assetaccount){
		   Id recordTypeIdCase = [Select Id , DeveloperName from RecordType Where sobjecttype = 'Case' and DeveloperName = 'CH_NokiaStandardCase' limit 01].Id;
		List<Case> caseList = new List<Case>();
		for(integer i=0;i<size;i++){
			Case caseObj = new Case();
			caseObj.Description = 'test'+i;
			caseObj.Subject = 'test' +i;
			caseObj.Severity__c = 'Minor';
			caseObj.Priority='Low';
			caseObj.CH_InitialDiagnosis__c = 'testt';
			caseObj.Type='Incident';
			caseobj.Status='New';
			caseobj.CH_Outage__c = 'No';
			caseobj.CH_SecurityGroup__c ='Test1234' +i;
			caseobj.CH_IssueOccurenceDate__c =system.now().addMinutes(-1440);
			caseobj.CH_AssignedDate__c= system.today().addDays(-1);
			caseobj.Country__c = 'United States of America';
			caseobj.ProductId = productId;
			caseobj.AccountId = assetaccount;
			caseobj.EntitlementId =entiid;
			caseobj.AssetId =asid;
			caseobj.CH_Solution__c = ParentProductId;
			caseobj.recordTypeId =recordTypeIdCase;
			caseobj.CH_OutageStartDate__c = System.now().addMinutes(-1440);
			caseobj.CH_OutageEndDate__c  = System.now().addMinutes(-1439);
			caseList.add(caseObj);
		   System.debug('caseList'+caseList); 
		}
		return caseList;
	}
	  
	public static List<CH_OutageDuration__c> createoutageDurationRecord(List<case> caseList)
	{
	   LIst<CH_OutageDuration__c> listOfoutageDuration =new LIst<CH_OutageDuration__c>(); 
		for(Case caseObj: caseList )
		{ 
			CH_OutageDuration__c objOutageDuration =new CH_OutageDuration__c(); 
			objOutageDuration.CH_SupportTicket__c = caseObj.Id; 
			listOfoutageDuration.add(objOutageDuration);
		}
	  
	   return listOfoutageDuration;
	}
	public static List<Product2> createProductRecord(Integer size){
		   
		List<Product2> productlist =new List<Product2>();
		for(integer i=0;i<size;i++){
			Product2 prodObj = new Product2();
			prodObj.Name ='Test'+i;
			prodObj.ProductCode ='133-047489_00';
			prodObj.DataUsage__c = 'CARES';
			prodObj.PMD_Portfolio_Classification__c = 'Product';
			prodObj.NCP_CAREACTIVATE__c ='Test';
			prodObj.DataUsage__c='CARES';
			prodObj.NCP_CAREACTIVATE__c='Test';
			prodObj.CH_ParentProductId__c=prodObj.Id;
			productlist.add(prodObj);
			System.debug('Product List'+productlist);
		}
		return productlist;
	}
	  
	
	 public static List<Account> createAccountRecord(Integer size){
		List<Account> accountlist =new List<Account>();
		for(integer i=0;i<size;i++){
			Account accObj = new Account();
			accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			accObj.Name ='test'+i;
			accObj.AccountNumber ='76521';
			accountlist.add(accObj);
		}
		return accountlist;
	} 
	
	public static List<ServiceContract> createServiceContractRecord(Integer size){
		List<ServiceContract> sclist =new List<ServiceContract>();
		for(integer i=0;i<size;i++){
			ServiceContract scObj = new ServiceContract();
			scObj.Name ='test'+i;
			scobj.CH_CDB_ContractId__c ='12345';
			scObj.CH_CDB_CustomerId__c ='76521';
			sclist.add(scObj);
		}
		return sclist;
	} 
	 public static List<Asset> createAssetRecord(Integer size,String acid){
		List<Asset> aslist =new List<Asset>();
		for(integer i=0;i<size;i++){
			Asset scObj = new Asset();
			scObj.CH_CDB_ExternalAssetId__c = '4144'+i;
			scObj.Name ='Test'+i;
			scObj.AccountId =acid;
			scObj.CH_CDB_ExternalAssetId__c = '123123';
			aslist.add(scObj);
		}
		return aslist;
	} 
	
	public static List<Entitlement> createEntitlementRecord(Integer size ,string scid,string acid, string assid){
		List<Entitlement> entitlementlist =new List<Entitlement>();
		for(integer i=0;i<size;i++){
			Entitlement entiObj = new Entitlement();
			entiObj.Name ='test'+i;
		
			system.debug('assidName'+assid);
			entiObj.CH_ServiceMappingId__c ='Legacy Customer Support Service - Critical Major Minor 24x7';
			entiObj.AccountId =acid;
			entiObj.CH_CDB_EntitlementId__c ='54321';
			entiObj.ServiceContractId= scid;
			entiObj.AssetId =assid;
			entitlementlist.add(entiObj);
		}
		return entitlementlist;
	}  
	   public static CH_Settings__c createChsetting(){
		CH_Settings__c chset = new CH_Settings__c();
		chset.Description__c = 'test custom settings';
		chset.SettingValue__c = '3';
		chset.Name = 'SpecificTimeForOnhold';
		  
		return chset;
	}
		//DEM0050458: For customer hidden attachments comments should not be public
	/*
	Create CH_Attachment__c records where Customer_Visible__c is false
	*/
	public static List<CH_Attachment__c> createCHAttachmentRecordFalse(Integer size, String classification, String caseId){
		List<CH_Attachment__c> attachmentList = new List<CH_Attachment__c>();
		for(integer i=0;i<size;i++){
			CH_Attachment__c chAtachObj = new CH_Attachment__c();
			chAtachObj.Name = 'Test Attachment ' + i;
			chAtachObj.File_Name__c ='Test' + i+'encrypted.zip';
			chAtachObj.CH_FileType__c ='encrypted';
			chAtachObj.AttachmentID__c = 'kfgaskfgasieug' + i;
			chAtachObj.Case__c = caseId;
			chAtachObj.CH_Classification__c = classification;
			chAtachObj.CH_Description__c = 'Test' +i;
			chAtachObj.CH_Puropse__c = 'Test' +i;
			chAtachObj.CH_Service_Class__c = 'CARE';
			chAtachObj.CH_Size__c = 12;
			chAtachObj.CH_Status__c = 'uploading';
			chAtachObj.CH_Uploaded__c = system.now();
			chatachObj.CH_MarkForDelete__c =True;
			chAtachObj.Customer_Visible__c = False;
			attachmentList.add(chAtachObj);
		}
		return attachmentList;
	}
}