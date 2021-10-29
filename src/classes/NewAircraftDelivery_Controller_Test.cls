@isTest(SeeAllData=true)
private class NewAircraftDelivery_Controller_Test {

    static testMethod void myNewAircraftDelivery_ControllerTest1() {
       test.starttest();
       
      Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c,GTA_number__c,POC_Management__c from account where Name LIKE '%honeywell %' limit 1];
       
        Platform__c p = new Platform__c();
        p.Name = 'Test Paltform';
        p.Model__c = '36-16A';
        p.Make__c = 'VARIOUS OEMS';
        //p.SAP_External_System__c=True;
        insert p;
        
         /*Fleet_Asset_Detail__c fleetAssetDetail = new Fleet_Asset_Detail__c();
         fleetAssetDetail.Name='testFleetAsset';
         fleetAssetDetail.Serial_Number__c ='SN61611';
         fleetAssetDetail.New_Alert_Identification__c = true;
         fleetAssetDetail.State__c='canada';
         fleetAssetDetail.Platform_Name__c = p.id;
         insert fleetAssetDetail;*/
        
        Fleet_Asset_Detail__c fleetAssetDetail = [select id from Fleet_Asset_Detail__c order by createddate desc limit 1];
        NewAircraftDelivery_Controller controller = new NewAircraftDelivery_Controller(new ApexPages.StandardController(new Fleet_Asset_Detail__c()));
        
        controller.fleetAssetDetail.Aircraft_Delivery_Date__c = date.newInstance(12, 1, 2014);
        controller.fleetAssetDetail.Account__c = acc.id;
        controller.fleetAssetDetail.Serial_Number__c ='SN61611';
        NewAircraftDelivery_Controller.searchAccounts('searchAccounts');
        NewAircraftDelivery_Controller.searchPlatforms('searchPlatforms');
        NewAircraftDelivery_Controller.searchContacts('searchContacts');
        NewAircraftDelivery_Controller.getAccountAddress(string.valueOf(acc.Id));
        NewAircraftDelivery_Controller.getMakeAndModel(string.valueOf(p.Id));
        //NewAircraftDelivery_Controller.getFleetDetails(fleetAssetDetail.State__c,fleetAssetDetail.id);
        NewAircraftDelivery_Controller.searchDetails('EGPWS');
        controller.saveAAS();
        controller.AccountNotFound = false;
        //controller.fleetAssetDetail.Account__c = null;
        //controller.saveAAS();
        test.stoptest();
    }
    
    static testMethod void myNewAircraftDelivery_ControllerTest2() {
     test.starttest();
     //Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];
        
          Account acc = new Account();
        acc.Name='Accountss';
        acc.POC_Management__c='123';
        acc.GTA_number__c='987';
      
        insert acc;
        
        
        PageReference newAircraftDelivery_pageRef = Page.NewAircraftNotification_2_VF;
        Test.setCurrentPage(newAircraftDelivery_pageRef);
        
        NewAircraftDelivery_Controller controller = new NewAircraftDelivery_Controller(new ApexPages.StandardController(new Fleet_Asset_Detail__c()));
        controller.tempAccountID = acc.id;
        //controller.AccountNotFound = true;
        controller.getacctTypes();
        controller.fleetAssetDetail.Serial_Number__c ='SN61611';
       /* controller.fleetAssetDetail.Aircraft_Delivery_Date__c = date.newInstance(12, 1, 2014);
        controller.fleetAssetDetail.Serial_Number__c ='SN61611';
        controller.city = 'Test City';
        controller.primaryEmailAdd = 'test@gmail.com';
        controller.selectedAccType = 'Test';
        controller.streetAddLine1 = 'Test Street1';
        controller.streetAddLine2 = 'Test Street2';
        controller.zipCode = '1113411'; */
        
        NewAircraftDelivery_Controller.getAccountAddress(string.valueOf(acc.Id));
        
       
        controller.saveAAS();
         test.stoptest();
    }
    
    
    static testMethod void myNewAircraftDelivery_ControllerTest3() {
    test.starttest();
    Platform__c p = new Platform__c();
        p.Name = 'Test Platform11';
        p.Model__c = '36-16A';
        p.Make__c = 'VARIOUS OEMS';
        insert p;
        
         Fleet_Asset_Detail__c fleetAssetDetail = new Fleet_Asset_Detail__c();
         fleetAssetDetail.Name='testFleetAsset';
         fleetAssetDetail.Serial_Number__c ='SN61611';
         fleetAssetDetail.New_Alert_Identification__c = true;
         
         fleetAssetDetail.Platform_Name__c = p.id;
         fleetAssetDetail.State__c='canada';
        // fleetAssetDetail.Model__c='34-tr';
         insert fleetAssetDetail;
         
         Attachment attach=new Attachment();     
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=fleetAssetDetail.id;
            insert attach;
            
        fleetAssetDetail.Fleet_Asset_Notification__c = true; 
       
          //update fleetAssetDetail;
         
    test.stoptest();
    }
    

 static testMethod void myNewAircraftDelivery_ControllerTest4() {
       test.starttest();
          
        //Case cse=[select id from Case where CaseNumber='CASE-11889747' limit 1];
       
        PageReference newAircraftDelivery_pageRef = Page.NewAircraftNotification_2_VF;
        Test.setCurrentPage(newAircraftDelivery_pageRef);
        NewAircraftDelivery_Controller controller = new NewAircraftDelivery_Controller(new ApexPages.StandardController(new Fleet_Asset_Detail__c()));
        controller.saveAAS();
 
         List<Task> newTaskList =[select id,Type,Subject,Description from Task where Type ='Customer Communication' limit 1];
         system.debug(newTaskList!=null);
         system.debug('the new task is'+newTaskList[0]);
         system.assertEquals('Customer Communication',newTaskList[0].Type);
         test.stoptest();
         }
         
    static testMethod void myNewAircraftDelivery_ControllerTest5() {
       test.starttest();
       
      Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c,GTA_number__c,POC_Management__c from account where Name LIKE '%honeywell %' limit 1];
       
        Platform__c p = new Platform__c();
        p.Name = 'Test Paltform';
        p.Model__c = '36-16A';
        p.Make__c = 'VARIOUS OEMS';
        //p.SAP_External_System__c=True;
        insert p;
        
         Fleet_Asset_Detail__c fleetAssetDetail = new Fleet_Asset_Detail__c();
         fleetAssetDetail.Name='testFleetAsset';
         fleetAssetDetail.Serial_Number__c ='SN61611';
         fleetAssetDetail.New_Alert_Identification__c = true;
         fleetAssetDetail.State__c='canada';
         fleetAssetDetail.Platform_Name__c = p.id;
         insert fleetAssetDetail;
        
        //Fleet_Asset_Detail__c fleetAssetDetail = [select id from Fleet_Asset_Detail__c order by createddate desc limit 1];
        NewAircraftDelivery_Controller controller = new NewAircraftDelivery_Controller(new ApexPages.StandardController(new Fleet_Asset_Detail__c()));
        
        controller.fleetAssetDetail.Aircraft_Delivery_Date__c = date.newInstance(12, 1, 2014);
        controller.fleetAssetDetail.Account__c = acc.id;
        controller.fleetAssetDetail.Serial_Number__c ='SN61611';
        NewAircraftDelivery_Controller.searchAccounts('searchAccounts');
        NewAircraftDelivery_Controller.searchPlatforms('searchPlatforms');
        NewAircraftDelivery_Controller.searchContacts('searchContacts');
        NewAircraftDelivery_Controller.getAccountAddress(string.valueOf(acc.Id));
        NewAircraftDelivery_Controller.getMakeAndModel(string.valueOf(p.Id));
        NewAircraftDelivery_Controller.getFleetDetails(string.valueOf(acc.Id));
        NewAircraftDelivery_Controller.searchDetails('EGPWS');
        //NewAircraftDelivery_Controller.FleetAssetupdate(fleetAssetDetail.id);
        NewAircraftDelivery_Controller.sendNotification(fleetAssetDetail.id);
        //NewAircraftDelivery_Controller.sendNotification(fleetAssetDetail.id);
        // NewAircraftDelivery_Controller.caseUpdate(cas1.id);
        //controller.saveAAS();
        controller.AccountNotFound = false;
        //controller.fleetAssetDetail.Account__c = null;
        controller.saveAAS();
        test.stoptest();
    } 
 }