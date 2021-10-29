@isTest
public class TestClass_AgreementAttachmentToContract
{
    public static testMethod void testschedule() 
    {
        Test.StartTest();
        AgreementAttachmentToContract sh1 = new AgreementAttachmentToContract();
        String sch = '0 45 09 ? * 1-7';
        system.schedule('Test Agreement Check', sch, sh1);
      
        Test.stopTest();
    }
    
    public static testMethod void testschedule1() 
    {
        Test.StartTest();
       
        AgreementAttachmentToContract sh2 = new AgreementAttachmentToContract();
        String sch2 = '0 00 10 ? * 1-7';
        system.schedule('Test Agreement Check2', sch2, sh2 );        
        
        Test.stopTest();
    }
    
//added by Ashwin using Maria's Credentials.
    
    public static testMethod void testschedule2() 
    {
        Test.StartTest();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';        
        insert acc;
        
        List<RecordType> rt = [select id from recordtype where (name='MSP Contracts' or name='HAPP/MPP Contracts') and SObjectType='Contract'];
        
        contract  con = new contract();     
        con.Name = 'test';
        con.accountid=acc.id;
        con.Contract_3_months_Expiry__C=false;
        con.Contract_6_months_Expiry__C=false;
        con.MSP_Customer_Profile_Automation__c='Create Profile';
        con.status='draft';
        Con.RecordTypeId=rt[0].Id;
        Con.Renewal_Start_date__c=System.Today().addDays(-1);
        Con.Renewal_Account_Name_Dealer__c=acc.id;
        insert con;
        
        AgreementAttachmentToContract sh4 = new AgreementAttachmentToContract();
        String sch = '0 45 09 ? * *';
        system.schedule('Test Agreement Check', sch, sh4);
        
        Test.stopTest();
    }
    
    public static testMethod void testschedule3() 
    {
        Test.StartTest();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';        
        acc.Report_Address_Line_2__c=Null;
        acc.Report_Address_Line_3__c='TestAddress';
        insert acc;
        
        Contact Cont=new Contact();
        Cont.LastName='TestCon';
        Cont.AccountId=acc.Id;
        Cont.Contact_Function__c='Accident Investigator';
        Insert Cont;
        
        List<RecordType> rt = [select id from recordtype where (name='MSP Contracts' or name='HAPP/MPP Contracts') and SObjectType='Contract'];
        
        contract  con = new contract();     
        con.Name = 'test';
        con.accountid=acc.id;
        con.Contract_3_months_Expiry__C=false;
        con.Contract_6_months_Expiry__C=false;
        con.MSP_Customer_Profile_Automation__c='Create Profile';
        con.status='draft';
        Con.RecordTypeId=rt[0].Id;
        Con.Renewal_Start_date__c=System.Today().addDays(-1);
        Con.Renewal_Account_Name_Dealer__c=acc.id;
        Con.Renewal_End_Date__c=Null;
        Con.Renewal_Notes__c='TestNotes';
        Con.Renewal_Order_Receipt_Name__c=Cont.Id;
        Con.Renewal_Fleet_Discount__c='100%200';
        insert con;
        
        AgreementAttachmentToContract sh4 = new AgreementAttachmentToContract();
        String sch = '0 45 09 ? * *';
        system.schedule('Test Agreement Check', sch, sh4);
        
        Test.stopTest();
    }
    public static testMethod void testAgreementAttachmentToContract() 
    {
              
        Account newAcct = new account();
        newAcct.name = 'test account code coverage';
       
        insert newAcct;
        
        contact con = new contact();
        con.lastname='test name';
        insert con;
        
        List<RecordType> rt = [select id from recordtype where (name='MSP Contracts' or name='HAPP/MPP Contracts') and SObjectType='Contract'];

        
        Contract objContract = new Contract();
        objContract.name = 'Con1';
        objContract.AccountId = newAcct.id;
        objContract.RecordTypeId=rt[0].Id;        
        objContract.Renewal_Account_Name_Dealer__c =newAcct.id;
        objContract.Renewal_Notes__c ='Test';
        objContract.Renewal_Customer__c=newAcct.id;
        objContract.Renewal_Order_Receipt_Name__c =con.id;
        objContract.Renewal_Fleet_Discount__c='100';
        objContract.Renewal_End_Date__c = date.newinstance(2022, 8, 17); 
        objContract.Renewal_Start_date__c = System.Today().addDays(-1);
        
        insert objContract;
        
        Case cas  = new case();
        cas.Serv_Contract__c =objContract.id;        
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
    
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        
        insert cas;
        

    }
}