public with sharing class DSPC_Myrecord_Controller 
{
  public list<Opportunity> opplist{get;set;}
  public list<lead>leadlist{get;set;}
  public boolean showboolean{get;set;}
  public boolean showmoreopp{get;set;}
  public DSPC_Myrecord_Controller ()
  {
     showboolean = true;
     showmoreopp = true;
     opplist= new list<opportunity>();
     set<Opportunity>opplist1=new set<Opportunity>();
     opplist=[select id,Name,AccountId,StageName,CloseDate,Amount,Createddate  from Opportunity 
              where OwnerId=:Userinfo.getUserId()and StageName!='Closed' ORDER BY CloseDate ASC NULLS LAST limit 5];
     leadlist= new list<lead>();
     leadlist=[select id,name,Company,Email,Status,Createddate  from lead where ownerId=:Userinfo.getuserId()and Status !='Completed'ORDER BY Createddate DESC NULLS LAST LIMIT 5];
  }
  public void showmore() {
      leadlist=[select id,name,Company,Email,Status,Createddate  from lead where ownerId=:Userinfo.getuserId()and Status !='Completed'ORDER BY Createddate DESC NULLS LAST LIMIT 10];
      showboolean = false;
  }
  public void showmoreopps() {
       opplist=[select id,Name,AccountId,StageName,CloseDate,Amount,Createddate  from Opportunity 
              where OwnerId=:Userinfo.getUserId()and StageName!='Closed' ORDER BY CloseDate ASC NULLS LAST limit 10];
      showmoreopp = false;    
  }
}