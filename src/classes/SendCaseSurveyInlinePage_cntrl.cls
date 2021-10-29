public class SendCaseSurveyInlinePage_cntrl{
    public string caseid{get;set;}
    public Case c{get;set;}
    public string strSurveyType = 'RGQO';
    public boolean flag2 {get;set;}
    //public string strSurveyType2 = 'Manual_General';
    //public string strSurveyType3 = 'Manual_WebSupport';
   
    
    public Id orders_RecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Orders').getRecordTypeId();
    public Id WebSupport_RecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('WEB Support').getRecordTypeId();
    public Id general_RecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('General').getRecordTypeId();
    public Id quotes_RecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Quotes').getRecordTypeId();
    public Id R_O_RecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Repair & Overhaul').getRecordTypeId();
    public Id OEM_RecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('OEM Quotes Orders').getRecordTypeId();
    public Id Ret_RecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Returns').getRecordTypeId();
    public Id Retp_RecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ReturnsPRO').getRecordTypeId();
    public Id CpFeedback_RecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CP Events Record Type').getRecordTypeId();

    
    //public List <String> statusValues = new List<String>{'Open','Re-Open','On Hold','Cancelled'};   
   
    private ApexPages.StandardController con;


    //List<String> toAddress = new List<String>();
    //Public List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
  
  
    public SendCaseSurveyInlinePage_cntrl(ApexPages.StandardController controller) {
        caseid=System.currentPageReference().getParameters().get('id');
              c= [select id,contactId,ownerid,AccountId,CaseNumber,CreatedDate,Subject,Origin,User_CBT__c,SBU__c,Region__c,
                   Status,Owner_Manager__c, Service_Level__c, RecordTypeId,type, Classification__c, Sub_Class__c, Detail_Class__c, 
                   Customer_PO_RO_WONumber__c,Primary_Work_Number__c,Survey_Type__c,Requestor_Email_Address__c, Account_Name__c, NSS_Survey_Link__c,Survey_Sent__c from case where id=:caseid];
              
              con = controller;  
    }
    
  public PageReference givesurvey(){
    
        if((c!= NULL && c.Status != 'Done' && c.Status != 'Closed')  ){
            System.Debug('Inside Warning Message condition');
            System.Debug('Id: ' +c.Id);
            System.Debug('Status' +c.Status);
            flag2 = TRUE;
            
        }   
        
        else if (c!= NULL && (c.status == 'Done' || c.status == 'Closed') && c.ContactId != NULL && c.NSS_Survey_Link__c == NULL)  {
            
            System.Debug('Entry condition to generate new NSS Survey Link');
            Contact con = [SELECT Id, Email, Last_Survey_Date__c, RecordTypeId, Last_Survey_Type__c, Survey_Opt_Out__c, NPS_Survey__c, SBU_Contact__c
                                    FROM Contact 
                                    WHERE Id = :c.ContactId limit 1];
             
             User objUser = AfterUpdateHelperClass.getUserDetails(c.ownerid);
             System.Debug('Before Calling AfterUpdateHelper Class');
            if(c.RecordTypeId == general_RecType && c.Type =='MyAerospace Survey' ) {
                 strSurveyType = 'Manual_General';
            }    
                  
            else if (c.RecordTypeId == WebSupport_RecType){
                 strSurveyType = 'Manual_WebSupport';
                 
            }  
            else if (c.RecordTypeId == CpFeedback_RecType ){
                 strSurveyType = 'Manual_CpFeedback';
                 
            }    
            else {
                strSurveyType = 'RGQO';
            }       
            
            System.Debug('Survey Type: ' +strSurveyType);
             AfterUpdateHelperClass.SendSurvey(c, con, strSurveyType, objUser);
             System.Debug('After Calling AfterUpdateHelper Class');
             
            System.Debug('end of current if');
            PageReference pr = new PageReference('/apex/SendCaseSurveyInlinePage_page2');
            pr.setRedirect(true);
            return pr;  
        }
    else if (c!= NULL && (c.status == 'Done' || c.status == 'Closed') && c.ContactId == NULL && c.NSS_Survey_Link__c == NULL)  {        
        User objUser = AfterUpdateHelperClass.getUserDetails(c.ownerid);
             System.Debug('Before Calling AfterUpdateHelper Class');
             if (c.RecordTypeId == CpFeedback_RecType ){
                 strSurveyType = 'Manual_CpFeedback';
                 
            }
          System.Debug('Survey Type: ' +strSurveyType);
             AfterUpdateHelperClass.SendSurvey(c, strSurveyType, objUser);
             System.Debug('After Calling AfterUpdateHelper Class');
             
             //else if(c!= NULL && (c.status == 'Done' || c.status == 'Closed') && c.ContactId == NULL && c.NSS_Survey_Link__c != NULL && strSurveyType == 'Manual_CpFeedback' ){
            Contact con1 = new Contact();
con1.FirstName = 'Test';
con1.LastName = 'Contact';
con1.Email = 'no-reply@organization.com';
insert con1;
            List<String> sendTo = new List<String>();           
      sendTo.add(c.Requestor_Email_Address__c);
                System.Debug('Latest Survey link2 is present, hence just sending the email to contact');
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(con1.Id);
                mail.setWhatId(c.Id);
                mail.settoAddresses(sendTo);
                mail.setTemplateId(label.WebToCase_CPEVENTS1);
                mail.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                mail.setBccSender(false);
                mail.setUseSignature(false);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
                delete con1;
                c.Survey_Sent__c = 1; 
                Update c;
                PageReference pr = new PageReference('/apex/SendCaseSurveyInlinePage_page2');
                pr.setRedirect(true);
                return pr;            
                
           
          
    }           
    
           else if (c!= NULL && (c.status == 'Done' || c.status == 'Closed') && c.ContactId != NULL && c.NSS_Survey_Link__c != NULL &&
            (c.Survey_Type__c == 'RGQO' || c.Survey_Type__c == 'Manual_General' || c.Survey_Type__c == 'Manual_WebSupport' || c.Survey_Type__c == 'Manual_CpFeedback' )){
            
            if ((c.RecordTypeId == general_RecType && c.Type =='MyAerospace Survey' && c.Survey_Type__c == 'Manual_General') ||
            (c.RecordTypeId == general_RecType && c.Type !='MyAerospace Survey' && c.Survey_Type__c == 'RGQO'))
            
            {
                System.Debug('Latest Survey link1 is present, hence just sending the email to contact');
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(c.contactId);
                mail.setWhatId(c.Id);
                mail.setTemplateId(label.NSS_Survey_Email);
                mail.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID); 
                mail.setBccSender(false);
                mail.setUseSignature(false);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
                
                c.Survey_Sent__c = 1; 
                Update c;
                PageReference pr = new PageReference('/apex/SendCaseSurveyInlinePage_page2');
                pr.setRedirect(true);
                return pr;
                
            }
            
            else if ((c.RecordTypeId == general_RecType && c.Type =='MyAerospace Survey' && c.Survey_Type__c != 'Manual_General') ||
            (c.RecordTypeId == general_RecType && c.Type !='MyAerospace Survey' && c.Survey_Type__c != 'RGQO')) {
                //Generate new Survey URL
                Contact con = [SELECT Id, Email, Last_Survey_Date__c, RecordTypeId, Last_Survey_Type__c, Survey_Opt_Out__c, NPS_Survey__c, SBU_Contact__c
                                    FROM Contact 
                                    WHERE Id = :c.ContactId limit 1];
             
             User objUser = AfterUpdateHelperClass.getUserDetails(c.ownerid);
             System.Debug('Before Calling AfterUpdateHelper Class');
              if(c.Type =='MyAerospace Survey') strSurveyType = 'Manual_General';  
              if(c.Type !='MyAerospace Survey') strSurveyType = 'RGQO';
              
            System.Debug('Survey Type: ' +strSurveyType);
             AfterUpdateHelperClass.SendSurvey(c, con, strSurveyType, objUser);
             System.Debug('After Calling AfterUpdateHelper Class');
             
            System.Debug('end of current if');
            PageReference pr = new PageReference('/apex/SendCaseSurveyInlinePage_page2');
            pr.setRedirect(true);
            return pr;  
                
            }   
            
            else{
            
                System.Debug('Latest Survey link2 is present, hence just sending the email to contact');
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(c.contactId);
                mail.setWhatId(c.Id);
                mail.setTemplateId(label.NSS_Survey_Email);
                mail.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                mail.setBccSender(false);
                mail.setUseSignature(false);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
                
                c.Survey_Sent__c = 1; 
                Update c;
                PageReference pr = new PageReference('/apex/SendCaseSurveyInlinePage_page2');
                pr.setRedirect(true);
                return pr;
            
            }
        } 
        
                 
        
        else if ((c!= NULL && (c.status == 'Done' || c.status == 'Closed') && c.ContactId != NULL && c.NSS_Survey_Link__c != NULL ) &&
        (c.Survey_Type__c != 'RGQO' || c.Survey_Type__c != 'Manual_General' || c.Survey_Type__c != 'Manual_WebSupport' || c.Survey_Type__c != 'Manual_CpFeedback')) {
        
            
            System.Debug('NSS Survey Link is old, hence generating new one');   
            
            Contact con = [SELECT Id, Email, Last_Survey_Date__c, RecordTypeId, Last_Survey_Type__c, Survey_Opt_Out__c, NPS_Survey__c, SBU_Contact__c
                                    FROM Contact 
                                    WHERE Id = :c.ContactId limit 1];
             
             User objUser = AfterUpdateHelperClass.getUserDetails(c.ownerid);
             System.Debug('Before Calling AfterUpdateHelper Class');
             if(c.RecordTypeId == general_RecType && c.Type =='MyAerospace Survey') {
                 
                 strSurveyType = 'Manual_General';
                 System.Debug('Survey Type: ' +strSurveyType);
             }  
            else if (c.RecordTypeId == WebSupport_RecType){
                
                 strSurveyType = 'Manual_WebSupport';
                 System.Debug('Survey Type: ' +strSurveyType);
            }
            else if (c.RecordTypeId == CpFeedback_RecType ){
                
                 strSurveyType = 'Manual_CpFeedback';
                 System.Debug('Survey Type: ' +strSurveyType);
            }
            else {
                strSurveyType = 'RGQO';
            }
             
            AfterUpdateHelperClass.SendSurvey(c, con, strSurveyType, objUser);
            System.Debug('After Calling AfterUpdateHelper Class');
             
            System.Debug('end of current if');
            PageReference pr = new PageReference('/apex/SendCaseSurveyInlinePage_page2');
            pr.setRedirect(true);
            return pr;
                
        }       

        if (c!= NULL && (c.status == 'Done' || c.status == 'Closed') && c.ContactId == NULL && c.NSS_Survey_Link__c != NULL)   
{
         Contact con1 = new Contact();
con1.FirstName = 'Test';
con1.LastName = 'Contact';
con1.Email = 'no-reply@organization.com';
insert con1;
            List<String> sendTo = new List<String>();           
      sendTo.add(c.Requestor_Email_Address__c);
                System.Debug('Latest Survey link2 is present, hence just sending the email to contact');
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(con1.Id);
                mail.setWhatId(c.Id);
                mail.settoAddresses(sendTo);
                mail.setTemplateId(label.WebToCase_CPEVENTS1);
                mail.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                mail.setBccSender(false);
                mail.setUseSignature(false);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
                delete con1;
                c.Survey_Sent__c = 1; 
                Update c;
                PageReference pr = new PageReference('/apex/SendCaseSurveyInlinePage_page2');
                pr.setRedirect(true);
                return pr;     
  }           
           
      return null;
  }//give survey end   
}