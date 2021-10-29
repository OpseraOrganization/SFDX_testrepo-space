/*******************************************************************************
Name         : SendeMailToADVNCustomersBatch
Created By   : Ravi Bodepalli
Company Name : NTT Data
Created Date : 2 Feb 2019
Usages       : This Class is used for sending an ADVN email notification to customers.
*******************************************************************************/

global class SendeMailToADVNCustomersBatch implements Database.Batchable<SObject>
{
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        system.debug('Started!..'); 
        String query = 'Select id,Name__c, Task_Activities__c,Task_Activities__r.Type__c,Case__c,Case__r.CaseOwnerChanged__c,Case__r.Requestor_Email__c,Case__r.RecordType.Name,Case__r.origin,Case__r.Customer_PO_RO_WONumber__c,Case__r.Contact.Primary_Email_Address__c,Case__r.Product_Serial_Number__c,Case__r.Part_Number__c,Case__r.Primary_Email_Address__c,Status__c from Activitiy_Line_Item__c where Status__c=\'Open\' AND Task_Activities__c != null AND Name__c= \'WADV\' AND Task_Activities__r.Status__c = \'Open\' AND Task_Activities__r.Type__c=\'Z146 Cust Follow Up Required - GAT0\' AND Case__r.origin = \'SAP Interface\' AND Case__r.RecordType.Name = \'Repair & Overhaul\'';
        system.debug('Query====>'+query);  
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Activitiy_Line_Item__c> aliList)
    {        
        String emSub,emHtmlbody,EmailSendStatus,hwLogo;
        List<EmailTemplate> emTemp = new List<EmailTemplate>();
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();         
        List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
        Set<Id> csIds = new Set<Id>();        
        List<String> toAddresses = new List<String>();
       
        List<Case> onHoldCasList = new List<Case> ();
        Map<Id,List<String>> ccAddrmap = new Map<Id,List<String>>();
        Map<Id,List<String>> toAddrmap = new Map<Id,List<String>>();
        
        for(Activitiy_Line_Item__c ali : aliList){
            if(ali.case__c != null )
               csIds.add(ali.case__c);
        }       
         
        emTemp = [Select Id,Name,HTMLValue,Subject,Body from EmailTemplate where Name =: 'Repair & Overhaul ADVN Notification' Limit 1];
        
         List<case> csList = [select Id,Status,Customer_PO_RO_WONumber__c,Product_Number__c,Product_Number__r.Name, Part_Number__c,Product_Serial_Number__c,Requestor_Email__c,CaseOwnerChanged__c,Contact.Primary_Email_Address__c from case where Id IN: csIds]; 
         system.debug('csIds====='+csIds);
        if(!csList.isEmpty())
        {
            for(case cas : csList ) {
                if(cas.Requestor_Email__c != null)
                {
                  List<String> toAddr = new List<String> ();
                    toAddr.add(cas.Requestor_Email__c);
                    toAddrmap.put(cas.Id,toAddr);                                                    
                } 
                if(cas.CaseOwnerChanged__c != null)
                { 
                    if(cas.CaseOwnerChanged__c.contains(';')){
                         List<String> ccaddSet = cas.CaseOwnerChanged__c.split(';');                 
                         ccAddrmap.put(cas.Id,ccaddSet);
                    }
                    else{
                       List<String> ccaddSet = new  List<String> ();
                       ccaddSet.add(cas.CaseOwnerChanged__c );
                       ccAddrmap.put(cas.Id,ccaddSet);
                    }                    
                }
                if(cas.Requestor_Email__c == null && cas.CaseOwnerChanged__c == null )
                {                    
                    cas.Status = 'On Hold – Response Received';
                    onHoldCasList.add(cas);
                }
            }
            
            for(case cs : csList)
            {      
                if(!emTemp.isEmpty())
                {                
                    hwLogo = Label.RDF_Honeywell_Logo;
                    emSub = emTemp[0].Subject;              
                    emHtmlbody = '<!DOCTYPE html><body><style>p{margin-top:0px; margin-bottom:0px;}</style><body  style=" background-color:#FFFFFF; bEditID:b1st1; bLabel:body;"><center ><table cellpadding="0" width="500" cellspacing="0" id="topTable" height="450" ><tr valign="top" ><td  style=" background-color:#FFFFFF; bEditID:r1st1; bLabel:header; vertical-align:top; height:60; text-align:right;"><img border="0" bEditID="r1sp1" bLabel="headerImage" id="r1sp1" src="'+hwLogo+'">'+'</img></td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r2st1; bLabel:accent1; height:5;"></td></tr><tr valign="top" ><td styleInsert="1" height="300"  style=" background-color:#FFFFFF; color:#000000; bEditID:r3st1; bLabel:main; font-size:12pt; font-family:arial;">'+emTemp[0].HTMLValue+'</td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r4st1; bLabel:accent2; height:5;"></td></tr><tr valign="top" ><td  style=" background-color:#FFFFFF; bEditID:r5st1; bLabel:footer; vertical-align:top; height:60; text-align:left;"></td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r6st1; bLabel:accent3; height:5;"></td></tr></table></center><br><br></body></html>';
                    emHtmlbody = emHtmlbody.replace('<![CDATA[','');
                    emHtmlbody = emHtmlbody.replace(']]>',''); 
                                 
                        if(cs.Customer_PO_RO_WONumber__c != null)
                           emHtmlbody = emHtmlbody.replace('{!Case.Customer_PO_RO_WONumber__c}',cs.Customer_PO_RO_WONumber__c);
                        else
                            emHtmlbody = emHtmlbody.replace('{!Case.Customer_PO_RO_WONumber__c}','');
                        if(cs.Product_Number__c != null)
                            emHtmlbody = emHtmlbody.replace('{!Case.Product_Number__c}',cs.Product_Number__r.Name);
                        else
                            emHtmlbody = emHtmlbody.replace('{!Case.Product_Number__c}','');
                        if(cs.Product_Serial_Number__c != null)
                            emHtmlbody = emHtmlbody.replace('{!Case.Product_Serial_Number__c}',cs.Product_Serial_Number__c);
                        else
                            emHtmlbody = emHtmlbody.replace('{!Case.Product_Serial_Number__c}','');  
                
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setSubject(emSub);
                    mail.setHTMLBody(emHtmlbody);
                    mail.setOrgWideEmailAddressId(Label.Aero_Repairs_Org_ID);
                    if((!toAddrmap.isEmpty() && toAddrmap.containsKey(cs.Id)) && (!ccAddrmap.isEmpty() &&  ccAddrmap.containsKey(cs.Id)))
                    {
                        mail.setToAddresses(toAddrmap.get(cs.Id));                      
                        bulkEmails.add(mail);
                    }
                    else if(!toAddrmap.isEmpty() && toAddrmap.containsKey(cs.Id))
                    {
                        mail.setToAddresses(toAddrmap.get(cs.Id));  
                        bulkEmails.add(mail);
                    }
                    else if(!ccAddrmap.isEmpty() && ccAddrmap.containsKey(cs.Id))
                    {
                        if(cs.CaseOwnerChanged__c.contains(';')) {
                            List<String> ccaddSet = cs.CaseOwnerChanged__c.split(';');
                            mail.setToAddresses(ccaddSet);
                        }else 
                            mail.setToAddresses(ccAddrmap.get(cs.Id));
                        bulkEmails.add(mail);
                    }else
                    {
                        continue;
                    }
                    EmailSendStatus = 'EMail to Send!';
                    system.debug('ccAddresses ====>'+ccAddrmap );
                    system.debug('toAddresses ====>'+toAddrmap);
                    
                }
                else
                {
                   EmailSendStatus = 'No EMail to Send!';
                }                
            }  
        }
              
        if(bulkEmails.size()>0){
            try{
                Messaging.sendEmail(bulkEmails);
                EmailSendStatus = 'Email Sent Successfully!';                        
            }
            catch(exception ex)
            {
                System.debug('Exception in sending mail SendeMailToADVNCustomersBatch ' +ex);
                EmailSendStatus = 'Email Sending Failed with error '+ex.getMessage();
            }
        } 
        if(!onHoldCasList.isEmpty())
        {
             try{
                 update onHoldCasList;                
             }
             catch(DMLException emailex){                
                 system.debug('Email Message Insert----->'+emailex.getMessage());
             }
         }
                
        if(EmailSendStatus != null && EmailSendStatus == 'Email Sent Successfully!' && !csList.isEmpty())
        {              
            for(Case cs : csList)
            {                                 
               if(!emTemp.isEmpty())
                {                
                    hwLogo = Label.RDF_Honeywell_Logo;
                    emSub = emTemp[0].Subject;              
                    emHtmlbody = '<!DOCTYPE html><body><style>p{margin-top:0px; margin-bottom:0px;}</style><body  style=" background-color:#FFFFFF; bEditID:b1st1; bLabel:body;"><center ><table cellpadding="0" width="500" cellspacing="0" id="topTable" height="450" ><tr valign="top" ><td  style=" background-color:#FFFFFF; bEditID:r1st1; bLabel:header; vertical-align:top; height:60; text-align:right;"><img border="0" bEditID="r1sp1" bLabel="headerImage" id="r1sp1" src="'+hwLogo+'">'+'</img></td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r2st1; bLabel:accent1; height:5;"></td></tr><tr valign="top" ><td styleInsert="1" height="300"  style=" background-color:#FFFFFF; color:#000000; bEditID:r3st1; bLabel:main; font-size:12pt; font-family:arial;">'+emTemp[0].HTMLValue+'</td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r4st1; bLabel:accent2; height:5;"></td></tr><tr valign="top" ><td  style=" background-color:#FFFFFF; bEditID:r5st1; bLabel:footer; vertical-align:top; height:60; text-align:left;"></td></tr><tr valign="top" ><td  style=" background-color:#FF0000; bEditID:r6st1; bLabel:accent3; height:5;"></td></tr></table></center><br><br></body></html>';
                    emHtmlbody = emHtmlbody.replace('<![CDATA[','');
                    emHtmlbody = emHtmlbody.replace(']]>',''); 
                                 
                        if(cs.Customer_PO_RO_WONumber__c != null)
                           emHtmlbody = emHtmlbody.replace('{!Case.Customer_PO_RO_WONumber__c}',cs.Customer_PO_RO_WONumber__c);
                        else
                            emHtmlbody = emHtmlbody.replace('{!Case.Customer_PO_RO_WONumber__c}','');
                        if(cs.Product_Number__c!= null)
                            emHtmlbody = emHtmlbody.replace('{!Case.Product_Number__c}',cs.Product_Number__r.Name);
                        else
                            emHtmlbody = emHtmlbody.replace('{!Case.Product_Number__c}','');
                        if(cs.Product_Serial_Number__c != null)
                            emHtmlbody = emHtmlbody.replace('{!Case.Product_Serial_Number__c}',cs.Product_Serial_Number__c);
                        else
                            emHtmlbody = emHtmlbody.replace('{!Case.Product_Serial_Number__c}','');
              
                    EmailMessage emailToCase = new EmailMessage();                   
                    emailToCase.Incoming = false;
                    emailToCase.MessageDate = system.now();                    
                    emailToCase.FromName = 'Aero Repairs';
                    emailToCase.ParentId = cs.id;
                    emailToCase.Status = '3';                  
                    emailToCase.subject =emSub;
                    if(emHtmlbody != null && emHtmlbody.length() >0 )
                    { 
                       emailToCase.HtmlBody = emHtmlbody;
                    }
                    /*if(cs.Requestor_Email__c != null){
                       emailToCase.FromAddress = cs.Requestor_Email__c;
                    }else{
                       emailToCase.FromAddress ='noreply@salesforce.com';
                    }*/
                    emailToCase.FromAddress =label.RDF_AeroRepairsEmailAddress;
                    if(cs.CaseOwnerChanged__c != null && cs.Requestor_Email__c != null){
                        system.debug('Email ---toadd only ----------->');
                        emailToCase.ToAddress = cs.Requestor_Email__c;                        
                    }
                    else if(cs.CaseOwnerChanged__c != null && cs.Requestor_Email__c == null)
                    {
                        system.debug('Email ---toadd and no ccaddress----------->');
                        emailToCase.ToAddress = cs.CaseOwnerChanged__c;
                    }
                    else if(cs.CaseOwnerChanged__c == null && cs.Requestor_Email__c != null)
                    {
                        system.debug('Email ---no toadd and ccaddress----------->');
                        emailToCase.ToAddress = cs.Requestor_Email__c;
                    }else
                    {
                        continue;
                    }
                    
                    listInsertEmailMessage.add(emailToCase);
                 }
            }
            
            if(listInsertEmailMessage.size() >0 )
            {
                try{
                    insert listInsertEmailMessage;                
                }
                Catch(DMLException emailex)
                {
                    system.debug('Email Message Insert----->'+emailex.getMessage());
                }
            }     
        }
    }    
    global void finish(Database.BatchableContext bc){ 
      system.debug('Finished !..');      
    } 
}