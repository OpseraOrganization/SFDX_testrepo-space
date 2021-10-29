/*********************************************************************************
Name : RDF_EmailAttachmentSeriviceHandler 
Company Name : NTT Data
Project : RDF
Created Date  : 17/09/2018
Modified Date : 17/09/2018
Usages : This class is email service handdler for RDF_EmailAttachment
*********************************************************************************/

global class RDF_EmailAttachmentSeriviceHandler implements Messaging.InboundEmailHandler{
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env)
    {
        
        // Create an InboundEmailResult object for returning the result of the 
        // Apex Email Service
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        Boolean hasAttachment = false;
        String myPlainText= '';
        
        // Add the email plain text into the local variable 
        myPlainText = email.plainTextBody;
        String sub = email.subject ;
        //   system.debug(':::::myPlainText::::::::'+myPlainText);
        String[] bodySplitted;
        if(email.PlainTextBody != null)
        {
           bodySplitted  = email.PlainTextBody.split('\n');
        }
        
        
        System.debug('@@@@@attachementDuplicateSet'+sub);
        try {
            String aribaId;
            if(sub != null)
            {
                aribaId = sub.substringBetween('[ref:', ']');
                System.debug('@@@@@aribaId '+aribaId );
                if(!String.isEmpty(aribaId))
                {
                    List<Contract> contractList = new List<Contract> ();
                    
                    contractList=  [Select Id,Contract_Number_I_Many__c from Contract Where Contract_Number_I_Many__c =: aribaId ];
                    
                    if(!contractList.isEmpty())
                    {
                        
                        Customer_Emails__c custEmails = new Customer_Emails__c();
                        String aSub = email.subject;
                        if(aSub.contains('[ref:'))
                        {
                            aSub=  aSub.removeEnd('[ref:');
                            custEmails.Subject__c = aSub;
                        }
                        else
                        {
                            custEmails.Subject__c = email.subject;
                        }                   
                        custEmails.From_Name__c = email.fromName;
                        custEmails.From_Address__c = email.fromAddress;
                        custEmails.To_Address__c = String.ValueOf(email.toAddresses);
                        custEmails.Contract__c = contractList[0].Id;
                        custEmails.Content_body__c = email.htmlBody;
                        custEmails.has_Attachment__c= false;
                        
                        insert custEmails;
                        
                        List<Attachment> listTextAttachment = new List<Attachment>();  
                        Attachment att1 = new Attachment();                             
                        att1.Name = email.subject+'.html';
                        att1.Body = blob.valueOf(email.htmlBody);
                        att1.ParentId = custEmails.Id;                    
                        
                        listTextAttachment.add(att1);
                        system.debug('listTextAttachment====>'+listTextAttachment);
                        if(email.textAttachments != null)
                        {                       
                            Set<String> attachementDuplicateSet = new Set<String>();
                            for(Attachment att : [Select id,Name,ParentId From Attachment Where ParentId =: custEmails.Id])
                            {
                                attachementDuplicateSet.add(att.Name+'@'+aribaId);
                            }
                            System.debug('@@@@@attachementDuplicateSet'+attachementDuplicateSet);
                            for(Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
                                if(!attachementDuplicateSet.contains(tAttachment.fileName+'@'+aribaId))
                                {
                                    System.debug('@@@@Came to text attachment');
                                    Attachment attachment = new Attachment();                             
                                    attachment.Name = tAttachment.fileName;
                                    attachment.Body = Blob.valueOf(tAttachment.body);
                                    attachment.ParentId = custEmails.Id;
                                    //insert attachment;
                                    listTextAttachment.add(attachment);
                                }
                                
                            }
                            
                        }
                        if(!listTextAttachment.isEmpty()){
                            insert listTextAttachment;
                            hasAttachment = true;
                        }
                        if(email.binaryAttachments != null)
                        {
                            Set<String> attachementDuplicateSet = new Set<String>();
                            for(Attachment att : [Select id,Name,ParentId From Attachment Where ParentId =: custEmails.Id])
                            {
                                attachementDuplicateSet.add(att.Name+'@'+aribaId);
                            }
                            System.debug('@@@@@attachementDuplicateSet'+attachementDuplicateSet);
                            List<Attachment> listBinaryAttachment = new List<Attachment>();     
                            for(Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                                if(!attachementDuplicateSet.contains(bAttachment.fileName+'@'+aribaId))
                                {
                                    System.debug('@@@@Came to bin attachment'+bAttachment.fileName+'@'+aribaId);
                                    Attachment attachment = new Attachment();                             
                                    attachment.Name = bAttachment.fileName;
                                    attachment.Body = bAttachment.body;                                 
                                    attachment.ParentId = custEmails.Id;
                                    listBinaryAttachment.add(attachment);
                                }
                            }
                            if(!listBinaryAttachment.isEmpty()){
                                insert listBinaryAttachment;
                                hasAttachment = true;
                            } 
                        } 
                        if(hasAttachment){
                            Customer_Emails__c cstEmails = new Customer_Emails__c(Id = custEmails.Id);
                            cstEmails.has_Attachment__c= true;
                            update cstEmails;
                        } 
                        
                        result.success = true;          
                    }
                } 
            }
        }        
        catch (Exception e) {
            result.success = false;
            System.debug('Exception in RDF_EmailAttachmentSeriviceHandler Emailservices: ' + e.getMessage());
        } 
        return result;
    }
    
}