@isTest(seeAllData = false)
Public class ATR_Contact_Tool_Access_Test{
    Public static testMethod Void MethodTest(){
     Test.startTest();
Integer eCount = 0;
List<Case> cases=new List<Case>();
List<Task> task1=new List<Task>();
List<Case> casetoUpdate= new List<Case>();

Account acc = new Account();
acc.Name = 'Honeywell Test';
acc.Customer_Status__c = 'Active';
acc.Strategic_Business_Unit__c = 'ATR';
acc.CBT__c = 'Airbus';
acc.Region_Name__c = 'Americas';
acc.Sub_Region_Name__c = 'Canada';
acc.Service_Level__c = 'Standard';
acc.Type = 'OEM';
acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
try{
insert acc;
}Catch(Exception ex){}

Contact con = new Contact();
con.FirstName = 'test';
con.LastName = 'test';
con.AccountId = acc.Id;
con.Primary_Email_Address__c = 'test@gmail.com';
con.Email='test@gmail.com';
con.Honeywell_ID__c='E473516';
try {
insert con;
}Catch(Exception ex){}


if(con.FirstName == NULL){
con.FirstName = 'test';
try {
update con;
}Catch(Exception ex){}

}
case cs = new case();
cs.RecordTypeid=label.WEB;
cs.Origin='phone';
cs.Status='open';
cs.Type ='WEB Portal Registration';
cs.Tool_name__c=label.ATR_RMU_TOOL_Name;
cs.Honeywell_id__c =con.Honeywell_ID__c;

cs.Contactid=con.id;
insert cs;


  Contact_Tool_Access__c cta= new Contact_Tool_Access__c();
  cta.name='Technical Publications';
  cta.Portal_Tool_Master__c=label.Technical_Publications;
  cta.Request_Status__c='Approved';
  cta.CRM_Contact_ID__c=con.id;
  cta.Portal_Honeywell_id__c=con.Honeywell_ID__c;
  insert cta;
  update cta;

   Test.stopTest();
    }
    
}