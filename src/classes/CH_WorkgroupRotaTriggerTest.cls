@isTest
public class CH_WorkgroupRotaTriggerTest
{
	@TestSetup 
	public static void setup(){
		CH_ManageCreateQueueAsynchQueue.doChainJob= false;
		CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
		Test.startTest();
		CH_Settings__c cstObj = new CH_Settings__c();
		cstObj.SettingValue__c = 'Yes';
		cstObj.Name = 'WorkgroupRotaTrigger';
		insert cstObj;
		system.debug('cstObj--'+cstObj);
		
		CH_Workgroup__c WorkgroupObj = new   CH_Workgroup__c();
		WorkgroupObj.Name ='testWorkgroup';
		WorkgroupObj.CH_Workgroup_Instructions__c ='Test Instructions ';
		insert WorkgroupObj;
		
		CH_Workgroup_Member__c testWorkgrpMember = new CH_Workgroup_Member__c();
		testWorkgrpMember.CH_User__c = UserInfo.getUserId();
		testWorkgrpMember.CH_Role__c = 'Expert';
		testWorkgrpMember.CH_Workgroup__c =WorkgroupObj.Id;
		// testWorkgrpMember.Name='testWorkgrpMemberName';
		insert testWorkgrpMember;
		
		List<CH_Workgroup_Event__c> rotaList =new List<CH_Workgroup_Event__c>();
		
		CH_Workgroup_Event__c workgroupRotaObj  =new CH_Workgroup_Event__c();
		//  workgroupRotaObj.Name='workgroupRotaObjName';
		workgroupRotaObj.CH_Workgroup__c=WorkgroupObj.Id;
		//workgroupRotaObj.OwnerId =UserInfo.getUserId();
		workgroupRotaObj.CH_WorkgroupMember__c=testWorkgrpMember.Id;
		workgroupRotaObj.CH_StartDate__c=(DateTime) JSON.deserialize('"2018-03-03T01:09:36.933"', DateTime.class);	   
		workgroupRotaObj.CH_EndDate__c=(DateTime) JSON.deserialize('"2019-03-03T01:09:36.933"', DateTime.class);
		workgroupRotaObj.CH_SupportType__c='On Call Primary';
		workgroupRotaObj.CH_Timezone__c='GMT';
		workgroupRotaObj.CH_Days__c='Sunday';
		workgroupRotaObj.CH_EndOccurence__c =(DateTime) JSON.deserialize('"2019-03-03T01:09:36.933"', DateTime.class);
		workgroupRotaObj.CH_Recoccurence__c=true;
		insert workgroupRotaObj;
		rotaList.add(workgroupRotaObj);
		Test.stopTest();
	}
	
	@IsTest
	public static void runTriggerTest(){
		CH_ManageCreateQueueAsynchQueue.doChainJob= false;
		CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
		Test.startTest();
		CH_Settings__c cstObj = new CH_Settings__c();
		cstObj.SettingValue__c = 'Yes';
		cstObj.Name = 'WorkgroupRotaTrigger';
		insert cstObj;
		
		CH_Workgroup__c WorkgroupObj = new   CH_Workgroup__c();
		WorkgroupObj.Name ='testWorkgroup';
		WorkgroupObj.CH_Workgroup_Instructions__c ='Test Instructions ';
		insert WorkgroupObj;
		
		CH_Workgroup_Member__c testWorkgrpMember = new CH_Workgroup_Member__c();
		testWorkgrpMember.CH_User__c = UserInfo.getUserId();
		testWorkgrpMember.CH_Role__c = 'Expert';
		testWorkgrpMember.CH_Workgroup__c =WorkgroupObj.Id;
		// testWorkgrpMember.Name='testWorkgrpMemberName';
		insert testWorkgrpMember;
		
		List<CH_Workgroup_Event__c> rotaList =new List<CH_Workgroup_Event__c>();
		CH_Workgroup_Event__c workgroupRotaObj  =new CH_Workgroup_Event__c();
		//  workgroupRotaObj.Name='workgroupRotaObjName';
		workgroupRotaObj.CH_Workgroup__c=WorkgroupObj.Id;
		//workgroupRotaObj.OwnerId =UserInfo.getUserId();
		workgroupRotaObj.CH_WorkgroupMember__c=testWorkgrpMember.Id;
		workgroupRotaObj.CH_StartDate__c=(DateTime) JSON.deserialize('"2018-03-03T01:09:36.933"', DateTime.class);	   
		workgroupRotaObj.CH_EndDate__c=(DateTime) JSON.deserialize('"2019-03-03T01:09:36.933"', DateTime.class);
		workgroupRotaObj.CH_SupportType__c='On Call Primary';
		workgroupRotaObj.CH_Timezone__c='GMT';
		workgroupRotaObj.CH_Days__c='Sunday';
		workgroupRotaObj.CH_EndOccurence__c =(DateTime) JSON.deserialize('"2019-03-03T01:09:36.933"', DateTime.class);
		workgroupRotaObj.CH_Recoccurence__c=true;
		insert workgroupRotaObj;
		rotaList.add(workgroupRotaObj);
		Test.stopTest();
	}
	
	@isTest
	static void testFilter(){
		CH_Workgroup__c testWorkgroupObj = new   CH_Workgroup__c();
		testWorkgroupObj =[Select Id,Name From CH_Workgroup__c ];
		CH_Workgroup_Member__c testWorkgrpMember = new CH_Workgroup_Member__c();
		testWorkgrpMember=[Select Id,Name From CH_Workgroup_Member__c ];
		Test.startTest();
		CH_FilterRota.getWorkgroupRota(testWorkgroupObj.Id,testWorkgrpMember.Id, '2018-09-11', '2018-09-12');
		Test.stopTest();
	}
	
	@isTest
	static void getMyWorkgroupRotaTest(){	
		Test.startTest();
		CH_FilterRota.getMyWorkgroupRota();
		Test.stopTest();
	}
	
	@isTest
	static void getUserNameTest(){
		Test.startTest();
		CH_FilterRota.getUserName();
		Test.stopTest();
	}
}