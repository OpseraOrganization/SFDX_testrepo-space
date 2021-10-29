/** * File Name: SendMail_TaskOwnerManager 
* Description :Trigger to send mail based on task
* Copyright : NTTDATA 2015 *
* @author : NTTDATA
* Modification Log =============================================================== Ver Date Author Modification --- ---- ------ -------------*
Version   Date         Author         Modification 
1.1       9/29/2015    NTTDATA        INC000008975216 - Activity Notifications for NSS Detractor Ratings  
1.2       20/05/2016   NTTDATA        INC000009966209 - NSS Detractor Follow Up notification to include link to Case, Activity and Feedback Records **/ 

trigger SendMail_TaskOwnerManager on Task (after insert) {
    List<Case> Accountname= new List<Case>();
    List<Task> Sublist = new List<Task>();
    List<Task> SERSublist = new List<Task>();
    String Subjected;
    set<id> OwnerID= new set<id>();
    set<id> WhatID= new set<id>();
    set<id> sertaskId = new set<id>();
    Map<id,Case> sertaskmap = new Map<Id,Case>();
    String link=label.Instance_Link;
    String parent='';
    String SalesOrder='',Subject = '',SBU ='', CBTteam ='', cbt ='', Description = '', CaseNumber='',EmailReceivedext ='',Notes='',CustFocal ='',EmailSentext ='',BusFocal ='',ClosedDate='',EmailSent='',EmailReceived ='',Holds ='',ces='',ContactEmail='',ContactWork='',Resolution='',NPSRecomm='',NPSClass='',InquiryCls='',EaseofCon='',AGentKnow='',Timeliness='',Quality='',Agent='',OverallSatis='',CommentsTopic='',Comments='',ContactReq='',OwnerSite='',OwnerMan='',NoOfContacts ='',FCR='';
    
    for(Task ntask : Trigger.new){
        if(ntask.recordtypeid!= label.General_Task ){
            system.debug('inside trigger');
            Subjected = ntask.Subject;
            system.debug('Subjected' +Subjected);
            if(Subjected != ''& Subjected!= Null){
                System.debug('inside first IF condition');
                ///Subjected = Subjected.toUpperCase();
                if(Subjected.contains('NSS Survey - Follow Up')){
                    System.debug('entered subject');
                    OwnerID.add(ntask.Ownerid);    
                    Sublist.add(ntask);
                    WhatID.add(ntask.whatid);
                    system.debug('???????'+WhatID);
                }
                parent=ntask.whatId;
                system.debug('parent'+parent);
                if(parent!=null)//Added for null pointer fix
                    parent=parent.substring(0,3);
                System.debug('second IF condition');
                //if(Subjected.contains('NSS Detractor Follow Up') && ntask.recordtypeid==label.Service_Task_RT_ID && parent=='500' ){
                if(Subjected.contains('NSS Detractor Follow Up') && ntask.recordtypeid==label.Task_Survey_FP_RecordTypeId && parent=='500' ){   
                    System.debug('test4560');
                    WhatID.add(ntask.whatid);
                    OwnerID.add(ntask.Ownerid);
                    sertaskId.add(ntask.id); 
                    SERSublist.add(ntask);
                } 
            }
        }    
    } 
    // Query from Feedback object
    List<Feedback__c> Fblist = new list<Feedback__c>();
    Map<Id,User> usrmap = new Map<Id,User>([Select Name, Email, Managerid, Manager.email,Manager.Name,Id From User where Id in : OwnerID]);
    List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
    List<User> users = [SELECT Email FROM User WHERE Id IN (
                                      SELECT UserOrGroupId
                                      FROM GroupMember
                                      WHERE Group.Name = :'NSS Detractor ATR BGA')];
                                    System.Debug('Users list length: ' + users.size());
                                        
                                    
    // INC000008975216  - Start
    Map<String,NSSDetractor__c> nssOwnerMap = NSSDetractor__c.getall();
    // INC000008975216  - End   
    String htmlstring= '';
    list<case> clist = new list<case>();
    if(WhatID.size()>0){    
        //Case_Owner_Manager_Email__c field is included in the query for INC0002574948
        Accountname = [select ID,Owner.Email, CreatedDate,ClosedDate,Type__c,RecordType.name,Notes__c,Account_Name__c,Contact_name__c,casenumber,subject,Description,owner.name,SBU__c,Origin,CBT__c,CBT_Team__c,Customer_Support_Focal__r.name,Customer_Support_Focal__r.Primary_Email_Address__c,Business_Focal__r.name,Sales_Order_Number__c,Primary_Email_Address__c,Primary_Work_Number__c,of_Emails_Sent__c,of_Emails_Received__c,of_Holds__c,Resolution__c,CSM_Feedback__c,CSM_Feedback__r.name,CSM_Feedback__r.CES_Score__c,CSM_Feedback__r.No_of_Contacts_to_Resolve__c,CSM_Feedback__r.Comments__c,CSM_Feedback__r.NPS_Recommend__c,CSM_Feedback__r.NPS_Classification__c,CSM_Feedback__r.Inquiry_closed__c,CSM_Feedback__r.Ease_of_Contact_Availability__c,CSM_Feedback__r.Knowledge_Technical_Expertise__c,CSM_Feedback__r.Timeliness_of_response__c,CSM_Feedback__r.Quality_and_Accuracy__c,CSM_Feedback__r.Courtesy_and_Professionalism__c,CSM_Feedback__r.Overall_satisfaction__c,CSM_Feedback__r.Comments_Topic__c,CSM_Feedback__r.Contact_requested__c,CSM_Feedback__r.Owner_Manager__c,CSM_Feedback__r.Owner_Site__c,CSM_Feedback__r.CreatedBy.name, Case_Owner_Manager_Email__c from Case where ID in: WhatID];
        system.debug('====Accountname: '+Accountname);
        Fblist = [select id,name,CreatedBy.Name,Comments__c,CES_Score__c,FCR__c,No_of_Contacts_to_Resolve__c,  NPS_Recommend__c,NPS_Classification__c,Inquiry_closed__c,Ease_of_Contact_Availability__c,Knowledge_Technical_Expertise__c,Timeliness_of_response__c,Quality_and_Accuracy__c,Courtesy_and_Professionalism__c,Overall_satisfaction__c,Comments_Topic__c,Contact_requested__c,Owner_Site__c,Owner_Manager__c,Ownerid,Case__c,Case__r.id from Feedback__c where Case__c IN:Accountname limit 1];
        if(Accountname.size()>0 && Fblist.size()>0){
            for(Case a : Accountname){
                System.debug('test123'+a);
                sertaskmap.put(a.id,a);
                a.CSM_Feedback__c = Fblist[0].Id;
                system.debug('cccccc'+a.CSM_Feedback__c );
                clist.add(a);
                system.debug('Sublist.size() '+Sublist.size());
                if(a.Sales_Order_Number__c!=null && a.Sales_Order_Number__c!='')                    
                    SalesOrder = a.Sales_Order_Number__c;
                if(a.Subject !=null)                    
                    Subject = a.Subject ; 
                if(a.SBU__c !=null)                    
                    sbu = a.SBU__c ;
                if(a.CBT__c !=null)                    
                    cbt = a.CBT__c ;
                 if(a.CBT_Team__c !=null)                    
                    CBTteam = a.CBT_Team__c ;
                if(a.Description !=null)                    
                    Description = a.Description ; 
                if(a.ClosedDate  !=null)                    
                    ClosedDate = string.valueOf(a.ClosedDate) ; 
                if(a.of_Emails_Sent__c!=null)
                    EmailSent = string.valueOf(a.of_Emails_Sent__c);
              //  if(a.of_Emails_Sent_to_External_Customer__c!=null)
               //     EmailSentext = string.valueOf(a.of_Emails_Sent_to_External_Customer__c);    
                if(a.Primary_Work_Number__c!=null)    
                    ContactWork = a.Primary_Work_Number__c;
                if(a.Primary_Email_Address__c!=null)    
                    ContactEmail = a.Primary_Email_Address__c;                        
                if(a.of_Emails_Received__c!=null)
                    EmailReceived = string.valueOf(a.of_Emails_Received__c);
             //   if(a.of_Emails_Received_from_External_Custo__c!=null)
             //       EmailReceivedext = string.valueOf(a.of_Emails_Received_from_External_Custo__c);
                if(a.of_Holds__c!=null)
                    Holds =string.valueOf(a.of_Holds__c);
                if(a.Resolution__c!=null)
                    Resolution = a.Resolution__c;
                if(a.Notes__c!=null)
                    Notes= a.Notes__c;    
                if(a.Customer_Support_Focal__r.name!=null) 
                    CustFocal =a.Customer_Support_Focal__r.name; 
                if(a.Business_Focal__r.name!=null) 
                    BusFocal   =a.Business_Focal__r.name; 
                
                if(Fblist[0].CES_Score__c!=null)
                    ces= string.valueOf(Fblist[0].CES_Score__c); 
                if(Fblist[0].NPS_Recommend__c!=null)
                    NPSRecomm = string.valueOf(Fblist[0].NPS_Recommend__c);
                if(Fblist[0].NPS_Classification__c!=null)
                    NPSClass = Fblist[0].NPS_Classification__c;
                if(Fblist[0].Inquiry_closed__c!=null)
                    InquiryCls = Fblist[0].Inquiry_closed__c;
                if(Fblist[0].Ease_of_Contact_Availability__c!=null)
                    EaseofCon = string.valueOf(Fblist[0].Ease_of_Contact_Availability__c);
                if(Fblist[0].Knowledge_Technical_Expertise__c!=null)
                    AGentKnow = string.valueOf(Fblist[0].Knowledge_Technical_Expertise__c);
                if(Fblist[0].Timeliness_of_response__c!=null)
                    Timeliness = string.valueOf(Fblist[0].Timeliness_of_response__c);
                if(Fblist[0].Quality_and_Accuracy__c!=null)
                    Quality = string.valueOf(Fblist[0].Quality_and_Accuracy__c);
                if(Fblist[0].Courtesy_and_Professionalism__c!=null)
                    Agent = string.valueOf(Fblist[0].Courtesy_and_Professionalism__c);
                if(Fblist[0].Overall_satisfaction__c!=null)
                    OverallSatis = string.valueOf(Fblist[0].Overall_satisfaction__c);
                if(Fblist[0].Contact_requested__c!=null)
                    ContactReq = Fblist[0].Contact_requested__c;
                if(Fblist[0].Owner_Site__c!=null)
                    OwnerSite = Fblist[0].Owner_Site__c;
                if(Fblist[0].Owner_Manager__c!=null)
                    OwnerMan = Fblist[0].Owner_Manager__c;
                if(Fblist[0].Comments__c!=null)
                    Comments = Fblist[0].Comments__c;
                if(Fblist[0].Comments_Topic__c!=null)
                   CommentsTopic = Fblist[0].Comments_Topic__c;
                if(Fblist[0].No_of_Contacts_to_Resolve__c !=null)
                   NoOfContacts = Fblist[0].No_of_Contacts_to_Resolve__c ; 
                
                if(Sublist.size()>0){
                    System.debug('Inside task loop');
                    String serverUrl=URL.getSalesforceBaseUrl().toExternalForm() +'/'+Sublist[0].id;
                    htmlstring+='<a href="'+serverUrl+'"> Click Here</a>';
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();   
                    // Strings to hold the email addresses to which you are sending the email.
                    //String[] toAddresses = new String[] {usrmap.get(Sublist[0].OwnerID).Manager.Email}; 
                    String[] toAddresses = new String[] {usrmap.get(Sublist[0].OwnerID).Email}; 
                    system.debug('toAddresses'+toAddresses);
                    mail.setToAddresses(toAddresses);
                    // Specify the name used as the display name.
                    mail.setSenderDisplayName('No-Reply@Honeywell.com');
                    // Specify the subject line for your email address.
                    mail.setSubject('NSS Follow-up Required Notification');
                    // Set to True if you want to BCC yourself on the email.
                    mail.setBccSender(false);
                    mail.setUseSignature(false);
                    // Specify the text content of the email.
                    mail.setHtmlBody('Dear '+usrmap.get(Sublist[0].OwnerID).Name+',<br>         A customer has responded to an NSS Survey and has requested to be contacted.  Please see the information below to assist you in preparing to contact the customer.<br>             Case Number: '+a.CaseNumber+'<br>             Case Record Type: '+a.RecordType.name+'<br>             Case Origin: '+a.Origin+'<br>             Case Owner: '+a.Owner.Name+'<br>             Account SBU: '+a.SBU__c+'<br>             CBT: '+a.CBT__c+'<br>             CBT Team: '+a.CBT_Team__c+'<br>             Sales Order Number: '+SalesOrder+'<br>             Account Name: '+a.Account_Name__c+'<br>             Contact Name: '+a.contact_name__c +'<br>             Contact Primary Email Address: '+ContactEmail +'<br>             Contact Primary Work Number: '+ContactWork+'<br>             '+EmailSent+' - Email Sent<br>             '+EmailReceivedext +' - External Emails Received<br>             '+Holds+' - Holds<br>             Resolution: '+Resolution+'<br>             <br/>The Feedback Record is '+Fblist[0].name+'<br/>             The following are the details of the feedback record,<br/>             '+NPSRecomm+' - NPS Recommend<br/>             NPS Classification: '+NPSClass+'<br/>               Inquiry Closed: '+InquiryCls+'<br/>             '+EaseofCon+' - Ease of Contacting appropriate person<br/>             '+AGentKnow+' - Agent knowledge technical expertise<br/>             '+Timeliness+' - Timeliness of responses<br/>             '+Quality+' - Quality/accuracy of responses<br/>             '+Agent+' - Agent courtesy and professionalism<br/>             '+OverallSatis+' - Overall satisfaction with the outcome<br/>             Comments topic: '+CommentsTopic+'<br/>             Comments: '+Comments+'<br/>             Contact Requested: '+ContactReq+'<br/>             Owner Site: '+OwnerSite+'<br/>             Owner Manager: '+OwnerMan+'<br/>             Created By: '+Fblist[0].CreatedBy.name+'<br/>            ');
                    bulkEmails.add(mail);
                    //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
                }
                if(sertaskid.size()>0 && SERSublist.size()>0) 
                {
                 
                    if((a.RecordTypeId == Label.Order_RecordType || a.RecordTypeId == Label.QuotesRecordID || a.RecordTypeId == Label.Repair_Overhaul_RT_ID ||
                    a.RecordTypeId == Label.Case_Return_RecordType || a.RecordTypeId == Label.OEM_Quotes_Orders_ID || a.RecordTypeId == Label.D_S_Quotes_Orders_RT || a.RecordTypeId == Label.FSS_Accounts_RecordType_ID || a.RecordTypeId == Label.FssActivationCaseRecordTypeId || a.RecordTypeId == Label.FSS_Tech_Issue_RT_ID || a.RecordTypeId == Label.GDC_Accounts || a.RecordTypeId == Label.JXSupportRecType_ID || a.RecordTypeId == Label.HAPP_Accts || a.RecordTypeId == Label.MSP_Contract || a.RecordTypeId == Label.NavDB_Accts_RecordID || a.RecordTypeId == Label.TechPubs_RecordType_ID) &&
                    (Fblist[0].FCR__c != null && Fblist[0].FCR__c > 1) || (Fblist[0].Overall_satisfaction__c <= 2 || Fblist[0].CES_Score__c <6 || Fblist[0].NPS_Recommend__c <6 || Fblist[0].Ease_of_Contact_Availability__c < 6 || Fblist[0].Knowledge_Technical_Expertise__c < 6 || Fblist[0].Timeliness_of_response__c < 6 || Fblist[0].Quality_and_Accuracy__c < 6 || Fblist[0].Courtesy_and_Professionalism__c < 6))
                 
                            {            
                                
                                //String eMailSubject='NSS Detractor Follow up - '+a.Account_name__c+' - '+a.casenumber ;
                                String eMailSubject='CSAT Detractor Follow up - '+a.Account_name__c+' - '+a.casenumber ;
                                String eMailBody='<!DOCTYPE html><body><table border="0" cellpadding="0" cellspacing="0" width="950" style="position: absolute;right: 50px;"><tr><td align="center" height="45" valign="top"><img src=https://c.cs23.content.force.com/servlet/servlet.ImageServer?id=015300000018fo4&oid=00D30000000dWxY" alt="Logo" style="border:none;display:block;right: 20px;position: absolute;top: 10px;height: 30px;"/></td></tr><br/></table><table border="0" cellpadding="5" cellspacing="0" width="600" style="position: absolute;right: 50px;border-top-width: 4px;border-top-style: solid;border-top-color: #ED2028;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #ED2028;"><tr><td align="right" valign="top"><table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td align="left" height="60" style="font-family:Times New Roman;font-size:16px;padding-left: 24px;" valign="middle">';
                                //eMailBody = eMailBody +' You have been assigned '+'<a href = "'+link+''+SERSublist[0].id+'">'+ SERSublist[0].activity_number__c +'</a>'+ ' because '+a.contact_name__c +' from '+a.Account_name__c+' has responded to an NSS survey with a score of 6 or less on one or more questions.<br/><br/> '+'<a href = "'+link+''+a.id+'">'+a.casenumber +'</a>'+' '+subject+' is owned by '+a.owner.name+'.<br/><br/>Please take the appropriate action and then close this activity.  Be sure to document the action taken in the Resolution field of the activity. The following are the details of the given case details, <br>             Case Open: '+a.CreatedDate+'<br>             Case Closed: '+ClosedDate+'<br>             Case Record Type: '+a.RecordType.name+'<br>             Case Origin: '+a.Origin+'<br>             Case Owner: '+a.Owner.Name+'<br>             Account SBU: '+a.SBU__c+'<br>             CBT: '+a.CBT__c+'<br>             CBT Team: '+a.CBT_Team__c+'<br>             Customer Support Focal: '+CustFocal+'<br>             Business Focal: '+BusFocal+'<br>             Sales Order Number: '+SalesOrder+'<br>             Account Name: '+a.Account_Name__c+'<br>             Contact Name: '+a.contact_name__c +'<br>             Contact Primary Email Address: '+ContactEmail+'<br>             Contact Primary Work Number: '+ContactWork+'<br>              '+EmailSent+' - Email Sent<br>             '+EmailReceived+' - Email Received<br>             '+EmailSentext+' - External Emails Sent<br>             '+EmailReceivedext +' - External Emails Received<br>             '+Holds+' - Holds<br>             Resolution: '+Resolution+'<br>             Notes: '+Notes+'<br>             <br/><br/>The Feedback Record is ' +'<a href = "'+link+''+Fblist[0].id+'">'+Fblist[0].name +'</a>' +'<br/>'             +ces+' - CES <br/>             '+NoOfContacts+' - Number of contacts to resolve<br/>             '+NPSRecomm+' - NPS Recommend<br/>             NPS Classification: '+NPSClass+'<br/>             Inquiry Closed: '+InquiryCls+'<br/>             '+EaseofCon+' - Ease of Contacting appropriate person<br/>             '+AGentKnow+' - Agent knowledge technical expertise<br/>             '+Timeliness+' - Timeliness of responses<br/>             '+Quality+' - Quality/accuracy of responses<br/>             '+Agent+' - Agent courtesy and professionalism<br/>             '+OverallSatis+' - Overall satisfaction with the outcome<br/>             Comments topic: '+CommentsTopic+'<br/>             Comments: '+Comments+'<br/>             Contact Requested: '+ContactReq+'<br/>             Owner Site: '+OwnerSite+'<br/>             Owner Manager: '+OwnerMan+'<br/>             Created By: '+Fblist[0].CreatedBy.name+'<br/>              <br/>              <br/>              Description: '+Description+'<br/>              <br/>              <br/>              <br/><br/>Thank you';
                                eMailBody = eMailBody +' You have been assigned '+'<a href = "'+link+''+SERSublist[0].id+'">'+ SERSublist[0].activity_number__c +'</a>'+ ' because '+a.contact_name__c +' from '+a.Account_name__c+' has responded to a survey with a dissatisfaction rating on one or more questions.<br/><br/> '+'<a href = "'+link+''+a.id+'">'+a.casenumber +'</a>'+' '+subject+' is owned by '+a.owner.name+'.<br/><br/>Please take the appropriate action and then close this activity.  Be sure to document the action taken in the Resolution field of the activity. The following are the details of the given case details, <br>             Case Open: '+a.CreatedDate+'<br>             Case Closed: '+ClosedDate+'<br>             Case Record Type: '+a.RecordType.name+'<br>             Case Origin: '+a.Origin+'<br>             Case Owner: '+a.Owner.Name+'<br>             Account SBU: '+a.SBU__c+'<br>             CBT: '+a.CBT__c+'<br>             CBT Team: '+a.CBT_Team__c+'<br>             Customer Support Focal: '+CustFocal+'<br>             Business Focal: '+BusFocal+'<br>             Sales Order Number: '+SalesOrder+'<br>             Account Name: '+a.Account_Name__c+'<br>             Contact Name: '+a.contact_name__c +'<br>             Contact Primary Email Address: '+ContactEmail+'<br>             Contact Primary Work Number: '+ContactWork+'<br>' +Holds+' - Holds<br>             Resolution: '+Resolution+'<br>             Notes: '+Notes+'<br>             <br/><br/>The Feedback Record is ' +'<a href = "'+link+''+Fblist[0].id+'">'+Fblist[0].name +'</a>' +'<br/>'             +ces+' - CES <br/>             '+NoOfContacts+' - Number of contacts to resolve<br/>             '+NPSRecomm+' - NPS Recommend<br/>             NPS Classification: '+NPSClass+'<br/>             Inquiry Closed: '+InquiryCls+'<br/> '+OverallSatis+' - Overall satisfaction with the outcome<br/>             Comments topic: '+CommentsTopic+'<br/>             Comments: '+Comments+'<br/>             Contact Requested: '+ContactReq+'<br/>             Owner Site: '+OwnerSite+'<br/>             Owner Manager: '+OwnerMan+'<br/>             Created By: '+Fblist[0].CreatedBy.name+'<br/>              <br/>              <br/>              Description: '+Description+'<br/>              <br/>              <br/>              <br/><br/>Thank you';
                                eMailBody = eMailBody + '</td></tr></table></td></tr></table><br/><br/><table border="0" cellpadding="5" cellspacing="0" width="600" style="position: absolute;right: 50px;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #ED2028;"/></body></html>';
                                String[] toadd = new String[]{};
                                String[] ccadd = new String[]{};                       
                                // Added by: NTT DATA, CSO Bundle Project ticket - NSS Detector.
                                
                                if(a.SBU__c =='ATR' || a.SBU__c =='BGA'){                  
                                    //toadd.add(nssOwnerMap.get('ATR').owneremail__c);
                                    
                                    System.Debug('Case owner/To Addresses: ' + toadd);
                                    //To Address has been changed for INC0002574948 
                                    toadd.add(a.Case_Owner_Manager_Email__c);
                                }
                                else if(a.SBU__c =='D&S'){                  
                                    //toadd.add(nssOwnerMap.get('D&S').owneremail__c);
                                    System.Debug('Case owner/To Addresses: ' + toadd);
                                     //To Address has been changed for INC0002574948 
                                        toadd.add(a.Case_Owner_Manager_Email__c);
                                }
                                else{
                                    //toadd.add(usrmap.get(SERSublist[0].OwnerID).Email);
                                    System.Debug('Case owner/To Addresses: ' + toadd);
                                     //To Address has been changed for INC0002574948 
                                        toadd.add(a.Case_Owner_Manager_Email__c);
                                }
                                
                                if(users.size()>0){
                                        for(User u : users)
                                            ccadd.add(u.email);
                                        System.Debug('CC Addresses: ' + ccadd);
                                    } 
                                                              
                                /*ccadd.add(nssOwnerMap.get('CCList').owneremail__c); 
                                ccadd.add(nssOwnerMap.get('CCListNew').owneremail__c); /**** Added by siva regarding SCTASK1703963 ****/
                                
                                //Below 3 lines added for SCTASK1855781
                                /*ccadd.add(nssOwnerMap.get('CCListNew2').owneremail__c); 
                                ccadd.add(nssOwnerMap.get('CCListNew3').owneremail__c); 
                                ccadd.add(nssOwnerMap.get('CCListNew4').owneremail__c); */
                                
                                if(a.Customer_Support_Focal__r.Primary_Email_Address__c!=null) {
                                    ccadd.add(a.Customer_Support_Focal__r.Primary_Email_Address__c);
                                }     
                                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();                        
                                message.setUseSignature(false);
                                message.setSaveAsActivity(false);
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                                if(toadd.size()>0){ 
                                    message.setToAddresses(toadd);
                                    message.setCcAddresses(ccadd );
                                    message.setHtmlBody(eMailBody);
                                    message.setSubject(eMailSubject);
                                    bulkEmails.add(message);
                                }     
                       } 
                }
            }
        }
    } 
    if(!(Test.isRunningTest()) )
    {   
        if( bulkEmails.size() >0){
            Messaging.reserveSingleEmailCapacity(trigger.size);
            Messaging.sendEmail(bulkEmails); 
        }
    }
}