/*****************************************************************
Name            :   ChannelPartnerNominationTest
Company Name    :   NTTData
Created Date    :   27-Mar-2021
Usages          :   ContentDocumentTriggerHandler,CPN_send_email_w_attachment
,ContentDocumentTrigger,ContentVersionTriggerHandler,DContentDocumentTrigger
,ChannelPartnerNomination
******************************************************************/
@isTest
public class ChannelPartnerNominationTest {
    @testSetup
    public static void testData(){
        Account acc = TestDataFactory.createAccount();
        Channel_Partner_Nomination__c CPN = TestDataFactory.createCPN(acc.id);
    }
    //Attachment is mandatory for submitting the record for approval
    @isTest
    public static void SubmitForApproval(){
        string errorMsg = '';
        Channel_Partner_Nomination__c CPN = [Select id,Approval_Status__C from Channel_Partner_Nomination__c limit 1];
        updateApprovers(New list<Channel_Partner_Nomination__c>{CPN});
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitrequest();
        app.setObjectId(CPN.Id);
        
        try{
            Approval.ProcessResult result = Approval.process(app);
        }
        catch(Exception ex){
            errorMsg = ex.getMessage();            
        }
        system.assert(errorMsg.contains(label.CPN_no_file_submit));
    }
    //Submitted for approval with attachment
    @isTest
    public static void SubmitForApprovalwAttachment(){
        Channel_Partner_Nomination__c CPN = [Select id,Approval_Status__C from Channel_Partner_Nomination__c limit 1];
        updateApprovers(New list<Channel_Partner_Nomination__c>{CPN});
        ContentVersion CV = TestDataFactory.CreateContentVersion(null);
        ContentDocumentLink CDL = TestDataFactory.CreateContentDocumentLink(CPN.Id,[Select contentDocumentId from ContentVersion where id=:CV.Id].contentDocumentId);
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitrequest();
        app.setObjectId(CPN.Id);
        Approval.ProcessResult result = Approval.process(app);
        system.assertEquals('Pending',[Select approval_Status__c from Channel_Partner_Nomination__c where id=:CPN.Id].Approval_Status__c);
    }
    //Sumitted for approval with attachment and approved
    @isTest
    public static void SubmitForApprovalapproved(){
        Channel_Partner_Nomination__c CPN = [Select id,Approval_Status__C from Channel_Partner_Nomination__c limit 1];
        updateApprovers(New list<Channel_Partner_Nomination__c>{CPN});
        ContentVersion CV = TestDataFactory.CreateContentVersion(null);
        ContentDocumentLink CDL = TestDataFactory.CreateContentDocumentLink(CPN.Id,[Select contentDocumentId from ContentVersion where id=:CV.Id].contentDocumentId);
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitrequest();
        app.setObjectId(CPN.Id);
        Approval.ProcessResult result = Approval.process(app);
        Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
        pwr.setAction('Approve');
        pwr.setWorkitemId(result.getNewWorkitemIds()[0]);
        result = Approval.process(pwr);
        //system.debug(result.getNewWorkitemIds()[0]);
        system.assertEquals('Approved',[Select approval_Status__c from Channel_Partner_Nomination__c where id=:CPN.Id].Approval_Status__c);
    }
    //Does not allow more than one file to be uploaded
    @isTest
    public static void uploadmoreFile(){
        string errorMsg = '';
        Channel_Partner_Nomination__c CPN = [Select id,Approval_Status__C from Channel_Partner_Nomination__c limit 1];
        updateApprovers(New list<Channel_Partner_Nomination__c>{CPN});
        ContentVersion CV = TestDataFactory.CreateContentVersion(null);
        ContentDocumentLink CDL = TestDataFactory.CreateContentDocumentLink(CPN.Id,[Select contentDocumentId from ContentVersion where id=:CV.Id].contentDocumentId);
        ContentVersion CV1 = TestDataFactory.CreateContentVersion(null);
        try{
            ContentDocumentLink CDL1 = TestDataFactory.CreateContentDocumentLink(CPN.Id,[Select contentDocumentId from ContentVersion where id=:CV1.Id].contentDocumentId);
        }
        catch(Exception ex){
            errorMsg = ex.getMessage();
        }
        system.assert(errorMsg.contains(label.CPN_File_Error_Msg_1_file));
    }
    //Sumitted for approval with attachment and deleting the file
    @isTest
    public static void SubmitForApprovalremoveFile(){
        string errorMsg = '';
        Channel_Partner_Nomination__c CPN = [Select id,Approval_Status__C from Channel_Partner_Nomination__c limit 1];
        updateApprovers(New list<Channel_Partner_Nomination__c>{CPN});
        ContentVersion CV = TestDataFactory.CreateContentVersion(null);
        ContentDocumentLink CDL = TestDataFactory.CreateContentDocumentLink(CPN.Id,[Select contentDocumentId from ContentVersion where id=:CV.Id].contentDocumentId);
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitrequest();
        app.setObjectId(CPN.Id);
        Approval.ProcessResult result = Approval.process(app);
        try{
            Delete CDL;  
        }
        catch(Exception ex){
            errorMsg = ex.getMessage();
        }
        system.assert(errorMsg.contains(label.CPN_File_Error_Msg));
    }
    //clearing the Content Document URL from Channel partner nomination object 
    //when the file is deleted when the status is not pending/approved 
    @isTest
    public static void clearContentDocURL(){
        string baseurl = URL.getSalesforceBaseUrl().toExternalForm();
        string errorMsg = '';
        String ContentDocIdold = '';        
        Channel_Partner_Nomination__c CPN = [Select id,Approval_Status__C from Channel_Partner_Nomination__c limit 1];
        ContentVersion CV = TestDataFactory.CreateContentVersion(null);
        ContentDocIdold = [Select contentDocumentId from ContentVersion where id=:CV.Id].contentDocumentId;
        ContentDocumentLink CDL = TestDataFactory.CreateContentDocumentLink(CPN.Id,ContentDocIdold);
        Database.delete(ContentDocIdold);
        system.assertEquals(null, [Select id,Approval_Status__C,Content_Document_url__c from Channel_Partner_Nomination__c where id=:CPN.Id].Content_Document_url__c);
    }
    //Delete the file when the record is submitted for approval
    @isTest
    public static void DeleteFile(){
        string baseurl = URL.getSalesforceBaseUrl().toExternalForm();
        string errorMsg = '';
        String ContentDocIdold = '';        
        Channel_Partner_Nomination__c CPN = [Select id,Approval_Status__C from Channel_Partner_Nomination__c limit 1];
        updateApprovers(New list<Channel_Partner_Nomination__c>{CPN});
        ContentVersion CV = TestDataFactory.CreateContentVersion(null);
        ContentDocIdold = [Select contentDocumentId from ContentVersion where id=:CV.Id].contentDocumentId;
        ContentDocumentLink CDL = TestDataFactory.CreateContentDocumentLink(CPN.Id,ContentDocIdold);
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitrequest();
        app.setObjectId(CPN.Id);
        Approval.ProcessResult result = Approval.process(app);
        system.debug(result);
        system.debug([Select id,Approval_Status__C from Channel_Partner_Nomination__c limit 1]);
        try{
            Database.delete(ContentDocIdold); 
        }
        catch(Exception ex){
            errorMsg = ex.getMessage();
        }
        system.debug(errorMsg);
        system.assert(errorMsg.contains(label.CPN_File_Error_Msg));
    }
    //Sumitted for approval with attachment and updating the version
    @isTest
    public static void Submitupdateversion(){
        string errorMsg = '';
        string contDocId = '';
        Channel_Partner_Nomination__c CPN = [Select id,Approval_Status__C from Channel_Partner_Nomination__c limit 1];
        updateApprovers(New list<Channel_Partner_Nomination__c>{CPN});
        ContentVersion CV = TestDataFactory.CreateContentVersion(null);
        contDocId = [Select contentDocumentId from ContentVersion where id=:CV.Id].contentDocumentId;
        ContentDocumentLink CDL = TestDataFactory.CreateContentDocumentLink(CPN.Id,contDocId);
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitrequest();
        app.setObjectId(CPN.Id);
        Approval.ProcessResult result = Approval.process(app);
        try{
            ContentVersion CV1 = TestDataFactory.CreateContentVersion(contDocId);
        }
        catch(Exception ex){
            errorMsg = ex.getMessage();
        }
        system.assert(errorMsg.contains(label.CPN_File_Error_Msg));
    }
    //Submitted for approval with attachment from lightning component 
    @isTest
    public static void Submitlightning(){
        string contDocId = '';
        Channel_Partner_Nomination__c CPN = [Select id,Approval_Status__C from Channel_Partner_Nomination__c limit 1];
        updateApprovers(New list<Channel_Partner_Nomination__c>{CPN});
        ContentVersion CV = TestDataFactory.CreateContentVersion(null);
        contDocId = [Select contentDocumentId from ContentVersion where id=:CV.Id].contentDocumentId;
        ContentDocumentLink CDL = TestDataFactory.CreateContentDocumentLink(CPN.Id,contDocId);
        CPN_SubmitApproval.submitforApproval(CPN.Id);
        system.assertEquals('Pending',[Select approval_Status__c from Channel_Partner_Nomination__c where id=:CPN.Id].Approval_Status__c);
    }
    //Submit for approval without file
    @isTest
    public static void Submitlightningnofile(){
        string errorMsg = '';
        Channel_Partner_Nomination__c CPN = [Select id,Approval_Status__C from Channel_Partner_Nomination__c limit 1];
        updateApprovers(New list<Channel_Partner_Nomination__c>{CPN});
        try{
        	CPN_SubmitApproval.submitforApproval(CPN.Id);
        }
        catch(Exception ex){
            errorMsg = ex.getMessage();
        }
        system.assertEquals('Script-thrown exception',errorMsg);
    }
    
    //Send email on submission
    @isTest
    public static void SendEmail(){
        string contDocId = '';
        Channel_Partner_Nomination__c CPN = [Select id,Approval_Status__C from Channel_Partner_Nomination__c limit 1];
        updateApprovers(New list<Channel_Partner_Nomination__c>{CPN});
        ContentVersion CV = TestDataFactory.CreateContentVersion(null);
        contDocId = [Select contentDocumentId from ContentVersion where id=:CV.Id].contentDocumentId;
        ContentDocumentLink CDL = TestDataFactory.CreateContentDocumentLink(CPN.Id,contDocId);
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitrequest();
        app.setObjectId(CPN.Id);
        Approval.ProcessResult result = Approval.process(app);        
        CPN_send_email_w_attachment.sendEmail(new list<channel_partner_nomination__c>{[Select id,Approval_Status__C from Channel_Partner_Nomination__c where id=:CPN.Id]});
    }
    public static void updateApprovers(List<Channel_Partner_Nomination__C> CPNList){
        for(Channel_Partner_Nomination__C CPN:CPNList){
            CPN.Global_Channel_Committee_look_up__c = userinfo.getUserId();
            CPN.Licensing_look_up__c = userinfo.getUserId();
            CPN.Engines_ABM_look_up__c = userinfo.getUserId();
        }
        update CPNList;
    }
    
}