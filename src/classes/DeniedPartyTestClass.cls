@isTest
private class DeniedPartyTestClass {

    static testMethod void TestSchedulableweekly() {
    
    test.startTest();       
    DeniedPartyRequestSchedulable weeklybatch = new DeniedPartyRequestSchedulable();       
    String schedule = '0 0 23 * * ?';       
    system.schedule('Test weekly', schedule, weeklybatch );  
    DeniedPartyRequestSchedulable.call();
      
       test.stopTest();
    
    }
    
    static testMethod void TestSchedulabledaily() {
    
    test.startTest();       
    DeniedPartyRequestSchedulable_daily dailybatch = new DeniedPartyRequestSchedulable_daily();       
    String schedule = '0 0 23 * * ?';       
    system.schedule('Test dailybatch', schedule, dailybatch );  
    DeniedPartyRequestSchedulable_daily.call();
      
       test.stopTest();
    
    }
    static testMethod void Testbatchweeklydaily() {    
    
      
    CreateAccountAddressBatch weeklyb = new CreateAccountAddressBatch();
    CreateAccountAddressBatch_daily dailyb = new CreateAccountAddressBatch_daily();
   
    test.startTest();
    ID batchprocessid = Database.executeBatch(weeklyb,200);
    ID batchprocessid1 = Database.executeBatch(dailyb ,200);
    
     //Account acc= new Account(name='Test Task Account');
     
     //insert acc;
     
      account newAcct = new account();
        newAcct.name = 'test account code coverage';
        newAcct.type='Distributor';
        newAcct.Strategic_Business_Unit__c='ATR';
        insert newAcct;
     
    //where (not (Report_Account_name__c like '%VARIOUS%')) and (not (Formula_Strategic_Business_Unit__c like 'Intercompany')) and (not (Denied_Party_Status__c like 'Whitelist')) and AccountStatus__c!='Inactive'
    
    List<account_address__c> sobj=new List<account_address__c>();
    
    account_address__c aa = new account_address__c();
    aa.Account_Name__c = newAcct.id;
    aa.Address_Type__c = 'Other';
    aa.Report_Address_Line_1__c = 'Test address line 1';
    aa.Report_City_Name__c = 'Test City';
    aa.Report_Country_Name__c = 'Afghanistan';
    insert aa;
    sobj.add(aa);
    
    weeklyb.execute(null,sobj);
    dailyb.execute(null,sobj);
    test.stopTest();
    
    }
     static testMethod void testDeiniedPartyResponse() {
     
     account Acct = new account();
        Acct.name = 'test account code coverage';
        Acct.type='Distributor';
        Acct.Strategic_Business_Unit__c='ATR';
        insert Acct;
     
    //where (not (Report_Account_name__c like '%VARIOUS%')) and (not (Formula_Strategic_Business_Unit__c like 'Intercompany')) and (not (Denied_Party_Status__c like 'Whitelist')) and AccountStatus__c!='Inactive'
    
    List<account_address__c> sobjct=new List<account_address__c>();
    
    account_address__c add = new account_address__c();
    add.Account_Name__c = Acct.id;
    add.Address_Type__c = 'Other';
    add.Report_Address_Line_1__c = 'Test address line 1 test';
    add.Report_City_Name__c = 'Test City 1';
    add.Report_Country_Name__c = 'India';
    insert add;
    
    
    List<SPL_Ref_ID__c> splid = new List<SPL_Ref_ID__c>();
    
    SPL_Ref_ID__c rid = new SPL_Ref_ID__c();
    
    rid.Account_Address__c = add.Id;
    rid.Name = 'Test name';
    insert rid;
     
    DeiniedPartyResponse.ADDRNUMBER_cls ADDR_o= new DeiniedPartyResponse.ADDRNUMBER_cls();
    DeiniedPartyResponse.SPL_ENTITIY_cls ent_o= new DeiniedPartyResponse.SPL_ENTITIY_cls();
    DeiniedPartyResponse.SPL_NAME_cls nam_o= new DeiniedPartyResponse.SPL_NAME_cls();
    DeiniedPartyResponse.SPL_ADDRESS_cls adr_o= new DeiniedPartyResponse.SPL_ADDRESS_cls();
   
   DeiniedPartyResponse.SPL_ENTITIY_cls[] Aent_o= new DeiniedPartyResponse.SPL_ENTITIY_cls[]{};
    DeiniedPartyResponse.SPL_NAME_cls[] Anam_o= new DeiniedPartyResponse.SPL_NAME_cls[]{};
    DeiniedPartyResponse.SPL_ADDRESS_cls[] Aadr_o= new DeiniedPartyResponse.SPL_ADDRESS_cls[]{};
   
   account_address__c add1=[select name from account_address__c where id =:add.id];
   
    ADDR_o.ADDRESS_ID=add1.name;
    ADDR_o.BPTYP='x';
    ADDR_o.BPVSY='y';
    ADDR_o.ADDRESS_BLOCKED='Y';
    ADDR_o.USER_ACTION='x';
    ADDR_o.RELEASE_REASON_SCHEMA='Z';
    
    
    ent_o.LGREG='x';
    ent_o.SPL_LIST_TYPE='y';
    ent_o.SPL_PROVIDER_ID='z';
    ent_o.SPL_DATA_REF_ID='rrtrtrx';
    ent_o.SPL_ENTRY_DATE='12213123';
    ent_o.SPL_TZONE_ENTRY='w';
    ent_o.SPL_VALID_FROM='w';
    ent_o.SPL_FILE_ID='x';
    ent_o.SPL_COMMENT1='x';
    ent_o.SPL_COMMENT2='x';
    ent_o.SPL_COMMENT3='x';
    
    nam_o.LAUNR='765';
    nam_o.SPL_NAME1='o';
    nam_o.SPL_ID_NUMBER='8';    
    
    adr_o.LAUNR='987';
    adr_o.SPL_STREET1='';
    adr_o.SPL_CITY='';
    adr_o.SPL_COUNTRY='';

    anam_o.Add(nam_o);
    ent_o.SPL_NAME=anam_o;
    aadr_o.add(adr_o);
    ent_o.SPL_ADDRESS=aadr_o;
    
    aent_o.add(ent_o);
    ADDR_o.SPL_ENTITIY=aent_o;
    
    DeiniedPartyResponse.ADDRNUMBER_cls[] ADDRNUMBER = new DeiniedPartyResponse.ADDRNUMBER_cls[]{};
    ADDRNUMBER.add(ADDR_o);
    DeiniedPartyResponse.SPL_OFFLINE_SCREENING_RESULT(ADDRNUMBER);
    
    ADDR_o.ADDRESS_BLOCKED='N';
      DeiniedPartyResponse.ADDRNUMBER_cls[] ADDRNUMBER1 = new DeiniedPartyResponse.ADDRNUMBER_cls[]{};
    ADDRNUMBER1.add(ADDR_o);
    DeiniedPartyResponse.SPL_OFFLINE_SCREENING_RESULT(ADDRNUMBER1);

     } 
    
 }