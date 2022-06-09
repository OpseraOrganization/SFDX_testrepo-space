@isTest(seeAlldata=false)
public class CH_CPATrigger_Test {
	
	@isTest
	public static void CPATriggertest(){
		Test.startTest();
		String userval=UserInfo.getUserId();
		CH_Corrective_Preventive_Action__c cpaval= new CH_Corrective_Preventive_Action__c();
		cpaval.CH_Source__c='Case Handling Routing Issue';
		cpaval.CH_Priority__c='High';
		cpaval.CH_Category__c ='Customer';
		cpaval.CH_Sub_category__c='Documentation';
		cpaval.CH_Scope__c='All Customer';
		cpaval.CH_Domain__c='Care';
		cpaval.CH_Closing_criteria__c='CPA no longer needed';
		cpaval.CH_Description__c='oktest';
		cpaval.CH_Cause_Analysis__c='oktest';
		cpaval.CH_CPA_Manager__c=userval;
		insert cpaval;
		List <CH_Corrective_Preventive_Action__c> aval=[select 	id,CH_Description__c from CH_Corrective_Preventive_Action__c limit 1];
		String testval=aval[0].CH_Description__c;
		system.assertEquals('oktest', testval);
		Test.stopTest();
		
		
	}

}