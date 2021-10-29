global class BatchPegaEmailErrorHandler implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts
{
    String query = 'SELECT id,CC_Address__c,Email_Message_Id__c,From_Address__c,Html_Body__c,Pega_Case_Id__c,Sent__c,Subject__c,To_Address__c,Bcc_Address__c FROM PegaEmailServiceQueue__c';
    global BatchPegaEmailErrorHandler() {
    }
    global void execute(SchedulableContext SC) {
        BatchPegaEmailErrorHandler BatchPega = new BatchPegaEmailErrorHandler();
        Database.executeBatch(BatchPega,10);
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(this.query);
    }
    global void execute(Database.BatchableContext BC, List<PegaEmailServiceQueue__c> scope) {
        if(!scope.isEmpty()){
        List<PegaEmailServiceQueue__c> deleteList=new List<PegaEmailServiceQueue__c>();
        Map<String,PegaEmailServiceQueue__c> newMap= new  Map<String,PegaEmailServiceQueue__c>();
        for(PegaEmailServiceQueue__c pesq:scope){
           newMap.put(pesq.Email_Message_Id__c,pesq);  
           System.debug('New Map'+newMap);
        }
        List<Attachment> allAttachments=new List<Attachment>();
		allAttachments=[Select id,Body,ContentType,Name,ParentId,BodyLength
                                from Attachment where ParentId=:newMap.keySet()];
		Map<Id,List<Attachment>> attachMap=new Map<Id,List<Attachment>>();
		if(!allAttachments.isEmpty()){
		for (Attachment a : allAttachments) {
			if(a.BodyLength<=3200000){
				if (attachMap.containsKey(a.parentId)) {
					attachMap.get(a.parentId).add(a);
				} else {
					List<Attachment> mailList = new List<Attachment>();
					mailList.add(a);
					attachMap.put(a.parentId, mailList);
				}
			}
			} 
		}      
        for(PegaEmailServiceQueue__c pes:scope){
            PegaEmailRequestWrapper p = new PegaEmailRequestWrapper();
            p.CaseId=pes.Pega_Case_Id__c;
            List<PegaEmailRequestWrapper.CustomerEmail> pe=new List<PegaEmailRequestWrapper.CustomerEmail>();
            PegaEmailRequestWrapper.CustomerEmail pc= new PegaEmailRequestWrapper.CustomerEmail();
				pc.pytoString=pes.To_Address__c;
                datetime strDT= pes.Sent__c;
                string s = strDT.format('MMM dd, yyyy hh:mm:ss a');
                pc.pxSentDateTime=s;
                pc.pyFromUserId=pes.From_Address__c;
                pc.pyCCstring=pes.CC_Address__c;
                pc.pySubject=pes.Subject__c;
                pc.pyBody=pes.Html_Body__c;
                pc.PyBccString=pes.bcc_address__c;
            	List<PegaEmailRequestWrapper.AttachmentList> atlist=new List<PegaEmailRequestWrapper.AttachmentList>();
                if(!attachMap.isEmpty()){
                List<Attachment> attachList=AttachMap.get(pes.Email_Message_Id__c);  
                if(attachList!=null){
                for(Attachment a:attachList){
                    PegaEmailRequestWrapper.AttachmentList AttObj= new PegaEmailRequestWrapper.AttachmentList();
                     AttObj.pxAttachName=a.Name;
                     AttObj.pyAttachStream=EncodingUtil.base64Encode(a.Body);
                     atlist.add(AttObj);
                }
                }
                pc.AttachmentList=atlist;  
                System.debug('Pc'+pc.AttachmentList);
               }
        	pe.add(pc);
            p.CustomerEmail=pe;
            System.debug(p.customerEmail);
           	String emailBody=Json.serialize(p);
                HttpRequest req=new HttpRequest();
                req.setEndpoint(PegaService__c.getInstance('Endpoints').Email_To_Pega__c);
                req.setHeader('Content-Type','application/json');
                Blob headerValue = Blob.valueOf( PegaCredentials__c.getInstance('ServiceCredentials').Username__c+ ':' +PegaCredentials__c.getInstance('ServiceCredentials').Password__c );
                String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);
                req.setMethod('POST');
                req.setBody(emailBody);
                System.debug('Request: '+emailBody);
                Http h=new Http();
                HttpResponse res=h.send(req);
            	System.debug('Rsp:'+res.getBody());
            if(res.getStatusCode()==200){
                PegaEmailServiceQueue__c pegaQueueObj=newMap.get(pes.Email_Message_Id__c);
                deleteList.add(pegaQueueObj);
                System.debug('Delete List'+deleteList);
            }
        }
        if(!deleteList.isEmpty()){
            delete deleteList;
            
        }
         
    }
    }
    global void finish(Database.BatchableContext BC) {
        //TODO: add a record to custom log object
    }
}