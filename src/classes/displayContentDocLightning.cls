/***********************************************************************************************
Name:                   displayContentDocLightning
Author:                 Satya Mohanty
Created Date:           12/2/2018
Use Case:               This class  is been used showbriefcaselightning component to display briefcase list view
                        OWNED BY THE CRM SALES TEAM.
************************************************************************************************/
public class displayContentDocLightning {
    @AuraEnabled
    public static list<ContentVersion> fetchContentData(ID talId) {
        List<ContentDocumentLink> getContentDoc = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE ContentDocumentId =:talId LIMIT 1];
        List<ContentVersion> allContentDoc = new List<ContentVersion >();
        ContentVersion Contentv;
        if(getContentDoc.size()>0){
            Set<Id> contDocId = new Set<id>();
            List<ContentDocumentLink> allContentDocL = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:getContentDoc[0].LinkedEntityId];
            for(ContentDocumentLink cdl : allContentDocL){
                contDocId.add(cdl.ContentDocumentId);
            }
            for(ContentVersion cv : [SELECT Brightcove_Path__c,SBU__c,ContentSize,ContentDocumentId,ContentUrl,Description,FeaturedContentDate,FileExtension,FileType,Id,IsLatest,IsMajorVersion,TextPreview,Title,ContentModifiedDate,LastModifiedDate,LastModifiedBy.Name,LastModifiedById FROM ContentVersion WHERE ContentDocumentId =: contDocId AND IsLatest = true  order by Title  ASC NULLS LAST]){
                if(cv.ContentSize >0){
                    Contentv = new ContentVersion();
                    Contentv.ContentDocumentId = cv.ContentDocumentId;
                    Contentv.Description = cv.FileExtension;
                    Contentv.Title = cv.Title;
                    Contentv.SBU__c = cv.SBU__c;
                    Contentv.ContentUrl = String.valueOf(cv.ContentSize/1024) +' KB';
                    Contentv.Brightcove_Path__c = '/sfc/servlet.shepherd/version/download/'+cv.Id+'?asPdf=false&operationContext=CHATTER';
                    Contentv.ContentModifiedDate = cv.ContentModifiedDate;
                    // Contentv.PathOnClient = cv.LastModifiedBy.Name;
                    allContentDoc.add(Contentv);
                }
            }
        }
        System.debug('allContentDoc====='+allContentDoc);
        return allContentDoc;
    }
}