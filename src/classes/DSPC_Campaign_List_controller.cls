public with sharing class DSPC_Campaign_List_controller {
    public Campaign cmp {get; set;}
    public List<Campaign> AllSearchcams  
    {  
        get  
        {  
            if(cam != null)  
                return (List<Campaign>)cam.getRecords();  
            else  
                return null ;  
        }  
        set;}
     public ApexPages.StandardSetController cam {
        get {
            if(cam == null) {
                cam = new ApexPages.StandardSetController(Database.getQueryLocator([select Id,IsActive,Name,Status,BudgetedCost,ActualCost,CampaignPrimarySBU__c,D_S_Campaign__c from Campaign where D_S_Campaign__c = true AND IsActive = true AND CampaignPrimarySBU__c =:'D&S']));
                cam.setPageSize(5);
            }
            return cam;
        }
        set;
    } 
    
    //Constructor
    public DSPC_Campaign_List_controller() {
        AllSearchcams = new List<Campaign>() ;  
        cmp = new Campaign() ;  
    }
    
    //Pagination functions
    public Boolean hasNext  
    {  
        get  
        {  
            return cam.getHasNext();  
        }  
        set;  
    }  
    
    public Boolean hasPrevious  
    {  
        get  
        {  
            return cam.getHasPrevious();  
        }  
        set;  
    }   
    public Integer pageNumber  
    {  
        get  
        {  
            return cam.getPageNumber();  
        }  
        set;  
    }  
    public void previous()  
    {  
        cam.previous();  
    }  
    public void next()  
    {  
        cam.next();  
    }  

}