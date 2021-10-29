@isTest
public class RepLocator_LeadCreationEmailClass_Test
{
 public static testmethod void RepLocator_LeadCreation()
 {
  Account a = new Account(Name = 'test');
  insert a;
  Account_Address__c accadd = new Account_Address__c();
  //accadd.BGAMob_Customer_Name__c = 'test';
  accadd.BGAMob_Address_1__c = 'test';
  accadd.BGAMob_Address_2__c = 'test';
  accadd.BGAMob_City_Name__c = 'test';
  accadd.BGAMob_State_Province__c = 'test';
  accadd.BGAMob_Postal_Code__c = '12345';
  accadd.BGAMob_Country_Nm__c = 'test';
  accadd.BGAMob_Contact_Email__c = 'test@test.com';
  accadd.Account_Name__c = a.id;
  insert accadd;
  Lead l = new lead();
  l.lastname = 'test';
  l.company = 'test';
  l.Status = 'Engaged';
  l.email = 'test@test.com';
  l.recordTypeid = Label.RepLocator_LeadRecordTypeId;
  l.Lead_Source_Other__c = 'Channel Partner';
  l.Lead_Description__c = 'test';
  l.Type_of_Platform__c = 'test';
  l.Account_Country__c = 'India';
  l.Primary_Work_Number__c = '123';
  l.FirstName = 'test';
  l.Lead_Market__c = 'test';
  l.Channel_Partner_Name__c = accadd.id;
  insert l;
  
 }
 public static testmethod void RepLocator_LeadCreation1()
 {
  Account a = new Account(Name = 'test');
  insert a;
  Account_Address__c accadd = new Account_Address__c();
  //accadd.BGAMob_Customer_Name__c = 'test';
  accadd.Account_Name__c = a.id;
  insert accadd;
  Lead l = new lead();
  l.lastname = 'test';
  l.company = 'test';
  l.Status = 'Engaged';
  l.email = 'test@test.com';
  l.recordTypeid = Label.RepLocator_LeadRecordTypeId;
  l.Lead_Source_Other__c = 'Honeywell Representative';
  l.Channel_Partner_Name__c = accadd.id;
  insert l;
  }
  public static testmethod void RepLocator_LeadCreation2()
 {
  Lead l = new lead();
  l.lastname = 'test';
  l.company = 'test';
  l.Status = 'Engaged';
  l.email = '';
  l.recordTypeid = Label.RepLocator_LeadRecordTypeId;
  l.Lead_Source_Other__c = 'Honeywell Representative';
  l.Lead_Description__c = 'test';
  l.Type_of_Platform__c = 'test';
  l.Account_Country__c = 'India';
  l.Primary_Work_Number__c = '123';
  l.FirstName = 'test';
  l.Lead_Market__c = 'test';
  insert l;
  
  Lead ld = null;
  try
  {
      RepLocator_LeadCreationEmailClass.sendEmailtoLeads(ld);
  }
  catch(Exception e)
  {
  }
  
  }
  public static testmethod void RepLocator_LeadCreation3()
 {
  Lead l = new lead();
  l.lastname = 'test';
  l.company = 'test';
  l.Status = 'Engaged';
  l.email = 'test@test.com';
  l.recordTypeid = Label.RepLocator_LeadRecordTypeId;
  l.Lead_Source_Other__c = 'Honeywell Representative';
  l.Lead_Description__c = 'test';
  l.Type_of_Platform__c = 'test';
  l.Account_Country__c = 'India';
  l.Primary_Work_Number__c = '123';
  l.FirstName = 'test';
  l.Lead_Market__c = 'test';
  insert l;
  }
}