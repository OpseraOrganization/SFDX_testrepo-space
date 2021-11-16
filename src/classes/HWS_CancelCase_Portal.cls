/*****************************************************************
@description:	Apex controller for HWS_CancelCase_Portal lightning component
**************************************************/
public without sharing class HWS_CancelCase_Portal {
	
	/****************************************
* Name : getCancellationStatus
* @description : method to get Contact Name
* @param: string contactid
* @return : String
*****************************************/
	@auraEnabled
	public static String getCancellationStatus(string caseid)
	{   
		//System.debug('Contact Id'+contactid);
		//commenting unused variable NOKIASC-32425
		//List<String> strLst = new List<String>();
		try{
			Case caseStat= [SELECT Id,Status, HWS_ServiceType__c,(select id,HWS_ServiceType__c from Cases where HWS_ServiceType__c='Advanced Exchange in Hours') FROM case where Id = :caseid ];			
			if(caseStat.Cases.size()>0 || caseStat.HWS_ServiceType__c == 'Advanced Exchange in Hours'){
				return 'hidebtn';
			}
			/*else if(caseStat.HWS_ServiceType__c == 'Advanced Exchange in Hours'){
return 'hidebtn';
}*/
			else{
				return caseStat.Status;
			}
		}
		
		Catch(Exception e){
			System.debug(LoggingLevel.DEBUG,'Error in CancelCase***'+e.getMessage() +'on line number ' +e.getLineNumber() + ' '+ e.getCause());
			return null;
		}
		
	}
	
	@auraEnabled
	public static List<String> cancelChildCases(String casId){
		String platform='portal';
		//NOKIASC-32416:Calling HWS_Utilty class generic method for cancel child case.
		return HWS_Utilty.cancelChildCases(casId, '','',platform);
	}
	
}