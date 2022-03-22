/****************************************
	 * Class Name : ContractHandler
	 * Created Date: june 2018
	 * Created By : Accenture
	 * Last Modified by: Accenture
	 * Last Modified Date: 
	 * Description : Handle the sequence of the Contract Trigger
	 * Test Class: 
	 *****************************************/
	public without Sharing class ContractHandler{
		/********************
		*Method Name: afterUpdateOperation
		*Parameter: newContractList, Old Contract Map
		*Description: Used to handle after Update activities
		*******************/
		public static void afterUpdateOperation(List<Contract> newContractList, Map<ID, Contract> ContractOldMap) { 
			list<Contract> updatedContract = new list<Contract>();
			try{
				for(Contract newContract: newContractList){
					if(newContract.Contract_Status__c != ContractOldMap.get(newContract.id).Contract_Status__c){
						updatedContract.add(newContract);
					}
				}
				if(updatedContract.size() > 0 ){
					ContractHelper.updateAccNAccreditation(updatedContract);
				}
			}
	 catch(System.Exception e){ExceptionHandler.addException(e, PRMGlobalConstants.ContractHandler, PRMGlobalConstants.afterUpdateOperation );}
		}
		/********************
		*Method Name: beforeUpdateOperation
		*Parameter: newContractList, Old Contract Map
		*Description: Used to handle after Update activities
		*******************/
		public static void beforeUpdateOperation(List<Contract> newContractList) {
			list<Contract> updatedContract = new list<Contract>();
			try{
				for(Contract newContract: newContractList){
					if(newContract.StartDate < Date.today()){
						updatedContract.add(newContract);
					}
				}
				if(updatedContract.size() > 0 ){
					ContractHelper.updateContractStatus(updatedContract);
				}
			}
			catch(System.Exception e){ExceptionHandler.addException(e, PRMGlobalConstants.ContractHandler, PRMGlobalConstants.afterUpdateOperation );}
		}
		/********************
		*Method Name: afterInsertOperation
		*Parameter: newContractList
		*Description: Used to handle after insert activities
		*******************/
		public static void afterinsertOperation(List<Contract> newContractList) { 
			list<Contract> updatedContract = new list<Contract>();
			try{
	  for(Contract newContract: newContractList){
	   if(newContract.Contract_Status__c == PRMGlobalConstants.ActiveSt || 
		  newContract.StartDate >= system.today() ){
		updatedContract.add(newContract);
	   }
	  }
	  if(updatedContract.size() > 0 ){
	   ContractHelper.updateAccNAccreditation(updatedContract);
	  }
	 }
	 catch(System.Exception e){ExceptionHandler.addException(e, PRMGlobalConstants.ContractHandler, PRMGlobalConstants.afterInsertOperation );}
		}
		/********************
		*Method Name: beforeDeleteOperation
		*Parameter: deletedContractList
		*Description: Used to handle before delete activities (updating related Accreditations)
		*******************/
		public static void beforeDeleteOperation(List<Contract> deletedContractList) { 
			list<Contract> updatedContract = new list<Contract>();
			try{
	  for(Contract newContract: deletedContractList){
	   if(newContract.Contract_Status__c == PRMGlobalConstants.ActiveSt){
		updatedContract.add(newContract);
	   }
	  }
	  if(updatedContract.size() > 0 ){
	   ContractHelper.updateAccNAccreditation(updatedContract);
	  }
	 }
	 catch(System.Exception e){ExceptionHandler.addException(e, PRMGlobalConstants.ContractHandler, PRMGlobalConstants.afterInsertOperation );}
		}
	}