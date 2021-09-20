/**
* @description: Coop Transfer Trigger Handler to calculate Allocation Transfer In/Out fields in bulk for new Transfer Records
* TestClass: PRM_FundTransfersTest
**/
public without sharing class CoOpTransferHandler{
	public static void beforeInsertOperation(List<Co_op_Allocation_Transfer__c> newTransferList) {
		If(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)) {
			try{
	CoOpTransferHelper.handleNullValues(newTransferList);
			}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.CoOpTransferHandler,PRMGlobalConstants.beforeInsertOperation);}
		}
	}
	public static void afterInsertOperation(List<Co_op_Allocation_Transfer__c> newTransferList) {
		If(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)) {
			try{
	CoOpTransferHelper.handleTransfers(newTransferList);
			}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.CoOpTransferHandler,PRMGlobalConstants.afterInsertOperation);}
		}
	}
}