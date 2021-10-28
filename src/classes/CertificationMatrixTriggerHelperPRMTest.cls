/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:			CertificationMatrixTriggerHelperPRMTest
Description:	 CertificationMatrixTriggerHelperPRMTest class to test values and perform DML operations on CertificationMatrix object
Date		Version	  Author		Summary of Changes 
-----------	  ----------	  -----------------	---------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------*/

		   /**
* Description : to cover certification matrix helper class 
Name - CertificationMatrixTriggerHelperPRMTest
* @param NA
* @return User
* @throws NA
**/
@IsTest
public class CertificationMatrixTriggerHelperPRMTest {

	private static testMethod void updateGPPFieldsTest(){
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
		 Test.startTest();
		 File_Sharing_Custom_Setting__c filesharing = new File_Sharing_Custom_Setting__c();
		 filesharing.name = 'Allowed Profiles For Chatter Files';
		 filesharing.Value__c ='';
		 filesharing.Description__c = 'List out the profile Names in Comma Separation without any extra space after comma';
		 insert filesharing;
		Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
		acc.Market__c = 'Market India';
		//acc.BusinessPartnerRole__c = 'Indirect Reseller';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.BillingCountry  = 'India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		acc.Partner_Program__c = 'GPP 3.0';
		insert acc;
		//acc.Partner_Program__c = 'GPP 1.0';
		//update acc;
		
		Account acc1 = new Account();
		acc1 = TestDataFactory.createAccount(1)[0];
		acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
		acc1.Market__c = 'Market India';
		//acc1.BusinessPartnerRole__c = 'Indirect Reseller';
		acc1.Name = 'STARHUB LIMITED';
		acc1.Country__c='India';
		acc1.BillingCountry  = 'India';
		acc1.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		acc1.Partner_Program__c = 'GPP 0.0';
		insert acc1;
		//acc1.Partner_Program__c = 'GPP 3.0';
		//update acc1;
		
		Contact con = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(con);
		
		Certification_Matrix__c CertMatrix1 = new Certification_Matrix__c(GPP_0_0__c = 'test 10', GPP_1_0__c = 'test 11', GPP_2_0__c = 'test 12', GPP_3_0__c = 'test 13');
		Database.insert(CertMatrix1);
		CertMatrix1.GPP_0_0__c = 'PRMTEST1';
		CertMatrix1.GPP_1_0__c = 'PRMTEST1 1';
		CertMatrix1.GPP_2_0__c = 'PRMTEST1 2';
		CertMatrix1.GPP_3_0__c = 'PRMTEST1 3';
		Database.Update(CertMatrix1);
		Certification_Matrix__c CertMatrix = new Certification_Matrix__c(GPP_0_0__c = 'test 0', GPP_1_0__c = 'test 1', GPP_2_0__c = 'test 2', GPP_3_0__c = 'test 3');
		Database.insert(CertMatrix);
		CertMatrix.GPP_0_0__c = 'PRMTEST';
		CertMatrix.GPP_1_0__c = 'PRMTEST 1';
		CertMatrix.GPP_2_0__c = 'PRMTEST 2';
		CertMatrix.GPP_3_0__c = 'PRMTEST 3';
		Database.Update(CertMatrix);
		
		LIST<Certification__c> certdetailList = new LIST<Certification__c>();
		Certification__c certification1 = new Certification__c(GPP_Certification_Name__c = 'Deployment Installation test', Certification_Matrix_Number__c = CertMatrix1.ID, Name__c = con.Id, 
		Partner__c = acc.ID,  Approvedby_Authority__c = 'No');
	   // certdetailList.add(certification1);
		
		Certification__c certification2 = new Certification__c(GPP_Certification_Name__c = 'Deployment Installation test', Certification_Matrix_Number__c = CertMatrix.ID, Name__c = con.Id, 
		Partner__c = acc.ID,  Approvedby_Authority__c = 'No');
		certdetailList.add(certification2);
		Database.insert(certdetailList);
		
		CertMatrix.GPP_0_0__c = 'PRMTEST';
		CertMatrix.GPP_1_0__c = 'PRMTEST 111';
		CertMatrix.GPP_2_0__c = 'PRMTEST 211';
		CertMatrix.GPP_3_0__c = 'PRMTEST 311';
		Database.Update(CertMatrix);
		
		certdetailList[0].Certification_Matrix_Number__c = CertMatrix.ID;
		certdetailList[0].Partner__c=acc.ID;
		certdetailList[0].GPP_Certification_Name__c= CertMatrix.GPP_0_0__c;
		Database.update(certdetailList);
		//acc.Partner_Program__c = 'GPP 3.0';
		//update acc;
		Test.stopTest();
	}
	}
}