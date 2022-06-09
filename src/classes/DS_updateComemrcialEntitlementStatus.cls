/**
* @description: This class with update Comemrtial entitlement Status based on CPOLI status and CPOLI status if available quantity become 0
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION	   AUTHOR				  DATE		   DETAIL				 FEATURES/CSR/TTP
* 1.0		   Sonali Kothavale		18/02/2019	 DS Feb Release
* ============================================================================ 
**/
public class DS_updateComemrcialEntitlementStatus implements Queueable{ 
	set<ID> cPOLI = new set<ID>();   
	set<ID> toBeExpired = new set<ID>();
	
	 /**********************************************************************************************************************
	* author: Accenture
	* Date: Feb-2019
	* Param: Set<ID> CPOLI- List Of LI where status got upadted, Set<ID> toBeExpired - list of LI which got upadted to expired
	* Return: void
	* Description: Constructor
	* High Level Process : 
	**********************************************************************************************************************/ 
	public DS_updateComemrcialEntitlementStatus(Set<ID> cPOLI, Set<ID> toBeExpired){
		this.cPOLI = cPOLI;
		this.toBeExpired = toBeExpired;
	}
	
	 /**********************************************************************************************************************
	* author: Accenture
	* Date: Feb-2019
	* Param: from constructor
	* Return: void
	* Description: Method for upadting Entitlement status on CPO LI status upaded and CPOLI if available quantity become 0
	* High Level Process :  
	**********************************************************************************************************************/ 
	public void execute(QueueableContext context) 
	{	
		try{
			list<Apttus_Config2__CustomerPOItem__c> cpoLIsToProcess = new list<Apttus_Config2__CustomerPOItem__c>();
			list<Apttus_Config2__CustomerPOItem__c> toBeExpiredLI = new list<Apttus_Config2__CustomerPOItem__c>();
			list<Apttus_Config2__CustomerPOItem__c> expiryUpdateLI = new list<Apttus_Config2__CustomerPOItem__c>();
			list<Apttus_Config2__CustomerPOItem__c> allCPOLIForEntitlements = new list<Apttus_Config2__CustomerPOItem__c>();
			set<ID> commercialEntitlementIDs = new set<ID>();
			list<Commercial_Entitlement__c> commercialEntitlements = new list<Commercial_Entitlement__c>();
			List<Commercial_Entitlement__c> comemrcialEntitlementToBeUpdated = new list<Commercial_Entitlement__c>();
			map<ID, list<Apttus_Config2__CustomerPOItem__c>> entitlementToCPOLI = new map<ID, list<Apttus_Config2__CustomerPOItem__c>>();
			map<ID, string> entitleToStatusUpadtes = new map<ID, string>();
			boolean isAnyEntitled = false;
			boolean isAnyPending = false;
			
			cpoLIsToProcess = [select id, Commercial_Entitlement__c, Commercial_Entitlement_Status__c 
			from Apttus_Config2__CustomerPOItem__c where id in: cPOLI 
			Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			
			
			if(!(cpoLIsToProcess.isempty())){
	for(Apttus_Config2__CustomerPOItem__c loopLI : cpoLIsToProcess){
		
		if(toBeExpired.contains(loopLI.id)){
			
			toBeExpiredLI.add(loopLI);
		}
		if(loopLI.Commercial_Entitlement_Status__c == CSWXGlobalConstant.entitledValue && !(toBeExpired.contains(loopLI.id))){
			
			entitleToStatusUpadtes.put(loopLI.Commercial_Entitlement__c, CSWXGlobalConstant.entitledValue);
		}
		else{
			commercialEntitlementIDs.add(loopLI.Commercial_Entitlement__c);
		}
		
	}
			}
			else{}
			
	 // system.debug('======  entitleToStatusUpadtes ==== :' + entitleToStatusUpadtes);
	 // system.debug('======  commercialEntitlementIDs ==== :' + commercialEntitlementIDs);
			
			commercialEntitlements = [select id, Status__c from Commercial_Entitlement__c 
				where id in: commercialEntitlementIDs 
				Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			allCPOLIForEntitlements = [select id, Commercial_Entitlement__c, Commercial_Entitlement_Status__c 
				from Apttus_Config2__CustomerPOItem__c 
				where Commercial_Entitlement__c in: commercialEntitlementIDs 
				Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			
	//  system.debug('======  commercialEntitlements ==== :' + commercialEntitlements);
	//  system.debug('======  allCPOLIForEntitlements ==== :' + allCPOLIForEntitlements);
			
			if(!(allCPOLIForEntitlements.isempty())){
	for(Apttus_Config2__CustomerPOItem__c loopLI : allCPOLIForEntitlements){
		list<Apttus_Config2__CustomerPOItem__c> allCPOLI = new list<Apttus_Config2__CustomerPOItem__c>();
		if(entitlementToCPOLI.containsKey(loopLI.Commercial_Entitlement__c)){
			allCPOlI = entitlementToCPOLI.get(loopLI.Commercial_Entitlement__c);
		}
			allCPOlI.add(loopLI);
			entitlementToCPOLI.put(loopLI.Commercial_Entitlement__c, allCPOlI);
	}
			}
			else{}
			
			//system.debug('======  entitlementToCPOLI ==== :' + entitlementToCPOLI);
			
			if(!(commercialEntitlements.isempty())){
	for(Commercial_Entitlement__c loopCE : commercialEntitlements){
		if(entitlementToCPOLI.containsKey(loopCE.id)){
			list<Apttus_Config2__CustomerPOItem__c> allLIs = entitlementToCPOLI.get(loopCE.id);
			
			if(!allLIs.isempty()){
				for(Apttus_Config2__CustomerPOItem__c loopLI : allLIs){
		if(loopLI.Commercial_Entitlement_Status__c ==  CSWXGlobalConstant.entitledValue 
			&& !(toBeExpired.contains(loopLI.id))){
			isAnyEntitled = true;
			break;
		}
		else if(loopLI.Commercial_Entitlement_Status__c ==  CSWXGlobalConstant.pendingValue 
			&& !(isAnyEntitled) && !(toBeExpired.contains(loopLI.id))){
			isAnyPending = true;
		}
		else{}
				}
			} else{}
		}
		else{}
	  //  system.debug('====== loopCE : isAnyEntitled , isAnyPending ==== :' + loopCE +  ' : ' + isAnyEntitled + ' ' + isAnyPending);
		if(isAnyEntitled){
			entitleToStatusUpadtes.put(loopCE.id, CSWXGlobalConstant.entitledValue);
		} else if(isAnyPending){
			entitleToStatusUpadtes.put(loopCE.id, CSWXGlobalConstant.pendingValue);
		} else{
			entitleToStatusUpadtes.put(loopCE.id, CSWXGlobalConstant.Expired);
		}
		isAnyEntitled = false;
		isAnyPending = false;
	  //  system.debug('======  entitleToStatusUpadtes ==== :' + entitleToStatusUpadtes);
	}   
			}
			else{}
			
			if(!entitleToStatusUpadtes.keyset().isempty()){
	for(Commercial_Entitlement__c commercialEntitle : [select id, Status__c 
		from Commercial_Entitlement__c where id in: entitleToStatusUpadtes.keyset() 
		Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
		
		if(entitleToStatusUpadtes.containsKey(commercialEntitle.id)){
			commercialEntitle.Status__c = entitleToStatusUpadtes.get(commercialEntitle.id);
			comemrcialEntitlementToBeUpdated.add(commercialEntitle);
		}
		else{}
	}
			}
			else{}
			
			
	//  system.debug('======  comemrcialEntitlementToBeUpdated ==== :' + comemrcialEntitlementToBeUpdated);
			
			if(!comemrcialEntitlementToBeUpdated.isempty()){
	database.update(comemrcialEntitlementToBeUpdated,false);
			}
			else{}
			
			if(!toBeExpiredLI.isempty()){
	for(Apttus_Config2__CustomerPOItem__c expiriedLI : toBeExpiredLI){
		expiriedLI.Commercial_Entitlement_Status__c = CSWXGlobalConstant.Expired;
		expiryUpdateLI.add(expiriedLI);
	}
	
			}
			else{}
	//  system.debug('expiryUpdateLI : '+ expiryUpdateLI);
			database.update(expiryUpdateLI,false);
		
	}
	catch(System.Exception e){ExceptionHandler.addException(
				e, CSWXGlobalConstant.DS_updateComemrcialEntitlementStatus,
		CSWXGlobalConstant.DS_updateComemrcialEntitlementStatus);}
				
	}		
}