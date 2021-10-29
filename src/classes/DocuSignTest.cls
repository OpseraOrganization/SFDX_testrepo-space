@isTest
private class DocuSignTest {
  public static testMethod void DocusignTest1(){
        
        
       Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Unauthorized Dist/Brkr';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Business Aviation';
        insert acc;
        
        Contract objContract = new Contract();
        objContract.accountId = acc.id;
       
        insert objContract;
      
      Opportunity opp=new Opportunity();
       
        opp.Satcom_Direct_Customer__c='Yes';
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Prospecting' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit'; 
        insert opp;
       
        opp.Sales_Type__c='Completion';
        opp.Satcom_Direct_Customer__c='No';
        
        update opp;
       
        test.startTest(); 
        Case objCase = new Case();
     //   objCase.REcordTypeId='Test RT';
                        objCase.type='MSP Renewal';
                        objCase.Opportunity__c = opp.id;
                        objCase.Status='Open';
                        objCase.Classification__c='MSP_Int';
                        objCase.origin='Web';
                        objCase.Serv_Contract__c = objContract.Id;
                        objCase.Subject = 'test Subject';
        
        insert objCase;
      
      objCase.Subject = 'test Subject2';
      
      update objCase;
        
        dsfs__DocuSign_Status__c objDocuSign = new dsfs__DocuSign_Status__c();
        objDocuSign.dsfs__Company__c = acc.Id;
        objDocuSign.dsfs__Contract__c = objContract.id;
        objDocuSign.dsfs__Envelope_Status__c = 'MSP Contract Honeywell';
       objDocuSign.dsfs__Subject__c = 'Sent';
        
        insert objDocuSign;
                      
        
        test.stopTest();
        
    }
    
    public static testMethod void DocusignTest2(){
        
        
       Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Unauthorized Dist/Brkr';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Business Aviation';
        insert acc;
        
        Contract objContract = new Contract();
        objContract.accountId = acc.id;
       
        insert objContract;
      
      Opportunity opp=new Opportunity();
       
        opp.Satcom_Direct_Customer__c='Yes';
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Prospecting' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit'; 
        insert opp;
       
        opp.Sales_Type__c='Completion';
        opp.Satcom_Direct_Customer__c='No';
        
        update opp;
       
        test.startTest(); 
        Case objCase = new Case();
                      objCase.REcordTypeId= RecordTypeServices.getRecordTypeByName('MSP Contract','Case').Id;
                        objCase.type='MSP Renewal';
                        objCase.Opportunity__c = opp.id;
                        objCase.Status='Open';
                        objCase.Classification__c='MSP_Int';
                        objCase.origin='Web';
                        objCase.Serv_Contract__c = objContract.Id;
                        objCase.Subject = 'test Subject';
        
        insert objCase;
      
    
        dsfs__DocuSign_Status__c objDocuSign = new dsfs__DocuSign_Status__c();
        objDocuSign.dsfs__Company__c = acc.Id;
        objDocuSign.dsfs__Contract__c = objContract.id;
        objDocuSign.dsfs__Envelope_Status__c = 'MSP Contract Honeywell';
       objDocuSign.dsfs__Subject__c = 'Sent';
        
        insert objDocuSign;
                      
        
        test.stopTest();
        
    }
    public static testMethod void DocusignTest3(){
        
        
       Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Unauthorized Dist/Brkr';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Business Aviation';
        insert acc;
        
        Contract objContract = new Contract();
        objContract.accountId = acc.id;
       
        insert objContract;
      
      Opportunity opp=new Opportunity();
       
        opp.Satcom_Direct_Customer__c='Yes';
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Prospecting' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit'; 
        insert opp;
       
        opp.Sales_Type__c='Completion';
        opp.Satcom_Direct_Customer__c='No';
        
        update opp;
       
        test.startTest(); 
        Case objCase = new Case();
                      objCase.REcordTypeId= RecordTypeServices.getRecordTypeByName('MSP Contract','Case').Id;
                        objCase.type='MSP Renewal';
                        objCase.Opportunity__c = opp.id;
                        objCase.Status='Open';
                        objCase.Classification__c='MSP_Int';
                        objCase.origin='Web';
                        objCase.Serv_Contract__c = objContract.Id;
                        objCase.Subject = 'test Subject';
        
        insert objCase;
      
    
        dsfs__DocuSign_Status__c objDocuSign = new dsfs__DocuSign_Status__c();
        objDocuSign.dsfs__Company__c = acc.Id;
        objDocuSign.dsfs__Contract__c = objContract.id;
        objDocuSign.dsfs__Envelope_Status__c = 'Sent';
        objDocuSign.dsfs__Subject__c = 'MSP Customer Profile form';
         
        
        insert objDocuSign;
        
        
        objDocuSign.dsfs__Subject__c = 'Honeywell MSP Contract';
        update    objDocuSign;        
        
        test.stopTest();
        
    }
    }