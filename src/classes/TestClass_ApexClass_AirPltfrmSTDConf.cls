/** * File Name:  TestClass_ApexClass_AirPltfrmSTDConf
* Description Test Method
* Class Tested: AircraftPlatformSTDConf 
* Copyright : Wipro Technologies Limited Copyright (c) 2011
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest(SeeAllData=true)
private class TestClass_ApexClass_AirPltfrmSTDConf {

    static testMethod void airPltfrmSTDConfTest() {
        
        Account tstAccRec = new Account(name = 'Test Account' );
       
        Platform__c plat1 = new Platform__c(Name='Test Platform1',Platform_Type__c='test1',Model__c='test1',Make__c='test1',Managing_SBU__c='ATR');
        insert plat1;       
       
        Fleet_Asset_Detail__c tstFleetAssetDtl = new Fleet_Asset_Detail__c( Account__c = tstAccRec.Id ,Name= 'Test Fleet Asset', OEM_Name__c=tstAccRec.Id , Platform_Name__c = plat1.id);
        insert tstFleetAssetDtl;
        
        Aircraft_Platform_Configuration__c tstAirPltStdConf = new Aircraft_Platform_Configuration__c(DESCRIPTION_NM__c = 'Test Plat Form Configuration', Platform_Name__c = plat1.id);
        insert tstAirPltStdConf;
        
        
        Aircraft_Custom_Configuration__c tstCustConfig = new Aircraft_Custom_Configuration__c(Aircraft_Platform_Standard_Configuration__c=tstAirPltStdConf.Id, Fleet_Asset_Detail__c=tstFleetAssetDtl.id);
        insert tstCustConfig;
        Test.startTest();
        ApexPages.StandardController tstController = new ApexPages.StandardController(tstFleetAssetDtl) ;
                
        AircraftPlatformSTDConf tstAirCrftPltFrm = new AircraftPlatformSTDConf(tstController);
        
        List<Aircraft_Platform_Configuration__c> tstAircrftPltList= tstAirCrftPltFrm.getPltConf();
       
        List<Aircraft_Custom_Configuration__c> tstAircrftPltList1=tstAirCrftPltFrm.getAirConf();
        
        Test.stopTest();
        
        
    }
     static testMethod void airPltfrmSTDConfTest1() {
        
        Account tstAccRec = new Account(name = 'Test Account' );
        Platform__c plat = new Platform__c(Name='Test Platform',Platform_Type__c='test',Model__c='test',Make__c='test',Managing_SBU__c='ATR');
        insert plat;
        
        Platform__c plat1 = new Platform__c(Name='Test Platform1',Platform_Type__c='test1',Model__c='test1',Make__c='test1',Managing_SBU__c='ATR');
        insert plat1;
        
         Fleet_Asset_Detail__c fleetAssetDetail = new Fleet_Asset_Detail__c();
         fleetAssetDetail.Name='testFleetAsset';
         fleetAssetDetail.Serial_Number__c ='SN61611';
         fleetAssetDetail.New_Alert_Identification__c = true;
         fleetAssetDetail.Account__c=tstAccRec.id;
         fleetAssetDetail.Platform_Name__c = plat.id;
         fleetAssetDetail.State__c='canada';
        // fleetAssetDetail.Model__c='34-tr';
         insert fleetAssetDetail;
          Attachment attach=new Attachment();     
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=fleetAssetDetail.id;
            insert attach;
            
            
            
            Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=tstAccRec.Id,Phone_3__c='9986502495',Aircraft_Notifications__c=true,
            Contact_Is_Employee__c=true,  Contact_Status__c='Active' ,Employee_Number__c='E146953', 
            Employee_Contact_Role__c='Analyst',Email='test@123.com', Aircraft_Alert_for_Platforms__c=plat.id);
            insert cont;
            
            
            
        Test.startTest();    
        
        boolean isAlreadyExecuted=true; 
        AircraftNotificationsTriggerStopper.hasalreadyExecuted();
        AircraftNotificationsTriggerStopper.setalreadyExecuted();
        AircraftNotificationsTriggerStopper.unsetalreadyExecuted();
        //Added by Sagarika
        AircraftNotificationsTriggerStopper.setalreadyExecutedPFECN();
        AircraftNotificationsTriggerStopper.hasalreadyExecutedNavdb();
        AircraftNotificationsTriggerStopper.setalreadyExecutedNavdb();
        AircraftNotificationsTriggerStopper.setalreadyExecutedORdersRT();
        AircraftNotificationsTriggerStopper.hasalreadyExecutedDupeOppty();
        AircraftNotificationsTriggerStopper.setalreadyExecutedDupeOppty();
        AircraftNotificationsTriggerStopper.hasalreadyExecutedPPO();
        AircraftNotificationsTriggerStopper.setalreadyExecutedPPO();
        AircraftNotificationsTriggerStopper.hasalreadyExecutedPFECN();
        AircraftNotificationsTriggerStopper.setalreadyExecutedPFECN();
        AircraftNotificationsTriggerStopper.unsetalreadyExecuted();
        AircraftNotificationsTriggerStopper.hasalreadyExecutedORdersRT();
        plat.Parent_Platform__c=plat1.id;
        update plat; 
        
        AircraftNotificationsTriggerStopper.unsetalreadyExecuted();
        fleetAssetDetail.Fleet_Asset_Notification__c = true; 
        update fleetAssetDetail;
        Test.stopTest();
        
        
    }
}