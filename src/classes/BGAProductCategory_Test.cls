@isTest ()
public class BGAProductCategory_Test {
    static testMethod void BGATestMethod1(){
       
        
        ApexPages.StandardController controller;
        BGAProductCategory bga = new BGAProductCategory(controller);
        
        BGAProductCategory.getProduct('all');
        BGAProductCategory.getTSElist('Test Prod');
        BGAProductCategory.getTSElist('all');
        BGAProductCategory.getTSElist('Avionics');
        BGAProductCategory.getTollfreeno('Mechanical');
        BGAProductCategory.getTollfreeno('Techinical');
        BGAProductCategory.getTollfreeno('Non Techinical');
        BGAProductCategory.getTollfreenodetails('Test Prod','Test Prod1'); 
         
        
        Skill_DataBase__c sd = new Skill_DataBase__c();
        sd.Master_Skill_Type__c='Test Skill';
        sd.Mobile_App_Products_Description__c='TEst Description';
        sd.Product_Ext__c='Test Product';
        sd.Mobile_App_Products_Image_Url__c='Test URL';
        sd.Skill_Type__c='Mobile App Products';
        sd.Skill_Value__c='Mechanical Other';
        sd.Value1__c='Test Value1';
        sd.Value2__c='Test Value2';
        sd.Value3__c='Test Value3';
        insert sd;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Gupta';
        con.FirstName = 'Sumit';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sumit13.gupta@nttdata.com';
        con.Email='sumit13.gupta@nttdata.com';
        con.Mobile_App_Role__c=Label.BGAMob_MechanicalFSE;
        test.startTest();
        insert con;
        
        Skills2__c skill = new Skills2__c();
        skill.Contact__c=con.Id;
        skill.Skill_Value__c='Test Skill';
        insert skill;
         
        BGAProductCategory.getContactlist1('Test Skill','all');
        BGAProductCategory.getContactlist1('Test Skill','Mechanical');
        BGAProductCategory.getContactlist1('Test Skill','Avionics'); 
        //BGAProductCategory.getContactdetails(con.id); 
        BGAProductCategory.getContact1('Test Prod',String.valueOf(con.Id));
        BGAProductCategory.getProductdeatils(String.valueOf(sd.Id));
        //BGAProductCategory.getcontactlist(String.valueOf(sd.Id));
        BGAProductCategory.getContact(String.valueOf(con.Id));
        test.stopTest(); 
        
    }
    
    static testMethod void BGATestMethod2(){
        test.startTest();
        
        ApexPages.StandardController controller;
        BGAProductCategory bga = new BGAProductCategory(controller);
        
        
        
        Skill_DataBase__c sd = new Skill_DataBase__c();
        sd.Master_Skill_Type__c='Test Skill';
        sd.Mobile_App_Products_Description__c='TEst Description';
        sd.Product_Ext__c='Test Product';
        sd.Mobile_App_Products_Image_Url__c='Test URL';
        sd.Skill_Type__c='Mobile App Products';
        sd.Skill_Value__c='Test Mechanical';
        sd.Value1__c='Mechanical';
        sd.Value2__c='Test Value2';
        sd.Value3__c='Test Value3';
        insert sd;
        
        BGAProductCategory.getProduct('Mechanical');
        BGAProductCategory.getProduct('all');
        
        Skill_DataBase__c sd1 = new Skill_DataBase__c();
        sd1.Master_Skill_Type__c='Test Skill';
        sd1.Mobile_App_Products_Description__c='TEst Description';
        sd1.Product_Ext__c='Test Product';
        sd1.Mobile_App_Products_Image_Url__c='Test URL';
        sd1.Skill_Type__c='Mobile App Products';
        sd1.Skill_Value__c='Test Mechanical';
        sd1.Value1__c='Avionics';
        sd1.Value2__c='Test Value2';
        sd1.Value3__c='Test Value3';
        insert sd1;
        
        BGAProductCategory.getProduct('Avionics');
        
        test.stopTest(); 
        
    }
    
    static testMethod void BGATestMethod3(){
        test.startTest();
        
        ApexPages.StandardController controller;
        BGAProductCategory bga = new BGAProductCategory(controller);
        
        BGAProductCategory.getProduct('Avionics');
        
        Skill_DataBase__c sd = new Skill_DataBase__c();
        sd.Master_Skill_Type__c='Test Skill';
        sd.Mobile_App_Products_Description__c='TEst Description';
        sd.Product_Ext__c='Test Product';
        sd.Mobile_App_Products_Image_Url__c='Test URL';
        sd.Skill_Type__c='Mobile App Products';
        sd.Skill_Value__c='Test Avionics';
        sd.Value1__c='Avionics';
        sd.Value2__c='Test Value2';
        sd.Value3__c='Test Value3';
        insert sd;
        BGAProductCategory.getcontactlst(String.valueOf(sd.Id));   
        BGAProductCategory.getEscalationContact(); 
        BGAProductCategory.getcontactlist('TestRecord'); 
        
        test.stopTest(); 
        
    }
}