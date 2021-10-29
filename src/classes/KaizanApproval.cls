public with sharing class KaizanApproval
{
    public string message {get;set;}
    public Aero_China_Kaizen__c item {get;set;}    
    public KaizanApproval(ApexPages.StandardController controller) {
        //item = (Aero_China_Kaizen__c )controller.getRecord();
    }
    public void PageLoad()   
    {
        String task = ApexPages.currentPage().getParameters().get('Action');
        String itemId = ApexPages.currentPage().getParameters().get('id');        
        if(task != null && itemId != null)
        {
            item = [select id,ownerid,Kaizen_Level__c,name,Action_Owner__r.Name,CreatedBy.Name,dept__c,requester__c,LastModifiedBy.Name from Aero_China_Kaizen__c where id =:itemId];
            if(task =='Submit')
            {
                           
                //item.recordTypeId = Schema.SObjectType.Aero_China_Kaizen__c.getRecordTypeInfosByName().get('Approved').getRecordTypeId();
                item.Kaizen_Level__c = 2;
                update item;
                message = 'Request Sent for Approval.';
                List<Kaizen_Users__c > users = [select email__C from Kaizen_Users__c where User_Role__c includes ('Supervisor') and Department__c =:item.dept__c ];
                string[] toEmails = new List<String>();
                for(Kaizen_users__C u: users)
                {
                    toEmails.add(u.email__c);                
                }
                string ccEMail = [select email__C from Kaizen_Users__c where  id =:item.Action_Owner__c].email__c;
                if(toEmails.size() == 0)
                {
                    message = 'No Owner set for this department. Contact Admin.';                
                } 
                else
                {
                    Messaging.SingleEMailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(toEmails);
                    mail.setCCAddresses(new List<string>{ccEmail});
                    mail.setSaveAsActivity(false);                    
                    //mail.setTargetObjectId(item.OwnerId);
                    mail.setSenderDisplayName('Salesforce Internal');
                    //EmailTemplate et = [select id from emailtemplate where developername='Kaizen_Submitted_for_Review'];                        
                    //mail.setTemplateId(et.id);
                    mail.setSubject('New Kaizen: '+item.Name);
                    mail.setHtmlBody('Hi,<br/><br/>New Kaizen: <b>'+item.Name+'</b> has submitted by '+item.CreatedBy.Name+'<br/><br/>');
                    mail.setHtmlBody(mail.getHtmlBody()+'Review and Approve be clicking below link.<br/>');
                    mail.setHtmlBody(mail.getHtmlBody()+'https://'+ApexPages.currentPage().getHeaders().get('Host')+'/'+item.id+'.<br/><br/>');
                    mail.setHtmlBody(mail.getHtmlBody()+'Regards.<br/>Internal Team');
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
                    message = 'Request Sent for Approval to these people:'+toEmails;         
                }          
            }   
            else if(task == 'Approve')
            {
                boolean isApproved = false;
                string ccEMail = [select email__C from Kaizen_Users__c where  id =:item.Action_Owner__c].email__c;
                if(item.Kaizen_Level__c == 2)
                {
                    List<Kaizen_Users__c > users = [select email__C from Kaizen_Users__c where User_Role__c includes ('Leader') and Department__c =:item.dept__c ];
                    string[] toEmails = new List<String>();
                    for(Kaizen_users__C u: users)
                    {
                        toEmails.add(u.email__c);                
                    }
                    
                    if(toEmails.size() != 0)
                    {
                        Messaging.SingleEMailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setToAddresses(toEmails);
                        mail.setCCAddresses(new List<string>{ccEmail});
                        mail.setSaveAsActivity(false);                    
                        mail.setSenderDisplayName('Salesforce Internal');
                        mail.setSubject('New Kaizen: '+item.Name);
                        mail.setHtmlBody('Hi,<br/><br/>Leader Approval Required Kaizen:<b>'+item.Name+'</b> has been approved by '+item.LastModifiedBy.Name+'<br/><br/>');
                        mail.setHtmlBody(mail.getHtmlBody()+'Review and Approve be clicking below link.<br/>');
                        mail.setHtmlBody(mail.getHtmlBody()+'https://'+ApexPages.currentPage().getHeaders().get('Host')+'/'+item.id+'.<br/><br/>');
                        mail.setHtmlBody(mail.getHtmlBody()+'Regards.<br/>Internal Team');
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});              
                    }
                    else
                    {
                        isApproved = true;
                    }
                }
                else if(item.Kaizen_Level__c == 3 || isApproved)
                {
                    Messaging.SingleEMailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new List<string>{ccEmail});
                    mail.setSaveAsActivity(false);                    
                    mail.setSenderDisplayName('Salesforce Internal');
                    mail.setSubject('Kaizen Approved: '+item.Name);
                    mail.setHtmlBody('Hi,<br/><br/>Kaizen Approved:<b>'+item.Name+'</b> has been approved by '+item.LastModifiedBy.Name+'<br/><br/>');
                    mail.setHtmlBody(mail.getHtmlBody()+'Use below link to access the details.<br/>');
                    mail.setHtmlBody(mail.getHtmlBody()+'https://'+ApexPages.currentPage().getHeaders().get('Host')+'/'+item.id+'.<br/><br/>');
                    mail.setHtmlBody(mail.getHtmlBody()+'Regards.<br/>Internal Team');
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
                }
                item.Kaizen_Level__c = item.Kaizen_Level__c +1;
                update item;
                
                message = 'Item Approved.';
            }  
            else if(task == 'Reject')
            {
                item.Kaizen_Level__c = 1;
                update item;
                message = 'Item Rejected.';
                string toEMail = [select email__C from Kaizen_Users__c where  id =:item.requester__c ].email__c;
                Messaging.SingleEMailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<string>{toEmail});
                mail.setSaveAsActivity(false);                    
                mail.setSenderDisplayName('Salesforce Internal');
                mail.setSubject('Kaizen Rejected: '+item.Name);
                mail.setHtmlBody('Hi,<br/><br/>Kaizen Rejected:<b>'+item.Name+'</b> has been rejected by '+item.LastModifiedBy.Name+'<br/><br/>');
                mail.setHtmlBody(mail.getHtmlBody()+'Use below link to access the details.<br/>');
                mail.setHtmlBody(mail.getHtmlBody()+'https://'+ApexPages.currentPage().getHeaders().get('Host')+'/'+item.id+'.<br/><br/>');
                mail.setHtmlBody(mail.getHtmlBody()+'Regards.<br/>Internal Team');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
            }
        } 
        else 
        {
            message = 'Invalid Action or Page. Please Contact Admin';   
           
        }       
    }
}