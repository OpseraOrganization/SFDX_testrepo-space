@RestResource(urlMapping='/AerospaceAircraftCaseServices/*')
global without sharing class caseWithAircraftWebServiceController {

    @HttpPost
    global static void doPost()
    {
        String caseNum = null;
        RestRequest req = RestContext.request;
        RestContext.response.addHeader('Content-Type', 'application/json');
        system.debug('-----------Recieved data--------'+req.requestBody.toString()) ;
        CaseDetailRecord caseDetail = (CaseDetailRecord)JSON.deserialize(req.requestBody.toString(),CaseDetailRecord.class);
        
       
        System.debug('caseDetail - '+ caseDetail);
        if(caseDetail.caseNumber==null || (caseDetail.caseNumber!=null && caseDetail.updationType =='Quote Created'))
        {
            List<QueueSobject> caseOwnerQueue = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name=: caseDetail.ownerQueue]; 
            List<RecordType> caseRecordType =  [SELECT Id FROM RecordType WHERE Name =: caseDetail.recordtypeName and SObjectType = 'Case' limit 1];
            Case newCaseDetail = new Case();
            string errMessage;
            if(caseRecordType.size()<1)
            {
                errMessage = 'No recordType found with this data..!';
                CaseResponse caseReturn = new CaseResponse(null,null,'Failure',errMessage);                     
                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(caseReturn));
            }
            else
            {
            
            newCaseDetail.status = caseDetail.status;
            if(caseDetail.caseNumber==null)
            {
                newCaseDetail.RecordTypeId = caseRecordType[0].id;
                if(!caseOwnerQueue.isEmpty())
                newCaseDetail.OwnerID = caseOwnerQueue[0].QueueId; //caseDetail.ownerQueue;
            }
            String subject;
            if(caseDetail.contractType != null)
            {
                subject = caseDetail.contractType+' ';
            }
            if(caseDetail.aircraftModel !=null)
            {
                subject = subject+caseDetail.aircraftModel+' ';
            }
            if(caseDetail.aircraftSerialNumber !=null)
            {
                subject = subject+caseDetail.aircraftSerialNumber;
            }
            newCaseDetail.subject = subject;
            //newCaseDetail.Classification__c = caseDetail.classification;
            if(caseDetail.comments !=null)
            newCaseDetail.Comments__c =  caseDetail.comments;
            newCaseDetail.Sub_Status__c = caseDetail.subStatus;
            //newCaseDetail.description =  caseDetail.description;                        
            List<Account> accountRecList = [select id,name from account where name=:caseDetail.operatorName or name=:caseDetail.dealerName];
            List<Fleet_Asset_Detail__c> aircraftDetails = [select id from Fleet_Asset_Detail__c where (Model__c=:caseDetail.aircraftModel and Make__c=:caseDetail.aircraftMake) and 
                                                       (Tail_Number__c=:caseDetail.aircraftTail and Serial_Number__c=:caseDetail.aircraftSerialNumber)];
                
            String dealerID;            
            String casenotes = null;
            String operatorID;
            String aircraftID;
            String additionalInfo = '';
            if(caseDetail.quotenumber != null)
            {
                additionalInfo = 'Quote Number : '+caseDetail.quotenumber+'\n ';
            }
            if(accountRecList.size()>0)
            {
                for(Account acc: accountRecList)
                {
                    if(acc.name==caseDetail.operatorName)
                        operatorID = acc.id;
                    if(acc.name==caseDetail.dealerName)
                        dealerID = acc.id;
                }
            }
                    
            if(aircraftDetails.size()>0)
            {
                aircraftID = aircraftDetails[0].id; 
                newCaseDetail.Notes__c = caseDetail.notes;
                newCaseDetail.Aircraft_Name__c = aircraftID;
            }
            else
            {
                String strNotes;                
                newcaseDetail.Notes__c = 'Make: '+caseDetail.aircraftMake+','+' Model: '+caseDetail.aircraftModel+','+' Serial Number: '+caseDetail.aircraftSerialNumber+', Tail Number: '+caseDetail.aircraftTail;
            }
            if(caseDetail.contractType !=null)
            {
                newCaseDetail.Type = caseDetail.contractType;
            }
            if(operatorID!= null){
                newCaseDetail.Aircraft_Owner_Operator__c = operatorID;
            }else{
                if(caseDetail.operatorName !=null)
                {
                    additionalInfo = additionalInfo + 'Operator :' +caseDetail.operatorName +'\n ';
                 }
            }
            if(dealerID!=null)
            {
                newCaseDetail.AccountID = dealerID;
            }else{
                if(caseDetail.dealerName !=null)
                {
                    additionalInfo = additionalInfo + 'Dealer 1 :' +caseDetail.dealerName+'\n ';
                }
            }
            if(caseDetail.leadSource !=null)
            {
                additionalInfo = additionalInfo + '\n Lead Source :' +caseDetail.leadSource;
            }
            newCaseDetail.Additional_Web_Form_Info__c = additionalInfo;
            if(caseDetail.quotePrice !=null)
                newCaseDetail.Dollar_Amount__c = integer.valueof(caseDetail.quotePrice);
            if(caseDetail.quoteValidDate!=null)
                newCaseDetail.Expiration_Date__c = datetime.valueof(caseDetail.quoteValidDate);
            if(caseDetail.dealerContact !=null) 
                newCaseDetail.BGA_Dealer_Name__c = caseDetail.dealerContact;
            newCaseDetail.Origin = 'Web';
            newCaseDetail.Government_Compliance_SM_M_Content__c = 'No';
            newCaseDetail.Export_Compliance_Content_ITAR_EAR__c = 'No'; 
            try 
            {
                if(caseDetail.caseNumber == null)
                {
                    insert newCaseDetail; 
                }
                else
                {
                    
                    Case caseUpdated = [select casenumber,id  from case where casenumber =: caseDetail.caseNumber];
                    newCaseDetail.Id = caseUpdated.id;
                    update newCaseDetail;
                }
                system.debug('@@@@Inserted Case@@@@@'+newCaseDetail);
                if(caseDetail.attachmentDetail!=null && newCaseDetail.Id !=null)
                {
                    system.debug('$$$$$$$$$$$$$$$'+caseDetail.attachmentDetail);
                    Blob attachDetail = EncodingUtil.base64Decode(caseDetail.attachmentDetail);
                                
                    Attachment a = new Attachment();
                    a.ParentId = newCaseDetail.Id;
                    a.Name = caseDetail.attachmentName+'.pdf';
                    a.Body = attachDetail;
                    a.ContentType='application/pdf'; 
                    insert a;
                }
                Case caseInserted = [select casenumber,id  from case where id =: newCaseDetail.id ];
                CaseResponse caseReturn = new CaseResponse(newCaseDetail.id, caseInserted.casenumber,'Success',null);  
                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(caseReturn));
            }
            catch(Exception e)  // exception handling
            {
                System.debug('The following exception has occurred: '+e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
                errMessage = e.getMessage();
                CaseResponse caseReturn = new CaseResponse(null,null,'Failure',errMessage);
                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(caseReturn));
                //return JSON.serialize(caseReturn);
            }
            
            }
            //return JSON.serialize(caseReturn);
        }
        else if(caseDetail.caseNumber!=null && caseDetail.updationType =='Accept-Reject')
        {
            Case updateCase = [select id,CaseNumber,Sub_Status__c,status,Comments__c,Rejection_Comments__c,description from Case where CaseNumber=:caseDetail.caseNumber];
            
            updateCase.status = caseDetail.status;
            updateCase.Rejection_Comments__c = caseDetail.comments;
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
       //public String honeywellID;
       public String contractType;
       //public string subject;
       public string description;
       public String classification;
       public string comments;
       public String recordtypeName;
       public String subStatus;
       public String ownerQueue;
       public String leadSource;     
       public String status;
       public String caseID;
       public String caseNumber;
       public String quotePrice;
       public string dealerName;
       public string operatorName;
       public string aircraftMake; 
       public string aircraftModel;
       public string aircraftTail;
       public String aircraftSerialNumber;
       public String notes;
       public String quotenumber;
       public String quoteValidDate;
       public String attachmentDetail;
       public String attachmentName;
       public String dealerContact;
       public String updationType;
             
       public CaseDetailRecord()
       {
            
       }
    }

}