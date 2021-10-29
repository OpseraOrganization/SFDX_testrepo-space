public with sharing class DSPC_Case_List_controller {
    public Case cas {get; set;}  
    public List<Case> AllSearchcase  
    {  
        get  
        {  
            if(cs != null)  
                return (List<Case>)cs.getRecords();  
            else  
                return null ;  
        }  
        set;} 
     
      public ApexPages.StandardSetController cs {
        get {
            if(cs == null) {
            id uid = userinfo.GetUserid();
                cs = new ApexPages.StandardSetController(Database.getQueryLocator([select Id,CaseNumber,Status,CreatedDate,Ownerid,Account_Name_web__c,Dealer_Distributor__c from Case where createdbyid =:uid Order by Status DESC]));
                cs.setPageSize(10);
            }
            return cs;
        }
        set;
    }
    public DSPC_Case_List_controller() {
     //   id uid = userinfo.GetUserid();
        AllSearchcase = new List<Case>() ;  
        cas = new Case() ;  
    }
    
    //Pagination functions
    public Boolean hasNext  
    {  
        get  
        {  
            return cs.getHasNext();  
        }  
        set;  
    }  
    
    public Boolean hasPrevious  
    {  
        get  
        {  
            return cs.getHasPrevious();  
        }  
        set;  
    }   
    public Integer pageNumber  
    {  
        get  
        {  
            return cs.getPageNumber();  
        }  
        set;  
    }  
    public void previous()  
    {  
        cs.previous();  
    }  
    public void next()  
    {  
        cs.next();  
    }  
}