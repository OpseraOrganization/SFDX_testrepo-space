/*
Test class for ProcessPO email handler

1/10/13    CC @ IC    Created per Internet Creations Case 76323
*/
@isTest(seealldata=true)
public class TestProcessPO{
       
    static case cs1;
    static case cs2;
    static case cs3;
    
    static Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
    static ProcessPO ProcPO = new ProcessPO();
        
    static {
         /*  
        //avoid routing failures from E2CP
        Insert new E2CP__casepref__c(
            name = 'E2C_EMAIL_CASE_ORIGIN_ROUTING_1'
            , E2CP__prefcat__c = 'e2c_email_case_origin_routing'
            , E2CP__preflong__c = 'name@company.com'
            , E2CP__prefval__c = 'Email,Normal,'
        );
     
        Account acc = new Account();
        acc.Name = 'Honeywell Test';
        acc.OwnerId = [Select Id from User where Name = 'API User SFDC Cust Master'].Id;
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airlines';
        acc.CBT_Team__c = 'Americas';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
        try {
        insert acc;
        }catch(Exception ex){}
         //Account acc= new Account(name='Test Account');
    //insert acc;
        
        Contact con = new Contact();
        con.Phone_1__c='231231231';
        con.Honeywell_ID__c='E521948';
        con.Address_Line_1__c='Testtsstts';
        con.Address_Line_2__c='Testtsstts';
        con.Address_Line_3__c='Testtsstts';
        con.City_Name__c='Testtsstts';
        con.State_Code__c='Testtsstts';
        con.Country_Name__c='Testtsstts';
        con.FirstName = 'KapilM';
        con.LastName = 'Singh';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'test@honeywell.com';
        con.Email='test@honeywell.com';
        
        try {
        insert con;
        }catch(Exception ex){}
        */
            Contact con = [select id from contact limit 1];
        //test cases
        cs1 = new Case(Subject = 'Single PO', Product_Serial_Number__c = '12341234', 
                       //No_FCR_Reason__c = 'test', For Ticket INC000009687923
                       contactid=con.id);
        cs2 = new Case(Subject = 'Mutli PO 1', Product_Serial_Number__c = '56785678', 
                       //No_FCR_Reason__c = 'test', For Ticket INC000009687923
                       contactid=con.id);
        cs3 = new Case(Subject = 'Mutli PO 2', Product_Serial_Number__c = '56785678', 
                       //No_FCR_Reason__c = 'test',For Ticket INC000009687923
                       contactid=con.id);
        insert new Case[]{cs1,cs2,cs3};
        
        //Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        //ProcessPO ProcPO = new ProcessPO();
        
    }
    
    static testMethod void testEmail1(){
        
        //test 1 - exactly one hit on cases
        //should attach email to case 1
        ProcPO.handleInboundEmail(getNewEmail('PO Test 12341234'), env);
        
       // system.assertEquals(3, [select id from Case].size());
       // system.assertEquals(1, [select id from EmailMessage where ParentId = :cs1.Id].size());
        system.assertEquals(0, [select id from EmailMessage where ParentId = :cs2.Id].size());
        system.assertEquals(0, [select id from EmailMessage where ParentId = :cs3.Id].size());
    
    }
    
    static testMethod void testEmail2(){
    
        //test 2 - twos hit on cases
        //should send to E2CP
        ProcPO.handleInboundEmail(getNewEmail('PO Test 56785678'), env);
        
        //system.assertEquals(4, [select id from Case].size());
        system.assertEquals(0, [select id from EmailMessage where ParentId = :cs1.Id].size());
        system.assertEquals(0, [select id from EmailMessage where ParentId = :cs2.Id].size());
        system.assertEquals(0, [select id from EmailMessage where ParentId = :cs3.Id].size());
    
    }
    
    static testMethod void testEmail3(){
    
        //test 3 - no hits on cases
        //should send to E2CP
        ProcPO.handleInboundEmail(getNewEmail('PO Test 999999999'), env);
        
       // system.assertEquals(4, [select id from Case].size());
        system.assertEquals(0, [select id from EmailMessage where ParentId = :cs1.Id].size());
        system.assertEquals(0, [select id from EmailMessage where ParentId = :cs2.Id].size());
        system.assertEquals(0, [select id from EmailMessage where ParentId = :cs3.Id].size());
    
    }
    
    static Messaging.InboundEmail getNewEmail(string subj){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEmail.Header h = new Messaging.InboundEmail.Header();
        h.name = 'hdr';
        h.value = 'val';
        email.headers = new Messaging.InboundEmail.Header[]{h};
        email.subject = subj;
        email.plainTextBody = 'Body of email';
        email.toAddresses = new String[]{'name@company.com'};
        email.fromAddress = 'test@honeywell.com';
        email.replyto = 'test@honeywell.com';
        return email;
    }

}