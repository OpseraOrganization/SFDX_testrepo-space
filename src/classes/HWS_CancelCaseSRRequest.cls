/*****************************************************************
@description:	This class returns json string of requested case
History									
DATE			AUTHOR	CHANGE
12/04/2019	  Vinod T		 Created
10/11/2020 		Prateek NOKIASC-32425
*****************************************************************/

Public without sharing Class HWS_CancelCaseSRRequest
{
	/*****************************************************************
@description:	Returns the string json of the requested case object 
@param: parentCaseId
@return:  JSON String
Throws [Exceptions]: [optional]	
History						
DATE			AUTHOR	CHANGE
12/04/2019	  Vinod T		 Created
29/10/2020	Afif		   //NOKIASC-31236:Added Action parameter,and LogisticNode for SOO Call
*****************************************************************/
	Public SOORequestBody cancelSRRequest(Id parentCaseId,Id childId,String actionName){
		try{
			//NOKIASC-31236:Change the query string to accommodate GetEscalationInstruction SOO call.
			String strCase = 'SELECT id,CreatedBy.Name,Status,CreatedDate,CaseNumber,Account.NCP_P20_ID__c,HWS_LogisticNodeCode__c ';			
			if (actionName=='Cancel'){
				strCase = strCase+' ,(SELECT id,HWS_RMA_Number__c,HWS_Contract_Line_Item__r.CH_ServiceType__c,Status,NCP_Service_Contract__r.CH_ERPSystem__c,HWS_SPS_Order_No__c FROM Cases WHERE Status =\'Ordered\')';
				//NOKIASC-32425
				strCase = strCase+' FROM Case	WHERE id = :parentCaseId ';
			}
			else{
				//NOKIASC-32425
				strCase = strCase+' FROM Case	WHERE id = :childId ';
			}			
			Case caseRec  = database.query(strCase);

			
			HWS_CancelParentCase_WRAPPER parentCase ;
			switch on actionName {
				when 'Cancel' {		
					if(caseRec.Cases.size() > 0 && childId == null)
					{
						
						parentCase = new HWS_CancelParentCase_WRAPPER(caseRec,actionName);
						for(Case childCaseRec: caseRec.Cases){
							parentCase.Requestitems.add(new HWS_CancelChildCases_WRAPPER(childCaseRec));
						}
					} 
					else
					{
						parentCase = new HWS_CancelParentCase_WRAPPER(caseRec,actionName);
						for(Case c: caseRec.Cases){
						   
							if(c.id == childId){
							   
								parentCase.Requestitems.add(new HWS_CancelChildCases_WRAPPER(c));
							}							
						}
					} 
				}
				when 'GetEscalationInstruction' {	 
					parentCase = new HWS_CancelParentCase_WRAPPER(caseRec,actionName);
				}   
		when else {
					system.debug('===actionName=='+ actionName);
				}
			}
			
			String jsonString = JSON.serialize(parentCase,true);
			
			SOORequestBody obj=new SOORequestBody();
			obj.jsonPayload=jsonString;
			obj.caseNumber=caseRec.CaseNumber;
		   
			return obj;
		}
		Catch(Exception e){
			System.debug(LoggingLevel.DEBUG,'Error in CancelCaseSRRequest***'+e.getMessage() +'on line number ' +e.getLineNumber() + ' '+ e.getCause());
			return null;
		}
	}
	public class SOORequestBody{
		public String jsonPayload;
		public String caseNumber;	 
	}
}