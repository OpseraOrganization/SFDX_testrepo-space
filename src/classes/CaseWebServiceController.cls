@RestResource(urlMapping='/AerospaceCaseServices/*')
global without sharing class CaseWebServiceController {
    
    @HttpPost
    global static void doPost(){
        String caseNum = null;
        RestRequest req = RestContext.request;
        RestContext.response.addHeader('Content-Type', 'application/json');
        system.debug('-----------Recieved data--------'+req.requestBody.toString()) ;
        CaseDetailRecord caseDetail = (CaseDetailRecord)JSON.deserialize(req.requestBody.toString(),CaseDetailRecord.class);
        List<QueueSobject> caseOwnerQueue = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name=: caseDetail.ownerQueue]; 
        List<RecordType> caseRecordType = [SELECT Id FROM RecordType WHERE Name =: caseDetail.recordtypeName and SObjectType = 'Case' limit 1];
        System.debug('caseDetail - '+ caseDetail); 
        
        if(caseDetail.caseID==null){
            String isServiceMissing = caseDetail.isServiceMissing;
            
            Contact contactName = [select id,AccountId from Contact where Honeywell_ID__c =:caseDetail.honeywellID LIMIT 1];  
            system.debug('##@$#$@ '+contactName);
            system.debug('##@$#$@ isServiceMissing '+isServiceMissing);
            system.debug('##@$#$@ govtComplianceContent '+caseDetail.govtComplianceContent);
            system.debug('##@$#$@ exportComplianceContent '+caseDetail.exportComplianceContent);
            
            Case newCaseDetail = new Case();
            newCaseDetail.AccountID = contactName.AccountId;
            newCaseDetail.contactID = contactName.id;
            newCaseDetail.subject = caseDetail.subject;
            newCaseDetail.Classification__c = caseDetail.classification;
            newCaseDetail.Origin = 'Web';
            newCaseDetail.RecordTypeId = caseRecordType[0].id;
            newCaseDetail.status = caseDetail.status;
            newCaseDetail.Sub_Status__c = caseDetail.subStatus;
            newCaseDetail.description = caseDetail.description;
            newCaseDetail.Government_Compliance_SM_M_Content__c = 'No';//caseDetail.govtComplianceContent;
            newCaseDetail.Export_Compliance_Content_ITAR_EAR__c = 'No'; //caseDetail.exportComplianceContent;
            
            if(isServiceMissing == 'Y'){
                newCaseDetail.SuppliedEmail = caseDetail.email;
                
                newCaseDetail.type = caseDetail.caseType;
                newCaseDetail.Additional_Web_Form_Info__c = caseDetail.subscriptionDetails;
            }else{
                newCaseDetail.Comments__c =  caseDetail.comments;
            }
            
            if(!caseOwnerQueue.isEmpty())
                newCaseDetail.OwnerID = caseOwnerQueue[0].QueueId; //caseDetail.ownerQueue;
            
            string errMessage;
            try {
                Database.DMLOptions options = new Database.DMLOptions();
                options.assignmentRuleHeader.useDefaultRule = true;
                newCaseDetail.setOptions(options);
                insert newCaseDetail; 
                system.debug('@@@@Inserted Case@@@@@'+newCaseDetail);
            }
            catch(Exception e)  // exception handling
            {
                System.debug('The following exception has occurred: '+e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
                errMessage = e.getMessage();
                CaseResponse caseReturn = new CaseResponse(null,null,'Failure',errMessage);
                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(caseReturn));
                //return JSON.serialize(caseReturn);
            }
            Case caseInserted = [select casenumber,id  from case where id =: newCaseDetail.id ];
            CaseResponse caseReturn = new CaseResponse(newCaseDetail.id, caseInserted.casenumber,'Success',null);  
            RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(caseReturn));
            //return JSON.serialize(caseReturn);
        }
        else{
            Case updateCase = [select id,CaseNumber,Sub_Status__c,status,Comments__c,description from Case where id=:caseDetail.caseID];
            updateCase.Sub_Status__c = caseDetail.subStatus;
            updateCase.status = caseDetail.status;
            updateCase.Comments__c = caseDetail.comments;
            updateCase.description = caseDetail.description;
            update updateCase;
            CaseResponse caseReturn = new CaseResponse(updateCase.id, updateCase.CaseNumber,'Success',null);  
            RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(caseReturn));
            //return JSON.serialize(caseReturn);
        }
    }


public class CaseResponse{
    public String caseId;
    public String caseNumber;
    public String Status;
    public String error;
    
    public CaseResponse(String caserecId,String caserecNumber, String statusmsg,String errormsg){
        error = '';
        caseId = caserecId;
        caseNumber = caserecNumber;
        Status = statusmsg;
        if(errormsg!=null)
            error =  errormsg;
    }   
}

public class CaseDetailRecord   
{
    public String honeywellID;
    public string subject;
    public string description;
    public String classification;
    public string comments;
    public String recordtypeName;
    public String subStatus;
    public String ownerQueue;
    public String caseType;     
    public String status;
    public String caseID;
    
    public String subscriptionDetails;
    public String exportComplianceContent;
    public String govtComplianceContent;
    public String email;
    public String origin;
    public String isServiceMissing;
    
    public CaseDetailRecord()
    {
        
    }
}

}