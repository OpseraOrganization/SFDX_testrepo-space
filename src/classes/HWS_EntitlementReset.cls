/***
* Description : To update Entitlement Exception based on newly selected Entitlement Status 
* and old Entitlement Exception values and contract Line Condition
* Author : Eashwar 
* User Story : NOKIASC-34951
* ***/
public class HWS_EntitlementReset {
	
	public static void resetEntitlementException(String oldEntValue,String condition,Case caseRec)
	{
		try{
			String oldESValue=caseRec.CH_EntitlementException__c;
			
	
			//Start of Uknown Warranty
			if( caseRec.HWS_WarrantyStatus__c==HWS_Constants.WS_UKWarranty)
			{
	
	
	  resetUKCases(oldESValue,caseRec,condition);
			}
			// Start of Out of Warranty 
			else if( caseRec.HWS_WarrantyStatus__c==HWS_Constants.OUT_OF_WARRANTY)
			{
	 
	
	  resetOOWCases(oldESValue,caseRec,condition);
			}
			//Start of InWarranty
			else if( caseRec.HWS_WarrantyStatus__c==HWS_Constants.WS_InWarranty)
			{
	  
	resetIWCases(oldESValue,caseRec,condition);
			}
			
		}
		catch(AuraHandledException e){
			throw new AuraHandledException(e.getMessage()+e.getLineNumber());
		}
		
	}
	public static void resetUKCases(String oldESValue,Case caseRec,String condition)
	{
		if(oldESValue==HWS_Constants.WStatusCheckFailed || oldESValue == HWS_Constants.WS_UKWarranty || oldESValue == HWS_Constants.UWStatus )
	{
		if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESIWVM)
		{
			if(condition ==HWS_Constants.UC1 || condition==HWS_Constants.UC2A || condition==HWS_Constants.UC67 || condition==HWS_Constants.UC8 || condition==HWS_Constants.UC9 || condition==HWS_Constants.UC3 )
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.WS_InWarranty;
				caseRec.Status=HWS_Constants.caseStatusDraft;
			}
			else if(condition ==HWS_Constants.UC2B || condition ==HWS_Constants.UC4 || condition ==HWS_Constants.UC5)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.IW_QuotRequired;
				caseRec.CH_EntitlementStatus__c=HWS_Constants.PendingQuotCreation;
				caseRec.Status=HWS_Constants.caseStatusOnHold;
			}   
		}
		else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESOOWVM)
		{
			if(condition ==HWS_Constants.UC67 || condition==HWS_Constants.UC9  )
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.OUT_OF_WARRANTY;
				caseRec.Status=HWS_Constants.caseStatusDraft;
			}   
			else if(condition== HWS_Constants.UC5 || condition== HWS_Constants.UC3|| condition==HWS_Constants.UC4)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.OOW_QuotRequired;
				caseRec.CH_EntitlementStatus__c=HWS_Constants.PendingQuotCreation;
				caseRec.Status=HWS_Constants.caseStatusOnHold;
			}
			else if(condition== HWS_Constants.UC1 || condition== HWS_Constants.UC8|| condition==HWS_Constants.UC2A ||condition==HWS_Constants.UC2B )
			{
				caseRec.addError(HWS_Constants.EntitlementStatusValidationError);
		 
			}
			
		}
		else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESMOFOC)
		{
			caseRec.CH_EntitlementException__c=HWS_Constants.Not_Applicable;
			caseRec.Status=HWS_Constants.caseStatusDraft;
		}
		else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESMOB)
		{
			if(condition== HWS_Constants.UC1 || condition== HWS_Constants.UC2A || condition== HWS_Constants.UC8 || condition== HWS_Constants.UC2B || condition== HWS_Constants.UC3 || condition== HWS_Constants.UC4 || condition== HWS_Constants.UC5 )
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.NA_QuotRequired;
				caseRec.CH_EntitlementStatus__c=HWS_Constants.PendingQuotCreation;
				caseRec.Status=HWS_Constants.caseStatusOnHold;
			}
			else if(condition== HWS_Constants.UC67 || condition==HWS_Constants.UC9)
			{
				caseRec.addError(HWS_Constants.EntitlementStatusValidationError);
			}
			
		}
		else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.Service_Declined)
		{
			if(condition== HWS_Constants.UC1 || condition== HWS_Constants.UC2A || condition== HWS_Constants.UC8 || condition== HWS_Constants.UC2B || condition== HWS_Constants.UC67 || condition== HWS_Constants.UC9 )
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.Not_Applicable;
				caseRec.Status=HWS_Constants.caseStatusCancel;
			}
			else if(condition== HWS_Constants.UC3 || condition==HWS_Constants.UC4 || condition==HWS_Constants.UC5)
			{
				caseRec.addError(HWS_Constants.EntitlementStatusValidationError);
			}
			
			
		}
	}
	//Row 93 from Excel
	else if(oldESValue==HWS_Constants.IW_QuotRequired)
	{
		if(condition== HWS_Constants.UC2B || condition== HWS_Constants.UC4 || condition== HWS_Constants.UC5 )
		{
			if(caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingQuotCreation || caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingCAOQ || caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingCAPMR)
			{
	
	caseRec.Status=HWS_Constants.caseStatusOnHold;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESQAPR)
			{
				
				caseRec.CH_EntitlementException__c=HWS_Constants.WS_InWarranty;
				caseRec.Status=HWS_Constants.caseStatusDraft;
				
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.QR)
			{
				
				caseRec.CH_EntitlementException__c=HWS_Constants.QD;
				caseRec.Status=HWS_Constants.caseStatusCancel;
				
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESMOFOC)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.Not_Applicable;
				caseRec.Status=HWS_Constants.caseStatusDraft;
				
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.Service_Declined)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.QExp;
				caseRec.Status=HWS_Constants.caseStatusCancel;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESIWVM  || caseRec.CH_EntitlementStatus__c==HWS_Constants.ESOOWVM || caseRec.CH_EntitlementStatus__c==HWS_Constants.ESMOB || caseRec.CH_EntitlementStatus__c== HWS_Constants.PendingWarrantyVerification )
			{
				
				
				
				caseRec.addError(HWS_Constants.EntitlementStatusValidationError);
			}
			 else
			{
				//if they select any other status within this usecase as we have additional values
		 caseRec.addError(HWS_Constants.EntitlementStatusValidationError);
			}
		}
	   
	}
	//Row 117
	else if(oldESValue==HWS_Constants.OOW_QuotRequired)
	{
		if(condition ==HWS_Constants.UC3 || condition==HWS_Constants.UC4 || condition==HWS_Constants.UC5)
		{
			if( caseRec.CH_EntitlementStatus__c==HWS_Constants.ESOOWVM || caseRec.CH_EntitlementStatus__c==HWS_Constants.ESMOB )
			{
		 
				
			
				caseRec.addError(HWS_Constants.EntitlementStatusValidationError);
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESIWVM )
			{
				if(condition==HWS_Constants.UC4 || condition==HWS_Constants.UC5)
							{
					caseRec.CH_EntitlementException__c=HWS_Constants.IW_QuotRequired;
								caseRec.CH_EntitlementStatus__c=HWS_Constants.PendingQuotCreation;
					caseRec.Status=HWS_Constants.caseStatusOnHold;
							}
				if(condition ==HWS_Constants.UC3)
				{
		caseRec.CH_EntitlementException__c=HWS_Constants.WS_InWarranty;
		caseRec.Status=HWS_Constants.caseStatusDraft;
				}
				
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingQuotCreation || caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingCAOQ || caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingWarrantyVerification || caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingCAPMR)
			{
		 
				caseRec.Status=HWS_Constants.caseStatusOnHold;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESQAPR )
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.OUT_OF_WARRANTY;
				caseRec.Status=HWS_Constants.caseStatusDraft;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.QR )
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.QD;
				caseRec.Status=HWS_Constants.caseStatusCancel;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESMOFOC )
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.Not_Applicable;
				caseRec.Status=HWS_Constants.caseStatusDraft;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.Service_Declined)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.QExp;
				caseRec.Status=HWS_Constants.caseStatusCancel;
			}
			else
			{
				caseRec.addError(HWS_Constants.EntitlementStatusValidationError);
			}
			
			
		}
	}
	//Row 137 
	else if(oldESValue==HWS_Constants.NA_QuotRequired)
	{
		if(condition ==HWS_Constants.UC1 || condition ==HWS_Constants.UC2A || condition ==HWS_Constants.UC2B || condition ==HWS_Constants.UC8 || condition ==HWS_Constants.UC3 || condition==HWS_Constants.UC4 || condition==HWS_Constants.UC5)
		{
			if(caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingQuotCreation || caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingCAOQ || caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingCAPMR || caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingWarrantyVerification)
			{
				caseRec.Status=HWS_Constants.caseStatusOnHold;
		 
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESQAPR || caseRec.CH_EntitlementStatus__c==HWS_Constants.ESMOFOC)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.Not_Applicable;
				caseRec.Status=HWS_Constants.caseStatusDraft;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.QR)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.QD;
				caseRec.Status=HWS_Constants.caseStatusCancel;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.Service_Declined)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.QExp;
				caseRec.Status=HWS_Constants.caseStatusCancel;
			}
			else
			{
		 caseRec.addError(HWS_Constants.EntitlementStatusValidationError);
			}
			
		}
		
	}
	else
	{
		caseRec.addError(HWS_Constants.EntitlementStatusValidationError);
	}
	}
	public static void resetOOWCases(String oldESValue,Case caseRec,String condition)
	{
		 if(oldESValue==HWS_Constants.EE_OOWD)
	{
		if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESIWVM)
		{
			
			if(condition ==HWS_Constants.UC1 || condition==HWS_Constants.UC2A || condition==HWS_Constants.UC67 || condition==HWS_Constants.UC8 || condition==HWS_Constants.UC9 || condition==HWS_Constants.UC3 )
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.WS_InWarranty;
				caseRec.Status=HWS_Constants.caseStatusDraft;
			}
			else if(condition ==HWS_Constants.UC2B || condition ==HWS_Constants.UC4 || condition ==HWS_Constants.UC5)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.IW_QuotRequired;
		caseRec.CH_EntitlementStatus__c=HWS_Constants.PendingQuotCreation;
				caseRec.Status=HWS_Constants.caseStatusOnHold;
			}
			
			
		}
		else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESOOWVM)
		{
			if(condition ==HWS_Constants.UC67 || condition==HWS_Constants.UC9  )
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.OUT_OF_WARRANTY;
				caseRec.Status=HWS_Constants.caseStatusDraft;
			}   
			else if(condition== HWS_Constants.UC5 || condition== HWS_Constants.UC3|| condition==HWS_Constants.UC4)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.OOW_QuotRequired;
		caseRec.CH_EntitlementStatus__c=HWS_Constants.PendingQuotCreation;
				caseRec.Status=HWS_Constants.caseStatusOnHold;
			}
			else if(condition== HWS_Constants.UC1 || condition== HWS_Constants.UC8|| condition==HWS_Constants.UC2A ||condition==HWS_Constants.UC2B )
			{
		caseRec.addError(HWS_Constants.EntitlementStatusValidationError);
			}
			
		}
		else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESMOFOC)
		{
			caseRec.CH_EntitlementException__c=HWS_Constants.Not_Applicable;
			caseRec.Status=HWS_Constants.caseStatusDraft;
		}
		else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESMOB)
		{
			if(condition== HWS_Constants.UC1 || condition== HWS_Constants.UC2A || condition== HWS_Constants.UC8 || condition== HWS_Constants.UC2B || condition== HWS_Constants.UC3 || condition== HWS_Constants.UC4 || condition== HWS_Constants.UC5 )
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.NA_QuotRequired;
		caseRec.CH_EntitlementStatus__c=HWS_Constants.PendingQuotCreation;
				caseRec.Status=HWS_Constants.caseStatusOnHold;
			}
			else if(condition== HWS_Constants.UC67 || condition==HWS_Constants.UC9)
			{
		 caseRec.addError(HWS_Constants.EntitlementStatusValidationError);
			}
			
		}
		else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.Service_Declined)
		{
			if(condition== HWS_Constants.UC1 || condition== HWS_Constants.UC2A || condition== HWS_Constants.UC8 || condition== HWS_Constants.UC2B || condition== HWS_Constants.UC67 || condition== HWS_Constants.UC9 )
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.OUT_OF_WARRANTY;
				caseRec.Status=HWS_Constants.caseStatusCancel;
			}
			else if(condition== HWS_Constants.UC3 || condition== HWS_Constants.UC4 || condition== HWS_Constants.UC5 )
			{
				
				caseRec.addError(HWS_Constants.EntitlementStatusValidationError);
			}	   
			
		}
	}
	else if(oldESValue==HWS_Constants.IW_QuotRequired)
	{
		if(condition== HWS_Constants.UC5 || condition== HWS_Constants.UC2B|| condition==HWS_Constants.UC4)
		{
			if(caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingCAPMR || caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingQuotCreation || caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingCAOQ || caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingWarrantyVerification)
			{
				
				caseRec.Status=HWS_Constants.caseStatusOnHold;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESQAPR)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.WS_InWarranty;
				caseRec.Status=HWS_Constants.caseStatusDraft;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.QR)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.QD;
				caseRec.Status=HWS_Constants.caseStatusCancel;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESMOFOC)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.Not_Applicable;
				caseRec.Status=HWS_Constants.caseStatusDraft;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.Service_Declined)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.QExp;
				caseRec.Status=HWS_Constants.caseStatusCancel;
			}
			else
			{
		 caseRec.addError(HWS_Constants.EntitlementStatusValidationError);
			}
			
		}
		
	}
	else if(oldESValue==HWS_Constants.OOW_QuotRequired)
	{
		if(condition== HWS_Constants.UC5 || condition== HWS_Constants.UC3 || condition==HWS_Constants.UC4)
		{
			if(caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingCAPMR || caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingQuotCreation || caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingCAOQ || caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingWarrantyVerification)
			{
				
				caseRec.Status=HWS_Constants.caseStatusOnHold;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESQAPR)
			{
				
				
				caseRec.CH_EntitlementException__c=HWS_Constants.OUT_OF_WARRANTY;
				caseRec.Status=HWS_Constants.caseStatusDraft;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESIWVM)
			{
				if(condition== HWS_Constants.UC5 || condition==HWS_Constants.UC4)
							 {
						caseRec.CH_EntitlementException__c=HWS_Constants.IW_QuotRequired;
									caseRec.CH_EntitlementStatus__c=HWS_Constants.PendingQuotCreation;
						caseRec.Status=HWS_Constants.caseStatusOnHold;
							}
				if(condition== HWS_Constants.UC3)
				{
		caseRec.CH_EntitlementException__c=HWS_Constants.WS_InWarranty;
		caseRec.Status=HWS_Constants.caseStatusDraft;
				}
				
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.QR)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.QD;
				caseRec.Status=HWS_Constants.caseStatusCancel;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESMOFOC)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.Not_Applicable;
				caseRec.Status=HWS_Constants.caseStatusDraft;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.Service_Declined)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.QExp;
				caseRec.Status=HWS_Constants.caseStatusCancel;
			}
			else
			{
		 
				caseRec.addError(HWS_Constants.EntitlementStatusValidationError);
			}
			
		}
		
	}
	else if(oldESValue==HWS_Constants.NA_QuotRequired)
	{
		if(condition== HWS_Constants.UC5 || condition== HWS_Constants.UC3 || condition==HWS_Constants.UC4 || condition==HWS_Constants.UC2B || condition== HWS_Constants.UC1 || condition== HWS_Constants.UC2A || condition==HWS_Constants.UC8)
		{
			if(caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingCAPMR || caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingQuotCreation || caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingCAOQ || caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingWarrantyVerification)
			{
				
				caseRec.Status=HWS_Constants.caseStatusOnHold;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESQAPR || caseRec.CH_EntitlementStatus__c==HWS_Constants.ESMOFOC)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.Not_Applicable;
				caseRec.Status=HWS_Constants.caseStatusDraft;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.QR)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.QD;
				caseRec.Status=HWS_Constants.caseStatusCancel;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.Service_Declined)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.QExp;
				caseRec.Status=HWS_Constants.caseStatusCancel;
			}
			else
			{
		 caseRec.addError(HWS_Constants.EntitlementStatusValidationError);
			}
			
		}
	}
	else
	{
	   caseRec.addError(HWS_Constants.EntitlementStatusValidationError);
	}
	}
	public static void resetIWCases(String oldESValue,Case caseRec,String condition)
	{
		 
	  
		if(oldESValue==HWS_Constants.IW_QuotRequired && (condition== HWS_Constants.UC5 || condition== HWS_Constants.UC2B || condition==HWS_Constants.UC4) )
		{
			if(caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingCAPMR || caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingQuotCreation || caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingCAOQ || caseRec.CH_EntitlementStatus__c==HWS_Constants.PendingWarrantyVerification)
			{
		 
				caseRec.Status=HWS_Constants.caseStatusOnHold;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESQAPR)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.WS_InWarranty;
				caseRec.Status=HWS_Constants.caseStatusDraft;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.QR)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.QD;
				caseRec.Status=HWS_Constants.caseStatusCancel;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.ESMOFOC)
			{
				caseRec.CH_EntitlementException__c=HWS_Constants.Not_Applicable;
				caseRec.Status=HWS_Constants.caseStatusDraft;
			}
			else if(caseRec.CH_EntitlementStatus__c==HWS_Constants.Service_Declined)
			{
			
	caseRec.CH_EntitlementException__c=HWS_Constants.QExp;
	caseRec.Status=HWS_Constants.caseStatusCancel;
			
		 }
			else
			{
		 caseRec.addError(HWS_Constants.EntitlementStatusValidationError);
			}
			
		}
		
	
	}
}