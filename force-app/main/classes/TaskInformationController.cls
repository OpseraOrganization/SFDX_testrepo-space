/**
* @description: TaskInformationController is an apex class. This is used to extend the functionality of lightning component.
*			   The class includes methods to retrieve all accessable Task Details for the User.
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION AUTHOR		  DATE		DETAIL										  FEATURES/CSR/TTP
* 1.0				   29/08/2017   Sprint 9 LoA requirements.
* ============================================================================ 
*/
public class TaskInformationController 
{
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Aug-2017
* Param: String searchKeyWord
* Return: taskInfoWrapperObj
* Description: Retrieve all records from Opportunity and get it's Active Offer
* High Level Process : 
**********************************************************************************************************************/
	
	@AuraEnabled
	public static TaskInformationWrapper getOpptyOfferValues(String oppRecordId)
	{
		
		TaskInformationWrapper taskInfoWrapperObj = new TaskInformationWrapper();  
		Opportunity oppObj = new Opportunity();
		try
		{  
			oppObj = [select Id,Phase_Status__c,Name,Lead_BG__c,Lead_BU__c, 
					  (select Id,Offer_Number__c,Name,Price__c from Offers__r where ActiveOffer__c =: true limit 1) from Opportunity where id =: oppRecordId limit 1];
			
			System.debug('OppObj Value::'+oppObj);
			//System.debug('OppObj Value1::'+oppObj.Offers__r[0].Id);
			
			if(oppObj.Offers__r.size()>0)
			{
				taskInfoWrapperObj.offerNumber = oppObj.Offers__r[0].Offer_Number__c;
				taskInfoWrapperObj.offerRecordId = oppObj.Offers__r[0].Id;
			}
			
			if(oppObj.Name != null)
			{
				taskInfoWrapperObj.relatedOpptyName = oppObj.Name;
			} 
			
			
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, TaskInformationController.class.getName(), GlobalConstants.GET_OPPTY_OFFER_VALUES);
		}
		System.debug('WrapperDetails:::'+taskInfoWrapperObj.offerNumber); 
		System.debug('WrapperDetails:::'+taskInfoWrapperObj.relatedOpptyName); 
		return taskInfoWrapperObj;
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Aug-2017
* Param: No Parameter
* Return: phasestatusvalues
* Description: Retrieve the OpportunityPhaseStatusValues
* High Level Process : 
**********************************************************************************************************************/
	@AuraEnabled
	public static List<String> getOpportunityPhaseStatusValues(){
		List<String> phaseStatusValues = new List<String>();
		try{
			String customString = File_Sharing_Custom_Setting__c.getInstance(GlobalConstants.OPPORTUNITY_GATE_VALUES).Value__c;
			if(customString != null)
			{
				for(String level : customString.split(GlobalConstants.COMMA))
				{
					phaseStatusValues.add(level.trim());
				}
			} 
		}catch(Exception ex) {
			ExceptionHandler.addException(ex, ApprovalCentreController.class.getName(), GlobalConstants.METHOD_OPPORTUNITYSALESOUTCOMEVALUE);
		}
		return phaseStatusValues;
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Aug-2017
* Param: String searchKeyWord
* Return: saveTaskDetails
* Description: Inserting task object record from the Approval Center Lightning Component
* High Level Process : 
**********************************************************************************************************************/
	@AuraEnabled
	public static Boolean saveTaskDetails(Task objTask,String offerNumber,Id oppRecordId,String offerRecId,String selectGateVal)
	{
		Id Approval_RecordType_ID = Schema.SObjectType.Task.getRecordTypeInfosByName().get(GlobalConstants.APPROVL_CENTER_RECORTYPE).getRecordTypeId();	
		Boolean isInserted = true;
		Id recId;
		try
		{
			System.debug('Task Object Value:::'+objTask);
			System.debug('Task Subject Value :::'+offerNumber);
			System.debug('Task Related To Value :::'+oppRecordId);
			//System.debug('objTask.WhoId :::'+objTask.WhoId);
			System.debug('selectGateVal :::'+selectGateVal);
			//TaskInformationWrapper.subject = objTask.Subject;
			//System.debug('mydate :::'+mydate.format());
			/*if(objTask.WhoId != null && UserInfo.getUiTheme() != GlobalConstants.USER_UI_THEME_MOBILE){

JSONParser parser = JSON.createParser(objTask.WhoId);
System.debug('parsed : '+parser);

while (parser.nextToken() != null) 
{
if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'id')
{	  
System.debug('parser.nextToken() : '+parser.nextToken());
System.debug('parser.getText() : '+parser.getText());
System.debug('parser.getIdValue() : '+parser.getIdValue());
recId = parser.getIdValue();
}

}

System.debug('recId****'+recId);
objTask.WhoId = recId;   
}	
else
{
System.debug('objTask.WhoId :::'+objTask.WhoId);
}*/
			objTask.WhatId = oppRecordId;
			objTask.OfferId__c = offerRecId;
			objTask.OfferNumber__c = offerNumber;
			objTask.Created_At__c = selectGateVal;
			objTask.recordtypeid = Approval_RecordType_ID; 
			
			
			insert objTask;
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, TaskInformationController.class.getName(), GlobalConstants.GET_OPPTY_OFFER_VALUES);
		}
		return isInserted; 
		
	}
	/**********************************************************************************************************************
* author: Accenture
* Date: Aug-2017
* Param: String assignVal,String myDate
* Return: trur or false
* Description: Inserting task object record from the Approval Center Lightning Component
* High Level Process : 
**********************************************************************************************************************/
	@AuraEnabled
	public static Integer getAssignedToVal(String assignVal, String myDate)
	{
		Date Parsedata;		
		Integer Count=0;
		System.debug('myDate>>>'+myDate);					 
		List<String> dateArray = new List<String>();
		if(!String.isBlank(myDate))
		{
			myDate.replace('.','-');
			System.debug('Updated inside mydate:::'+myDate);
		}
		
		if(!String.isBlank(myDate) && myDate.contains('-')){
			dateArray = myDate.split('-');
			System.debug('dateArray:::'+dateArray);
			System.debug('dateArray.size():::'+dateArray.size());
			System.debug('dateArray.length():::'+dateArray[0].length());
			if(dateArray.size() == 3 && dateArray[0].length() == 4){
				Parsedata = date.valueOf(myDate);
			}
			else{
				Count = 2; 
			}
		}
		
		System.debug('AssignVal:::'+assignVal);
		System.debug('Parsedata:::'+Parsedata);
		System.debug('Date.today().format():::::' + Date.today().format());
		System.debug('Date.Parse(Date.today().format()::::'+Date.Parse(Date.today().format()));
		if(Parsedata!=null && Parsedata < Date.Parse(Date.today().format()) && String.isNotBlank(assignVal))
		{
			System.debug('Date is past date');
			return 1;
		}
		else if(Count==2)
		{
			System.debug('Wrong Date format');		  
			return 2;
			
		}
		else if(Parsedata!=null && Parsedata < Date.Parse(Date.today().format()) && !String.isNotBlank(assignVal))
		{
			System.debug('Inside assigned to is null && date is previous date');
			return 3;			
		} 
		else if(Parsedata!=null && Parsedata > Date.Parse(Date.today().format()) && !String.isNotBlank(assignVal))
		{
			System.debug('Inside Assigned To is null & Date is correct');
			return 4;
		}
		else if (Parsedata ==null && !String.isNotBlank(assignVal))
		{
			System.debug('Inside Due date is Null & Assign To is Null');
			return 5;
		}
		else if (Parsedata ==null && String.isNotBlank(assignVal))
		{
			System.debug('Inside Due date is Null & Assign To is Not Null');
			return 6;			
		}
		else 
			return 7;
		
	} 
}