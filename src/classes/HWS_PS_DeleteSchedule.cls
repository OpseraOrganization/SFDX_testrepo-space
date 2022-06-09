/****************************************
* Class Name : HWS_PS_DeleteSchedule
* User Story :NOKIASC-
* Created Date: 01 June 2021
* Created By : TCS
* Last Modified by: 
* Last Modified Date:
* Description : Batch job for deleting staging table data
* Test Class: HWS_PS_DeleteSchedule_Test
*****************************************/
global class HWS_PS_DeleteSchedule implements Schedulable{
	global void execute(SchedulableContext sc){
		String cs = HWS_GenericSettings__c.getValues('HWS_PS_RelationsDelete').HWS_Field1__c;
		String cs1 = HWS_GenericSettings__c.getValues('HWS_PS_SalesDelete').HWS_Field1__c;
		String cs2 = HWS_GenericSettings__c.getValues('HWS_PS_VersionDelete').HWS_Field1__c;
		String cs3 = HWS_GenericSettings__c.getValues('HWS_BulkUploadDelete').HWS_Field1__c;
		
		if(cs=='true'){ Database.executeBatch(new HWS_PS_RelationsDelete_Batch(),200);
		}
		else if(cs1=='true'){ Database.executeBatch(new HWS_PS_SalesDelete_Batch(),200);
		}
		else if(cs2=='true'){ Database.executeBatch(new HWS_PS_VersionDelete_Batch(),200);
		}
		else if (cs3=='true') {Database.executeBatch(new HWS_BulkUploadDelete_Batch(),200);
		}
		
	}
}