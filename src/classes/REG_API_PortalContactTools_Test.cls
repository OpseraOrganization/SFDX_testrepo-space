@IsTest

private class REG_API_PortalContactTools_Test
{
          /** @TestSetup
    static void fncDataSetup() {
        Reg_TestDataFactory.createTestRecordsPortalContact();        
    }**/
    
    @TestSetup
    static void testData() 
    { 
        //List<Contact_Tool_Access__c > conTList = new List<Contact_Tool_Access__c >(); 
        List<Account> acountList=new List<Account>();
        List<contact > conList = new List<contact >();
        List<Portal_Tools_Master__c > ptmList = new List<Portal_Tools_Master__c >();
        List<Account_Tools__c> accToolsList = new List<Account_Tools__c >();
        //List<case> caseList = new List<case>();
        
        /* boolean isEmbarConAdd = false;
boolean isSancConAdd = false;
boolean isSancAcc = false ;
boolean isEmbarAcc = false ;
boolean isSancCitizn =false;
boolean isEmbarCitizn = false;
boolean isGeneric = false;
*/
        
        List<Country__c > countryList = new List<Country__c >();
        Country__c countryval1 = new Country__c(name='India',SFDC_Country_Name__c='India',ISO_Country_Code__c='IN');
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
        account honeywellAccount = new account(name='test_case_account',ATR_Portal_Access_Template__c = temp1.id,Customer_Status__c='Active',Country__c=countryval1.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        account honeywellAccount1 = new account(name='Test Account1',ATR_Portal_Access_Template__c = temp.id,Customer_Status__c='Active',Country__c=countryval4.id,Report_Country_Name__c='Australia',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account1');
        account honeywellAccount2 = new account(name='test_revalidate_account',ATR_Portal_Access_Template__c = temp.id,Customer_Status__c='Active',Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany');
        account honeywellAccount3 = new account(name='Test Account3',ATR_Portal_Access_Template__c = temp1.id,Customer_Status__c='Active',Country__c=countryval1.id,Report_Country_Name__c='Australia',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account1');
        account honeywellAccount6 = new account(name='test_case_account1',Customer_Status__c='Active',Country__c=countryval1.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        acountList.add(honeywellAccount6);
        acountList.add(a);
        acountList.add(honeywellAccount);
        acountList.add(honeywellAccount1);
        acountList.add(honeywellAccount2);
        acountList.add(honeywellAccount3);
        insert acountList;
        contact honeywellContact = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297', country_code__c = 'IN',postal_code__c = '411057',state_code__c = 'MA',Citizenship_Country__c = 'India',Contact_Birth_Country__c = 'India', Birth_City__c = 'Pune', Permanent_Resident_Expiration_Date__c = date.valueof('2019-09-01'),Address_Line_1__c = 'wakad',Address_Line_2__c = 'dutt mandir', City_Name__c = 'Pune');
        contact honeywellContact1 = new contact(firstname='test1',Contact_Status__c='Active',lastname='user1',Email='testuser1@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23456' ,Citizenship_Country__c = 'Canada',Contact_Birth_Country__c = 'Canada', Birth_City__c = 'Toronto', Permanent_Resident_Expiration_Date__c = date.valueof('2019-09-01'));
        contact honeywellContact2 = new contact(firstname='test2',Contact_Status__c='Active',lastname='user1',Email='testuser2@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23457' ,Citizenship_Country__c = 'USA');
        contact honeywellContact3 = new contact(firstname='test3',Contact_Status__c='Active',lastname='user1',Email='testuser3@itc.com',accountid=a.id,Honeywell_ID__c='T134298', country_code__c = 'CA',postal_code__c = '411057',state_code__c = 'BC',Citizenship_Country__c = 'Canada',Contact_Birth_Country__c = 'Canada', Birth_City__c = 'Toronto', Permanent_Resident_Expiration_Date__c = date.valueof('2019-09-01'),Address_Line_1__c = 'wakad',Address_Line_2__c = 'dutt mandir', City_Name__c = 'Toronto',Country_Name__c = 'Canada');
        //contact honeywellContact4 = new contact(firstname='test4',Contact_Status__c='Active',lastname='user1',Email='testuser3@itc.com',accountid=a.id,Honeywell_ID__c='T134297', country_code__c = 'CA',postal_code__c = '411057',state_code__c = 'BC',Citizenship_Country__c = 'Canada',Contact_Birth_Country__c = 'Canada', Birth_City__c = 'Toronto', Permanent_Resident_Expiration_Date__c = date.valueof('2019-09-01'),Address_Line_1__c = 'wakad',Address_Line_2__c = 'dutt mandir', City_Name__c = 'Toronto',Country_Name__c = 'Canada');
        contact honeywellContact5 = new contact(firstname='test5',Contact_Status__c='Active',lastname='user1',Email='testuser5@honeywell.com',primary_email_address__c = 'testuser5@honeywell.com',accountid=honeywellAccount1.id,Honeywell_ID__c='T134290', country_code__c = 'AU',postal_code__c = '411057',Citizenship_Country__c = 'Australia',Contact_Birth_Country__c = 'Australia', Birth_City__c = 'Sydney', Permanent_Resident_Expiration_Date__c = date.valueof('2019-09-01'),Address_Line_1__c = 'wakad',Address_Line_2__c = 'dutt mandir', City_Name__c = 'Sydney');
        contact honeywellContact6 = new contact(firstname='test6',Contact_Status__c ='Active',lastname='user1',Email='testuser6@itc.com',accountid=honeywellAccount6.id,Honeywell_ID__c='T852369',Contact_Is_Employee__c = true);
        conList.add(honeywellContact );
        conList.add(honeywellContact1 );
        conList.add(honeywellContact2 );
        conList.add(honeywellContact3 );
        //conList.add(honeywellContact4 );
        conList.add(honeywellContact5 );
        conList.add(honeywellContact6 );
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
        // List<Contact_Address__c>  cd= new List<Contact_Address__c>();
        //Contact_Address__c  caddress = new Contact_Address__c (Reporting_City_Name__c='test', Reporting_Street_Address_Line_1__c='test',Contact__c=honeywellContact.id,Report_Country_Codes__c='IN',Is_Primary_Address__c = true);
        //cd.add(caddress);
        //insert cd;
        Portal_Tools_Master__c ptM = new Portal_Tools_Master__c(name = 'Test', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
        ptmList.add(ptM);
        Portal_Tools_Master__c ptM3 = new Portal_Tools_Master__c(name = 'Test3', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
        ptmList.add(ptM3);          
        insert ptmList;       
        
        Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id,primary_honeywell_id__c= true,Portal_Status__c = 'Active' , Email_Sent_Counter__c = 5);
        insert phi;
        Portal_Honeywell_Id__c   phi1 = new Portal_Honeywell_Id__c(name='T134298',Email_Sent_Counter__c = 4,Contact__c=honeywellContact3.id,primary_honeywell_id__c= true,Portal_Status__c = 'InActive');
        insert phi1;
        Portal_Honeywell_Id__c   phi2 = new Portal_Honeywell_Id__c(name='T134299',Email_Sent_Counter__c = 0,Contact__c=honeywellContact3.id,primary_honeywell_id__c= true,Portal_Status__c = 'Active');
        insert phi2;
        Portal_Honeywell_Id__c   phi6 = new Portal_Honeywell_Id__c(name='T852369',Email_Sent_Counter__c = 0,Contact__c=honeywellContact6.id,primary_honeywell_id__c= true,Portal_Status__c = 'Active');
        insert phi6;
        /*
Portal_Tools_Master__c ptM = new Portal_Tools_Master__c(name = 'Test', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
ptmList.add(ptM);
Portal_Tools_Master__c ptM1 = new Portal_Tools_Master__c(name = 'Test1', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
ptmList.add(ptM1);
Portal_Tools_Master__c ptM2 = new Portal_Tools_Master__c(name = 'Test2', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
ptmList.add(ptM2);
Portal_Tools_Master__c ptM3 = new Portal_Tools_Master__c(name = 'Test3', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
ptmList.add(ptM3);
Portal_Tools_Master__c ptM4 = new Portal_Tools_Master__c(name = 'Technical Publications', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
ptmList.add(ptM4);
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
Portal_Tools_Master__c ptM11 = new Portal_Tools_Master__c(name = 'REG Online Ordering', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved', Queue_Id__c = '00G30000001zXD4EAM');
ptmList.add(ptM11);   

Portal_Tools_Master__c ptM12 = new Portal_Tools_Master__c(name = 'REG Product Returns and Repairs', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved',Queue_Id__c='00G30000001zXD4EAM');
ptmList.add(ptM12);
Portal_Tools_Master__c ptM13 = new Portal_Tools_Master__c(name = 'REG Order Status', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved',Queue_Id__c='00G30000001zXD4EAM');
ptmList.add(ptM13);
//Portal_Tools_Master__c ptM14 = new Portal_Tools_Master__c(name = 'REG Online Ordering', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved',Queue_Id__c='00G30000001zXD4EAM');
//ptmList.add(ptM14);

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
Account_Tools__c acT = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM.Id , Account_Name__c = honeywellAccount.Id );
accToolsList.add(acT);
Account_Tools__c acT1 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM1.Id , Account_Name__c = honeywellAccount.Id );
accToolsList.add(acT1);
Account_Tools__c acT2 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM2.Id , Account_Name__c = honeywellAccount.Id );
accToolsList.add(acT2);
Account_Tools__c acT3 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM4.Id , Account_Name__c = honeywellAccount.Id );
accToolsList.add(acT3);
Account_Tools__c acT11 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM5.Id , Account_Name__c = honeywellAccount.Id );
Account_Tools__c acT19 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM6.Id , Account_Name__c = honeywellAccount.Id );
Account_Tools__c acT4 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM7.Id , Account_Name__c = honeywellAccount.Id );
Account_Tools__c acT5 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM8.Id , Account_Name__c = honeywellAccount.Id );
Account_Tools__c acT6 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM9.Id , Account_Name__c = honeywellAccount.Id );
Account_Tools__c acT7 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM10.Id , Account_Name__c = honeywellAccount.Id );
Account_Tools__c acT8 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM11.Id , Account_Name__c = honeywellAccount.Id );
Account_Tools__c acT9 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM12.Id , Account_Name__c = honeywellAccount.Id );
Account_Tools__c acT10 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM13.Id , Account_Name__c = honeywellAccount.Id );
Account_Tools__c acT12 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM15.Id , Account_Name__c = honeywellAccount.Id);
Account_Tools__c acT121 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM15.Id , Account_Name__c = honeywellAccount1.Id);
Account_Tools__c acT13 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM16.Id , Account_Name__c = honeywellAccount.Id );
Account_Tools__c acT131 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM16.Id , Account_Name__c = a.Id );
Account_Tools__c acT132 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM16.Id , Account_Name__c = honeywellAccount1.Id );
Account_Tools__c acT14 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM17.Id , Account_Name__c = honeywellAccount.Id );
Account_Tools__c acT141 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM17.Id , Account_Name__c = a.Id );
Account_Tools__c acT142 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM17.Id , Account_Name__c = honeywellAccount1.Id );
Account_Tools__c acT15 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM18.Id , Account_Name__c = a.Id );
Account_Tools__c acT151 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM18.Id , Account_Name__c = honeywellAccount1.Id );
Account_Tools__c acT16 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM19.Id , Account_Name__c = honeywellAccount.Id );
Account_Tools__c acT17 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM20.Id , Account_Name__c = honeywellAccount.Id );
Account_Tools__c acT18 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM21.Id , Account_Name__c = honeywellAccount.Id );


accToolsList.add(acT4);
accToolsList.add(acT5);
accToolsList.add(acT6);
accToolsList.add(acT7);
accToolsList.add(acT8);
accToolsList.add(acT9);
accToolsList.add(acT10);
accToolsList.add(acT11); 
accToolsList.add(acT12);
accToolsList.add(acT121);
accToolsList.add(acT13);
accToolsList.add(acT131);
accToolsList.add(acT132);
accToolsList.add(acT14);
accToolsList.add(acT141);
accToolsList.add(acT142);
accToolsList.add(acT15);
accToolsList.add(acT151);
accToolsList.add(acT16);
accToolsList.add(acT17);
accToolsList.add(acT18);
accToolsList.add(acT19);
insert accToolsList;
Contact_Tool_Access__c caT = new Contact_Tool_Access__c(MCORE_Platform_of_most_interest1__c = 'test1',Portal_Tool_Master__c= ptM.Id, name = 'Test', Portal_Honeywell_ID__c = 'T134297', Request_Status__c = 'Approved',CRM_Contact_ID__c = honeywellContact.Id );
Contact_Tool_Access__c caT1 = new Contact_Tool_Access__c(Portal_Tool_Master__c= ptM1.Id, name = 'Test1', Portal_Honeywell_ID__c = 'T134297', Request_Status__c = 'Pending',CRM_Contact_ID__c = honeywellContact.Id );
Contact_Tool_Access__c caT2 = new Contact_Tool_Access__c(Portal_Tool_Master__c= ptM10.Id , MCORE_Account_Type__c = 'test',Manager_Name__c = 'test', MCORE_Purpose_of_MCORE_Access__c = 'test',name = 'REG MCORE', Portal_Honeywell_ID__c = 'E23456', Request_Status__c = 'Denied',CRM_Contact_ID__c = honeywellContact1.Id );
Contact_Tool_Access__c caT3 = new Contact_Tool_Access__c(Portal_Tool_Master__c= ptM11.Id , MCORE_Account_Type__c = 'test',Manager_Name__c = 'test', MCORE_Purpose_of_MCORE_Access__c = 'test',name = 'REG Online Ordering', Portal_Honeywell_ID__c = 'E23456', Request_Status__c = 'Approved',CRM_Contact_ID__c = honeywellContact1.Id );
Contact_Tool_Access__c caT4 = new Contact_Tool_Access__c(Portal_Tool_Master__c= ptM16.Id , MCORE_Account_Type__c = 'test',Manager_Name__c = 'test', MCORE_Purpose_of_MCORE_Access__c = 'test',name = 'REG Aerospace (NavDB)', Portal_Honeywell_ID__c = 'E23456', Request_Status__c = 'Approved',CRM_Contact_ID__c = honeywellContact1.Id );
Contact_Tool_Access__c caT5 = new Contact_Tool_Access__c(Portal_Tool_Master__c= ptM13.Id , MCORE_Account_Type__c = 'test',Manager_Name__c = 'test', MCORE_Purpose_of_MCORE_Access__c = 'test',name = 'REG Order Status', Portal_Honeywell_ID__c = 'E23456', Request_Status__c = 'Approved',CRM_Contact_ID__c = honeywellContact1.Id );
conTList.add(caT);
conTList.add(caT1); 
conTList.add(caT2); 
conTList.add(caT3); 
conTList.add(caT4); 
conTList.add(caT5); 
insert conTList;  
case cas = new case(Honeywell_ID__c = 'T134297', contactId =honeywellContact.id, subject = 'MyAerospace Registration Request – REG MyGDC - Global Data Center' );  
caseList.add(cas);
insert caseList;

List<REG_Master_Tool_Name__c>  Rtnm = new   List<REG_Master_Tool_Name__c>();
REG_Master_Tool_Name__c toolData = new REG_Master_Tool_Name__c(Tool_Id__c = ptM4.Id , Tool_Name__c = 'Technical Publications', Name = 'REG Technical Publications');
Rtnm.add(toolData);
REG_Master_Tool_Name__c toolDataa1 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM21.Id , Tool_Name__c = 'Bendix/King Dealer Access', Name = 'Reg Bendix/King Dealer Access');
Rtnm.add(toolDataa1);
REG_Master_Tool_Name__c toolDataa2 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM19.Id , Tool_Name__c = 'Core Returns Management System', Name = 'REG Core Returns Management System');
Rtnm.add(toolDataa2);
REG_Master_Tool_Name__c toolDataa3 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM20.Id , Tool_Name__c = 'MyGDC - Global Data Center', Name = 'REG MyGDC - Global Data Center');
Rtnm.add(toolDataa3);
REG_Master_Tool_Name__c toolDataa4 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM5.Id , Tool_Name__c = 'Warranty and Programs Claims/Credit Memo Access', Name = 'REG Warranty and Programs');
Rtnm.add(toolDataa4);
insert Rtnm;

List<REG_Master_Tool_Name__c>  Rtnm1 = new  List<REG_Master_Tool_Name__c>();
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

REG_Master_Tool_Name__c toolDataa11 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM12.Id , Tool_Name__c = 'Order Status', Name = 'REG Order Status');
Rtnm1.add(toolDataa11);
REG_Master_Tool_Name__c toolDataa12 = new REG_Master_Tool_Name__c(Tool_Id__c = ptM13.Id , Tool_Name__c = 'Product Returns and Repairs', Name = 'REG Product Returns and Repairs');
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
//REG_Is_Generic__c isGen = new REG_Is_Generic__c(Name = 'Is Generic', id__c = 'a06m0000006Qylh');
//insert isGen;
List <REG_PortalContact_Service.toolsWrap> resDataList = new List <REG_PortalContact_Service.toolsWrap>();


Contact_Aircraft__c conAircraft = new Contact_Aircraft__c();
conAircraft.Name = 'Test Con Aircraft';
conAircraft.CRM_Contact_ID__c = honeywellContact.Id;
conAircraft.Record_Data_Owner__c = honeywellContact.Id;
conAircraft.Aircraft_FMS__c = 'Test Con Aircraft_FMS__c';
insert conAircraft;


Account_Email_Domains__c domain=new Account_Email_Domains__c();
domain.Account_Email_Domain__c='honeywell.com';
domain.Name='Internal';
domain.Internal_Email_Domain__c=true;
domain.Account__c = honeywellAccount1.Id;
insert domain; 
*/
        
        
    }
    
    //====================update specific tool starts
    static testMethod void testUpdateSpecificTool(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        Portal_Tools_Master__c pRecord = [select id from Portal_Tools_Master__c where name = 'Test' limit 1];
        request.requestUri ='/contacts/T134297/tools/'+pRecord.Id;
        request.httpMethod = 'PUT';
        system.assertEquals('PUT',request.httpMethod);
        request.addHeader('Content-Type', 'application/json');
                Test.startTest();
        request.requestBody=Blob.valueOf('{"contactToolAccess":{},"caseComments":"Test1","caseAddInfo":"Test2"}'); 
        
        RestContext.request = request;       
        RestContext.response= response;
        
        REG_API_PortalContactTools.doPut();
        Test.stopTest();
        String result = response.responseBody.toString();
        system.assert(result.contains('404'));
    }
    
    static testMethod void testUpdateSpecificToolNoData(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        Portal_Tools_Master__c pRecord = [select id from Portal_Tools_Master__c where name = 'Test' limit 1];
        request.requestUri ='/contacts/H313671/tools/'+pRecord.Id;
        request.httpMethod = 'PUT';
        system.assertEquals('PUT',request.httpMethod);
        request.addHeader('Content-Type', 'application/json');
                Test.startTest();
        request.requestBody=Blob.valueOf('{"contactToolAccess":{},"caseComments":"Test1","caseAddInfo":"Test2"}'); 
        
        RestContext.request = request;       
        RestContext.response=response;
        
        REG_API_PortalContactTools.doPut();
        Test.stopTest();    
        String result = response.responseBody.toString();
        system.assert(result.contains('404'));
    }  
    //====================update specific tool ends
    //=====================update sold to starts
    static testMethod void testInsertSoldTo(){
        RestRequest request = new RestRequest();
         RestResponse response = new RestResponse();
        //Portal_Tools_Master__c pRecord = [select id from Portal_Tools_Master__c where name = 'Test3' limit 1];
        request.requestUri ='/contacts/T134297/soldTo/';
        //request.requestURI ='/contacts/soldTo/'+pRecord.Id;
        request.httpMethod = 'PUT';
        system.assertEquals('PUT',request.httpMethod);
        request.addHeader('Content-Type', 'application/json');
                Test.startTest();
        REG_API_PortalContactTools.JSON2Apex jsonObj = new REG_API_PortalContactTools.JSON2Apex ();
        contact contact = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test' LIMIT 1];
        List<account> accId =[select id from account where name = 'Test Account'];
        List<SAP_Contact_Sold_To__c> soldToList = new List<SAP_Contact_Sold_To__c>();
        SAP_Contact_Sold_To__c sapConSoldTo1 = new SAP_Contact_Sold_To__c();
        sapConSoldTo1.Name = 'Test sold to contact';
        sapConSoldTo1.Contact__c = contact.Id;
        sapConSoldTo1.Record_Data_Owner__c = contact.Id;
        sapConSoldTo1.SAP_Account_Sold_To__c = 'A120978';
        sapConSoldTo1.soldToToolAccess__c = 'ordersReturns';
        soldToList.add(sapConSoldTo1);
        SAP_Contact_Sold_To__c sapConSoldTo2 = new SAP_Contact_Sold_To__c();
        sapConSoldTo2.Name = 'Test sold to contact1';
        sapConSoldTo2.Contact__c = contact.Id;
        sapConSoldTo2.Record_Data_Owner__c = contact.Id;
        sapConSoldTo2.SAP_Account_Sold_To__c = 'R56789';
        sapConSoldTo2.soldToToolAccess__c = 'ordersReturns';
        soldToList.add(sapConSoldTo2);
        insert soldToList; 
        List<REG_API_PortalContactTools.soldTosWrappper> soldToWrapperList = new List<REG_API_PortalContactTools.soldTosWrappper>();
        for(SAP_Contact_Sold_To__c soldc :[SELECT Id,soldToToolAccess__c,Name,Contact__c,Record_Data_Owner__c,SAP_Account_Sold_To__c FROM SAP_Contact_Sold_To__c limit 1])
        {
            REG_API_PortalContactTools.soldTosWrappper soldToWrapper = new REG_API_PortalContactTools.soldTosWrappper();
            soldToWrapper.accountId = accId[0].Id;
            soldToWrapper.accountName = soldc.Name;
            soldToWrapper.soldToToolAccess = 'OrdersReturns';
            soldToWrapper.soldToId=soldc.SAP_Account_Sold_To__c ;
            soldToWrapperList.add(soldToWrapper);
        }     
        jsonObj.SoldTos = soldToWrapperList;  
        system.debug('jsonObj' +jsonObj);            
        // request.requestBody=Blob.valueOf('{"soldToId": "300599","accountName": "FLIGHTSAFETY INTL INC","accountId": "0013000000bFtXBAA0","siebelRowId" : "1+5XZ+1333","soldToToolAccess": "OrdersReturns"},{"soldToId": "300600","accountName": "FLIGHTSAFETY INTL INC","accountId": "0013000000bFtXBAA0","siebelRowId": "1+5XZ+1333","soldToToolAccess": "OrdersReturns"}'); 
        
        request.requestBody = Blob.valueOf(JSON.serialize(jsonObj));
        RestContext.request = request;       
        RestContext.response= response;
        

        REG_API_PortalContactTools.doPut();
        Test.stopTest(); 
        
        
    }
    static testMethod void testInsertSoldToNoData(){
        RestRequest request = new RestRequest();
        //Portal_Tools_Master__c pRecord = [select id from Portal_Tools_Master__c where name = 'Test3' limit 1];
        request.requestUri ='/contacts/H313671/soldTo/';
        //request.requestURI ='/contacts/soldTo/'+pRecord.Id;
        request.httpMethod = 'PUT';
        system.assertEquals('PUT',request.httpMethod);
        request.addHeader('Content-Type', 'application/json');
                
        Test.startTest();
        REG_API_PortalContactTools.JSON2Apex jsonObj = new REG_API_PortalContactTools.JSON2Apex ();
        contact contact = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test' LIMIT 1];
        List<account> accId =[select id from account where name = 'Test Account'];
        List<SAP_Contact_Sold_To__c> soldToList = new List<SAP_Contact_Sold_To__c>();
        SAP_Contact_Sold_To__c sapConSoldTo1 = new SAP_Contact_Sold_To__c();
        sapConSoldTo1.Name = 'Test sold to contact';
        sapConSoldTo1.Contact__c = contact.Id;
        sapConSoldTo1.Record_Data_Owner__c = contact.Id;
        sapConSoldTo1.SAP_Account_Sold_To__c = 'A120978';
        sapConSoldTo1.soldToToolAccess__c = 'ordersReturns';
        soldToList.add(sapConSoldTo1);
        SAP_Contact_Sold_To__c sapConSoldTo2 = new SAP_Contact_Sold_To__c();
        sapConSoldTo2.Name = 'Test sold to contact1';
        sapConSoldTo2.Contact__c = contact.Id;
        sapConSoldTo2.Record_Data_Owner__c = contact.Id;
        sapConSoldTo2.SAP_Account_Sold_To__c = 'R56789';
        sapConSoldTo2.soldToToolAccess__c = 'ordersReturns';
        soldToList.add(sapConSoldTo2);
        insert soldToList; 
        List<REG_API_PortalContactTools.soldTosWrappper> soldToWrapperList = new List<REG_API_PortalContactTools.soldTosWrappper>();
        for(SAP_Contact_Sold_To__c soldc :[SELECT Id,soldToToolAccess__c,Name,Contact__c,Record_Data_Owner__c,SAP_Account_Sold_To__c FROM SAP_Contact_Sold_To__c limit 1])
        {
            REG_API_PortalContactTools.soldTosWrappper soldToWrapper = new REG_API_PortalContactTools.soldTosWrappper();
            soldToWrapper.accountId = accId[0].Id;
            soldToWrapper.accountName = soldc.Name;
            soldToWrapper.soldToToolAccess = 'OrdersReturns';
            soldToWrapper.soldToId=soldc.SAP_Account_Sold_To__c ;
            soldToWrapperList.add(soldToWrapper);
        }     
        jsonObj.SoldTos = soldToWrapperList;  
        system.assert(!soldToWrapperList.isEmpty());     
        // request.requestBody=Blob.valueOf('{"soldToId": "300599","accountName": "FLIGHTSAFETY INTL INC","accountId": "0013000000bFtXBAA0","siebelRowId" : "1+5XZ+1333","soldToToolAccess": "OrdersReturns"},{"soldToId": "300600","accountName": "FLIGHTSAFETY INTL INC","accountId": "0013000000bFtXBAA0","siebelRowId": "1+5XZ+1333","soldToToolAccess": "OrdersReturns"}'); 
        
        request.requestBody = Blob.valueOf(JSON.serialize(jsonObj));
        
        RestContext.request = request;       
        RestContext.response=new RestResponse();

        REG_API_PortalContactTools.doPut();
        Test.stopTest();    
    }
    static testMethod void testInsertSoldToNoSoldTos(){
        RestRequest request = new RestRequest();
        // Portal_Tools_Master__c pRecord = [select id from Portal_Tools_Master__c where name = 'Test3' limit 1];
        request.requestUri ='/contacts/T134297/soldTo/';
        //request.requestURI ='/contacts/soldTo/'+pRecord.Id;
        request.httpMethod = 'PUT';
        system.assertEquals('PUT',request.httpMethod);
        request.addHeader('Content-Type', 'application/json');
                
        Test.startTest();
        REG_API_PortalContactTools.JSON2Apex jsonObj = new REG_API_PortalContactTools.JSON2Apex ();
        contact contact = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test' LIMIT 1];
        List<account> accId =[select id from account where name = 'Test Account'];
        List<SAP_Contact_Sold_To__c> soldToList = new List<SAP_Contact_Sold_To__c>();
        SAP_Contact_Sold_To__c sapConSoldTo1 = new SAP_Contact_Sold_To__c();
        sapConSoldTo1.Name = 'Test sold to contact';
        sapConSoldTo1.Contact__c = contact.Id;
        sapConSoldTo1.Record_Data_Owner__c = contact.Id;
        sapConSoldTo1.SAP_Account_Sold_To__c = 'text acc sold to';
        sapConSoldTo1.soldToToolAccess__c = 'ordersReturns';
        soldToList.add(sapConSoldTo1);
        SAP_Contact_Sold_To__c sapConSoldTo2 = new SAP_Contact_Sold_To__c();
        sapConSoldTo2.Name = 'Test sold to contact1';
        sapConSoldTo2.Contact__c = contact.Id;
        sapConSoldTo2.Record_Data_Owner__c = contact.Id;
        sapConSoldTo2.SAP_Account_Sold_To__c = 'text acc sold to';
        sapConSoldTo2.soldToToolAccess__c = 'ordersReturns';
        soldToList.add(sapConSoldTo2);
        insert soldToList; 
        system.assert(!soldToList.isEmpty());
        
        // request.requestBody=Blob.valueOf('{"soldToId": "300599","accountName": "FLIGHTSAFETY INTL INC","accountId": "0013000000bFtXBAA0","siebelRowId" : "1+5XZ+1333","soldToToolAccess": "OrdersReturns"},{"soldToId": "300600","accountName": "FLIGHTSAFETY INTL INC","accountId": "0013000000bFtXBAA0","siebelRowId": "1+5XZ+1333","soldToToolAccess": "OrdersReturns"}'); 
        request.requestBody = Blob.valueOf(JSON.serialize(jsonObj));
        RestContext.request = request;       
        RestContext.response=new RestResponse();

        REG_API_PortalContactTools.doPut();
        Test.stopTest();    
    }    
    /////================update sold to ends
    //==============================getAllSoldTo starts
    static testMethod void testGetAllSoldTo(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/T134297/soldTo';  //Request URL
        // request.addParameter('honid', 'T134297');
        request.httpMethod = 'GET';//HTTP Request Type
        system.assertEquals('GET',request.httpMethod);
        Test.startTest();
        REG_API_PortalContactTools.doGet();
        Test.stopTest();
        String result = response.responseBody.toString();
        system.assert(String.isNotBlank(result));
    }
    //==============================getAllSoldTo ends
    //==========================update tool access starts 
    /*
//===============================================moved to other class 
//Reg Bendix/King Dealer Access
static testMethod void testcheckToolAccess13(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;
Portal_Tools_Master__c pRecord14 = [select id from Portal_Tools_Master__c where name = 'Reg Bendix/King Dealer Access' limit 1];
request.requestUri ='/contacts/T134297/tools/'+ pRecord14.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();

request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
Test.startTest();
REG_API_PortalContactTools.doPost();
Test.stopTest();
}

//REG MyGDC - Global Data Center
static testMethod void testcheckToolAccess12(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;
Portal_Tools_Master__c pRecord13 = [select id from Portal_Tools_Master__c where name = 'REG MyGDC - Global Data Center' limit 1];
request.requestUri ='/contacts/T134297/tools/'+ pRecord13.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();

request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
Test.startTest();
REG_API_PortalContactTools.doPost();
Test.stopTest();
}
//REG Core Returns Management System
static testMethod void testcheckToolAccess11(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;
Portal_Tools_Master__c pRecord12 = [select id from Portal_Tools_Master__c where name = 'REG Core Returns Management System' limit 1];
request.requestUri ='/contacts/T134297/tools/'+ pRecord12.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();

request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
Test.startTest();
REG_API_PortalContactTools.doPost();
Test.stopTest();
}
//REG Warranty and Programs
static testMethod void testcheckToolAccess(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;

Test.startTest();
Portal_Tools_Master__c pRecord = [select id from Portal_Tools_Master__c where name = 'REG Warranty and Programs' limit 1];
request.requestUri ='/contacts/T134297/tools/'+ pRecord.Id;

//Portal_Tools_Master__c pRecord1 = [select id from Portal_Tools_Master__c where name = 'REG Technical Knowledge Center' limit 1];
//request.requestUri ='/contacts/T134297/tools/'+ pRecord1.Id;

request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');


REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();

request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}
//REG Technical Knowledge Center
static testMethod void testcheckToolAccess1(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord1 = [select id from Portal_Tools_Master__c where name = 'REG Technical Knowledge Center' limit 1];
request.requestUri ='/contacts/T134297/tools/'+ pRecord1.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();

request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}
//REG Contracts/Reporting
static testMethod void testcheckToolAccess2(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord3 = [select id from Portal_Tools_Master__c where name = 'REG Contracts/Reporting' limit 1];
request.requestUri ='/contacts/T134297/tools/'+ pRecord3.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();
//jsonObj.contactToolAccess = [SELECT id, Portal_Tool_Master__c,Name, Portal_Honeywell_ID__c, Request_Status__c, CRM_Contact_ID__c FROM contact_Tool_Access__c LIMIT 1];
jsonObj.contactAircraft = [SELECT Id,Name,CRM_Contact_ID__c,Record_Data_Owner__c,Aircraft_FMS__c FROM Contact_Aircraft__c LIMIT 1];


jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact LIMIT 1];
request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}
//REG MCORE
static testMethod void testcheckToolAccessMcore(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord4 = [select id from Portal_Tools_Master__c where name = 'REG MCORE' limit 1];
request.requestUri ='/contacts/T134297/tools/'+ pRecord4.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();
jsonObj.contactToolAccess = [SELECT id, Portal_Tool_Master__c,Name, Portal_Honeywell_ID__c, Request_Status__c, CRM_Contact_ID__c FROM contact_Tool_Access__c limit 1];
jsonObj.McorePlatformOfMostInterest = 'test1' + ',' + 'test2' + ',' + 'test3';

request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}
//REG MCORE
static testMethod void testcheckToolAccessMcore1(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord4 = [select id from Portal_Tools_Master__c where name = 'REG MCORE' limit 1];
request.requestUri ='/contacts/T134297/tools/'+ pRecord4.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();
jsonObj.contactToolAccess = [SELECT id, Portal_Tool_Master__c,Name, Portal_Honeywell_ID__c, Request_Status__c, CRM_Contact_ID__c FROM contact_Tool_Access__c limit 1];
jsonObj.McorePlatformOfMostInterest = 'test1' + ',' + 'test2' ;

request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}
//REG MCORE
static testMethod void testcheckToolAccessMcore3(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord4 = [select id from Portal_Tools_Master__c where name = 'REG MCORE' limit 1];
request.requestUri ='/contacts/T134297/tools/'+ pRecord4.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();
jsonObj.contactToolAccess = [SELECT id, Portal_Tool_Master__c,Name, Portal_Honeywell_ID__c, Request_Status__c, CRM_Contact_ID__c FROM contact_Tool_Access__c limit 1];
jsonObj.McorePlatformOfMostInterest = 'test1' ;

request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}
//REG MCORE
static testMethod void testcheckToolAccessMcoreDenied(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord4 = [select id from Portal_Tools_Master__c where name = 'REG MCORE' limit 1];
request.requestUri ='/contacts/E23456/tools/'+ pRecord4.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();
jsonObj.contactToolAccess = [SELECT id, MCORE_Purpose_of_MCORE_Access__c,MCORE_Account_Type__c,Manager_Name__c,Portal_Tool_Master__c,Name, Portal_Honeywell_ID__c, Request_Status__c, CRM_Contact_ID__c FROM contact_Tool_Access__c where name = 'REG MCORE' limit 1];
jsonObj.McorePlatformOfMostInterest = 'test1' + ',' + 'test2' + ',' + 'test3';

request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}

//REG Online Ordering
static testMethod void testcheckToolAccess4(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord5 = [select id from Portal_Tools_Master__c where name = 'REG Online Ordering' limit 1];
request.requestUri ='/contacts/T134297/tools/'+ pRecord5.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();
List<account> accId =[select id from account where name = 'Test Account1'];
jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test' LIMIT 1];
//contact con = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test1' LIMIT 1];
List<SAP_Contact_Sold_To__c> soldToList = new List<SAP_Contact_Sold_To__c>();
SAP_Contact_Sold_To__c sapConSoldTo1 = new SAP_Contact_Sold_To__c();
sapConSoldTo1.Name = 'Test sold to contact';
sapConSoldTo1.Contact__c = jsonObj.contact.Id;
sapConSoldTo1.Record_Data_Owner__c = jsonObj.contact.Id;
sapConSoldTo1.SAP_Account_Sold_To__c = 'text acc sold to';
sapConSoldTo1.SoldtoToolAccess__c = 'ordersReturns';
soldToList.add(sapConSoldTo1);
SAP_Contact_Sold_To__c sapConSoldTo2 = new SAP_Contact_Sold_To__c();
sapConSoldTo2.Name = 'Test sold to contact1';
sapConSoldTo2.Contact__c = jsonObj.contact.Id;
sapConSoldTo2.Record_Data_Owner__c = jsonObj.contact.Id;
sapConSoldTo2.SAP_Account_Sold_To__c = 'text acc sold to';
sapConSoldTo2.SoldtoToolAccess__c = 'ordersReturns';
soldToList.add(sapConSoldTo2);
insert soldToList;


List<REG_API_PortalContactTools.soldTosWrappper> soldToWrapperList = new List<REG_API_PortalContactTools.soldTosWrappper>();
for(SAP_Contact_Sold_To__c soldc :[SELECT Id,soldToToolAccess__c,Name,Contact__c,Record_Data_Owner__c FROM SAP_Contact_Sold_To__c limit 1])
{
REG_API_PortalContactTools.soldTosWrappper soldToWrapper = new REG_API_PortalContactTools.soldTosWrappper();
soldToWrapper.accountId = accId[0].Id;
soldToWrapper.accountName = soldc.Name;
soldToWrapper.soldToToolAccess = 'OrdersReturns';
soldToWrapper.soldToId=soldc.Id;
soldToWrapperList.add(soldToWrapper);
}      
jsonObj.SAPcontactSoldTos = soldToWrapperList;

request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}

//REG Online Ordering
static testMethod void testcheckToolAccessApproved(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord5 = [select id from Portal_Tools_Master__c where name = 'REG Online Ordering' limit 1];
request.requestUri ='/contacts/E23456/tools/'+ pRecord5.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();
List<account> accId =[select id from account where name = 'Test Account'];
jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test' LIMIT 1];
//contact con = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test1' LIMIT 1];
List<SAP_Contact_Sold_To__c> soldToList = new List<SAP_Contact_Sold_To__c>();
SAP_Contact_Sold_To__c sapConSoldTo1 = new SAP_Contact_Sold_To__c();
sapConSoldTo1.Name = 'Test sold to contact';
sapConSoldTo1.Contact__c = jsonObj.contact.Id;
sapConSoldTo1.Record_Data_Owner__c = jsonObj.contact.Id;
sapConSoldTo1.SAP_Account_Sold_To__c = 'text acc sold to';
soldToList.add(sapConSoldTo1);
SAP_Contact_Sold_To__c sapConSoldTo2 = new SAP_Contact_Sold_To__c();
sapConSoldTo2.Name = 'Test sold to contact1';
sapConSoldTo2.Contact__c = jsonObj.contact.Id;
sapConSoldTo2.Record_Data_Owner__c = jsonObj.contact.Id;
sapConSoldTo2.SAP_Account_Sold_To__c = 'text acc sold to';
soldToList.add(sapConSoldTo2);
insert soldToList;


List<REG_API_PortalContactTools.soldTosWrappper> soldToWrapperList = new List<REG_API_PortalContactTools.soldTosWrappper>();
for(SAP_Contact_Sold_To__c soldc :[SELECT Id,soldToToolAccess__c,Name,Contact__c,Record_Data_Owner__c FROM SAP_Contact_Sold_To__c limit 1])
{
REG_API_PortalContactTools.soldTosWrappper soldToWrapper = new REG_API_PortalContactTools.soldTosWrappper();
soldToWrapper.accountId = accId[0].Id;
soldToWrapper.accountName = soldc.Name;
soldToWrapper.soldToToolAccess = 'OrdersReturns';
soldToWrapper.soldToId=soldc.Id;
soldToWrapperList.add(soldToWrapper);
}      
jsonObj.SAPcontactSoldTos = soldToWrapperList;

request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}    
//=============================================================================


//======================================================
//REG Technical Publications
static testMethod void testcheckToolAccess7(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord8 = [select id from Portal_Tools_Master__c where name = 'REG Technical Publications' limit 1];
request.requestUri ='/contacts/T134297/tools/'+ pRecord8.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();

jsonObj.contact = [SELECT id, Name, firstname,Citizenship_Country__c,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c,Contact_Birth_Country__c,Birth_City__c FROM Contact where firstname='test'LIMIT 1];

// Contact_Address__c conAdd = new Contact_Address__c(Is_Primary_Address__c = true,Reporting_City_Name__c = 'Pune', Reporting_Street_Address_Line_1__c = 'Hinjewadi',Contact__c = jsonObj.contact.Id , Report_Country_Codes__c = 'IN');
Contact_Address__c conAdd = new Contact_Address__c(Is_Primary_Address__c = true,Reporting_City_Name__c = 'Pune', Reporting_Street_Address_Line_1__c = 'Hinjewadi',Contact__c = jsonObj.contact.Id , Report_Country_Codes__c = 'IN');

insert conadd;
request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}
//REG Technical Publications
static testMethod void testcheckToolAccessInternalDomain(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord8 = [select id from Portal_Tools_Master__c where name = 'REG Technical Publications' limit 1];
request.requestUri ='/contacts/T134290/tools/'+ pRecord8.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();

jsonObj.contact = [SELECT id, Name, firstname,Citizenship_Country__c,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c,Contact_Birth_Country__c,Birth_City__c FROM Contact where firstname='test5'LIMIT 1];

// Contact_Address__c conAdd = new Contact_Address__c(Is_Primary_Address__c = true,Reporting_City_Name__c = 'Pune', Reporting_Street_Address_Line_1__c = 'Hinjewadi',Contact__c = jsonObj.contact.Id , Report_Country_Codes__c = 'IN');
Contact_Address__c conAdd = new Contact_Address__c(Is_Primary_Address__c = true,Reporting_City_Name__c = 'Pune', Reporting_Street_Address_Line_1__c = 'Hinjewadi',Contact__c = jsonObj.contact.Id , Report_Country_Codes__c = 'IN');

insert conadd;
request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}    
//REG Technical Publications
static testMethod void testchecktoolAccessTechPub(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord8 = [select id from Portal_Tools_Master__c where name = 'REG Technical Publications' limit 1];
request.requestUri ='/contacts/E23456/tools/'+ pRecord8.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();
jsonObj.contact = [SELECT id, Name, firstname,Citizenship_Country__c,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c,Contact_Birth_Country__c,Birth_City__c FROM Contact where firstname='test1'LIMIT 1];

Contact_Address__c conAdd = new Contact_Address__c(Reporting_City_Name__c = 'Toronto', Reporting_Street_Address_Line_1__c = 'Hinjewadi',Contact__c = jsonObj.contact.Id , Report_Country_Codes__c = 'CA');
insert conadd;
request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}  
//REG Technical Publications
static testMethod void testchecktoolAccessTechPub1(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord8 = [select id from Portal_Tools_Master__c where name = 'REG Technical Publications' limit 1];
request.requestUri ='/contacts/E23457/tools/'+ pRecord8.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();
jsonObj.contact = [SELECT id, Name, firstname,Citizenship_Country__c,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c,Contact_Birth_Country__c,Birth_City__c FROM Contact where firstname='test2'LIMIT 1];

Contact_Address__c conAdd = new Contact_Address__c(Is_Primary_Address__c = true,Reporting_City_Name__c = 'Boston', Reporting_Street_Address_Line_1__c = 'Hinjewadi',Contact__c = jsonObj.contact.Id , Report_Country_Codes__c = 'US');
insert conadd;
request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}      

// ====================================  
//REG Aerospace (ASDS) 
static testMethod void testcheckToolAccess8(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'REG Aerospace (ASDS)' limit 1];
request.requestUri ='/contacts/T134298/tools/'+ pRecord9.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();

jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, Address_Line_1__c,City_Name__c,Country_Name__c,lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test3' LIMIT 1];
LIST<account> accid = [select id from account where name = 'test account'];
// string addressName = jsonObj.contact.Address_Line_1__c+' '+jsonObj.contact.City_Name__c+' '+ jsonObj.contact.Country_Name__c;
Account_Address__c accAdd = new Account_Address__c( Address_Type__c = 'Contact',Account_Name__c=accId[0].Id ,Report_Address_Line_1__c = 'wakad', Report_City_Name__c = 'Toronto',Report_Country_Name__c = 'Canada'); 
insert accAdd;
Contact_Address__c conAdd = new Contact_Address__c(Reporting_Country_Name__c = 'Canada',Reporting_Address_State_Code__c = 'BC',Is_Primary_Address__c = true,Reporting_City_Name__c = 'Toronto', Reporting_Street_Address_Line_1__c = 'Hinjewadi',Contact__c = jsonObj.contact.Id , Report_Country_Codes__c = 'CA',Reporting_Address_Postal_Code__c = '411057');
insert conAdd;
//  Account_Cross_Ref__c accRef = new Account_Cross_Ref__c(External_Country_Name__c = 'India',External_Main_Fax__c = '12345678',External_Main_Phone__c = '1234567890',Site_Name__c = 'BMS',external_account_id__c = '7894563-01',site_code__c = 'test',Account_Name__c = accid[0].id,External_City_Name__c = conAdd.Reporting_City_Name__c,External_Postal_Code__c = conAdd.Reporting_Address_Postal_Code__c,external_country_code__c = conAdd.Report_Country_Codes__c,external_state_code__c = conAdd.Reporting_Address_State_Code__c);
// insert accRef;
request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}

//REG Aerospace (ASDS) 
static testMethod void testcheckToolAccessASDS(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'REG Aerospace (ASDS)' limit 1];
request.requestUri ='/contacts/T134290/tools/'+ pRecord9.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();

jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, Address_Line_1__c,City_Name__c,Country_Name__c,lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test5' LIMIT 1];
LIST<account> accid = [select id from account where name = 'test account'];
// string addressName = jsonObj.contact.Address_Line_1__c+' '+jsonObj.contact.City_Name__c+' '+ jsonObj.contact.Country_Name__c;
// Account_Address__c accAdd = new Account_Address__c( Address_Type__c = 'Contact',Account_Name__c=accId[0].Id ,Report_Address_Line_1__c = 'wakad', Report_City_Name__c = 'Toronto',Report_Country_Name__c = 'Canada'); 
// insert accAdd;
Contact_Address__c conAdd = new Contact_Address__c(Reporting_Country_Name__c = 'Australia',Is_Primary_Address__c = true,Reporting_City_Name__c = 'Sydney', Reporting_Street_Address_Line_1__c = 'Hinjewadi',Contact__c = jsonObj.contact.Id , Report_Country_Codes__c = 'AU',Reporting_Address_Postal_Code__c = '411057');
insert conAdd;
//  Account_Cross_Ref__c accRef = new Account_Cross_Ref__c(External_Country_Name__c = 'India',External_Main_Fax__c = '12345678',External_Main_Phone__c = '1234567890',Site_Name__c = 'BMS',external_account_id__c = '7894563-01',site_code__c = 'test',Account_Name__c = accid[0].id,External_City_Name__c = conAdd.Reporting_City_Name__c,External_Postal_Code__c = conAdd.Reporting_Address_Postal_Code__c,external_country_code__c = conAdd.Report_Country_Codes__c,external_state_code__c = conAdd.Reporting_Address_State_Code__c);
// insert accRef;
request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}
//REG Aerospace (EGPWS)
static testMethod void testcheckToolAccess9(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'REG Aerospace (EGPWS)' limit 1];
request.requestUri ='/contacts/T134297/tools/'+ pRecord9.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();

jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test' LIMIT 1];

Contact_Address__c conAdd = new Contact_Address__c(Is_Primary_Address__c = false,Reporting_City_Name__c = 'Pune', Reporting_Street_Address_Line_1__c = 'Hinjewadi',Contact__c = jsonObj.contact.Id , Report_Country_Codes__c = 'IN');
insert conAdd;

request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}

//REG Aerospace (NavDB)
static testMethod void testcheckToolAccess10(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'REG Aerospace (NavDB)' limit 1];
request.requestUri ='/contacts/T134297/tools/'+ pRecord9.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();

jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact LIMIT 1];
request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}

//eFindings
static testMethod void testcheckToolAccess14(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'REG eFindings / Historical Findings' limit 1];
request.requestUri ='/contacts/T134297/tools/'+ pRecord9.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();
jsonObj.contactToolAccess = [SELECT id, Portal_Tool_Master__c,Name, Portal_Honeywell_ID__c, Request_Status__c, CRM_Contact_ID__c FROM contact_Tool_Access__c LIMIT 1];
jsonObj.contactAircraft = [SELECT Id,Name,CRM_Contact_ID__c,Record_Data_Owner__c,Aircraft_FMS__c FROM Contact_Aircraft__c LIMIT 1];

List<REG_API_PortalContactTools.soldTosWrappper> soldToWrapperList = new List<REG_API_PortalContactTools.soldTosWrappper>();
for(SAP_Contact_Sold_To__c soldc :[SELECT Id,soldToToolAccess__c,Name,Contact__c,Record_Data_Owner__c FROM SAP_Contact_Sold_To__c limit 1])
{
REG_API_PortalContactTools.soldTosWrappper soldToWrapper = new REG_API_PortalContactTools.soldTosWrappper();
soldToWrapper.accountId = soldc.Id;
soldToWrapper.accountName = soldc.Name;
soldToWrapper.soldToToolAccess = 'OrderReturns';
soldToWrapper.soldToId=soldc.Id;
soldToWrapperList.add(soldToWrapper);
}      
jsonObj.SAPcontactSoldTos = soldToWrapperList;
jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact LIMIT 1];
request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}

//REG Honeywell Training
static testMethod void testcheckToolAccess15(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'REG Honeywell Training' limit 1];
request.requestUri ='/contacts/T134297/tools/'+ pRecord9.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();
jsonObj.contactToolAccess = [SELECT id, Portal_Tool_Master__c,Name, Portal_Honeywell_ID__c, Request_Status__c, CRM_Contact_ID__c FROM contact_Tool_Access__c LIMIT 1];
jsonObj.contactAircraft = [SELECT Id,Name,CRM_Contact_ID__c,Record_Data_Owner__c,Aircraft_FMS__c FROM Contact_Aircraft__c LIMIT 1];

List<REG_API_PortalContactTools.soldTosWrappper> soldToWrapperList = new List<REG_API_PortalContactTools.soldTosWrappper>();
for(SAP_Contact_Sold_To__c soldc :[SELECT Id,soldToToolAccess__c,Name,Contact__c,Record_Data_Owner__c FROM SAP_Contact_Sold_To__c limit 1])
{
REG_API_PortalContactTools.soldTosWrappper soldToWrapper = new REG_API_PortalContactTools.soldTosWrappper();
soldToWrapper.accountId = soldc.Id;
soldToWrapper.accountName = soldc.Name;
soldToWrapper.soldToToolAccess = 'OrderReturns';
soldToWrapper.soldToId=soldc.Id;
soldToWrapperList.add(soldToWrapper);
}      
jsonObj.SAPcontactSoldTos = soldToWrapperList;
jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact LIMIT 1];
request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
Test.startTest();
REG_API_PortalContactTools.doPost();
Test.stopTest();
}
//=============================moved to other class
*/
    //Delete Contact
    static testMethod void testDeleteContact(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response; 
        request.headers.put('deletedByEmailId','myaerospace@honeywell.com.dev');  
        //Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'REG Honeywell Training' limit 1];
        request.requestUri ='/contacts/T134297';
        request.httpMethod = 'DELETE';
        system.assertEquals('DELETE',request.httpMethod);
        request.addHeader('Content-Type', 'application/json');   
                Test.startTest();
        REG_API_PortalContactTools jsonObj = new REG_API_PortalContactTools();
        contact c=[select id from contact where Honeywell_ID__c='T134297' limit 1];
        List<Contact> conList=new List<Contact>([SELECT Id,Primary_Email_Address__c,Portal_Temp_Primary_Email__c,Temp_Portal_Company_Name__c,(SELECT Id from Portal_Honeywell_ID__r WHERE Name ='T134297'),(select Id from Account_Aircraft__r),(SELECT Id from Contact_Tool_Access__r WHERE Portal_Honeywell_ID__c ='T134297'),(SELECT Id from SAP_Contact_Sold_To__r),(SELECT Id from Account_Contacts1__r),(SELECT Id from User_Aircraft_Associations__r),(SELECT Id from Restricted_Service_Programs__r) from Contact WHERE Id =:c.Id]);
        //jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact LIMIT 1];
        request.requestBody=Blob.valueOf(JSON.serialize(conList));

        REG_API_PortalContactTools.doDelete();
        Test.stopTest();
    }
    
    //Delete contact for inactive contact status
    static testMethod void testDeleteContactInActiveStatus(){
        RestRequest request = new RestRequest();  
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response; 
        request.headers.put('deletedByEmailId','myaerospace@honeywell.com.dev');  
        //Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'REG Honeywell Training' limit 1];
        request.requestUri ='/contacts/T134297';
        request.httpMethod = 'DELETE';
        system.assertEquals('DELETE',request.httpMethod);
        request.addHeader('Content-Type', 'application/json'); 
                Test.startTest();
        REG_API_PortalContactTools jsonObj = new REG_API_PortalContactTools();
        contact c=[select id,Contact_Status__c from contact where Honeywell_ID__c='T134297' limit 1];
        c.Contact_Status__c='Inactive';
            update c;
        List<Contact> conList=new List<Contact>([SELECT Id,Primary_Email_Address__c,Portal_Temp_Primary_Email__c,Temp_Portal_Company_Name__c,(SELECT Id from Portal_Honeywell_ID__r WHERE Name ='T134297'),(select Id from Account_Aircraft__r),(SELECT Id from Contact_Tool_Access__r WHERE Portal_Honeywell_ID__c ='T134297'),(SELECT Id from SAP_Contact_Sold_To__r),(SELECT Id from Account_Contacts1__r),(SELECT Id from User_Aircraft_Associations__r),(SELECT Id from Restricted_Service_Programs__r) from Contact WHERE Id =:c.Id]);
        //jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact LIMIT 1];
        request.requestBody=Blob.valueOf(JSON.serialize(conList));

        REG_API_PortalContactTools.doDelete();
        Test.stopTest();
    }
    
    // delete contact for wrong honId
    static testMethod void testDeleteContactNoHonId(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;   
        //Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'REG Honeywell Training' limit 1];
        request.requestUri ='/contacts';
        request.httpMethod = 'DELETE';
        system.assertEquals('DELETE',request.httpMethod);
        request.addHeader('Content-Type', 'application/json'); 
                Test.startTest();
        request.headers.put('deletedbyemailid','testuser@honeywell.com');
        REG_API_PortalContactTools jsonObj = new REG_API_PortalContactTools();
        contact c=[select id from contact where Honeywell_ID__c='T134297' limit 1];
        List<Contact> conList=new List<Contact>([SELECT Id,Primary_Email_Address__c,Portal_Temp_Primary_Email__c,Temp_Portal_Company_Name__c,(SELECT Id from Portal_Honeywell_ID__r WHERE Name ='T134297'),(select Id from Account_Aircraft__r),(SELECT Id from Contact_Tool_Access__r WHERE Portal_Honeywell_ID__c ='T134297'),(SELECT Id from SAP_Contact_Sold_To__r),(SELECT Id from Account_Contacts1__r),(SELECT Id from User_Aircraft_Associations__r),(SELECT Id from Restricted_Service_Programs__r) from Contact WHERE Id =:c.Id]);
        //jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact LIMIT 1];
        request.requestBody=Blob.valueOf(JSON.serialize(conList));

        REG_API_PortalContactTools.doDelete();
        Test.stopTest();
    }
    
    // delete contact for no honId
    static testMethod void testDeleteContact1(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;   
        //Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'REG Honeywell Training' limit 1];
        request.requestUri ='/contacts/T134298';
        request.httpMethod = 'DELETE';
        system.assertEquals('DELETE',request.httpMethod);
        request.addHeader('Content-Type', 'application/json'); 
                Test.startTest();
        REG_API_PortalContactTools jsonObj = new REG_API_PortalContactTools();
        contact c=[select id from contact where Honeywell_ID__c='T134298' limit 1];
        List<Contact> conList=new List<Contact>([SELECT Id,Primary_Email_Address__c,Portal_Temp_Primary_Email__c,Temp_Portal_Company_Name__c,(SELECT Id from Portal_Honeywell_ID__r WHERE Name ='T134298'),(select Id from Account_Aircraft__r),(SELECT Id from Contact_Tool_Access__r WHERE Portal_Honeywell_ID__c ='T134297'),(SELECT Id from SAP_Contact_Sold_To__r),(SELECT Id from Account_Contacts1__r),(SELECT Id from User_Aircraft_Associations__r),(SELECT Id from Restricted_Service_Programs__r) from Contact WHERE Id =:c.Id]);
        //jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact LIMIT 1];
        request.requestBody=Blob.valueOf(JSON.serialize(conList));

        REG_API_PortalContactTools.doDelete();
        Test.stopTest();
    }
    static testMethod void testRevalidate(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/T134298/revalidate';  //Request URL
        request.httpMethod = 'POST';//HTTP Request Type
        system.assertEquals('POST',request.httpMethod);
                test.startTest();
        //request.requestBody = blob.valueOf('');
        REG_API_PortalContactTools.revalidateWrapper jsonObj = new REG_API_PortalContactTools.revalidateWrapper();
        jsonObj.incrementCounter ='y';
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
        contact c=[select id from contact where Honeywell_ID__c='T134298' limit 1];
        list<Portal_Honeywell_ID__c> portDetails = [SELECT Id,Name,Email_Sent_Counter__c FROM Portal_Honeywell_ID__c  where Name = 'T134298' and Portal_Status__c = 'InActive' and Contact__c = :c.Id];

        REG_API_PortalContactTools.doPost();
        test.stopTest();
    }
    //=================================================================================================
    
    static testMethod void testRevalidate1(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        
        request.requestURI = '/contacts/T134297/revalidate';  //Request URL
        request.httpMethod = 'POST';//HTTP Request Type
        system.assertEquals('POST',request.httpMethod);
        //request.requestBody = blob.valueOf('');
                test.startTest();
        REG_API_PortalContactTools.revalidateWrapper jsonObj = new REG_API_PortalContactTools.revalidateWrapper();
        jsonObj.revalidate ='y';
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
        contact c=[select id from contact where Honeywell_ID__c='T134297'];
        list<Portal_Honeywell_ID__c> portDetails = [SELECT Id,Name,Email_Sent_Counter__c FROM Portal_Honeywell_ID__c where Name = 'T134297' and Contact__c = :c.Id];

        REG_API_PortalContactTools.doPost();
        test.stopTest();
    }
    
    
    // ====================================================================================
    //code for contact-match
    static testMethod void testContactMatch(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.headers.put('emailid','testuser@itc.com');
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/contact-match';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        system.assertEquals('GET',request.httpMethod);
                test.startTest();
        //request.requestBody = blob.valueOf('');
        REG_API_PortalContactTools jsonObj = new REG_API_PortalContactTools();
        contact con1=[select id from contact where Honeywell_ID__c='T134297'];
        Contact_Address__c cd1 = new Contact_Address__c(Reporting_Street_Address_Line_1__c='test',Report_Country_Codes__c='878',Reporting_City_Name__c='Active',Is_Primary_Address__c = true,Address_Status__c = 'Active',Contact__c=con1.id);
        insert cd1;

        REG_API_PortalContactTools.doGet();
        test.stopTest();
    }
    //code for contact-match for wrong email 
    static testMethod void testContactMatch1(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.headers.put('emailid','kDWGKJGBL@KJB.KJ');
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/contact-match';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        system.assertEquals('GET',request.httpMethod);
        //request.requestBody = blob.valueOf('');
        REG_API_PortalContactTools jsonObj = new REG_API_PortalContactTools();
        
        test.startTest();
        REG_API_PortalContactTools.doGet();
        test.stopTest();
    }
    
    //code for contact-match for no email 
    static testMethod void testContactMatch2(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.headers.put('emailid','');
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/contact-match';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        system.assertEquals('GET',request.httpMethod);
        //request.requestBody = blob.valueOf('');
        REG_API_PortalContactTools jsonObj = new REG_API_PortalContactTools();
        
        test.startTest();
        REG_API_PortalContactTools.doGet();
        test.stopTest();
    }
    
    //code for contact-match
    static testMethod void testContactMatch3(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.headers.put('emailid','testuser6@itc.com');
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/contact-match';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        system.assertEquals('GET',request.httpMethod);
                test.startTest();
        //request.requestBody = blob.valueOf('');
        REG_API_PortalContactTools jsonObj = new REG_API_PortalContactTools();
        list<account> accId = [select id from account where name='test_case_account1' limit 1];
        list<contact> con1=[select id,Contact_Is_Employee__c from contact where Honeywell_ID__c='T852369' and account.id=:accId[0].Id];
        con1[0].Contact_Is_Employee__c = true;
        update con1;
        Account_Address__c accAdd = new Account_Address__c(  Address_Status__c = 'Active',Address_Type__c = 'Contact',Report_Address_Line_2__c = 'abc',Report_Address_Line_3__c = 'xyz',Account_Name__c=accId[0].Id ,Report_Address_Line_1__c = 'wakad', Report_City_Name__c = 'Toronto',Report_Country_Name__c = 'Canada',Report_Country_Codes__c = 'CN',Is_Primary_Address__c = true ,Report_Postal_Code__c = '441108' ,Report_State_Code__c = '123654' ); 
    insert accAdd;

        REG_API_PortalContactTools.doGet();
        test.stopTest();
    }
    
    
    //code for contact Details
    static testMethod void testContactDetails(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/T134297';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        system.assertEquals('GET',request.httpMethod);
        //request.requestBody = blob.valueOf('');
        //REG_API_PortalContactTools jsonObj = new REG_API_PortalContactTools();
        test.startTest();
        REG_API_PortalContactTools.doGet();
        test.stopTest();
    }
    
    //code for contact Details for no hon Id
    static testMethod void testContactDetails1(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        system.assertEquals('GET',request.httpMethod);
        //request.requestBody = blob.valueOf('');
        //REG_API_PortalContactTools jsonObj = new REG_API_PortalContactTools();
        test.startTest();
        REG_API_PortalContactTools.doGet();
        test.stopTest();
    }
    
    //code for contact Details for wrong hon Id
    static testMethod void testContactDetails2(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/fhbdzbn';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        system.assertEquals('GET',request.httpMethod);
        //request.requestBody = blob.valueOf('');
        //REG_API_PortalContactTools jsonObj = new REG_API_PortalContactTools();
        test.startTest();
        REG_API_PortalContactTools.doGet();
        test.stopTest();
    }
    
    static testMethod void testgetActiveContactAddreess(){
        contact c1=[select id from contact where Honeywell_ID__c='T134297' limit 1];
        Test.starttest();
        REG_PortalContact_Service.getActiveContactAddreess(c1.Id);
        Test.stoptest();
    }
    
    static testMethod void testConvertPhoneNumbersToDisplayFormat(){
        String input = '(541) 754-3010';
        Test.starttest();
        String result = REG_PortalContact_Service.ConvertPhoneNumbersToDisplayFormat(input);
        system.assert(result.contains('+1 5417543010'));
        Test.stoptest();
    }
    
    /*   @isTest
public static void testChkToolStstus(){
Portal_Tools_Master__c pRecord = [select id from Portal_Tools_Master__c where name = 'Test3' limit 1];
Test.starttest();
REG_PortalToolAccess_Service.chkToolStatus('T134297',pRecord.Id);
Test.stoptest();
}*/
    /*  
//==============================just for now   - moved to other class
//REG Aerospace (ASDS) 
static testMethod void testcheckToolAccessASDS22(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'REG Aerospace (ASDS)' limit 1];
request.requestUri ='/contacts/T134290/tools/'+ pRecord9.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();        
jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, Address_Line_1__c,City_Name__c,Country_Name__c,lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test5' LIMIT 1];
LIST<account> accid = [select id from account where name = 'test account1'];
system.debug('accid' +accid);
Contact_Address__c conAdd = new Contact_Address__c(Reporting_Country_Name__c = 'Australia',Is_Primary_Address__c = true,Reporting_City_Name__c = 'Sydney', Reporting_Street_Address_Line_1__c = 'Hinjewadi',Contact__c = jsonObj.contact.Id , Report_Country_Codes__c = 'AU',Reporting_Address_Postal_Code__c = '411057');
insert conAdd;
request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
REG_API_PortalContactTools.doPost();
Test.stopTest();
}

static testMethod void testcheckToolAccessASDS1(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'REG Aerospace (ASDS)' limit 1];
request.requestUri ='/contacts/T134299/tools/'+ pRecord9.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();        
jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, Address_Line_1__c,City_Name__c,Country_Name__c,lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test' LIMIT 1];
//1.account id is not blank and remove ATR_Portal_Access_Template__c from account.
LIST<account> accid = [select id from account where name = 'Test Account3'];
system.debug('accid' +accid);
//2.set isSancConAdd  as false    
List<country__c> countryvalnew= [select id,name,isSanctioned__c from country__c where name='India' limit 1];
system.debug('countryvalnew-isSanctioned__c'+countryvalnew[0].isSanctioned__c);
Contact_Address__c conAdd = new Contact_Address__c(Reporting_Country_Name__c = 'India',Is_Primary_Address__c = true,Reporting_City_Name__c = 'Pune', Reporting_Street_Address_Line_1__c = 'Hinjewadi',Contact__c = jsonObj.contact.Id , Report_Country_Codes__c = 'IN',Reporting_Address_Postal_Code__c = '411057');
insert conAdd;
request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
REG_API_PortalContactTools.doPost();
Test.stopTest();
}

//REG Aerospace (NAVDB) 
static testMethod void testcheckToolAccessNAVDB(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'REG Aerospace (NavDB)' limit 1];
request.requestUri ='/contacts/T134290/tools/'+ pRecord9.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();        
jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, Address_Line_1__c,City_Name__c,Country_Name__c,lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test5' LIMIT 1];
LIST<account> accid = [select id from account where name = 'test account1'];
system.debug('accid' +accid);
Contact_Address__c conAdd = new Contact_Address__c(Reporting_Country_Name__c = 'Australia',Is_Primary_Address__c = true,Reporting_City_Name__c = 'Sydney', Reporting_Street_Address_Line_1__c = 'Hinjewadi',Contact__c = jsonObj.contact.Id , Report_Country_Codes__c = 'AU',Reporting_Address_Postal_Code__c = '411057');
insert conAdd;
request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
REG_API_PortalContactTools.doPost();
Test.stopTest();
}

static testMethod void testcheckToolAccessNAVDB1(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'REG Aerospace (NavDB)' limit 1];
request.requestUri ='/contacts/T134299/tools/'+ pRecord9.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();        
jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, Address_Line_1__c,City_Name__c,Country_Name__c,lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test' LIMIT 1];
//1.account id is not blank and remove ATR_Portal_Access_Template__c from account.
LIST<account> accid = [select id from account where name = 'Test Account3'];
system.debug('accid' +accid);
//2.set isSancConAdd  as false    
List<country__c> countryvalnew= [select id,name,isSanctioned__c from country__c where name='India' limit 1];
system.debug('countryvalnew-isSanctioned__c'+countryvalnew[0].isSanctioned__c);
Contact_Address__c conAdd = new Contact_Address__c(Reporting_Country_Name__c = countryvalnew[0].name, Is_Primary_Address__c = true,Reporting_City_Name__c = 'Pune', Reporting_Street_Address_Line_1__c = 'Hinjewadi',Contact__c = jsonObj.contact.Id , Report_Country_Codes__c = 'IN',Reporting_Address_Postal_Code__c = '411057');
insert conAdd;

request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
REG_API_PortalContactTools.doPost();
Test.stopTest();
}

//REG Aerospace (EGPWS)
static testMethod void testcheckToolAccessEGPWS(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'REG Aerospace (EGPWS)' limit 1];
request.requestUri ='/contacts/T134290/tools/'+ pRecord9.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();        
jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, Address_Line_1__c,City_Name__c,Country_Name__c,lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test5' LIMIT 1];
LIST<account> accid = [select id from account where name = 'test account1'];
system.debug('accid' +accid);
Contact_Address__c conAdd = new Contact_Address__c(Reporting_Country_Name__c = 'Australia',Is_Primary_Address__c = true,Reporting_City_Name__c = 'Sydney', Reporting_Street_Address_Line_1__c = 'Hinjewadi',Contact__c = jsonObj.contact.Id , Report_Country_Codes__c = 'AU',Reporting_Address_Postal_Code__c = '411057');
insert conAdd;
request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
REG_API_PortalContactTools.doPost();
Test.stopTest();
}

static testMethod void testcheckToolAccessEGPWS1(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'REG Aerospace (EGPWS)' limit 1];
request.requestUri ='/contacts/T134299/tools/'+ pRecord9.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();        
jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, Address_Line_1__c,City_Name__c,Country_Name__c,lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test' LIMIT 1];
//1.account id is not blank and remove ATR_Portal_Access_Template__c from account.
LIST<account> accid = [select id from account where name = 'Test Account3'];
system.debug('accid' +accid);
//2.set isSancConAdd  as false    
List<country__c> countryvalnew= [select id,name,isSanctioned__c from country__c where name='India' limit 1];
system.debug('countryvalnew-isSanctioned__c'+countryvalnew[0].isSanctioned__c);
Contact_Address__c conAdd = new Contact_Address__c(Reporting_Country_Name__c = countryvalnew[0].name, Is_Primary_Address__c = true,Reporting_City_Name__c = 'Pune', Reporting_Street_Address_Line_1__c = 'Hinjewadi',Contact__c = jsonObj.contact.Id , Report_Country_Codes__c = 'IN',Reporting_Address_Postal_Code__c = '411057');
insert conAdd;

request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
REG_API_PortalContactTools.doPost();
Test.stopTest();
}*/
    
    // =======================================================================================
    
    
    /*================just for now - moved to other class
//REG Aerospace (NavDb) 
static testMethod void testcheckToolAccessnavdb5(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'REG Aerospace (NavDB)' limit 1];
request.requestUri ='/contacts/T134298/tools/'+ pRecord9.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();

jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, Address_Line_1__c,City_Name__c,Country_Name__c,lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test3' LIMIT 1];
LIST<account> accid = [select id from account where name = 'test account'];
// string addressName = jsonObj.contact.Address_Line_1__c+' '+jsonObj.contact.City_Name__c+' '+ jsonObj.contact.Country_Name__c;
Account_Address__c accAdd = new Account_Address__c( Address_Type__c = 'Contact',Account_Name__c=accId[0].Id ,Report_Address_Line_1__c = 'wakad', Report_City_Name__c = 'Toronto',Report_Country_Name__c = 'Canada'); 
insert accAdd;
Contact_Address__c conAdd = new Contact_Address__c(Reporting_Country_Name__c = 'Canada',Reporting_Address_State_Code__c = 'BC',Is_Primary_Address__c = true,Reporting_City_Name__c = 'Toronto', Reporting_Street_Address_Line_1__c = 'Hinjewadi',Contact__c = jsonObj.contact.Id , Report_Country_Codes__c = 'CA',Reporting_Address_Postal_Code__c = '411057');
insert conAdd;
//  Account_Cross_Ref__c accRef = new Account_Cross_Ref__c(External_Country_Name__c = 'India',External_Main_Fax__c = '12345678',External_Main_Phone__c = '1234567890',Site_Name__c = 'BMS',external_account_id__c = '7894563-01',site_code__c = 'test',Account_Name__c = accid[0].id,External_City_Name__c = conAdd.Reporting_City_Name__c,External_Postal_Code__c = conAdd.Reporting_Address_Postal_Code__c,external_country_code__c = conAdd.Report_Country_Codes__c,external_state_code__c = conAdd.Reporting_Address_State_Code__c);
// insert accRef;
request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}
//REG Aerospace (NavDb) 
static testMethod void testcheckToolAccessnavdbApproved(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'REG Aerospace (NavDB)' limit 1];
request.requestUri ='/contacts/E23456/tools/'+ pRecord9.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();

jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, Address_Line_1__c,City_Name__c,Country_Name__c,lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test3' LIMIT 1];
LIST<account> accid = [select id from account where name = 'test account'];
// string addressName = jsonObj.contact.Address_Line_1__c+' '+jsonObj.contact.City_Name__c+' '+ jsonObj.contact.Country_Name__c;
Account_Address__c accAdd = new Account_Address__c( Address_Type__c = 'Contact',Account_Name__c=accId[0].Id ,Report_Address_Line_1__c = 'wakad', Report_City_Name__c = 'Toronto',Report_Country_Name__c = 'Canada'); 
insert accAdd;
Contact_Address__c conAdd = new Contact_Address__c(Reporting_Country_Name__c = 'Canada',Reporting_Address_State_Code__c = 'BC',Is_Primary_Address__c = true,Reporting_City_Name__c = 'Toronto', Reporting_Street_Address_Line_1__c = 'Hinjewadi',Contact__c = jsonObj.contact.Id , Report_Country_Codes__c = 'CA',Reporting_Address_Postal_Code__c = '411057');
insert conAdd;
//  Account_Cross_Ref__c accRef = new Account_Cross_Ref__c(External_Country_Name__c = 'India',External_Main_Fax__c = '12345678',External_Main_Phone__c = '1234567890',Site_Name__c = 'BMS',external_account_id__c = '7894563-01',site_code__c = 'test',Account_Name__c = accid[0].id,External_City_Name__c = conAdd.Reporting_City_Name__c,External_Postal_Code__c = conAdd.Reporting_Address_Postal_Code__c,external_country_code__c = conAdd.Report_Country_Codes__c,external_state_code__c = conAdd.Reporting_Address_State_Code__c);
// insert accRef;
request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}    

//REG Aerospace (EGPWS) 
static testMethod void testcheckToolAccessegpws6(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'REG Aerospace (EGPWS)' limit 1];
request.requestUri ='/contacts/T134298/tools/'+ pRecord9.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();

jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, Address_Line_1__c,City_Name__c,Country_Name__c,lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test3' LIMIT 1];
LIST<account> accid = [select id from account where name = 'test account'];
// string addressName = jsonObj.contact.Address_Line_1__c+' '+jsonObj.contact.City_Name__c+' '+ jsonObj.contact.Country_Name__c;
Account_Address__c accAdd = new Account_Address__c( Address_Type__c = 'Contact',Account_Name__c=accId[0].Id ,Report_Address_Line_1__c = 'wakad', Report_City_Name__c = 'Toronto',Report_Country_Name__c = 'Canada'); 
insert accAdd;
Contact_Address__c conAdd = new Contact_Address__c(Reporting_Country_Name__c = 'Canada',Reporting_Address_State_Code__c = 'BC',Is_Primary_Address__c = true,Reporting_City_Name__c = 'Toronto', Reporting_Street_Address_Line_1__c = 'Hinjewadi',Contact__c = jsonObj.contact.Id , Report_Country_Codes__c = 'CA',Reporting_Address_Postal_Code__c = '411057');
insert conAdd;
//  Account_Cross_Ref__c accRef = new Account_Cross_Ref__c(External_Country_Name__c = 'India',External_Main_Fax__c = '12345678',External_Main_Phone__c = '1234567890',Site_Name__c = 'BMS',external_account_id__c = '7894563-01',site_code__c = 'test',Account_Name__c = accid[0].id,External_City_Name__c = conAdd.Reporting_City_Name__c,External_Postal_Code__c = conAdd.Reporting_Address_Postal_Code__c,external_country_code__c = conAdd.Report_Country_Codes__c,external_state_code__c = conAdd.Reporting_Address_State_Code__c);
// insert accRef;
request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}

static testMethod void testcheckToolAccessgeneric1(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'REG Aerospace (EGPWS)' limit 1];
request.requestUri ='/contacts/T134297/tools/'+ pRecord9.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();

jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, Address_Line_1__c,City_Name__c,Country_Name__c,lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test' LIMIT 1];
LIST<account> accid = [select id from account where name = 'test account'];
// string addressName = jsonObj.contact.Address_Line_1__c+' '+jsonObj.contact.City_Name__c+' '+ jsonObj.contact.Country_Name__c;
Account_Address__c accAdd = new Account_Address__c( Address_Type__c = 'Contact',Account_Name__c=accId[0].Id ,Report_Address_Line_1__c = 'wakad', Report_City_Name__c = 'Toronto',Report_Country_Name__c = 'Canada'); 
insert accAdd;
Contact_Address__c conAdd = new Contact_Address__c(Reporting_Country_Name__c = 'Canada',Reporting_Address_State_Code__c = 'BC',Is_Primary_Address__c = true,Reporting_City_Name__c = 'Toronto', Reporting_Street_Address_Line_1__c = 'Hinjewadi',Contact__c = jsonObj.contact.Id , Report_Country_Codes__c = 'CA',Reporting_Address_Postal_Code__c = '411057');
insert conAdd;
//  Account_Cross_Ref__c accRef = new Account_Cross_Ref__c(External_Country_Name__c = 'India',External_Main_Fax__c = '12345678',External_Main_Phone__c = '1234567890',Site_Name__c = 'BMS',external_account_id__c = '7894563-01',site_code__c = 'test',Account_Name__c = accid[0].id,External_City_Name__c = conAdd.Reporting_City_Name__c,External_Postal_Code__c = conAdd.Reporting_Address_Postal_Code__c,external_country_code__c = conAdd.Report_Country_Codes__c,external_state_code__c = conAdd.Reporting_Address_State_Code__c);
// insert accRef;
request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}
*/
    static testMethod void testToolCreateemptysoldto(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;   
        Test.startTest();
        Portal_Tools_Master__c pRecord9 = [select id from Portal_Tools_Master__c where name = 'test' limit 1];
        request.requestUri ='/contacts/'+ pRecord9.Id;
        request.httpMethod = 'POST';
        system.assertEquals('POST', request.httpMethod);
        request.addHeader('Content-Type', 'application/json');
        REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();
        
        jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact LIMIT 1];
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
        
        REG_API_PortalContactTools.doPost();
        Test.stopTest();  
    }
    /* moved to other class  
static testMethod void testcheckToolAccessonlineorders(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord6 = [select id from Portal_Tools_Master__c where name = 'REG Order Status' limit 1];
request.requestUri ='/contacts/E23456/tools/'+ pRecord6.Id;
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.inputWrapper jsonObj = new REG_API_PortalContactTools.inputWrapper();
jsonObj.contactToolAccess = [SELECT id, Portal_Tool_Master__c,Name, Portal_Honeywell_ID__c, Request_Status__c, CRM_Contact_ID__c FROM contact_Tool_Access__c LIMIT 1];
//jsonObj.contactAircraft = [SELECT Id,Name,CRM_Contact_ID__c,Record_Data_Owner__c,Aircraft_FMS__c FROM Contact_Aircraft__c LIMIT 1];
List<account> accId = [Select id from account where name = 'Test Account1'];
List<REG_API_PortalContactTools.soldTosWrappper> soldToWrapperList = new List<REG_API_PortalContactTools.soldTosWrappper>();
for(SAP_Contact_Sold_To__c soldc :[SELECT Id,soldToToolAccess__c,Name,Contact__c,Record_Data_Owner__c FROM SAP_Contact_Sold_To__c limit 1])
{
REG_API_PortalContactTools.soldTosWrappper soldToWrapper = new REG_API_PortalContactTools.soldTosWrappper();
soldToWrapper.accountId = accId[0].id;
soldToWrapper.accountName = soldc.Name;
soldToWrapper.soldToToolAccess = 'OrdersReturns';
soldToWrapper.soldToId=soldc.Id;
soldToWrapperList.add(soldToWrapper);
}      
jsonObj.SAPcontactSoldTos = soldToWrapperList;

jsonObj.contact = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact LIMIT 1];

request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
REG_API_PortalContactTools.doPost();
Test.stopTest();
}


static testMethod void testupdateToolAccess(){
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;   
Test.startTest();
Portal_Tools_Master__c pRecord5 = [select id from Portal_Tools_Master__c where name = 'REG Warranty and Programs' limit 1];
request.requestUri ='/contacts/T134297/tools/'+ pRecord5.Id +'/update-status';
request.httpMethod = 'POST';
request.addHeader('Content-Type', 'application/json');
REG_API_PortalContactTools.toolAccessClass jsonObj = new REG_API_PortalContactTools.toolAccessClass();
List<account> accId =[select id from account where name = 'Test Account'];
//jsonObj.contactId ='003m0000018F57a';
List<contact> conId = [SELECT id FROM Contact LIMIT 1];
jsonObj.contactId =conId[0].id;
//contact con = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test' LIMIT 1];
jsonObj.toolStatus='Approved';

request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));

REG_API_PortalContactTools.doPost();
Test.stopTest();
}*/
    
    
    static testMethod void testGetContactSoldTo(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/kjbkhbk/soldto';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        system.assertEquals('GET', request.httpMethod);
        //request.requestBody = blob.valueOf('');
        test.startTest();
        REG_API_PortalContactTools.doGet();
        test.stopTest();
    }
    
}