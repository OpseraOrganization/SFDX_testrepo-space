/** * File Name: CSO/GTO_Test_ApexClass
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* Nov-08-2013      1.0            Anusuy Murugiah       Wrapping the testmethod with Start and Stop
* */ 
@isTest
private  class CSO_GTO_Test_ApexClass {
static testmethod void testCallCenter(){

//variable declaration
List<Case> caseList= new List<Case>();
List<Service_Request__c> SRs= new  List<Service_Request__c>();
//List<Field_Event__c> FEs =new List<Field_Event__c>();
List< Service_Recovery_Report__c> SRRs= new List< Service_Recovery_Report__c>();
Profile pf= [select id from Profile where name = 'System Administrator'];
User usr = new User(LastName = 'Test UserCSO',Username = 'tu1cso@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert usr;

 //creating account;
 Account acc= new Account(name='Test Account');
 insert acc;
 
 //creating contact;
 Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E132567' );
 insert cont;

Product2 prd= new Product2(product_number__c='111',name='111');
insert prd;

Lead leads= new Lead(LastName='Test',Status='Open',Company='testComp',Account__c=acc.id , Contact__c = cont.id);
insert leads;
 Test.startTest();
 //creating case
 Case cases=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
  //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
 Type='Order');
 insert cases;

 
 
 
 //creating service requests
 /*Service_Request__c SR= new Service_Request__c(Case_Number__c=cases.Id);
 SRs.add(SR);
 Service_Request__c SRNew= new Service_Request__c(Contact_Name__c=cont.Id);
 SRs.add(SRNew);
 insert SRs;*/

  //creating Field Events
/*Field_Event__c FE= new Field_Event__c(Case_Number__c=cases.Id);
FEs.add(FE);
Field_Event__c FENew= new Field_Event__c(Contact__c=cont.Id);
FEs.add(FENew);
insert FEs;*/

 //creating service request report
 /*Service_Recovery_Report__c SRR= new Service_Recovery_Report__c(Case_Number__c=cases.Id,status__C='In Process');
 SRRs.add(SRR);
 Service_Recovery_Report__c SRRNew= new Service_Recovery_Report__c(Contact_Name__c=cont.Id);
 SRRs.add(SRRNew);
 insert SRRs;
 SRR.status__c='Awarded - Lost';
 update SRR;
 Service_Recovery_Report_Team_Members__c  SRRTeam = new Service_Recovery_Report_Team_Members__c(Is_Primary_Team_member__c=true,
 Service_Recovery_Report__c=SRR.Id,Contact_Name__c=cont.Id);
 insert SRRTeam;
 Service_Recovery_Report_Team_Members__c  SRRTeam1 = new Service_Recovery_Report_Team_Members__c(Is_Primary_Team_member__c=true,
 Service_Recovery_Report__c=SRR.Id,Contact_Name__c=cont.Id);
 Service_Recovery_Report_Team_Members__c  SRRTeam2 = new Service_Recovery_Report_Team_Members__c(
 Service_Recovery_Report__c=SRR.Id);
 insert SRRTeam2;
 try{
 insert SRRTeam1;}
 catch(Exception e){}

SRRTeam.Is_Primary_Team_member__c=false;
update SRRTeam;
 SRRTeam.Is_Primary_Team_member__c=true;
update SRRTeam;
  delete SRRTeam;*/
 
 //creating case
 Case casesCSO=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Type='Order',
 Export_Compliance_Content_ITAR_EAR__c='Yes', Government_Compliance_SM_M_Content__c='No',
 classification__c='CSO Spares' 
 //No_FCR_Reason__c='Not Trained'For Ticket INC000009687923
 );
caseList.add(casesCSO);
 Case casesGTO=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,
 Export_Compliance_Content_ITAR_EAR__c='Yes', Government_Compliance_SM_M_Content__c='No',
 classification__c='GTO Field Service' //No_FCR_Reason__c='Not Trained'For Ticket INC000009687923
                       );
caseList.add(casesGTO);
 Case casesGeneral=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,
 Export_Compliance_Content_ITAR_EAR__c='Yes', Government_Compliance_SM_M_Content__c='No',                        
 classification__c='GTO Field Service' //No_FCR_Reason__c='Not Trained'For Ticket INC000009687923
                           );
caseList.add(casesGeneral);
insert CaseList;
Test.stopTest();
 cases.classification__c='ISC';
 cases.Export_Compliance_Content_ITAR_EAR__c ='Yes';
 update cases;    
 
   
try{
  //  Task tasks= new Task (whatId=cases.Id,ownerid=usr.Id);
  //  insert tasks;
    cases.ownerId=usr.Id;
    cases.Export_Compliance_Content_ITAR_EAR__c ='No';
    //update cases;
    cases.Status='Done';
    update cases;
}
 catch(Exception e){}   

casesCSO.Export_Compliance_Content_ITAR_EAR__c='No';
update casesCSO;



// RecordType[] rec1 = [Select Id,Name from RecordType where name='VOC'];
 //Case_Line_Item__c caseLine= new Case_Line_Item__c(Part_Number__c='111',Case_Number__c=cases.Id,Comments__c='Testing');
 //insert caseLine;
 //Feedback__C voc= new Feedback__C(RecordTypeId=rec1[0].Id,contact__C=cont.Id,   Delivery_Weight__c=100, Delivery_Customer_Rating__c='Blue - Best in Class');
 //insert voc;



}// end of method
}// end of class