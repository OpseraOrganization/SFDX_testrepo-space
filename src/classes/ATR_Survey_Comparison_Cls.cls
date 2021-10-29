/** * File Name: ATR_Survey_Comparison_Cls 
* Description :To show the comparision survey result in Account
* Copyright : NTTDATA 2015 *
 * @author : NTTDATA
 * Modification Log =============================================================== Ver Date Author Modification --- ---- ------ -------------*
**/ 
public with sharing class ATR_Survey_Comparison_Cls {
private final Account acc;
public String posId;
    public Feedback__c fb{get; set;}   
    Private String sortExp = 'name';
    Private String sortDirection = 'ASC';
    public String sortExpression {
    get
    {
       return sortExp;
    }
    set
    {
      if (value == sortExp)
        sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
      else
        sortDirection = 'ASC';
        sortExp = value;
    }
   }
    public List<Feedback__c> AllSearchcase   
    {  
        get  
        {  
            if(cs != null)  
                return (List<Feedback__c>)cs.getRecords();  
            else  
                return null;  
        }  
        set;} 
     public ATR_Survey_Comparison_Cls (ApexPages.StandardController controller) {
       
        this.acc= (Account)controller.getRecord();
        posId= this.acc.Id; 
        //posId= '0013000000bFxi9';
        }
      public ApexPages.StandardSetController cs {
        get {
            
            if(cs == null) {
            
            //id uid = userinfo.GetUserid();
                cs = new ApexPages.StandardSetController(Database.getQueryLocator([select Consolidated_score_Rating__c,Customer_Overall_Satisfaction_Metric_IND__c,Product_Category__c,ATR_Survey_Group__c,Year__c,Quarter__c,id,name,
           Reliability_Metric_IND__c,Service_Support_Metric_IND__c,Repair_Performance_IND__c,Spares_Performance_IND__c,Communication_IND__c 
           from Feedback__c  where recordtypeid=:label.ATR_VOC_Record_Type and account__c=:posId order by createddate desc Limit 10000]));
                cs.setPageSize(10);
            }
            return cs;
        }
        set;
    }
    
    public ATR_Survey_Comparison_Cls () { 
        AllSearchcase = new List<Feedback__c>() ; 
        fb = new Feedback__c() ;  
    }
    
    public String getSortDirection() {
    //if not column is selected 
    if (sortExpression == null || sortExpression == '')
      return 'ASC';
    else
     return sortDirection;
    }
    
    public void setSortDirection(String value) {  
        sortDirection = value;
    }
    
    public void ViewData() {
       string sortFullExp = sortExpression  + ' ' + sortDirection;     
       
       try {
       String tempStr = 'select Consolidated_score_Rating__c,Customer_Overall_Satisfaction_Metric_IND__c,Product_Category__c,ATR_Survey_Group__c,Year__c,Quarter__c,id,name,' +
               'Reliability_Metric_IND__c,Service_Support_Metric_IND__c,Repair_Performance_IND__c,Spares_Performance_IND__c,Communication_IND__c '+
               'from Feedback__c  where recordtypeid=:label.ATR_VOC_Record_Type and account__c=:posId order by ';
           cs = new ApexPages.StandardSetController(Database.getQueryLocator(tempStr  + sortFullExp + ' NULLS Last Limit 10000 '));
           cs.setPageSize(10);
       }
       catch (exception e) {
           system.debug('An Unexpected Error has occured'+e);
       }
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