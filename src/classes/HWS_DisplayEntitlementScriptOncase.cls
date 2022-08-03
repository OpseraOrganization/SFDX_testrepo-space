public without sharing class HWS_DisplayEntitlementScriptOncase {
	
	@AuraEnabled
	public static Map<string,string> getEntitlementscript(Id caseId){
		system.debug('case Id value###'+caseId);
		String contLineScript = 'No Contract line Entitlement script';
		String contractScript = 'No Servicecontract Entitlement script';
		
		Map<string,string> returnscript = new map<string,string>();
		
		if (caseId != null)
		{
			Case casescript = [select HWS_Contract_Line_Item__r.CH_LineItemEntitlementScript__c,HWS_Contract_Line_Item__r.ServiceContract.CH_EntitlementScript__c
							   from case where id = :caseId];
			
			if(casescript != null)
			{
				string s = casescript.HWS_Contract_Line_Item__r.CH_LineItemEntitlementScript__c;
				string x = casescript.HWS_Contract_Line_Item__r.ServiceContract.CH_EntitlementScript__c; 
				
				if (!String.isEmpty(s))
				{
					contLineScript = s;
				}
				returnscript.put('ContractLineItemEntitlementScript',contLineScript);
				
				if (!String.isEmpty(x))
				{
					contractScript = x;
				}
				
				returnscript.put('ServiceContract',contractScript);
			}			
			
		}
		system.debug('********map'+returnscript);
		return returnscript;
	}   
}