@isTest
private class QFDFieldsAutoPopulation_Test {
    
     @testSetup static void setup()
     {
        Account AccRec = new Account();
        AccRec.name = 'Acc_Text_rec';
        AccRec.Type = 'OEM';
        AccRec.Strategic_Business_Unit__c = 'ATR';
        AccRec.CBT__c = 'Airbus';
        AccRec.Customer_Status__c = 'Active';
        AccRec.Region_Name__c = 'Americas';
        AccRec.Sub_Region_Name__c = 'Canada';
        AccRec.Service_Level__c = 'Standard';

        insert AccRec;

        Contact CntRec = new Contact();
        CntRec.Accountid = AccRec.id;
        CntRec.FirstName = 'Testing';
        CntRec.LastName = 'Check';
        CntRec.Email = 'anila.francis@wipro.com';
        insert CntRec;

        Case ca = new Case();
        ca.Recordtypeid = label.General_RT_ID;
        ca.Origin = 'phone';
        ca.Export_Compliance_Content_ITAR_EAR__c = 'No';
        ca.Government_Compliance_SM_M_Content__c = 'No';
        ca.Classification__c = 'gcc';
        ca.type = 'Other';
        ca.status = 'Open';
        ca.Contact = CntRec;
        insert ca;
    
    }
    static testMethod void QFDFieldsTestMethod() {
        
                
        List<Service_Request__c> serReqList = new List<Service_Request__c>();
        List<Id> serReqIds = new List<Id>();
        
        List<Account> AccRecList = [Select id from Account where name = 'Acc_Text_rec' limit 1 ];
        List<Contact> cntRecList = [Select id from contact where Email = 'anila.francis@wipro.com' limit 1 ];
        List<Case> csList =[select id from case where Classification__c = 'gcc' limit 1];
        Id srRecId = Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get('SR(General)').getRecordTypeId();
        test.starttest();
        Service_Request__c SRrec = new Service_Request__c();
        SRrec.Contact_Name__c = cntRecList[0].id;
        SRrec.recordtypeid = srRecId ;
        SRrec.SR_Type__c = 'Field Event';
        SRrec.Subject__C = 'test';
        SRrec.Status__C = 'Open';
        SRrec.Priority__c = 'High';
        SRrec.Problem_Description__c = 'test';
        SRrec.Deliverable__c = 'test';
        SRrec.Atr__c = 'Service/Support';
        SRrec.Attribute_Details__c = 'Product Investigation';
        SRrec.Attribute_Sub__c = 'Field Service Support';
        SRrec.Complexity_Level__c = '1-Part Price/Availability';
        SRrec.Customer_Due_Date__c = system.today();        
        SRrec.Case_Number__c = csList[0].id;
        SRrec.Ownerid = label.EPS_ATR_Queue;
        SRrec.Gate_1_Completion_Date__c = system.today();
        SRrec.CSB_Gate__c = 'test';
        SRrec.X1st_18Mth_EIS__c = 'No';
        SRrec.CUS_IFSD_21_3_FMS__c = 'Yes';
        SRrec.Cust_Impact__c ='Top 10 D&C driver';
        SRrec.Financial_12mth__c = '$100K to $250K';
        SRrec.Platforms_Affected__c = 'test';
        SRrec.Previous_Inv__c='Recent SRD/Investigated <5 Yrs';
        SRrec.Prod_Maturity__c='Stable';
        SRrec.Reliability__c='At or above guarantee’s (PSAA or other)';
        
        serReqList.add(SRrec);
        
        insert serReqList;
        
        serReqIds.add(serReqList[0].Id);   
           
        serReqList[0].Status__c = 'closed';
        serReqList[0].Date_Closed__c = system.today() + 101;
        serReqList[0].Key_Code__c = '';
        update serReqList;
        
        List<Service_Request__c> serReqList1 = new List<Service_Request__c>();
        List<Id> serReqIds1 = new List<Id>();
        
        Service_Request__c SRrec1 = new Service_Request__c();
        SRrec1.Contact_Name__c = CntRecList[0].id;
        SRrec1.recordtypeid = srRecId ;
        SRrec1.SR_Type__c = 'Field Event';
        SRrec1.Subject__C = 'test';
        SRrec1.Status__C = 'Open';
        SRrec1.Priority__c = 'High';
        SRrec1.Problem_Description__c = 'test';
        SRrec1.Deliverable__c = 'test';
        SRrec1.Atr__c = 'Service/Support';
        SRrec1.Attribute_Details__c = 'Product Investigation';
        SRrec1.Attribute_Sub__c = 'Field Service Support';
        SRrec1.Complexity_Level__c = '1-Part Price/Availability';
        SRrec1.Customer_Due_Date__c = system.today();        
        SRrec1.Case_Number__c = csList[0].id;
        SRrec1.Gate_2_Completed__c = system.today();
        SRrec1.CSB_Gate__c = 'Gate 3';
        SRrec1.Key_Code__c = 'test';
        SRrec1.Ownerid = Label.EPS_BGA_Queue;
        SRrec1.X1st_18Mth_EIS__c = 'Yes';
        SRrec1.CUS_IFSD_21_3_FMS__c = 'No';
        SRrec1.Cust_Impact__c ='Top 10 D&C driver';
        SRrec1.Financial_12mth__c = '$100K to $250K';
        SRrec1.Platforms_Affected__c = 'test';
        SRrec1.Previous_Inv__c='Recent SRD/Investigated <5 Yrs';
        SRrec1.Prod_Maturity__c='Stable';
        SRrec1.Reliability__c='At or above guarantee’s (PSAA or other)';
          serReqList1.add(SRrec1);      
        insert serReqList1;
        
         serReqIds1.add(serReqList1[0].Id); 
         
        SRrec.Status__c = 'Rejected';
        SRrec.Date_Closed__c = system.today() + 80;
        serReqList1[0].Ownerid = label.EPS_ATR_Queue;
        update SRrec1;
        
        List<Service_Request__c> serReqList2 = new List<Service_Request__c>();
        List<Id> serReqIds2 = new List<Id>();
       
        Service_Request__c SRrec2 = new Service_Request__c();
        SRrec2.Contact_Name__c = CntRecList[0].id;
        SRrec2.recordtypeid = srRecId ;
        SRrec2.SR_Type__c = 'Field Event';
        SRrec2.Subject__C = 'test';
        SRrec2.Status__C = 'Open';
        SRrec2.Priority__c = 'High';
        SRrec2.Problem_Description__c = 'test';
        SRrec2.Deliverable__c = 'test';
        SRrec2.Atr__c = 'Service/Support';
        SRrec2.Attribute_Details__c = 'Product Investigation';
        SRrec2.Attribute_Sub__c = 'Field Service Support';
        SRrec2.Complexity_Level__c = '1-Part Price/Availability';
        SRrec2.Customer_Due_Date__c = system.today();        
        SRrec2.Case_Number__c = csList[0].id;
        SRrec2.Gate_2_Completed__c = system.today();
        SRrec2.CSB_Gate__c = 'Gate 3';
        SRrec2.Key_Code__c = 'test';
        SRrec2.Ownerid = Label.EPS_D_S_Queue;
        SRrec2.Date_Closed__c = system.today() + 80;
      //  SRrec2.X1st_18Mth_EIS__c = '';
      //  SRrec2.CUS_IFSD_21_3_FMS__c = 'No';
       // SRrec2.Cust_Impact__c ='Top 10 D&C driver';
       // SRrec2.Financial_12mth__c = '$100K to $250K';
        SRrec2.Platforms_Affected__c = 'test';
        SRrec2.Previous_Inv__c='Recent SRD/Investigated <5 Yrs';
        SRrec2.Prod_Maturity__c='Stable';
        SRrec2.Reliability__c='At or above guarantee’s (PSAA or other)';
         serReqList2.add(SRrec2);      
        insert serReqList2;
        
        serReqIds2.add(serReqList2[0].Id); 

        List<Service_Request__c> serReqList3 = new List<Service_Request__c>();
        List<Id> serReqIds3 = new List<Id>();
        
        Platform__c p = new Platform__c();
        p.name='Test Platform';
        p.CurrencyIsoCode = 'USD';
        p.SRD_Supported__c =false;
        
        insert p;
        
        Platform__c p1 = new Platform__c();
        p1.name='Test Platform';
        p1.CurrencyIsoCode = 'USD';
        p1.SRD_Supported__c =true;
        
        insert p1;
        
        Service_Request__c SRrec3 = new Service_Request__c();
        SRrec3.Contact_Name__c = CntRecList[0].id;
        SRrec3.recordtypeid = srRecId ;
        SRrec3.SR_Type__c = 'Field Event';
        SRrec3.Subject__C = 'test';
        SRrec3.Status__C = 'Open';
        SRrec3.Priority__c = 'High';
        SRrec3.Problem_Description__c = 'test';
        SRrec3.Deliverable__c = 'test';
        SRrec3.Atr__c = 'Service/Support';
        SRrec3.Attribute_Details__c = 'Product Investigation';
        SRrec3.Attribute_Sub__c = 'Field Service Support';
        SRrec3.Complexity_Level__c = '1-Part Price/Availability';
        SRrec3.Customer_Due_Date__c = system.today();        
        SRrec3.Case_Number__c = csList[0].id;
        SRrec3.Gate_2_Completed__c = system.today();
        SRrec3.CSB_Gate__c = 'Gate 3';
        SRrec3.Key_Code__c = 'test';
        SRrec3.Ownerid = Label.EPS_D_S_Queue;
        SRrec3.Date_Closed__c = system.today() + 80;
       // SRrec3.X1st_18Mth_EIS__c = '';
       // SRrec3.CUS_IFSD_21_3_FMS__c = 'No';
       // SRrec3.Cust_Impact__c ='Top 10 D&C driver';
       // SRrec3.Financial_12mth__c = '$100K to $250K';
        SRrec3.Platforms_Affected__c = 'test';
        SRrec3.Previous_Inv__c='Recent SRD/Investigated <5 Yrs';
        SRrec3.Prod_Maturity__c='Stable';
        SRrec3.Reliability__c='At or above guarantee’s (PSAA or other)';
        SRrec3.Aircraft_Type__c = p.Id; 
        serReqList3.add(SRrec3);      
        insert serReqList3;
        
        serReqIds2.add(serReqList3[0].Id); 
        
        
        List<Service_Request__c> serReqList4 = new List<Service_Request__c>();
        List<Id> serReqIds4 = new List<Id>();
       
        Service_Request__c SRrec4 = new Service_Request__c();
        SRrec4.Contact_Name__c = CntRecList[0].id;
        SRrec4.recordtypeid = srRecId ;
        SRrec4.SR_Type__c = 'Field Event';
        SRrec4.Subject__C = 'test';
        SRrec4.Status__C = 'Open';
        SRrec4.Priority__c = 'High';
        SRrec4.Problem_Description__c = 'test';
        SRrec4.Deliverable__c = 'test';
        SRrec4.Atr__c = 'Service/Support';
        SRrec4.Attribute_Details__c = 'Product Investigation';
        SRrec4.Attribute_Sub__c = 'Field Service Support';
        SRrec4.Complexity_Level__c = '1-Part Price/Availability';
        SRrec4.Customer_Due_Date__c = system.today();        
        SRrec4.Case_Number__c = csList[0].id;
        SRrec4.Gate_2_Completed__c = system.today();
        SRrec4.CSB_Gate__c = 'Gate 3';
        SRrec4.Key_Code__c = 'test';
        SRrec4.Ownerid = Label.EPS_D_S_Queue;
        SRrec4.Date_Closed__c = system.today() + 80;
        SRrec4.X1st_18Mth_EIS__c = '';
        SRrec4.CUS_IFSD_21_3_FMS__c = 'No';
        SRrec4.Cust_Impact__c ='Top 10 D&C driver';
        SRrec4.Financial_12mth__c = '$100K to $250K';
        SRrec4.Platforms_Affected__c = 'test';
        SRrec4.Previous_Inv__c='Recent SRD/Investigated <5 Yrs';
        SRrec4.Prod_Maturity__c='Stable';
        SRrec4.Reliability__c='At or above guarantee’s (PSAA or other)';
        SRrec4.Aircraft_Type__c = p.Id; 
        serReqList4.add(SRrec4);      
        insert serReqList4;
        
        serReqIds4.add(serReqList4[0].Id); 
    
        test.stoptest();
       
        QFDFieldsAutoPopulation.populateQFDFieldsData(serReqList,true,false);
        QFDFieldsAutoPopulation.populateQFDFieldsData(serReqList1,true,false);
        QFDFieldsAutoPopulation.populateQFDFieldsData(serReqList2,true,false);
        QFDFieldsAutoPopulation.populateQFDFieldsData(serReqList4,true,false);
    }
    
     static testMethod void QFDFieldsTestMethod1() {       
                
        
        List<Account> AccRecList = [Select id from Account where name = 'Acc_Text_rec' limit 1 ];
        List<Contact> cntRecList = [Select id from contact where Email = 'anila.francis@wipro.com' limit 1 ];
        List<Case> csList =[select id from case where Classification__c = 'gcc' limit 1];
         Id srRecId = Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get('SR(General)').getRecordTypeId();
        List<Service_Request__c> serReqList5 = new List<Service_Request__c>();
        List<Id> serReqIds5 = new List<Id>();
        
        Platform__c p = new Platform__c();
        p.name='Test Platform';
        p.CurrencyIsoCode = 'USD';
        p.SRD_Supported__c =true;
        
        insert p;
        
        test.starttest();
        Service_Request__c SRrec5 = new Service_Request__c();
        SRrec5.Contact_Name__c = cntRecList[0].id;
        SRrec5.recordtypeid = srRecId ;
        SRrec5.SR_Type__c = 'Field Event';
        SRrec5.Subject__C = 'test';
        SRrec5.Status__C = 'Open';
        SRrec5.Priority__c = 'High';
        SRrec5.Problem_Description__c = 'test';
        SRrec5.Deliverable__c = 'test';
        SRrec5.Atr__c = 'Service/Support';
        SRrec5.Attribute_Details__c = 'Product Investigation';
        SRrec5.Attribute_Sub__c = 'Field Service Support';
        SRrec5.Complexity_Level__c = '1-Part Price/Availability';
        SRrec5.Customer_Due_Date__c = system.today();        
        SRrec5.Case_Number__c = csList[0].id;
        SRrec5.Gate_2_Completed__c = system.today();
        SRrec5.CSB_Gate__c = 'Gate 3';
        SRrec5.Key_Code__c = 'test';
        SRrec5.Ownerid = Label.EPS_D_S_Queue;
        SRrec5.Date_Closed__c = system.today() + 80;
        SRrec5.X1st_18Mth_EIS__c = 'NO';
        SRrec5.CUS_IFSD_21_3_FMS__c = 'No';
        SRrec5.Cust_Impact__c ='Nuisance or Work around available';
        SRrec5.Financial_12mth__c = 'None';
        SRrec5.Platforms_Affected__c = 'test';
        SRrec5.Previous_Inv__c='NO';
        SRrec5.Prod_Maturity__c='Stable';
        SRrec5.Reliability__c='At or above guarantee’s (PSAA or other)';
        SRrec5.Aircraft_Type__c = p.Id; 
        serReqList5.add(SRrec5);      
        insert serReqList5;
        
        serReqIds5.add(serReqList5[0].Id);
        
        List<Service_Request__c> serReqList6 = new List<Service_Request__c>();
        List<Id> serReqIds6 = new List<Id>();
        
        Service_Request__c SRrec6 = new Service_Request__c();
        SRrec6.Contact_Name__c = cntRecList[0].id;
        SRrec6.recordtypeid = srRecId ;
        SRrec6.SR_Type__c = 'Field Event';
        SRrec6.Subject__C = 'test';
        SRrec6.Status__C = 'Open';
        SRrec6.Priority__c = 'High';
        SRrec6.Problem_Description__c = 'test';
        SRrec6.Deliverable__c = 'test';
        SRrec6.Atr__c = 'Service/Support';
        SRrec6.Attribute_Details__c = 'Product Investigation';
        SRrec6.Attribute_Sub__c = 'Field Service Support';
        SRrec6.Complexity_Level__c = '1-Part Price/Availability';
        SRrec6.Customer_Due_Date__c = system.today();        
        SRrec6.Case_Number__c = csList[0].id;
        SRrec6.Gate_2_Completed__c = system.today();
        SRrec6.CSB_Gate__c = 'Gate 3';
        SRrec6.Key_Code__c = 'test';
        SRrec6.Ownerid = Label.EPS_D_S_Queue;
        SRrec6.Date_Closed__c = system.today() + 80;
        SRrec6.X1st_18Mth_EIS__c = '';
        SRrec6.CUS_IFSD_21_3_FMS__c = '';
        SRrec6.Cust_Impact__c ='';
        SRrec6.Financial_12mth__c = '';
        SRrec6.Platforms_Affected__c = 'test';
        SRrec6.Previous_Inv__c='';
        SRrec6.Prod_Maturity__c='';
        SRrec6.Reliability__c='';
        SRrec6.Aircraft_Type__c = p.Id; 
        serReqList6.add(SRrec6);      
        insert serReqList6;
        //test.stoptest();
        
        serReqIds6.add(serReqList6[0].Id);        
        
        test.stoptest();      
        
        QFDFieldsAutoPopulation.populateQFDFieldsData(serReqList5,true,false);
        QFDFieldsAutoPopulation.populateQFDFieldsData(serReqList6,true,false);
        
     }   
     
     static testMethod void QFDFieldsTestMethod2() {       
                
        
        List<Account> AccRecList = [Select id from Account where name = 'Acc_Text_rec' limit 1 ];
        List<Contact> cntRecList = [Select id from contact where Email = 'anila.francis@wipro.com' limit 1 ];
        List<Case> csList =[select id from case where Classification__c = 'gcc' limit 1];
        
        List<Service_Request__c> serReqList5 = new List<Service_Request__c>();
        List<Id> serReqIds5 = new List<Id>();
        Id srRecId = Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get('SR(General)').getRecordTypeId();        
        
        Platform__c p = new Platform__c();
        p.name='Test Platform';
        p.CurrencyIsoCode = 'USD';
        p.SRD_Supported__c =true;
        
        insert p;        
       
        
        test.StartTest();
        List<Service_Request__c> serReqList7 = new List<Service_Request__c>();
        List<Id> serReqIds7 = new List<Id>();
        
        Service_Request__c SRrec7 = new Service_Request__c();
        SRrec7.Contact_Name__c = cntRecList[0].id;
        SRrec7.recordtypeid = srRecId;
        SRrec7.SR_Type__c = 'Field Event';
        SRrec7.Subject__C = 'test';
        SRrec7.Status__C = 'Open';
        SRrec7.Priority__c = 'High';
        SRrec7.Problem_Description__c = 'test';
        SRrec7.Deliverable__c = 'test';
        SRrec7.Atr__c = 'Service/Support';
        SRrec7.Attribute_Details__c = 'Product Investigation';
        SRrec7.Attribute_Sub__c = 'Field Service Support';
        SRrec7.Complexity_Level__c = '1-Part Price/Availability';
        SRrec7.Customer_Due_Date__c = system.today();        
        SRrec7.Case_Number__c = csList[0].id;
        SRrec7.Gate_2_Completed__c = system.today();
        SRrec7.CSB_Gate__c = 'Gate 3';
        SRrec7.Key_Code__c = 'test';
        SRrec7.Ownerid = Label.EPS_D_S_Queue;
        SRrec7.Date_Closed__c = system.today() + 80;
        SRrec7.X1st_18Mth_EIS__c = 'No';
        SRrec7.CUS_IFSD_21_3_FMS__c = 'No';
        SRrec7.Cust_Impact__c ='Nuisance or Work around available';
        SRrec7.Financial_12mth__c = 'None';
        SRrec7.Platforms_Affected__c = 'test';
        SRrec7.Previous_Inv__c='Recent SRD/Investigated <3 Yrs';
        SRrec7.Prod_Maturity__c='Stable';
        SRrec7.Reliability__c='At or above guarantee’s (PSAA or other)';
        SRrec7.Aircraft_Type__c = p.Id; 
        Srrec7.Legacy_Siebel_Account_Id__c = '040, Below, Rejected';
        Srrec7.Override__c= true; 
        serReqList7.add(SRrec7);      
        insert serReqList7;
        
        serReqIds7.add(serReqList7[0].Id);
        
        List<Service_Request__c> serReqList8 = new List<Service_Request__c>();
        List<Id> serReqIds8 = new List<Id>();
        
        Service_Request__c SRrec8 = new Service_Request__c();
        SRrec8.Contact_Name__c = cntRecList[0].id;
        SRrec8.recordtypeid = srRecId;
        SRrec8.SR_Type__c = 'Field Event';
        SRrec8.Subject__C = 'test';
        SRrec8.Status__C = 'Open';
        SRrec8.Priority__c = 'High';
        SRrec8.Problem_Description__c = 'test';
        SRrec8.Deliverable__c = 'test';
        SRrec8.Atr__c = 'Service/Support';
        SRrec8.Attribute_Details__c = 'Product Investigation';
        SRrec8.Attribute_Sub__c = 'Field Service Support';
        SRrec8.Complexity_Level__c = '1-Part Price/Availability';
        SRrec8.Customer_Due_Date__c = system.today();        
        SRrec8.Case_Number__c = csList[0].id;
        SRrec8.Gate_2_Completed__c = system.today();
        SRrec8.CSB_Gate__c = 'Gate 3';
        SRrec8.Key_Code__c = 'test';
        SRrec8.Ownerid = Label.EPS_D_S_Queue;
        SRrec8.Date_Closed__c = system.today() + 80;
        SRrec8.X1st_18Mth_EIS__c = 'No';
        SRrec8.CUS_IFSD_21_3_FMS__c = 'No';
        SRrec8.Cust_Impact__c ='Top 10 D&C driver';
        SRrec8.Financial_12mth__c = 'None';
        SRrec8.Platforms_Affected__c = 'test';
        SRrec8.Previous_Inv__c='Recent SRD/Investigated <3 Yrs';
        SRrec8.Prod_Maturity__c='Stable';
        SRrec8.Reliability__c='At or above guarantee’s (PSAA or other)';
        SRrec8.Aircraft_Type__c = p.Id; 
        Srrec8.Legacy_Siebel_Account_Id__c = '040, Below, Override';
        Srrec8.Override__c = false; 
        serReqList8.add(SRrec8);      
        insert serReqList8;
        
        serReqIds8.add(serReqList8[0].Id);
        test.stoptest();
        
        QFDFieldsAutoPopulation.populateQFDFieldsData(serReqList7,true,false);
        QFDFieldsAutoPopulation.populateQFDFieldsData(serReqList8,true,false);
     }   
}