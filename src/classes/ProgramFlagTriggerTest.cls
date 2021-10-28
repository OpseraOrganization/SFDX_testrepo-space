/****************************************
 * Name : ProgramFlagTriggerTest 
 * Author : Accenture
 * Description : Test class for ProgramFlagTrigger, ProgramFlagHandler and ProgramFlagTriggerHelper
 *****************************************/
@istest
private class ProgramFlagTriggerTest {
	
	
	private static List<Account> accountList = new List<Account>();
	private static List<Opportunity> opportunityList = new List<Opportunity>();

	
	/***********************
	* Method Name: programFlagMethod
	* Description: Sales Process : programFlagMethod
	* Parameters: NA
	************************/ 
	static testMethod void programFlagMethod(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		System.runAs(userCreation){
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList); 
			accountList = TestDataFactory.createAccount(2);
			database.insert(accountList);
			opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);
			database.insert(opportunityList);
			Program_Flag__c pfdata = new Program_Flag__c();
			pfdata.Name = 'PfData';
			database.insert(pfdata);
			OptyProgramFlagJunction__c opfj = new OptyProgramFlagJunction__c();
			opfj.Opportunity__c = opportunityList[0].id;
	
			database.insert(opfj);
			opfj.Program_Flag__c = pfdata.id;
			database.update(opfj);
			database.delete(opfj);
		}
	}
	
	 /***********************
	* Method Name: competitorMethodNegative
	* Description: Sales Process : competitorMethodNegative
	* Parameters: NA
	************************/ 
	static testMethod void competitorMethodNegative(){
		OptyProgramFlagJunction__c opfj = new OptyProgramFlagJunction__c();
		user userCreation = TestDataFactory.userCreation(1,'Nokia Sales Profile')[0];
		database.insert(userCreation);
		System.runAs(userCreation){
			Test.startTest();
			try{
			
			List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList); 
	accountList = TestDataFactory.createAccount(1);
	database.insert(accountList);
	opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);
	opportunityList[0].StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
	opportunityList[0].Phase_Status__c = 'Planned';
	opportunityList[0].Sales_Outcome__c = 'Obsolete';
	database.insert(opportunityList);
	Program_Flag__c pfdata = new Program_Flag__c();
	pfdata.Name = 'PfData';
	database.insert(pfdata);
	
	opfj.Opportunity__c = opportunityList[0].id;
	
	database.insert(opfj);
	opfj.Program_Flag__c = pfdata.id;
	database.update(opfj);
	database.delete(opfj);
			}catch(Exception e){
	Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false; 
	System.assertEquals(expectedExceptionThrown, true);
			}
			Test.stopTest();
		}
	}
	
	/***********************
	* Method Name: competitorMethodMethodNegativeUpdate
	* Description: Sales Process : competitorMethodMethodNegativeUpdate
	* Parameters: NA
	************************/ 
	static testMethod void competitorMethodMethodNegativeUpdate(){
		OptyProgramFlagJunction__c opfj = new OptyProgramFlagJunction__c();
		Program_Flag__c pfdata = new Program_Flag__c();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		user userCreationOtherProfile = TestDataFactory.userCreation(1,'Global Process Admin Profile')[0];
		database.insert(userCreationOtherProfile );
		
		System.runAs(userCreation){
			
			accountList = TestDataFactory.createAccount(2);
			database.insert(accountList);
			opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);   
			opportunityList[0].StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			opportunityList[0].Phase_Status__c = 'Submitted for G2 Approval';
			//opportunityList[0].Sales_Outcome__c = 'Obsolete';
			List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			database.insert(opportunityList);
			
			pfdata.Name = 'PfData';
			database.insert(pfdata);
			
			opfj.Opportunity__c = opportunityList[0].id;
			database.insert(opfj);			
		}
	
		System.runAs(userCreationOtherProfile ){
			try{
	opfj.Program_Flag__c = pfdata.id;
	database.update(opfj);		
			}catch(Exception e){
	Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false; 
	//System.assertEquals(expectedExceptionThrown, false);
			}
		}		
	}
	
	/***********************
	* Method Name: competitorMethodNegativeDelete
	* Description: Sales Process : competitorMethodNegativeDelete
	* Parameters: NA
	************************/ 
	static testMethod void competitorMethodNegativeDelete(){
		OptyProgramFlagJunction__c opfj = new OptyProgramFlagJunction__c();
		Program_Flag__c pfdata = new Program_Flag__c();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		user userCreationOtherProfile = TestDataFactory.userCreation(1,'Global Process Admin Profile')[0];
		database.insert(userCreationOtherProfile );
		
		System.runAs(userCreation){
			
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);   
			opportunityList[0].StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			opportunityList[0].Phase_Status__c = 'Planned';
			//opportunityList[0].Sales_Outcome__c = 'Obsolete';
			List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			database.insert(opportunityList);
		
			pfdata.Name = 'PfData';
			database.insert(pfdata);
			
			opfj.Opportunity__c = opportunityList[0].id;
			database.insert(opfj);	
		}
	
		System.runAs(userCreationOtherProfile ){
			try{	
	database.delete(opfj);   
			}catch(Exception e){
	Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false; 
	//System.assertEquals(expectedExceptionThrown, true);
			}
		}		
	}
	//Sales Process: Req#1454
	/***********************
	* Method Name: copyOpptyProgramFlagToOifTest
	* Description: Sales Process : To cover copyOpptyProgramFlagToOif method
	* Parameters: NA
	************************/ 
	static testMethod void copyOpptyProgramFlagToOifTest(){
		Id dealFramedRecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Framed Deal').getRecordTypeId();
		Database.BatchableContext BC;
		List<Order_Intake_Forecast__c> oifCreation = new List<Order_Intake_Forecast__c>();
		product2 productCreation = new product2();
		//OptyProgramFlagJunction__c opfj = new OptyProgramFlagJunction__c();
		List<Program_Flag__c> pfdata = new List<Program_Flag__c>();
		Program_Flag__c pfdataObj = new Program_Flag__c();
		Program_Flag__c pfdataObj1 = new Program_Flag__c();
		Nokia_Financial_Calendar__c nokiaFinCalObjCreation = new Nokia_Financial_Calendar__c();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		System.runAs(userCreation){
			accountList = TestDataFactory.createAccount(2);
			database.insert(accountList);
			opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);
			List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			database.insert(opportunityList);
			
			productCreation = TestDataFactory.productCreation(1)[0];
			productCreation.Business_Group__c='FN';
			productCreation.Family= 'FNCABLE'; 
			database.insert(productCreation);
			nokiaFinCalObjCreation = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCalObjCreation);
			pfdataObj.Name = 'PfData';
			pfdataObj1.Name = 'PfData1';
			pfdata.add(pfdataObj);
			pfdata.add(pfdataObj1);
			database.insert(pfdata);  
			oifCreation = TestDataFactory.orderIntakeCreation(2,opportunityList[0],productCreation,nokiaFinCalObjCreation);
			database.insert(oifCreation);   
			OptyProgramFlagJunction__c opfj = new OptyProgramFlagJunction__c();
			OptyProgramFlagJunction__c opfj1 = new OptyProgramFlagJunction__c();
			List<OptyProgramFlagJunction__c> opfjaddList = new List<OptyProgramFlagJunction__c>();  
			opfj.Opportunity__c = opportunityList[0].id;
			opfj.Program_Flag__c = pfdata[0].id;
			opfj1.Opportunity__c = opportunityList[0].id;
			opfj1.Program_Flag__c = pfdata[1].id;
			opfjaddList.add(opfj);
			opfjaddList.add(opfj1);
			database.insert(opfjaddList);
			database.delete(opfjaddList);
			List<Deal__c> dealList = TestDataFactory.createDeal(1);
			dealList[0].recordtypeid = dealFramedRecordTypeId;
			database.insert(dealList[0]);
			
			//Catching exception
			OptyProgramFlagJunctionTriggerHelper.retrictOptyProgramFlagJunction(NULL);
			OptyProgramFlagJunctionTriggerHelper.copyOpptyProgramFlagToOif(NULL,NULL);
			//Executing the batch
			Batch_copyOpptyPfToOif  opptyProgJuncBatch = new Batch_copyOpptyPfToOif();
			database.executeBatch(opptyProgJuncBatch);
			//opptyProgJuncBatch.execute(BC, dealList);
		}
	}
}