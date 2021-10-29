/** * File Name: CSO/GTO_Test_ApexClass1
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* Nov-08-2013      1.0            Anusuy Murugiah       Wrapping the testmethod with Start and Stop
* */

@isTest
private  class CSO_GTO_Test_ApexClass1 {
static testmethod void testCallCenter1(){

Id pf = Label.Sys_Admin_Profile_Id;
//Profile pf= [select id from Profile where name = 'System Administrator'];
//Adding record type to case before 
//Id recrdtypid=[select id from recordtype where name='Repair & Overhaul' and sobjecttype='case' limit 1].Id;
Id recrdtypid = Label.Repair_Overhaul_RT_ID;
//creating account;
 Account acc= new Account(name='Test Account');
 insert acc;
 //creating contact;
 Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E005675' );
 insert cont;
 User usr1 = new User(LastName = 'Test UserGTO',Username = 'honnewgto@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1honeygto' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',MobilePhone='123');
insert usr1;
 Contact_Plan__c fse = new Contact_Plan__c(Account_Name__c =acc.id);
insert fse;

User usr = new User(LastName = 'Test UserCSO',Username = 'tu11cso@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert usr;
List<solution> sols= new List<solution>();
Skills2__c skill= new Skills2__c (Primary_Secondary__c='Primary' ,Supported_Product__c='Radio',   Contact__c=cont.Id);
insert skill;
//Skills2__c skill= [select id,Primary_Secondary__c, Contact__c,Supported_Product__c from Skills2__c limit 1];
//RecordType[] rec = [Select Id,Name from RecordType where name='Solution CSO Non-Technical' or
//name='Solution GTO Technical'  ];
//System.debug('&&&&&&&&&&&&&&&'+rec);
id rec = Label.Solution_CSO_Non_Technical_RT_Id;
Id rec1 = label.Solution_GTO_Technical_RT_Id;

Solution sol= new Solution(Categorization__c='Categorization__c',   SolutionName='New Sol',RecordTypeId=rec,Audit_Frequency__c='Weekly',Intellectual_Property_Review_By__c=usr.Id,Intellectual_Property_Review_Date__c=System.Today(),Export_Review_By__c=usr.Id,Export_Review_Date__c=System.Today());
sols.add(sol);
Solution sol1= new Solution(Categorization__c='Categorization__c',   SolutionName='New Sol Rec',RecordTypeId=rec1,
Supported_Product__c='Radio',Audit_Frequency__c='Weekly',Intellectual_Property_Review_By__c=usr.Id,Intellectual_Property_Review_Date__c=System.Today(),Export_Review_By__c=usr.Id,Export_Review_Date__c=System.Today());
sols.add(sol1);

insert sols;
System.debug('***********'+sol);
System.runas(usr1){

sol.Categorization__c='Installation';
sol.Status='Content Review';
sol1.Status='Standards Review';
//update sols;
sol.Status='Final Review';
sol1.Status='Technical Review';
//update sols;



System.runas(usr1){

Test.startTest();
sol.Status='Approved';
sol1.Status='Approved';
update sols;

 /*Case cases=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
 No_FCR_Reason__c='Not Trained',Type='Order',recordtypeid=recrdtypid);
 insert cases;*/
 Test.stopTest();

}



}
}
}