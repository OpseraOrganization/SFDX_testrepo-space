public class EmailMessagesPaginationController {
	
    @auraEnabled
    public static string previousMsg(id eMsgID){
        system.debug('entered to the method' + eMsgID);
        Id prevId;
        Id caseId;
        String prevURL;
        String statusMsg;
        for(EmailMessage obj: [SELECT ParentId FROM EmailMessage WHERE Id =:eMsgID])
            caseId = obj.ParentId;
        System.debug('caseId--'+caseId);
        List<Id> lstId = new List<Id>();
        for(EmailMessage obj: [SELECT Id FROM EmailMessage WHERE ParentId =:caseId ORDER BY MessageDate ASC])
            lstId.add(obj.Id);
        System.debug('lstId--'+lstId);
        Integer result = lstId.indexOf(String.valueOf(eMsgID));
        System.debug('result--'+result);
        if(result > 0){
            prevId = lstId.get(result-1);
        }
         String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        System.debug('In previousMsg');
        if(prevId!=null){
            prevURL = sfdcBaseURL+'/lightning/r/EmailMessage/'+prevId+'/view';
            return prevURL;
        }
        else
            statusMsg = 'No More Previous Emails.';
        return statusMsg;
    }
    @auraEnabled
    public static string NextMessage(id eMsgID){
        Id nextId;
        String nextURL;
         Id caseId;
        String statusMsg;
         for(EmailMessage obj: [SELECT ParentId FROM EmailMessage WHERE Id =:eMsgID])
            caseId = obj.ParentId;
        System.debug('caseId--'+caseId);
        List<Id> lstId = new List<Id>();
        for(EmailMessage obj: [SELECT Id FROM EmailMessage WHERE ParentId =:caseId ORDER BY MessageDate ASC])
            lstId.add(obj.Id);
        System.debug('lstId--'+lstId);
        Integer result = lstId.indexOf(String.valueOf(eMsgID));
        System.debug('result--'+result);
        if(result > 0){
            if(result < lstId.size()-1){
                nextId = lstId.get(result+1);
            } 
        }
        else if(result == 0 && lstId.size() > 1){
            nextId = lstId.get(result+1);
        }
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();    
        if(nextId!=null){
             nextURL = sfdcBaseURL+'/lightning/r/EmailMessage/'+nextId+'/view';
            return nextURL;
        } 
        else{
           statusMsg = 'None';
            return statusMsg;
        }
            
    }
}