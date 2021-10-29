//SCTASK1154614 - adithya - Deleted the field AC type in all the case queries as per this task.
public class CSM_EMEAReport_cls {
    List<Id> caseids = new List<Id>();
    List<Id> caseids1 = new List<Id>();
    List<Products_CSM_Toolbox_Case__c> cproducts = new List<Products_CSM_Toolbox_Case__c>();
    List<List<Products_CSM_Toolbox_Case__c>> pids = new List<List<Products_CSM_Toolbox_Case__c>>();
    string serverUrl;
    List<case> emeacases  =new List<case>();    
    List<case> emeaclosecases  =new List<case>();
    List<case> emeaopencases  =new List<case>();
    List<case> emeanewcases  =new List<case>();
    
    public CSM_EMEAReport_cls(ApexPages.StandardController controller) {
        emeacases = [select OpenTask__c,Description,id,CSM_Senior_Escalation__c,CaseNumber,CSM_CSM__c,CSM_CSM__r.name,
        Account_Name__c,CSM_Category__c, CSM_Site_Name__c,Status,Product_Number__c,
        Product_Description__c  from Case 
        where ( Status ='Open' or (Status= 'Closed' and (ClosedDate = yesterday or ClosedDate = TODAY))) 
        and Case_Record_Type__c = 'CSM Toolbox' and CSM_Region__c = 'EMEAI' and  CSM_Feedback_Case__c = false 
        //and (lastmodifieddate = TODAY OR lastmodifieddate = YESTERDAY )
        and createddate = LAST_N_DAYS:14 and createddate = TODAY
        ORDER BY CSM_Senior_Escalation__c DESC];
        
        emeaclosecases = [select OpenTask__c,Description,id,CSM_Senior_Escalation__c,CaseNumber,CSM_CSM__c,CSM_CSM__r.name,
        Account_Name__c,CSM_Category__c, CSM_Site_Name__c,Status,Product_Number__c,
        Product_Description__c  from Case 
        where ( (Status= 'Closed' and (ClosedDate = yesterday or ClosedDate = TODAY))) 
        and Case_Record_Type__c = 'CSM Toolbox' and CSM_Region__c = 'EMEAI' and  CSM_Feedback_Case__c = false 
        //and (lastmodifieddate = TODAY OR lastmodifieddate = YESTERDAY )
        and createddate = LAST_N_DAYS:14 and createddate != TODAY
        ORDER BY CSM_Senior_Escalation__c DESC];
        
        emeaopencases = [select OpenTask__c,Description,id,CSM_Senior_Escalation__c,CaseNumber,CSM_CSM__c,CSM_CSM__r.name,
        Account_Name__c,CSM_Category__c, CSM_Site_Name__c,Status,Product_Number__c,
        Product_Description__c  from Case 
        where ( Status ='Open') 
        and Case_Record_Type__c = 'CSM Toolbox' and CSM_Region__c = 'EMEAI' and  CSM_Feedback_Case__c = false 
        //and (lastmodifieddate = TODAY OR lastmodifieddate = YESTERDAY )
        and createddate = LAST_N_DAYS:14 and createddate != TODAY
        ORDER BY CSM_Senior_Escalation__c DESC];
       
        for(integer i=0;i<emeacases.size();i++) {
            caseids1.add(emeacases[i].Id);
            emeacases[i].OpenTask__c=false;
            integer  taskcount=0;
            taskcount=[Select count() from Task where whatid =:emeacases[i].Id and (lastmodifieddate = TODAY OR lastmodifieddate = YESTERDAY )];
            if(taskcount>0)
            emeacases[i].OpenTask__c=true;
            caseids.add(emeacases[i].Id);
        } 
        for(integer i=0;i<emeaclosecases.size();i++) {
            caseids1.add(emeaclosecases[i].Id);
            emeaclosecases[i].OpenTask__c=false;
            integer  taskcount=0;
            taskcount=[Select count() from Task where whatid =:emeaclosecases[i].Id and (lastmodifieddate = TODAY OR lastmodifieddate = YESTERDAY )];
            if(taskcount>0)
            emeaclosecases[i].OpenTask__c=true;
            caseids.add(emeaclosecases[i].Id);
        }
        for(integer i=0;i<emeaopencases.size();i++) {
            caseids1.add(emeaopencases[i].Id);
            emeaopencases[i].OpenTask__c=false;
            integer  taskcount=0;
            taskcount=[Select count() from Task where whatid =:emeaopencases[i].Id and (lastmodifieddate = TODAY OR lastmodifieddate = YESTERDAY )];
            if(taskcount>0)
            emeaopencases[i].OpenTask__c=true;
            caseids.add(emeaopencases[i].Id);
        }       
    }   
   public List<Case> getemearecords()
   {
        return emeacases;
   }
   public List<Case> getemeaclosecases()
   {
        return emeaclosecases;
   }
   public List<Case> getemeaopencases()
   {
        return emeaopencases;
   }
   List<Task> ctasks = new List<Task>();
  
   public List<TAsk> gettasks()
   { 
        ctasks = [select id,status,ACTIVITY_NUMBER__C,ownerid,description,whatid,Owner_Name__c,Description__c,ActivityDate,Completed_Date__c,Subject,Resolution__c from Task where whatid in :caseids and (lastmodifieddate = TODAY OR lastmodifieddate = YESTERDAY ) ];
        return ctasks;
   }
    public List<Products_CSM_Toolbox_Case__c> getproducts() {  
        cproducts=[Select Case__c,Product__r.Product_Number__c,Product__r.Description from Products_CSM_Toolbox_Case__c where Case__c =:caseids1];
                //if(productcoun>0)
        return cproducts;    
    } 
    public String getserverUrl()
    {
        serverUrl = URL.getSalesforceBaseUrl().toExternalForm() +'/';
        return serverUrl;
    }   
    public boolean getshowcases()
    {
        if(emeacases.size()>0) 
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    public boolean getclosedcases()
    {
        if(emeaclosecases.size()>0) 
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    public boolean getopencases()
    {
        if(emeaopencases.size()>0) 
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}