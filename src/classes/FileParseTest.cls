@isTest 
public class FileParseTest
{
	static testMethod void getObjectType() 
	{
		FileParse.getObjectType();
	}
	
	static testMethod void getObjects() 
	{
		FileParse.getObjects('custom');
	}
	
	static testMethod void passFile_Jason() 
	{
		
		string strjason =  '[{"Co_Op_Allocation_Amount__c":"Blank","ION_Revenue__c":"Blank","ION_Allocation__c":"Blank","ION__c":"Blank","ION_NUAGE_Revenue__c":'+
			'"Blank","ION_NUAGE_Allocation__c":"Blank","ION_NUAGE__c":"Blank","ION_Optics_Revenue__c":"Blank","ION_OPTICS_Allocation__c":"Blank","'+
			'ION_OPTICS__c":"Blank","ION_Routing_Revenue__c":"Blank","ION_Routing_Allocation__c":"Blank","ION_Routing__c":"Blank","FN_Revenue__c":"Blank"'+
			',"FN_Allocation__c":"Blank","FN__c":"Blank","A_A_VITAL_Revenue__c":"Blank","A_A_VITAL_Allocation__c":"Blank","A_A_VITAL__c":"Blank",'+
			' "MN_Revenue__c":"Blank","Partner_Name__c":"0014100000LUVlyAAH","MN_Allocation__c":"Blank","MN__c":"Blank","Fund_Id__c":"aCW1g0000004CGAGA2",'+
			' "Allocation_Month__c":"dataload check","Allocation_Year__c":"May","Available_Date__c":"2018-06-06","Co_Op_Eligible_Revenue__c":"Blank"}]';
		
		FileParse.passFile_Jason(strjason ,'Co_Op_Allocation__c','Insert');
	}
	
	static testMethod void passFile_JasonUpdate() 
	{
		
		
		string strjason =  '[{"id":"0014100000LUVlyAAH","Co_Op_Allocation_Amount__c":"Blank","ION_Revenue__c":"Blank","ION_Allocation__c":"Blank","ION__c":"Blank","ION_NUAGE_Revenue__c":'+
			'"Blank","ION_NUAGE_Allocation__c":"Blank","ION_NUAGE__c":"Blank","ION_Optics_Revenue__c":"Blank","ION_OPTICS_Allocation__c":"Blank","'+
			'ION_OPTICS__c":"Blank","ION_Routing_Revenue__c":"Blank","ION_Routing_Allocation__c":"Blank","ION_Routing__c":"Blank","FN_Revenue__c":"Blank"'+
			',"FN_Allocation__c":"Blank","FN__c":"Blank","A_A_VITAL_Revenue__c":"Blank","A_A_VITAL_Allocation__c":"Blank","A_A_VITAL__c":"Blank",'+
			' "MN_Revenue__c":"Blank","MN_Allocation__c":"Blank","MN__c":"Blank",'+
			' "Allocation_Month__c":"dataload check","Allocation_Year__c":"May","Available_Date__c":"2018-06-06","Co_Op_Eligible_Revenue__c":"Blank"}]';
		
		FileParse.passFile_Jason(strjason ,'Co_Op_Allocation__c','Update');
	}
	
	
	static testMethod void getFields() 
	{
		
		FileParse.getFields('Co_Op_Allocation__c');
	}
	
	static testMethod void fetchContact() 
	{
		
		FileParse.fetchContact();
	}
	
	static testMethod void getBatchStatus() 
	{
		
		FileParse.getBatchStatus(null);
	}
	
	
	static testMethod void fetchParseResult() 
	{
		Parse_Result__c objParse = new Parse_Result__c();
		objParse.Apex_JobID__c = 'ApexJob';
		objParse.User_ID__c =UserInfo.getUserId();
		insert objParse ;
		
		csvDownloadCtrl.fetchParseResult(objParse.Apex_JobID__c );
		csvDownloadCtrl.getBatchStatus(null);
	}
	
	static testMethod void DataDeleteBatch() 
	{
		Parse_Result__c objParse = new Parse_Result__c();
		objParse.Apex_JobID__c = 'ApexJob';
		objParse.User_ID__c =UserInfo.getUserId();
		insert objParse ;
		
		DataLoad_Delete  sh1 = new DataLoad_Delete();
		Test.StartTest();
		String sch = '0 0 23 * * ?'; 
		system.schedule('Test Territory Check', sch, sh1);
		Test.stopTest();
		
	}
}