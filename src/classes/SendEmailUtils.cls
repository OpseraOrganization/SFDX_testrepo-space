public class SendEmailUtils
{
    @InvocableMethod
    public static void SendEmail(List<Id> caseId)
    {
    try{
    boolean boolStopEmail = false;
    case c=[select id,sub_class__c,contactid,contact.Email,Type_of_Request__c,Emailbox_Origin__c,recordtype.name,ownerid__r.DTS_Check__c,Classification__c,status,
    ContactRequested__c,ownerid__r.managerid,P2C_sent__c,ownerid from case where Id in :caseId limit 1];
    //system.debug ('exception sendEmailUtils'+c);
    //Added for Bendixking Project
    if(c!=null && c.contactid!= null && (c.recordtype.name =='AOG' || (c.ownerid__r.DTS_Check__c == false 
    && c.Classification__c == 'GTO' && c.recordtype.name =='Technical Issue') ||(c.ownerid__r.DTS_Check__c == false 
    && c.sub_class__c == 'Bendix/King' && c.recordtype.name =='Technical Issue' && c.Emailbox_Origin__c=='Email-BendixKing') 
    || (c.recordtype.name =='Orders' && c.Sub_Class__c =='SPEX/Exchange' && c.Type_of_Request__c=='SPEX Request')) 
    && c.status == 'Propose to Close' ){
    //New instance of a single email message
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String domain = c.contact.Email.split('@').get(1);
    if(domain!='honeywell.com' || domain!='Honeywell.com' || domain!='HONEYWELL.COM'){
    // Who you are sending the email to
    mail.setTargetObjectId(c.contactid);
    }
    
    // The email template ID used for the email
    if (c.recordtype.name =='Technical Issue' && c.sub_class__c != 'Bendix/King'){
    mail.setTemplateId(label.GTO_P2C_EmailTemplateId);
    mail.setOrgWideEmailAddressId(label.Aero_tech_support);
      }
     //Added for Bendixking Project
    if (c.recordtype.name =='Technical Issue' && c.sub_class__c == 'Bendix/King'){
    mail.setTemplateId(label.BendixKing_P2C_EmailTemplateId);
    mail.setOrgWideEmailAddressId(label.Bendixking_org_wide_address);
      }  
      if (c.recordtype.name =='AOG'){
                if(c.Emailbox_Origin__c == 'Email-crc-spex'){ //if condition addedd for SCTASK1732824
                    mail.setTemplateId(label.SPEX_AOG);
                    mail.setOrgWideEmailAddressId(label.SPEX_AOG_From_Address); 
                }
                else{
                    mail.setTemplateId(label.AOG_P2C_EmailTemplateId);
                    mail.setOrgWideEmailAddressId('0D2300000008PGM');
                }           
                
        }     
        if (c.recordtype.name =='Orders' && c.Type_of_Request__c=='SPEX Request'){
            mail.setTemplateId(label.SPEX_AOG);
            mail.setOrgWideEmailAddressId(label.SPEX_AOG_From_Address);
        }        
        
    mail.setWhatId(c.id);    
    mail.setBccSender(false);
    mail.setUseSignature(false);
    //mail.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);
    //mail.setSenderDisplayName('Aero Do Not Reply');
    //mail.setSaveAsActivity(true);  
    //system.debug('c.P2c_sent__c'+c.P2c_sent__c);
     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        if(c.P2c_sent__c == null || c.P2c_sent__c == 0.0 )
        {
            c.P2C_sent__c=1;
        }
        else
        {
            c.P2C_sent__c= c.P2C_sent__c + 1;
            system.debug('else called');
           
        }
     update c;
    }
    
    //RAPD-2702(Convert Surveys to Propose to Close for Quotes case types) 
    System.Debug('****Inside Class****');
    system.debug('check bool'+boolStopEmail  );
  if(c!=null && c.contactId != null && c.status == 'Propose to Close' &&  (((c.recordtype.name == 'OEM Quotes Orders' && c.Emailbox_Origin__c == 'Email-BGAOEMQuoteOrders' )|| (c.recordtype.name =='OEM/Spares') ||( c.recordtype.name=='Orders' && c.Emailbox_Origin__c == 'Email-Orders') ) || ((c.recordtype.name =='OEM Quotes Orders') || (c.recordtype.name =='OEM/Spares') || (c.recordtype.name =='Orders') ) ) )
    {          
    system.debug('Inside OEM If condition****');
        Messaging.SingleEmailMessage mailObj = new Messaging.SingleEmailMessage();        
        mailObj.setTargetObjectId(c.contactid);
        //changing vml buttons in email template
        mailObj.setTemplateId(label.OEM_Orders_TemplateID_Custom);
        //mailObj.setTemplateId(label.OEM_Orders_TemplateID);
        mailObj.setOrgWideEmailAddressId(label.OEM_Orders_Org_Wide_Address);       
        mailObj.setWhatId(c.id);    
        mailObj.setBccSender(false);
        mailObj.setUseSignature(false);
          if(c.P2c_sent__c == null || c.P2c_sent__c == 0.0 )
        {
            c.P2C_sent__c=1;
        }
        else
        {
            c.P2C_sent__c= c.P2C_sent__c + 1;
            system.debug('else called');
           
        }
     update c;
     if( c.P2C_sent__c >2){
     boolStopEmail  = true; 
     }
        //send email
        system.debug('checkbool'+boolStopEmail );
        if(boolStopEmail  == false){
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailObj });
         }
    }
    // RAPD-2702 ended changes  
   
   // if(!Test.isRunningTest()){ 
    if (c.status == 'Open-Rejected' && c.ContactRequested__c.contains('Yes,')){
    Task newTask = new Task();
    newTask.subject = 'Customer Requested Contact';
    newTask.whatId = c.Id;
    
    if(c.ContactRequested__c == 'Yes, have a member of the management team call me'){
    newTask.ownerId = c.ownerid__r.managerid;
    }
    else{
    newTask.ownerId = c.OwnerId;
    }
    newTask.status = 'Open';
    newTask.Priority = 'Normal';
    newTask.Description = 'Customer has requested Phone Call: '+c.ContactRequested__c+'.'+
    ' Review the feedback, contact the case owner and take appropriate action.';
    newTask.recordtypeid=label.Survey_followup_task;
    newtask.whoid =c.contactid;
    //insert  newTask;
    Database.DMLOptions dmlOptions = new Database.DMLOptions(); 
    if(c.recordtype.name == 'Technical Issue'){ 
    dmlOptions.EmailHeader.TriggerUserEmail = TRUE;
    }
    Database.Insert(newTask, dmlOptions);
    }
    //}
    }catch(exception e){
    //system.debug ('exception sendEmailUtils'+e);
    }
    }
}