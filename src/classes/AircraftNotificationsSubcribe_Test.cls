@isTest(SeeAllData=true)
private class AircraftNotificationsSubcribe_Test {

    static testMethod void AircraftNotificationsSubcribe_controller_Test1() {
       test.starttest();
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];
       
        Map<id,Platform__c> searchResults1 = new  Map<id,Platform__c>(); 
      
           Contact testContact = new contact();
        testContact.LastName = 'Test Contact';        
        testContact.Account = acc;        
        testContact.SBU_Contact__c = 'D&S';        
        testContact.CBT__c = 'DAA';        
        testContact.CBT_Team__c = 'CBMS';        
        testContact.Primary_Email_Address__c = 'test@hh.com';        
        testContact.Functional_Role__c = 'Sales';
        testContact.Phone_3__c = '12311111';
        testContact.Aircraft_Alert_for_Platforms__c = 'All';
        insert testContact;
        
            Platform__c p = new Platform__c();
        p.Name = 'Test Platform11';
        p.Model__c = '36-16A';
        p.Make__c = 'VARIOUS OEMS';
        //p.SAP_External_System__c=True;
        insert p;
        searchResults1.put(p.id,p);
         Platform__c p1 = new Platform__c();
        p1.Name = 'Test Platform12';
        p1.Model__c = '36-16A';
        p1.Make__c = 'VARIOUS OEMS';
        //p.SAP_External_System__c=True;
        insert p1;
        searchResults1.put(p1.id,p1);
         list<string> strnglst = new list<string>();
        strnglst.add(string.valueof(p.id));
        strnglst.add(string.valueof(p1.id));
        
        AircraftNotificationsSubcribe_controller controller1 = new AircraftNotificationsSubcribe_controller();
        AircraftNotificationsSubcribe_controller controller = new AircraftNotificationsSubcribe_controller(new ApexPages.StandardController(testContact));
       
       controller.selectedSubscription = null;
       controller.save();
       controller.selectedSubscription = 'update';
       controller.save();
       controller.rightSelectPlatforms  = strnglst;
       controller.save();
        controller.selectedSubscription = 'all'; 
        controller.save();
        controller.getItems();
       // controller.toLeft();
        //controller.toRight();
        controller.searchPlatform();
        
        testContact.Aircraft_Alert_for_Platforms__c = 'none';
        update testContact;
          AircraftNotificationsSubcribe_controller controller2 = new AircraftNotificationsSubcribe_controller(new ApexPages.StandardController(testContact));
         
          testContact.Aircraft_Alert_for_Platforms__c = p.id;
          update testContact;
          AircraftNotificationsSubcribe_controller controller3 = new AircraftNotificationsSubcribe_controller(new ApexPages.StandardController(testContact));
          
        
        controller.platformSearchTerm = 'test';
        controller.searchPlatform();
        
        
        //controller.rightSelectPlatforms = strnglst; 
        controller.leftSelectPlatforms = strnglst;
        controller.searchResults = searchResults1;
        controller.toRight();
        controller.rightSelectPlatforms  = strnglst;
        controller.searchResults = searchResults1;
        controller.toLeft();
        test.stoptest();
    }
    
  
}