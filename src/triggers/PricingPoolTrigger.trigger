/*******************************
Created by: Standav
Created Date: 27 April 2021
Last modified by: 
Last modified date:  
Description: Pricing Pool Trigger for Name duplication
*******************************/
trigger PricingPoolTrigger on CPQ_PricingPool__c (before insert, before update) {
	set<string> nameset=new set<string>();
	Set<String> existingNames = new Set<String>();
	
	for(CPQ_PricingPool__c p:trigger.new)
	{
		nameset.add(p.CPQ_Pricing_Pool_Name__c);
	}
	
	if(!nameset.isEmpty()){
	List<CPQ_PricingPool__c> cpqlist= new list<CPQ_PricingPool__c>([select Id,CPQ_Pricing_Pool_Name__c from CPQ_PricingPool__c where CPQ_Pricing_Pool_Name__c in: nameset]);
	
	for(CPQ_PricingPool__c pl: cpqlist){
	existingNames.add(pl.CPQ_Pricing_Pool_Name__c); 
		
	}
	}
	
	
	if(!existingNames.isEmpty()){
	for(CPQ_PricingPool__c cp:trigger.new)
	{
		if(existingNames.contains(cp.CPQ_Pricing_Pool_Name__c))
		{
			cp.CPQ_Pricing_Pool_Name__c.adderror('Duplicate Name found Please rectify Pricing Pool Name');
			
		}
	}
	}
}