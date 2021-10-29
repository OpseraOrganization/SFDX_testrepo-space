/*******************************************************************************
Name            :   ACSM_SeverityRemainderEmails
Created By      :   Harikishore V
Company Name    :   NTTData
Project         :   Aircraft Connectivity 
Created Date    :   28-October-2015
Usages          :   Batch class to get the Severity1 FSS cases to send remainder email to Case owners for every 2 hours.
*******************************************************************************/
global class ACSM_SeverityRemainderEmails implements Database.batchable<sObject>, Schedulable{
    global string query;
    global ACSM_SeverityRemainderEmails (){
        //Query to fetch cases of FSS Tech Issue records
        query = 'Select id,ownerid,Owner.Name,Notes__c,Owner.Email,CaseNumber,Contact.Name,Account.Name,Primary_Cell_Number__c,Primary_Work_Number__c,CreatedDate,Lastmodifieddate,Priority,Case_Ref_ID__c,Recordtypeid,Status from Case where Case_Record_Type__c=\'FSS Technical Issue\' and Priority=\'Severity 1\' and IsClosed=False and Status!=\'Closed\'';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);     
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Case> listSev1Cases = new List<Case>();
        List<Messaging.SingleEmailMessage> ACSMSev1bulkEmails = new List<Messaging.SingleEMailMessage>();
        List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
        system.debug('----> scope' + scope);
        String body,sub;
        EmailTemplate em = [Select id,Name,HTMLValue,Subject,Body from EmailTemplate where id=:label.ACSM_Severity_1_Notification_Temp_ID];
        for(sObject caseRec : scope)
        {   
            case cas = (case)caseRec;
            if(string.valueof(cas.Ownerid).startswith('005')){
                if(cas.Priority == 'Severity 1')
                    listSev1Cases.add(cas);
            }
        }
        system.debug('---->Sev1Cases :'+listSev1Cases);
        for(Case c:listSev1Cases){
            system.debug('====> '+c.CreatedDate);
            Datetime cdt=system.now();
            integer b = Integer.valueOf((cdt.getTime() - c.CreatedDate.getTime())/ (1000*60*60));
            system.debug('=====>b: '+b);
            Integer x,y;
            x=b/2;
            y=x*2;
            if(y==b){
                sub = em.Subject;
                sub = sub.replace('{!Case.CaseNumber}' ,c.CaseNumber);
                sub = sub.replace('{!Case.Case_Ref_ID__c}',c.Case_Ref_ID__c);
                System.debug('----> SUBJECT: '+sub);
                body = '<!DOCTYPE html><body><style>p{margin-top:0px; margin-bottom:0px;}</style><body  style=" background-color:#FFFFFF; bEditID:b1st1; bLabel:body;"><center ><table cellpadding="0" width="500" cellspacing="0" id="topTable" height="450" ><tr valign="top" ><td  style=" background-color:#FFFFFF; bEditID:r1st1; bLabel:header; vertical-align:top; height:60; text-align:right;"><img border="0" bEditID="r1sp1" bLabel="headerImage" id="r1sp1" src="https://c.na1.content.force.com/servlet/servlet.ImageServer?id=015300000018fo4&oid=00D30000000dWxY" ></img></td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r2st1; bLabel:accent1; height:5;"></td></tr><tr valign="top" ><td styleInsert="1" height="300"  style=" background-color:#FFFFFF; color:#000000; bEditID:r3st1; bLabel:main; font-size:12pt; font-family:arial;">'+em.HTMLValue+'</td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r4st1; bLabel:accent2; height:5;"></td></tr><tr valign="top" ><td  style=" background-color:#FFFFFF; bEditID:r5st1; bLabel:footer; vertical-align:top; height:60; text-align:left;"></td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r6st1; bLabel:accent3; height:5;"></td></tr></table></center><br><br></body></html>';
                body = body.replace('<![CDATA[','');
                body = body.replace(']]>','');
                body = body.replace('{!Case.OwnerFullName}',c.Owner.Name);
                body = body.replace('{!Case.CaseNumber}' ,c.CaseNumber);
                body = body.replace('{!Case.Case_Ref_ID__c}',c.Case_Ref_ID__c);
                body = body.replace('{!Case.CreatedDate}',string.valueOf(Date.valueOf(c.CreatedDate)));
                body = body.replace('{!Case.Priority}',c.Priority);
                if(c.Contact.Name!=null)
                    body = body.replace('{!Case.Contact}',c.Contact.Name);
                else
                    body = body.replace('{!Case.Contact}','');
                if(c.Primary_Work_Number__c!=null)
                    body = body.replace('{!Case.Primary_Work_Number__c}',c.Primary_Work_Number__c);
                else
                    body = body.replace('{!Case.Primary_Work_Number__c}','');
                if(c.Primary_Cell_Number__c!=null)
                    body = body.replace('{!Case.Primary_Cell_Number__c}',c.Primary_Cell_Number__c);
                else
                    body = body.replace('{!Case.Primary_Cell_Number__c}','');
                if(c.Account.Name!=null)
                    body = body.replace('{!Case.Account}',c.Account.Name);
                else
                    body = body.replace('{!Case.Account}','');
                if(c.Notes__c!=null)
                    body = body.replace('{!Case.Notes__c}',c.Notes__c);
                else
                    body = body.replace('{!Case.Notes__c}','');
                system.debug('--->Body: '+body);
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                msg.setsaveAsActivity(false);
                msg.setOrgWideEmailAddressId(label.ACSM_FSS_Tech_Support_ORG_ID);
                msg.setSubject(sub);
                msg.setHTMLBody(body);
                msg.setTargetObjectId(c.Ownerid);
                ACSMSev1bulkEmails.add(msg);
                if(ACSMSev1bulkEmails.size()>0){
                    EmailMessage emailToCase = new EmailMessage();
                    emailToCase.Incoming = false;
                    emailToCase.Subject = sub;
                    emailToCase.MessageDate = system.now();
                    emailToCase.ParentId = c.Id;
                    emailToCase.FromAddress = Label.ACSM_FSS_Tech_Support_Email;
                    emailToCase.FromName = 'Aero FSS Tech Support';
                    emailToCase.ToAddress = c.Owner.Email;
                    if(body!=null && body.length()>0 ){
                        if(body.length()<32000)
                            emailToCase.HtmlBody =  body.substring(0,body.length());
                        else
                            emailToCase.HtmlBody =  body.substring(0,32000);
                    }
                    listInsertEmailMessage.add(emailToCase);
                }
            }
        }
        if(ACSMSev1bulkEmails.size()>0){
            Messaging.sendEmail(ACSMSev1bulkEmails);
        }
        if(listInsertEmailMessage.size()>0){
            insert listInsertEmailMessage;
        }
    }
    
    global void finish(Database.BatchableContext BC){} 
    
    global void execute(SchedulableContext sc){
        ACSM_SeverityRemainderEmails ordersBatch = new ACSM_SeverityRemainderEmails();
        database.executeBatch(ordersBatch,200);
    }
}