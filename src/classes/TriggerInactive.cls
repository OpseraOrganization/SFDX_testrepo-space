/*******************************************************************************
Name         : TriggerInactive
Created By   : Anusuya Murugiah
Company Name : NTT Data
Project      : <Phase-II>, <HealthCheck - Sprint 2>
Created Date : 31 October 2012 
Usages       : This Class has set of boolean variables which is used to stop 
               the recursive call of triggers. 
Modification History  :
Date          Version No.     Modified by     Brief Description of Modification
15 Nov 2013   1.1             NTTDATA         HAN-0263 Healtcheck Sprint 2              
*******************************************************************************/
public class TriggerInactive
{
public static boolean Update_Discretionary_Plan_DLI_DR = True;
public static boolean Update_DLI_DR = True;
public static boolean testTrigger = True;
public static boolean TestCaseCancelled = True;
public static boolean TestCSMCaseCreation = True;
public static boolean TestOppRequiredFields = True;
public static boolean TestOppUpdate_UpdateStage = True;
public static boolean TestCasValUpdtBasOnOwner = true;
public static boolean TestATROpp_ContentDeliveries_Automation = True;
public static boolean TestOpportunityProduct_UpdateTechSales = True;
public static boolean TestOpportunity_InsertPhases = True;
public static boolean avoidRecursion = True;
public static boolean avoidRecursion1 = True;
public static boolean createRotableCase = True;
public static boolean sendNotification= True;
// HAN-0263 Healtcheck Sprint 2 - Start
public static boolean blnCaseWFDelegate = True;
public static boolean blnCaseWFDelegateUpdate = True;
public static boolean sendmailnotif = True;
// HAN-0263 Healtcheck Sprint 2 - Start
public static boolean sendMail= True; 
public static boolean blnCasetechupdate =  True;
public static boolean avoidCloserecursion = True;
public static boolean avoidcaseonholdlog = True;
public static boolean avoidRecursionemail = True;
Public static boolean avoidRecursionPPO = True;
Public static boolean avoidRecursionROI = True;
Public static boolean avoidRecursionROIservice = True;
Public static boolean avoidRecursionCase = True;
Public static boolean avoidRecursionCase1 = True;
Public static boolean avoidRecursionCaseInsert = True;
Public static boolean avoidRecursionCaseUpdate = True;
Public static boolean avoidTriggerRecursionCase = True;
Public static boolean avoidRecursionContact = True;
Public static boolean avoidRecursionContact_Sync = True;
Public static boolean avoidRecursionCaseBeforeUpdate = True;
}