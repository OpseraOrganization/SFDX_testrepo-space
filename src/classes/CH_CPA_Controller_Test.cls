@isTest
public class CH_CPA_Controller_Test {
	
	@isTest
	public static void CPAControllertest(){
		Test.startTest();
		String userVal=UserInfo.getUserId();
		CH_Corrective_Preventive_Action__c cpaValue= new CH_Corrective_Preventive_Action__c();
		cpaValue.CH_Source__c='Case Handling Routing Issue';
		cpaValue.CH_Priority__c='High';
		cpaValue.CH_Category__c ='Customer';
		cpaValue.CH_Sub_category__c='Documentation';
		cpaValue.CH_Scope__c='All Customer';
		cpaValue.CH_Domain__c='Care';
		cpaValue.CH_Closing_criteria__c='CPA no longer needed';
		cpaValue.CH_Description__c='oktest';
		cpaValue.CH_Cause_Analysis__c='oktest';
		cpaValue.CH_CPA_Manager__c=userVal;
		cpaValue.CH_Recommendation__c='testRecommendation';
		cpaValue.CH_Follow_up__c ='testFollowUp';
		cpaValue.CH_Result__c ='testResult';
		cpaValue.CH_Rejection_Cause__c='No Capacity';
		insert cpaValue;
		Test.stopTest();
		CH_Corrective_Preventive_Action__c objCPAUpdate = [select id, CH_CPA_Status__c,CH_Rejection_Cause__c from CH_Corrective_Preventive_Action__c LIMIT 1];   
		System.assertEquals(objCPAUpdate.CH_Rejection_Cause__c, 'No Capacity');
		CH_CPA_Controller.acceptCPA(objCPAUpdate.Id);
		CH_CPA_Controller.rejectCPA(objCPAUpdate.Id,objCPAUpdate.CH_Rejection_Cause__c);
		CH_CPA_Controller.transferCPAFieldsQuery(objCPAUpdate.Id);
		
	}
	
}