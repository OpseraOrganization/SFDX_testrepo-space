/*******************************************************************************
Name                :   DSFileUploadController
Created By          :   Suresh M
Company Name        :   NTT Data
Project             :   <Aero> 
Created Date        :   15-02-2021
Usages              :   RAPD-7951: Re-usable Lightning Component of File Updload      
Modification History
*******************************************************************************/
public class DSFileUploadController {
 	@AuraEnabled  
    public static List<ContentDocument> getFiles(String recordId){ 
        Set<Id> recordIds = new Set<Id>{recordId};
        List<ContentDocumentLink> cdlList = [SELECT Id, LinkedEntityId, ContentDocumentId FROM 
                                             ContentDocumentLink WHERE LinkedEntityId IN :recordIds
                                            ];                         
        Set<Id> documentIds = new Set<Id>(); 
        for(ContentDocumentLink cdl:cdlList){  
            documentIds.add(cdl.ContentDocumentId);  
        }    
        return [SELECT Id, Title, FileType,FileExtension FROM ContentDocument WHERE Id IN :documentIds];        
    } 
    
    @AuraEnabled  
    public static void deleteFile(String contentDocumentId){ 
        delete [SELECT Id from ContentDocument WHERE Id = :contentDocumentId];       
    }  
     public static void deleteAllFiles(String recordId){ 
       Set<Id> recordIds = new Set<Id>{recordId};
        List<ContentDocumentLink> cdlList = [SELECT Id, LinkedEntityId, ContentDocumentId FROM 
                                             ContentDocumentLink WHERE LinkedEntityId IN :recordIds
                                            ];                         
        List<ContentDocument> documentIds = new List<ContentDocument>(); 
        for(ContentDocumentLink cdl:cdlList){  
            documentIds.add(new ContentDocument(Id=cdl.ContentDocumentId));  
        }    
        database.delete(documentIds,false);
    }
}