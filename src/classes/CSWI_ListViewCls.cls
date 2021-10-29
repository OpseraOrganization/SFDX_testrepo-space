public with sharing class CSWI_ListViewCls {
    public Customer_Specific_Work_Instruction__c cswi {get; set;}
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
    public List<Customer_Specific_Work_Instruction__c> AllSearchcase   
    {  
        get  
        {  
            if(cs != null)  
                return (List<Customer_Specific_Work_Instruction__c>)cs.getRecords();  
            else  
                return null;  
        }  
        set;} 
     
      public ApexPages.StandardSetController cs {
        get {
            if(cs == null) {
            id uid = userinfo.GetUserid();
                cs = new ApexPages.StandardSetController(Database.getQueryLocator([select id,Accept_Exchanges__c,Customer_Name__c,Brief_Overview_of_Contract__c,Contract_Flow_Down_Document__c,Contract_ID__c,Customer_Code__c,Damage__c,Fixed_Price__c,Active__c,Fixed_Pricing__c,iMany__c,NFF__c,Overall_Discount__c,Send_Quotes_To__c,Special_Instructions__c,Special_Labor_Rate__c,Special_Modification_Charge__c,Name,ownerid,Accept_HON_DER__c,Additive_Overhaul_Fee__c,Warranty__c,Zero_Dollar_Quotes__c,CreatedDate from Customer_Specific_Work_Instruction__c where Active__c=true ORDER BY CreatedDate Limit 10000]));
                cs.setPageSize(15);
            }
            return cs;
        }
        set;
    }
    
    public CSWI_ListViewCls() { 
        AllSearchcase = new List<Customer_Specific_Work_Instruction__c>() ; 
        cswi = new Customer_Specific_Work_Instruction__c() ;  
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
       cs = new ApexPages.StandardSetController(Database.getQueryLocator('select id,Accept_Exchanges__c,Customer_Name__c,Brief_Overview_of_Contract__c,Contract_Flow_Down_Document__c,Contract_ID__c,Customer_Code__c,Damage__c,Fixed_Price__c,Active__c,Fixed_Pricing__c,iMany__c,NFF__c,Overall_Discount__c,Send_Quotes_To__c,Special_Instructions__c,Special_Labor_Rate__c,Special_Modification_Charge__c,Name,ownerid,Accept_HON_DER__c,Additive_Overhaul_Fee__c,Warranty__c,Zero_Dollar_Quotes__c,CreatedDate from Customer_Specific_Work_Instruction__c where Active__c=true ORDER BY ' + sortFullExp + ' NULLS Last Limit 10000 '));
       cs.setPageSize(15);
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