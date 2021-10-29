/*  * File Name: WorkFlowSearchController
    * Description: Ability to search  workflows by multiple defined parameters.
    * Copyright : Wipro Technologies Limited Copyright (c) 2010
    * @author : wipro
    * Modification Log ===============================================================
      Ver Date Author Modification --- ---- ------ -------------*
     */
// Controller     
public with sharing class WorkFlowSearchController{

public WorkFlowSearchController(ApexPages.StandardController controller) 
  {
     soql = 'select id,Name,OwnerId,Wokflow_Name__c,Defence_Space_OE__c,Airlines__c,RACC__c,Defence_Space__c,HIS__c,ATR__c,BG_A_OE__c,HTSI__c,Customer_Name__r.name,Exposed_Cost__c,BG_A__c,Atlas_or_P_DR__c,Opportunity_Description__r.name,Platform__r.name,Sales_K__c, X5_Year_Revenue_K__c,Approval_Level_Required__c,Approval_Level_in_Progress__c,Status__c,CREATEDDATE from Workflow_details__c where Name!= null';
     runQuery();
  }
 
// the collection of Status Options to display 
public List<SelectOption> getStatusoptions() 
   {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('None','--None--'));        
      Schema.DescribeFieldResult fieldResult = Workflow_details__c.Status__c.getDescribe();
      List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
      for(Schema.PicklistEntry p : ple)
      options.add(new SelectOption(p.getValue(), p.getValue()));
      return options;
   }  

public pagereference getnavigation3()
   {
      String name;
      String str = System.currentPageReference().getParameters().get('name');
       If(str != Null)
        try{
            name= [Select id from workflow_details__c where ID =:str].Id;
           }catch(exception e){return null;}
      Pagereference p = new pagereference('/'+name);
      return p;
    }
  
private String soql {get;set;}
// the collection of Workflow detail records to display

public List<Workflow_details__c> work {get;set;}
 
// the current sort direction. defaults to asc
public String sortDir 
  {
     get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
     set;
  }
 
// the current field to sort by. defaults to last name
public String sortField 
  {
     get  { if (sortField == null) {sortField = 'Atlas_or_P_DR__c'; } return sortField;  
          }
     set;
  }

// format the soql for display on the visualforce page
public String debugSoql 
  {
     get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 30'; 
         }
     set;
  }
 
// toggles the sorting of query from asc<-->desc
public void toggleSort() 
  {
     // simply toggle the direction
     sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
     //run the query again
     runQuery();
  }
 
public date fromdate{get; set;}

// runs the actual query
public void runQuery() 
  {
     try 
        {
           work = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 30');
        } 
     catch (Exception e) 
        {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
        }
  }
 
// runs the search with parameters passed via Javascript

public PageReference runSearch() 
  {
     String cnam = Apexpages.currentPage().getParameters().get('cusname');
     String exp = Apexpages.currentPage().getParameters().get('exposed');
     String atp = Apexpages.currentPage().getParameters().get('atlas');
     String opp = Apexpages.currentPage().getParameters().get('opportunity');
     String plat = Apexpages.currentPage().getParameters().get('platform');
     String salesmin = Apexpages.currentPage().getParameters().get('salesmin');
     String salesmax = Apexpages.currentPage().getParameters().get('salesmax');
     String arlval= Apexpages.currentPage().getParameters().get('arlne');
     String BGAVal= Apexpages.currentPage().getParameters().get('BGA');
     String RACVal= Apexpages.currentPage().getParameters().get('RAC');
     String DefspceVal= Apexpages.currentPage().getParameters().get('Defspce');
     String HISVal= Apexpages.currentPage().getParameters().get('HIS');
     String ATRVal= Apexpages.currentPage().getParameters().get('ATR');
     String DefspceOEVal= Apexpages.currentPage().getParameters().get('DefspceOE');
     String BGAOEval= Apexpages.currentPage().getParameters().get('BGAOE');
     String HTSIVal= Apexpages.currentPage().getParameters().get('HTSI');
     String fiveyrmaxsalesmin = Apexpages.currentPage().getParameters().get('fiveyrmaxsalesmin');
     String fiveyrmaxsalesmax = Apexpages.currentPage().getParameters().get('fiveyrmaxsalesmax');
     String Statusval= Apexpages.currentPage().getParameters().get('Statusdtl');
     string FromdateVal= Apexpages.currentPage().getParameters().get('frmdate');
     string TodateVal= Apexpages.currentPage().getParameters().get('todate');
     
     system.debug('^^^^^^^^^^'+FromdateVal);
     system.debug('11^^^^^^^^^^'+TodateVal);
     soql ='select id,Name,OwnerId,Wokflow_Name__c,Defence_Space_OE__c,Airlines__c,RACC__c,Defence_Space__c,HIS__c,ATR__c,BG_A_OE__c,HTSI__c,Customer_Name__r.name,Exposed_Cost__c,BG_A__c,Atlas_or_P_DR__c,Opportunity_Description__r.name,Platform__r.name,Sales_K__c,X5_Year_Revenue_K__c,Approval_Level_Required__c,Approval_Level_in_Progress__c,Status__c,CREATEDDATE from Workflow_details__c where Name!= null' ;
     System.debug('+++++'+ Statusval);
     if ((!Statusval.equals(''))&& Statusval !='--None--')
        {
           system.debug('insideeeeeeeee'+Statusval);
           soql += ' and Status__c ='+'\''+Statusval+'\'';
        }
     
     if (!cnam.equals('')) 
        {
           soql += ' and Customer_Name__r.name LIKE \''+String.escapeSingleQuotes(cnam)+'%\'';
        }
    
     if (!exp.equals(''))
        {
           soql += ' and Exposed_Cost__c In('+ String.escapeSingleQuotes(exp)+')';
        } 
  
     if (!atp.equals(''))
        {
           soql += ' and Atlas_or_P_DR__c LIKE \''+String.escapeSingleQuotes(atp)+'%\'';
        }
      
     if (!opp.equals(''))
        {
           soql += ' and Opportunity_Description__r.name LIKE \''+String.escapeSingleQuotes(opp)+'%\'';
        }
    
      if(plat !=null)
      {
      if (!plat.equals(''))
        {
           soql += ' and Platform__r.name LIKE \''+String.escapeSingleQuotes(plat)+'%\'';      
        }    
      }
      
     if(salesmin!=null || salesmax !=null)
     {   
     if (!(salesmin.equals('') || salesmax.equals('')))
        {
           soql += ' and Sales_K__c >'+salesmin+ 'and Sales_K__c<'+salesmax;
        }
      }
              
     if (!(fiveyrmaxsalesmin.equals('') || fiveyrmaxsalesmax.equals('')))
        {
           soql += ' and X5_Year_Revenue_K__c >'+fiveyrmaxsalesmin+ 'and X5_Year_Revenue_K__c<'+fiveyrmaxsalesmax+'and ';
        }
     
     if(arlval.equals('True') || BGAVal.equals('True') || RACVal.equals('True') || DefspceVal.equals('True') || HISVal.equals('True') || ATRVal.equals('True') || BGAOEval.equals('True') || DefspceOEVal.equals('True') || HTSIVal.equals('True'))     
         soql += ' and ( ';       
         
     if (arlval.equals('True'))
        {
           boolean ARLTrue=True;
           
           soql += 'Airlines__c ='+ARLTrue;
           if(BGAVal.equals('True') || RACVal.equals('True') || DefspceVal.equals('True') || HISVal.equals('True') || ATRVal.equals('True') || BGAOEval.equals('True') || DefspceOEVal.equals('True') || HTSIVal.equals('True'))     
           soql += ' or ';
           system.debug('*****'+soql);
        }
     
     if (BGAVal.equals('True'))
        {
           boolean BGATrue=True;
           soql += 'BG_A__c ='+BGATrue;
           if(RACVal.equals('True') || DefspceVal.equals('True') || HISVal.equals('True') || ATRVal.equals('True') || BGAOEval.equals('True') || DefspceOEVal.equals('True') || HTSIVal.equals('True'))     
           soql += ' or ';
        } 
     
     if (RACVal.equals('True'))
        {
           boolean RACTrue=True;
           soql += 'RACC__c ='+RACTrue;
           if(DefspceVal.equals('True') || HISVal.equals('True') || ATRVal.equals('True') || BGAOEval.equals('True') || DefspceOEVal.equals('True') || HTSIVal.equals('True'))     
           soql += ' or ';
        } 
     
     if (DefspceVal.equals('True'))
        {
           boolean DefspceTrue=True;
           soql += 'Defence_Space__c ='+DefspceTrue;
           if(HISVal.equals('True') || ATRVal.equals('True') || BGAOEval.equals('True') || DefspceOEVal.equals('True') || HTSIVal.equals('True'))     
           soql += ' or ';
        } 
     
     if (HISVal.equals('True'))
        {
           boolean HISTrue=True;
           soql += 'HIS__c ='+HISTrue;
           if(BGAOEval.equals('True') || ATRVal.equals('True') || BGAOEval.equals('True') || DefspceOEVal.equals('True'))     
           soql += ' or ';
        } 
     
     if (ATRVal.equals('True'))
        {
           boolean ATRTrue=True;
           soql += 'ATR__c ='+ATRTrue;
           if(BGAOEval.equals('True') || DefspceOEVal.equals('True') || HTSIVal.equals('True'))     
           soql += ' or ';
        } 
        
     if (DefspceOEVal.equals('True'))
        {
           boolean DefspceOETrue=True;
           soql += 'Defence_Space_OE__c ='+DefspceOETrue;
           if(HTSIVal.equals('True') || BGAOEval.equals('True'))     
           soql += ' or ';
        } 
     
     if (BGAOEval.equals('True'))
        {
           boolean BGAOETrue=True;
           soql += 'BG_A_OE__c ='+BGAOETrue;
           if(HTSIVal.equals('True'))     
           soql += ' or ';
        } 
     
     if (HTSIVal.equals('True'))
        {
           boolean HTSITrue=True;
           soql += 'HTSI__c ='+HTSITrue;
        }    
      
     if(arlval.equals('True') || BGAVal.equals('True') || RACVal.equals('True') || DefspceVal.equals('True') || HISVal.equals('True') || ATRVal.equals('True') || BGAOEval.equals('True') || DefspceOEVal.equals('True') || HTSIVal.equals('True'))     
         soql += ')';         
            
      if (!FromdateVal.equals(''))
        {
           date frmdte= date.parse(FromdateVal);
           if(!TodateVal.equals(''))
           {
              date todte= date.parse(TodateVal);
              String fromday;
              String todaysday;
              String frommonth;
              String todaysmonth;
               
              if(frmdte.day() >=1 && frmdte.day() < 10)
                  fromday = '0'+String.valueof(frmdte.day());
              if(todte.day() >=1 && todte.day() < 10)
                  todaysday= '0'+String.valueof(todte.day());
              
              if(frmdte.month() >=1 && frmdte.month() < 10)
                  frommonth = '0'+String.valueof(frmdte.month());
              if(todte.month() >=1 && todte.month() < 10)
                  todaysmonth= '0'+String.valueof(todte.month());
    
             String fromdate;
              if(fromday != null){
               if(frommonth != null)
                   fromdate = frmdte.year() + '-' + frommonth + '-' + fromday +'T12:00:00Z'; 
               else
                   fromdate = frmdte.year() + '-' + frmdte.month() + '-' + fromday +'T12:00:00Z'; 
              }else{
                if(frommonth != null)
                   fromdate = frmdte.year() + '-' + frommonth + '-' + frmdte.day() +'T12:00:00Z'; 
               else
                   fromdate = frmdte.year() + '-' + frmdte.month() + '-' + frmdte.day() +'T12:00:00Z'; 
             }
             String todate;
              if(todaysday != null){
               if(todaysmonth != null)   
                  todate= todte.year() + '-' + todaysmonth + '-' + todaysday +'T12:00:00Z'; 
               else 
                   todate= todte.year() + '-' + todte.month() + '-' + todaysday +'T12:00:00Z'; 
              }else{
               if(todaysmonth != null)   
                  todate= todte.year() + '-' + todaysmonth + '-' + todte.day() +'T12:00:00Z'; 
               else 
                   todate= todte.year() + '-' + todte.month() + '-' + todte.day() +'T12:00:00Z'; 
              }
              soql += ' and CreatedDate>'+fromdate+' and CreatedDate<'+todate ;
           }
        }  
               
     // run the query again
     System.debug('+++++'+ soql);
     runQuery();
     return null;
  }
  
public pagereference exportexcel()
  {
     PageReference p = new PageReference('/apex/Workflow_detail_Export');
     return p;
  }   
  
}