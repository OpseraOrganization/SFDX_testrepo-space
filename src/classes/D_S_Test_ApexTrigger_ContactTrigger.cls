@isTest
public  class D_S_Test_ApexTrigger_ContactTrigger
{
static testmethod void contact_updatesbu()
{
Account a1 = New Account(Name= 'sbuaccount', Strategic_Business_Unit__c = 'D&S',CBT__c = 'Advanced Technology', CBT_Team__c='ASM: Advanced Sensors & Microsystems',CBT_Directorate__c='Advanced Sensing Technology');
insert a1;
Contact c1 = new Contact(lastname='Sumitha',firstname='Test',accountId=a1.Id,
Contact_Is_Employee__c=false,Phone_3__c ='9986555678');
insert c1;
Contact c2 = new Contact(lastname='Anila',firstname='Test',accountId=a1.Id,
Contact_Is_Employee__c=true,Phone_3__c ='9986555678',Employee_Contact_Role__c = 'Account Administrator',Employee_Number__c='E123567');
insert c2;
c2.Contact_Is_Employee__c=false;
update c2;
Account a2 = New Account(Name= 'cbtaccount', Strategic_Business_Unit__c = 'D&S',CBT__c = 'Advanced Technology', CBT_Team__c='ASM: Advanced Sensors & Microsystems',CBT_Directorate__c='Advanced Sensing Technology');
insert a2;
c2.accountid = a2.id;
update c2;
}

}