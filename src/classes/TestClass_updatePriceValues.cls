@isTest(SeeAllData=true)
private class TestClass_updatePriceValues{
    static testMethod void TestMthd_updatePriceValues(){
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where alias='sadmin' and isactive = true order by createddate asc limit 1];
        //User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];
  
      
        Contact objContact = new Contact();
        objContact.LastName = 'hari';
        objContact.FirstName = 'vnv';
        objContact.AccountId = acc.Id;
        objContact.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        objContact.Email='harikishore.vutukuri@honeywell.com';
        objContact.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        objContact.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;     
        objContact.Employee_Number__c = 'E123123';
        insert objContact;
         
        Price_Book__c pb = new Price_Book__c();
        pb.Product_Type__c = 'MSP';    
        pb.Engine__c = 'TFE731-2';
        pb.Location__c = 'North America(NA)';
        pb.Between_Price__c = '23.55';
        pb.MSP_Gold__c = '10.20';
        pb.NRL_Gold__c = '20.1';
        pb.OverPrice__c = '25.1';
        pb.Under_Price__c = '33.11';
        pb.APU_Gold_NLS_Price__c = '22.01';
        pb.APU_Gold_Price__c = '34.12';
        pb.APU_Price__c = '22.22';
        pb.APU_Transfer_Fee_Price__c = '23.55';
        pb.APU_Model__c = '36-100A';
        pb.OverHrs__c = 23;
        pb.UnderHrs__c = 55;
        pb.Years__c = 5;
        pb.Renewal_Start_Date__c = null;
        pb.Transfer_Fee__c = '55.55';
        insert pb;
        
        Price_Book__c pb1 = new Price_Book__c();
        pb1.Product_Type__c = 'MSP';    
        pb1.Engine__c = 'TFE731-2';
        pb1.Location__c = 'North America(NA)';
        pb1.Between_Price__c = '23.55';
        pb1.MSP_Gold__c = '10.20';
        pb1.NRL_Gold__c = '20.10';
        pb1.OverPrice__c = '25.11';
        pb1.Under_Price__c = '33.11';
        pb1.OverHrs__c = 23;
        pb1.UnderHrs__c = 55;
        pb1.APU_Gold_NLS_Price__c = '23.01';
        pb1.APU_Gold_Price__c = '32.12';
        pb1.APU_Price__c = '23.22';
        pb1.APU_Transfer_Fee_Price__c = '25.55';
        pb1.APU_Model__c = '36-150E';
        pb1.Years__c = 5;
        pb1.Renewal_Start_Date__c = system.today();
        pb1.Transfer_Fee__c = '55.55';
        insert pb1;
        
        Platform__c pf = new Platform__c();
        pf.Name = 'Test Hari';
        pf.Model__c = 'Hello';
        pf.Make__c = 'Hi';
        pf.APU__c = '36-150E';
        insert pf;
        Platform__c pf1 = new Platform__c();
        pf1.Name = 'Test Hariiiiii';
        pf1.Model__c = 'Hellooo';
        pf1.Make__c = 'Hiii';
        pf1.APU__c = '';
        insert pf1;
        
        Fleet_Asset_Detail__c f = new Fleet_Asset_Detail__c();
        f.MSP_Engine_Model__c = 'TFE731-2';
        f.Account__c = acc.Id;
        f.Platform_Name__c = pf.id;
        f.Tail_Number__c = '20';
        f.Serial_Number__c = '55';
        insert f;
        Fleet_Asset_Detail__c f1 = new Fleet_Asset_Detail__c();
        f1.MSP_Engine_Model__c = '';
        f1.Account__c = acc.Id;
        f1.Platform_Name__c = pf1.id;
        f1.Tail_Number__c = '20';
        f1.Serial_Number__c = '55';
        insert f1;
        
        Contract c = new Contract();
        c.AccountId = acc.Id;
        c.Status = 'Pending Activation';
        c.Type__c = 'MSP';
        c.Renewal_Order_Receipt_Name__c = objContact.id;
        c.Aircraft__c = f.id;
        c.Location__c = 'North America(NA)';
        c.Engine_MSP_Price_ONA__c = '10.12';
        c.Engine_MSP_PriceNA__c = '20.12';
        c.Engine_MSP_Price_Between__c = '30.12';
        c.EngineOverHrs__c = 23;
        c.EngineUnderHrs__c = 55;
        c.Engine_Gold_Price__c = '50.12';
        c.Engine_Gold_NRL_Price__c = '60.12';
        c.Engine_Transfer_Fee_Price__c = '70.12';
        c.Years__c = 5;
        c.APU_Transfer_Fee_Price__c = '23.55';
        c.APU_MSP_Price__c = '55.21';
        c.APU_Gold_NLS_Price__c = '22.2';
        c.APU_Gold_Price__c = '15.11';
        c.MSP_Engine_ModelPL__c = 'TFE731-2';
        c.Renewal_Start_Date__c = system.today();
        insert c;
        
        test.startTest();
        c.Engine_MSP_Price_ONA__c = pb.OverPrice__c;
        c.Engine_MSP_PriceNA__c = pb.Under_Price__c;
        c.Engine_MSP_Price_Between__c = pb.Between_Price__c;
        c.EngineOverHrs__c = pb.OverHrs__c;
        c.EngineUnderHrs__c = pb.UnderHrs__c;
        c.Engine_Gold_Price__c = pb.MSP_Gold__c;
        c.Engine_Gold_NRL_Price__c = pb.NRL_Gold__c;
        c.Engine_Transfer_Fee_Price__c = pb.Transfer_Fee__c;
        c.APU_Transfer_Fee_Price__c = pb.APU_Transfer_Fee_Price__c;
        c.APU_MSP_Price__c = pb.APU_Price__c;
        c.APU_Gold_NLS_Price__c = pb.APU_Gold_NLS_Price__c;
        c.APU_Gold_Price__c = pb.APU_Gold_Price__c;
        c.Years__c = pb.Years__c;
        
        try{
        update c;
        }catch(DMLException e){}
        
        c.Engine_MSP_Price_ONA__c = pb1.OverPrice__c;
        c.Engine_MSP_PriceNA__c = pb1.Under_Price__c;
        c.Engine_MSP_Price_Between__c = pb1.Between_Price__c;
        c.EngineOverHrs__c = pb1.OverHrs__c;
        c.EngineUnderHrs__c = pb1.UnderHrs__c;
        c.Engine_Gold_Price__c = pb1.MSP_Gold__c;
        c.Engine_Gold_NRL_Price__c = pb1.NRL_Gold__c;
        c.Engine_Transfer_Fee_Price__c = pb1.Transfer_Fee__c;
        c.APU_Transfer_Fee_Price__c = pb1.APU_Transfer_Fee_Price__c;
        c.APU_MSP_Price__c = pb1.APU_Price__c;
        c.APU_Gold_NLS_Price__c = pb1.APU_Gold_NLS_Price__c;
        c.APU_Gold_Price__c = pb1.APU_Gold_Price__c;
        c.Years__c = pb1.Years__c;
       
        try{
        update c;
        }catch(DMLException de){}
        c.MSP_Engine_ModelPL__c = '';
        c.Aircraft__c = f1.id;
        c.Engine_MSP_Price_ONA__c = '';
        c.Engine_MSP_PriceNA__c = '';
        c.Engine_MSP_Price_Between__c = '';
        c.EngineOverHrs__c = null;
        c.EngineUnderHrs__c = null;
        c.Engine_Gold_Price__c = '';
        c.Engine_Gold_NRL_Price__c = '';
        c.Engine_Transfer_Fee_Price__c = '';
        c.APU_Transfer_Fee_Price__c = '';
        c.APU_MSP_Price__c = '';
        c.APU_Gold_NLS_Price__c = '';
        c.APU_Gold_Price__c = '';
        // code added for test coverage--start//
        Entitlement__c entobj = new Entitlement__c(Contract_Number__c=c.Id,Entitlement_Type__c='Aircraft',Entitlement_Start_Date__c=system.today() );
        insert entobj;
        
         User u =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where alias='sadmin' and isactive = true order by createddate desc limit 1];
        
        try{
         c.OwnerId= u.Id;
                    // code added for test coverage--End//
        update c;
        }catch(DMLException dee){}
        test.stopTest();
    }
}