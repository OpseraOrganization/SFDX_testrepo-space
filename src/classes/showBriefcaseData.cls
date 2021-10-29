Public class showBriefcaseData{

     @auraEnabled
     
     public static List<ContentVersion> allContentDocBrfcseOthers {get;set;}
     public static List<ContentVersion> allContentDocExternalLink {get;set;}
     public static List<ContentVersion> allContentDocMisc {get;set;}
     public static String LibraryName {get;set;}
               
    public static list<ContentVersion> getAllContentDoc() {
    
        Id talId = ApexPages.currentPage().getParameters().get('docId');
        List<ContentDocumentLink> getContentDoc = [SELECT Id, 
                                                          LinkedEntityId, 
                                                          ContentDocumentId 
                                                   FROM ContentDocumentLink 
                                                   WHERE ContentDocumentId =:talId LIMIT 1];
        //String LibraryName = getContentDoc[0].LinkedEntity.Name;
        allContentDocBrfcseOthers = new List<ContentVersion >();
        allContentDocExternalLink = new List<ContentVersion >();
        allContentDocMisc = new List<ContentVersion >();       
        List<ContentVersion> allContentDoc = new List<ContentVersion >();
        
          ContentVersion Contentv;       
            if(getContentDoc.size()>0){
                Set<Id> contDocId = new Set<id>();
                List<ContentDocumentLink> allContentDocL = [SELECT Id,
                                                                   LinkedEntityId,
                                                                   LinkedEntity.Name, 
                                                                   ContentDocumentId 
                                                            FROM ContentDocumentLink 
                                                            WHERE LinkedEntityId =:getContentDoc[0].LinkedEntityId
                                                           ];
                LibraryName = allContentDocL[0].LinkedEntity.Name;
                                        
                for(ContentDocumentLink cdl : allContentDocL){
                    contDocId.add(cdl.ContentDocumentId);                
                }
            
            for(ContentVersion cv : [SELECT Brightcove_Path__c,
                                             Group_By__c,Document_Type__c,
                                             SBU__c,URL__c,ContentModifiedDate,
                                             ContentDocumentId,ContentUrl,
                                             ContentSize,Description,
                                             FeaturedContentDate,
                                             FileExtension,FileType,
                                             Id,IsLatest,
                                             IsMajorVersion,CreatedDate,
                                             TextPreview,Title 
                                     FROM ContentVersion
                                     WHERE ContentDocumentId =: contDocId 
                                     AND Group_BY__c IN ('Briefcase Primary','Briefcase Other Files','External Link','Misc') 
                                     AND  FileExtension!='zip' 
                                     AND IsLatest = true ORDER 
                                     BY Group_BY__c ASC, Title ASC NULLS LAST]){
                Contentv = new ContentVersion();
                
                string baseUrl = URL.getSalesforceBaseUrl().toExternalForm(); 
                Contentv.PreviewLink__c = baseUrl+'/lightning/r/ContentDocument/'+cv.ContentDocumentId+'/view';
                Contentv.ContentDocumentId = cv.ContentDocumentId;                
                Contentv.SBU__c = cv.FileExtension;
                Contentv.Title = cv.Title;
                Contentv.Document_Type__c= cv.Document_Type__c;
                //Contentv.getFileType= cv.FileType;
                //Contentv.SBU__c = cv.SBU__c;
                //Contentv.ContentUrl = cv.ContentUrl; // Existing field ref
                Contentv.URL__c = cv.URL__c;
                Contentv.Description= String.valueOf(cv.ContentSize/1024) +' KB';
                Contentv.Group_BY__c= cv.Group_BY__c;
                Contentv.Brightcove_Path__c = 'sfc/servlet.shepherd/version/download/'+cv.Id+'?asPdf=false&operationContext=CHATTER';
                Contentv.CreatedDate= cv.CreatedDate;
                                
                if(cv.Group_BY__c == 'Briefcase Primary'){                    
                    allContentDoc.add(Contentv);
                }else if(cv.Group_BY__c == 'Briefcase Other Files'){
                    allContentDocBrfcseOthers.add(Contentv);
                }else if(cv.Group_BY__c == 'External Link'){
                    allContentDocExternalLink.add(Contentv);
                }else{
                    allContentDocMisc.add(Contentv);
                }                
                             
            }
        }
        return allContentDoc;
    }
}