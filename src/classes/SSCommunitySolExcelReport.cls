/** 
    * File Name: SSCommunitySolExcelReport 
    * Description: This class is used for exporting the Knowledge Articles 
    * @author : TCS-GTO Team
* */
public with sharing class SSCommunitySolExcelReport {
    public SSCommunitySolExcelReport() {}
   /* private String searchType;
    private String[] searchTypeArray;
    private String searchText;
    private String searchQuery;
    private string a;
    private string b;
    public List<Technical_Solutions__kav> kv{get;set;}
    */
    /** 
     * Constructor : initalized variables
    **/    
    
   /* public SSCommunitySolExcelReport(){ 
       searchType= String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('param1'));
       searchTypeArray=searchType.split(':');
       searchText= String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('param2'));
       a = 'Online';
       b = 'en_US';
       
       
       if(searchTypeArray[0]=='Technical_Solutions__kav')       
        populateRecord();       
    }*/
    
    /** 
      * Method Name: populateRecord
      * Description : This method used to fetch Solutions/Knowledge Article 
      * 
    **/  
   /* public void populateRecord(){
        searchQuery = 'FIND \'' + searchText+ '\' IN ALL FIELDS RETURNING Technical_Solutions__kav (Id, Title,Owner.Name,ArticleNumber,ArticleType,FirstPublishedDate,PublishStatus,Solution_Number__c,UrlName,VersionNumber, Summary,Model_Name__c,Aircraft_Type__c,Honeywell_Part_Number__c,ATA_Chapter__c,Article_Details_del__c,Solution_Title__c,FAQ__c,LastPublishedDate,LastModifiedById,KnowledgeArticleId   WHERE PublishStatus=\'' + a+ '\' and language=\'' + b+ '\')';
        
        List<LIST<Technical_Solutions__kav >> searchedResult = search.query(searchQuery);
        kv=searchedResult[0];
    }*/
    
    /** 
      * Method Name: populateCASRecord
      * Description : This method used to fetch CAS Message Knowledge Article 
      * 
    **/  
    
        
}