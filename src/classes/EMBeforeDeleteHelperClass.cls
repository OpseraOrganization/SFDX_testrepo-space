/*******************************************************************************
Name         : EMBeforeDeleteHelperClass
Created By   : Anusuya Murugiah
Company Name : NTT Data
Project      : Fix for SOQL 101 Error 
Created Date : 22 December 2014
Usages       : This Trigger is to replace the set of Email Message Triggers split across 
               into single trigger call.  
*******************************************************************************/
public class EMBeforeDeleteHelperClass
{
    public static void emBeforeDeleteMethod(Map<ID,EmailMessage> oldMap ){
        // DeleteNotAllowed trigger - Start
        // Rule to check only users with System Admin,Honeywell System Administrator and
        // Honeywell System Administrator (US) Profile can Delete Email Message
        Id ProfileId = Userinfo.getProfileId();        
        for(EmailMessage e1 : oldMap.values()){
            //if(ProfileId != '00e300000017loa' && ProfileId != '00e30000001YFih' && ProfileId != '00e30000001WUxB'){
            //bypass developer admin non us profile as part of INC0003089009
            if(ProfileId != label.Sys_Admin_Profile_Id && ProfileId != label.Honeywell_System_Administrator_US && ProfileId !=label.Developer_Administrator_Non_US && ProfileId != label.Honeywell_System_Administrator && e1.status!='5'){
                e1.adderror('Please Contact your System Administrator: Deletion Not Permitted');
            }
        }
        // DeleteNotAllowed trigger - End
    }
}