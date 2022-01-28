/****************************************
 * Class Name : ContractHelper
 * Created Date: June 2018
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description : Contract Helper
	 
 * Test Class: 
 *****************************************/
public without sharing class ContractHelper {

	/********************
	*Method Name: UpdatedAccountfforACcreditation level update
	*Parameter: 
	*Description: 
	*******************/
	public static void updateAccNAccreditation(list<Contract> newcontract){
		try{
			system.debug('newcontract  .....'+ newcontract);
			set<ID> deletedContractIds = new set<ID>();
			map<id, String> activeTypes = new map<id, String>();
			list<Accreditation__c> accredToUpdate = new list<Accreditation__c>();
			set<ID> accId = new set<ID>();
			
			for(Contract Contr : newcontract){
	system.debug('In contract loop : '+ Contr.name );
	accId.add(Contr.AccountID);
	if(Trigger.isDelete){
					deletedContractIds.add(Contr.Id);
				}
			}
			for(Contract c : [Select Id, AccountId, Contract_Status__c, Contract_Type__c from Contract where
								 AccountID in: accId and Contract_Status__c =: PRMGlobalConstants.ActiveSt and Id not in: deletedContractIds]){
									 if(!activeTypes.keySet().contains(c.AccountId)){
										 activeTypes.put(c.AccountId, c.Contract_Type__c);
									 }else{
										 if(!activeTypes.get(c.AccountId).contains(c.Contract_Type__c)){
											 activeTypes.put(c.AccountId, activeTypes.get(c.AccountId) + PRMGlobalConstants.SemiColon + c.Contract_Type__c);
										 }
									 }
			}
			
			
			for(Accreditation__c accred : [select id, name, Evaluated_Accreditation__c, Partner__c, Active_Contract_Types__c 
										   from Accreditation__c where Partner__c in: accId Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
											   
											   if(activeTypes.keySet().contains(accred.Partner__c)){
												   accred.Active_Contract_Types__c = activeTypes.get(accred.Partner__c);
											   }else{
												   accred.Active_Contract_Types__c = null;
											   }
											   accred.Evaluated_Accreditation__c = true;
											   accredToUpdate.add(accred);
										   }   
			system.debug('accredToUpdate ...... '+ accredToUpdate);
			Database.update(accredToUpdate, false);
			
		
		}catch(Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.ContractHelper ,PRMGlobalConstants.ContractHelper);
		}
	}
	
	public static void updateContractStatus(list<Contract> newcontract){
		for(Contract Contr : newcontract){
			if(Contr.StartDate < Date.today() && Contr.EndDate > Date.today()){
				Contr.Contract_Status__c = 'Active';
			}else if(Contr.EndDate < Date.today()){
				Contr.Contract_Status__c = 'Expired';
			}
		}
	}
}