/* Type:  Apex Class
* Name - CH_CA_WorkgroupScheduleSearch_Test
* Description - This class is created to test CH_CA_WorkgroupScheduleSearch_Controller 
* Developer: TCS
* */
@IsTest
public class CH_CA_WorkgroupScheduleSearch_Test {
	@testSetup   
	static void setuptestdata(){   
		setuprecords();
	}
	
	static private void setuprecords(){  
		
		//creating workgroup
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		
		CH_Workgroup__c wg = new CH_Workgroup__c(CH_End_of_Business_Hours_Threshold__c = 60,
	CH_Level_Of_Support__c = 'Initial Support',
	CH_Start_of_Business_Hours_Threshold__c = 60,
	CH_Type__c = 'Engineer',
	Name='TestWorkgroupforScheduleSearch');
		insert wg;
		
		//Creating Workgroup Schedule without any filter 
		CH_Workgroup_Schedule__c wgScheduleWithoutFilter = new CH_Workgroup_Schedule__c();
		wgScheduleWithoutFilter.Name = 'wgScheduleWithoutFilter';
		wgScheduleWithoutFilter.CH_Start_DateTime__c = DateTime.now().addDays(-10);
		wgScheduleWithoutFilter.CH_End_DateTime__c = DateTime.now().addDays(10);
		wgScheduleWithoutFilter.CH_StartDateTime__c = DateTime.now().addDays(-10);
		wgScheduleWithoutFilter.CH_EndDateTime__c = DateTime.now().addDays(10);
		wgScheduleWithoutFilter.CH_Workgroup__c  = wg.Id;
		wgScheduleWithoutFilter.CH_Time_Zone__c = 'UTC';
		insert wgScheduleWithoutFilter;
		
		//Creating Workgroup Schedule with filter with weight 5 
		CH_Workgroup_Schedule__c wgScheduleWithFilter = new CH_Workgroup_Schedule__c();
		wgScheduleWithFilter.Name = 'wgScheduleWithFilter';
		wgScheduleWithFilter.CH_Start_DateTime__c = DateTime.now().addDays(-10);
		wgScheduleWithFilter.CH_End_DateTime__c = DateTime.now().addDays(10);
		wgScheduleWithFilter.CH_StartDateTime__c = DateTime.now().addDays(-10);
		wgScheduleWithFilter.CH_EndDateTime__c = DateTime.now().addDays(10);
		wgScheduleWithFilter.CH_Workgroup__c  = wg.Id;
		wgScheduleWithFilter.CH_Time_Zone__c = 'UTC';
		insert wgScheduleWithFilter;
		
		//Creating filter 
		CH_Workgroup_Filter__c schedulefilter = new CH_Workgroup_Filter__c(CH_Country__c = 'India',
		 CH_Outage__c = 'Yes',
		 CH_Region__c='Market India',
		 CH_Severity__c='Critical',
		 CH_Workgroup_Schedule__c=wgScheduleWithFilter.Id,
		 CH_Workgroup_Type__c = 'Engineer' );
		insert schedulefilter;
		
		
		//Creating Workgroup Schedule with filter with weight 1 
		//weight values are based on matching crieteria on filter record if 1 value matches weight is 1, if 2 matches weight would be 2 and so on....
		CH_Workgroup_Schedule__c wgScheduleWithFilter1 = new CH_Workgroup_Schedule__c();
		wgScheduleWithFilter1.Name = 'wgScheduleWithFilter1';
		wgScheduleWithFilter1.CH_Start_DateTime__c = DateTime.now().addDays(-10);
		wgScheduleWithFilter1.CH_End_DateTime__c = DateTime.now().addDays(10);
		wgScheduleWithFilter1.CH_StartDateTime__c = DateTime.now().addDays(-10);
		wgScheduleWithFilter1.CH_EndDateTime__c = DateTime.now().addDays(10);
		wgScheduleWithFilter1.CH_Workgroup__c  = wg.Id;
		wgScheduleWithFilter1.CH_Time_Zone__c = 'UTC';
		insert wgScheduleWithFilter1;
		
		//Creating filter 
		CH_Workgroup_Filter__c schedulefilter1 = new CH_Workgroup_Filter__c(CH_Country__c = 'India',
				CH_Workgroup_Schedule__c=wgScheduleWithFilter1.Id);
		insert schedulefilter1;
		
		//Creating Workgroup Schedule with filter and weight 2
		//
		CH_Workgroup_Schedule__c wgScheduleWithFilter2 = new CH_Workgroup_Schedule__c();
		wgScheduleWithFilter2.Name = 'wgScheduleWithFilter2';
		wgScheduleWithFilter2.CH_Start_DateTime__c = DateTime.now().addDays(-10);
		wgScheduleWithFilter2.CH_End_DateTime__c = DateTime.now().addDays(10);
		wgScheduleWithFilter2.CH_StartDateTime__c = DateTime.now().addDays(-10);
		wgScheduleWithFilter2.CH_EndDateTime__c = DateTime.now().addDays(10);
		wgScheduleWithFilter2.CH_Workgroup__c  = wg.Id;
		wgScheduleWithFilter2.CH_Time_Zone__c = 'UTC';
		insert wgScheduleWithFilter2;
		
		//Creating filter 
		CH_Workgroup_Filter__c schedulefilter2 = new CH_Workgroup_Filter__c(CH_Country__c = 'India',
				CH_Outage__c = 'Yes',
				CH_Workgroup_Schedule__c=wgScheduleWithFilter2.Id);
		insert schedulefilter2;
		
		//Creating Workgroup Schedule with filter and weight 3
		CH_Workgroup_Schedule__c wgScheduleWithFilter3 = new CH_Workgroup_Schedule__c();
		wgScheduleWithFilter3.Name = 'wgScheduleWithFilter3';
		wgScheduleWithFilter3.CH_Start_DateTime__c = DateTime.now().addDays(-10);
		wgScheduleWithFilter3.CH_End_DateTime__c = DateTime.now().addDays(10);
		wgScheduleWithFilter3.CH_StartDateTime__c = DateTime.now().addDays(-10);
		wgScheduleWithFilter3.CH_EndDateTime__c = DateTime.now().addDays(10);
		wgScheduleWithFilter3.CH_Workgroup__c  = wg.Id;
		wgScheduleWithFilter3.CH_Time_Zone__c = 'UTC';
		insert wgScheduleWithFilter3;
		
		//Creating filter 
		CH_Workgroup_Filter__c schedulefilter3 = new CH_Workgroup_Filter__c(CH_Country__c = 'India',
				CH_Outage__c = 'Yes',
				CH_Workgroup_Type__c = 'Engineer',
				CH_Workgroup_Schedule__c=wgScheduleWithFilter3.Id);
		insert schedulefilter3;
		
		//Creating Workgroup Schedule with filter and weight 4
		CH_Workgroup_Schedule__c wgScheduleWithFilter4 = new CH_Workgroup_Schedule__c();
		wgScheduleWithFilter4.Name = 'wgScheduleWithFilter4';
		wgScheduleWithFilter4.CH_Start_DateTime__c = DateTime.now().addDays(-10);
		wgScheduleWithFilter4.CH_End_DateTime__c = DateTime.now().addDays(10);
		wgScheduleWithFilter4.CH_StartDateTime__c = DateTime.now().addDays(-10);
		wgScheduleWithFilter4.CH_EndDateTime__c = DateTime.now().addDays(10);
		wgScheduleWithFilter4.CH_Workgroup__c  = wg.Id;
		wgScheduleWithFilter4.CH_Time_Zone__c = 'UTC';
		insert wgScheduleWithFilter4;
		
		//Creating filter 
		CH_Workgroup_Filter__c schedulefilter4 = new CH_Workgroup_Filter__c(CH_Country__c = 'India',
				CH_Outage__c = 'Yes',
				CH_Workgroup_Type__c = 'Engineer',
				CH_Severity__c='Critical',
				CH_Workgroup_Schedule__c=wgScheduleWithFilter4.Id);
		insert schedulefilter4;
		
		//Creating Workgroup Schedule with filter and weight 5 
		CH_Workgroup_Schedule__c wgScheduleWithFilter5 = new CH_Workgroup_Schedule__c();
		wgScheduleWithFilter5.Name = 'wgScheduleWithFilter5';
		wgScheduleWithFilter5.CH_Start_DateTime__c = DateTime.now().addDays(-10);
		wgScheduleWithFilter5.CH_End_DateTime__c = DateTime.now().addDays(10);
		wgScheduleWithFilter5.CH_StartDateTime__c = DateTime.now().addDays(-10);
		wgScheduleWithFilter5.CH_EndDateTime__c = DateTime.now().addDays(10);
		wgScheduleWithFilter5.CH_Workgroup__c  = wg.Id;
		wgScheduleWithFilter5.CH_Time_Zone__c = 'UTC';
		insert wgScheduleWithFilter5;
		
		//Creating filter 
		CH_Workgroup_Filter__c schedulefilter5 = new CH_Workgroup_Filter__c(CH_Country__c = 'Albania',
				CH_Outage__c = 'No',
				CH_Workgroup_Type__c = 'Expert',
				CH_Severity__c='Minor',
				CH_Workgroup_Schedule__c=wgScheduleWithFilter5.Id);
		insert schedulefilter5;
		
		//Creating Workgroup Schedule with filter and weight 6
		CH_Workgroup_Schedule__c wgScheduleWithFilter6 = new CH_Workgroup_Schedule__c();
		wgScheduleWithFilter6.Name = 'wgScheduleWithFilter6';
		wgScheduleWithFilter6.CH_Start_DateTime__c = DateTime.now().addDays(-10);
		wgScheduleWithFilter6.CH_End_DateTime__c = DateTime.now().addDays(10);
		wgScheduleWithFilter6.CH_StartDateTime__c = DateTime.now().addDays(-10);
		wgScheduleWithFilter6.CH_EndDateTime__c = DateTime.now().addDays(10);
		wgScheduleWithFilter6.CH_Workgroup__c  = wg.Id;
		wgScheduleWithFilter6.CH_Time_Zone__c = 'UTC';
		insert wgScheduleWithFilter6;
		
		//Creating filter 
		CH_Workgroup_Filter__c schedulefilter6 = new CH_Workgroup_Filter__c(CH_Country__c = 'India',
				CH_Outage__c = 'Yes',
				CH_Region__c='Market India',
				CH_Severity__c='Critical',
				CH_Workgroup_Schedule__c=wgScheduleWithFilter6.Id,
				CH_Workgroup_Type__c = 'Engineer' );
		insert schedulefilter6;
		//Associating filter with customer
		Id accountLegalEntityRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		Account tempLegalAccount = new Account(
			Name = 'LEGAL-ACCOUNT',
			OwnerId = UserInfo.getUserId(),
			RecordTypeId = accountLegalEntityRecordType,
			Country__c = 'Bahrain'
		);
		insert tempLegalAccount;
		CH_Workgroup_Filter_Customer_Association__c custAsso6 = new CH_Workgroup_Filter_Customer_Association__c();
		custAsso6.CH_Account__c = tempLegalAccount.Id;
		custAsso6.CH_Workgroup_Filter__c = schedulefilter6.Id;
		insert custAsso6;
		
		//Creating Workgroup Schedule  with filter and weight 7
		CH_Workgroup_Schedule__c wgScheduleWithFilter7 = new CH_Workgroup_Schedule__c();
		wgScheduleWithFilter7.Name = 'wgScheduleWithFilter7';
		wgScheduleWithFilter7.CH_Start_DateTime__c = DateTime.now().addDays(-10);
		wgScheduleWithFilter7.CH_End_DateTime__c = DateTime.now().addDays(10);
		wgScheduleWithFilter7.CH_StartDateTime__c = DateTime.now().addDays(-10);
		wgScheduleWithFilter7.CH_EndDateTime__c = DateTime.now().addDays(10);
		wgScheduleWithFilter7.CH_Workgroup__c  = wg.Id;
		wgScheduleWithFilter7.CH_Time_Zone__c = 'UTC';
		insert wgScheduleWithFilter7;
		
		//Creating filter 
		CH_Workgroup_Filter__c schedulefilter7 = new CH_Workgroup_Filter__c(CH_Country__c = 'India',
				CH_Outage__c = 'Yes',
				CH_Region__c='Market India',
				CH_Severity__c='Critical',
				CH_Workgroup_Schedule__c=wgScheduleWithFilter7.Id,
				CH_Workgroup_Type__c = 'Engineer' );
		insert schedulefilter7;
		//Associating filter with customer
		CH_Workgroup_Filter_Customer_Association__c custAsso7 = new CH_Workgroup_Filter_Customer_Association__c();
		custAsso7.CH_Account__c = tempLegalAccount.Id;
		custAsso7.CH_Workgroup_Filter__c = schedulefilter7.Id;
		insert custAsso7;
		
		//Associating filter with product
		Product2 tempProduct = new Product2(
			Name = 'TestProduct' ,
			NokiaCPQ_State__c = 'Implement',
			NCP_CAREACTIVATE__c = 'test',
			PMD_Portfolio_Classification__c = 'Product'
		);
		insert tempProduct;
		Product2 tempProductModule = new Product2(
			Name = 'TestProductModule' ,
			NokiaCPQ_State__c = 'Implement',
			NCP_CAREACTIVATE__c = 'test',
			PMD_Portfolio_Classification__c = 'Product Modules'
		);
		insert tempProductModule;
		
		CH_Workgroup_Filter_Product_Association__c prodAsso7 = new CH_Workgroup_Filter_Product_Association__c();
		prodAsso7.CH_Product__c = tempProduct.Id;
		prodAsso7.CH_Workgroup_Filter__c = schedulefilter7.Id;
		insert prodAsso7;
	}
	
	//test method - to test getselectOptions method
	static testMethod void testgetselectOptions() {
		test.startTest();
		CH_Workgroup_Filter__c sObj = new CH_Workgroup_Filter__c();
		//getting list of picklist values
		List<string> selectOptions = CH_CA_WorkgroupScheduleSearch_Controller.getselectOptions(sObj , 'CH_Workgroup_Type__c');
		//creating expected list of picklist values
		List<string> expectedOptions = new List<string>();
		expectedOptions.add('Customer Care Manager');
		expectedOptions.add('Engineer');
		expectedOptions.add('Exclusions Quotation Support-CDM');
		expectedOptions.add('Exclusions Quotation Support-OC');
		expectedOptions.add('Expert');
		expectedOptions.add('Field Support');
		expectedOptions.add('Incident Managers');
		expectedOptions.add('Quotation Only');
		expectedOptions.add('Quotation Support');
		expectedOptions.add('Smart Tier 1');
		expectedOptions.add('Technical Escalation Managers');	
		expectedOptions.add('Warranty Only');
		expectedOptions.add('Warranty Support');
		expectedOptions.add('Warranty and Quotation');
		//comparing expected results with actual ones
		system.assertEquals(expectedOptions, selectOptions);
		test.stopTest();
	}
	
	//test method - to test searchSchedules FOR ACTIVE = true parameter
	static testMethod void testsearchSchedulesforActive() {
		test.startTest();
		//creating parameter
		String startDate= string.valueOf(DateTime.now().addDays(-20));
		String endDate=string.valueOf(DateTime.now().addDays(20));
		String setStartTime= string.valueOf(Datetime.now().Time());
		String setEndTime= string.valueOf(Datetime.now().Time());
		//active set to Yes i.e True
		String active = 'Yes';
		String workgroupType = 'Engineer';
		Account newAccount = [SELECT ID,Name from Account where Name = 'LEGAL-ACCOUNT' LIMIT 1];
		String customer=newAccount.Id;
		String region = 'Market Asia-Pacific';
		String country = 'India';
		String severity = 'Critical';
		Product2 tempProduct = [SELECT Id,NokiaCPQ_State__c,NCP_CAREACTIVATE__c,PMD_Additional_Classification__c,PMD_Portfolio_Classification__c FROM Product2 WHERE Name = 'TestProduct' LIMIT 1];
		string product = tempProduct.Id;
		String outage = 'Yes';
		string workgroupId = [SELECT ID FROM CH_Workgroup__C WHERE Name='TestWorkgroupforScheduleSearch'].Id; 
		//getting actual results of workgroup schedules
		List <Object> actual = CH_CA_WorkgroupScheduleSearch_Controller.searchSchedules( startDate,  endDate, setStartTime, setEndTime,  active,  workgroupType, 
				customer,  region,  country, 
				severity,  product, outage , '',workgroupId,'','','');
		
		//creating expected list of results i.e workgroup schedules with Active = true
		DateTime strtD = DateTime.now().addDays(-20);
		DateTime endD = DateTime.now().addDays(20);
		List <sObject> expected = [SELECT Id,Name,CH_Start_DateTime__c,CH_EndDateTime__c,CH_StartDateTime__c,CH_End_DateTime__c,CH_Active__c ,CH_Workgroup_Filters_Count__c, 
	 (SELECT CH_Workgroup_Type__c,CH_Region__c,CH_Country__c,CH_Severity__c,CH_Outage__c  FROM CH_Workgroup_Filters__r)
	 FROM CH_Workgroup_Schedule__c 
	 WHERE CH_Workgroup__c = : workgroupId 
	 AND CH_Start_DateTime__c >= :strtD
	 AND CH_Start_DateTime__c <= :endD
	 AND CH_Active__c =true]; 
		//comparing expected results with actual ones
		system.assertEquals(string.valueOf(expected), string.valueOf(actual));
		test.stopTest();
	}	
	
	//test method - to test deleteSchedule method
	static testMethod void testdeleteSchedule() {
		test.startTest();
		//getting record to delete.
		CH_Workgroup_Schedule__c wgSchedule = [SELECT Id,Name FROM CH_Workgroup_Schedule__c WHERE Name='wgScheduleWithFilter' Limit 1];
		//below statement will delete the record.
		CH_CA_WorkgroupScheduleSearch_Controller.deleteSchedule(wgSchedule.Id);
		//checking in deleted records ...
		CH_Workgroup_Schedule__c wgScheduleD = [SELECT Id,IsDeleted from CH_Workgroup_Schedule__c WHERE Id =: wgSchedule.Id ALL ROWS];
		//IsDeleted would be returned True if the record is deleted.
		system.assert(true,wgScheduleD.IsDeleted);
		test.stopTest();
	}
	
	//test method - to test getSchedulePerUser method
	static testMethod void getSchedulePerUser() {
		test.startTest();
		String setStartTime= string.valueOf(Datetime.now().Time());
		String setEndTime= string.valueOf(Datetime.now().Time());
		List<CH_Workgroup_Member_Timeslot_Association__c> workgroup_Member_Timeslot_Association1 = new List<CH_Workgroup_Member_Timeslot_Association__c>();		
		List<CH_Workgroup_Member_Timeslot_Association__c> workgroup_Member_Timeslot_Association =  new List<CH_Workgroup_Member_Timeslot_Association__c>();
		Workgroup_Member_Timeslot_Association = CH_CA_WorkgroupScheduleSearch_Controller.getSchedulePerUser(String.valueOf(system.now()),String.valueOf(system.now().addMonths(1)),setStartTime,setEndTime,UserInfo.getUserId());
		system.assertEquals(workgroup_Member_Timeslot_Association1, workgroup_Member_Timeslot_Association);
		test.stopTest();
	} 
	
	//test method - to test getUserDetail method
	static testMethod void getUserDetail() {
		test.startTest();
		String userName;
		userName = CH_CA_WorkgroupScheduleSearch_Controller.getUserDetail();		
		system.assertEquals(userName,UserInfo.getUserId());
		test.stopTest();
	} 
	
	//test method - to test getUserDetail method
	static testMethod void getDateTimeDetails() {
		Test.startTest();
		CH_CA_WorkgroupScheduleSearch_Controller.getDateTimeValues actual = new CH_CA_WorkgroupScheduleSearch_Controller.getDateTimeValues();
		actual = CH_CA_WorkgroupScheduleSearch_Controller.getDateTimeDetails();
		system.assertEquals(string.valueOf(Datetime.now().date().addMonths(1)), string.valueOf(actual.getEndDate));
		Test.StopTest();
	} 
}