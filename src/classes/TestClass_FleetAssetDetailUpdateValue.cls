/**********************************************************************************
Name         : TestClass_FleetAssetDetailUpdateValue
Created By   :Mythreyee Sureshkumar 
company Name :
Project      :Aero sales
created Date :4/24/2013 
Usages       :This test class to test the update value of fleetAsset
**********************************************************************************/

@isTest
private class TestClass_FleetAssetDetailUpdateValue {
    
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
  
        test.starttest();
        
        Contact CntRec = new Contact();
        CntRec.Accountid = AccRec.id;
        CntRec.FirstName = 'Testing';
        CntRec.LastName = 'Check';
        CntRec.Email = 'anila.francis@wipro.com';
        insert CntRec;
       test.stoptest();
        
       /* Case ca = new Case();
        ca.Recordtypeid = label.General_RT_ID;
        ca.Origin = 'phone';
        ca.Export_Compliance_Content_ITAR_EAR__c = 'No';
        ca.Government_Compliance_SM_M_Content__c = 'No';
        ca.Classification__c = 'gcc';
        ca.type = 'Other';
        ca.status = 'Open';
        ca.Contact = CntRec;
        insert ca;*/
        
       
        
        List<Service_Request__c> serReqList = new List<Service_Request__c>();
        
        Service_Request__c SRrec = new Service_Request__c();
        SRrec.Contact_Name__c = CntRec.id;
        SRrec.recordtypeid = '01213000001WHo8';
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
       // SRrec.Case_Number__c = ca.id;
        SRrec.Ownerid = label.EPS_ATR_Queue;
        SRrec.Gate_1_Completion_Date__c = system.today();
        SRrec.CSB_Gate__c = 'test';
        SRrec.X1st_18Mth_EIS__c = 'No';
        SRrec.CUS_IFSD_21_3_FMS__c = 'Yes';
        SRrec.Cust_Impact__c ='Top 10 D&C driver';
        SRrec.Financial_12mth__c = '$100K to $250K';
        SRrec.Previous_Inv__c='Recent SRD/Investigated <5 Yrs';
        SRrec.Prod_Maturity__c='Stable';
        SRrec.Reliability__c='At or above guarantee’s (PSAA or other)';
        
        serReqList.add(SRrec);
        
        insert serReqList;
        
      
    }
    static testMethod void TestMthd_FleetAssetDetailUpdateValue() 
    {
       test.starttest();
        Platform__c parentpltFrm = new Platform__c(name='Test Platform');
        insert parentpltFrm;
        
        Platform__c pltFrm1 = new Platform__c(name='Test Platform 1');
        insert pltFrm1;
        
        Platform__c pltFrm2 = new Platform__c(name='Test Platform2',Parent_Platform__c = parentpltFrm.Id);
        insert pltFrm2;
        
        pltFrm2.Parent_Platform__c = pltFrm1.Id;
        update pltFrm2; 
        
        Fleet_Asset_Detail__c fltast = new Fleet_Asset_Detail__c(Name = 'Test Fleet Asset',Tail_Number__c = '5555',Serial_Number__c = '6666',Platform_Name__c=parentpltFrm.id);
        insert fltast;
        
        Account acc = new Account();
        acc.Name = 'Honeywell Test';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'D&S';
        acc.CBT__c = 'DAA';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';        
        insert acc; 
        
        Contact con = new Contact();
        con.LastName = 'Velmurugan';
        con.FirstName = 'Sindhuja';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sindhuja11.velmurugan@nttdata.com';
        con.Email='sindhuja@nttdata.com';
        insert con;
        
        Map<String,ID> profiles = new Map<String,ID>();
        List<Profile> ps = [select id, name from Profile where name ='Standard User' or name = 'System Administrator'];
        
        for(Profile p : ps){
         profiles.put(p.name, p.id);
        }
       
      User standard = new User(alias = 'standt', 
      email='standarduser@testorg.com', 
      emailencodingkey='UTF-8', 
      lastname='Testing', languagelocalekey='en_US', 
      localesidkey='en_US', 
      profileid = profiles.get('Standard User'), 
      timezonesidkey='America/Los_Angeles', 
      username='standard1@testorg.com', EMPLOYEENUMBER ='E085790');

      insert standard;
        
        
        Case objcase1 = new Case();        
        objcase1.Aircraft_Name__c = fltast.id;
        objcase1.Status = 'Open';
        objcase1.Due_Date__c = system.today();
        //objcase1.No_FCR_Reason__c = 'Research'; For Ticket INC000009687923
        insert objcase1;
        
        fltast.Tail_Number__c = '9999';
        fltast.Serial_Number__c = '3333';
        update fltast;
        test.stoptest(); 
    }
    
     static testMethod void TestMthd_Method1()
     {
        Platform__c parentpltFrm = new Platform__c(name='Test Platform',SRD_Supported__c =false);
        insert parentpltFrm;
        
        
        List<Id> serReqIds = new List<Id>();
        
        List<Service_Request__c> serReqList1 =[select id from Service_Request__c where SR_Type__c = 'Field Event' limit 1 ];
        List<Account> AccRecList = [Select id from Account where name = 'Acc_Text_rec' limit 1 ];
        //List<Contact> cntRecList = [Select id from contact where Email = 'anila.francis@wipro.com' limit 1 ];
        //List<Case> csList =[select id from case where Classification__c = 'gcc' limit 1];
        
        
        
        test.starttest();
        Aircraft_Platforms_Affected__c airPlatAffec = new Aircraft_Platforms_Affected__c(
                                    Aircraft_Platforms_Affected__c = parentpltFrm.id,
                                    Service_Request__c = serReqList1[0].Id);
                
        insert airPlatAffec;  
        
        parentpltFrm.SRD_Supported__c = true;         
        
        //update parentpltFrm;
                        
        test.stoptest();  
       
     }
}