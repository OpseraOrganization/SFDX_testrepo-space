/**
 * @description: A Test class for PreferredDistributor Trigger and helper.
 * @author:	Accenture IDC.
 *
 * ============================================================================
 * History:
 * -------
 * 
 * API VERSION		   DATE		 DETAIL
 * 41.0				  03/08/2018   PRM Release 3.1 hypercare
 * ============================================================================ 
 */
 @isTest
 
 public with sharing class PreferredDistributorHelperTest{
 
	   /**
* Description : Test data to be created.
* @param Id NA 
* @return NA
**/
	public static testmethod void testDelete(){
		Test.startTest();
		
		NCP_CustomerCommunitySetting__c css = new NCP_CustomerCommunitySetting__c();
		css.Name = 'Default';
		css.Customer_Account__c = 'Customer - test';
		css.Customer_Account_Number__c = '12345';
		css.Customer_User_Profile__c = 'Customers';
		insert css;

		String orgId = userInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(PRMGlobalConstants.COLON,'').replace(PRMGlobalConstants.HYPHEN,'');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName = orgId + dateString + randomInt;
		Profile p = [SELECT Id FROM Profile WHERE Name =:PRMGlobalConstants.SysAdmin limit 1];
		User u = new User(Alias = PRMGlobalConstants.Aliass, Email=PRMGlobalConstants.TestEmail,
						  EmailEncodingKey = PRMGlobalConstants.FileUTF, LastName=PRMGlobalConstants.TestLName, LanguageLocaleKey=PRMGlobalConstants.TestLanguageLocaleKey,
						  LocaleSidKey=PRMGlobalConstants.TestLanguageLocaleKey, ProfileId = p.Id,TimeZoneSidKey=PRMGlobalConstants.TestTimeZone, 
						  Username = uniqueName + PRMGlobalConstants.Testt + orgId + PRMGlobalConstants.TestOrg,IsActive=true,Nokia_ID__c = randomInt + '0'); 
		Database.insert(u);
		Id accRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(PRMGlobalConstants.AccRecType).getRecordTypeId();
		Account acct = new Account(name=PRMGlobalConstants.Testtext,recordtypeid=accRecTypeId);
		Database.insert(acct);
		Partner_Company__c pc = new Partner_Company__c();
		pc.Partner_Name__c = acct.id;
		pc.Country_Headquarters__c = PRMGlobalConstants.countryHq;
		pc.Market__c = PRMGlobalConstants.Distibutor;
		pc.Partner_Type__c = PRMGlobalConstants.Distr;
		Database.insert(pc);
		Country_State_Dependency__c cs = new Country_State_Dependency__c();
		cs.Name = PRMGlobalConstants.Testtext;
		cs.Country__c = PRMGlobalConstants.Testtext;
		cs.State__c = PRMGlobalConstants.Testtext;
		Database.insert(cs);
		Account acc = new Account();
		acc.Name = PRMGlobalConstants.accName + Utils.generateRandomInteger(2)+Utils.generateRandomString(2);
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(PRMGlobalConstants.AccRecType).getRecordTypeId();
		
		Database.insert(acc);
		RecordType rt = [SELECT Id, Name FROM RecordType WHERE SobjectType =:PRMGlobalConstants.CaseObject  AND Name =:PRMGlobalConstants.CaseRecType limit 1];
		  Case caseDetails;
		  caseDetails = new Case(Status =PRMGlobalConstants.NewStatus,Priority=PRMGlobalConstants.priority,Subject=PRMGlobalConstants.Testtext,Description =PRMGlobalConstants.Testtext,
										   RecordTypeId = rt.id);
		Database.insert(caseDetails);
		junction__c PrefDist = new junction__c(case__c = caseDetails.id,Partner_Company__c=pc.id);
		
		Database.insert(PrefDist);
		
		Database.delete(PrefDist);
		Test.stopTest();
		
	}
  }