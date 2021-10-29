/** * File Name: OpportunityWebserviceController
* Description Rest Webservice class to insert & Update opportunity & insert the attachment for the opportunity
* Copyright : ITC INFOTECH Limited Copyright (c) 2017
* * @author : ITC INFOTECH
Ver Date Author v1.0 06/02/2017
* */ 
@RestResource(urlMapping='/AerospaceOpportunityService/*')
global without sharing class OpportunityWebserviceController {
   @HttpPost
    global static void doPost()
    {
     /*   RestRequest req = RestContext.request;
        RestContext.response.addHeader('Content-Type', 'application/json');
        system.debug('-----------Recieved data--------'+req.requestBody.toString()) ;
        String replaceIllegal= req.requestBody.toString();    
         system.debug('-----------Recieved data--------'+replaceIllegal) ;
        OpportunityRecord OpportunityDetail = (OpportunityRecord)JSON.deserialize(replaceIllegal,OpportunityRecord.class);     
        system.debug('----------Opportunity Records List----------'+OpportunityDetail);
        // Insert opportunity 
        if(OpportunityDetail.opportunityID==null){   
            
            List<RecordType> opportuntiyRecordType =  [SELECT Id FROM RecordType WHERE Name =: OpportunityDetail.recordtypeName and SObjectType = 'Opportunity'];
            List<Account> accountRecList = [select id,name from account where name=:OpportunityDetail.operatorName or name=:OpportunityDetail.dealerName];
            
            List<Fleet_Asset_Detail__c> aircraftDetails = [select id from Fleet_Asset_Detail__c where (Model__c=:OpportunityDetail.aircraftModel and Make__c=:OpportunityDetail.aircraftMake) and 
                                                           (Tail_Number__c=:OpportunityDetail.aircraftTail and Serial_Number__c=:OpportunityDetail.aircraftSerialNumber)];
            String dealerID;
            string errMessage = ' ';
            String opptynotes = null;
            String operatorID;
            String aircraftID;
 			            
            if(opportuntiyRecordType.size()<1){
                errMessage = 'No recordType found with this data..!';
                OpportunityResponse opptyResponse = new OpportunityResponse('Failure',null,errMessage,null);
                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(opptyResponse));
                //return JSON.serialize(opptyResponse);
            }
            if(accountRecList.size()>0){
                for(Account acc: accountRecList){
                    if(acc.name==OpportunityDetail.operatorName)
                        operatorID = acc.id;
                    if(acc.name==OpportunityDetail.dealerName)
                        dealerID = acc.id;
                }
            }
            if(operatorID==null){
                list<Account> defacclist = [select id from account where name='HONEYWELL DEFAULT ACCOUNT']; 
                operatorID = defacclist[0].id;
            }else if(dealerID==null){
                list<Account> defacclist = [select id from account where name='HONEYWELL DEFAULT ACCOUNT']; 
                dealerID = defacclist[0].id;
            }
            system.debug('####Dealer Details###'+operatorID+'!!!!!!!!'+dealerID);
            system.debug('####aircraftDetails###'+aircraftDetails+'!!!!!!!!'+dealerID);
            if(aircraftDetails.size()>0){
                aircraftID = aircraftDetails[0].id; 
            }else{
                opptynotes = 'Make:'+OpportunityDetail.aircraftMake+','+'Model:'+OpportunityDetail.aircraftModel+','+'Serial Number:'+OpportunityDetail.aircraftSerialNumber+',Tail Number:'+OpportunityDetail.aircraftTail;
            }
            
            Opportunity oppty = new Opportunity();
            oppty.type = OpportunityDetail.contractType;
            oppty.dealer_account__c = dealerID;
            oppty.AccountID = operatorID;
            oppty.RecordTypeId = opportuntiyRecordType[0].id;
            oppty.name = OpportunityDetail.contractType+' '+ OpportunityDetail.aircraftModel+' '+OpportunityDetail.aircraftSerialNumber;
            oppty.Amount = integer.valueof(OpportunityDetail.quotePrice);
            if(opptynotes!=null){
                oppty.Opportunity_Notes__c = opptynotes;
            }else{
                oppty.Opportunity_Notes__c = OpportunityDetail.notes;
                oppty.Aircraft_Ref__c = aircraftID;
            }
            oppty.leadsource = 'Quoting Tool'; // OpportunityDetail.leadSourcevalue;
            oppty.Comments__c = OpportunityDetail.comments;
            oppty.stagename=OpportunityDetail.stage;
            oppty.Quote__c = OpportunityDetail.quotenumber;
            oppty.Quote_Expiration_Date__c = date.valueof(OpportunityDetail.quoteValidDate);   
          
            //Added by Savita
            oppty.CloseDate = date.valueof(OpportunityDetail.quoteValidDate); 
            oppty.Dealer_Contact_Details__c = OpportunityDetail.dealerContact; 
            
            try {
                insert oppty; 
                system.debug('@@@@Inserted Oppty@@@@@'+oppty);
            }
            catch(Exception e)  // exception handling
            {
                System.debug('The following exception has occurred: '+e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
                errMessage = e.getMessage();
                //return errMessage; 
            }  
            
            
            if(errMessage!= null && errMessage!=' '){
                OpportunityResponse opptyResponse = new OpportunityResponse('Failure',null,errMessage,null);
                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(opptyResponse));
            }else{   
                OpportunityResponse opptyResponse = new OpportunityResponse('Success',oppty.id,null,null);   
                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(opptyResponse));
            }
            
            // Inserting attachment for the opportunity
        }else{
            if(OpportunityDetail.attachmentDetail!=null){
                system.debug('$$$$$$$$$$$$$$$'+OpportunityDetail.attachmentDetail);
                Blob attachDetail = EncodingUtil.base64Decode(OpportunityDetail.attachmentDetail);
                
               /* Attachment a = new Attachment();
                a.ParentId = OpportunityDetail.opportunityID;
                a.Name = OpportunityDetail.attachmentName+'.pdf';
                a.Body = attachDetail;
                a.ContentType='application/pdf'; 
                insert a;*/
                /*************Start of SCTASK3774363***************/
              /*  ContentVersion cv = new ContentVersion();
                cv.PathOnClient = 'application/pdf'; 
                cv.Title =  OpportunityDetail.attachmentName+'.pdf';
                cv.VersionData = attachDetail;
				insert cv;
                
                Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
                
                ContentDocumentLink cDocLink = new ContentDocumentLink();
                cDocLink.ContentDocumentId = conDocument;
                cDocLink.LinkedEntityId = OpportunityDetail.opportunityID;
                cDocLink.ShareType = 'I';
                Insert cDocLink;
                /*************End of SCTASK3774363***************/
               /* OpportunityResponse attachmentResponse = new OpportunityResponse('Success',OpportunityDetail.opportunityID,null,cv.id);//added cv.id wrt SCTASK3774363
                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(attachmentResponse));
                
                // Updating the Opportunity       
            }else{
                String comments = '';
                Opportunity updateOpptyRec =[select id,stagename,Opportunity_Notes__c,Comments__c from Opportunity where id=:OpportunityDetail.opportunityID];
                updateOpptyRec.stagename = OpportunityDetail.stage;
              
                comments = (updateOpptyRec.Comments__c == null) ? '': updateOpptyRec.Comments__c;
                updateOpptyRec.Comments__c = comments + '\n' +OpportunityDetail.comments;
                update updateOpptyRec; 
                OpportunityResponse opptyResponse = new OpportunityResponse('Success',updateOpptyRec.id,null,null);
                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(opptyResponse));
                
            }
        }*/
    }
    
    /*Public class OpportunityResponse
    {
        public String status;
        public String opportunityID;
        public String attachmentID;
        public String error;
        
        public OpportunityResponse(String statusmsg,String opptyID,String errormsg,String attachID){
            attachmentID = ' ';
            error = ' ';
            system.debug('###'+statusmsg+'@@@'+opptyID);
            status = statusmsg;
            opportunityID = opptyID;
            if(attachID!=null)
                attachmentID = attachID;
            if(errormsg!= null)
                error = errormsg;
        }
    }
    
    public class OpportunityRecord   
    {
        public String recordtypeName;
        public String ownerQueue;
        public String contractType;
        public String honeywellID;
        public string subject;
        public String quotePrice;
        public string dealerName;
        public string operatorName;
        public string stage;
        public string aircraftMake; 
        public string aircraftModel;
        public string aircraftTail;
        public String aircraftSerialNumber;
        public String notes;
        public String quotenumber;
        public String leadSourcevalue;
        public string comments;
        public String quoteValidDate;
        public String attachmentDetail;
        public String attachmentName;
        public String opportunityID;
        public String dealerContact;
        
        public OpportunityRecord()
        {
            
        }
    }*/
}