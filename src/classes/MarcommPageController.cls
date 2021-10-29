public with sharing class MarcommPageController 
{
  //public List<RecordType>  recList;
  public String Var01 { get; set; }
    public MarcommPageController () {
        Var01 = Apexpages.currentPage().getParameters().get('Var01');
    }
    
  public ApexPages.StandardSetController caseList {
        
        get {
            if(caseList == null) 
            {
                 
               // recList=new List<RecordType>();
              //  recList=[Select id,DeveloperName from RecordType where DeveloperName ='MarCom'];
               caseList = new         
                ApexPages.StandardSetController(Database.getQueryLocator(
              //  [SELECT Case_Number__c,OwnerName__c,Marcom__c,Status,Marcom_Created_Date__c,Marcom_Business__c,Marcom_Market__c,Marcom_Request_Timeline__c,Marcom_Audience__c,Marcom_Request_Region__c FROM Case where RecordTypeId=:recList[0].id and Status != 'Closed'  and CreatedById = :UserInfo.getUserId() order by  Marcom_Created_Date__c desc LIMIT 200]));
              [SELECT Name,CreatedDate,OwnerId,Marcom_SR_Status__c,Marcom_Business__c,Marcom_Market__c,Marcom_Request_Timeline__c,Marcom_Audience__c,Marcom_Request_Region__c FROM Marcom_Service_Request__c where CreatedById = :UserInfo.getUserId() order by  CreatedDate desc LIMIT 200]));
                
            }
            return caseList;
        }
        set;
    }
    
    
   
    public List<Marcom_Service_Request__c> getCases() {
         //return (List<Marcom_Service_Request__c>) caseList.getRecords();
         List<Marcom_Service_Request__c > newList=(List<Marcom_Service_Request__c >) caseList.getRecords();
         for(Marcom_Service_Request__c c: newList)
         {
            if(c.Marcom_SR_Status__c == 'null')
            {
              c.Marcom_SR_Status__c='Open';
            }
         }
            return newList;
    }  
    }