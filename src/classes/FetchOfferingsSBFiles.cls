public class FetchOfferingsSBFiles {
   
    public static string SBFiles;
    public static map<string,string> filePathMap {get;set;}
   
    @InvocableMethod
    public static void processRequest(List<String> OfferingID){
        filePathMap = new map<string,string>();
        for(RMU_VALUE__c offering:[select Bulletins__c, Briefcase_Path__c from RMU_VALUE__c where id=:OfferingID]){
             string briefCasePath = offering.Briefcase_Path__c;
               if(briefCasePath != null && briefCasePath.contains('069')){
                 try{
                     string str = briefCasePath.substring(briefCasePath.indexof('069'),briefCasePath.indexof('069')+15);
                    // system.debug('Document id value:'+str);
                     
                     Id documentID = (id) str;
                     List<ContentDocumentLink> getContentDoc = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE ContentDocumentId =:str LIMIT 1];
                     if(getContentDoc.size()>0){
                        string linkedEnityID = getContentDoc[0].LinkedEntityId;
                         //system.debug('Linked Entity ID:'+linkedEnityID);
                         
                         Set<Id> contDocId = new Set<id>();
                         for(ContentDocumentLink cdl:[SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:linkedEnityID]){
                             contDocId.add(cdl.ContentDocumentId);
                         }
                         //System.debug('Content doc ID:'+contDocId);
                         
                         for(Contentversion cVersion: [select id,Title,FileType from Contentversion where ContentDocumentId=:contDocId AND (NOT contentversion.Title LIKE '%Service Bulletin%') AND (NOT contentversion.Title LIKE '%Sales Information Sheet%') AND (contentversion.Title LIKE '%Bulletin%') and IsLatest = true ORDER BY contentversion.Title ASC]){
                           string downloadURL = URL.getOrgDomainUrl().toExternalForm()+'/sfc/servlet.shepherd/version/download/'+cVersion.id+'?asPdf=false&operationContext=CHATTER';
                           filePathMap.put(cVersion.Title,downloadURL);
                                }    
                         
                      }
                     set<String>key= filePathMap.keyset();
                     //System.debug('Set'+key);
                     SBFiles ='';
                     If (filePathMap.keySet()!=null){
                         for(String k : filePathMap.keySet()){                          
                             //offering.HSB_Mulitiple_SBs__c = filePathMap.get(k);    
                             //system.debug(K+'='+ filePathMap.get(k)); 
                             SBFiles += '<a href="' + filePathMap.get(k) + '">' + k +'</a>;'+'<br/>';
                          }
                    }
                     offering.Bulletins__c = SBFiles;
                     Update offering;

                 }
                 catch(Exception e){
                     system.debug('Exception during string to ID converstion at NotifySMEOnOffering.'+e.getMessage()+' @Line number:'+e.getLineNumber());
                 }
             }
        }
    }

}