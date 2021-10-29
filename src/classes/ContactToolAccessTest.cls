@isTest()
public class ContactToolAccessTest{

    static testMethod void firstTest() 
    {
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

insert acc;

Contact con = new Contact();
con.LastName = 'Singh';
con.FirstName = 'Kapil';
con.AccountId = acc.Id;
con.Primary_Email_Address__c = 'kapil.nowhere@gmail.com.qa';
con.Email='kapil.nowhere@gmail.com.qa';
insert con;

Portal_Tools_Master__c obj1=new Portal_Tools_Master__c();
obj1.name='Technical Publications';
obj1.Tool_Description__c='testtooldescription';
insert obj1;







Contact_Tool_Access__c obj=new Contact_Tool_Access__c ();
obj.name='test';
obj.Request_Status__c='Denied';
obj.Portal_Honeywell_ID__c='1212';
obj.CRM_Contact_ID__c=con.id;
obj.Portal_Tool_Master__c=obj1.id;
obj.AutoApproveFlag__c=true;
insert obj;
obj.Request_Status__c='Approved';
update obj;
        
  /*      Contact_Tool_Access__c obj11=new Contact_Tool_Access__c ();
        obj11.CRM_Contact_ID__c= con.Id;
obj11.name='test11';
obj11.Request_Status__c='Denied';
obj11.Portal_Honeywell_ID__c='1212';
obj11.CRM_Contact_ID__c=con.id;
obj11.Portal_Tool_Master__c=obj1.id;
obj11.AutoApproveFlag__c=true;
        insert obj11;
//obj11.Id=con.Id;
update obj11;*/

}

}