/** * File Name: CSO/GTO_Test_ApexClass4
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* Nov-08-2013      1.0            Anusuy Murugiah       Wrapping the testmethod with Start and Stop
* */
@isTest (seealldata = true)
private  class CSO_GTO_Test_ApexClass4 {
static testmethod void testCallCenter(){





//creating account;
// Account acc= new Account(name='Test Account');
// insert acc;
 
 //creating contact;
 //Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
  //Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='567' );
 Contact cont=[select id,AccountId from contact where Contact_Status__c='Active' and Employee_Contact_Role__c='Analyst' limit 1];
 //insert cont;

 //creating case
 Case cases=new Case(AccountId=cont.AccountId,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
 //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
 Type='Order');
 insert cases;
 //test.starttest();
List<Service_Request__c> SRs= new  List<Service_Request__c>();
//List<Field_Event__c> FEs =new List<Field_Event__c>();
List< Service_Recovery_Report__c> SRRs= new List< Service_Recovery_Report__c>();
 //creating service requests
 Service_Request__c SR= new Service_Request__c(Case_Number__c=cases.Id);
 SRs.add(SR);
 Service_Request__c SRNew= new Service_Request__c(Contact_Name__c=cont.Id);
 SRs.add(SRNew);
 insert SRs;
 //creating service request report
 Service_Recovery_Report__c SRR= new Service_Recovery_Report__c(Case_Number__c=cases.Id,status__C='In Process');
 SRRs.add(SRR);
 Service_Recovery_Report__c SRRNew= new Service_Recovery_Report__c(Contact_Name__c=cont.Id);
 SRRs.add(SRRNew);
 insert SRRs;
 SRR.status__c='Awarded - Lost';
 update SRR;
 Test.startTest();
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
  delete SRRTeam;
test.stoptest(); 
  }
  }