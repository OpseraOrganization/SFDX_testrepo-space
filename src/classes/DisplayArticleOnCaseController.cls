/*
Created By : Shwetha Penumalla
Created Date : 29-April-2020
Usages : This Controller is for the VF page DisplayArticleOnCase to get the Articles associated with the Case on Case Quality record    
*/
public class DisplayArticleOnCaseController {
    
    public static string recordID {get;set;}
    public static List<Knowledge__kav> articleList {get;set;}
    
    public DisplayArticleOnCaseController(ApexPages.StandardController controller){
        recordID = ApexPages.currentPage().getparameters().get('id');
    }
    
    public static void DisplayArticles(){
       articleList = new List<Knowledge__kav>();
       Case_Quality_Audit__c qualityRecord = new Case_Quality_Audit__c();
     qualityRecord = [Select id,Case__c from Case_Quality_Audit__c where id =:recordId];
      articleList = [Select id,Title,URLName,Summary from Knowledge__kav where ID IN (SELECT KnowledgeArticleVersionId FROM CaseArticle
    WHERE CaseId =: qualityRecord.Case__c)];
         /*articleList = [Select id,Title,URLName,Summary from Knowledge_Article__kav where ID IN (SELECT KnowledgeArticleVersionId FROM CaseArticle
    WHERE CaseId = '500K000000HHZcB')];*/
        system.debug('articleList==' +articleList);                                  
        
    }
}