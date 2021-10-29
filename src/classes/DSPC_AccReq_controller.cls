Public with sharing class DSPC_AccReq_controller {
    public Case AccCase{get;set;}
    public id uid;
    public user currentuser; 
    // Constructor
    public DSPC_AccReq_controller() {
        AccCase = new case();
        uid = userinfo.getuserid();
        currentuser = [select ID, contactid from user where id =:uid limit 1];
    }
    // Method to create a new case for account request
    public pagereference Submit() {
            try {
                AccCase.Status = 'Active';
                AccCase.First_Call_Resolution__c = true;
                AccCase.RecordTypeId = label.DSPC_CMDT_RecordTypeId;
                AccCase.Export_Compliance_Content_ITAR_EAR__c = 'No';
                AccCase.Government_Compliance_SM_M_Content__c = 'No';
                AccCase.OwnerId = Label.DSPC_MDT_Queue_ID;
                if (currentuser.contactid != null || currentuser.contactid != '') {
                AccCase.contactid = currentuser.contactid;
                }
                insert AccCase;
            }
            catch (exception e) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'An Unexpected Error has occured. Please Re-Check the values entered or contact Support team'));    
                return null;
            }
        
        pagereference pageref = new pagereference('/apex/DSPC_Account_List');
        pageref.setredirect(true);
        return pageref;
    }
    // Back button for Account List page
    public pagereference back() {
        pagereference pageref = new pagereference('/apex/DSPC_Account_List');
        pageref.setredirect(true);
        return pageref;
    }
}