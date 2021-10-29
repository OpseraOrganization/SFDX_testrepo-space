public class  eGreen_sheet_Approval_edit{
list<Workflow_details__c> WFList = new list<Workflow_details__c>();
List<WorkFlow_Approval_History__c> ApproveobjRec=new List<WorkFlow_Approval_History__c>();
List<WorkFlow_Approval_History__c> Approveobj=new List<WorkFlow_Approval_History__c>();
list<string> suggesttierlst= new list<string>();
Workflow_details__c WFRec= new Workflow_details__c();
WorkFlow_Approval_History__c objComm = new WorkFlow_Approval_History__c();
WorkFlow_Approval_History__c objComm1 = new WorkFlow_Approval_History__c();
list<string> lstofAPP= new list<string>();
list<string> lstofAP= new list<string>();
list<string> lstofAPP2= new list<string>();
Save_As_Draft__c savendrftrec = new Save_As_Draft__c();
//list<Approver__c> Alist=new  list<Approver__c>();
list<Approver__c> Alist = new list<Approver__c>();

Set<ID> dupBusUser = new Set<ID>();
Set<ID> dupContUser = new Set<ID>();
Set<ID> dupFinUser = new Set<ID>();
Set<ID> dupMpmUser = new Set<ID>();
Set<ID> dupNotUser = new Set<ID>();
list<Approver__c> BusinessSort = new list<Approver__c>();
list<Approver__c> ContractSort = new list<Approver__c>();
list<Approver__c> FinanceSort = new list<Approver__c>();
list<Approver__c> MPMSort = new list<Approver__c>();
list<Approver__c> NotificationSort = new list<Approver__c>(); 


list<Approver__c> bus_app=new  list<Approver__c>();
list<Approver__c>con_app=new  list<Approver__c>();
list<Approver__c> fin_app=new  list<Approver__c>();
list<Approver__c>not_app=new  list<Approver__c>();
list<Approver__c>mpm_app=new  list<Approver__c>();
list<Approver__c> bus_app1=new  list<Approver__c>();
list<Approver__c> con_app1=new  list<Approver__c>();
list<Approver__c> fin_app1=new  list<Approver__c>();
list<Approver__c> mpm_app1=new  list<Approver__c>();
list<Approver__c> not_app1=new  list<Approver__c>();
Save_As_Draft__c saveAsDrft= new Save_As_Draft__c();
Map<id,Approver__c> SveAsMap= new Map<id,Approver__c>();
list<Approver__c> bus_selected=new  list<Approver__c>();
list<Approver__c>con_selected=new  list<Approver__c>();
list<Approver__c> fin_selected=new  list<Approver__c>();
list<Approver__c>mpm_selected=new  list<Approver__c>();
list<Approver__c> notification_selected=new  list<Approver__c>();
string user2;
List<WorkFlow_Approval_History__c> ApproveobjRec1=new List<WorkFlow_Approval_History__c>();
list<integer> intlist= new list<integer>();
boolean flag=false;
//List<SelectOption> options1 = new List<SelectOption>();
String region0, region1, region2,region3,region4;
Approver__c CurrApp = new Approver__c();

List<server_details__c> lstSrvDet= server_details__c.getall().values();
//System.debug('wwwwwwwwwwwww'+lstSrvDet);
string strSrvName=lstSrvDet[0].servername__c; 

public string status{get; set;}
public string Tier{get; set;}

Map<id,Approver__c> Applstbusiness= new Map<id, Approver__c>();

Map<id,Approver__c> ApplstContract= new Map<id, Approver__c>();
Map<id,Approver__c> ApplstFinance= new Map<id, Approver__c>();
Map<id,Approver__c> Applstmpm= new Map<id, Approver__c>();
Map<id,Approver__c> ApplstNotification= new Map<id, Approver__c>();

public id Wfid;
public id savenDrftId;
public  eGreen_sheet_Approval_edit(ApexPages.StandardController controller) {
 savenDrftId= System.currentPageReference().getParameters().get('id');
 savendrftrec =[select Workflow_details__r.id,Business_Approver1__c,Business_Approver2__c,Business_Approver3__c,Business_Approver4__c,Contract_Approvers1__c,Contract_Approvers2__c,Contract_Approvers3__c,Contract_Approvers4__c,Finance_Approver1__c,Finance_Approver2__c,Finance_Approver3__c,Finance_Approver4__c,Notification1__c,Notification2__c,Notification3__c,Notification4__c,Workflow_details__c,M_PM_Approver1__c,M_PM_Approver2__c,M_PM_Approver3__c,M_PM_Approver4__c,Business_Approver1_Id__c,Business_Approver2_Id__c,Business_Approver3_Id__c,Business_Approver4_Id__c,Contract_Approvers1_Id__c,Contract_Approvers2_Id__c,Contract_Approvers3_Id__c,Contract_Approvers4_Id__c,Finance_Approver1_Id__c,Finance_Approver2_Id__c,Finance_Approver3_Id__c,finance_Approver4_Id__c,M_PM_Approver1_Id__c,M_PM_Approver2_Id__c,M_PM_Approver3_Id__c,M_PM_Approver4_Id__c,Notification1_Id__c,Notification2_Id__c,Notification3_Id__c,Notification4_Id__c from Save_As_Draft__c where id=:savenDrftId];
   WFList=[select Documentum__c,Requester_s_Comments__c,Opportunity_Description__c, Airbus_c__c,Global__c,Airlines_c__c,Name,ATR_c__c,BG_A_OE_c__c,BG_A_c__c,Boeing_c__c,RACC_c__c,Defence_Space_c__c,Defence_Space_OE_c__c,HIS_c__c,HTSI_c__c,HTSI_OE_c__c,Approval_Level_in_Progress__c,ATR__c,Airlines__c,Ownerid,Business_Unit__c ,Sales_K__c,X5_Year_Revenue_K__c,Customer_Name__r.name,Front_End_Loss__c,Front_End_Loss_Max_Year__c,Exposed_Cost__c,Exposed_Cost_Max_Year_K__c,Terms_and_Conditions__c,Atlas_or_P_DR__c,Airbus__c,Status__c,BG_A__c,BG_A_OE__c,Boeing__c,Defence_Space__c,Defence_Space_OE__c,HIS__c,HTSI__c,HTSI_OE__c,RACC__c,Americas__c,APAC__c,EMEAI__c,Middle_East_APU_s_Only__c from Workflow_details__c where id=:savendrftrec.Workflow_details__r.id];
   status=WFList[0].Status__c;
   
   string progress_level=WFList[0].Approval_Level_in_Progress__c;
   list<string> p_level1=progress_level.split('Tier');
   string plevel='Tier'+p_level1[1];
  /************************* Checking for the region *******************************************/   
   if(WFList[0].Americas__c)
      region0='Americas';
   if(WFList[0].APAC__c)
      region1='APAC';
   if(WFList[0].Global__c)
      region2='Global';
   if(WFList[0].EMEAI__c)
      region3='EMEAI';
   if(WFList[0].Middle_East_APU_s_Only__c)
      region4='MiddleEast-APU only';

/********************************** Checking for the Tier level in progress *******************************/

/*************************************** Quering the required Approvers *****************************************/

      Alist=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where  Tier__c like:'%'+plevel  and (Region__c like:region0 or Region__c like:region1 or Region__c like:region2 or Region__c like:region3 or Region__c like:region4) and (Business_Unit__c like:WFList[0].Airbus_c__c or Business_Unit__c like:WFList[0].Airlines_c__c or  Business_Unit__c like:WFList[0].ATR_c__c or  Business_Unit__c like:WFList[0].BG_A_OE_c__c or  Business_Unit__c like:WFList[0].BG_A_c__c or  Business_Unit__c like:WFList[0].Boeing_c__c or  Business_Unit__c like:WFList[0].RACC_c__c or  Business_Unit__c like:WFList[0].Defence_Space_c__c or Business_Unit__c like:WFList[0].Defence_Space_OE_c__c or  Business_Unit__c like:WFList[0].HIS_c__c or  Business_Unit__c like:WFList[0].HTSI_c__c or  Business_Unit__c like:WFList[0].HTSI_OE_c__c )order by Approver_Name__r.name ];

     not_app1=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.name!= null order by Approver_Name__r.name];



for(integer j=0;j<Alist.size();j++)
  {
              if(Alist[j].Approver_type__c == 'Business Approver'){
                  //Applstbusiness.put(Alist[j].Approver_Name__r.id,Alist[j]);
                  if(!(dupBusUser.contains(Alist[j].Approver_Name__r.id))){
                      BusinessSort.add(Alist[j]);
                      dupBusUser.add(Alist[j].Approver_Name__r.id);    
                      system.debug('uuuuuuuu'+dupBusUser);
                  }    
                      system.debug('aaaaaaaa'+BusinessSort);
              }
                  
              if(Alist[j].Approver_type__c == 'Contract Approver'){
                  //ApplstContract.put(Alist[j].Approver_Name__r.id,Alist[j]);
                  if(!(dupContUser.contains(Alist[j].Approver_Name__r.id))){
                      ContractSort.add(Alist[j]);
                      dupContUser.add(Alist[j].Approver_Name__r.id);    
                  }    
                      system.debug('aaaaaaaa'+ContractSort);
              }
                  
              if(Alist[j].Approver_type__c == 'Finance Approver'){
                  //ApplstFinance.put(Alist[j].Approver_Name__r.id,Alist[j]);
                  if(!(dupFinUser.contains(Alist[j].Approver_Name__r.id))){
                      FinanceSort.add(Alist[j]);
                      dupFinUser.add(Alist[j].Approver_Name__r.id);    
                  }    
                      system.debug('aaaaaaaa'+FinanceSort);
              }
                  
              if(Alist[j].Approver_type__c == 'M&PM Approver' ){
                  //Applstmpm.put(Alist[j].Approver_Name__r.id,Alist[j]);
                  if(!(dupMpmUser.contains(Alist[j].Approver_Name__r.id))){
                      MPMSort.add(Alist[j]);
                      dupMpmUser.add(Alist[j].Approver_Name__r.id);    
                  }    
                      system.debug('aaaaaaaa'+MPMSort);     
              }
   }
   
   for(integer j=0;j<not_app1.size();j++)
       {
           //ApplstNotification.put(not_app1[j].Approver_Name__r.id,not_app1[j]);
           if(!(dupNotUser.contains(not_app1[j].Approver_Name__r.id))){
               NotificationSort.add(not_app1[j]);
               dupNotUser.add(not_app1[j].Approver_Name__r.id);    
           }
       }

 }
public Workflow_details__c getWFRec()
{
Wfrec=[select Documentum__c,Requester_s_Comments__c,Opportunity_Description__c, Airbus_c__c,Global__c,Airlines_c__c,Name,ATR_c__c,BG_A_OE_c__c,BG_A_c__c,Boeing_c__c,RACC_c__c,Defence_Space_c__c,Defence_Space_OE_c__c,HIS_c__c,HTSI_c__c,HTSI_OE_c__c,Approval_Level_in_Progress__c,ATR__c,Airlines__c,Ownerid,Business_Unit__c ,Sales_K__c,X5_Year_Revenue_K__c,Customer_Name__r.name,Front_End_Loss__c,Front_End_Loss_Max_Year__c,Exposed_Cost__c,Exposed_Cost_Max_Year_K__c,Terms_and_Conditions__c,Atlas_or_P_DR__c,Airbus__c,Status__c,BG_A__c,BG_A_OE__c,Boeing__c,Defence_Space__c,Defence_Space_OE__c,HIS__c,HTSI__c,HTSI_OE__c,RACC__c,Americas__c,APAC__c,EMEAI__c,Middle_East_APU_s_Only__c from Workflow_details__c where id=:savendrftrec.Workflow_details__r.id];
return Wfrec;

} 
 /***********************Business Approvers****************/
 //first picklist//
String LstVal1;

public string getoptions1()
{
  
  return LstVal1;
}
public void setoptions1(string LstVal1)
{
  
  this.LstVal1=LstVal1;
}
public list<SelectOption> getUserList1()
{
List<SelectOption> options1 = new List<SelectOption>();
boolean flag=False;
boolean flag1=False;
bus_selected=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.id=:savendrftrec.Business_Approver1_Id__c and Approver_type__c = 'Business Approver'];
if(bus_selected.size()>0)
options1.add(new SelectOption(bus_selected[0].id,bus_selected[0].Approver_Name__r.name));

 for(Approver__c apprs: BusinessSort)
  {
  if(savendrftrec.Business_Approver1__c!=apprs.Approver_Name__r.name)
  {
  
 if(savendrftrec.Business_Approver1__c==Null && flag1==False)
           {
          options1.add(new SelectOption('None','None'));
          flag1=True;
           }
          
          options1.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
 
  }
  }  
  if(flag1==False)
  {
  options1.add(new SelectOption('None','None'));
  }
return options1;
}

//end of first picklist//
//second picklist//
String LstVal2;

public string getoptions2()
{
  
  return LstVal2;
}
public void setoptions2(string LstVal2)
{
  
  this.LstVal2=LstVal2;
}
public list<SelectOption> getUserList2()
{
List<SelectOption> options2 = new List<SelectOption>();
boolean flag=False;
boolean flag1=False;
bus_selected=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.id=:savendrftrec.Business_Approver2_Id__c and Approver_type__c = 'Business Approver'];
if(bus_selected.size()>0)
options2.add(new SelectOption(bus_selected[0].id,bus_selected[0].Approver_Name__r.name));

 for(Approver__c apprs: BusinessSort)
  {
  if(savendrftrec.Business_Approver2__c!=apprs.Approver_Name__r.name)
  {
  
  if(savendrftrec.Business_Approver2__c==Null && flag1==False)
           {
          options2.add(new SelectOption('Optional','Optional'));
          flag1=True;
           }
          
          options2.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
 
  }
  }  
  if(flag1==False)
  {
  options2.add(new SelectOption('Optional','Optional'));
  }
return options2;
}
//end of second picklist//

//third picklist//
string Lstval3=savendrftrec.Business_Approver3__c;
public string getoptions3()
{
  
  return Lstval3;
}

public void setoptions3(string Lstval3)
{
     this.Lstval3=Lstval3;
} 
public list<SelectOption> getUserList3()
{
List<SelectOption> options3 = new List<SelectOption>();

boolean flag=False;
boolean flag1=False;
bus_selected=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.id=:savendrftrec.Business_Approver3_Id__c and Approver_type__c = 'Business Approver'];
if(bus_selected.size()>0)
options3.add(new SelectOption(bus_selected[0].id,bus_selected[0].Approver_Name__r.name));

 for(Approver__c apprs: BusinessSort)
  {
  if(savendrftrec.Business_Approver3__c!=apprs.Approver_Name__r.name)
  {
  
  if(savendrftrec.Business_Approver3__c==Null && flag1==False)
           {
          options3.add(new SelectOption('Optional','Optional'));
          flag1=True;
           }
          
          options3.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
 
  }
  }  
  if(flag1==False)
  {
  options3.add(new SelectOption('Optional','Optional'));
  }
return options3;
}
//end of third picklist//

//fourth picklist//
string Lstval4=savendrftrec.Business_Approver4__c;
public string getoptions4()
{
  
  return Lstval4;
}

public void setoptions4(string Lstval4)
{
     this.Lstval4=Lstval4;
}
 
public list<SelectOption> getUserList4()
{
List<SelectOption> options4 = new List<SelectOption>();


boolean flag=False;
boolean flag1=False;
bus_selected=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.id=:savendrftrec.Business_Approver4_Id__c and Approver_type__c = 'Business Approver'];
if(bus_selected.size()>0)
options4.add(new SelectOption(bus_selected[0].id,bus_selected[0].Approver_Name__r.name));

 for(Approver__c apprs: BusinessSort)
  {
  if(savendrftrec.Business_Approver4__c!=apprs.Approver_Name__r.name)
  {
  
  if(savendrftrec.Business_Approver4__c==Null && flag1==False)
           {
          options4.add(new SelectOption('Optional','Optional'));
          flag1=True;
           }
          
          options4.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
 
  }
  }  
  if(flag1==False)
  {
  options4.add(new SelectOption('Optional','Optional'));
  }
return options4;
}
//end of fourth picklist//
//**********************End of Business Approvers*******************//



/******** Contact Approvers *****/
//first picklist//
String LstVal1c;
public string getoptions1c()
{
  
  return LstVal1c;
}
public void setoptions1c(string LstVal1c)
{
  
  this.LstVal1c=LstVal1c;
}

public list<SelectOption> getUserList1c()
{
List<SelectOption> options1c = new List<SelectOption>();

boolean flag=False;
boolean flag1=False;
con_selected=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.id=:savendrftrec.Contract_Approvers1_Id__c and Approver_type__c = 'Contract Approver'];
if(con_selected.size()>0)
options1c.add(new SelectOption(con_selected[0].id,con_selected[0].Approver_Name__r.name));

 for(Approver__c apprs: ContractSort)
  {
  if(savendrftrec.Contract_Approvers1__c!=apprs.Approver_Name__r.name)
  {
  
  if(savendrftrec.Contract_Approvers1__c==Null && flag1==False)
           {
          options1c.add(new SelectOption('None','None'));
          flag1=True;
           }
          
          options1c.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
 
  }
  }  
  if(flag1==False)
  {
  options1c.add(new SelectOption('None','None'));
  }

return options1c;
}
//end of first picklist//

//second picklist
String LstVal2c;
public string getoptions2c()
{
  
  return LstVal2c;
}
public void setoptions2c(string LstVal2c)
{
  
  this.LstVal2c=LstVal2c;
}

public list<SelectOption> getUserList2c()
{
List<SelectOption> options2c = new List<SelectOption>();

boolean flag=False;
boolean flag1=False;
con_selected=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.id=:savendrftrec.Contract_Approvers2_Id__c and Approver_type__c = 'Contract Approver'];
if(con_selected.size()>0)
options2c.add(new SelectOption(con_selected[0].id,con_selected[0].Approver_Name__r.name));

 for(Approver__c apprs: ContractSort)
  {
  if(savendrftrec.Contract_Approvers2__c!=apprs.Approver_Name__r.name)
  {
  
  if(savendrftrec.Contract_Approvers2__c==Null && flag1==False)
           {
          options2c.add(new SelectOption('Optional','Optional'));
          flag1=True;
           }
          
          options2c.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
 
  }
  }  
  if(flag1==False)
  {
  options2c.add(new SelectOption('Optional','Optional'));
  }

return options2c;
}
//end of second picklist//

//Third picklist
String LstVal3c;
public string getoptions3c()
{
  
  return LstVal3c;
}
public void setoptions3c(string LstVal3c)
{
  
  this.LstVal3c=LstVal3c;
}

public list<SelectOption> getUserList3c()
{
List<SelectOption> options3c = new List<SelectOption>();

boolean flag=False;
boolean flag1=False;
con_selected=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.id=:savendrftrec.Contract_Approvers3_Id__c and Approver_type__c = 'Contract Approver'];
if(con_selected.size()>0)
options3c.add(new SelectOption(con_selected[0].id,con_selected[0].Approver_Name__r.name));

 for(Approver__c apprs: ContractSort)
  {
  if(savendrftrec.Contract_Approvers3__c!=apprs.Approver_Name__r.name)
  {
  
  if(savendrftrec.Contract_Approvers3__c==Null && flag1==False)
           {
          options3c.add(new SelectOption('Optional','Optional'));
          flag1=True;
           }
          
          options3c.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
 
  }
  }  
  if(flag1==False)
  {
  options3c.add(new SelectOption('Optional','Optional'));
  }

return options3c;
}
//End of third picklist//

//fourth picklist
String LstVal4c;
public string getoptions4c()
{
  
  return LstVal4c;
}
public void setoptions4c(string LstVal4c)
{
  
  this.LstVal4c=LstVal4c;
}

public list<SelectOption> getUserList4c()
{
List<SelectOption> options4c = new List<SelectOption>();

boolean flag=False;
boolean flag1=False;
con_selected=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.id=:savendrftrec.Contract_Approvers4_Id__c and Approver_type__c = 'Contract Approver'];
if(con_selected.size()>0)
options4c.add(new SelectOption(con_selected[0].id,con_selected[0].Approver_Name__r.name));

 for(Approver__c apprs: ContractSort)
  {
  if(savendrftrec.Contract_Approvers4__c!=apprs.Approver_Name__r.name)
  {
  
  if(savendrftrec.Contract_Approvers4__c==Null && flag1==False)
           {
          options4c.add(new SelectOption('Optional','Optional'));
          flag1=True;
           }
          
          options4c.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
 
  }
  }  
  if(flag1==False)
  {
  options4c.add(new SelectOption('Optional','Optional'));
  }

return options4c;
}
//end of foruth picklist//
//****************end of Contract approvers************//

/********Finance Approvers *****/
//first picklist
String LstVal1f;
public string getoptions1f()
{
  
  return LstVal1f;
}
public void setoptions1f(string LstVal1f)
{
  
  this.LstVal1f=LstVal1f;
}

public list<SelectOption> getUserList1f()
{
List<SelectOption> options1f = new List<SelectOption>();


boolean flag=False;
boolean flag1=False;
fin_selected=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.id=:savendrftrec.Finance_Approver1_Id__c and Approver_type__c = 'Finance Approver'];
if(fin_selected.size()>0)
options1f.add(new SelectOption(fin_selected[0].id,fin_selected[0].Approver_Name__r.name));

 for(Approver__c apprs: FinanceSort)
  {
  if(savendrftrec.Finance_Approver1__c!=apprs.Approver_Name__r.name)
  {
  
  if(savendrftrec.Finance_Approver1__c==Null && flag1==False)
           {
          options1f.add(new SelectOption('None','None'));
          flag1=True;
           }
          
          options1f.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
 
  }
  }  
  if(flag1==False)
  {
  options1f.add(new SelectOption('None','None'));
  }
return options1f;
}
//end of first picklist//

//second picklist
String LstVal2f;
public string getoptions2f()
{
  
  return LstVal2f;
}
public void setoptions2f(string LstVal2f)
{
  
  this.LstVal2f=LstVal2f;
}

public list<SelectOption> getUserList2f()
{
List<SelectOption> options2f = new List<SelectOption>();


boolean flag=False;
boolean flag1=False;
fin_selected=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.id=:savendrftrec.Finance_Approver2_Id__c and Approver_type__c = 'Finance Approver'];
if(fin_selected.size()>0)
options2f.add(new SelectOption(fin_selected[0].id,fin_selected[0].Approver_Name__r.name));

 for(Approver__c apprs: FinanceSort)
  {
  if(savendrftrec.Finance_Approver2__c!=apprs.Approver_Name__r.name)
  {
  
  if(savendrftrec.Finance_Approver2__c==Null && flag1==False)
           {
          options2f.add(new SelectOption('Optional','Optional'));
          flag1=True;
           }
          
          options2f.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
 
  }
  }  
  if(flag1==False)
  {
  options2f.add(new SelectOption('Optional','Optional'));
  }
return options2f;
}
//end of second picklist//

//Third picklist
String LstVal3f;
public string getoptions3f()
{
  
  return LstVal3f;
}
public void setoptions3f(string LstVal3f)
{
  
  this.LstVal3f=LstVal3f;
}

public list<SelectOption> getUserList3f()
{
List<SelectOption> options3f = new List<SelectOption>();


boolean flag=False;
boolean flag1=False;
fin_selected=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.id=:savendrftrec.Finance_Approver3_Id__c and Approver_type__c = 'Finance Approver'];
if(fin_selected.size()>0)
options3f.add(new SelectOption(fin_selected[0].id,fin_selected[0].Approver_Name__r.name));

 for(Approver__c apprs: FinanceSort)
  {
  if(savendrftrec.Finance_Approver3__c!=apprs.Approver_Name__r.name)
  {
  
  if(savendrftrec.Finance_Approver3__c==Null && flag1==False)
           {
          options3f.add(new SelectOption('Optional','Optional'));
          flag1=True;
           }
          
          options3f.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
 
  }
  }  
  if(flag1==False)
  {
  options3f.add(new SelectOption('Optional','Optional'));
  }
return options3f;
}
//end of third picklist

//fourth picklist
String LstVal4f;
public string getoptions4f()
{
  
  return LstVal4f;
}
public void setoptions4f(string LstVal4f)
{
  
  this.LstVal4f=LstVal4f;
}

public list<SelectOption> getUserList4f()
{
List<SelectOption> options4f = new List<SelectOption>();


boolean flag=False;
boolean flag1=False;
fin_selected=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.id=:savendrftrec.Finance_Approver4_Id__c and Approver_type__c = 'Finance Approver'];
if(fin_selected.size()>0)
options4f.add(new SelectOption(fin_selected[0].id,fin_selected[0].Approver_Name__r.name));

 for(Approver__c apprs: FinanceSort)
  {
  if(savendrftrec.Finance_Approver4__c!=apprs.Approver_Name__r.name)
  {
  
  if(savendrftrec.Finance_Approver4__c==Null && flag1==False)
           {
          options4f.add(new SelectOption('Optional','Optional'));
          flag1=True;
           }
          
          options4f.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
 
  }
  }  
  if(flag1==False)
  {
  options4f.add(new SelectOption('Optional','Optional'));
  }
return options4f;
}
//end of fourth picklist//

/***********************First for M&PM****************/
String LstVal1m;
public string getoptions1m()
{
  
  return LstVal1m;
}
public void setoptions1m(string LstVal1m)
{
  
  this.LstVal1m=LstVal1m;
}

public list<SelectOption> getUserList1m()
{
List<SelectOption> options1m = new List<SelectOption>();


boolean flag=False;
boolean flag1=False;
mpm_selected=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.id=:savendrftrec.M_PM_Approver1_Id__c and Approver_type__c = 'M&PM Approver'];
if(mpm_selected.size()>0)
options1m.add(new SelectOption(mpm_selected[0].id,mpm_selected[0].Approver_Name__r.name));

 for(Approver__c apprs: MPMSort)
  {
  if(savendrftrec.M_PM_Approver1__c!=apprs.Approver_Name__r.name)
  {
  
  if(savendrftrec.M_PM_Approver1__c==Null && flag1==False)
           {
          options1m.add(new SelectOption('None','None'));
          flag1=True;
           }
          
          options1m.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
 
  }
  }  
  if(flag1==False)
  {
  options1m.add(new SelectOption('None','None'));
  }
return options1m;
}
String LstVal2m;
public string getoptions2m()
{
  
  return LstVal2m;
}
public void setoptions2m(string LstVal2m)
{
  
  this.LstVal2m=LstVal2m;
}

public list<SelectOption> getUserList2m()
{
List<SelectOption> options2m = new List<SelectOption>();


boolean flag=False;
boolean flag1=False;
mpm_selected=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.id=:savendrftrec.M_PM_Approver2_Id__c and Approver_type__c = 'M&PM Approver'];
if(mpm_selected.size()>0)
options2m.add(new SelectOption(mpm_selected[0].id,mpm_selected[0].Approver_Name__r.name));

 for(Approver__c apprs: MPMSort)
  {
  if(savendrftrec.M_PM_Approver2__c!=apprs.Approver_Name__r.name)
  {
  
  if(savendrftrec.M_PM_Approver2__c==Null && flag1==False)
           {
          options2m.add(new SelectOption('Optional','Optional'));
          flag1=True;
           }
          
          options2m.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
 
  }
  }  
  if(flag1==False)
  {
  options2m.add(new SelectOption('Optional','Optional'));
  }
return options2m;
}
//*******third picklist//
String LstVal3m;
public string getoptions3m()
{
  
  return LstVal3m;
}
public void setoptions3m(string LstVal3m)
{
  
  this.LstVal3m=LstVal3m;
}

public list<SelectOption> getUserList3m()
{
List<SelectOption> options3m = new List<SelectOption>();


boolean flag=False;
boolean flag1=False;
mpm_selected=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.id=:savendrftrec.M_PM_Approver3_Id__c and Approver_type__c = 'M&PM Approver'];
if(mpm_selected.size()>0)
options3m.add(new SelectOption(mpm_selected[0].id,mpm_selected[0].Approver_Name__r.name));

 for(Approver__c apprs: MPMSort)
  {
  if(savendrftrec.M_PM_Approver3__c!=apprs.Approver_Name__r.name)
  {
  
  if(savendrftrec.M_PM_Approver3__c==Null && flag1==False)
           {
          options3m.add(new SelectOption('Optional','Optional'));
          flag1=True;
           }
          
          options3m.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
 
  }
  }  
  if(flag1==False)
  {
  options3m.add(new SelectOption('Optional','Optional'));
  }
return options3m;
}
//****fourth picklist
String LstVal4m;
public string getoptions4m()
{
  
  return LstVal4m;
}
public void setoptions4m(string LstVal3m)
{
  
  this.LstVal4m=LstVal4m;
}

public list<SelectOption> getUserList4m()
{
List<SelectOption> options4m = new List<SelectOption>();


boolean flag=False;
boolean flag1=False;
mpm_selected=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.id=:savendrftrec.M_PM_Approver4_Id__c and Approver_type__c = 'M&PM Approver'];
if(mpm_selected.size()>0)
options4m.add(new SelectOption(mpm_selected[0].id,mpm_selected[0].Approver_Name__r.name));

 for(Approver__c apprs: MPMSort)
  {
  if(savendrftrec.M_PM_Approver4__c!=apprs.Approver_Name__r.name)
  {
  
  if(savendrftrec.M_PM_Approver4__c==Null && flag1==False)
           {
          options4m.add(new SelectOption('Optional','Optional'));
          flag1=True;
           }
          
          options4m.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
 
  }
  }  
  if(flag1==False)
  {
  options4m.add(new SelectOption('Optional','Optional'));
  }
return options4m;
}
/**********End of Picklist***************/
//******notification****
String LstVal1n;
public string getoptions1n()
{
  
  return LstVal1n;
}
public void setoptions1n(string LstVal1n)
{
  
  this.LstVal1n=LstVal1n;
}

public list<SelectOption> getUserList1n()
{
List<SelectOption> options1n = new List<SelectOption>();


boolean flag=False;
boolean flag1=False;
notification_selected=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.id=:savendrftrec.Notification1_Id__c];
if(notification_selected.size()>0)
options1n.add(new SelectOption(notification_selected[0].id,notification_selected[0].Approver_Name__r.name));

 for(Approver__c apprs: NotificationSort)
  {
  if(savendrftrec.Notification1__c!=apprs.Approver_Name__r.name)
  {
  
  if(savendrftrec.Notification1__c==Null && flag1==False)
           {
          options1n.add(new SelectOption('None','None'));
          flag1=True;
           }
          
          options1n.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
 
  }
  }  
  if(flag1==False)
  {
  options1n.add(new SelectOption('None','None'));
  }
return options1n;
}

String LstVal2n;
public string getoptions2n()
{
  
  return LstVal2n;
}
public void setoptions2n(string LstVal2n)
{
  
  this.LstVal2n=LstVal2n;
}

public list<SelectOption> getUserList2n()
{
List<SelectOption> options2n = new List<SelectOption>();


boolean flag=False;
boolean flag1=False;
notification_selected=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.id=:savendrftrec.Notification2_Id__c];
if(notification_selected.size()>0)
options2n.add(new SelectOption(notification_selected[0].id,notification_selected[0].Approver_Name__r.name));

 for(Approver__c apprs: NotificationSort)
  {
  if(savendrftrec.Notification2__c!=apprs.Approver_Name__r.name)
  {
  
  if(savendrftrec.Notification2__c==Null && flag1==False)
           {
          options2n.add(new SelectOption('Optional','Optional'));
          flag1=True;
           }
          
          options2n.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
 
  }
  }  
  if(flag1==False)
  {
  options2n.add(new SelectOption('Optional','Optional'));
  }
return options2n;
}

String LstVal3n;
public string getoptions3n()
{
  
  return LstVal3n;
}
public void setoptions3n(string LstVal3n)
{
  
  this.LstVal3n=LstVal3n;
}

public list<SelectOption> getUserList3n()
{
List<SelectOption> options3n = new List<SelectOption>();


boolean flag=False;
boolean flag1=False;
notification_selected=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.id=:savendrftrec.Notification3_Id__c];
if(notification_selected.size()>0)
options3n.add(new SelectOption(notification_selected[0].id,notification_selected[0].Approver_Name__r.name));

 for(Approver__c apprs: NotificationSort)
  {
  if(savendrftrec.Notification3__c!=apprs.Approver_Name__r.name)
  {
  
  if(savendrftrec.Notification3__c==Null && flag1==False)
           {
          options3n.add(new SelectOption('Optional','Optional'));
          flag1=True;
           }
          
          options3n.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
 
  }
  }  
  if(flag1==False)
  {
  options3n.add(new SelectOption('Optional','Optional'));
  }
return options3n;
}
String LstVal4n;
public string getoptions4n()
{
  
  return LstVal4n;
}
public void setoptions4n(string LstVal4n)
{
  
  this.LstVal4n=LstVal4n;
}

public list<SelectOption> getUserList4n()
{
List<SelectOption> options4n = new List<SelectOption>();


boolean flag=False;
boolean flag1=False;
notification_selected=[select id,Approver_Name__r.name,Approver_type__c from Approver__c where Approver_Name__r.id=:savendrftrec.Notification4_Id__c];
if(notification_selected.size()>0)
options4n.add(new SelectOption(notification_selected[0].id,notification_selected[0].Approver_Name__r.name));

 for(Approver__c apprs: NotificationSort)
  {
  if(savendrftrec.Notification4__c!=apprs.Approver_Name__r.name)
  {
  
  if(savendrftrec.Notification4__c==Null && flag1==False)
           {
          options4n.add(new SelectOption('Optional','Optional'));
          flag1=True;
           }
          
          options4n.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
 
  }
  }  
  if(flag1==False)
  {
  options4n.add(new SelectOption('Optional','Optional'));
  }
return options4n;
}

//***************SendMail
Public pagereference sendMail() 
{
          List<Messaging.SingleEmailMessage> mailMass=new List<Messaging.SingleEmailMessage>();
          lstofAPP.add(Lstval1);
          lstofAPP.add(LstVal2);
          lstofAPP.add(Lstval3);
          lstofAPP.add(Lstval4);
          
          lstofAPP.add(LstVal1c);
          lstofAPP.add(LstVal2c);
          lstofAPP.add(LstVal3c);
          lstofAPP.add(LstVal4c);
          
          lstofAPP.add(LstVal1f);
          lstofAPP.add(LstVal2f);
          lstofAPP.add(LstVal3f);
          lstofAPP.add(LstVal4f);

          lstofAPP.add(LstVal1m);
          lstofAPP.add(LstVal2m);
          lstofAPP.add(LstVal3m);
          lstofAPP.add(LstVal4m);

          lstofAPP.add(LstVal1n);
          lstofAPP.add(LstVal2n);
          lstofAPP.add(LstVal3n);
          lstofAPP.add(LstVal4n);

   string progress_level=WFList[0].Approval_Level_in_Progress__c;
   list<string> p_level1=progress_level.split('Tier');
   string plevel='Tier'+p_level1[1];

   list<WorkFlow_Approval_History__c> aprec1=new list<WorkFlow_Approval_History__c>();
   list<Approver__c> Alist1= new  list<Approver__c>();
   list<Approver__c> Alist2= new  list<Approver__c>();
   
   
   /**************************************** Querying the selected approvers *********************************/
   system.debug('FFFFFFFFFF'+savendrftrec);
   system.debug('qweqweqwe'+lstofAPP);
   system.debug('qweqweqwe'+lstofAPP.size());
   Alist1=[select Email_from_user__c,id,Approver_Name__r.name,Out_of_Office__c,From__c,To__c ,Delegate_Name__c, Delegate_Email__c,Business_Unit__c,Approver_type__c ,Email__c from Approver__c where  Tier__c like:'%'+plevel and (Region__c like:region0 or Region__c like:region1 or Region__c like:region2 or Region__c like:region3 or Region__c like:region4) and (Business_Unit__c like:WFList[0].Airbus_c__c or Business_Unit__c like:WFList[0].Airlines_c__c or  Business_Unit__c like:WFList[0].ATR_c__c or  Business_Unit__c like:WFList[0].BG_A_OE_c__c or  Business_Unit__c like:WFList[0].BG_A_c__c or  Business_Unit__c like:WFList[0].Boeing_c__c or  Business_Unit__c like:WFList[0].RACC_c__c or  Business_Unit__c like:WFList[0].Defence_Space_c__c or Business_Unit__c like:WFList[0].Defence_Space_OE_c__c or  Business_Unit__c like:WFList[0].HIS_c__c or  Business_Unit__c like:WFList[0].HTSI_c__c or  Business_Unit__c like:WFList[0].HTSI_OE_c__c )];
  

   //Alist2=[select Email_from_user__c,id,Approver_Name__r.name,Out_of_Office__c,From__c,To__c ,Delegate_Name__c, Delegate_Email__c,Business_Unit__c,Approver_type__c ,Email__c from Approver__c where id in : lstofAPP];
   Alist2=[select Delegation_Valid_From1__c,Delegation_Valid_To1__c,Delegate_Name_Text1__c,Delegation_Valid_From2__c,Delegation_Valid_To2__c,Delegate_Name_Text2__c,Delegation_Valid_From3__c,Delegation_Valid_To3__c,Delegate_Name_Text3__c,Delegation_Valid_From4__c,Delegation_Valid_To4__c,Delegate_Name_Text4__c,Email_from_user__c,id,Approver_Name__r.name,Out_of_Office__c,From__c,To__c ,Delegate_Name__c, Delegate_Email__c,Business_Unit__c,Approver_type__c ,Email__c from Approver__c where id in : lstofAPP];
   system.debug('CCCCCCCCCCCC'+Alist2.size());
   system.debug('iiiiiiiiii'+Alist2);
   
   /******************************* Marking the previously submitted requests as old *******************************/
   
   aprec1=[select Old_record__c from WorkFlow_Approval_History__c where Workflow_details__c=:WFid];
   for(WorkFlow_Approval_History__c a:aprec1)
   {
  
     a.Old_record__c=True;
     Approveobj.add(a);
   } 
   update Approveobj;

for(integer i=0;i<lstofAPP.size();i++)
     {            
             if(lstofAPP[i]<>null && lstofAPP[i]!='Optional' && lstofAPP[i]!='None')
           { 
            
                 WorkFlow_Approval_History__c aprec=new WorkFlow_Approval_History__c();
                  WorkFlow_Approval_History__c aprecDelt=new WorkFlow_Approval_History__c();
                 for(Approver__c a:Alist2)
                    {

                           if(lstofAPP[i] == a.id)
                           {
                           
                                      CurrApp= a;
                                      system.debug('TTTTTTTTTTTTT'+lstofAPP[i]);
/******************************************** Checking for delegates ********************************************************/

                            if(CurrApp.Out_of_Office__c){                                    
                                     if(CurrApp.From__c<=System.Today() && CurrApp.To__c>=System.Today())
                                      {
                                             String lstdel=CurrApp.Delegate_Name__c ;
                                              while(CurrApp.Out_of_Office__c)
                                               {                                     
                                                   CurrApp = [select Business_Unit__c,id,Approver_Name__r.name,Name,Email__c,Out_of_Office__c,Delegate_Email__c,Email_from_user__c,Delegate_Name__c,Approver_type__c from Approver__c where  Approver_Name__r.name =: lstdel limit 1 ];
                                                   Boolean j=CurrApp.Out_of_Office__c;
                                                   if(j==True)
                                                    {
                                        
                                                        lstdel=CurrApp.Delegate_Name__c;
                                                    }
                                                }
                           
                                            
                                        }
                                        else if(CurrApp.Delegation_Valid_From1__c<=System.Today() && CurrApp.Delegation_Valid_To1__c>=System.Today())
                                      {
                                           String lstdel=CurrApp.Delegate_Name_Text1__c ;
                                              while(CurrApp.Out_of_Office__c)
                                               {                                     
                                                   CurrApp = [select Business_Unit__c,id,Approver_Name__r.name,Name,Email__c,Out_of_Office__c,Delegate_Email__c,Email_from_user__c,Delegate_Name__c,Approver_type__c from Approver__c where  Approver_Name__r.name =: lstdel limit 1 ];
                                                   Boolean j=CurrApp.Out_of_Office__c;
                                                   if(j==True)
                                                    {
                                        
                                                        lstdel=CurrApp.Delegate_Name__c;
                                                    }
                                                }
                                        }
                                       else if(CurrApp.Delegation_Valid_From2__c<=System.Today() && CurrApp.Delegation_Valid_To2__c>=System.Today())
                                      {
                                           String lstdel=CurrApp.Delegate_Name_Text2__c ;
                                              while(CurrApp.Out_of_Office__c)
                                               {                                     
                                                   CurrApp = [select Business_Unit__c,id,Approver_Name__r.name,Name,Email__c,Out_of_Office__c,Delegate_Email__c,Email_from_user__c,Delegate_Name__c,Approver_type__c from Approver__c where  Approver_Name__r.name =: lstdel limit 1 ];
                                                   Boolean j=CurrApp.Out_of_Office__c;
                                                   if(j==True)
                                                    {
                                        
                                                        lstdel=CurrApp.Delegate_Name__c;
                                                    }
                                                }
                                        }
                                        else if(CurrApp.Delegation_Valid_From3__c<=System.Today() && CurrApp.Delegation_Valid_To3__c>=System.Today())
                                      {
                                           String lstdel=CurrApp.Delegate_Name_Text3__c ;
                                              while(CurrApp.Out_of_Office__c)
                                               {                                     
                                                   CurrApp = [select Business_Unit__c,id,Approver_Name__r.name,Name,Email__c,Out_of_Office__c,Delegate_Email__c,Email_from_user__c,Delegate_Name__c,Approver_type__c from Approver__c where  Approver_Name__r.name =: lstdel limit 1 ];
                                                   Boolean j=CurrApp.Out_of_Office__c;
                                                   if(j==True)
                                                    {
                                        
                                                        lstdel=CurrApp.Delegate_Name__c;
                                                    }
                                                }
                                        }
                                        else if(CurrApp.Delegation_Valid_From4__c<=System.Today() && CurrApp.Delegation_Valid_To4__c>=System.Today())
                                      {
                                           String lstdel=CurrApp.Delegate_Name_Text4__c ;
                                              while(CurrApp.Out_of_Office__c)
                                               {                                     
                                                   CurrApp = [select Business_Unit__c,id,Approver_Name__r.name,Name,Email__c,Out_of_Office__c,Delegate_Email__c,Email_from_user__c,Delegate_Name__c,Approver_type__c from Approver__c where  Approver_Name__r.name =: lstdel limit 1 ];
                                                   Boolean j=CurrApp.Out_of_Office__c;
                                                   if(j==True)
                                                    {
                                        
                                                        lstdel=CurrApp.Delegate_Name__c;
                                                    }
                                                }
                                        }
                                        
                                  }
                                  
/*************************************************** Updating Workflow history records ***********************************************/

                           if(CurrApp.Approver_type__c!='Notification' && i<16)  
                            {
                                      aprec.Approver__c=CurrApp.Approver_Name__r.name;
                            //newly added
                                      aprec.Select_Approver__c = CurrApp.ID;
                                      aprec.Ownerid=CurrApp.Approver_Name__c;
                                      aprec.Email__c=CurrApp.Email_from_user__c;
                                      aprec.Workflow_details__c=savendrftrec.Workflow_details__r.id;
                                      aprec.Approval_Status__c='Pending Approval';
                                      aprec.Approver_Type__c=CurrApp.Approver_type__c;
                                      aprec.Approval_submitted_date__c=System.today();
                                      aprec.Business_Unit__c=CurrApp.Business_Unit__c;
                                      aprec.Tier__c=WFList[0].Approval_Level_in_Progress__c;
                                      WFList[0].Status__c ='In progress';             
                                      ApproveobjRec.add(aprec); 
                                      
                              }
                               if(i>=16 && i<=19 && lstofAPP[i]!=Null)
                              {
                              aprecDelt.Approver__c=CurrApp.Approver_Name__r.name;
                            //newly added
                                      aprecDelt.Select_Approver__c = CurrApp.ID;
                                      aprecDelt.Ownerid=CurrApp.Approver_Name__c;
                                      aprecDelt.Email__c=CurrApp.Email_from_user__c;
                                      aprecDelt.Workflow_details__c=savendrftrec.Workflow_details__r.id;
                                      aprecDelt.Approval_Status__c='Pending Approval';
                                      aprecDelt.Approver_Type__c=CurrApp.Approver_type__c;
                                      aprecDelt.Approval_submitted_date__c=System.today();
                                      aprecDelt.Business_Unit__c=CurrApp.Business_Unit__c;
                                      aprecDelt.Tier__c=WFList[0].Approval_Level_in_Progress__c;
                                      aprecDelt.Delete_Check_Box__c=True;
                                      //WFList[0].Status__c ='In progress';             
                                      ApproveobjRec1.add(aprecDelt);
                              }
                           }
                     }
                }                           
      }
      lstofAPP.Clear(); 
      if(ApproveobjRec.size()>0)
      {
      system.debug('LLLLLLLLLLLLL'+ApproveobjRec);
      insert ApproveobjRec;
      }
      if(ApproveobjRec1.size()>0)
      {
      
      insert ApproveobjRec1;
      delete ApproveobjRec1;
      }
      update WFList;
      PageReference oppPage = new PageReference('/'+ savendrftrec.Workflow_details__r.id);
      oppPage.setRedirect(true);
      return  oppPage;
      }
//************************
//****************Cancel Function************
Public pagereference Cancel()
{
  PageReference oppPage = new PageReference('/'+ savendrftrec.Workflow_details__r.id);
  oppPage.setRedirect(true);
  return oppPage;
}
}