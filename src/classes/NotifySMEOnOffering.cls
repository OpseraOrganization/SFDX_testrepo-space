Public class NotifySMEOnOffering{
    public string offeringID;
    public map<string,string> filePathMap {get;set;}
    
    public void setOfferingID(string offeringsID ){
        this.offeringID = offeringsID ;
        processRequest();
    }
    public string getOfferingID(){
        return offeringID;
    }
      
    public void processRequest(){
        filePathMap = new map<string,string>();
        for(RMU_VALUE__c offering:[select Briefcase_Path__c from RMU_VALUE__c where id=:offeringID]){
             string briefCasePath = offering.Briefcase_Path__c;
             if(briefCasePath != null && briefCasePath.contains('069')){
                 try{
                     string str = briefCasePath.substring(briefCasePath.indexof('069'),briefCasePath.indexof('069')+15);
                     system.debug('Document id value:'+str);
                     
                     Id documentID = (id) str;
                     List<ContentDocumentLink> getContentDoc = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE ContentDocumentId =:str LIMIT 1];
                     if(getContentDoc.size()>0){
                        string linkedEnityID = getContentDoc[0].LinkedEntityId;
                         Set<Id> contDocId = new Set<id>();
                         for(ContentDocumentLink cdl:[SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:linkedEnityID]){
                             contDocId.add(cdl.ContentDocumentId);
                         }
                         for(Contentversion cVersion: [select id,Title,FileType from Contentversion where ContentDocumentId=:contDocId and contentversion.Title like '%Sales Bulletin%' and IsLatest = true]){
                           string downloadURL = URL.getOrgDomainUrl().toExternalForm()+'/sfc/servlet.shepherd/version/download/'+cVersion.id+'?asPdf=false&operationContext=CHATTER';
                           filePathMap.put(cVersion.Title,downloadURL);
                       }                                
                     }
                                       
                 }catch(Exception e){
                     system.debug('Exception during string to ID converstion at NotifySMEOnOffering.'+e.getMessage()+' @Line number:'+e.getLineNumber());
                 }
             }
        }
        system.debug('filePathMap value:'+filePathMap);
    }
}