/** * File Name: REG_PortalUserRegistration_Service 

* Description  Service class for Portal User Record

* * @author : TCS 

Date 01/16/2019 

* */ 
public with sharing class REG_PortalUserRegistration_Service {
    
    /**
*Method used to get thr Portal User Registration record using honeywell Id
**/    
    public static REG_Result getPURDetails(String honeywellid,String EmailId){
        REG_Result result =new REG_Result();
        try{
            List<Portal_User_Registration__C> pur;
            if(honeywellid!=null && honeywellid!=''){
                pur=[SELECT Contact__c,EmailAddress__c,AppID__c,Contact_Creation_in_SFDC__c,Contact_Match__c,Contact_OR_Domain_Match__c,Create_HoneywellId__c,Create_New_Contact__c,Company_Not_Listed__c,Domain_Match__c,Honeywell_ID__c,Id,Initial_Reg__c,Is_Employee__c,Select_Company__c,Select_Existing_Contact__c,Unidentified_User__c,Validating_Email__c FROM Portal_User_Registration__c WHERE Honeywell_ID__c = :HoneywellId ];
                /*REG_Result conDetails = REG_PortalContact_Service.getContactforHid(honeywellid);
return conDetails;*/
            }
            else{
                pur=[SELECT Contact__c,EmailAddress__c,AppID__c,Contact_Creation_in_SFDC__c,Contact_Match__c,Contact_OR_Domain_Match__c,Create_HoneywellId__c,Create_New_Contact__c,Company_Not_Listed__c,Domain_Match__c,Honeywell_ID__c,Id,Initial_Reg__c,Is_Employee__c,Select_Company__c,Select_Existing_Contact__c,Unidentified_User__c,Validating_Email__c FROM Portal_User_Registration__c WHERE EmailAddress__c=:emailId];
                
            }
            if(pur!=null && pur.size()==0){
                result.handleError(404, 'PUR record not found', 'PUR record not found for the honeywell id and email address');
            }
            result.Data=pur;
        }        
        catch(System.Exception e){
            result.handleException(500, e.getMessage(), e);
            
        }
        
        return result;
    }//end of getPURDetails
    
    /**
*Method used to Update or insert the Portal User Registration 
**/    
    public static REG_Result setPURDetails(Object PURDetails ){
        REG_Result result =new REG_Result();
        try{
            
            Portal_User_Registration__C pur=(Portal_User_Registration__C)PURDetails;
            List<Portal_User_Registration__C> purRecordsByHoneywellId=new  List<Portal_User_Registration__C>();
            List<Portal_User_Registration__C> purRecordsByEmailId=new  List<Portal_User_Registration__C>();
            if(pur.Honeywell_ID__c!=null){
                purRecordsByHoneywellId=[select Id from Portal_User_Registration__c where honeywell_id__c = :pur.Honeywell_ID__c ];
                system.debug('purRecordsByHoneywellId  ' +purRecordsByHoneywellId); 
            }
            if(pur.EmailAddress__c!=null){
                purRecordsByEmailId=[select Id from Portal_User_Registration__c where EmailAddress__c = :pur.EmailAddress__c ];
                system.debug('purRecordsByEmailId  ' +purRecordsByEmailId); 
            }
            if(purRecordsByHoneywellId.size()>0)
                pur.id=purRecordsByHoneywellId[0].id;
            else if(purRecordsByEmailId.size()>0) 
                pur.id=purRecordsByEmailId[0].id;
            UPSERT pur Id;
            result.resourceId =pur.ID;
            result.status='success';
        }       
        
        catch(System.DMLException e){
            result.handleException(500, 'Portal User record Insert/Update Failure', e);
            
        } 
        catch(System.Exception e){
            
            result.handleException(500, e.getMessage(), e);
        }
        
        return result;
    }//end of getPURDetails
}//end of REG_PortalUserRegistration_Service