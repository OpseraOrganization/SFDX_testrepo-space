@isTest
public class CustomerTop10IssuesClasstst{ 
    static testmethod void CustomerTop10IssuesClasstst(){
    User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name != 'System Administrator' and isactive = true order by createddate asc limit 1];
              // Country__c cnt=new Country__c(Name='India');
     
       Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='ATR',Customer_Status__c='Active');
       insert acc;
        System.runAs(usr){
       Contact con = new Contact();
        con.LastName = 'testupdate';
        con.FirstName = 'sbucon';
        con.AccountId = acc.Id;
         con.Contact_Function__c='Infosys';
         con.Primary_Email_Address__c = 'sofiya.peermohamed@nttdata.com';
        con.Employee_Number__c = 'E123123';
        //con.Account_Contact_Name__c=acc.name;
        con.Email='harikishore.vutukuri@honeywell.com';
        //con.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
       // con.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;
        insert con;
         Case c1=new Case(App_Email__c='test1@g.com',SuppliedEmail='test@g.com',Origin='BGAMobileApp');
         insert c1; 
     
        Service_Request__c  Sr =new Service_Request__c();
        Sr.Subject__c='DS Test SR';
        Sr.SR_Type__c='Significant Customer Dissatisfier';
        Sr.Priority__c='High';
        Sr.Status__c='Open';
        Sr.Problem_Description__c='Technical Problem';
        Sr.Account_Name__c=acc.id;
        Sr.Customer_Due_Date__c=date.today();
        Sr.Top_Technical_Issue__c=true;
        Sr.Contact_Name__c = con.id;
        Sr.Case_Number__c = c1.Id;
        insert Sr;
        PageReference pageRef = Page.Customer_top10_issues;
        pageRef.getParameters().put('accid',acc.id);
        Test.setCurrentPage(pageRef); 
        
          Service_Request__c srp= new Service_Request__c();           
        ApexPages.StandardController can = new ApexPages.StandardController(srp);
        
        CustomerTop10IssuesClass CustIssue= new CustomerTop10IssuesClass (can);  
        CustIssue.getSRRecords();
        CustIssue.getSRRecordsAll();    
        CustIssue.getATRSRRecords();
        CustIssue.getATRSRRecordsAll();
        CustIssue.getBGASRRecords();
        CustIssue.getBGASRRecordsAll();
        CustIssue.getDSSRRecords();
        CustIssue.getDSSRRecordsAll();

        }
    
    
    }
    static testmethod void CustomerTop10IssuesClasstst1(){
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name != 'System Administrator' and isactive = true order by createddate asc limit 1];
              // Country__c cnt=new Country__c(Name='India');
      
       Account acc= new Account(name='Test Account1',Strategic_Business_Unit__c='BGA');
       insert acc;
       System.runAs(usr){
       Contact con = new Contact();
        con.LastName = 'testupdate1';
        con.FirstName = 'sbucon';
        con.AccountId = acc.Id;
         con.Contact_Function__c='Infosys';
         con.Primary_Email_Address__c = 'sofiya.peermohamed@nttdata.com';
        con.Employee_Number__c = 'E123123';
        //con.Account_Contact_Name__c=acc.name;
        con.Email='harikishore.vutukuri@honeywell.com';
        //con.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
       // con.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;
        insert con;
         Case c1=new Case(App_Email__c='test1@g.com',SuppliedEmail='test@g.com',Origin='BGAMobileApp');
         insert c1; 
     
        Service_Request__c  Sr =new Service_Request__c();
        Sr.Subject__c='DS Test SR';
        Sr.SR_Type__c='Significant Customer Dissatisfier';
        Sr.Priority__c='High';
        Sr.Status__c='Open';
        Sr.Problem_Description__c='Technical Problem';
        Sr.Account_Name__c=acc.id;
        Sr.Customer_Due_Date__c=date.today();
        Sr.Top_Technical_Issue__c=true;
        Sr.Contact_Name__c = con.id;
        Sr.Case_Number__c = c1.Id;
        insert Sr;
        PageReference pageRef = Page.Customer_top10_issues;
        pageRef.getParameters().put('accid',acc.id);
        Test.setCurrentPage(pageRef); 
        
          Service_Request__c srp= new Service_Request__c();           
        ApexPages.StandardController can = new ApexPages.StandardController(srp);
        
        CustomerTop10IssuesClass CustIssue= new CustomerTop10IssuesClass (can);  
        CustIssue.getSRRecords();
        CustIssue.getSRRecordsAll();    
        CustIssue.getATRSRRecords();
        CustIssue.getATRSRRecordsAll();
        CustIssue.getBGASRRecords();
        CustIssue.getBGASRRecordsAll();
        CustIssue.getDSSRRecords();
        CustIssue.getDSSRRecordsAll();        }
    
    }
    static testmethod void CustomerTop10IssuesClasstst2(){
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name != 'System Administrator' and isactive = true order by createddate asc limit 1];
              // Country__c cnt=new Country__c(Name='India');
      
       Account acc= new Account(name='Test Account2',Strategic_Business_Unit__c='D&S');
       insert acc;
       System.runAs(usr){
       Contact con = new Contact();
        con.LastName = 'testupdate2';
        con.FirstName = 'sbucon';
        con.AccountId = acc.Id;
         con.Contact_Function__c='Infosys';
         con.Primary_Email_Address__c = 'sofiya.peermohamed@nttdata.com';
        con.Employee_Number__c = 'E123123';
        //con.Account_Contact_Name__c=acc.name;
        con.Email='harikishore.vutukuri@honeywell.com';
        //con.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
       // con.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;
        insert con;
         Case c1=new Case(App_Email__c='test1@g.com',SuppliedEmail='test@g.com',Origin='BGAMobileApp');
         insert c1; 
     
        Service_Request__c  Sr =new Service_Request__c();
        Sr.Subject__c='DS Test SR';
        Sr.SR_Type__c='Significant Customer Dissatisfier';
        Sr.Priority__c='High';
        Sr.Status__c='Open';
        Sr.Problem_Description__c='Technical Problem';
        Sr.Account_Name__c=acc.id;
        Sr.Customer_Due_Date__c=date.today();
        Sr.Top_Technical_Issue__c=true;
        Sr.Contact_Name__c = con.id;
        Sr.Case_Number__c = c1.Id;
        insert Sr;
        PageReference pageRef = Page.Customer_top10_issues;
        pageRef.getParameters().put('accid',acc.id);
        Test.setCurrentPage(pageRef); 
        
          Service_Request__c srp= new Service_Request__c();           
        ApexPages.StandardController can = new ApexPages.StandardController(srp);
        
        CustomerTop10IssuesClass CustIssue= new CustomerTop10IssuesClass (can);  
        CustIssue.getSRRecords();
        CustIssue.getSRRecordsAll();    
        CustIssue.getATRSRRecords();
        CustIssue.getATRSRRecordsAll();
        CustIssue.getBGASRRecords();
        CustIssue.getBGASRRecordsAll();
        CustIssue.getDSSRRecords();
        CustIssue.getDSSRRecordsAll();
        CustIssue.getscroll();
        }
    
    }
    }