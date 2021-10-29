/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : sendcaseemail
* Description           : Trigger to send emails to customers for acknowledgemetn, surveys
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* Feb-05-2013      1.0            NTTData               Initial Version created
* Apr-01-2013      1.1            NTTData               SR# 375781 - Added Code to send email for EBIZ Web Survey
* June-06-2013     1.2            NTTData               GSS Intergation and SR# 406382 changes
* August-01-2013   1.3            NTTData               SR# 410393 - Added code to send notification email
*                                                       for NavDb Prod record type
***********************************************************************************************************/

trigger sendcaseemail on Case (After insert,After Update) 
{/*commenting inactive trigger code to improve code coverage-----
    set<id> recordtype = new set<id>();
    Map<id,Set<id>>recordmap = new map<id,set<id>>();
    //string recordtype1=label.Quotes_Id;
    string strSurveyTemplate = label.Web_Support_Survey_Template;
    //string quotestemplate=label.quotes_template;
    string MTOTemplate = label.MTO_Template;
    String OtherHoldTemplate = label.Other_Hold_Types_Deferred_On_Line_Order_Template;
    String spexTemplate = label.SPEX_Exchange_Warranty_Deferred_On_Line_Order_Notification_Template;
    //gss integration

    for(Case cas:Trigger.New)
    {
        if(cas.ContactId != null)
        {  
            if(trigger.isinsert &&
             (cas.RecordtypeId == label.GSS_Quotes_Orders || cas.RecordtypeId == label.GSS_Technical_Support
              || cas.RecordtypeId == label.Engine_Rentals_RT_ID || cas.RecordtypeId == label.Orders_Rec_ID
              || cas.RecordtypeId == label.NavDB_Prod_RecordId)
              ) 
            {
                try 
                {
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();            
                    //Setting common variables
                    message.setTargetObjectId(cas.ContactId);
                    message.setWhatId(cas.Id);             
                    message.setBccSender(false);             
                    message.setUseSignature(false);
                    message.setSaveAsActivity(false);         
                    
                    //Setting Template and From address based on email box
                    if(cas.Emailbox_Origin__c == 'Email-Aero GSE Orders')
                    {
                        message.setOrgWideEmailAddressId(label.Aerogssorders);   
                        if(cas.Agent_Contact_Flag__c == false)
                        {
                            message.setTemplateId(label.Order_Status);
                        }
                        else
                        {
                            message.setTemplateId(label.A2C_mapping_Template);                            
                        }
                    }  
                    else if(cas.Emailbox_Origin__c == 'Email-Aero GSE Quotes')
                    {
                        message.setOrgWideEmailAddressId(label.Aerogssquotes);
                        if (cas.Agent_Contact_Flag__c == false)
                        {
                            message.setTemplateId(label.Order_Status);
                        }
                        else
                        {
                            message.setTemplateId(label.A2C_mapping_Template);                            
                        }
                    }  
                    else if(cas.Emailbox_Origin__c == 'Email-Aero GSE Support')
                    {
                        message.setOrgWideEmailAddressId(label.Aerogsssupport);                    
                        if(cas.Agent_Contact_Flag__c == false)
                        {
                            message.setTemplateId(label.Order_Status);                                                                                      
                        }
                        else
                        {
                            message.setTemplateId(label.A2C_mapping_Template);                            
                        }                        
                    }
                    else if(cas.Emailbox_Origin__c == 'Email-Aero GSE Vendor Support')
                    {
                        message.setOrgWideEmailAddressId(label.aerogsevendorsupport);                    
                        if(cas.Agent_Contact_Flag__c == false)
                        {
                            message.setTemplateId(label.Order_Status); 
                        }
                        else
                        {
                            message.setTemplateId(label.A2C_mapping_Template);                            
                        }                                                             
                    } 
                    else if(cas.Emailbox_Origin__c == 'Email-Orders' && cas.sbu__c != 'ATR' && cas.sbu__c != 'D&S' && cas.sbu__c != 'BGA' && cas.service_level__c != 'Unauthorized Dist/Brkr')
                    {                              
                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                    
                        message.setTemplateId(label.Orders_Acknowledgement_Template_ID);                                                           
                    }
                    else if(cas.Emailbox_Origin__c == 'Email-Order Status' && cas.sbu__c != 'ATR' && cas.sbu__c != 'D&S' && cas.sbu__c != 'BGA')
                    {
                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                    
                        message.setTemplateId(label.OrderStatus_Acknowledgement_Template_ID);                                                           
                    } //Code for 427733 starts
                    else if(cas.Emailbox_Origin__c == 'Email-Order Status'  && (cas.sbu__c == 'D&S' || cas.sbu__c == 'BGA'))
                    {
                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                    
                        message.setTemplateId(label.BGA_and_D_S_Template);                                                           
                    } //code for 427733 ends
                    else if(cas.Emailbox_Origin__c == 'Email-EngineRentals')
                    {
                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                    
                        message.setTemplateId(label.ERB_Case_Creation_Template);                                                           
                    }
                    // Added code for SR# 410393
                    else if(cas.RecordtypeId == label.NavDB_Prod_RecordId)
                    {                        
                        String[] ccAddresses = new String[] {'AviationServices@Honeywell.com'};
                        message.setOrgWideEmailAddressId(label.Aviation_Service_OrgID);   
                        message.setCcAddresses(ccAddresses);                 
                        message.setTemplateId(label.NavDB_Prod_TemplateID);
                    }
                    // End for SR# 410393
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
                }
                catch (Exception e) 
                {
                    System.debug('Exception occured while sending mail');
                }
            } 
                   
             //avoiding Workflow rule for agent to contact mapping
            /*if(trigger.isinsert  && (cas.Primary_Email_Address__c != null) && (!cas.subject.contains('Fax:{')) && (cas.Agent_Contact_Flag__c == True))
            {
                if(cas.Mail_Box_Name__c =='Email-D&Sorders' || cas.Mail_Box_Name__c =='Email-D&Squotes' || cas.Mail_Box_Name__c =='Email-R&O D&S' || cas.Mail_Box_Name__c =='Email-ATR R&O Internal'
                || cas.Mail_Box_Name__c =='Email-BGA R&O Internal' || cas.Mail_Box_Name__c =='Email-D&S R&O Internal' || cas.Mail_Box_Name__c =='Email-R&O Canada')
                {
                    try 
                    {
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();            
                        message.setTargetObjectId(cas.ContactId);
                        message.setWhatId(cas.Id);             
                        message.setTemplateId(label.A2C_mapping_Template);
                        message.setBccSender(false);             
                        message.setUseSignature(false);             
                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                        message.setSaveAsActivity(false); 
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
                    }
                    catch (Exception e) 
                    {
                        System.debug('Exception occured while sending mail');
                    }
                }
                
            } 

            //Code added for SR #375781 starts          
            if(trigger.isupdate && cas.Survey_Sent__c == 1 && trigger.oldmap.get(cas.id).Survey_Sent__c != 1
                 && cas.Survey_Type__c == 'Web_Support')
            {
                try 
                {
                     Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                     message.setTargetObjectId(cas.ContactId);
                     message.setWhatId(cas.Id);
                     message.setTemplateId(strSurveyTemplate);
                     message.setBccSender(false);
                     message.setUseSignature(false);
                     message.setOrgWideEmailAddressId(label.Myaerospace_Org_Id);
                     message.setSaveAsActivity(false); 
                     Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
                 }
                 catch (Exception e) 
                 {
                     System.debug('Exception while sending mail for ebiz web survey '+e);
                 }
            }
            //Code added for SR #375781 ends
             /**if(cas.RecordtypeId==recordtype1 && (cas.Subject==null ||!(cas.Subject.contains('MTO')))) 
             {
                 if(trigger.isinsert || (trigger.isupdate && cas.RecordtypeId!=trigger.oldmap.get(cas.id).RecordtypeId))
                 {
                   try {
                     Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                     // Who you are sending the email to
                     message.setTargetObjectId(cas.ContactId);
                     message.setWhatId(cas.Id);
                     // The email template ID used for the email
                     message.setTemplateId(quotestemplate);
                     message.setBccSender(false);
                     message.setUseSignature(false);
                     //message.setReplyTo('response@honeywell.com');
                     //message.setSenderDisplayName('HoneywellRespone');
                     message.setOrgWideEmailAddressId('0D2300000008P9e');
                     message.setSaveAsActivity(false); 
                     Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
                     }
                     catch (Exception e) {}
                 }
             }
             // Code for Igloo Workflows-SR 427733
             if(trigger.isupdate &&(cas.Emailbox_Origin__c=='Email-Quotes') && cas.Account_Concierge__c == 'True' && (cas.SBU__c == 'BGA' || cas.SBU__c == 'D&S' || cas.SBU__c == 'ATR') && cas.Origin!= Trigger.oldMap.get(cas.id).Origin)
             {
                 if(cas.Origin=='Email')
                 {
                    try{
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.setTargetObjectId(cas.ContactId);
                        message.setWhatId(cas.Id);
                        // The email template ID used for the email
                        message.setTemplateId(label.All_Concierge_and_BGA_Owner_Operator_Quotes_Notification);
                       //message.setTemplateId(label.All_Customers_Email_Quote_Customer_Notification);
                        message.setBccSender(false);
                        message.setUseSignature(false);
                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                        message.setSaveAsActivity(false); 
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
                    }
                    catch (Exception ep) {
                    System.debug('RRRRRRRRRRRRR'+ep);
                    }
                }
              }
              else if(trigger.isupdate &&(cas.Emailbox_Origin__c=='Email-Quotes') && cas.SBU__c == 'BGA' && cas.Account_Type__c == 'Owner/Operator' && cas.Origin!= Trigger.oldMap.get(cas.id).Origin)
              {
                 if(cas.Origin=='Email')
                 {
                    try{
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.setTargetObjectId(cas.ContactId);
                        message.setWhatId(cas.Id);
                        // The email template ID used for the email
                        message.setTemplateId(label.All_Concierge_and_BGA_Owner_Operator_Quotes_Notification);
                       //message.setTemplateId(label.All_Customers_Email_Quote_Customer_Notification);
                        message.setBccSender(false);
                        message.setUseSignature(false);
                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                        message.setSaveAsActivity(false); 
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
                    }
                    catch (Exception ep) {
                    System.debug('RRRRRRRRRRRRR'+ep);
                    }
                }
              }
              else if(trigger.isupdate &&(cas.Emailbox_Origin__c=='Email-Quotes') && cas.Origin!= Trigger.oldMap.get(cas.id).Origin)
              {
                 if(cas.Origin=='Email')
                 {
                    try{
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.setTargetObjectId(cas.ContactId);
                        message.setWhatId(cas.Id);
                        // The email template ID used for the email
                        //message.setTemplateId(label.All_Concierge_and_BGA_Owner_Operator_Quotes_Notification);
                        message.setTemplateId(label.All_Customers_Email_Quote_Customer_Notification);
                        message.setBccSender(false);
                        message.setUseSignature(false);
                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                        message.setSaveAsActivity(false); 
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
                    }
                    catch (Exception ep) {
                    System.debug('RRRRRRRRRRRRR'+ep);
                    }
                }
              }
                 if(trigger.isinsert && (cas.Origin=='Web') && cas.recordtypeid == label.recordtype_case_quotes )
             {
                
                try{
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.setTargetObjectId(cas.ContactId);
                        message.setWhatId(cas.Id);
                        // The email template ID used for the email
                        message.setTemplateId(label.Quote_Portal);
                        message.setBccSender(false);
                        message.setUseSignature(false);
                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                        message.setSaveAsActivity(false); 
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
                    }
                    catch (Exception ep) {
                    System.debug('RRRRRRRRRRRRR'+ep);
                    }
                }
                
              if(trigger.isinsert && (cas.Emailbox_Origin__c=='Email-Orders')&&(cas.SBU__c=='BGA')&&
              (cas.Account_Concierge__c=='False' && cas.Account_Type__c!='Owner/Operator'))
                {
                   try{
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.setTargetObjectId(cas.ContactId);
                        message.setWhatId(cas.Id);
                        // The email template ID used for the email
                        message.setTemplateId(label.All_BGA_Template);
                        message.setBccSender(false);
                        message.setUseSignature(false);
                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                        message.setSaveAsActivity(false); 
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
                    }
                    catch (Exception exc) {
                    System.debug('*******************'+exc);
                    }
                }

                //code ends 427733
                //Code for Igloo ends
if(trigger.isinsert && (cas.Emailbox_Origin__c=='Email-RO EMEAI Internal' ||
     cas.Emailbox_Origin__c=='Email-RO Americas Internal' ||
     cas.Emailbox_Origin__c=='Email-R&O APAC Internal' ||
     cas.Emailbox_Origin__c=='Email-OEM Internal' ))
                {
                   try{
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.setTargetObjectId(cas.ContactId);
                        message.setWhatId(cas.Id);
                        // The email template ID used for the email
                        message.setTemplateId(label.Internal_Escalations_Case);
                        message.setBccSender(false);
                        message.setUseSignature(false);
                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                        message.setSaveAsActivity(false); 
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
                    }
                    catch (Exception exc) {
                    System.debug('*******************'+exc);
                    }
                }

            if(cas.Subject!=Null)
            {
                if(cas.Subject.contains('MTO') && cas.Origin=='Web')
                {
                    if(trigger.isinsert || (trigger.isupdate && cas.Subject!=trigger.oldmap.get(cas.id).Subject))
                    {
                        try{
                             Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                             // Who you are sending the email to
                             message.setTargetObjectId(cas.ContactId);
                             message.setWhatId(cas.Id);
                             // The email template ID used for the email
                             message.setTemplateId(MTOTemplate);
                             message.setBccSender(false);
                             message.setUseSignature(false);
                             message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                             message.setSaveAsActivity(false); 
                             Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
                         }
                         catch (Exception e) {}
                    }
                }
            }
            if(cas.Sub_Class__c == 'Deferred Online Order' && (cas.Subject == null || (!(cas.Subject.contains('SPEX Warranty'))
             && !(cas.Subject.contains('MTO'))&& !(cas.Subject.contains('WebOrder; SPEX; Warranty verification'))))) 
            {
                if(trigger.isinsert || (trigger.isupdate && cas.Sub_Class__c != trigger.oldmap.get(cas.id).Sub_Class__c))
                {
                    try{
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.setTargetObjectId(cas.ContactId);
                        message.setWhatId(cas.Id);
                        // The email template ID used for the email
                        message.setTemplateId(OtherHoldTemplate);
                        message.setBccSender(false);
                        message.setUseSignature(false);
                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                        message.setSaveAsActivity(false); 
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
                    }
                    catch (Exception e) {}
                }
            }
             if(cas.Subject!=Null)
             {
                  if(cas.Subject.contains('WebOrder; SPEX; Warranty verification'))
                  {
                     if(trigger.isinsert || (trigger.isupdate && cas.Subject!=trigger.oldmap.get(cas.id).Subject))
                     {
                         try{
                         Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                         message.setTargetObjectId(cas.ContactId);
                         message.setWhatId(cas.Id);
                         // The email template ID used for the email
                         message.setTemplateId(spexTemplate);
                         message.setBccSender(false);
                         message.setUseSignature(false);
                         message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                         message.setSaveAsActivity(false); 
                         Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
                         }
                         catch (Exception e) {}
                     }
                 }
             }
        }
    }
     for(Case cas:Trigger.New)
    {
    if(trigger.isinsert && (cas.Emailbox_Origin__c=='Email-Orders') && (cas.SBU__c == 'ATR') && cas.Primary_Email_Address__c != '')
                {
                   try{
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.setTargetObjectId(cas.ContactId);
                        message.setWhatId(cas.Id);
                        // The email template ID used for the email
                        message.setTemplateId(label.all_atr_orders);
                        message.setBccSender(false);
                        message.setUseSignature(false);
                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                        message.setSaveAsActivity(false); 
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
                    }
                    catch (Exception exc) {
                    System.debug('*******************'+exc);
                    }
                    }
                     if(trigger.isinsert && (cas.Emailbox_Origin__c=='Email-Order Status') && (cas.SBU__c == 'ATR') && cas.Primary_Email_Address__c != '')
                {
                   try{
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.setTargetObjectId(cas.ContactId);
                        message.setWhatId(cas.Id);
                        // The email template ID used for the email
                        message.setTemplateId(label.atr_order_status);
                        message.setBccSender(false);
                        message.setUseSignature(false);
                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                        message.setSaveAsActivity(false); 
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
                    }
                    catch (Exception exc) {
                    System.debug('*******************'+exc);
                    }
                }
                    if(trigger.isinsert && (cas.Emailbox_Origin__c=='Email-Orders') && (cas.SBU__c == 'D&S') && cas.Primary_Email_Address__c != '')
                {
                   try{
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.setTargetObjectId(cas.ContactId);
                        message.setWhatId(cas.Id);
                        // The email template ID used for the email
                        message.setTemplateId(label.orders_d_s);
                        message.setBccSender(false);
                        message.setUseSignature(false);
                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                        message.setSaveAsActivity(false); 
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
                    }
                    catch (Exception exc) {
                    System.debug('*******************'+exc);
                    }
                }
 if(trigger.isinsert && (cas.Emailbox_Origin__c=='Email-Orders') && (cas.SBU__c == 'BGA') && cas.Primary_Email_Address__c != '' && (cas.Account_Concierge__c == 'true' || cas.Account_Type__c == 'Owner/Operator'))
                {
                   try{
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.setTargetObjectId(cas.ContactId);
                        message.setWhatId(cas.Id);
                        // The email template ID used for the email
                        message.setTemplateId(label.BGA_orders_conci_true_owner_operator);
                        message.setBccSender(false);
                        message.setUseSignature(false);
                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                        message.setSaveAsActivity(false); 
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
                    }
                    catch (Exception exc) {
                    System.debug('*******************'+exc);
                    }
                }
                }*/
}