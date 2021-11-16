/****************************************
* Class Name : CH_ScheduleBatchToDeactiveCDBCLI
* Created Date: 13 Jan 2019
* Created By : Rajeshwari
* Description : NOKIASC-15192 - Automatic deactivation of Contract Line Items that are out of synch with CDB
* Test Class: CH_BatchToDeactiveCDBCLI_Test
Name			Modified DATE	   Comments
*****************************************/


global with sharing class CH_ScheduleBatchToDeactiveCDBCLI implements Schedulable{
	global void execute(SchedulableContext sc) {
		CH_BatchToDeactiveCDBCLI  batchToExecute = new CH_BatchToDeactiveCDBCLI (); 
		database.executebatch(batchToExecute);
		
	}
}