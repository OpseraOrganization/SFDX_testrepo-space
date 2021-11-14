/**
* @name	PSR_CloneOppTest 
* @author   
* @since   Oct , 2017
* @desc	This class helps create customized test data, used in test classes
* @history 
*/
@isTest
private class PSR_CloneOppTest{
	
	private static final Id PSR_EditRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.PRESALESRISKOPPORTUNITY).getRecordTypeId();
	private static Id oppIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.CREATE_INDIRECT_SALES_OPPORTUNITY).getRecordTypeId();
	static NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();

	static testMethod void getPSRCloneTest() {
	   
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		
		list <File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new list <File_Sharing_Custom_Setting__c> ();
		
		File_Sharing_Custom_Setting__c fileSharingCustomSetting1 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting1.Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE;
		fileSharingCustomSetting1.Value__c = '900';			
		fileSharingCustomSettingList.add(fileSharingCustomSetting1);
		insert fileSharingCustomSettingList;
		
		list < PSRCloneObject__c > psrlist = new list < PSRCloneObject__c >();
		
		PSRCloneObject__c psr1 = new PSRCloneObject__c();
		psr1.name = 'id';
		psr1.Field_API__c = 'id';
		psr1.DefaultValue__c  = 'id';
		psr1.Object__c = GlobalConstants.OBJECT_OPPORTUNITY;
		insert psr1;
		
		PSRCloneObject__c psr2 = new PSRCloneObject__c();
		psr2.name = 'PSR_Reference_Opportunity__r.stagename';
		psr2.Field_API__c = 'PSR_Reference_Opportunity__r.stagename';
		psr2.DefaultValue__c  = 'PSR_Reference_Opportunity__r.stagename';
		psr2.Object__c = GlobalConstants.OBJECT_OPPORTUNITY;
		insert psr2;
		
		
		PSRCloneObject__c psr3 = new PSRCloneObject__c();
		psr3.name = 'PSR_Reference_Opportunity__c';
		psr3.Field_API__c = 'PSR_Reference_Opportunity__c';
		psr3.DefaultValue__c  = 'PSR_Reference_Opportunity__c';
		psr3.Object__c = GlobalConstants.OBJECT_OPPORTUNITY;
		insert psr3;
		
		PSRCloneObject__c psr4 = new PSRCloneObject__c();
		psr4.name = 'name';
		psr4.Field_API__c = 'name';
		psr4.DefaultValue__c  = 'name';
		psr4.Object__c = GlobalConstants.OBJECT_OPPORTUNITY;
		insert psr4;
		
		PSRCloneObject__c psr5 = new PSRCloneObject__c();
		psr5.name = 'PSR_Pre_';
		psr5.Field_API__c = 'PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c';
		psr5.DefaultValue__c  = 'PSR_Pre_';
		psr5.Object__c = GlobalConstants.OBJECT_OPPORTUNITY;
		insert psr5;
		
		PSRCloneObject__c psr6 = new PSRCloneObject__c();
		psr6.name = 'PSR_Reset_PSRO__c';
		psr6.Field_API__c = 'PSR_Reset_PSRO__c';
		psr6.DefaultValue__c  = 'true';
		psr6.Object__c = GlobalConstants.OBJECT_OPPORTUNITY;
		insert psr6;
		
		PSRCloneObject__c psr7 = new PSRCloneObject__c();
		psr7.name = 'PSR_Pre_Type__c';
		psr7.Field_API__c = 'PSR_Pre_Sales_Risk_Opportunity_Type__c';
		psr7.DefaultValue__c  = 'PSR_Pre_Type__c';
		psr7.Object__c = GlobalConstants.OBJECT_OPPORTUNITY;
		insert psr7;
		
		//Creating User
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			//Creating Account
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234'; 
			database.insert(accountCreation);
			//Creating Indirect-Oppty
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];			
			optyCreation.RecordTypeId= oppIndirectRecordTypeId ;
			optyCreation.Country__c = 'India';
			optyCreation.G3_Approval_Date__c = system.now();
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			database.insert(optyCreation);
			//changing oppty's stage Name and phase status
			optyCreation.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			database.update(optyCreation);
			system.debug('optyCreationoptyCreationoptyCreation>>>>>>>>>>>>>>>>>>>>>>>>>'+optyCreation);
			//Creating Presales Oppty
			Opportunity preSalesTest = TestDataFactory.preSalesOpportunityCreation(2, accountCreation, optyCreation)[0];
			
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			//preSalesTest.CurrencyIsoCode = 'EUR';
			preSalesTest.RecordTypeId= PSR_EditRecordTypeID ;

			database.insert(preSalesTest);

	   
		
		test.startTest();
		PSR_CloneOpp.getPSRClone( preSalesTest.Id );
		

	   

	 
		

		test.stopTest();
		}
		
	}
}