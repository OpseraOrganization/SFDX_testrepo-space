/***********************************************************************************************************
* Company Name          : NTT Data
* Name                  : TechnicalIssueController 
* Description           : Controller for the Technical Issue Edit and Detail Page 
* Project               : GTO Usability Project
***********************************************************************************************************/
public with sharing class TechnicalIssueController{
public case c{get;set;}
public case clonecase{get;set;}
public Technical_Issue_Case_Extensions__c ext{get;set;}
public DateTime DateTime_Of_AOG {get;set;}
public  PageReference returnURL;
string id;
public String feId;
boolean aog=false;
Public Case cas{get;set;} 
Public Technical_Issue_Case_Extensions__c casext{get;set;}
Public Field_Event__c fe{get;set;}  
Public Field_Event__c fe1 {get; set;} 

public TechnicalIssueController(ApexPages.StandardController controller)
 {
     //Commented the below code since it is no longer in use
 /* 
    if(c==null){
       c= new case();
    }
   c.RecordTypeid=label.TechnicalIssue_RecordTypeID;
   id=ApexPages.currentPage().getParameters().get('id'); 
   
   if(ext==null){
   ext= new Technical_Issue_Case_Extensions__c();
   }  
   
   if(fe==null)
   {
   fe= new field_event__c();
   }
   

    
   if(id!=null)
   {
    c=[select id,subject,ContactId,RecordTypeId,AccountId,Status,Origin,User_VN_Name__c,Expected_Update__c,Classification__c,HON_Commit_Date__c,Product_Number__c,Product_Serial_Number__c,
     Supported_Products__c,Sub_Status__c,VN_Name__c,Priority,Order_Entered_by__c,Quote_Entered_By__c,Sub_Class__c,Detail_Class__c,Requestor_Email__c,
     Customer_Request_Date__c,FCR__c,SLA_Flag_Case_Age__c,AOG__c,First_Call_Resolution__c,AcceleratedRepair__c, 
     Additional_Web_Form_Info__c ,Resolution__c,Description,Comments_Reason_for_Cases_10_Hrs__c,Comments_Reason_for_No_FCR__c,Engine_Model__c,Type_Technical__c,Dispatch_Reason__c,Dispatch_Approver__c,
     Engine_APU_Reported_Serial_Number__c,Resolution_Tool__c,No_FCR_Reason__c,Aircraft_Tail_Number__c,Dispatch_Approval_Date__c,Aircraft_Serial_Number__c,Aircraft_Location__c,Platform__c,Reason_for_Cases_Closed_10_Hrs__c,Reason_for_Cancellation__c,SLA_Flag_Status__c,
     FSE_Name_1__c,FSE_Name_2__c,FSE_Name_3__c ,Account_Type__c,OwnerId,Account_Address__c,SBU__c,CBT__c,CBT_Team__c,Market__c,CaseNumber
     ,CreatedDate,ClosedDate,Service_Level__c ,Case_age_test__c ,Aircraft_Type__c,Region__c,Sub_Region__c,Primary_Cell_Number__c,
     Primary_Work_Number__c,Primary_Work_Number_Extension__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c
     ,Primary_Email_Address__c,Denied_Party_Alert__c,Report_Type__c ,Owner_Operator_Information__c ,SBU_w2c__c,Product_Model__c,Bailment_Agreement__c,Product_Part_Number__c,
     (select Case_object__c,Aircraft_Owner_Operator1__c ,name,Waiting_for_TCT_In_Hours__c,Date_Time_of_AOG_Occurrence__c,Times_since_New1__c,Cycles_Since_New2__c  from Technical_Issue_Case_Extensions__r) from case where id=:Id];
   system.debug('Engine Removallllllllllllll'+fe.engine_Removal__c);
   if(c.Technical_Issue_Case_Extensions__r.size()>0){
   system.debug('caseestesdfsdfasdfasdfsdfasdf');
   system.debug('case extttttttttttttt'+c.Technical_Issue_Case_Extensions__r[0]);
   ext=c.Technical_Issue_Case_Extensions__r[0]; 
   }
   if(ApexPages.currentPage().getParameters().get('feId')!=Null){
       //feId = ApexPages.currentPage().getParameters().get('feId');
         for(Field_Event__c f : [select Case_Number__c,Description_from_Case__c,Aircraft_Tail_Number__c,Aircraft_Serial_Number__c,TSN__c,CSN__c,Accident_Incident__c,Aircraft_Type__c,Problem_Description__c,Supported_Products__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_Position__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_Event_Report__c from Field_Event__c where Case_Number__c =: Id])
         fe= f;       
   }   
   else
      for(Field_Event__c f : [select Case_Number__c,Description_from_Case__c,Aircraft_Tail_Number__c,Aircraft_Serial_Number__c,TSN__c,CSN__c,Accident_Incident__c,Aircraft_Type__c,Problem_Description__c,Supported_Products__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_Position__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_Event_Report__c from Field_Event__c where Case_Number__c =: Id])
         fe= f;
   system.debug('Field event Size'+fe.Case_Number__c);
   system.debug('Field event Size'+c.Field_Events__r.size());
   c.Field_Event__c=fe.id; 
  
    }   
          
 if(id!=null && ApexPages.currentPage().getParameters().get('type')!=Null && ApexPages.currentPage().getParameters().get('type')=='Edit')
   {
      c=[select id,subject,ContactId,RecordTypeId,AccountId,Status,Origin,User_VN_Name__c,Expected_Update__c,Classification__c,HON_Commit_Date__c,Product_Number__c,Product_Serial_Number__c,
     Supported_Products__c,Priority,Order_Entered_by__c,Quote_Entered_By__c,Sub_Class__c,Detail_Class__c,Requestor_Email__c,
     Customer_Request_Date__c,FCR__c,SLA_Flag_Case_Age__c,AOG__c,VN_Name__c,First_Call_Resolution__c,AcceleratedRepair__c, 
     Additional_Web_Form_Info__c ,Resolution__c,Description,Comments_Reason_for_Cases_10_Hrs__c,Comments_Reason_for_No_FCR__c,Engine_Model__c,Type_Technical__c,Dispatch_Reason__c,Dispatch_Approver__c,
     Engine_APU_Reported_Serial_Number__c,Resolution_Tool__c,No_FCR_Reason__c,Aircraft_Tail_Number__c,Dispatch_Approval_Date__c,Aircraft_Serial_Number__c,Aircraft_Location__c,Platform__c,Reason_for_Cases_Closed_10_Hrs__c,Reason_for_Cancellation__c,SLA_Flag_Status__c,
     FSE_Name_1__c,FSE_Name_2__c,FSE_Name_3__c ,Sub_Status__c,Account_Type__c,OwnerId,Account_Address__c,SBU__c,CBT__c,CBT_Team__c,Market__c,CaseNumber
     ,CreatedDate,ClosedDate,Service_Level__c ,Case_age_test__c ,Aircraft_Type__c,Region__c,Sub_Region__c,Primary_Cell_Number__c,
     Primary_Work_Number__c,Primary_Work_Number_Extension__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c
     ,Primary_Email_Address__c,Denied_Party_Alert__c,Owner_Operator_Information__c ,Report_Type__c ,SBU_w2c__c,Product_Model__c,Bailment_Agreement__c,Product_Part_Number__c,
     (select Case_object__c,Aircraft_Owner_Operator1__c ,name,Date_Time_of_AOG_Occurrence__c,Waiting_for_TCT_In_Hours__c,Times_since_New1__c,Cycles_Since_New2__c  from Technical_Issue_Case_Extensions__r),(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_Event_Report__c from Field_Events__r where Id =:feId) from case where id=:Id];
   
   if(ApexPages.currentPage().getParameters().get('feId')!=Null){
       feId = ApexPages.currentPage().getParameters().get('feId');
         for(Field_Event__c f : [select Case_Number__c,Description_from_Case__c,Aircraft_Tail_Number__c,Aircraft_Serial_Number__c,TSN__c,CSN__c,Accident_Incident__c,Problem_Description__c,Supported_Products__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_Position__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_Event_Report__c,Field_event_Report_count__c from Field_Event__c where Id =: FeId])
         fe= f;       
   }  
   else
   {
    for(Field_Event__c f : [select Case_Number__c,Description_from_Case__c,Aircraft_Tail_Number__c,Aircraft_Serial_Number__c,TSN__c,CSN__c,Accident_Incident__c,Problem_Description__c,Supported_Products__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Engine_Position__c ,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_Event_Report__c,Field_event_Report_count__c from Field_Event__c where Case_Number__c =: Id])
         fe= f;
  ext=c.Technical_Issue_Case_Extensions__r[0]; 
  }
  } 
  
  if(id!=null && ApexPages.currentPage().getParameters().get('type')!=Null && ApexPages.currentPage().getParameters().get('type')=='Clone')
   {
   clonecase=[select id,subject,ContactId,RecordTypeId,AccountId,Status,Origin,User_VN_Name__c,Expected_Update__c,Classification__c,HON_Commit_Date__c,Product_Number__c,Product_Serial_Number__c,
     Supported_Products__c,Priority,Order_Entered_by__c,VN_Name__c,Quote_Entered_By__c,Sub_Class__c,Detail_Class__c,Requestor_Email__c,
     Customer_Request_Date__c,FCR__c,SLA_Flag_Case_Age__c,AOG__c,First_Call_Resolution__c,AcceleratedRepair__c, 
     Additional_Web_Form_Info__c ,Resolution__c,Description,Comments_Reason_for_Cases_10_Hrs__c,Comments_Reason_for_No_FCR__c,Engine_Model__c,Type_Technical__c,Dispatch_Reason__c,Dispatch_Approver__c,
     Engine_APU_Reported_Serial_Number__c,Resolution_Tool__c,No_FCR_Reason__c,Aircraft_Tail_Number__c,Dispatch_Approval_Date__c,Aircraft_Serial_Number__c,Aircraft_Location__c,Platform__c,Reason_for_Cases_Closed_10_Hrs__c,Reason_for_Cancellation__c,SLA_Flag_Status__c,
     FSE_Name_1__c,FSE_Name_2__c,Sub_Status__c,FSE_Name_3__c ,Account_Type__c,OwnerId,Account_Address__c,SBU__c,CBT__c,CBT_Team__c,Market__c,CaseNumber
     ,CreatedDate,ClosedDate,Service_Level__c ,Case_age_test__c ,Aircraft_Type__c,Region__c,Sub_Region__c,Primary_Cell_Number__c,
     Primary_Work_Number__c,Primary_Work_Number_Extension__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c
     ,Primary_Email_Address__c,Denied_Party_Alert__c,Report_Type__c ,Owner_Operator_Information__c ,SBU_w2c__c,Product_Model__c,Bailment_Agreement__c,Product_Part_Number__c,
     (select Case_object__c,name,Aircraft_Owner_Operator1__c ,Date_Time_of_AOG_Occurrence__c,Waiting_for_TCT_In_Hours__c,Times_since_New1__c,Cycles_Since_New2__c  from Technical_Issue_Case_Extensions__r),(select Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_Event_Report__c from Field_Events__r) from case where id=:Id];
     c = clonecase.clone(false, true); 
     if(ApexPages.currentPage().getParameters().get('feId')!=Null){
       feId = ApexPages.currentPage().getParameters().get('feId');
         for(Field_Event__c f : [select Case_Number__c,Supported_Products__c,Problem_Description__c,Accident_Incident__c,Engine_Position__c ,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_Event_Report__c,Field_event_Report_count__c from Field_Event__c where id =: feId ])
         fe= f.clone(false,true); 
         ///////////
         fe.Field_event_Report_count__c =null;
         fe.Case_Number__c =null;
         /////////////      
   }  
   else
      for(Field_Event__c f : [select Case_Number__c,Description_from_Case__c,Aircraft_Tail_Number__c,Aircraft_Serial_Number__c,TSN__c,CSN__c,Supported_Products__c,Problem_Description__c,Accident_Incident__c,Aircraft_Type__c,Engine_Position__c ,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_Event_Report__c,Field_event_Report_count__c from Field_Event__c where Case_Number__c =: Id])
       {
         fe1= f;
         fe1.Field_event_Report_count__c =null;
         fe1.Case_Number__c =null;
       }
   if(fe1!= null)    
   fe = fe1.clone(false,true);
   system.debug('c.subject***********'+c.subject);
   ext=c.Technical_Issue_Case_Extensions__r[0]; 
   }
       
       
   casext=ext;
   cas=c;
       
   }
   

 public PageReference save1() {
 system.debug('Inside TEch Issue Save');
 //upsert fe;
 //c.Field_Event__c=fe.id;
 try{
 system.debug('inside try block');
   upsert c;
 }
 catch(Exception e){
  system.debug('inside ctch block');
     String error = e.getMessage().substringAfterLast('FIELD_CUSTOM_VALIDATION_EXCEPTION,');
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,error));
     return null;
 }
Technical_Issue_Case_Extensions__c ext1 = [select id,Aircraft_Owner_Operator1__c ,Case_object__c,Date_Time_of_AOG_Occurrence__c,Times_since_New1__c,Cycles_Since_New2__c from Technical_Issue_Case_Extensions__c where Case_object__c =: c.id]; 
system.debug('Inside TEch Issue Save case upsert');
if(ext.Case_object__c==null)
{
ext.Case_object__c = c.Id;
 }
 if(fe.Case_Number__c==null)
 {
 system.debug('11111111111111111');
 fe.Case_Number__c=c.id;
 }
//ext.Date_Time_of_AOG_Occurrence__c=DateTime_Of_AOG  ;
system.debug('Inside TEch Issue Save ext id pass');
 if(c.AOG__c==false)
    {
    ext.Date_Time_of_AOG_Occurrence__c=null;
    }
 if(fe.Field_Event_Report__c==false)
    {
    system.debug('2222222222222222222222');
    fe.Accident_Incident__c='';
    fe.Engine_Position__c ='';
    fe.Effect_on_Operation__c='';
    fe.Engine_Removal__c='';
    fe.Event_Airport_Text__c='';
    fe.IFSD_ETOPS__c='';
    fe.Maintenance_Action__c='';
    fe.Maintenance_Agreement__c='';
    fe.Operational_Symptom__c='';
    fe.Report_Date__c=null;
    fe.Report_Type__c='';
    fe.Shutdown_Details__c='';
   
    }
    ext1.Date_Time_of_AOG_Occurrence__c=ext.Date_Time_of_AOG_Occurrence__c;
    ext1.Times_since_New1__c=ext.Times_since_New1__c;
    ext1.Cycles_Since_New2__c=ext.Cycles_Since_New2__c; 
upsert ext1;
 try{
 
if(fe!=null)
{
    if(fe.Field_event_Report_count__c==null)
        {
            fe.Field_event_Report_count__c=2;
        }
    else if(fe.Field_event_Report_count__c!=null)
        {
            fe.Field_event_Report_count__c=fe.Field_event_Report_count__c+1;
        } 
    fe.Supported_Products__c=c.Supported_Products__c;
    //fe.Product_Models__c=c.Product_Model__c;
    //fe.Engine_APU_Reported_S_N__c=c.Engine_APU_Reported_Serial_Number__c;
    fe.Report_Type__c=c.Report_Type__c;
    fe.Description_from_Case__c=c.Description;
    fe.Engine_APU_Replaced_S_N__c=c.Product_Serial_Number__c;
    fe.Aircraft_Tail_Number__c=c.Aircraft_Tail_Number__c;
    fe.Aircraft_Serial_Number__c=c.Aircraft_Serial_Number__c;
    fe.TSN__c=Integer.ValueOf(ext.Times_since_New1__c);
    fe.CSN__c=Integer.ValueOf(ext.Cycles_Since_New2__c);
    fe.Problem_Description__c=c.Description;
    fe.Aircraft_Type__c=c.Aircraft_Type__c;
    fe.Report_Date__c=Date.valueof(c.CreatedDate);
    upsert fe;
    }

}
catch(Exception e){
  system.debug('inside ctch block');
     String error = e.getMessage().substringAfterLast('FIELD_CUSTOM_VALIDATION_EXCEPTION,');
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,error));
     return null;
 }
system.debug('Inside TEch Issue Save ext upsert');

//pagereference p = new PageReference ('/apex/TechnicalIssue_DetailPage?id='+c.id+'&ext='+ ext1.id+'&feId='+fe.id);
pagereference p = new PageReference ('/'+c.id);
system.debug('p************** '+p);
p.setRedirect(true);  
return p;
        
}


public PageReference edit1() {
pagereference pa;
if(id=='')
pa = new PageReference ('/apex/TechnicalIssue_Page?id='+c.id+'&ext='+ ext.id +'&feId='+ fe.id+'&retURL=/apex/TechnicalIssue_DetailPage?id='+c.id+'&type=Edit&Recordtype='+c.RecordtypeId);
else
pa = new PageReference ('/apex/TechnicalIssue_Page?id='+id+'&ext='+ ext.id +'&feId='+ fe.id+'&retURL=/apex/TechnicalIssue_DetailPage?id='+id+'&type=Edit&Recordtype='+c.RecordtypeId);
pa.setRedirect(true);
return pa;
}
public PageReference clone1() {
pagereference pb;
if(id=='')
pb = new PageReference ('/apex/TechnicalIssue_Page?id='+c.id+'&ext='+ ext.id +'&feId='+ fe.id+'&retURL=/apex/TechnicalIssue_DetailPage?id='+c.id+'&type=Clone&Recordtype='+c.RecordtypeId);
else
pb = new PageReference ('/apex/TechnicalIssue_Page?id='+id+'&ext='+ ext.id+'&feId='+ fe.id +'&retURL=/apex/TechnicalIssue_DetailPage?id='+id+'&type=Clone&Recordtype='+c.RecordtypeId);
pb.setRedirect(true);
return pb;*/
}


}