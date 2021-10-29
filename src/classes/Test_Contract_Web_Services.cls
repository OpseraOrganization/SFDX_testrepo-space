@isTest
private class Test_Contract_Web_Services {


    private static testMethod void testContractServices() {
      
    Country__c countryval = new Country__c(name='INDIA',SFDC_Country_Name__c='INDIA');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',lastname='user1',accountid=honeywellAccount.id,Honeywell_ID__c='T134297',contact_status__c='Active');
        insert honeywellContact;
        List<Platform__c> pltfrm = new List<Platform__c>();
        Platform__c pf1 = new Platform__c(name='testPlatform1',Model__c='Tesla',Platform_Type__c='Airplane',Make__c='TS12435',Managing_SBU__c='BGA');
       	pltfrm.add(pf1);
        
        Test.startTest(); 
        Platform__c pf2 = new Platform__c(name='testPlatform2',Model__c='Teslas',Platform_Type__c='Airplane',Make__c='TS3245',Managing_SBU__c='BGA');
        
        pltfrm.add(pf2);
        insert pltfrm;
         List<Fleet_Asset_Detail__c> aircraft = new List<Fleet_Asset_Detail__c>();
        Fleet_Asset_Detail__c aircraftinfo1 =  new Fleet_Asset_Detail__c(name='testaircraftValue',Serial_Number__c='te2432423',Platform_Name__c=pf1.id);
        aircraft.add(aircraftinfo1);
        Fleet_Asset_Detail__c aircraftinfo2 =  new Fleet_Asset_Detail__c(name='testaircraftValue2',Serial_Number__c='te243890',Platform_Name__c=pf2.id);
        aircraft.add(aircraftinfo2);
        insert aircraft;
        
        contract newcontract = new contract(accountid=honeywellAccount.id,startdate=date.valueOf('2017-02-22'),enddate=date.valueOf('2017-03-21'),status='Draft',Type__c='HAPP',Aircraft__c=aircraftinfo1.id,Business_Focal_Email__c='rsmdanotificationtes@honeywell.com');
        insert newcontract;
        
        Contract cco = [Select id,SAP_Contract_Number__c,ContractNumber,status from contract where id =: newcontract.id];
        cco.SAP_Contract_Number__c = cco.ContractNumber;
        cco.status = 'Active';
        update cco; 
        RecordType recVal = [select id from RecordType where Name ='HAPP MPP Contracts' AND SObjectType = 'case'];
        
        

        contract newcontract1 = new contract(accountid=honeywellAccount.id,startdate=date.valueOf('2017-02-22'),enddate=date.valueOf('2017-03-21'),status='Draft',Aircraft__c=aircraftinfo2.id);       
        insert newcontract1;           
		Test.stopTest(); 
       
        Contract cco1 = [Select id,SAP_Contract_Number__c,ContractNumber,status from contract where id =: newcontract1.id];
        cco1.SAP_Contract_Number__c = cco1.ContractNumber;
        cco1.status = 'Active';
        update cco1;
        case renew1 = new case(status='Open',Contract_Number__c=cco.ContractNumber,RecordTypeID=recVal.id,Contact = honeywellContact, type ='HAPP Renewal',Sub_Status__c='1st Follow-up');
        insert renew1;
        Entitlement__c en = new Entitlement__c(Fleet_Asset_Aircraft__c=aircraftinfo2.id,Contract_Number__c = cco1.id);
        insert en;
 		
        // for fetching the aircraft header information 
        String JsonMsg5='[{ "contract_Number":"'+cco.ContractNumber+'","informtationType":"aircraft"},{"contract_Number":"'+cco1.ContractNumber+'","informtationType":"aircraft"}]';
            
        RestRequest req5 = new RestRequest(); 
        RestResponse res5 = new RestResponse();
    
        req5.requestURI = '/services/apexrest/AerospaceContractServices';  //Request URL
        req5.httpMethod = 'POST';//HTTP Request Type
        req5.requestBody = Blob.valueof(JsonMsg5);
        RestContext.request = req5;
        RestContext.response= res5;
        ContractWebServiceController.queryAircraftInformation();
       
     
    }
    private static testMethod void testContractServices1() {
     
    	Country__c countryval = new Country__c(name='INDIA',SFDC_Country_Name__c='INDIA');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',lastname='user1',accountid=honeywellAccount.id,Honeywell_ID__c='T134297',contact_status__c='Active');
        insert honeywellContact;
        List<Platform__c> pltfrm = new List<Platform__c>();
        Platform__c pf1 = new Platform__c(name='testPlatform1',Model__c='Tesla',Platform_Type__c='Airplane',Make__c='TS12435',Managing_SBU__c='BGA');
       	pltfrm.add(pf1);
        
        Test.startTest(); 
        Platform__c pf2 = new Platform__c(name='testPlatform2',Model__c='Teslas',Platform_Type__c='Airplane',Make__c='TS3245',Managing_SBU__c='BGA');
        
        pltfrm.add(pf2);
        insert pltfrm;
         List<Fleet_Asset_Detail__c> aircraft = new List<Fleet_Asset_Detail__c>();
        Fleet_Asset_Detail__c aircraftinfo1 =  new Fleet_Asset_Detail__c(name='testaircraftValue',Serial_Number__c='te2432423',Platform_Name__c=pf1.id);
        aircraft.add(aircraftinfo1);
        Fleet_Asset_Detail__c aircraftinfo2 =  new Fleet_Asset_Detail__c(name='testaircraftValue2',Serial_Number__c='te243890',Platform_Name__c=pf2.id);
        aircraft.add(aircraftinfo2);
        insert aircraft;
        
        contract newcontract = new contract(accountid=honeywellAccount.id,startdate=date.valueOf('2017-02-22'),enddate=date.valueOf('2017-03-21'),status='Draft',Type__c='HAPP',Aircraft__c=aircraftinfo1.id,Business_Focal_Email__c='rsmdanotificationtes@honeywell.com');
        insert newcontract;
        
        Contract cco = [Select id,SAP_Contract_Number__c,ContractNumber,status from contract where id =: newcontract.id];
        cco.SAP_Contract_Number__c = cco.ContractNumber;
        cco.status = 'Active';
        update cco; 
        RecordType recVal = [select id from RecordType where Name ='HAPP MPP Contracts' AND SObjectType = 'case'];
        
        

        contract newcontract1 = new contract(accountid=honeywellAccount.id,startdate=date.valueOf('2017-02-22'),enddate=date.valueOf('2017-03-21'),status='Draft',Aircraft__c=aircraftinfo2.id);       
        insert newcontract1;           
		Test.stopTest(); 
       
        Contract cco1 = [Select id,SAP_Contract_Number__c,ContractNumber,status from contract where id =: newcontract1.id];
        cco1.SAP_Contract_Number__c = cco1.ContractNumber;
        cco1.status = 'Active';
        update cco1;
        case renew1 = new case(status='Open',Contract_Number__c=cco.ContractNumber,RecordTypeID=recVal.id,Contact = honeywellContact, type ='HAPP Renewal',Sub_Status__c='1st Follow-up');
        insert renew1;
        Entitlement__c en = new Entitlement__c(Fleet_Asset_Aircraft__c=aircraftinfo2.id,Contract_Number__c = cco1.id);
        insert en;
      
        // for fetching the aircraft header information 
        
        String JsonMsg2='[{ "contract_Number":"'+cco.ContractNumber+'","informtationType":"count"},{"contract_Number":"'+cco1.ContractNumber+'","informtationType":"count"}]';
                        
        RestRequest req2 = new RestRequest(); 
        RestResponse res2 = new RestResponse();
    
        req2.requestURI = '/services/apexrest/AerospaceContractServices';  //Request URL
        req2.httpMethod = 'POST';//HTTP Request Type
        req2.requestBody = Blob.valueof(JsonMsg2);
        RestContext.request = req2;
        RestContext.response= res2;
        ContractWebServiceController.queryAircraftInformation();
        
        
     
    }
    private static testMethod void testContractServices2() {
       
    Country__c countryval = new Country__c(name='INDIA',SFDC_Country_Name__c='INDIA');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',lastname='user1',accountid=honeywellAccount.id,Honeywell_ID__c='T134297',contact_status__c='Active');
        insert honeywellContact;
        List<Platform__c> pltfrm = new List<Platform__c>();
        Platform__c pf1 = new Platform__c(name='testPlatform1',Model__c='Tesla',Platform_Type__c='Airplane',Make__c='TS12435',Managing_SBU__c='BGA');
       	pltfrm.add(pf1);
        
        Test.startTest(); 
        Platform__c pf2 = new Platform__c(name='testPlatform2',Model__c='Teslas',Platform_Type__c='Airplane',Make__c='TS3245',Managing_SBU__c='BGA');
        
        pltfrm.add(pf2);
        insert pltfrm;
         List<Fleet_Asset_Detail__c> aircraft = new List<Fleet_Asset_Detail__c>();
        Fleet_Asset_Detail__c aircraftinfo1 =  new Fleet_Asset_Detail__c(name='testaircraftValue',Serial_Number__c='te2432423',Platform_Name__c=pf1.id);
        aircraft.add(aircraftinfo1);
        Fleet_Asset_Detail__c aircraftinfo2 =  new Fleet_Asset_Detail__c(name='testaircraftValue2',Serial_Number__c='te243890',Platform_Name__c=pf2.id);
        aircraft.add(aircraftinfo2);
        insert aircraft;
        
        contract newcontract = new contract(accountid=honeywellAccount.id,startdate=date.valueOf('2017-02-22'),enddate=date.valueOf('2017-03-21'),status='Draft',Type__c='HAPP',Aircraft__c=aircraftinfo1.id,Business_Focal_Email__c='rsmdanotificationtes@honeywell.com');
        insert newcontract;
        
        Contract cco = [Select id,SAP_Contract_Number__c,ContractNumber,status from contract where id =: newcontract.id];
        cco.SAP_Contract_Number__c = cco.ContractNumber;
        cco.status = 'Active';
        update cco; 
        RecordType recVal = [select id from RecordType where Name ='HAPP MPP Contracts' AND SObjectType = 'case'];
        
        

        contract newcontract1 = new contract(accountid=honeywellAccount.id,startdate=date.valueOf('2017-02-22'),enddate=date.valueOf('2017-03-21'),status='Draft',Aircraft__c=aircraftinfo2.id);       
        insert newcontract1;           
		Test.stopTest(); 
       
        Contract cco1 = [Select id,SAP_Contract_Number__c,ContractNumber,status from contract where id =: newcontract1.id];
        cco1.SAP_Contract_Number__c = cco1.ContractNumber;
        cco1.status = 'Active';
        update cco1;
        case renew1 = new case(status='Open',Contract_Number__c=cco.ContractNumber,RecordTypeID=recVal.id,Contact = honeywellContact, type ='HAPP Renewal',Sub_Status__c='1st Follow-up');
        insert renew1;
        Entitlement__c en = new Entitlement__c(Fleet_Asset_Aircraft__c=aircraftinfo2.id,Contract_Number__c = cco1.id);
        insert en;
        
        String JsonMsg6='[{ "contract_Number":"'+cco.ContractNumber+'","informtationType":"contractRenewal"},{"contract_Number":"'+cco1.ContractNumber+'","informtationType":"contractRenewal"}]';
                        
        RestRequest req6 = new RestRequest(); 
        RestResponse res6 = new RestResponse();
    
        req6.requestURI = '/services/apexrest/AerospaceContractServices';  //Request URL
        req6.httpMethod = 'POST';//HTTP Request Type
        req6.requestBody = Blob.valueof(JsonMsg6);
        RestContext.request = req6;
        RestContext.response= res6;
        ContractWebServiceController.queryAircraftInformation();
      
    }
    private static testMethod void testContractServices3() {
    
        Country__c countryval = new Country__c(name='INDIA',SFDC_Country_Name__c='INDIA');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
         Test.startTest(); 
        Platform__c pf1 = new Platform__c(name='testPlatform1',Model__c='Tesla',Platform_Type__c='Airplane',Make__c='TS12435',Managing_SBU__c='BGA');
        insert pf1;
        Platform__c pf2 = new Platform__c(name='testPlatform2',Model__c='Teslas',Platform_Type__c='Airplane',Make__c='TS3245',Managing_SBU__c='BGA');
        insert pf2;
        Fleet_Asset_Detail__c aircraftinfo1 =  new Fleet_Asset_Detail__c(name='testaircraftValue',Serial_Number__c='te2432423',Platform_Name__c=pf1.id);
        insert aircraftinfo1;
        Fleet_Asset_Detail__c aircraftinfo2 =  new Fleet_Asset_Detail__c(name='testaircraftValue2',Serial_Number__c='te243890',Platform_Name__c=pf2.id);
        insert aircraftinfo2;
        contract newcontract1 = new contract(accountid=honeywellAccount.id,startdate=date.valueOf('2017-02-22'),enddate=date.valueOf('2017-03-21'),status='Draft',Aircraft__c=aircraftinfo2.id);       
        insert newcontract1;           

        Contract cco1 = [Select id,SAP_Contract_Number__c,ContractNumber,status from contract where id =: newcontract1.id];
        cco1.SAP_Contract_Number__c = cco1.ContractNumber;
        cco1.status = 'Active';
        update cco1;
        Entitlement__c en = new Entitlement__c(Fleet_Asset_Aircraft__c=aircraftinfo2.id,Entitlement_Type__c='Aircraft',Contract_Number__c = cco1.id);
        insert en;
        cco1.SAP_Contract_Number__c = en.Entitlement_Contract_Name__c;
        cco1.status = 'Active';
        update cco1;
         Test.stopTest();
        // for fetching the contract header information
       
        String JsonMsg3='[{ "aircraftMake":"TS3245","aircraftModel":"Teslas","aircraftSerialNumber":"te243890"}]';
                        
        RestRequest req3 = new RestRequest(); 
        RestResponse res3 = new RestResponse();
    
        req3.requestURI = '/services/apexrest/AerospaceContractServices';  //Request URL
        req3.httpMethod = 'POST';//HTTP Request Type
        req3.requestBody = Blob.valueof(JsonMsg3);
        RestContext.request = req3;
        RestContext.response= res3;
        ContractWebServiceController.queryAircraftInformation();
        
       
    }
    private static testMethod void testContractServices4() {
      
        Country__c countryval = new Country__c(name='INDIA',SFDC_Country_Name__c='INDIA');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
          Test.startTest(); 
        Platform__c pf1 = new Platform__c(name='testPlatform1',Model__c='Tesla',Platform_Type__c='Airplane',Make__c='TS12435',Managing_SBU__c='BGA');
        insert pf1;
        Platform__c pf2 = new Platform__c(name='testPlatform2',Model__c='Teslas',Platform_Type__c='Airplane',Make__c='TS3245',Managing_SBU__c='BGA');
        insert pf2;
        Fleet_Asset_Detail__c aircraftinfo1 =  new Fleet_Asset_Detail__c(name='testaircraftValue',Serial_Number__c='te2432423',Platform_Name__c=pf1.id);
        insert aircraftinfo1;
        Fleet_Asset_Detail__c aircraftinfo2 =  new Fleet_Asset_Detail__c(name='testaircraftValue2',Serial_Number__c='te243890',Platform_Name__c=pf2.id);
        insert aircraftinfo2;
        contract newcontract1 = new contract(accountid=honeywellAccount.id,startdate=date.valueOf('2017-02-22'),enddate=date.valueOf('2017-03-21'),status='Draft',Aircraft__c=aircraftinfo2.id);       
        insert newcontract1;           

        Contract cco1 = [Select id,SAP_Contract_Number__c,ContractNumber,status from contract where id =: newcontract1.id];
        cco1.SAP_Contract_Number__c = cco1.ContractNumber;
        cco1.status = 'Active';
        update cco1;
        Entitlement__c en = new Entitlement__c(Fleet_Asset_Aircraft__c=aircraftinfo2.id,Entitlement_Type__c='Aircraft',Contract_Number__c = cco1.id);
        insert en;
        cco1.SAP_Contract_Number__c = en.Entitlement_Contract_Name__c;
        cco1.status = 'Active';
        update cco1;
      Test.stopTest();
        
       
         // for fetching the contract header information
        String JsonMsg4='[{ "aircraft_Make":"Gulfstream Aerospace Corp","aircraft_Model":"Gulfstream IV","aircraft_SerialNumber":"1077"}]';
                        
        RestRequest req4 = new RestRequest(); 
        RestResponse res4 = new RestResponse();
    
        req4.requestURI = '/services/apexrest/AerospaceContractServices';  //Request URL
        req4.httpMethod = 'POST';//HTTP Request Type
        req4.requestBody = Blob.valueof(JsonMsg4);
        RestContext.request = req4;
        RestContext.response= res4;
        ContractWebServiceController.queryAircraftInformation();
        
       
    }

}