@isTest
public class Reg_TestDataFactory {
    public static void createTestRecords(){
        
        //get superuser test data
        
        List<contact > conList = new List<contact >();
        List<Account_Email_Domains__c> domainlist = new List<Account_Email_Domains__c>();
        List<Account> acclist = new List<Account>();
        List<Portal_Honeywell_Id__c> porHonList = new List<Portal_Honeywell_Id__c>();
        Country__c countryval = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval;
        
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id, Portal_Permissioned_Content__c = 'ATR - Basic Access',Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        accList.add(honeywellAccount);
        account honeywellAccount1 = new account(name='test_case_account1',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        accList.add(honeywellAccount1);
        account honeywellAccount3 = new account(name='test_case_account1',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        accList.add(honeywellAccount3);
        insert accList;          
        contact honeywellContact = new contact(firstname='test',Portal_Temp_Primary_Email__c = 'test@yahoo.com',Contact_Status__c='Active',lastname='user1',Primary_Email_Address__c = 'test@gmail.com',Email='test@gmail.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297',Is_Portal_Super_User__c = true);
        contact honeywellContact1 = new contact(firstname='test1',Primary_Email_Address__c = 'test@honeywell.com',Portal_Temp_Primary_Email__c = 'test@honeywell.com',Contact_Status__c='Active',lastname='user1',Email='test@honeywell.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23456');
        contact honeywellContact2 = new contact(firstname='test2',Primary_Email_Address__c = 'test@gmail.com',Portal_Temp_Primary_Email__c = 'test@honeywell.com',Contact_Status__c='Active',lastname='user1',Email='testuser1@internal.com',accountid=honeywellAccount1.id,Honeywell_ID__c='E23457');
        contact honeywellContact3 = new contact(firstname='test3',Primary_Email_Address__c = 'test@honeywell.com',Contact_Status__c='Active',lastname='user1',Email='testuser1@gmail123.com',accountid=honeywellAccount3.id,Honeywell_ID__c='foxtrot37');
        conList.add(honeywellContact );
        conList.add(honeywellContact1 );
        conList.add(honeywellContact2 );
        conList.add(honeywellContact3 );
        insert conList;
        Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id,primary_honeywell_id__c= true);
        porHonList.add(phi);
        Portal_Honeywell_Id__c   phi1 = new Portal_Honeywell_Id__c(name='E23456',Contact__c=honeywellContact1.id,primary_honeywell_id__c= true);
        porHonList.add(phi1);
        Portal_Honeywell_Id__c   phi2 = new Portal_Honeywell_Id__c(name='E23457',Contact__c=honeywellContact2.id,primary_honeywell_id__c= true);
        porHonList.add(phi2);
        Portal_Honeywell_Id__c   phi3 = new Portal_Honeywell_Id__c(name='foxtrot37',Contact__c=honeywellContact3.id,primary_honeywell_id__c= true,Portal_Status__c='Active');
        porHonList.add(phi3);
        
        insert porHonList;
        
        Account_Email_Domains__c domain=new Account_Email_Domains__c();
        domain.Account_Email_Domain__c='gmail.com';
        domain.Name='Gmail';
        domain.Internal_Email_Domain__c=true;
        domain.Account__c = honeywellAccount1.Id; 
        
        Account_Email_Domains__c domain2 =new Account_Email_Domains__c();
        domain2.Account_Email_Domain__c='gmail.com';
        domain2.Name='Gmail1';
        domain2.Internal_Email_Domain__c=false;  
        domain2.Account__c = honeywellAccount.Id; 
        
        Account_Email_Domains__c domain3 =new Account_Email_Domains__c();
        domain3.Account_Email_Domain__c='honeywell.com';
        domain3.Name='honeywell';
        domain3.Internal_Email_Domain__c=false;  
        domain3.Account__c = honeywellAccount3.Id; 
        
        
        domainlist.add(domain);
        domainlist.add(domain2);
        domainlist.add(domain3);
        
        insert domainlist;
        
        //get DomainType test data
        
        Account_Email_Domains__c accEmailDomain = new Account_Email_Domains__c();
        accEmailDomain.Name = 'Test Domain';
        accEmailDomain.Account_Email_Domain__c = 'testdomain.com';
        accEmailDomain.Internal_Email_Domain__c = False;
        insert accEmailDomain;
        
        Account_Email_Domains__c accEmailDomain1 = new Account_Email_Domains__c();
        accEmailDomain1.Name = 'Test1 Domain';
        accEmailDomain1.Account_Email_Domain__c = 'test1domain.com';
        accEmailDomain1.Internal_Email_Domain__c = True;
        insert accEmailDomain1;   
        
        //get aircraft test data
        list<Platform__c> p = new list<Platform__c>();
        Platform__c aircraft = new Platform__c(Make__c = 'testing' , Model__c = 'ModelTest' , Serial_Number_Format__c = 'serialTest');
        p.add(aircraft);
        Platform__c aircraft_1 = new Platform__c(Make__c = 'testing' , Model__c = 'ModelTest_1' , Serial_Number_Format__c = 'serialTest_1');
        p.add(aircraft_1);
        insert p;
        
        //get CountryStates test data
        Country__c c=new Country__c(name='Test',ISO_Country_Code__c='TS',SFDC_Country_Name__c='Test Country');
        insert c;
        Country_States__c states =new Country_States__c(Country__c=c.id,name='test sate');
        
        //Bulk Details
        Country__c countryval_1 = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval_1;
        account honeywellAccount_1 = new account(name='Reg_TestDataFactory',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount_1;
        contact honeywellContact_1 = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
        insert honeywellContact_1;
        Portal_Honeywell_Id__c   phi_1 = new Portal_Honeywell_Id__c(name='T54321',Contact__c=honeywellContact.id,primary_honeywell_id__c= true);
        insert phi_1;
        
        
        //ErrorTest test data
        List<REG_API_Trace_Detail__c> listOfErrors =new List<REG_API_Trace_Detail__c>(); 
        String userid;
        try{
            userid=[SELECT ID from User limit 1].Id;
            
        }
        catch(Exception e){
            System.debug('Error in SOQL');
        }
        for(Integer i=0;i<=10;i++){
            REG_API_Trace_Detail__c errorRecord=new REG_API_Trace_Detail__c();
            errorRecord.API_Name__c='Test API'+i;
            errorRecord.user__c=userid;
            
            
            errorRecord.error_Code__c=500;
            errorRecord.error_Message__c='Internal Server Error'+i;
            errorRecord.inputs__c='Caused by Test API'+i;
            listOfErrors.add(errorRecord);
        }
        insert listOfErrors;
        
        
        //PortalAccountTest test data
        /***List<Country__c > conListpat = new List<Country__c >();
        List<account > acclistpat = new List<account >();
        List<Account_Email_Domains__c > domlistpat = new List<Account_Email_Domains__c >();
        List<Account_Address__c > accaddlistpat = new List<Account_Address__c >();
        
        Country__c countryval0 = new Country__c(name='India',SFDC_Country_Name__c='India');
        Country__c countryval1 = new Country__c(name='US',SFDC_Country_Name__c='US');
        Country__c countryval2 = new Country__c(name='Canada',SFDC_Country_Name__c='Canada');
        conListpat.add(countryval0 );
        conListpat.add(countryval1 );
        conListpat.add(countryval2 );
        insert conListpat;
        
        Country_States__c conStat = new Country_States__c(Country__c = countryval2.Id, Name = 'GA');
        insert conStat;
        
        account honeywellAccount01 = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval0.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        account honeywellAccount11 = new account(name='test_case_account1',Customer_Status__c='Active',Country__c=countryval1.id,Report_Country_Name__c='US',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account1');
        account honeywellAccount21 = new account(name='test_case_account2',Customer_Status__c='Active',Country__c=countryval2.id,Report_Country_Name__c='Canada',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account2');
        acclistpat.add(honeywellAccount01 );
        acclistpat.add(honeywellAccount11 );
        acclistpat.add(honeywellAccount21 );
        insert acclistpat;
        
        Account_Email_Domains__c accEmailDom = new Account_Email_Domains__c(Account__c = honeywellAccount01.Id, Account_Email_Domain__c = 'tcs.com' );
        Account_Email_Domains__c accEmailDom1 = new Account_Email_Domains__c(Account__c = honeywellAccount11.Id, Account_Email_Domain__c = 'tcs.com' );
        Account_Email_Domains__c accEmailDom2 = new Account_Email_Domains__c(Account__c = honeywellAccount21.Id, Account_Email_Domain__c = 'tcs.com' );
        domlistpat.add(accEmailDom );
        domlistpat.add(accEmailDom1 );
        domlistpat.add(accEmailDom2 );
        insert domlistpat;
        
        Account_Address__c accadd = new Account_Address__c(Account_Name__c = honeywellAccount01.Id, Report_City_Name__c = 'Pune', Report_Country_Codes__c = 'IN', Report_State_Code__c = '', Is_Primary_Address__c = True );
        Account_Address__c accadd1 = new Account_Address__c(Account_Name__c = honeywellAccount01.Id, Report_City_Name__c = 'Bangalore', Report_Country_Codes__c = 'IN', Report_State_Code__c = '', Is_Primary_Address__c = False );
        Account_Address__c accadd2 = new Account_Address__c(Account_Name__c = honeywellAccount21.Id, Report_City_Name__c = '', Report_Country_Codes__c = 'CN', Report_State_Code__c = '', Is_Primary_Address__c = False );
        Account_Address__c accadd3 = new Account_Address__c(Account_Name__c = honeywellAccount11.Id, Report_City_Name__c = '', Report_Country_Codes__c = 'US', Report_State_Code__c = 'GA', Is_Primary_Address__c = True );
        Account_Address__c accadd4 = new Account_Address__c(Account_Name__c = honeywellAccount11.Id, Report_City_Name__c = 'Boston', Report_Country_Codes__c = 'US', Report_State_Code__c = 'GA', Is_Primary_Address__c = False);
        Account_Address__c accadd5 = new Account_Address__c(Account_Name__c = honeywellAccount21.Id, Report_City_Name__c = 'Toronto', Report_Country_Codes__c = 'CN', Report_State_Code__c = '', Is_Primary_Address__c = False );
        Account_Address__c accadd6 = new Account_Address__c(Account_Name__c = honeywellAccount21.Id, Report_City_Name__c = 'Toronto', Report_Country_Codes__c = 'CN', Report_State_Code__c = 'MN', Is_Primary_Address__c = False );
        //Account_Address__c accadd7 = new Account_Address__c(Account_Name__c = honeywellAccount21.Id, Report_City_Name__c = 'Toronto', Report_Country_Codes__c = 'CN', Report_State_Code__c = 'TR', Is_Primary_Address__c = True );
        accaddlistpat.add(accadd );
        accaddlistpat.add(accadd1 );
        accaddlistpat.add(accadd2 );
        accaddlistpat.add(accadd3 );
        accaddlistpat.add(accadd4 );
        accaddlistpat.add(accadd5 );
        accaddlistpat.add(accadd6 );
        insert accaddlistpat;***/
        
        
        //PortalUserRegistration test data
        /***Portal_User_Registration__C pur=new Portal_User_Registration__C(emailAddress__c='test.user01@xyz.com',honeywell_Id__c='testyuser01');
        insert pur;***/
        
    }
    
    public static void createTestRecordsPortalUser(){   
        //PortalUser test data
        List<contact > conList = new List<contact >(); 
        List<Account_Email_Domains__c> domainlist = new List<Account_Email_Domains__c>();
        List<Account> acclist = new List<Account>();
        List<Portal_Honeywell_Id__c> porHonList = new List<Portal_Honeywell_Id__c>();
        Country__c countryval = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval;
        Portal_Access_Template__c temp = new Portal_Access_Template__c(Record_Class__c='None',Record_Code__c='None',Retention_Hold_Reason__c='test hold reason',Template_Description__c='test template desc', Name ='Generic');
        insert temp;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id, Portal_Permissioned_Content__c = 'ATR - Basic Access',Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        accList.add(honeywellAccount);
        account honeywellAccount1 = new account(name='test_case_account1',ATR_Portal_Access_Template__c = temp.id,Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        accList.add(honeywellAccount1);
        insert accList;          
        contact honeywellContact = new contact(firstname='test',Portal_Temp_Primary_Email__c = 'test@yahoo.com',Contact_Status__c='Active',lastname='user1',Primary_Email_Address__c = 'test@gmail123.com',Email='test@gmail123.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
        contact honeywellContact1 = new contact(firstname='test1',Primary_Email_Address__c = 'test@honeywell.com',Portal_Temp_Primary_Email__c = 'test@honeywell.com',Contact_Status__c='Active',lastname='user1',Email='test@honeywell.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23456');
        contact honeywellContact2 = new contact(firstname='test2',Primary_Email_Address__c = 'test@gmail.com',Portal_Temp_Primary_Email__c = 'test@honeywell.com',Contact_Status__c='Active',lastname='user1',Email='testuser1@internal.com',accountid=honeywellAccount1.id,Honeywell_ID__c='E23457');
        contact honeywellContact3 = new contact(firstname='test3',Primary_Email_Address__c = 'test@gmail.com',Contact_Status__c='Active',lastname='user1',Email='testuser1@gmail123.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23458');
        conList.add(honeywellContact );
        conList.add(honeywellContact1 );
        conList.add(honeywellContact2 );
        conList.add(honeywellContact3 );
        insert conList;
        Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id,primary_honeywell_id__c= true);
        porHonList.add(phi);
        Portal_Honeywell_Id__c   phi1 = new Portal_Honeywell_Id__c(name='E23456',Contact__c=honeywellContact1.id,primary_honeywell_id__c= true);
        porHonList.add(phi1);
        Portal_Honeywell_Id__c   phi2 = new Portal_Honeywell_Id__c(name='E23457',Contact__c=honeywellContact2.id,primary_honeywell_id__c= true);
        porHonList.add(phi2);
        
        insert porHonList;
        
        Account_Email_Domains__c domain=new Account_Email_Domains__c();
        domain.Account_Email_Domain__c='internal.com';
        domain.Name='Internal';
        domain.Internal_Email_Domain__c=true;
        Account_Email_Domains__c domain1=new Account_Email_Domains__c();
        domain1.Account_Email_Domain__c='honeywell.com';
        domain1.Name='Honeywell';
        domain1.Internal_Email_Domain__c=false;
        domain1.Account__c = honeywellAccount1.Id;
        Account_Email_Domains__c domain2 =new Account_Email_Domains__c();
        domain2.Account_Email_Domain__c='tcs.com';
        domain2.Name='TCS';
        domain2.Internal_Email_Domain__c=false;  
        domain2.Account__c = honeywellAccount.Id;              
        domainlist.add(domain);
        domainlist.add(domain1);
        domainlist.add(domain2);
        Account_Email_Domains__c domain3=new Account_Email_Domains__c();
        domain3.Account_Email_Domain__c='honeywell.com';
        domain3.Name='Honeywell';
        domain3.Internal_Email_Domain__c=false;
        domain3.Account__c = honeywellAccount.Id;        
        domainlist.add(domain3);
        Account_Email_Domains__c domain4 =new Account_Email_Domains__c();
        domain4.Account_Email_Domain__c='tcs.com';
        domain4.Name='TCS';
        domain4.Internal_Email_Domain__c=false;  
        domain4.Account__c = honeywellAccount.Id;              
        domainlist.add(domain4);
        
        insert domainlist;
        Contact_Address__c newContactAddress=new Contact_Address__c();
        newContactAddress.contact__c=honeywellContact.Id ;
        newContactAddress.address_type__c='Office' ;
        newContactAddress.address_status__c='Active';
        newContactAddress.is_primary_address__c=true ;
        newContactAddress.reporting_street_address_line_1__c='Line 1';
        newContactAddress.reporting_street_address_line_2__c='Line 2';
        newContactAddress.reporting_street_address_line_3__c='Line 3';
        newContactAddress.reporting_city_name__c='City';
        newContactAddress.reporting_address_postal_code__c='400007';
        newContactAddress.reporting_country_name__c='India';
        newContactAddress.report_country_codes__c='IN';
        
        INSERT newContactAddress;
        Account_Address__c accAdd = new Account_Address__c(Denied_Party_Status__c = 'Blocked', Account_Name__c = honeywellAccount.id);
        insert accAdd;
        
        system.debug('temp==='+temp);  
        REG_Is_Generic__c isGen = new REG_Is_Generic__c(Name ='Is Generic', id__c = temp.id); 
        insert isGen;  
        Account_Contact__c accCon = new Account_Contact__c(Account_Name__c = honeywellAccount.id , Contact__c = honeywellContact.id);
        insert accCon;
        case cs = new case(Origin = 'BGAMobileApp' , Subject = 'testing123' , Status = 'Analysis');
        insert cs;
    }
    
    
    public static void createTestRecordsPortalContact(){
        
        //PortalContactTools test data
        List<Contact_Tool_Access__c > conTList = new List<Contact_Tool_Access__c >(); 
        List<Account> acountList=new List<Account>();
        List<contact > conList = new List<contact >();
        List<Portal_Tools_Master__c > ptmList = new List<Portal_Tools_Master__c >();
        List<Account_Tools__c> accToolsList = new List<Account_Tools__c >();
        List<case> caseList = new List<case>();
        List<Portal_Honeywell_Id__c> porList = new List<Portal_Honeywell_Id__c>();
        List<Country__c > countryList = new List<Country__c >();
        
        Country__c countryval1 = new Country__c(name='India',SFDC_Country_Name__c='India',ISO_Country_Code__c='IN',isEmbargoed__c = false, isSanctioned__c =false);
        Country__c countryval2 = new Country__c(name='Canada',SFDC_Country_Name__c='Canada',ISO_Country_Code__c='CA',isEmbargoed__c = true, isSanctioned__c =true);
        Country__c countryval3 = new Country__c(name='USA',SFDC_Country_Name__c='USA',ISO_Country_Code__c='US', isSanctioned__c =true);
        Country__c countryval4 = new Country__c(name='Australia',SFDC_Country_Name__c='Australia',ISO_Country_Code__c='AU');
        countryList.add(countryval1);
        countryList.add(countryval2);
        countryList.add(countryval3);
        countryList.add(countryval4);
        insert countryList;
        
        Portal_Access_Template__c temp = new Portal_Access_Template__c( Name ='Generic',Record_Class__c='None',Record_Code__c='None',Retention_Hold_Reason__c='test hold reason',Template_Description__c='test template desc');
        insert temp; 
        Portal_Access_Template__c temp1 = new Portal_Access_Template__c(Name ='Honeywell', Record_Class__c='None',Record_Code__c='None',Retention_Hold_Reason__c='test hold reason',Template_Description__c='test template desc');
        insert temp1;
        system.debug('temp==='+temp);
        
        Account a=new account(Name='Test Account', ATR_Portal_Access_Template__c = temp.id, Customer_Status__c='Active',Country__c=countryval2.id,Report_Country_Name__c='Canada',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell1 account');
        //account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval1.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Aero Level',CBT__c='Aero Level Other',CBT_Team__c='Aero Level Other',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        account honeywellAccount = new account(name='test_case_account',ATR_Portal_Access_Template__c = temp1.id,Customer_Status__c='Active',Country__c=countryval1.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        account honeywellAccount1 = new account(name='Test Account1',ATR_Portal_Access_Template__c = temp.id,Customer_Status__c='Active',Country__c=countryval4.id,Report_Country_Name__c='Australia',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account1');
        // account honeywellAccount2 = new account(name='test_revalidate_account',ATR_Portal_Access_Template__c = temp.id,Customer_Status__c='Active',Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany');
        //account honeywellAccount3 = new account(name='Test Account3',ATR_Portal_Access_Template__c = temp1.id,Customer_Status__c='Active',Country__c=countryval1.id,Report_Country_Name__c='Australia',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account1');
        acountList.add(a);
        acountList.add(honeywellAccount);
        acountList.add(honeywellAccount1);
        //acountList.add(honeywellAccount2);
        //acountList.add(honeywellAccount3);
        insert acountList;
        contact honeywellContact = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297', country_code__c = 'IN',postal_code__c = '411057',state_code__c = 'MA',Citizenship_Country__c = 'India',Contact_Birth_Country__c = 'India', Birth_City__c = 'Pune', Permanent_Resident_Expiration_Date__c = date.valueof('2019-09-01'),Address_Line_1__c = 'wakad',Address_Line_2__c = 'dutt mandir', City_Name__c = 'Pune');
        contact honeywellContact1 = new contact(firstname='test1',Contact_Status__c='Active',lastname='user1',Email='testuser1@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23456' ,Citizenship_Country__c = 'Canada',Contact_Birth_Country__c = 'Canada', Birth_City__c = 'Toronto', Permanent_Resident_Expiration_Date__c = date.valueof('2019-09-01'));
        contact honeywellContact2 = new contact(firstname='test2',Contact_Status__c='Active',lastname='user1',Email='testuser2@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23457' ,Citizenship_Country__c = 'USA');
        contact honeywellContact3 = new contact(firstname='test3',Contact_Status__c='Active',lastname='user1',Email='testuser3@itc.com',accountid=a.id,Honeywell_ID__c='T134298', country_code__c = 'CA',postal_code__c = '411057',state_code__c = 'BC',Citizenship_Country__c = 'Canada',Contact_Birth_Country__c = 'Canada', Birth_City__c = 'Toronto', Permanent_Resident_Expiration_Date__c = date.valueof('2019-09-01'),Address_Line_1__c = 'wakad',Address_Line_2__c = 'dutt mandir', City_Name__c = 'Toronto',Country_Name__c = 'Canada');
        //contact honeywellContact4 = new contact(firstname='test4',Contact_Status__c='Active',lastname='user1',Email='testuser3@itc.com',accountid=a.id,Honeywell_ID__c='T134297', country_code__c = 'CA',postal_code__c = '411057',state_code__c = 'BC',Citizenship_Country__c = 'Canada',Contact_Birth_Country__c = 'Canada', Birth_City__c = 'Toronto', Permanent_Resident_Expiration_Date__c = date.valueof('2019-09-01'),Address_Line_1__c = 'wakad',Address_Line_2__c = 'dutt mandir', City_Name__c = 'Toronto',Country_Name__c = 'Canada');
        contact honeywellContact5 = new contact(firstname='test5',Contact_Status__c='Active',lastname='user1',Email='testuser5@honeywell.com',primary_email_address__c = 'testuser5@honeywell.com',accountid=honeywellAccount1.id,Honeywell_ID__c='T134290', country_code__c = 'AU',postal_code__c = '411057',Citizenship_Country__c = 'Australia',Contact_Birth_Country__c = 'Australia', Birth_City__c = 'Sydney', Permanent_Resident_Expiration_Date__c = date.valueof('2019-09-01'),Address_Line_1__c = 'wakad',Address_Line_2__c = 'dutt mandir', City_Name__c = 'Sydney');
        // contact honeywellContact6 = new contact(firstname='test6',Contact_Status__c ='Active',lastname='user1',Email='testuser6@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134299', country_code__c = 'IN',postal_code__c = '411057',state_code__c = 'MA',Citizenship_Country__c = 'India',Contact_Birth_Country__c = 'India', Birth_City__c = 'Pune', Permanent_Resident_Expiration_Date__c = date.valueof('2019-09-01'),Address_Line_1__c = 'wakad',Address_Line_2__c = 'dutt mandir', City_Name__c = 'Pune');
        
        conList.add(honeywellContact );
        conList.add(honeywellContact1 );
        conList.add(honeywellContact2 );
        conList.add(honeywellContact3 );
        //conList.add(honeywellContact4 );
        conList.add(honeywellContact5 );
        //conList.add(honeywellContact6 ); - any ways commented
        insert conList;
        
        
        //Contact_Address__c cd1 = new Contact_Address__c(Reporting_Street_Address_Line_1__c='test',Report_Country_Codes__c='878',Reporting_City_Name__c='Active',Is_Primary_Address__c = true,Address_Status__c = 'Active',Contact__c=conList[5].id);
        //insert cd1;
        REG_Is_Generic__c isGen = new REG_Is_Generic__c(Name ='Is Generic', id__c = temp.id); 
        insert isGen;
        
        List<Account_Contact__c> accconList =new List<Account_Contact__c>();
        Account_Contact__c ac =new Account_Contact__c(Account_Name__c=a.Id,Contact__c=honeywellContact.Id);
        Account_Contact__c ac1 =new Account_Contact__c(Account_Name__c=a.Id,Contact__c=honeywellContact.Id);
        accconList.add(ac);
        accconList.add(ac1);
        insert accconList;
        system.debug('list data ***'+accconList);
        
        Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id,primary_honeywell_id__c= true,Portal_Status__c = 'Active');
        porList.add(phi);
        
        Portal_Honeywell_Id__c   phi1 = new Portal_Honeywell_Id__c(name='T134298',Contact__c=honeywellContact3.id,primary_honeywell_id__c= true,Portal_Status__c = 'Active');
        porList.add(phi1);
        Portal_Honeywell_Id__c   phi2 = new Portal_Honeywell_Id__c(name='T134290',Contact__c=honeywellContact5.id,primary_honeywell_id__c= true,Portal_Status__c = 'Active');
        porList.add(phi2);
        Portal_Honeywell_Id__c   phi3 = new Portal_Honeywell_Id__c(name='E23457',Contact__c=honeywellContact2.id,primary_honeywell_id__c= true,Portal_Status__c = 'Active');
        porList.add(phi3);
        Portal_Honeywell_Id__c   phi4 = new Portal_Honeywell_Id__c(name='E23456',Contact__c=honeywellContact1.id,primary_honeywell_id__c= true,Portal_Status__c = 'Active');
        porList.add(phi4);        
        
        insert porList;
        
        Portal_Tools_Master__c ptM = new Portal_Tools_Master__c(name = 'Test', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
        ptmList.add(ptM);
        Portal_Tools_Master__c ptM3 = new Portal_Tools_Master__c(name = 'Test3', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
        ptmList.add(ptM3);    
        Portal_Tools_Master__c ptM5 = new Portal_Tools_Master__c(name = 'REG Warranty and Programs', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
        ptmList.add(ptM5);        
        Portal_Tools_Master__c ptM6 = new Portal_Tools_Master__c(name = 'REG eFindings / Historical Findings', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved', Queue_Id__c='00G30000001zXD4EAM');
        ptmList.add(ptM6);
        Portal_Tools_Master__c ptM7 = new Portal_Tools_Master__c(name = 'REG Honeywell Training', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved', Queue_Id__c='00G30000002Yz1z');
        ptmList.add(ptM7);
        Portal_Tools_Master__c ptM8 = new Portal_Tools_Master__c(name = 'REG Technical Knowledge Center', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
        ptmList.add(ptM8);
        Portal_Tools_Master__c ptM9 = new Portal_Tools_Master__c(name = 'REG Contracts/Reporting', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved',Queue_Id__c='00G30000002YUD6EAO');
        ptmList.add(ptM9);
        Portal_Tools_Master__c ptM10 = new Portal_Tools_Master__c(name = 'REG MCORE', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved',Queue_Id__c='00G1B000004bJMf');
        ptmList.add(ptM10);        
        Portal_Tools_Master__c ptM12 = new Portal_Tools_Master__c(name = 'REG Product Returns and Repairs', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved',Queue_Id__c='00G30000001zXD4EAM');
        ptmList.add(ptM12);        
        Portal_Tools_Master__c ptM13 = new Portal_Tools_Master__c(name = 'REG Order Status', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved',Queue_Id__c='00G30000001zXD4EAM');
        ptmList.add(ptM13);        
        Portal_Tools_Master__c ptM11 = new Portal_Tools_Master__c(name = 'REG Online Ordering', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved', Queue_Id__c = '00G30000001zXD4EAM');
        ptmList.add(ptM11);        
        Portal_Tools_Master__c ptM15 = new Portal_Tools_Master__c(name = 'REG Technical Publications', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved',Queue_Id__c= '00G30000001zXC1EAM');
        ptmList.add(ptM15);        
        Portal_Tools_Master__c ptM16 = new Portal_Tools_Master__c(name = 'REG Aerospace (NavDB)', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved',Queue_Id__c='00G13000004LyeREAS');
        ptmList.add(ptM16);
        Portal_Tools_Master__c ptM17 = new Portal_Tools_Master__c(name = 'REG Aerospace (EGPWS)', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved',Queue_Id__c='00G13000004LyeREAS');
        ptmList.add(ptM17);
        Portal_Tools_Master__c ptM18 = new Portal_Tools_Master__c(name = 'REG Aerospace (ASDS)', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved', Queue_Id__c='00G13000004LyeREAS');
        ptmList.add(ptM18);
        Portal_Tools_Master__c ptM19 = new Portal_Tools_Master__c(name = 'REG Core Returns Management System', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
        ptmList.add(ptM19);
        Portal_Tools_Master__c ptM20 = new Portal_Tools_Master__c(name = 'REG MyGDC - Global Data Center', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
        ptmList.add(ptM20);
        Portal_Tools_Master__c ptM21 = new Portal_Tools_Master__c(name = 'Reg Bendix/King Dealer Access', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved', Queue_Id__c='00G30000002YUCcEAO');
        ptmList.add(ptM21);
        
        
        
        insert ptmList;
        Account_Tools__c acT19 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM6.Id , Account_Name__c = honeywellAccount.Id );
        Account_Tools__c acT4 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM7.Id , Account_Name__c = honeywellAccount.Id );
        Account_Tools__c acT5 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM8.Id , Account_Name__c = honeywellAccount.Id );
        Account_Tools__c acT11 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM5.Id , Account_Name__c = honeywellAccount.Id );
        Account_Tools__c acT6 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM9.Id , Account_Name__c = honeywellAccount.Id );
        Account_Tools__c acT7 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM10.Id , Account_Name__c = honeywellAccount.Id );
        Account_Tools__c acT8 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM11.Id , Account_Name__c = honeywellAccount.Id );
        Account_Tools__c acT12 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM15.Id , Account_Name__c = a.Id); 
        Account_Tools__c acT121 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM15.Id , Account_Name__c = honeywellAccount1.Id);
        Account_Tools__c acT122 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM15.Id , Account_Name__c = honeywellAccount.Id);
        Account_Tools__c acT13 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM16.Id , Account_Name__c = honeywellAccount.Id );
        Account_Tools__c acT131 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM16.Id , Account_Name__c = a.Id );
        Account_Tools__c acT132 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM16.Id , Account_Name__c = honeywellAccount1.Id );
        Account_Tools__c acT14 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM17.Id , Account_Name__c = honeywellAccount.Id );
        Account_Tools__c acT141 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM17.Id , Account_Name__c = a.Id );
        Account_Tools__c acT142 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM17.Id , Account_Name__c = honeywellAccount1.Id );
        Account_Tools__c acT15 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM18.Id , Account_Name__c = a.Id );
        Account_Tools__c acT151 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM18.Id , Account_Name__c = honeywellAccount1.Id );
        Account_Tools__c acT152 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM18.Id , Account_Name__c = honeywellAccount.Id );
        Account_Tools__c acT16 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM19.Id , Account_Name__c = honeywellAccount.Id );
        Account_Tools__c acT17 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM20.Id , Account_Name__c = honeywellAccount.Id );
        Account_Tools__c acT18 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM21.Id , Account_Name__c = honeywellAccount.Id );  
        accToolsList.add(acT11);
        accToolsList.add(acT16);
        accToolsList.add(acT17);
        accToolsList.add(acT18);
        accToolsList.add(acT19);
        accToolsList.add(acT5);
        accToolsList.add(acT4);
        accToolsList.add(acT6);
        accToolsList.add(acT7);       
        accToolsList.add(acT8);       
        accToolsList.add(acT12);
        accToolsList.add(acT121);
        accToolsList.add(acT122);
        accToolsList.add(acT13);
        accToolsList.add(acT14); 
        accToolsList.add(acT131);
        accToolsList.add(acT141);
        accToolsList.add(acT142);
        accToolsList.add(acT15);
        accToolsList.add(acT132);
        accToolsList.add(acT151);
        accToolsList.add(acT152);
        
        insert accToolsList;
        
        Contact_Tool_Access__c caT2 = new Contact_Tool_Access__c(Portal_Tool_Master__c= ptM10.Id , MCORE_Account_Type__c = 'test',Manager_Name__c = 'test', MCORE_Purpose_of_MCORE_Access__c = 'test',name = 'REG MCORE', Portal_Honeywell_ID__c = 'E23456', Request_Status__c = 'Denied',CRM_Contact_ID__c = honeywellContact1.Id );
        Contact_Tool_Access__c caT4 = new Contact_Tool_Access__c(Portal_Tool_Master__c= ptM16.Id , MCORE_Account_Type__c = 'test',Manager_Name__c = 'test', MCORE_Purpose_of_MCORE_Access__c = 'test',name = 'REG Aerospace (NavDB)', Portal_Honeywell_ID__c = 'E23456', Request_Status__c = 'Approved',CRM_Contact_ID__c = honeywellContact1.Id );
        Contact_Tool_Access__c caT3 = new Contact_Tool_Access__c(Portal_Tool_Master__c= ptM11.Id , MCORE_Account_Type__c = 'test',Manager_Name__c = 'test', MCORE_Purpose_of_MCORE_Access__c = 'test',name = 'REG Online Ordering', Portal_Honeywell_ID__c = 'E23456', Request_Status__c = 'Approved',CRM_Contact_ID__c = honeywellContact1.Id );
        Contact_Tool_Access__c caT5 = new Contact_Tool_Access__c(Portal_Tool_Master__c= ptM12.Id , MCORE_Account_Type__c = 'test',Manager_Name__c = 'test', MCORE_Purpose_of_MCORE_Access__c = 'test',name = 'REG Order Status', Portal_Honeywell_ID__c = 'E23456', Request_Status__c = 'Approved',CRM_Contact_ID__c = honeywellContact1.Id );
        Contact_Tool_Access__c caT6 = new Contact_Tool_Access__c(Portal_Tool_Master__c= ptM13.Id , MCORE_Account_Type__c = 'test',Manager_Name__c = 'test', MCORE_Purpose_of_MCORE_Access__c = 'test',name = 'REG Product Returns and Repairs', Portal_Honeywell_ID__c = 'E23456', Request_Status__c = 'Approved',CRM_Contact_ID__c = honeywellContact1.Id );
        
        conTList.add(caT5);
        conTList.add(caT4);
        conTList.add(caT3); 
        conTList.add(caT6);
        conTList.add(caT2);
        
        insert conTList;
        
        case cas = new case(Honeywell_ID__c = 'T134297', contactId =honeywellContact.id, subject = 'MyAerospace Registration Request – REG MyGDC - Global Data Center' );  
        caseList.add(cas);
        insert caseList;
        
        List<REG_Master_Tool_Name__c>  Rtnm1 = new  List<REG_Master_Tool_Name__c>();
        REG_Master_Tool_Name__c toolDataa1 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM21.Id , Tool_Name__c = 'Bendix/King Dealer Access', Name = 'Reg Bendix/King Dealer Access');
        Rtnm1.add(toolDataa1);
        REG_Master_Tool_Name__c toolDataa2 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM19.Id , Tool_Name__c = 'Core Returns Management System', Name = 'REG Core Returns Management System');
        Rtnm1.add(toolDataa2);
        REG_Master_Tool_Name__c toolDataa3 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM20.Id , Tool_Name__c = 'MyGDC - Global Data Center', Name = 'REG MyGDC - Global Data Center');
        Rtnm1.add(toolDataa3);
        REG_Master_Tool_Name__c toolDataa4 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM5.Id , Tool_Name__c = 'Warranty and Programs Claims/Credit Memo Access', Name = 'REG Warranty and Programs');
        Rtnm1.add(toolDataa4);         
        REG_Master_Tool_Name__c toolDataa5 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM6.Id , Tool_Name__c = 'eFindings', Name = 'REG eFindings / Historical Findings');
        Rtnm1.add(toolDataa5);
        REG_Master_Tool_Name__c toolDataa6 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM7.Id , Tool_Name__c = 'Honeywell Training', Name = 'REG Honeywell Training');
        Rtnm1.add(toolDataa6);
        REG_Master_Tool_Name__c toolDataa7 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM8.Id , Tool_Name__c = 'Technical Knowledge Center', Name = 'REG Technical Knowledge Center');
        Rtnm1.add(toolDataa7);         
        REG_Master_Tool_Name__c toolDataa8 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM9.Id , Tool_Name__c = 'Contracts/Reporting (HAPP, MPP, MSP)', Name = 'REG Contracts/Reporting');
        Rtnm1.add(toolDataa8);         
        REG_Master_Tool_Name__c toolDataa9 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM10.Id , Tool_Name__c = 'MCORE (Maintenance Cost Reduction)', Name = 'REG MCORE');
        Rtnm1.add(toolDataa9);         
        REG_Master_Tool_Name__c toolDataa10 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM11.Id , Tool_Name__c = 'Online Ordering', Name = 'REG Online Ordering');
        Rtnm1.add(toolDataa10); 
        REG_Master_Tool_Name__c toolDataa11 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM13.Id , Tool_Name__c = 'Order Status', Name = 'REG Order Status');
        Rtnm1.add(toolDataa11); 
        REG_Master_Tool_Name__c toolDataa12 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM12.Id , Tool_Name__c = 'Product Returns and Repairs', Name = 'REG Product Returns and Repairs');
        Rtnm1.add(toolDataa12);                       
        REG_Master_Tool_Name__c toolDataa13 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM15.Id , Tool_Name__c = 'Technical Publications', Name = 'REG Technical Publications');
        Rtnm1.add(toolDataa13);         
        REG_Master_Tool_Name__c toolDataa14 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM16.Id , Tool_Name__c = 'Aerospace Database Services (NavDB)', Name = 'REG Aerospace (NavDB)');
        Rtnm1.add(toolDataa14);
        REG_Master_Tool_Name__c toolDataa15 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM17.Id , Tool_Name__c = 'Aerospace Database Services (EGPWS)', Name = 'REG Aerospace (EGPWS)');
        Rtnm1.add(toolDataa15);
        
        REG_Master_Tool_Name__c toolDataa16 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM18.Id , Tool_Name__c = 'Aerospace Software & Data Services(ASDS)', Name = 'REG Aerospace (ASDS)');
        Rtnm1.add(toolDataa16);
        
        insert Rtnm1;
        
        //List <REG_PortalContact_Service.toolsWrap> resDataList = new List <REG_PortalContact_Service.toolsWrap>();
        
        //required for contracts reporting tool
        Contact_Aircraft__c conAircraft = new Contact_Aircraft__c();
        conAircraft.Name = 'Test Con Aircraft';
        conAircraft.CRM_Contact_ID__c = honeywellContact.Id;
        conAircraft.Record_Data_Owner__c = honeywellContact.Id;
        conAircraft.Aircraft_FMS__c = 'Test Con Aircraft_FMS__c';
        insert conAircraft;
        
        //required for tec pub tool
        Account_Email_Domains__c domain=new Account_Email_Domains__c();
        domain.Account_Email_Domain__c='honeywell.com';
        domain.Name='Internal';
        domain.Internal_Email_Domain__c=true;
        domain.Account__c = honeywellAccount1.Id;
        insert domain; 
              
    }
    
    public static void createTestRecordsForCase(){
         List<contact > conList = new List<contact >();
        List<case > caseList = new List<case >();
        List<SitecoreCaseType__c > customsettingList = new List<SitecoreCaseType__c >();
        List<Supported_Products__c > spList = new List<Supported_Products__c >();
        List<Platform__c > pfList = new List<Platform__c >();
         List<Service_Request__c > srList = new List<Service_Request__c >();
        
        SitecoreCaseType__c sc = new SitecoreCaseType__c(Name='WebsiteIssues/Registrationtoolaccess',Subject__c='MyAerospace Request Copy of Invoice');
        SitecoreCaseType__c sc1 = new SitecoreCaseType__c(Name='test',Case_Type__c='Services-AOG',Case_Record_Type__c='01230000000Zen1AAC',Origin__c='web',Subject__c='MyAerospace Request Copy of Invoice1');
        SitecoreCaseType__c sc3 = new SitecoreCaseType__c(Name='test1',Case_Type__c='Orders',Origin__c='web',Subject__c='MyAerospace Sending Payment');
        SitecoreCaseType__c sc2 = new SitecoreCaseType__c(Name='Global Customer Committee SR',Case_Record_Type__c='01230000000Zen1AAC',Subject__c=label.MyAerospace_Warranty_Credit_Request );
        SitecoreCaseType__c sc4 = new SitecoreCaseType__c(Name='WebsiteIssues/Registrationtoolaccess1',Case_Type__c='Global Customer Committee',Case_Record_Type__c='01230000000Zen1AAC',Subject__c=label.MyAerospace_Warranty_Credit_Request);
        SitecoreCaseType__c sc5 = new SitecoreCaseType__c(Name='OutSidePurchaseRequest',Case_Owner__c='005300000042rPLAAY',Case_Type__c='-',Case_Record_Type__c='01213000001ZSjNAAW',Subject__c='CP Authorization Part Number Needed');
        customsettingList.add(sc);
        customsettingList.add(sc1);
        customsettingList.add(sc2);
        customsettingList.add(sc3);
        customsettingList.add(sc4);
        customsettingList.add(sc5); 
        insert customsettingList;
        
        Supported_Products__c sp = new Supported_Products__c(Name='Tst',Product_Type__c='Yes',Status__c ='Active');
        spList.add(sp);
        insert spList;
        Platform__c pf = new Platform__c(Name='Tst',Make__c='Yes',Model__c='Active');
        pfList.add(pf);
        insert pfList;
        
        //service request
         Service_Request__c sr = new Service_Request__c(EmailId__c='amit.kate2@honeywell.com',Subject__c='test',Problem_Description__c='description');
        srList.add(sr);
        insert srList;
        
        Account a=new account(Name='STANDARD AERO INC',  Customer_Status__c='Active',Report_Country_Name__c='Canada',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell1 account');
        insert a;
        //Account a1=new account(Name='STANDARD AERO INC',  Customer_Status__c='Active',Report_Country_Name__c='Canada',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell1 account');
        //insert a1;
        contact honeywellContact = new contact(firstname='test',accountid=a.Id,Contact_Status__c='Active',lastname='user1',Primary_Email_Address__c='testuser@itc.com',Email='testuser@itc.com',Honeywell_ID__c='T134297', country_code__c = 'IN',Postal_Code__c='10010',Job_Title__c ='ABC',state_code__c = 'MA',Citizenship_Country__c = 'India',Contact_Birth_Country__c = 'India', Birth_City__c = 'Pune', Permanent_Resident_Expiration_Date__c = date.valueof('2019-09-01'),Address_Line_1__c = 'wakad',Address_Line_2__c = 'dutt mandir', City_Name__c = 'Pune');
        contact honeywellContact1=new contact(LastName='test',email='test@test.com',Primary_Email_Address__c='test@test.com',Phone_1__c='1234567890',Address_Line_1__c='test',Address_Line_2__c='test',City_Name__c='test',State_Code__c='12',Country_Name__c='test',Postal_Code__c='565',accountid=a.id,Honeywell_ID__c='T134297');
         contact honeywellContact2=new contact(LastName='test2',email='test2@test.com',Primary_Email_Address__c='test2@test.com',Phone_1__c='1234567890',Address_Line_1__c='test',Address_Line_2__c='test',City_Name__c='test',State_Code__c='12',Country_Name__c='test',Postal_Code__c='565',accountid=a.id,Honeywell_ID__c='T1342982');
        conList.add(honeywellContact);        
        conList.add(honeywellContact1);        
        conList.add(honeywellContact2);        
        insert conList;
        case cas = new case(Honeywell_ID__c = 'T134297',Address_Line_1__c='',Address_Line_2__c='',City_Name__c='',State_Code__c='',Country_Name__c='',Postal_Code__c='',accountid=a.id, contactId =honeywellContact.id, subject = 'MyAerospace Request Copy of Invoice' );  
        caseList.add(cas);
        insert caseList;
        
        //account team member
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
         //AccountTeamMember atm = new AccountTeamMember(UserId = u.id ,accountid=a.Id, TeamMemberRole= 'Customer Business Manager (CBM)');
        //insert atm;
        AccountTeamMember atm1 = new AccountTeamMember(UserId = usr.id ,accountid=a.Id, TeamMemberRole= 'Customer Service Manager');
        insert atm1;
    }
}