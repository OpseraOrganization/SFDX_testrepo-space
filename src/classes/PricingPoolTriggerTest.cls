/*******************************
Created by: Standav
Created Date: 27 April 2021
Last modified by: 
Last modified date:  
Description: Test class for Pricing Pool Trigger
*******************************/

@isTest
public class PricingPoolTriggerTest {
	
	public static testMethod void duplicateRecords(){
		CPQ_PricingPool__c cp =new CPQ_PricingPool__c();
		cp.CPQ_Pricing_Pool_Name__c= 'Test';
		cp.CPQ_Active__c=true;
		insert cp;
		CPQ_PricingPool__c cp1 = new CPQ_PricingPool__c();
		cp1.CPQ_Pricing_Pool_Name__c= 'Test';
		cp1.CPQ_Active__c=true;
		try{
			insert cp1;
		}catch(Exception e){
			//Do Nothing
		}
		
		
	}

}