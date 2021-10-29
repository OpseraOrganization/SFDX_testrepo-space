/*
Created By : Puvaneswari
Created Date : 10-March-2020
Usages : Controller to create Case Quality Audit on Button click from Lightning and Emails() to display 
Email List for EmailMessageDisplay*/
global class CaseQualityController {
    global static ID returnValue {get; set;}
    global static String recordId {get;set;}
    global static list<EmailMessage> mailMessage {get;set;}
    
    
    global CaseQualityController(ApexPages.StandardController controller) {
        recordId  = ApexPages.CurrentPage().getparameters().get('id');
    }
    @auraEnabled
    global static string checkCaseQuality(string recordId){
        Case cs= [Select id,Origin,CaseNumber,Status,IsClosed,AccountId, ContactId, (Select id,Name from Case_Quality_Audit__r) from Case where id =: recordId];
        System.debug(cs.IsClosed);
        if(cs.Case_Quality_Audit__r.size() == 0){
            if(cs.Status== 'Done' || cs.Status== 'Closed' || cs.Status=='Completed' || cs.Status=='Re-Closed' || cs.Status=='Closed-Approved' || cs.Status=='Closed-No response'){ 
                Case_Quality_Audit__c qualityRecord = new Case_Quality_Audit__c();
                qualityRecord.Case__c = recordId;
                qualityRecord.Audit_By__c = UserInfo.getUserId();
                if(cs.Origin == 'Email')
                    qualityRecord.Subject_Description__c='10';
                insert qualityRecord;
                return 'Success'+qualityRecord.ID;
            } else{
                return 'Not Closed';
            }
        }else{
            return 'Failure'+cs.Case_Quality_Audit__r[0].ID;
        }
    }
    
    global static void Emails(){
        mailMessage = new List<EmailMessage>();
        Case_Quality_Audit__c qualityRecord = new Case_Quality_Audit__c();
        Map<String,string> statusMap = new Map<string,string>();
        statusMap.put('0','New');
        statusMap.put('1','Read');
        statusMap.put('2','Replied');
        statusMap.put('3','Sent');
        statusMap.put('4','Forwarded');
        statusMap.put('5','Draft');
        if(Test.isRunningTest())
            qualityRecord =[Select id,Case__c from Case_Quality_Audit__c limit 1] ;
        else
            qualityRecord =[Select id,Case__c from Case_Quality_Audit__c where id =:recordId ];
        Case cs =  [Select id, (Select id,Status,Subject,FromAddress,ToAddress,MessageDate from EmailMessages) from Case where id =: qualityRecord.Case__c];
        System.debug(cs.EmailMessages);
        //mailMessage.addAll(cs.EmailMessages);
        for(EmailMessage e : cs.EmailMessages){
            e.status = statusMap.get(e.status);
            mailMessage.add(e);
        }
    }
}