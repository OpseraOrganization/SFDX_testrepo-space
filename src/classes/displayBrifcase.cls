public class displayBrifcase {
    @AuraEnabled
    public static brifcaseDocWrapper fetchContent(ID talId) {
        ContentVersion CV;
        ContentDistribution cd;
        system.debug('talId--'+talId);
        List<ContentDistribution> getContentDoc = [SELECT Id, DistributionPublicUrl, ContentDocumentId FROM ContentDistribution WHERE ContentDocumentId =:talId LIMIT 1];
        
        if(getContentDoc.size()==0 || Test.isRunningTest()){
            
            CV = [SELECT Id, Title FROM ContentVersion WHERE ContentDocumentId =:talId  AND IsLatest = true];            
            cd = new ContentDistribution();
            cd.name = CV.Title;
            cd.ContentVersionId = CV.Id;
            cd.PreferencesAllowOriginalDownload = false;
            cd.PreferencesAllowPDFDownload = false;
            cd.PreferencesAllowViewInBrowser = true;
            try{
            insert cd;
            }catch(Exception e){
                system.debug('Exception *****'+e.getMessage());
            }
        }
            
        brifcaseDocWrapper obj =  new brifcaseDocWrapper();
        obj.brifcaseDoc = [SELECT Id, DistributionPublicUrl, ContentDocumentId FROM ContentDistribution WHERE ContentDocumentId =:talId LIMIT 1];
        // return the wrapper class instance .
        obj.pageUrl = obj.brifcaseDoc[0].DistributionPublicUrl;
        return obj;
    }   
   
    // create a wrapper class with @AuraEnabled Properties    
    public class brifcaseDocWrapper {
        @AuraEnabled public List<ContentDistribution> brifcaseDoc {get;set;}
        @AuraEnabled public String pageUrl {get;set;}
    }
}