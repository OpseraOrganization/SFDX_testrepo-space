/****************************************
* Class Name : CH_DisplayEntitlementScript
* Created Date: 08 Sept 2018
* Created By : TSALEM
* Last Modified by: TSALEM
* Last Modified Date: 08 Sept 2018
* Description : Utility calss to retrieve the Entitlement Script from 
* User Story Reference: NOKIASC-1370

* Test Class: CH_DisplayEntitlementScript_TEST
*****************************************/
public class CH_DisplayEntitlementScript {	
	@AuraEnabled
	public static Map < String, String > getEntitlementScript(Id caseId) {
		Case currentCase = [SELECT Id, entitlementId FROM Case WHERE Id=:caseId];
		String contLineScript = '(no line item script)';
		String contractScript = '(no contract script)';
		
		Map < String, String > scriptToRetunrMap = new Map < String, String >();
		
		if (currentCase != null && currentCase.EntitlementId != null) {
			String s = [SELECT ContractLineItem.CH_LineItemEntitlementScript__c FROM Entitlement WHERE Id = :currentCase.EntitlementId limit 1].ContractLineItem.CH_LineItemEntitlementScript__c;			
			if (!String.isEmpty(s)) {
				contLineScript = s;
			}			
			scriptToRetunrMap.put('ContractLineScript', s);
			
			String x = [SELECT servicecontract.CH_EntitlementScript__c FROM contractlineitem WHERE Id IN 
						(SELECT contractlineitemid FROM entitlement WHERE Id =:currentCase.EntitlementId) limit 1].servicecontract.CH_EntitlementScript__c;			
			if (!String.isEmpty(x)) {
				contractScript = x;
			}			
			scriptToRetunrMap.put('ContractScript',x);
		}		
		return scriptToRetunrMap;
	}
	
	//Description - to close CH_Display_Entitlement_Script component US NOKIASC-16353
	@AuraEnabled
	public static void closeComponentMethod(Id caseId) {
		Case caseObj = new case();
		caseObj = [SELECT Id, CH_EntitlementScriptFlag__c FROM Case WHERE Id=:caseId Limit 1];
		if(caseObj != null){
			caseObj.CH_EntitlementScriptFlag__c = true;
			update caseObj;
		}
	}	
}