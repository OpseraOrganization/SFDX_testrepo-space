@isTest
public class Testcls_Contact_Sync_FunctionalRoles
{
  static testMethod void Testcls_Contact_Sync_FunctionalRoles() 
    {
       test.starttest();  

        Account acc = new Account();
        acc.Name = 'TstAccount';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'TestAcc';
        acc.Market_Name__c = 'Marine';
        
        insert acc;
        //Id rt= [select id,name from recordtype where sobjecttype='Case' and name='Rotable Core'].id;
        Contact con = new Contact();
        con.LastName = 'Kulkarni';
        con.FirstName = 'Shrivaths';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'shrivaths.kulkarni@nttdata.com';
        con.Email='shrivaths.kulkarni@nttdata.com';
        Con.Functional_Role__c = 'Campaign Manager';
        Con.Contact_Function__c = 'Communications';
        insert con;
        
               
       //Added for code coverage of Contact_Accountteamcls controller -  START
       ApexPages.StandardController std = new ApexPages.StandardController(con);  
       Contact_Accountteamcls test1 = new Contact_Accountteamcls(std);
       //Added for code coverage of Contact_Accountteamcls controller -  END
        
        con.Functional_Role__c = 'Proposal Coordinator';
       Con.Contact_Function__c = 'Customer Service';
       con.Mobile_App_Role__c = 'Customer Support Manager';
       con.Job_Title__c= 'Customer Support Manager in NTT';
        Update con;  
         test.stoptest();   
        
    }
 }