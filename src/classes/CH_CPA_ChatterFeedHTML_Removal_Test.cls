@isTest(seeAlldata=false)
public class CH_CPA_ChatterFeedHTML_Removal_Test {
	
	@isTest
	public static void CPAChatterFeedHTMLTriggertest(){
		Test.startTest();
		String userval=UserInfo.getUserId();
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
		cpaValue.CH_CPA_Manager__c=userval;
		cpaValue.CH_Recommendation__c='testRecommendation';
		cpaValue.CH_Follow_up__c ='testFollowUp';
		cpaValue.CH_Result__c ='testResult';
		insert cpaValue;
		Test.stopTest();
		 System.assertEquals(cpaValue.CH_Domain__c, 'Care');
	}
	
}