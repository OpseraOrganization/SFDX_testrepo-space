/**
 * Created by Satya Mohanty on 9/17/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
public with sharing class createOpportunityTask{
    public Task tskNew {get;set;}
    public EmailMessage emailMsg {get; private set;}
    public String addlRecipients {get; set;}
    private OrgWideEmailAddress sender = null;
    public String tasksales {get;set;}
    public String generaltask{get;set;}

    String oppid;
    public createOpportunityTask(ApexPages.StandardController controller){
        oppid = System.currentPageReference().getParameters().get('id');
        tskNew = new Task();
        tasksales = 'Sales Activity';
        generaltask ='General Task';
        emailMsg = new EmailMessage();
        sender = [select Id from OrgWideEmailAddress where Address =:'sfdcreportexporter@honeywell.com'];
    }
    ////////////////////******** Customer Status*********///////////////////////////////
    public PageReference saveTask(){
        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Customer Status').getRecordTypeId();
        Task tsk = tskNew;
        tsk.RecordtypeID = recTypeId;
        tsk.Subject = 'Customer Status';
        tsk.WhatId = System.currentPageReference().getParameters().get('id');
        //This is the default...
        tsk.OwnerId = UserInfo.getUserId();
        tsk.Status = 'In Progress';
        tsk.Type = 'Call';
        tsk.Description = tskNew.Description;
        tsk.CreatedDate = system.now();
        try{
            insert tsk;

            if(tsk.Id != NULL){
                List<Opportunity> opptListu = new List<Opportunity>();
                for(Opportunity oppty :[Select Name, Id, Status__c from Opportunity where ID =: tsk.WhatId]){
                    Opportunity opptObj = new Opportunity();
                    opptObj.id = tsk.WhatId;
                    opptObj.Status__c = tsk.Description;
                    opptListu.add(opptObj);
                }
                if(opptListu.size()>0){
                    System.debug('rsdjbjc============='+opptListu);
                    //update opptListu;
                }
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Created Successfully.Thank you!'));
            tskNew = new Task();
            // tsk = new Task();
        }
        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an Error! Cannot Create Task'));
        }
        return null;

    }
    ////////////////////******** Next Step*********///////////////////////////////
    public PageReference saveTask1(){
        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Next Step').getRecordTypeId();
        Task tsk = tskNew;
        tsk.RecordtypeID = recTypeId;
        tsk.Subject = 'Next Step';
        tsk.WhatId = System.currentPageReference().getParameters().get('id');

        tsk.OwnerId = UserInfo.getUserId();
        tsk.Status = 'In Progress';
        tsk.Type = 'Call';
        tsk.Description = tskNew.Description;
        tsk.ActivityDate = tskNew.ActivityDate;
        tsk.CreatedDate = system.now();
        try{
            insert tsk;
            if(tsk.Id != NULL){
                List<Opportunity> opptListu = new List<Opportunity>();
                for(Opportunity oppty :[Select Name, Id, Status__c from Opportunity where ID =: tsk.WhatId]){
                    Opportunity opptObj = new Opportunity();
                    opptObj.id = tsk.WhatId;
                    opptObj.Next_Step__c = tsk.Description;
                    opptObj.Next_Step_Date__c = tsk.ActivityDate;
                    opptListu.add(opptObj);
                }
                if(opptListu.size()>0){
                    System.debug('rsdjbjc============='+opptListu);
                    //update opptListu;
                }
            }
            tskNew = new Task();
            // tsk = new Task();
        }

        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an Error! Cannot Create Task'));
        }
        return null;

    }
    ////////////////////******** General Task*********///////////////////////////////
    public PageReference saveTask2(){
        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('General Task').getRecordTypeId();
        Task tsk = tskNew;
        tsk.RecordtypeID = recTypeId;
        tsk.Subject = 'General Task';
        tsk.WhatId = System.currentPageReference().getParameters().get('id');
        tsk.OwnerId = UserInfo.getUserId();
        tsk.Status = 'In Progress';
        tsk.Type = 'Call';
        tsk.Priority= 'Normal';
        tsk.Description = tskNew.Description;
        tsk.ActivityDate = tskNew.ActivityDate;
        try{
            insert tsk;
            tskNew = new Task();
            // tsk = new Task();
        }

        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an Error! Cannot Create Task'));
        }
        return null;

    }
    ////////////////////******** Sales Activity*********///////////////////////////////
    public PageReference saveTask3(){
        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Sales Activity').getRecordTypeId();
        Task tsk = tskNew;
        tsk.RecordtypeID = recTypeId;
        tsk.Subject = 'Sales Activity';
        tsk.WhatId = System.currentPageReference().getParameters().get('id');
        tsk.OwnerId = UserInfo.getUserId();
        tsk.Status = 'In Progress';
        tsk.Type = 'Call';
        tsk.Priority= 'Normal';
        tsk.Description = tskNew.Description;
        tsk.ActivityDate = tskNew.ActivityDate;
        try{
            insert tsk;
            tskNew = new Task();
            // tsk = new Task();
        }

        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an Error! Cannot Create Task'));
        }
        return null;

    }
    ///////******** Log An email logic*********///////

    public Attachment attachment {
        get {
            if (attachment==null) {
                System.debug('==========> creating new empty Attachment.');
                attachment = new Attachment();
            }
            return attachment;
        }
        set;
    }

    public PageReference send() {
        try {
            // now create our SingleEmailMessage to send out.
            Messaging.SingleEmailMessage singleEmailMsg = new Messaging.SingleEmailMessage();

            // concatenate all CC Addresses
            if (emailMsg.CcAddress != null && emailMsg.CcAddress != '') {
                singleEmailMsg.setCcAddresses(emailMsg.CcAddress.split(';'));
            }
            singleEmailMsg.setOrgWideEmailAddressId(sender.Id);

            singleEmailMsg.setSubject(emailMsg.Subject);
            singleEmailMsg.setPlainTextBody(emailMsg.TextBody);
            // now add additional recipients
            String[] addlToAddresses = null;
            if (addlRecipients != null && addlRecipients != '') {
                addlToAddresses = addlRecipients.split(';');
            }
            // now lets add any additional recipients to our list of recipients.
            List<String> lstToAddresses = null;
            if (addlToAddresses != null) {
                // now append these to our main recipient.
                lstToAddresses = new List<String>(addlToAddresses);
            } else {
                lstToAddresses = new List<String>();
            }
            lstToAddresses.add(emailMsg.ToAddress);
            singleEmailMsg.setToAddresses(lstToAddresses);
            // now we need to reset the ToAddress for our EmailMessage.
            emailMsg.ToAddress += (addlRecipients != null ? ';' + addlRecipients : '');
            // now attach file to email if there is one. Have to check the Body as Attachment
            // itself will never be null as it is always created first time it is accessed.
            if (attachment.Body != null) {
                Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
                emailAttachment.setBody(attachment.Body);
                emailAttachment.setFileName(attachment.Name);
                singleEmailMsg.setFileAttachments(new List<Messaging.EmailFileAttachment> {emailAttachment});
            }
            List<Messaging.SendEmailResult> results =  Messaging.sendEmail(
                    new List<Messaging.SingleEmailMessage> {singleEmailMsg});

            // now parse  our results
            // on success, return to calling page - Task view.
            if (results[0].success) {
                // now insert EmailMessage into database so it is associated with Task.
                insert emailMsg;
                // and insert attachment into database as well, associating it with our emailMessage
                if (attachment.Body != null) {
                    attachment.parentId=emailMsg.Id;
                    insert attachment;
                }
            }
        }
        catch (Exception e) {
            // on failure, display error message on existing page so return null to return there.
            String errorMsg = 'Exception thrown trying to send Email Message. Details = ' + e;
            System.debug('==========> ' + errorMsg);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
            return null;
        }
        return null;
    }
    public PageReference cancel() {
        // no need to do anything - just return to calling page.
        PageReference pgRef = new PageReference('/' + oppid);
        pgRef.setRedirect(true);
        return pgRef;
    }
}