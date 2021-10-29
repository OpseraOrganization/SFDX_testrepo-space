/*****************************************************************
Name            :   CPN_send_email_w_attachment
Company Name    :   NTTData
Created Date    :   27-Mar-2021
Usages          :   For sending email once the approval status is 
changed to Approved/Rejected/Pending with attachment to the approvers/Submitter
Test Class		:	ChannelPartnerNominationTest
******************************************************************/
public class CPN_send_email_w_attachment {
    public ID targetObjectId { get; set; }
    public String comments {
        get {
            if ( comments == null ) {
                 comments = getLastApprovalStep();                
            }
            return comments;
        }
        private set;
    }
    private String getLastApprovalStep() {
        String comments='';
        for(ProcessInstance pStep :[SELECT Id,status,TargetObjectId,(SELECT Id, Actor.Name,OriginalActor.Name,Comments,StepStatus FROM StepsAndWorkitems) 
                                    FROM ProcessInstance WHERE targetobjectId =:targetObjectId ORDER BY CreatedDate DESC Limit 1]){
                                        for(ProcessInstanceHistory stepItems:pStep.StepsAndWorkitems){
                                            if( (stepItems.StepStatus).equalsIgnoreCase('Approved') && stepItems.Comments != null){
                                                comments += stepItems.Actor.Name+' : '+stepItems.Comments+'<br/>';
                                            }else if((stepItems.StepStatus).equalsIgnoreCase('Rejected')){
                                                comments = '';
                                                comments =  stepItems.Actor.Name+' : '+stepItems.Comments+'<br/>';
                                                break;
                                            }
                                        }
                                        
                                    }
        return comments;
    }
    
    @invocableMethod
    public static void sendEmail(List<channel_partner_nomination__c> recs){
        //Stores the record id and the email recipients
        map<id,set<id>> objApproverId = new map<id,set<id>>();
        //map<id,set<id>> recIdmailRecipients = new map<id,set<id>>();
        //Channel partner nomination list
        List<Channel_partner_nomination__c> CPNList = new List<Channel_partner_nomination__c>();
        //Stores the recId and contentDocument
        map<id,id> recIdcontentdoc = new map<id,id>();
        //Stores the documentId and content
        map<id,id> docIdcontentVersion = new map<id,id>();
        //Stores the Channel partner nomination status
        map<id,string> cpnStatus = new map<id,string>();
        //Stores the email template Name and Id
        map<string,id> templateIdmap = new map<string,id>();
        //Stores the status and email template Name
        map<string,string> statustemplatemap = new map<string,string>();
        //Stores the email messages
        List<Messaging.SingleEmailMessage> messageList = new List<Messaging.SingleEmailMessage>();
        List<String> additionalApprovaers = new List<String>();
        //loops through individual record passed
        /*for(wrapperClass wrapClass:wrapClasslist){
recStatus.put(wrapClass.recId,wrapClass.status);
}*/
        //Ids.addAll(recStatus.keyset());
        
        
        //loops through individual record to store the status
        for(channel_partner_nomination__c CPN:recs){
            cpnStatus.put(CPN.Id,CPN.Approval_Status__c);
        }
        for(CPN_Email_Template__mdt cpnEmailtemplate:[Select Email_Template__c,DeveloperName from CPN_Email_Template__mdt where DeveloperName in: cpnStatus.values()]){
            statustemplatemap.put(cpnEmailtemplate.DeveloperName,cpnEmailtemplate.Email_Template__c);
        }
        for(EmailTemplate emailTemp:[SELECT DeveloperName,Id FROM EmailTemplate where DeveloperName in:statustemplatemap.values()]){
            templateIdmap.put(emailTemp.DeveloperName,emailTemp.Id);
        }
        //loops through the process instance
        for (ProcessInstance pi : [SELECT status,Id,TargetObjectId,SubmittedById,LastActorId,(SELECT Id, Actor.Name,OriginalActor.Name,ActorId,OriginalActorId,Comments, ProcessInstanceId,StepStatus FROM StepsAndWorkitems)
                                   FROM ProcessInstance WHERE targetobjectId in:cpnStatus.keyset() ORDER BY CreatedDate DESC limit 1])
        {
            //Stores the Approvers Id
            set<id> approversId = new set<id>(); 
            //Compares the status of the record's status and approval process's status. 
            //Makes sure that the record is not picked multiple times
            if(!objApproverId.containsKey(pi.TargetObjectId) && cpnStatus.get(pi.TargetObjectId)== pi.Status){
                if (pi.StepsAndWorkitems.size() > 0){
                    for(ProcessInstanceHistory pih :pi.StepsAndWorkitems){
                        if(pih.stepstatus!='started'){
                            approversId.add(pih.OriginalActorId);
                            approversId.add(pih.ActorId);  
                        }
                        
                    } 
                }
                //if the channel partner nomination approval status is approved/rejected then email will be sent to that
                if(('Approved,Rejected').containsIgnoreCase(cpnStatus.get(pi.TargetObjectId))){
                    approversId.add(pi.SubmittedById);
                }
                if(('Approved').containsIgnoreCase(cpnStatus.get(pi.TargetObjectId))){
                    additionalApprovaers = (Label.CPN_Additional_Approvers).split(',');
                }
                //puts the object Id and the list of approvers
                objApproverId.put(pi.TargetObjectId,new set<id>(approversId));
            }               
            
        }
        /*string query = 'Select id,approval_status__c,' + label.CPN_Approvers + ' from Channel_partner_nomination__c where Id in: recs  ';
system.debug(query);
CPNList = database.query(query);*/
        //loops through content document link to get the related files
        for(ContentDocumentLink CDL:[Select id,ContentDocumentId,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId in:cpnStatus.keyset()]){
            recIdcontentdoc.put(CDL.LinkedEntityId,CDL.ContentDocumentId);
        }
        //loops through the Content version to get the latest file id
        for(contentVersion cv :[SELECT id,contentDocumentId 
                                FROM ContentVersion WHERE contentDocumentId in:recIdcontentdoc.values() AND IsLatest = true]){
                                    docIdcontentVersion.put(cv.ContentDocumentId,cv.Id);
                                }
        
        for(Id objId:objApproverId.keyset()){
            for(id recipientId:objApproverId.get(objId)){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setTreatTargetObjectAsRecipient(true);
                message.setTargetObjectId(recipientId);
                message.setUseSignature(false); 
                message.setBccSender(false); 
                message.setSaveAsActivity(false);
                message.setTemplateID(templateIdmap.get(statustemplatemap.get(cpnStatus.get(objId))));
                message.setWhatId(objId);                    
                message.setEntityAttachments(new list<string>{docIdcontentVersion.get(recIdcontentdoc.get(objId))});
                messageList.add(message);
                
                if(additionalApprovaers.contains(recipientId)){
                   	 additionalApprovaers.remove(additionalApprovaers.indexOf(recipientId));             
                }
            }
            
        }
        /*for(Channel_partner_nomination__c CPN:CPNList){
string listofApprovers = label.CPN_Approvers;
set<id> recipientIds = new set<id>();
if(CPN.Approval_Status__c == 'pending'){
listofApprovers.remove(',OwnerId');
}*/
        
        /*for(string reciever : listofApprovers.split(',')){
if(string.isnotblank(string.valueof(CPN.get(reciever)))){
//recipientIds.add(string.valueof(CPN.get(reciever)));
Id recipientId= string.valueof(CPN.get(reciever));
Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
message.setTreatTargetObjectAsRecipient(true);
message.setTargetObjectId(recipientId);
//message.setSenderDisplayName(system.label.SEA_UOP_Sender);
message.setUseSignature(false); 
message.setBccSender(false); 
message.setSaveAsActivity(false);
message.setTemplateID('00X1F000003DDOX');
message.setWhatId(CPN.Id);                    
message.setEntityAttachments(new list<string>{docIdcontentVersion.get(recIdcontentdoc.get(CPN.Id))});
//message.setReplyTo(replyto);
messageList.add(message);
}                
}*/
        
        //}
        Savepoint sp = Database.setSavepoint();
        Messaging.sendEmail(messageList);
        Database.rollback(sp);
        List<Messaging.SingleEmailMessage> msgListToBeSend = new List<Messaging.SingleEmailMessage>();
        
        Integer i=1;        
        for (Messaging.SingleEmailMessage email : messageList) {
            
            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
            list<string> toAddresses= new list<string>{email.getTargetObjectId()};            
            if( i == messageList.size() ){
                 emailToSend.setCcAddresses(additionalApprovaers);
            }
            i +=1;
            emailToSend.setToAddresses(toAddresses);
            //emailToSend.setCcAddresses(email.getccAddresses());
            emailToSend.setPlainTextBody(email.getPlainTextBody());
            emailToSend.setHTMLBody(email.getHTMLBody());
            emailToSend.setSubject(email.getSubject());
            emailToSend.setBccSender(false);
            emailToSend.setUseSignature(false);
            emailToSend.setSaveAsActivity(false);
            emailToSend.setEntityAttachments(email.getEntityAttachments());
            msgListToBeSend.add(emailToSend);
        }
        if(msgListToBeSend.size()>0){
            Messaging.sendEmail(msgListToBeSend); 
        }
    }
    /*public class wrapperClass{
@invocableVariable(required=true)
public string recId;
@invocableVariable(required=true)
public string status;
}*/
}