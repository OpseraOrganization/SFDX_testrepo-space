/***********************************************************************************************************
* Company Name          : NTT Data
* Name                  : CSWI Search 
* Description           : Customer Specific Work Instruction Community  
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* OCT-27-2014      1.1            NTTData               SR# INC000006645221- Code changes to include the Instruction fields and SFDC Contract ID
***********************************************************************************************************/

//SR#423466 - This class performs the search fuctionlity for the CSWI object 
public with sharing class CSWISearch {
public String Keywords{get;set;}
public string keyword1{get;set;}
public boolean showresult{get;set;}
public Customer_Specific_Work_Instruction__c SearchRecord{get;set;}
public List<Customer_Specific_Work_Instruction__c> objCuslist  {get;set;}
public List<Customer_Specific_Work_Instruction__c> objCuslist1  {get;set;}
public string strQuery{get;set;}
public String sortExp = 'name';
public String sortDirection = 'ASC';
public string strCondition;
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
    
        
    /*public CSWISearch() 
    {
    }*/
    public CSWISearch(ApexPages.StandardController controller) 
    {
        if(SearchRecord==null)
           SearchRecord=new Customer_Specific_Work_Instruction__c();
    }
    
    public ApexPages.StandardSetController con{get; set;}
    
    public List<Customer_Specific_Work_Instruction__c> WorkInstructions
    {
        get
        {
            if(con != null)
                return (List<Customer_Specific_Work_Instruction__c>)con.getRecords();
            else
                return null ;
        }
        set;
    } 
 
    public void searchform()
    {
        strQuery = '';
        List<string> resultstring=new List<string>();  
       
        strCondition = '';
        if ((keyword1 != null || keyword1 != '')  && (keywords != '' || keywords != null))        
        strCondition += 'Customer_Name__c Like \'%'+Keywords+ '%\'' + 'and  Customer_Code__c  like \'%'+ keyword1+ '%\'';
        else if (keyword1!=null && strCondition == '') 
        strCondition += 'Customer_Code__c   like \'%'+ keyword1+ '%\''; 
               
         /* commemted the lines for keyword1
             if (SearchRecord.Customer_Code__c != null && strCondition == '')        
                  strCondition += 'Customer_Code__c   like \'%'+ SearchRecord.Customer_Code__c+ '%\'';        
              else if (SearchRecord.Customer_Code__c != null && strCondition != '')        
                  strCondition += ' and  Customer_Code__c    like \'%'+ SearchRecord.Customer_Code__c+ '%\'';
        */     
       If (strCondition == '') {
          strQuery  = 'SELECT Id,Name,Customer_Name__c,Customer_Code__c,Contractt_ID__c,Contractt_ID__r.name,Contract_Number__c from Customer_Specific_Work_Instruction__c '+' where Active__C = true  and Customer_Name__c Like \'%'+Keywords+'%\''; }
       else {
          strQuery = 'SELECT Id,Name,Customer_Name__c,Customer_Code__c,Contractt_ID__c,Contractt_ID__r.name,Contract_Number__c  from Customer_Specific_Work_Instruction__c where Active__c = True and '+strCondition+' ORDER BY  name DESC limit 500 '; } 
              
       objCuslist  = new List<Customer_Specific_Work_Instruction__c>();        
     //  objCuslist  =  Database.Query(strQuery); 
       con = new ApexPages.StandardSetController(Database.getQueryLocator(strQuery));
       con.setPageSize(5);
       showresult = true;
                       
       objCuslist1   = new List<Customer_Specific_Work_Instruction__c>();        
       Customer_Specific_Work_Instruction__c objVOC ;       
               
       List<String> arlKeywordsand = new List<String>();        
       List<String> arlKeywordsor  = new List<String>();        
       List<String> arlKeywordsnot = new List<String>();
       
       String strKeywd = '';
       
       for(Integer inCnt = 0;inCnt < objCuslist.Size(); inCnt ++ )
        {
             objVOC  = objCuslist[inCnt];
            if(//(null != objVOC.Contractt_ID__c &&  objVOC.Contractt_ID__c.toLowercase().contains(Keywords.toLowercase())) 
                (null != objVOC.Contractt_ID__c &&  (objVOC.Contractt_ID__r!=null && objVOC.Contractt_ID__r.name.contains(Keywords.toLowercase()))) 
                || (null != objVOC.Customer_Name__c &&  objVOC.Customer_Name__c.toLowercase().contains(Keywords.toLowercase()))
                || (objVOC.Name!=null && objVOC.name.toLowercase().contains(Keywords.toLowercase())) 
                || (objVOC.Customer_Code__c!=null && objVOC.Customer_Code__c.toLowercase().contains(Keywords.toLowercase())))
               {
                  objCuslist1.add(objVOC);
               }
        }
       
        objCuslist = objCuslist1;
        if(objCuslist.size()>0)
            showresult=true;   
       // return null;
    }
 
    public pagereference backMethod()
    {
     Pagereference pg =  new Pagereference('/apex/CSWISearch'); 
     pg.setRedirect(true);
     return pg;
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
       strCondition = '';
       if ((keyword1 != null || keyword1 != '')  && (keywords != '' || keywords != null)) {        
           strCondition += 'Customer_Name__c Like \'%'+Keywords+ '%\'' + 'and  Customer_Code__c  like \'%'+ keyword1+ '%\'';
       }
       else if (keyword1!=null && keywords == '') {
           strCondition += 'Customer_Code__c   like \'%'+ keyword1+ '%\''; 
       }
       else if (keywords!=null && keyword1 == '') {
           strCondition += 'Customer_Name__c Like \'%'+Keywords+ '%\''; 
       }
       
       try {
       If (strCondition == '') {
           con = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT Id,Name,Customer_Name__c,Customer_Code__c,Contractt_ID__c,Contractt_ID__r.name,Contract_Number__c  from Customer_Specific_Work_Instruction__c where Active__c = true  and Customer_Name__c Like \'%'+Keywords+'%\' order by ' + sortFullExp + ' NULLS LAST limit 10000'));
       }
       else {
           con = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT Id,Name,Customer_Name__c,Customer_Code__c,Contractt_ID__c,Contractt_ID__r.name,Contract_Number__c  from Customer_Specific_Work_Instruction__c where Active__c = true  and '+strCondition+' order by ' + sortFullExp + ' NULLS LAST limit 10000'));           
       }
       con.setPageSize(5);
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
            return con.getHasNext();  
        }  
        set;  
    }      
    public Boolean hasPrevious  
    {  
        get  
        {  
            return con.getHasPrevious();  
        }  
        set;  
    }   
    public Integer pageNumber  
    {  
        get  
        {  
            return con.getPageNumber();  
        }  
        set;  
    }  
    public void previous()  
    {  
        con.previous();  
    }  
    public void next()  
    {  
        con.next();  
    }  
  }