@isTest
private class Planned_Meeting_Task_TestCls{
static testMethod void Planned_Meeting_Task_TestMthd(){


//creating account;
 Account acc= new Account(name='Test Task Account');
 insert acc;
 
 //creating contact;
  Contact cont=new Contact(firstname='Test',LastName='Manager',AccountId=acc.Id,Phone_3__c='9986502445',
  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E156767',email='anila.francis@wipro.com');
  insert cont;

  //Creating feedback
  Feedback__C fdd= new Feedback__C(Account__c=acc.id,contact__C=cont.Id,Delivery_Weight__c=100,Warranty__c='1',Repair_Performance__c ='1',Delivery_Customer_Rating__c='Blue - Best in Class');
        insert fdd;
  
  //creating case
 Case cases=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
 //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
 Type='Order',Supported_Product__c='ADIRS',Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance', CSM_Feedback__c=fdd.id);
 insert cases;
//Creating Planned meeting
Planned_Meeting__c PlndMetng = new Planned_Meeting__c();
  PlndMetng.Name='Test';
  insert PlndMetng;
//creating task
  Task tasks= new Task (whatId=cases.Id, whoId=cont.Id, subject='NSS Survey - Follow Up', PRIORITY='Normal',Description='Testing',recordtypeid= label.Sales_Task_RT_ID);    
  insert tasks;   

ApexPages.StandardController controller= new ApexPages.StandardController(tasks);
System.currentPagereference().getParameters().put('id',tasks.id);
Planned_Meeting_Task_Cls PlndMtngTsk=new Planned_Meeting_Task_Cls();

PlndMtngTsk.getTaskRec();
PlndMtngTsk.setTaskRec();
string Txtdta=PlndMtngTsk.getTextData();
Txtdta=tasks.Description;
PlndMtngTsk.setTextData(Txtdta);
string CrtBy=PlndMtngTsk.getCretdBy();
CrtBy='Test';
PlndMtngTsk.setCretdBy(CrtBy);

PlndMtngTsk.getRelatTo();
PlndMtngTsk.getSubjctPickval();
PlndMtngTsk.getSubjectpiclstval();
PlndMtngTsk.getActionRst();
PlndMtngTsk.getClaimdAmnt();
PlndMtngTsk.getDueDte();
PlndMtngTsk.getCmpltDte();
PlndMtngTsk.getCompltddate();
PlndMtngTsk.getPaidAmnt();
PlndMtngTsk.getStatuspiclst();
PlndMtngTsk.getStatuspiclstval();
PlndMtngTsk.getPriortyPickval();
PlndMtngTsk.getPriortiypiclstval();
PlndMtngTsk.getTypePickval();
PlndMtngTsk.getTypepiclstval();
PlndMtngTsk.Save();
}

}