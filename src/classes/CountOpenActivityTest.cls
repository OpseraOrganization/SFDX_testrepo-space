/**************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : CountOpenActivityTest
* Description           : 
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* Nov-08-2013      1.0            Anusuy Murugiah       Wrapping the testmethod with Start and Stop
**************************************************************************************************/
@isTest
public class CountOpenActivityTest{

static testMethod void myUniTest(){
Test.startTest();
//Integer eCount = 0;
List<Case> cases=new List<Case>();
List<Task> task1=new List<Task>();
List<Case> casetoUpdate= new List<Case>();

/*Account acc = new Account();
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
con.FirstName = 'KapilM';
con.LastName = 'Singh';
con.AccountId = acc.Id;
con.Primary_Email_Address__c = 'kapil.nowhere@gmail.com';
con.Email='kapil.nowhere@gmail.com';
try {
insert con;
}Catch(Exception ex){}


if(con.FirstName == NULL){
con.FirstName = 'KapilM1';
try {
update con;
}Catch(Exception ex){}

}*/
Id RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Repair & Overhaul').getRecordTypeId();
Case cs = new Case();
cs.Origin = 'Web';
cs.Status = 'Open';
/*if(con.Id != NULL || con.Id != ''){
cs.ContactId = con.Id;
}else {*/
cs.ContactId = [Select Id from Contact Limit 1].Id;
//}
cs.Classification__c = 'GTO Field Service';
cs.HON_Commit_Date__c = System.now() + 1;
cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
cs.Government_Compliance_SM_M_Content__c = 'NO';
cs.RecordTypeId = RecordTypeId;
//cs.No_FCR_Reason__c='Not Trained';
try {
insert cs;
}Catch(Exception ex){}

/*UserRole role = [select Id, Name from UserRole where name = 'ALT' limit 1];

Profile profile = [select id from Profile where name = 'System Administrator'];
User manager = new User(LastName = 'Test Task Manager and Role',FirstName = 'TestFirstName', Username = 'testtaskmanagerandrole@test.com',
                    Email = 'testmanager@test.com',Alias = 'tm1' ,CommunityNickname= 'tmanager' ,
                    TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
                    ProfileId = profile.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
try {
insert manager;
}Catch(Exception ex){}*/


Task task = new Task();
//task.OwnerId = manager.Id;
task.Priority = 'Normal';
task.Status = 'Open';
//task.Assigned_Manager__c = manager.Id;
//task.Assigned_Role__c = role.Id;
task.whatId = cs.Id;
try {
insert task;
}Catch(Exception ex){}

   
try {
delete task;
}Catch(Exception ex){}
 Test.stopTest();   
}
}