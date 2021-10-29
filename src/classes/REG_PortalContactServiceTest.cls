@IsTest
private class REG_PortalContactServiceTest {
    
    @TestSetup
    Static void testData(){
        contact con = new contact(lastName = 'testing',honeywell_ID__c = 'H23456');
        insert con;
        Portal_Honeywell_ID__c hon_ID = new Portal_Honeywell_ID__c(name = 'H23456',Contact__c= con.ID);
        insert hon_ID;     
        Country__c countryval = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account' , SAP_account_sold_to__c = 'test');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
        insert honeywellContact;
        contact honeywellContact1 = new contact(firstname='test1',Contact_Status__c='Active',lastname='user1',Email='testuser1@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23456');
        insert honeywellContact1;
        contact honeywellContact2 = new contact(firstname='test12',Contact_Status__c='Active',lastname='user12',Email='testuser1@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134299');
        insert honeywellContact2;
        SAP_Contact_Sold_To__c contactSoldTo = new SAP_Contact_Sold_To__c(SAP_Account_Sold_To__c = 'testSAPSoldTo' , Contact__c = honeywellContact.id);
        insert contactSoldTo;
        Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id,primary_honeywell_id__c= true);
        insert phi;
        Portal_Honeywell_Id__c   phi1 = new Portal_Honeywell_Id__c(name='T134299',Email_Sent_Counter__c = 0,Contact__c=honeywellContact2.id,primary_honeywell_id__c= true,Portal_Status__c = 'Active');
        insert phi1;
        Portal_Tools_Master__c ptM = new Portal_Tools_Master__c(name = 'Test', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
        insert ptM;
        Portal_Tools_Master__c ptM1 = new Portal_Tools_Master__c(name = 'Test1', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
        insert ptM1;
        Portal_Tools_Master__c ptM2 = new Portal_Tools_Master__c(name = 'Test2', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
        insert ptM2;
        Portal_Tools_Master__c ptM3 = new Portal_Tools_Master__c(name = 'Test3', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
        insert ptM3;
        Account_Tools__c acT = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM.Id , Account_Name__c = honeywellAccount.Id );
        insert acT;
        Account_Tools__c acT1 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM1.Id , Account_Name__c = honeywellAccount.Id );
        insert acT1;
        Account_Tools__c acT2 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM2.Id , Account_Name__c = honeywellAccount.Id );
        insert acT2;
        Contact_Tool_Access__c caT = new Contact_Tool_Access__c(Portal_Tool_Master__c= ptM.Id, name = 'Test', Portal_Honeywell_ID__c = 'T134297', Request_Status__c = 'Approved',CRM_Contact_ID__c = honeywellContact.Id );
        insert caT;
        Contact_Tool_Access__c caT1 = new Contact_Tool_Access__c(Portal_Tool_Master__c= ptM1.Id, name = 'Test1', Portal_Honeywell_ID__c = 'T134297', Request_Status__c = 'Pending',CRM_Contact_ID__c = honeywellContact.Id );
        insert caT1;
        Account_Cross_Ref__c accCrossRef = new Account_Cross_Ref__c(Account_Name__c =  honeywellAccount.Id , external_account_name__c = 'a' , Name = 'Testing' , sbl_account_row_id__c = 'qwerty' , Site_Code__c = 'asdfg' , External_Account_ID__c = 'shsslkhl' , xref_type__c = 'SAP_SOLD_TO');
        insert accCrossRef;   
    }
    //code coverage for getContact method
    static testMethod void testGetContact(){
        REG_PortalContact_Service.getContact('H23456');
        REG_PortalContact_Service.getContactDetail('E23456');
        REG_PortalContact_Service.getContactByEmail('testuser@itc.com');
        REG_PortalContact_Service.GetAccountId('H23456');
        REG_PortalContact_Service.getContactSoldTo('T134297');
    }
}