/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : TestClass_SPEXClasses
* Description           : Test Class to test the functionality of the SPEX related APEX classes and Triggers.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 06-Sep-2012      0.01           NTTData               Initial Version

***********************************************************************************************************/
@isTest
private class TestClass_SPEXClasses 
{
    
    static testMethod void TestMthd_SPEXClasses()
    {
        SPEX_DB_Part_Summary__c objPartSummary = new SPEX_DB_Part_Summary__c();
        List<SPEX_DB_Part_Summary__c> lstPartSummary = new List<SPEX_DB_Part_Summary__c>();
        
            for(Integer i=0; i<=4; i++)
        {
            objPartSummary = new SPEX_DB_Part_Summary__c();
            objPartSummary.Part_Number__c = 'PT'+i;
            objPartSummary.Part_description__c = 'Part Desc';            
            objPartSummary.Stock_By_Americas__c = i*10;
            objPartSummary.Stock_By_APAC__c = i*100;
            objPartSummary.Stock_By_EMEA__c = i;
            objPartSummary.Demand_By_Americas__c = i*20;
            objPartSummary.Demand_By_APAC__c = i*10;
            objPartSummary.Demand_By_EMEA__c = i;
            lstPartSummary.add(objPartSummary);
        }
        
        insert lstPartSummary;
        
        lstPartSummary = [select id from SPEX_DB_Part_Summary__c where part_number__c = 'PT1' or part_number__c = 'PT2' Limit 10];
                
        if(lstPartSummary.size() > 1)
        {        
        SPEX_DB_Platform_Summary__c objPlatformSummary = new SPEX_DB_Platform_Summary__c();
        List<SPEX_DB_Platform_Summary__c> lstPlatformSummary = new List<SPEX_DB_Platform_Summary__c>();
        
            objPlatformSummary.Part_Number__c = lstPartSummary[0].id;
            objPlatformSummary.Platform__c = 'F7x1';
            objPlatformSummary.OEM_Name__c = 'Dassault1';
            objPlatformSummary.Demand_By_Americas__c = 1;
            objPlatformSummary.Demand_By_APAC__c = 2;
            objPlatformSummary.Demand_By_EMEA__c = 3;
            
            insert objPlatformSummary;            
            
            lstPartSummary[0].Min_Stock_Americas__c = 1;
            lstPartSummary[0].Min_Stock_APAC__c = 1;
            lstPartSummary[0].Min_Stock_EMEA__c = 1;
            update lstPartSummary;
            
            objPlatformSummary = new SPEX_DB_Platform_Summary__c();
            
            objPlatformSummary.Part_Number__c = lstPartSummary[1].id;
            objPlatformSummary.Platform__c = 'Falcon 20001';
            objPlatformSummary.OEM_Name__c = 'Dassault1';
            objPlatformSummary.Demand_By_Americas__c = 100;
            objPlatformSummary.Demand_By_APAC__c = 200;
            objPlatformSummary.Demand_By_EMEA__c = 300;
            
            insert objPlatformSummary;
            
            objPlatformSummary.Part_Number__c = lstPartSummary[0].id;
            update objPlatformSummary;
            
            objPlatformSummary = new SPEX_DB_Platform_Summary__c();
            
            objPlatformSummary.Part_Number__c = lstPartSummary[1].id;
            objPlatformSummary.Platform__c = 'Falcon 20001';
            objPlatformSummary.OEM_Name__c = 'Dassault1';
            objPlatformSummary.Demand_By_Americas__c = 100;
            objPlatformSummary.Demand_By_APAC__c = 200;
            objPlatformSummary.Demand_By_EMEA__c = 300;
            
            insert objPlatformSummary;
            
            objPartSummary = new SPEX_DB_Part_Summary__c();
            objPartSummary.Part_Number__c = 'StockOutPart';
            objPartSummary.Stock_By_Americas__c = 10;
            objPartSummary.Stock_By_APAC__c = 10;
            objPartSummary.Stock_By_EMEA__c = 10;
            objPartSummary.Demand_By_Americas__c = 20;
            objPartSummary.Demand_By_APAC__c = 20;
            objPartSummary.Demand_By_EMEA__c = 20;
            objPartSummary.Min_Stock_Americas__c = 1;
            objPartSummary.Min_Stock_APAC__c = 1;
            objPartSummary.Min_Stock_EMEA__c = 1;
            
            insert objPartSummary;
            
            objPlatformSummary = new SPEX_DB_Platform_Summary__c();            
            objPlatformSummary.Part_Number__c = objPartSummary.ID;
            objPlatformSummary.Platform__c = 'F7X1';
            objPlatformSummary.OEM_Name__c = 'Dassault1';
            objPlatformSummary.Demand_By_Americas__c = 0;
            objPlatformSummary.Demand_By_APAC__c = 0;
            objPlatformSummary.Demand_By_EMEA__c = 0;
            
            insert objPlatformSummary;
            
            objPlatformSummary = new SPEX_DB_Platform_Summary__c();
            
            objPlatformSummary.Part_Number__c = objPartSummary.ID;
            objPlatformSummary.Platform__c = 'Falcon 900';
            objPlatformSummary.OEM_Name__c = 'Dassault1';
            objPlatformSummary.Demand_By_Americas__c = 100;
            objPlatformSummary.Demand_By_APAC__c = 200;
            objPlatformSummary.Demand_By_EMEA__c = 300;
            
            insert objPlatformSummary;
            
            objPartSummary = new SPEX_DB_Part_Summary__c();
            objPartSummary.Part_Number__c = 'AtRiskPart';
            objPartSummary.Part_description__c = 'Part Desc';            
            objPartSummary.Stock_By_Americas__c = 1;
            objPartSummary.Stock_By_APAC__c = 1;
            objPartSummary.Stock_By_EMEA__c = 1;
            objPartSummary.Demand_By_Americas__c = 1;
            objPartSummary.Demand_By_APAC__c = 1;
            objPartSummary.Demand_By_EMEA__c = 1;
            objPartSummary.Min_Stock_APAC__c = 1;
            objPartSummary.Min_Stock_EMEA__c = 1;
            objPartSummary.Min_Stock_Americas__c = 1;
            
            insert objPartSummary;
            
            objPlatformSummary = new SPEX_DB_Platform_Summary__c();
            
            objPlatformSummary.Part_Number__c = objPartSummary.ID;
            objPlatformSummary.Platform__c = 'Falcon 9001';
            objPlatformSummary.OEM_Name__c = 'RiskOEM';
            objPlatformSummary.Demand_By_Americas__c = 0;
            objPlatformSummary.Demand_By_APAC__c = 0;
            objPlatformSummary.Demand_By_EMEA__c = 0;
            
            insert objPlatformSummary;
            
            lstPartSummary  = [select id from SPEX_DB_Part_Summary__c where part_number__c = 'AtRiskPart' Limit 10];
            
            if(lstPartSummary!=null & lstPartSummary.size() > 0)
            {   
                objPlatformSummary = new SPEX_DB_Platform_Summary__c();                
                objPlatformSummary.Part_Number__c = objPartSummary.ID;
                objPlatformSummary.Platform__c = 'Falcon 90012';
                objPlatformSummary.OEM_Name__c = 'RiskOEM2';
                objPlatformSummary.Demand_By_Americas__c = 1;
                objPlatformSummary.Demand_By_APAC__c = 1;
                objPlatformSummary.Demand_By_EMEA__c = 1;                        
                insert objPlatformSummary;
            }
                  
            objPartSummary = new SPEX_DB_Part_Summary__c();
            objPartSummary.Part_Number__c = 'SafePart';
            objPartSummary.Stock_By_Americas__c = 2;
            objPartSummary.Stock_By_APAC__c = 2;
            objPartSummary.Stock_By_EMEA__c = 2;
            objPartSummary.Demand_By_Americas__c = 1;
            objPartSummary.Demand_By_APAC__c = 1;
            objPartSummary.Demand_By_EMEA__c = 1;
            
            insert objPartSummary;
            
            objPlatformSummary = new SPEX_DB_Platform_Summary__c();            
            objPlatformSummary.Part_Number__c = objPartSummary.ID;
            objPlatformSummary.Platform__c = 'Falcon 9001';
            objPlatformSummary.OEM_Name__c = 'RiskOEM';
            objPlatformSummary.Demand_By_Americas__c = 1;
            objPlatformSummary.Demand_By_APAC__c = 1;
            objPlatformSummary.Demand_By_EMEA__c = 1;
            
            insert objPlatformSummary;            
            
       }
             
        
        SPEX_DB_Home_cls objSPEX_DB_Home_cls = new SPEX_DB_Home_cls();
        System.assertNotEquals(objSPEX_DB_Home_cls , null);
        
        Map<string,String> mpStatus;
        mpStatus = objSPEX_DB_Home_cls.MpStatus;
        System.assertNotEquals(mpStatus, null);
        
        SPEX_DB_CriticalParts_cls objSPEX_DB_CriticalParts_cls = new SPEX_DB_CriticalParts_cls();
        System.assertNotEquals(objSPEX_DB_CriticalParts_cls, null);
        
        SPEX_DB_OEM_Sel_cls objSPEX_DB_OEM_Sel_cls = new SPEX_DB_OEM_Sel_cls();
        System.assertNotEquals(objSPEX_DB_OEM_Sel_cls, null);
        
        SPEX_DB_Selection_cls objSPEX_DB_Selection_cls = new SPEX_DB_Selection_cls();
        System.assertNotEquals(objSPEX_DB_Selection_cls, null);
        
        SPEX_Inv_Platform_Detail_cls objSPEX_Inv_Platform_Detail_cls = new SPEX_Inv_Platform_Detail_cls('Dassault1','F7X1');
        System.assertNotEquals(objSPEX_Inv_Platform_Detail_cls, null);
        
        SPEX_Inv_Platform_Sel_cls objSPEX_Inv_Platform_Sel_cls = new SPEX_Inv_Platform_Sel_cls();
        System.assertNotEquals(objSPEX_Inv_Platform_Sel_cls, null);
        
        //SPEX_Inv_Platform_Sel_cls objParamSPEX_Inv_Platform_Sel_cls = new SPEX_Inv_Platform_Sel_cls('Dassault1');
        //System.assertNotEquals(objSPEX_Inv_Platform_Sel_cls, null);
        
        SPEX_Inv_Platform_Detail_cls objParamSPEX_Inv_Platform_Detail_cls = new SPEX_Inv_Platform_Detail_cls('Dassault1','F7X1');
        System.assertNotEquals(objParamSPEX_Inv_Platform_Detail_cls, null);
        
        SPEX_Status_ColorCode_cls objSPEX_Status_ColorCode_cls = new SPEX_Status_ColorCode_cls('Safe');
        System.assertNotEquals(objSPEX_Status_ColorCode_cls,null);
        
        SPEX_GetImage_cls.getImageName('Dassault','F7x');
        SPEX_GetImage_cls.getImageName('Dassault','Falcon 2000');
        SPEX_GetImage_cls.getImageName('Gulfstream','GV CLASSIC');
        SPEX_GetImage_cls.getImageName('Gulfstream','G650'); 
        SPEX_GetImage_cls.getImageName('Pilatus','PC-12');  
        SPEX_GetImage_cls.getImageName('Pilatus','PC-12 NG');                      
        SPEX_GetImage_cls.getImageName('Cessna','CESSNA 525 SERIES');   
        SPEX_GetImage_cls.getImageName('Cessna','CESSNA 550 SERIES');   
        SPEX_GetImage_cls.getImageName('Cessna','CESSNA 650 SERIES');   
        SPEX_GetImage_cls.getImageName('Cessna','CESSNA 680 SERIES');   
        SPEX_GetImage_cls.getImageName('Cessna','CESSNA 750 SERIES');  
        SPEX_GetImage_cls.getImageName('Bombardier','LEARJET'); 
        SPEX_GetImage_cls.getImageName('Bombardier','CHALLENGER'); 
        SPEX_GetImage_cls.getImageName('Bombardier','GLOBAL EXPRESS'); 
        SPEX_GetImage_cls.getImageName('Hawker Beechcraft','HAWKER 800 SERIES'); 
        SPEX_GetImage_cls.getImageName('Hawker Beechcraft','HAWKER 1000 SERIES'); 
        SPEX_GetImage_cls.getImageName('Hawker Beechcraft','HAWKER 4000 SERIES'); 
         
        DashboardHome objDashboardHome = new DashboardHome();
        System.assertNotEquals(objDashboardHome ,null);
        
        objDashboardHome.getOverallAOGStatus();
        objDashboardHome.getPlatformsAtRisk();
        objDashboardHome.getmpStatus();
      /*objDashboardHome.getSRsCountByProduct();
        objDashboardHome.getSRsCountBySBU();*/
        
        
        List<Sobject> lstParts = [select id from SPEX_DB_Part_Summary__c Limit 10];   
        
        delete lstParts;
        
        objPartSummary = new SPEX_DB_Part_Summary__c();
        objPartSummary.Part_Number__c = 'AtRiskPart123';
        objPartSummary.Stock_By_Americas__c = 0;
        objPartSummary.Stock_By_APAC__c = 0;
        objPartSummary.Stock_By_EMEA__c = 0;
        objPartSummary.Demand_By_Americas__c = 0;
        objPartSummary.Demand_By_APAC__c = 0;
        objPartSummary.Demand_By_EMEA__c = 0;
        objPartSummary.Min_Stock_Americas__c = 1;
        objPartSummary.Min_Stock_APAC__c = 1;
        objPartSummary.Min_Stock_EMEA__c = 1;
        
        insert objPartSummary;            
        objSPEX_DB_Home_cls = new SPEX_DB_Home_cls();
        
        lstParts = [select id from SPEX_DB_Part_Summary__c Limit 10];   
        
        delete lstParts;
        
        objPartSummary = new SPEX_DB_Part_Summary__c();
        objPartSummary.Part_Number__c = 'AtSafePart';
        objPartSummary.Stock_By_Americas__c = 1;
        objPartSummary.Stock_By_APAC__c = 1;
        objPartSummary.Stock_By_EMEA__c = 1;
        objPartSummary.Demand_By_Americas__c = 0;
        objPartSummary.Demand_By_APAC__c = 0;
        objPartSummary.Demand_By_EMEA__c = 0;
        objPartSummary.Min_Stock_Americas__c = 1;
        objPartSummary.Min_Stock_APAC__c = 1;
        objPartSummary.Min_Stock_EMEA__c = 1;
        
        insert objPartSummary;            
        //objSPEX_DB_Home_cls = new SPEX_DB_Home_cls(); 
        
        PageReference pageRef = Page.SPEX_Dashboard_OEM_Details;          
        PageRef.getParameters().put('PLATFORM','Test plt');
        System.currentPageReference().getParameters().put('PLATFORM','Test plt');
        Test.setCurrentPage(pageRef);      
        
        SPEX_Inv_Platform_Sel_cls objSPEX_Inv_Parameter_passed = new SPEX_Inv_Platform_Sel_cls();   
                
        SPEX_DB_Data_Log__c objDataLog = new SPEX_DB_Data_Log__c();
        objDataLog.Refresh_Time__c = system.now();
        
        insert objDataLog;
        
        SPEXDTO_cls.getRefreshTime();
    }
    
    static testMethod void TestMthd_SPEXClasses2()
    {    
    ////////////////////////////////// SR#395641////////////////////////////
    
        SPEX_DB_Part_Summary__c objPartSummary = new SPEX_DB_Part_Summary__c();
        List<SPEX_DB_Part_Summary__c> lstPartSummary = new List<SPEX_DB_Part_Summary__c>();
        
            for(Integer i=0; i<=4; i++)
        {
            objPartSummary = new SPEX_DB_Part_Summary__c();
            objPartSummary.Part_Number__c = 'PT'+i;
            objPartSummary.Part_description__c = 'Part Desc';            
            objPartSummary.Stock_By_Americas__c = i*10;
            objPartSummary.Stock_By_APAC__c = i*100;
            objPartSummary.Stock_By_EMEA__c = i;
            objPartSummary.Demand_By_Americas__c = i*20;
            objPartSummary.Demand_By_APAC__c = i*10;
            objPartSummary.Demand_By_EMEA__c = i;
            lstPartSummary.add(objPartSummary);
        }
        
        insert lstPartSummary;
        
        lstPartSummary = [select id from SPEX_DB_Part_Summary__c where part_number__c = 'PT1' or part_number__c = 'PT2' Limit 10];
                
        if(lstPartSummary.size() > 1)
        {      
            
          
        SPEX_DB_Platform_Summary__c objPlatformSummary = new SPEX_DB_Platform_Summary__c();
        List<SPEX_DB_Platform_Summary__c> lstPlatformSummary = new List<SPEX_DB_Platform_Summary__c>();
        
            objPlatformSummary.Part_Number__c = lstPartSummary[0].id;
            objPlatformSummary.Platform__c = 'F7x1';
            objPlatformSummary.OEM_Name__c = 'Dassault1';
            objPlatformSummary.Demand_By_Americas__c = 1;
            objPlatformSummary.Demand_By_APAC__c = 2;
            objPlatformSummary.Demand_By_EMEA__c = 3;
            
            insert objPlatformSummary;            
            
            lstPartSummary[0].Min_Stock_Americas__c = 1;
            lstPartSummary[0].Min_Stock_APAC__c = 1;
            lstPartSummary[0].Min_Stock_EMEA__c = 1;
            update lstPartSummary;
            
            objPlatformSummary = new SPEX_DB_Platform_Summary__c();
            
            objPlatformSummary.Part_Number__c = lstPartSummary[1].id;
            objPlatformSummary.Platform__c = 'Falcon 20001';
            objPlatformSummary.OEM_Name__c = 'Dassault1';
            objPlatformSummary.Demand_By_Americas__c = 100;
            objPlatformSummary.Demand_By_APAC__c = 200;
            objPlatformSummary.Demand_By_EMEA__c = 300;
            
            insert objPlatformSummary;
            
            objPlatformSummary.Part_Number__c = lstPartSummary[0].id;
            update objPlatformSummary;
            
            objPlatformSummary = new SPEX_DB_Platform_Summary__c();
            
            objPlatformSummary.Part_Number__c = lstPartSummary[1].id;
            objPlatformSummary.Platform__c = 'Falcon 20001';
            objPlatformSummary.OEM_Name__c = 'Dassault1';
            objPlatformSummary.Demand_By_Americas__c = 100;
            objPlatformSummary.Demand_By_APAC__c = 200;
            objPlatformSummary.Demand_By_EMEA__c = 300;
            
            insert objPlatformSummary;
            
            objPartSummary = new SPEX_DB_Part_Summary__c();
            objPartSummary.Part_Number__c = 'StockOutPart';
            objPartSummary.Stock_By_Americas__c = 10;
            objPartSummary.Stock_By_APAC__c = 10;
            objPartSummary.Stock_By_EMEA__c = 10;
            objPartSummary.Demand_By_Americas__c = 20;
            objPartSummary.Demand_By_APAC__c = 20;
            objPartSummary.Demand_By_EMEA__c = 20;
            objPartSummary.Min_Stock_Americas__c = 1;
            objPartSummary.Min_Stock_APAC__c = 1;
            objPartSummary.Min_Stock_EMEA__c = 1;
            
            insert objPartSummary;
            
            objPlatformSummary = new SPEX_DB_Platform_Summary__c();            
            objPlatformSummary.Part_Number__c = objPartSummary.ID;
            objPlatformSummary.Platform__c = 'F7X1';
            objPlatformSummary.OEM_Name__c = 'Dassault1';
            objPlatformSummary.Demand_By_Americas__c = 0;
            objPlatformSummary.Demand_By_APAC__c = 0;
            objPlatformSummary.Demand_By_EMEA__c = 0;
            
            insert objPlatformSummary;
            
            objPlatformSummary = new SPEX_DB_Platform_Summary__c();
            
            objPlatformSummary.Part_Number__c = objPartSummary.ID;
            objPlatformSummary.Platform__c = 'Falcon 900';
            objPlatformSummary.OEM_Name__c = 'Dassault1';
            objPlatformSummary.Demand_By_Americas__c = 100;
            objPlatformSummary.Demand_By_APAC__c = 200;
            objPlatformSummary.Demand_By_EMEA__c = 300;
            
            insert objPlatformSummary;
            
            objPartSummary = new SPEX_DB_Part_Summary__c();
            objPartSummary.Part_Number__c = 'AtRiskPart';
            objPartSummary.Part_description__c = 'Part Desc';            
            objPartSummary.Stock_By_Americas__c = 1;
            objPartSummary.Stock_By_APAC__c = 1;
            objPartSummary.Stock_By_EMEA__c = 1;
            objPartSummary.Demand_By_Americas__c = 1;
            objPartSummary.Demand_By_APAC__c = 1;
            objPartSummary.Demand_By_EMEA__c = 1;
            objPartSummary.Min_Stock_APAC__c = 1;
            objPartSummary.Min_Stock_EMEA__c = 1;
            objPartSummary.Min_Stock_Americas__c = 1;
            
            insert objPartSummary;
            
            objPlatformSummary = new SPEX_DB_Platform_Summary__c();
            
            objPlatformSummary.Part_Number__c = objPartSummary.ID;
            objPlatformSummary.Platform__c = 'Falcon 9001';
            objPlatformSummary.OEM_Name__c = 'RiskOEM';
            objPlatformSummary.Demand_By_Americas__c = 0;
            objPlatformSummary.Demand_By_APAC__c = 0;
            objPlatformSummary.Demand_By_EMEA__c = 0;
            
            insert objPlatformSummary;
            
            lstPartSummary  = [select id from SPEX_DB_Part_Summary__c where part_number__c = 'AtRiskPart' Limit 10];
            
            if(lstPartSummary!=null & lstPartSummary.size() > 0)
            {   
                objPlatformSummary = new SPEX_DB_Platform_Summary__c();                
                objPlatformSummary.Part_Number__c = objPartSummary.ID;
                objPlatformSummary.Platform__c = 'Falcon 90012';
                objPlatformSummary.OEM_Name__c = 'RiskOEM2';
                objPlatformSummary.Demand_By_Americas__c = 1;
                objPlatformSummary.Demand_By_APAC__c = 1;
                objPlatformSummary.Demand_By_EMEA__c = 1;                        
                insert objPlatformSummary;
            }
                  
            objPartSummary = new SPEX_DB_Part_Summary__c();
            objPartSummary.Part_Number__c = 'SafePart';
            objPartSummary.Stock_By_Americas__c = 2;
            objPartSummary.Stock_By_APAC__c = 2;
            objPartSummary.Stock_By_EMEA__c = 2;
            objPartSummary.Demand_By_Americas__c = 1;
            objPartSummary.Demand_By_APAC__c = 1;
            objPartSummary.Demand_By_EMEA__c = 1;
            
            insert objPartSummary;
            
            objPlatformSummary = new SPEX_DB_Platform_Summary__c();            
            objPlatformSummary.Part_Number__c = objPartSummary.ID;
            objPlatformSummary.Platform__c = 'Falcon 9001';
            objPlatformSummary.OEM_Name__c = 'RiskOEM';
            objPlatformSummary.Demand_By_Americas__c = 1;
            objPlatformSummary.Demand_By_APAC__c = 1;
            objPlatformSummary.Demand_By_EMEA__c = 1;
            
            insert objPlatformSummary;            
            system.debug('objPlatformSummary----->' + objPlatformSummary); 
       }
        //Creating Case    
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;
        
         //creating contact;
        Contact testCont=new Contact(firstname='Test',LastName='Contact0001',AccountId=testAccount.Id,Phone_3__c='991112456',
        Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Email='test00@test.com' );
        insert testCont;
        
        Product2 testProd = new Product2();
        testProd.Name = 'PT1';
        testProd.IsActive = true;
        testProd.Product_Number__c = 'pn101010012';
        insert testProd;
        
        if(testProd != null){
            SPEX_DB_Part_Summary__c objPartSummary1 = new SPEX_DB_Part_Summary__c();
                objPartSummary1.Part_Number__c = [select productcode from Product2 where id=:testProd.id].productcode;
                objPartSummary1.Part_description__c = 'Part Desc';            
                objPartSummary1.Stock_By_Americas__c = 0;
                objPartSummary1.Stock_By_APAC__c = 0;
                objPartSummary1.Stock_By_EMEA__c = 0;
                objPartSummary1.Demand_By_Americas__c = 0;
                objPartSummary1.Demand_By_APAC__c = 0;
                objPartSummary1.Demand_By_EMEA__c = 0;
            try{
            insert objPartSummary1;
            }catch(exception ex){
             system.debug('Error------>' + ex.getMessage());
            }
        }
        Case testCase =new Case();
        testCase.AccountId=testAccount.Id;
        testCase.subject='Fax:{9986512345} test data';
        testCase.ContactId=testcont.Id;
        testCase.Export_Compliance_Content_ITAR_EAR__c='No';
        testCase.Government_Compliance_SM_M_Content__c='No';
        //testCase.No_FCR_Reason__c='Not Trained'; For Ticket INC000009687923
        testCase.Type='AOG';
        testCase.Customer_PO_RO_WONumber__c='43545';
        testCase.workstrem__c='Spares';
        testCase.CSM_Region__c='EMEA';
        testCase.Supported_Product__c='Radio';
        testCase.Origin ='Email';
        testCase.Primary_Email__c='test.11@test.com';
        testCase.recordtypeid = label.Case_AOG_RecordType;
        testCase.classification__c  = 'CSO Special Programs';
        testCase.Sub_Class__c = 'AOG';
        testCase.Detail_Class__c = 'SPEX/Exchange';
        testCase.Product_Number__c = testProd.id;
        testCase.status = 'New';
          //testCase.SPEX_EXCHANGE__C = TRUE;
        insert testCase;
        system.debug('----->' + [select id,SPEX_EXCHANGE__C,Product_Part__c from Case where id=: testCase.id].Product_Part__c);
        
        
        SPEX_DB_CriticalParts_cls objSPEX_DB_CriticalParts_cls = new SPEX_DB_CriticalParts_cls();
        System.assertNotEquals(objSPEX_DB_CriticalParts_cls, null);
        ////////////////////////////////// SR#395641////////////////////////////
    }
}