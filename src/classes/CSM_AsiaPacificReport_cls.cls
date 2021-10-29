//SCTASK1154614 - adithya - Deleted the field AC type in all the case queries as per this task.
public class CSM_AsiaPacificReport_cls {

    List<Id> caseids = new List<Id>();
    List<Id> caseids1 = new List<Id>();
    List<case> aprcases = new List<case>();string serverUrl;
    
    public CSM_AsiaPacificReport_cls(ApexPages.StandardController controller) {

        aprcases = [select OpenTask__c,Description,id,CSM_Senior_Escalation__c,CaseNumber,CSM_CSM__c,
        CSM_CSM__r.name,Account_Name__c,CSM_Category__c, CSM_Site_Name__c,Status, 
        SPEX_Exchange__c,Product_Number__c,Program_Description__c,Product_Description__c from Case
         where ( Status ='Open' or (Status= 'Closed' and (ClosedDate = yesterday or ClosedDate = TODAY))) 
         and Case_Record_Type__c = 'CSM Toolbox' and CSM_Region__c = 'Asia/Pacific Rim' 
         and  CSM_Feedback_Case__c = false and (lastmodifieddate = TODAY OR lastmodifieddate = YESTERDAY ) 
         and createddate = LAST_N_DAYS:14
         ORDER BY CSM_Senior_Escalation__c DESC];
       
        for(integer i=0;i<aprcases.size();i++) {
        caseids1.add(aprcases[i].Id);
            aprcases[i].OpenTask__c=false;
            integer  taskcount=0;
            taskcount=[Select count() from Task where whatid =:aprcases[i].Id and (lastmodifieddate = TODAY OR lastmodifieddate = YESTERDAY )];
            if(taskcount>0)
            aprcases[i].OpenTask__c=true;
            caseids.add(aprcases[i].Id);
              
        }
        
    }
   
    public List<Case> getaprrecords() {
    //amercases = [select Description,id,CSM_Senior_Escalation__c,CaseNumber,CSM_CSM__c,CSM_CSM__r.name,Account_Name__c,CSM_Category__c, CSM_Site_Name__c,Product_Part_Number__c,Status  from Case where ( Status ='Open' or (Status= 'Closed' and ClosedDate = yesterday)) and Case_Record_Type__c = 'CSM Toolbox' and CSM_Region__c = 'Americas' and  CSM_Feedback_Case__c = false and (lastmodifieddate = TODAY OR lastmodifieddate = YESTERDAY ) ];
       return aprcases;
    }

    public String getserverUrl() {
        serverUrl = URL.getSalesforceBaseUrl().toExternalForm() +'/';
        return serverUrl;
    }
    
    List<Task> ctasks = new List<Task>();
    List<List<Task>> cids = new List<List<Task>>();
       List<Products_CSM_Toolbox_Case__c> cproducts = new List<Products_CSM_Toolbox_Case__c>();
    List<List<Products_CSM_Toolbox_Case__c>> pids = new List<List<Products_CSM_Toolbox_Case__c>>();
  
/*cids[ integer.valueOf(t.whatid) ].add(t);*/
  
    public List<List<Task>> getids() {              
        return cids;
    }
     
    public List<Task> gettasks() {  
        ctasks = [select id,status,ACTIVITY_NUMBER__C,ownerid,description,whatid,Owner_Name__c,Description__c,ActivityDate,Completed_Date__c,Subject,Resolution__c  from Task where whatid in :caseids and (lastmodifieddate = TODAY OR lastmodifieddate = YESTERDAY ) ];
        return ctasks;    
    }
      public List<Products_CSM_Toolbox_Case__c> getproducts() {  
        cproducts=[Select Case__c,Product__r.Product_Number__c,Product__r.Description from Products_CSM_Toolbox_Case__c where Case__c =:caseids1];
            //if(productcoun>0)
        return cproducts;    
    }
    
    public boolean getshowcases() {
        if(aprcases.size()>0) {
            return true;
        }
        else {
            return false;
        }
    }
}