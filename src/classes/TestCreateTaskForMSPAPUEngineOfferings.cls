@isTest
private class TestCreateTaskForMSPAPUEngineOfferings{
    static testMethod void testBatchClass(){
        Account acct = new Account();
        acct.type = 'Dealer';
        acct.Name = 'Test Account';
        insert acct;
        
        RMU_VALUE__c rmuvalue = new RMU_VALUE__c(name='MSP APU (Gold)');
        insert rmuvalue;
        
        RMU_VALUE__c rmuvalue1 = new RMU_VALUE__c(name='MSP Engines');
        insert rmuvalue1;
        
        RMU_VALUE__c rmuvalue2 = new RMU_VALUE__c(name='MSP APU');
        insert rmuvalue2;
        
        RMU_VALUE__c rmuvalue3 = new RMU_VALUE__c(name='MSP Engines (Gold)');
        insert rmuvalue3;
        
        
        
        OFFERING_MAPPER__c rmu = new OFFERING_MAPPER__c(name='Test RMU');
        rmu.RMU_VALUE__c = rmuvalue.id;
        rmu.RMU_Platform_Product_Ratio__c = 10.00;
        rmu.RMU_DEALER_PRC__c = 5.0;
        insert rmu;
        
        
        Account_Eligible_RMU__c aer= new Account_Eligible_RMU__c();
        /* Commenting the below line as part of CRQ000000163236, in the production Account_Eligible_RMU__c object we dont have 
           RMU_Platform__c field.Hence this test class is getting failed during deployment.
           Note:- This test class will fail in UAT till we get the refresh from Production.
        */
        //aer.RMU_Platform__c = rmu.id;
        insert aer;
        
    
         Case cas = new Case();
            cas.Origin = 'web';
            cas.Status = 'Open';  
            cas.OwnerId = Label.CSO_R_O_Team;
            //cas.ContactId = objContact.Id;
            cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
            cas.Classification__c = 'CSO Repair Order';
            //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
            cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
            cas.Government_Compliance_SM_M_Content__c = 'No';
            cas.Sales_Order_Number__c = '12345678';
            //cas.Order_Entered_By__c = 'Harikishore';
            cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
            cas.Description = 'Test cases';
            cas.subject='test case';
            insert cas;
            
            Platform__c p = new Platform__c();
            p.Platform__c ='Test platform please ignore';
            p.APU_Maker__c = 'Honeywell';
          p.Engine_Maker__c = 'Honeywell';
            insert p;
            
        Fleet_Asset_Detail__c fad = new Fleet_Asset_Detail__c();
            fad.Case_Associated__c = cas.Id;
            fad.New_Alert_Identification__c = true;
            fad.Platform_Name__c =p.id;
            fad.Serial_Number__c = 'test 123';
            fad.Status__c = 'In Service';
            
            insert fad;
        
         Fleet_Asset_Detail__c fad1 = new Fleet_Asset_Detail__c();
            fad1.Case_Associated__c = cas.Id;
            fad1.New_Alert_Identification__c = true;
            fad1.Platform_Name__c =p.id;
            fad1.Serial_Number__c = 'test 123';
            fad1.Status__c = 'In Service';
            
            insert fad1;
            
             Fleet_Asset_Detail__c fad2 = new Fleet_Asset_Detail__c();
            fad2.Case_Associated__c = cas.Id;
            fad2.New_Alert_Identification__c = true;
            fad2.Platform_Name__c =p.id;
            fad2.Serial_Number__c = 'test 123';
            fad2.Status__c = 'In Service';
            
            
            insert fad2;
            
             Fleet_Asset_Detail__c fad3 = new Fleet_Asset_Detail__c();
            fad3.Case_Associated__c = cas.Id;
            fad3.New_Alert_Identification__c = true;
            fad3.Platform_Name__c =p.id;
            fad3.Serial_Number__c = 'test 123';
            fad3.Status__c = 'In Service';
            
            
            insert fad3;
            
            
        Account_Eligible_RMU_Fleet_Asset__c aerfa = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa.Account_Eligible_RMU__c = aer.id;
        aerfa.Account__c = acct.Id;
        aerfa.RMU_Platform__c = rmu.id;
        aerfa.AER_Update__c = false;
        aerfa.Aircraft_Count__c=10;
        aerfa.RMU__c = rmuvalue.id;
        aerfa.Aircraft_Installed_Count__c=8; 
        aerfa.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa.RMU_Flyaway_Work_Ext__c = 0.0;  
        aerfa.Aircraft__c = fad.id; 
        insert aerfa;
        
        Account_Eligible_RMU_Fleet_Asset__c aerfa1 = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa1.Account_Eligible_RMU__c = aer.id;
        aerfa1.Account__c = acct.Id;
        aerfa1.RMU_Platform__c = rmu.id;
        aerfa1.AER_Update__c = false;
        aerfa1.Aircraft_Count__c=10;
        aerfa1.RMU__c = rmuvalue1.id;
        aerfa1.Aircraft_Installed_Count__c=8; 
        aerfa1.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa1.RMU_Flyaway_Work_Ext__c = 0.0;  
        aerfa1.Aircraft__c = fad1.id; 
        insert aerfa1;
        
        
        Account_Eligible_RMU_Fleet_Asset__c aerfa2 = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa2.Account_Eligible_RMU__c = aer.id;
        aerfa2.Account__c = acct.Id;
        aerfa2.RMU_Platform__c = rmu.id;
        aerfa2.AER_Update__c = false;
        aerfa2.Aircraft_Count__c=10;
        aerfa2.RMU__c = rmuvalue2.id;
        aerfa2.Aircraft_Installed_Count__c=8; 
        aerfa2.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa2.RMU_Flyaway_Work_Ext__c = 0.0;  
        aerfa2.Aircraft__c = fad2.id; 
        insert aerfa2;
        
        Account_Eligible_RMU_Fleet_Asset__c aerfa3 = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa3.Account_Eligible_RMU__c = aer.id;
        aerfa3.Account__c = acct.Id;
        aerfa3.RMU_Platform__c = rmu.id;
        aerfa3.AER_Update__c = false;
        aerfa3.Aircraft_Count__c=10;
        aerfa3.RMU__c = rmuvalue3.id;
        aerfa3.Aircraft_Installed_Count__c=8; 
        aerfa3.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa3.RMU_Flyaway_Work_Ext__c = 0.0;  
        aerfa3.Aircraft__c = fad3.id; 
        insert aerfa3;
        
        
        
        Contract cnt = new Contract();
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt.AccountId = acct.id;
            cnt.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt.Renewal_Start_date__c = System.today();
            cnt.Renewal_Account_Name_Dealer__c = acct.id;
            cnt.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt.Renewal_Customer__c = acct.id;
            cnt.Renewal_Notes__c = 'Test Note';        
            cnt.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt.Status = 'Pending Activation';
            cnt.Type__c = 'HAPP/MPP';
            cnt.StartDate = date.newinstance(2009, 1, 7);
            cnt.Enddate = system.today().addDays(30);
            cnt.Name = '1234';
            insert cnt;
            
            
            Contract cnt1 = new Contract();
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt1.AccountId = acct.id;
            cnt1.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt1.Renewal_Start_date__c = System.today();
            cnt1.Renewal_Account_Name_Dealer__c = acct.id;
            cnt1.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt1.Renewal_Customer__c = acct.id;
            cnt1.Renewal_Notes__c = 'Test Note';        
            cnt1.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt1.Status = 'Pending Activation';
            cnt1.Type__c = 'HAPP/MPP';
            cnt1.StartDate = date.newinstance(2009, 1, 7);
            cnt1.Enddate = system.today().addDays(30);
            cnt1.Name = '12345';
            insert cnt1;
            
            Contract cnt2 = new Contract();
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt2.AccountId = acct.id;
            cnt2.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt2.Renewal_Start_date__c = System.today();
            cnt2.Renewal_Account_Name_Dealer__c = acct.id;
            cnt2.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt2.Renewal_Customer__c = acct.id;
            cnt2.Renewal_Notes__c = 'Test Note';        
            cnt2.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt2.Status = 'Pending Activation';
            cnt2.Type__c = 'HAPP/MPP';
            cnt2.StartDate = date.newinstance(2009, 1, 7);
            cnt2.Enddate = system.today().addDays(30);
            cnt2.Name = '123456';
            insert cnt2;
            
            Contract cnt3 = new Contract();
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt3.AccountId = acct.id;
            cnt3.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt3.Renewal_Start_date__c = System.today();
            cnt3.Renewal_Account_Name_Dealer__c = acct.id;
            cnt3.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt3.Renewal_Customer__c = acct.id;
            cnt3.Renewal_Notes__c = 'Test Note';        
            cnt3.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt3.Status = 'Pending Activation';
            cnt3.Type__c = 'HAPP/MPP';
            cnt3.StartDate = date.newinstance(2009, 1, 7);
            cnt3.Enddate = system.today().addDays(30);
            cnt3.Name = '1234567';
            insert cnt3;
        RMU_Sales__c sales = new RMU_Sales__c();
        sales.Aircraft__c = fad.id;
        sales.RMU__c = rmuvalue.id;
        sales.Order_Number__c = 'Cnt-'+cnt.Name;
        insert sales;
        
        
        sales = new RMU_Sales__c();
        sales.Aircraft__c = fad1.id;
        sales.RMU__c = rmuvalue1.id;
        sales.Order_Number__c = 'Cnt-'+cnt.Name;
        insert sales;
        
        sales = new RMU_Sales__c();
        sales.Aircraft__c = fad2.id;
        sales.RMU__c = rmuvalue2.id;
        sales.Order_Number__c = 'Cnt-'+cnt.Name;
        insert sales;
        
        sales = new RMU_Sales__c();
        sales.Aircraft__c = fad3.id;
        sales.RMU__c = rmuvalue3.id;
        sales.Order_Number__c = 'Cnt-'+cnt.Name;
        insert sales;
        
        Account_Eligible_RMU_Fleet_Asset__c  aerfact = [select RMU_Flyaway_Extended_Price__c,RMU_Flyaway_Work_Ext__c
                            from Account_Eligible_RMU_Fleet_Asset__c where id =:aerfa.id];
        system.debug('aerfa value:'+aerfact);
        system.debug('RMU_Product_Ratio__c value:'+aerfa.RMU_Product_Ratio__c);
        system.debug('RMU_Dealer_Price__c value:'+aerfa.RMU_Dealer_Price__c);
        system.debug('Aircraft_Open_Count__c value:'+aerfa.Aircraft_Open_Count__c);        
        system.debug('RMU_Dealer_Extended_Price__c value:'+aerfa.RMU_Dealer_Extended_Price__c);
        Id batch = Database.executeBatch(new BatchAERUpdate(),10);
        
        Test.StartTest();
        CreateTaskForMSPAPUEngineOfferings sh1 = new CreateTaskForMSPAPUEngineOfferings();
        Database.executeBatch(new CreateTaskForMSPAPUEngineOfferings());
        
    }
    
    static testMethod void testBatchClass2(){
        Account acct = new Account();
        acct.type = 'Dealer';
        acct.Name = 'Test Account';
        insert acct;
        
        RMU_VALUE__c rmuvalue = new RMU_VALUE__c(name='MSP Engines');
        insert rmuvalue;
        
        RMU_VALUE__c rmuvalue1 = new RMU_VALUE__c(name='MSP Engines (Gold)');
        insert rmuvalue1;
        
        RMU_VALUE__c rmuvalue2 = new RMU_VALUE__c(name='MSP Engines');
        insert rmuvalue2;
        
        RMU_VALUE__c rmuvalue3 = new RMU_VALUE__c(name='MSP Engines (Gold)');
        insert rmuvalue3;
        
        
        
        OFFERING_MAPPER__c rmu = new OFFERING_MAPPER__c(name='Test RMU');
        rmu.RMU_VALUE__c = rmuvalue.id;
        rmu.RMU_Platform_Product_Ratio__c = 10.00;
        rmu.RMU_DEALER_PRC__c = 5.0;
        insert rmu;
        
        
        Account_Eligible_RMU__c aer= new Account_Eligible_RMU__c();
        /* Commenting the below line as part of CRQ000000163236, in the production Account_Eligible_RMU__c object we dont have 
           RMU_Platform__c field.Hence this test class is getting failed during deployment.
           Note:- This test class will fail in UAT till we get the refresh from Production.
        */
        //aer.RMU_Platform__c = rmu.id;
        insert aer;
        
    
         Case cas = new Case();
            cas.Origin = 'web';
            cas.Status = 'Open';  
            cas.OwnerId = Label.CSO_R_O_Team;
            //cas.ContactId = objContact.Id;
            cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
            cas.Classification__c = 'CSO Repair Order';
            //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
            cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
            cas.Government_Compliance_SM_M_Content__c = 'No';
            cas.Sales_Order_Number__c = '12345678';
            //cas.Order_Entered_By__c = 'Harikishore';
            cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
            cas.Description = 'Test cases';
            cas.subject='test case';
            insert cas;
            
            Platform__c p = new Platform__c();
            p.Platform__c ='Test platform please ignore';
            p.APU_Maker__c = 'Honeywell';
          p.Engine_Maker__c = 'Honeywell';
            insert p;
            
        Fleet_Asset_Detail__c fad = new Fleet_Asset_Detail__c();
            fad.Case_Associated__c = cas.Id;
            fad.New_Alert_Identification__c = true;
            fad.Platform_Name__c =p.id;
            fad.Serial_Number__c = 'test 123';
            fad.Status__c = 'In Service';
            
            
            insert fad;
        
         Fleet_Asset_Detail__c fad1 = new Fleet_Asset_Detail__c();
            fad1.Case_Associated__c = cas.Id;
            fad1.New_Alert_Identification__c = true;
            fad1.Platform_Name__c =p.id;
            fad1.Serial_Number__c = 'test 123';
            fad1.Status__c = 'In Service';
            
            
            insert fad1;
            
             Fleet_Asset_Detail__c fad2 = new Fleet_Asset_Detail__c();
            fad2.Case_Associated__c = cas.Id;
            fad2.New_Alert_Identification__c = true;
            fad2.Platform_Name__c =p.id;
            fad2.Serial_Number__c = 'test 123';
            fad2.Status__c = 'In Service';
            
            insert fad2;
            
             Fleet_Asset_Detail__c fad3 = new Fleet_Asset_Detail__c();
            fad3.Case_Associated__c = cas.Id;
            fad3.New_Alert_Identification__c = true;
            fad3.Platform_Name__c =p.id;
            fad3.Serial_Number__c = 'test 123';
            fad3.Status__c = 'In Service';
            
            insert fad3;
            
            
        Account_Eligible_RMU_Fleet_Asset__c aerfa = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa.Account_Eligible_RMU__c = aer.id;
        aerfa.Account__c = acct.Id;
        aerfa.RMU_Platform__c = rmu.id;
        aerfa.AER_Update__c = false;
        aerfa.Aircraft_Count__c=10;
        aerfa.RMU__c = rmuvalue.id;
        aerfa.Aircraft_Installed_Count__c=8; 
        aerfa.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa.RMU_Flyaway_Work_Ext__c = 0.0;  
        aerfa.Aircraft__c = fad.id; 
        insert aerfa;
        
        Account_Eligible_RMU_Fleet_Asset__c aerfa1 = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa1.Account_Eligible_RMU__c = aer.id;
        aerfa1.Account__c = acct.Id;
        aerfa1.RMU_Platform__c = rmu.id;
        aerfa1.AER_Update__c = false;
        aerfa1.Aircraft_Count__c=10;
        aerfa1.RMU__c = rmuvalue1.id;
        aerfa1.Aircraft_Installed_Count__c=8; 
        aerfa1.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa1.RMU_Flyaway_Work_Ext__c = 0.0;  
        aerfa1.Aircraft__c = fad.id; 
        insert aerfa1;
        
        
        Account_Eligible_RMU_Fleet_Asset__c aerfa2 = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa2.Account_Eligible_RMU__c = aer.id;
        aerfa2.Account__c = acct.Id;
        aerfa2.RMU_Platform__c = rmu.id;
        aerfa2.AER_Update__c = false;
        aerfa2.Aircraft_Count__c=10;
        aerfa2.RMU__c = rmuvalue2.id;
        aerfa2.Aircraft_Installed_Count__c=8; 
        aerfa2.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa2.RMU_Flyaway_Work_Ext__c = 0.0;  
        aerfa2.Aircraft__c = fad.id; 
        insert aerfa2;
        
        Account_Eligible_RMU_Fleet_Asset__c aerfa3 = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa3.Account_Eligible_RMU__c = aer.id;
        aerfa3.Account__c = acct.Id;
        aerfa3.RMU_Platform__c = rmu.id;
        aerfa3.AER_Update__c = false;
        aerfa3.Aircraft_Count__c=10;
        aerfa3.RMU__c = rmuvalue3.id;
        aerfa3.Aircraft_Installed_Count__c=8; 
        aerfa3.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa3.RMU_Flyaway_Work_Ext__c = 0.0;  
        aerfa3.Aircraft__c = fad.id; 
        insert aerfa3;
        
        
        
        Contract cnt = new Contract();
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt.AccountId = acct.id;
            cnt.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt.Renewal_Start_date__c = System.today();
            cnt.Renewal_Account_Name_Dealer__c = acct.id;
            cnt.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt.Renewal_Customer__c = acct.id;
            cnt.Renewal_Notes__c = 'Test Note';        
            cnt.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt.Status = 'Pending Activation';
            cnt.Type__c = 'HAPP/MPP';
            cnt.StartDate = date.newinstance(2009, 1, 7);
            cnt.Enddate = system.today().addDays(30);
            cnt.Name = '1234';
            insert cnt;
            
            
            Contract cnt1 = new Contract();
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt1.AccountId = acct.id;
            cnt1.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt1.Renewal_Start_date__c = System.today();
            cnt1.Renewal_Account_Name_Dealer__c = acct.id;
            cnt1.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt1.Renewal_Customer__c = acct.id;
            cnt1.Renewal_Notes__c = 'Test Note';        
            cnt1.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt1.Status = 'Pending Activation';
            cnt1.Type__c = 'HAPP/MPP';
            cnt1.StartDate = date.newinstance(2009, 1, 7);
            cnt1.Enddate = system.today().addDays(30);
            cnt1.Name = '12345';
            insert cnt1;
            
            Contract cnt2 = new Contract();
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt2.AccountId = acct.id;
            cnt2.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt2.Renewal_Start_date__c = System.today();
            cnt2.Renewal_Account_Name_Dealer__c = acct.id;
            cnt2.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt2.Renewal_Customer__c = acct.id;
            cnt2.Renewal_Notes__c = 'Test Note';        
            cnt2.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt2.Status = 'Pending Activation';
            cnt2.Type__c = 'HAPP/MPP';
            cnt2.StartDate = date.newinstance(2009, 1, 7);
            cnt2.Enddate = system.today().addDays(30);
            cnt2.Name = '123456';
            insert cnt2;
            
            Contract cnt3 = new Contract();
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt3.AccountId = acct.id;
            cnt3.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt3.Renewal_Start_date__c = System.today();
            cnt3.Renewal_Account_Name_Dealer__c = acct.id;
            cnt3.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt3.Renewal_Customer__c = acct.id;
            cnt3.Renewal_Notes__c = 'Test Note';        
            cnt3.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt3.Status = 'Pending Activation';
            cnt3.Type__c = 'HAPP/MPP';
            cnt3.StartDate = date.newinstance(2009, 1, 7);
            cnt3.Enddate = system.today().addDays(30);
            cnt3.Name = '1234567';
            insert cnt3;
        RMU_Sales__c sales = new RMU_Sales__c();
        sales.Aircraft__c = fad.id;
        sales.RMU__c = rmuvalue.id;
        sales.Order_Number__c = 'Cnt-'+cnt.Name;
        insert sales;
        
        
        sales = new RMU_Sales__c();
        sales.Aircraft__c = fad.id;
        sales.RMU__c = rmuvalue1.id;
        sales.Order_Number__c = 'Cnt-'+cnt.Name;
        insert sales;
        
        sales = new RMU_Sales__c();
        sales.Aircraft__c = fad.id;
        sales.RMU__c = rmuvalue2.id;
        sales.Order_Number__c = 'Cnt-'+cnt.Name;
        insert sales;
        
        sales = new RMU_Sales__c();
        sales.Aircraft__c = fad.id;
        sales.RMU__c = rmuvalue3.id;
        sales.Order_Number__c = 'Cnt-'+cnt.Name;
        insert sales;
        
        Account_Eligible_RMU_Fleet_Asset__c  aerfact = [select RMU_Flyaway_Extended_Price__c,RMU_Flyaway_Work_Ext__c
                            from Account_Eligible_RMU_Fleet_Asset__c where id =:aerfa.id];
        system.debug('aerfa value:'+aerfact);
        system.debug('RMU_Product_Ratio__c value:'+aerfa.RMU_Product_Ratio__c);
        system.debug('RMU_Dealer_Price__c value:'+aerfa.RMU_Dealer_Price__c);
        system.debug('Aircraft_Open_Count__c value:'+aerfa.Aircraft_Open_Count__c);        
        system.debug('RMU_Dealer_Extended_Price__c value:'+aerfa.RMU_Dealer_Extended_Price__c);
        Id batch = Database.executeBatch(new BatchAERUpdate(),10);
        
        Test.StartTest();
        CreateTaskForMSPAPUEngineOfferings sh1 = new CreateTaskForMSPAPUEngineOfferings();
        Database.executeBatch(new CreateTaskForMSPAPUEngineOfferings());
        
    }
    
    static testMethod void testBatchClass3(){
        Account acct = new Account();
        acct.type = 'Dealer';
        acct.Name = 'Test Account';
        insert acct;
        
        RMU_VALUE__c rmuvalue = new RMU_VALUE__c(name='MSP APU');
        insert rmuvalue;
        
        RMU_VALUE__c rmuvalue1 = new RMU_VALUE__c(name='MSP APU (Gold)');
        insert rmuvalue1;
        
        RMU_VALUE__c rmuvalue2 = new RMU_VALUE__c(name='MSP APU');
        insert rmuvalue2;
        
        RMU_VALUE__c rmuvalue3 = new RMU_VALUE__c(name='MSP APU (Gold)');
        insert rmuvalue3;
        
        
        
        OFFERING_MAPPER__c rmu = new OFFERING_MAPPER__c(name='Test RMU');
        rmu.RMU_VALUE__c = rmuvalue.id;
        rmu.RMU_Platform_Product_Ratio__c = 10.00;
        rmu.RMU_DEALER_PRC__c = 5.0;
        insert rmu;
        
        
        Account_Eligible_RMU__c aer= new Account_Eligible_RMU__c();
        /* Commenting the below line as part of CRQ000000163236, in the production Account_Eligible_RMU__c object we dont have 
           RMU_Platform__c field.Hence this test class is getting failed during deployment.
           Note:- This test class will fail in UAT till we get the refresh from Production.
        */
        //aer.RMU_Platform__c = rmu.id;
        insert aer;
        
    
         Case cas = new Case();
            cas.Origin = 'web';
            cas.Status = 'Open';  
            cas.OwnerId = Label.CSO_R_O_Team;
            //cas.ContactId = objContact.Id;
            cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
            cas.Classification__c = 'CSO Repair Order';
            //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
            cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
            cas.Government_Compliance_SM_M_Content__c = 'No';
            cas.Sales_Order_Number__c = '12345678';
            //cas.Order_Entered_By__c = 'Harikishore';
            cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
            cas.Description = 'Test cases';
            cas.subject='test case';
            insert cas;
            
            Platform__c p = new Platform__c();
            p.Platform__c ='Test platform please ignore';
            p.APU_Maker__c = 'Honeywell';
          p.Engine_Maker__c = 'Honeywell';
            insert p;
            
        Fleet_Asset_Detail__c fad = new Fleet_Asset_Detail__c();
            fad.Case_Associated__c = cas.Id;
            fad.New_Alert_Identification__c = true;
            fad.Platform_Name__c =p.id;
            fad.Serial_Number__c = 'test 123';
            fad.Status__c = 'In Service';
            
            insert fad;
        
         Fleet_Asset_Detail__c fad1 = new Fleet_Asset_Detail__c();
            fad1.Case_Associated__c = cas.Id;
            fad1.New_Alert_Identification__c = true;
            fad1.Platform_Name__c =p.id;
            fad1.Serial_Number__c = 'test 123';
            fad1.Status__c = 'In Service';
            
            insert fad1;
            
             Fleet_Asset_Detail__c fad2 = new Fleet_Asset_Detail__c();
            fad2.Case_Associated__c = cas.Id;
            fad2.New_Alert_Identification__c = true;
            fad2.Platform_Name__c =p.id;
            fad2.Serial_Number__c = 'test 123';
            fad2.Status__c = 'In Service';
            
            insert fad2;
            
             Fleet_Asset_Detail__c fad3 = new Fleet_Asset_Detail__c();
            fad3.Case_Associated__c = cas.Id;
            fad3.New_Alert_Identification__c = true;
            fad3.Platform_Name__c =p.id;
            fad3.Serial_Number__c = 'test 123';
            fad3.Status__c = 'In Service';
            
            insert fad3;
            
            
        Account_Eligible_RMU_Fleet_Asset__c aerfa = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa.Account_Eligible_RMU__c = aer.id;
        aerfa.Account__c = acct.Id;
        aerfa.RMU_Platform__c = rmu.id;
        aerfa.AER_Update__c = false;
        aerfa.Aircraft_Count__c=10;
        aerfa.RMU__c = rmuvalue.id;
        aerfa.Aircraft_Installed_Count__c=8; 
        aerfa.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa.RMU_Flyaway_Work_Ext__c = 0.0;  
        aerfa.Aircraft__c = fad.id; 
        insert aerfa;
        
        Account_Eligible_RMU_Fleet_Asset__c aerfa1 = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa1.Account_Eligible_RMU__c = aer.id;
        aerfa1.Account__c = acct.Id;
        aerfa1.RMU_Platform__c = rmu.id;
        aerfa1.AER_Update__c = false;
        aerfa1.Aircraft_Count__c=10;
        aerfa1.RMU__c = rmuvalue1.id;
        aerfa1.Aircraft_Installed_Count__c=8; 
        aerfa1.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa1.RMU_Flyaway_Work_Ext__c = 0.0;  
        aerfa1.Aircraft__c = fad.id; 
        insert aerfa1;
        
        
        Account_Eligible_RMU_Fleet_Asset__c aerfa2 = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa2.Account_Eligible_RMU__c = aer.id;
        aerfa2.Account__c = acct.Id;
        aerfa2.RMU_Platform__c = rmu.id;
        aerfa2.AER_Update__c = false;
        aerfa2.Aircraft_Count__c=10;
        aerfa2.RMU__c = rmuvalue2.id;
        aerfa2.Aircraft_Installed_Count__c=8; 
        aerfa2.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa2.RMU_Flyaway_Work_Ext__c = 0.0;  
        aerfa2.Aircraft__c = fad.id; 
        insert aerfa2;
        
        Account_Eligible_RMU_Fleet_Asset__c aerfa3 = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa3.Account_Eligible_RMU__c = aer.id;
        aerfa3.Account__c = acct.Id;
        aerfa3.RMU_Platform__c = rmu.id;
        aerfa3.AER_Update__c = false;
        aerfa3.Aircraft_Count__c=10;
        aerfa3.RMU__c = rmuvalue3.id;
        aerfa3.Aircraft_Installed_Count__c=8; 
        aerfa3.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa3.RMU_Flyaway_Work_Ext__c = 0.0;  
        aerfa3.Aircraft__c = fad.id; 
        insert aerfa3;
        
        
        
        Contract cnt = new Contract();
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt.AccountId = acct.id;
            cnt.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt.Renewal_Start_date__c = System.today();
            cnt.Renewal_Account_Name_Dealer__c = acct.id;
            cnt.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt.Renewal_Customer__c = acct.id;
            cnt.Renewal_Notes__c = 'Test Note';        
            cnt.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt.Status = 'Pending Activation';
            cnt.Type__c = 'HAPP/MPP';
            cnt.StartDate = date.newinstance(2009, 1, 7);
            cnt.Enddate = system.today().addDays(30);
            cnt.Name = '1234';
            insert cnt;
            
            
            Contract cnt1 = new Contract();
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt1.AccountId = acct.id;
            cnt1.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt1.Renewal_Start_date__c = System.today();
            cnt1.Renewal_Account_Name_Dealer__c = acct.id;
            cnt1.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt1.Renewal_Customer__c = acct.id;
            cnt1.Renewal_Notes__c = 'Test Note';        
            cnt1.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt1.Status = 'Pending Activation';
            cnt1.Type__c = 'HAPP/MPP';
            cnt1.StartDate = date.newinstance(2009, 1, 7);
            cnt1.Enddate = system.today().addDays(30);
            cnt1.Name = '12345';
            insert cnt1;
            
            Contract cnt2 = new Contract();
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt2.AccountId = acct.id;
            cnt2.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt2.Renewal_Start_date__c = System.today();
            cnt2.Renewal_Account_Name_Dealer__c = acct.id;
            cnt2.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt2.Renewal_Customer__c = acct.id;
            cnt2.Renewal_Notes__c = 'Test Note';        
            cnt2.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt2.Status = 'Pending Activation';
            cnt2.Type__c = 'HAPP/MPP';
            cnt2.StartDate = date.newinstance(2009, 1, 7);
            cnt2.Enddate = system.today().addDays(30);
            cnt2.Name = '123456';
            insert cnt2;
            
            Contract cnt3 = new Contract();
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt3.AccountId = acct.id;
            cnt3.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt3.Renewal_Start_date__c = System.today();
            cnt3.Renewal_Account_Name_Dealer__c = acct.id;
            cnt3.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt3.Renewal_Customer__c = acct.id;
            cnt3.Renewal_Notes__c = 'Test Note';        
            cnt3.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt3.Status = 'Pending Activation';
            cnt3.Type__c = 'HAPP/MPP';
            cnt3.StartDate = date.newinstance(2009, 1, 7);
            cnt3.Enddate = system.today().addDays(30);
            cnt3.Name = '1234567';
            insert cnt3;
        RMU_Sales__c sales = new RMU_Sales__c();
        sales.Aircraft__c = fad.id;
        sales.RMU__c = rmuvalue.id;
        sales.Order_Number__c = 'Cnt-'+cnt.Name;
        insert sales;
        
        
        sales = new RMU_Sales__c();
        sales.Aircraft__c = fad.id;
        sales.RMU__c = rmuvalue1.id;
        sales.Order_Number__c = 'Cnt-'+cnt.Name;
        insert sales;
        
        sales = new RMU_Sales__c();
        sales.Aircraft__c = fad.id;
        sales.RMU__c = rmuvalue2.id;
        sales.Order_Number__c = 'Cnt-'+cnt.Name;
        insert sales;
        
        sales = new RMU_Sales__c();
        sales.Aircraft__c = fad.id;
        sales.RMU__c = rmuvalue3.id;
        sales.Order_Number__c = 'Cnt-'+cnt.Name;
        insert sales;
        
        Account_Eligible_RMU_Fleet_Asset__c  aerfact = [select RMU_Flyaway_Extended_Price__c,RMU_Flyaway_Work_Ext__c
                            from Account_Eligible_RMU_Fleet_Asset__c where id =:aerfa.id];
        system.debug('aerfa value:'+aerfact);
        system.debug('RMU_Product_Ratio__c value:'+aerfa.RMU_Product_Ratio__c);
        system.debug('RMU_Dealer_Price__c value:'+aerfa.RMU_Dealer_Price__c);
        system.debug('Aircraft_Open_Count__c value:'+aerfa.Aircraft_Open_Count__c);        
        system.debug('RMU_Dealer_Extended_Price__c value:'+aerfa.RMU_Dealer_Extended_Price__c);
        Id batch = Database.executeBatch(new BatchAERUpdate(),10);
        
        Test.StartTest();
        CreateTaskForMSPAPUEngineOfferings sh1 = new CreateTaskForMSPAPUEngineOfferings();
        Database.executeBatch(new CreateTaskForMSPAPUEngineOfferings());
        
    }
    
    static testMethod void testBatchClass4(){
        Account acct = new Account();
        acct.type = 'Dealer';
        acct.Name = 'Test Account';
        insert acct;
        
        RMU_VALUE__c rmuvalue = new RMU_VALUE__c(name='MSP APU');
        insert rmuvalue;
        
        RMU_VALUE__c rmuvalue1 = new RMU_VALUE__c(name='MSP APU (Gold)');
        insert rmuvalue1;
        
        RMU_VALUE__c rmuvalue2 = new RMU_VALUE__c(name='MSP APU');
        insert rmuvalue2;
        
        RMU_VALUE__c rmuvalue3 = new RMU_VALUE__c(name='MSP APU (Gold)');
        insert rmuvalue3;
        
        
        
        OFFERING_MAPPER__c rmu = new OFFERING_MAPPER__c(name='Test RMU');
        rmu.RMU_VALUE__c = rmuvalue.id;
        rmu.RMU_Platform_Product_Ratio__c = 10.00;
        rmu.RMU_DEALER_PRC__c = 5.0;
        insert rmu;
        
        
        Account_Eligible_RMU__c aer= new Account_Eligible_RMU__c();
        /* Commenting the below line as part of CRQ000000163236, in the production Account_Eligible_RMU__c object we dont have 
           RMU_Platform__c field.Hence this test class is getting failed during deployment.
           Note:- This test class will fail in UAT till we get the refresh from Production.
        */
        //aer.RMU_Platform__c = rmu.id;
        insert aer;
        
    
         Case cas = new Case();
            cas.Origin = 'web';
            cas.Status = 'Open';  
            cas.OwnerId = Label.CSO_R_O_Team;
            //cas.ContactId = objContact.Id;
            cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
            cas.Classification__c = 'CSO Repair Order';
            //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
            cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
            cas.Government_Compliance_SM_M_Content__c = 'No';
            cas.Sales_Order_Number__c = '12345678';
            //cas.Order_Entered_By__c = 'Harikishore';
            cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
            cas.Description = 'Test cases';
            cas.subject='test case';
            insert cas;
            
            Platform__c p = new Platform__c();
            p.Platform__c ='Test platform please ignore';
            p.APU_Maker__c = 'Honeywell';
          p.Engine_Maker__c = 'Honeywell';
            insert p;
            
        Fleet_Asset_Detail__c fad = new Fleet_Asset_Detail__c();
            fad.Case_Associated__c = cas.Id;
            fad.New_Alert_Identification__c = true;
            fad.Platform_Name__c =p.id;
            fad.Serial_Number__c = 'test 123';
            fad.Status__c = 'In Service';
            
            insert fad;
        
         Fleet_Asset_Detail__c fad1 = new Fleet_Asset_Detail__c();
            fad1.Case_Associated__c = cas.Id;
            fad1.New_Alert_Identification__c = true;
            fad1.Platform_Name__c =p.id;
            fad1.Serial_Number__c = 'test 123';
            fad1.Status__c = 'In Service';
            
            insert fad1;
            
             Fleet_Asset_Detail__c fad2 = new Fleet_Asset_Detail__c();
            fad2.Case_Associated__c = cas.Id;
            fad2.New_Alert_Identification__c = true;
            fad2.Platform_Name__c =p.id;
            fad2.Serial_Number__c = 'test 123';
            fad2.Status__c = 'In Service';
            
            insert fad2;
            
             Fleet_Asset_Detail__c fad3 = new Fleet_Asset_Detail__c();
            fad3.Case_Associated__c = cas.Id;
            fad3.New_Alert_Identification__c = true;
            fad3.Platform_Name__c =p.id;
            fad3.Serial_Number__c = 'test 123';
            fad3.Status__c = 'In Service';
            
            insert fad3;
            
            
        Account_Eligible_RMU_Fleet_Asset__c aerfa = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa.Account_Eligible_RMU__c = aer.id;
        aerfa.Account__c = acct.Id;
        aerfa.RMU_Platform__c = rmu.id;
        aerfa.AER_Update__c = false;
        aerfa.Aircraft_Count__c=10;
        aerfa.RMU__c = rmuvalue.id;
        aerfa.Aircraft_Installed_Count__c=0; 
        aerfa.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa.RMU_Flyaway_Work_Ext__c = 0.0;  
        aerfa.Aircraft__c = fad.id; 
        insert aerfa;
        
        Account_Eligible_RMU_Fleet_Asset__c aerfa1 = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa1.Account_Eligible_RMU__c = aer.id;
        aerfa1.Account__c = acct.Id;
        aerfa1.RMU_Platform__c = rmu.id;
        aerfa1.AER_Update__c = false;
        aerfa1.Aircraft_Count__c=10;
        aerfa1.RMU__c = rmuvalue1.id;
        aerfa1.Aircraft_Installed_Count__c=0; 
        aerfa1.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa1.RMU_Flyaway_Work_Ext__c = 0.0;  
        aerfa1.Aircraft__c = fad.id; 
        insert aerfa1;
        
        
        Account_Eligible_RMU_Fleet_Asset__c aerfa2 = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa2.Account_Eligible_RMU__c = aer.id;
        aerfa2.Account__c = acct.Id;
        aerfa2.RMU_Platform__c = rmu.id;
        aerfa2.AER_Update__c = false;
        aerfa2.Aircraft_Count__c=10;
        aerfa2.RMU__c = rmuvalue2.id;
        aerfa2.Aircraft_Installed_Count__c=0; 
        aerfa2.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa2.RMU_Flyaway_Work_Ext__c = 0.0;  
        aerfa2.Aircraft__c = fad1.id; 
        insert aerfa2;
        
        Account_Eligible_RMU_Fleet_Asset__c aerfa3 = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa3.Account_Eligible_RMU__c = aer.id;
        aerfa3.Account__c = acct.Id;
        aerfa3.RMU_Platform__c = rmu.id;
        aerfa3.AER_Update__c = false;
        aerfa3.Aircraft_Count__c=10;
        aerfa3.RMU__c = rmuvalue3.id;
        aerfa3.Aircraft_Installed_Count__c=0; 
        aerfa3.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa3.RMU_Flyaway_Work_Ext__c = 0.0;  
        aerfa3.Aircraft__c = fad1.id; 
        insert aerfa3;
        
        
        
        Contract cnt = new Contract();
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt.AccountId = acct.id;
            cnt.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt.Renewal_Start_date__c = System.today();
            cnt.Renewal_Account_Name_Dealer__c = acct.id;
            cnt.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt.Renewal_Customer__c = acct.id;
            cnt.Renewal_Notes__c = 'Test Note';        
            cnt.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt.Status = 'Pending Activation';
            cnt.Type__c = 'HAPP/MPP';
            cnt.StartDate = date.newinstance(2009, 1, 7);
            cnt.Enddate = system.today().addDays(30);
            cnt.Name = '1234';
            insert cnt;
            
            
            Contract cnt1 = new Contract();
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt1.AccountId = acct.id;
            cnt1.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt1.Renewal_Start_date__c = System.today();
            cnt1.Renewal_Account_Name_Dealer__c = acct.id;
            cnt1.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt1.Renewal_Customer__c = acct.id;
            cnt1.Renewal_Notes__c = 'Test Note';        
            cnt1.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt1.Status = 'Pending Activation';
            cnt1.Type__c = 'HAPP/MPP';
            cnt1.StartDate = date.newinstance(2009, 1, 7);
            cnt1.Enddate = system.today().addDays(30);
            cnt1.Name = '12345';
            insert cnt1;
            
            Contract cnt2 = new Contract();
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt2.AccountId = acct.id;
            cnt2.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt2.Renewal_Start_date__c = System.today();
            cnt2.Renewal_Account_Name_Dealer__c = acct.id;
            cnt2.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt2.Renewal_Customer__c = acct.id;
            cnt2.Renewal_Notes__c = 'Test Note';        
            cnt2.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt2.Status = 'Pending Activation';
            cnt2.Type__c = 'HAPP/MPP';
            cnt2.StartDate = date.newinstance(2009, 1, 7);
            cnt2.Enddate = system.today().addDays(30);
            cnt2.Name = '123456';
            insert cnt2;
            
            Contract cnt3 = new Contract();
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt3.AccountId = acct.id;
            cnt3.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt3.Renewal_Start_date__c = System.today();
            cnt3.Renewal_Account_Name_Dealer__c = acct.id;
            cnt3.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt3.Renewal_Customer__c = acct.id;
            cnt3.Renewal_Notes__c = 'Test Note';        
            cnt3.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt3.Status = 'Pending Activation';
            cnt3.Type__c = 'HAPP/MPP';
            cnt3.StartDate = date.newinstance(2009, 1, 7);
            cnt3.Enddate = system.today().addDays(30);
            cnt3.Name = '1234567';
            insert cnt3;
        RMU_Sales__c sales = new RMU_Sales__c();
        sales.Aircraft__c = fad.id;
        sales.RMU__c = rmuvalue.id;
        sales.Order_Number__c = 'Cnt-'+cnt.Name;
        insert sales;
        
        
        sales = new RMU_Sales__c();
        sales.Aircraft__c = fad.id;
        sales.RMU__c = rmuvalue1.id;
        sales.Order_Number__c = 'Cnt-'+cnt.Name;
        insert sales;
        
        sales = new RMU_Sales__c();
        sales.Aircraft__c = fad.id;
        sales.RMU__c = rmuvalue2.id;
        sales.Order_Number__c = 'Cnt-'+cnt1.Name;
        insert sales;
        
        sales = new RMU_Sales__c();
        sales.Aircraft__c = fad.id;
        sales.RMU__c = rmuvalue3.id;
        sales.Order_Number__c = 'Cnt-'+cnt1.Name;
        insert sales;
        
        Account_Eligible_RMU_Fleet_Asset__c  aerfact = [select RMU_Flyaway_Extended_Price__c,RMU_Flyaway_Work_Ext__c
                            from Account_Eligible_RMU_Fleet_Asset__c where id =:aerfa.id];
        system.debug('aerfa value:'+aerfact);
        system.debug('RMU_Product_Ratio__c value:'+aerfa.RMU_Product_Ratio__c);
        system.debug('RMU_Dealer_Price__c value:'+aerfa.RMU_Dealer_Price__c);
        system.debug('Aircraft_Open_Count__c value:'+aerfa.Aircraft_Open_Count__c);        
        system.debug('RMU_Dealer_Extended_Price__c value:'+aerfa.RMU_Dealer_Extended_Price__c);
        Id batch = Database.executeBatch(new BatchAERUpdate(),10);
        
        Test.StartTest();
        CreateTaskForMSPAPUEngineOfferings sh1 = new CreateTaskForMSPAPUEngineOfferings();
        Database.executeBatch(new CreateTaskForMSPAPUEngineOfferings());
        
    }
    
        static testMethod void testBatchClass5(){
        Account acct = new Account();
        acct.type = 'Dealer';
        acct.Name = 'Test Account';
        insert acct;
        
        RMU_VALUE__c rmuvalue = new RMU_VALUE__c(name='MSP Engines');
        insert rmuvalue;
        
        RMU_VALUE__c rmuvalue1 = new RMU_VALUE__c(name='MSP Engines (Gold)');
        insert rmuvalue1;
        
        RMU_VALUE__c rmuvalue2 = new RMU_VALUE__c(name='MSP Engines');
        insert rmuvalue2;
        
        RMU_VALUE__c rmuvalue3 = new RMU_VALUE__c(name='MSP Engines (Gold)');
        insert rmuvalue3;
        
        
        
        OFFERING_MAPPER__c rmu = new OFFERING_MAPPER__c(name='Test RMU');
        rmu.RMU_VALUE__c = rmuvalue.id;
        rmu.RMU_Platform_Product_Ratio__c = 10.00;
        rmu.RMU_DEALER_PRC__c = 5.0;
        insert rmu;
        
        
        Account_Eligible_RMU__c aer= new Account_Eligible_RMU__c();
        /* Commenting the below line as part of CRQ000000163236, in the production Account_Eligible_RMU__c object we dont have 
           RMU_Platform__c field.Hence this test class is getting failed during deployment.
           Note:- This test class will fail in UAT till we get the refresh from Production.
        */
        //aer.RMU_Platform__c = rmu.id;
        insert aer;
        
    
         Case cas = new Case();
            cas.Origin = 'web';
            cas.Status = 'Open';  
            cas.OwnerId = Label.CSO_R_O_Team;
            //cas.ContactId = objContact.Id;
            cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
            cas.Classification__c = 'CSO Repair Order';
            //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
            cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
            cas.Government_Compliance_SM_M_Content__c = 'No';
            cas.Sales_Order_Number__c = '12345678';
            //cas.Order_Entered_By__c = 'Harikishore';
            cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
            cas.Description = 'Test cases';
            cas.subject='test case';
            insert cas;
            
            Platform__c p = new Platform__c();
            p.Platform__c ='Test platform please ignore';
            p.APU_Maker__c = 'Honeywell';
            p.Engine_Maker__c = 'Honeywell';
            insert p;
            
        Fleet_Asset_Detail__c fad = new Fleet_Asset_Detail__c();
            fad.Case_Associated__c = cas.Id;
            fad.New_Alert_Identification__c = true;
            fad.Platform_Name__c =p.id;
            fad.Serial_Number__c = 'test 123';
            fad.Status__c = 'In Service';
            
            insert fad;
        
         Fleet_Asset_Detail__c fad1 = new Fleet_Asset_Detail__c();
            fad1.Case_Associated__c = cas.Id;
            fad1.New_Alert_Identification__c = true;
            fad1.Platform_Name__c =p.id;
            fad1.Serial_Number__c = 'test 123';
            fad1.Status__c = 'In Service';
            
            insert fad1;
            
             Fleet_Asset_Detail__c fad2 = new Fleet_Asset_Detail__c();
            fad2.Case_Associated__c = cas.Id;
            fad2.New_Alert_Identification__c = true;
            fad2.Platform_Name__c =p.id;
            fad2.Serial_Number__c = 'test 123';
            fad2.Status__c = 'In Service';
            
            insert fad2;
            
             Fleet_Asset_Detail__c fad3 = new Fleet_Asset_Detail__c();
            fad3.Case_Associated__c = cas.Id;
            fad3.New_Alert_Identification__c = true;
            fad3.Platform_Name__c =p.id;
            fad3.Serial_Number__c = 'test 123';
            fad3.Status__c = 'In Service';
            
            insert fad3;
            
            
        Account_Eligible_RMU_Fleet_Asset__c aerfa = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa.Account_Eligible_RMU__c = aer.id;
        aerfa.Account__c = acct.Id;
        aerfa.RMU_Platform__c = rmu.id;
        aerfa.AER_Update__c = false;
        aerfa.Aircraft_Count__c=10;
        aerfa.RMU__c = rmuvalue.id;
        aerfa.Aircraft_Installed_Count__c=0; 
        aerfa.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa.RMU_Flyaway_Work_Ext__c = 0.0;  
        aerfa.Aircraft__c = fad.id; 
        insert aerfa;
        
        Account_Eligible_RMU_Fleet_Asset__c aerfa1 = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa1.Account_Eligible_RMU__c = aer.id;
        aerfa1.Account__c = acct.Id;
        aerfa1.RMU_Platform__c = rmu.id;
        aerfa1.AER_Update__c = false;
        aerfa1.Aircraft_Count__c=10;
        aerfa1.RMU__c = rmuvalue1.id;
        aerfa1.Aircraft_Installed_Count__c=0; 
        aerfa1.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa1.RMU_Flyaway_Work_Ext__c = 0.0;  
        aerfa1.Aircraft__c = fad.id; 
        insert aerfa1;
        
        
        Account_Eligible_RMU_Fleet_Asset__c aerfa2 = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa2.Account_Eligible_RMU__c = aer.id;
        aerfa2.Account__c = acct.Id;
        aerfa2.RMU_Platform__c = rmu.id;
        aerfa2.AER_Update__c = false;
        aerfa2.Aircraft_Count__c=10;
        aerfa2.RMU__c = rmuvalue2.id;
        aerfa2.Aircraft_Installed_Count__c=0; 
        aerfa2.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa2.RMU_Flyaway_Work_Ext__c = 0.0;  
        aerfa2.Aircraft__c = fad.id; 
        insert aerfa2;
        
        Account_Eligible_RMU_Fleet_Asset__c aerfa3 = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa3.Account_Eligible_RMU__c = aer.id;
        aerfa3.Account__c = acct.Id;
        aerfa3.RMU_Platform__c = rmu.id;
        aerfa3.AER_Update__c = false;
        aerfa3.Aircraft_Count__c=10;
        aerfa3.RMU__c = rmuvalue3.id;
        aerfa3.Aircraft_Installed_Count__c=0; 
        aerfa3.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa3.RMU_Flyaway_Work_Ext__c = 0.0;  
        aerfa3.Aircraft__c = fad.id; 
        insert aerfa3;
        
        
        
        Contract cnt = new Contract();
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt.AccountId = acct.id;
            cnt.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt.Renewal_Start_date__c = System.today();
            cnt.Renewal_Account_Name_Dealer__c = acct.id;
            cnt.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt.Renewal_Customer__c = acct.id;
            cnt.Renewal_Notes__c = 'Test Note';        
            cnt.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt.Status = 'Pending Activation';
            cnt.Type__c = 'HAPP/MPP';
            cnt.StartDate = date.newinstance(2009, 1, 7);
            cnt.Enddate = system.today().addDays(30);
            cnt.Name = '1234';
            insert cnt;
            
            
            Contract cnt1 = new Contract();
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt1.AccountId = acct.id;
            cnt1.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt1.Renewal_Start_date__c = System.today();
            cnt1.Renewal_Account_Name_Dealer__c = acct.id;
            cnt1.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt1.Renewal_Customer__c = acct.id;
            cnt1.Renewal_Notes__c = 'Test Note';        
            cnt1.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt1.Status = 'Pending Activation';
            cnt1.Type__c = 'HAPP/MPP';
            cnt1.StartDate = date.newinstance(2009, 1, 7);
            cnt1.Enddate = system.today().addDays(30);
            cnt1.Name = '12345';
            insert cnt1;
            
            Contract cnt2 = new Contract();
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt2.AccountId = acct.id;
            cnt2.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt2.Renewal_Start_date__c = System.today();
            cnt2.Renewal_Account_Name_Dealer__c = acct.id;
            cnt2.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt2.Renewal_Customer__c = acct.id;
            cnt2.Renewal_Notes__c = 'Test Note';        
            cnt2.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt2.Status = 'Pending Activation';
            cnt2.Type__c = 'HAPP/MPP';
            cnt2.StartDate = date.newinstance(2009, 1, 7);
            cnt2.Enddate = system.today().addDays(30);
            cnt2.Name = '123456';
            insert cnt2;
            
            Contract cnt3 = new Contract();
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt3.AccountId = acct.id;
            cnt3.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt3.Renewal_Start_date__c = System.today();
            cnt3.Renewal_Account_Name_Dealer__c = acct.id;
            cnt3.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt3.Renewal_Customer__c = acct.id;
            cnt3.Renewal_Notes__c = 'Test Note';        
            cnt3.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt3.Status = 'Pending Activation';
            cnt3.Type__c = 'HAPP/MPP';
            cnt3.StartDate = date.newinstance(2009, 1, 7);
            cnt3.Enddate = system.today().addDays(30);
            cnt3.Name = '1234567';
            insert cnt3;
        RMU_Sales__c sales = new RMU_Sales__c();
        sales.Aircraft__c = fad.id;
        sales.RMU__c = rmuvalue.id;
        sales.Order_Number__c = 'Cnt-'+cnt.Name;
        insert sales;
        
        
        sales = new RMU_Sales__c();
        sales.Aircraft__c = fad.id;
        sales.RMU__c = rmuvalue1.id;
        sales.Order_Number__c = 'Cnt-'+cnt.Name;
        insert sales;
        
        sales = new RMU_Sales__c();
        sales.Aircraft__c = fad.id;
        sales.RMU__c = rmuvalue2.id;
        sales.Order_Number__c = 'Cnt-'+cnt.Name;
        insert sales;
        
        sales = new RMU_Sales__c();
        sales.Aircraft__c = fad.id;
        sales.RMU__c = rmuvalue3.id;
        sales.Order_Number__c = 'Cnt-'+cnt.Name;
        insert sales;
        
        Account_Eligible_RMU_Fleet_Asset__c  aerfact = [select RMU_Flyaway_Extended_Price__c,RMU_Flyaway_Work_Ext__c
                            from Account_Eligible_RMU_Fleet_Asset__c where id =:aerfa.id];
        system.debug('aerfa value:'+aerfact);
        system.debug('RMU_Product_Ratio__c value:'+aerfa.RMU_Product_Ratio__c);
        system.debug('RMU_Dealer_Price__c value:'+aerfa.RMU_Dealer_Price__c);
        system.debug('Aircraft_Open_Count__c value:'+aerfa.Aircraft_Open_Count__c);        
        system.debug('RMU_Dealer_Extended_Price__c value:'+aerfa.RMU_Dealer_Extended_Price__c);
        Id batch = Database.executeBatch(new BatchAERUpdate(),10);
        
        Test.StartTest();
        CreateTaskForMSPAPUEngineOfferings sh1 = new CreateTaskForMSPAPUEngineOfferings();
        Database.executeBatch(new CreateTaskForMSPAPUEngineOfferings());
        
    }
    static testMethod void testScheduleJob(){
         Test.StartTest();
         CreateTaskForMSPAPUEngineOfferings sh1 = new CreateTaskForMSPAPUEngineOfferings();      
         String sch = '0  00 1 3 * ?';
         system.schedule('Test', sch, sh1);
        Test.stopTest();
    }
}