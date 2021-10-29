@isTest
private class TestCls_ApexTrgr_UpdateDelayStatusField{
    static testMethod void Testcls_ApexTrgr_UpdateDelayStatusFieldTest(){ 
        Account acc = new Account();
        acc.Name='Tesst Account';
        acc.Customer_Status__c='Active';
        acc.Region_Name__c='Americas';
        acc.Sub_Region_Name__c='Africa';
        acc.Service_Level__c='Comprehensive';
        acc.Strategic_Business_Unit__c='ATR';
        acc.CBT__c='Airbus';
        acc.CBT_Team__c='Airbus';
        acc.Market_Name__c='Air Transport';
        acc.Business_Owner__c='Ryan, Justin';
        acc.Type='Air Cargo Transporter';
        acc.REPORT_ACCOUNT_NAME__c='Test Report';
        insert acc;
        
        Contact c= new Contact();
        c.AccountId=acc.Id;
        c.LastName='Hari';
        c.SBU_Contact__c='ACS Labs';
        c.CBT__c='ACS Sensors Lab';
        c.CBT_Team__c='ACS Advanced Sensors';
        c.Primary_Email_Address__c='test@test.com';
        c.Phone_1__c= '12345678';
        insert c; 
        
        Feedback__c fb = new Feedback__c();
        fb.Year__c = '2011';
        fb.Prod_LN_Prgm_Product_LIne__c = 'APU';
        fb.Supplier_Rating_Syst__c = 'Yes';
        fb.Quarter__c = 'Q1';
        fb.Date_of_Interview__c = system.today();
        fb.Value_Customer_Rating__c = 'Unspecified';
        fb.Delivery_Customer_Rating__c = 'Green - Satisfied';
        fb.Quality_Customer_Rating__c = 'Blue - Best in class';
        fb.Reliability_Customer_Rating__c = 'Red - Very Dissatisfied';
        fb.Responsiveness_Customer_Rating__c = 'Unspecified';
        fb.Service_Support_Customer_Rating__c = 'Green - Satisfied';
        fb.Development_Customer_Rating__c = 'Unspecified';
        try{
        insert fb;
        }catch(DMLException ee){}
        
        Service_Request__c sr = new Service_Request__c();
        sr.Subject__c = 'test';
        sr.SR_Type__c = 'GDC';
        sr.Priority__c = 'High';
        sr.Status__c = 'Closed';
        sr.Problem_Description__c = 'test';
        sr.Deliverable__c = 'test';
        sr.Customer_Due_Date__c = System.today()+1;
        //sr.HON_Commit_Date__c = system.today()+1;
        sr.Atr__c = 'Value';
        sr.Complexity_Level__c='1-Part Price/Availability';
        sr.Risk_Assessment__c = 'Red';
        sr.ATR_Other__c = true;
        sr.BGA_Other__c = true;
        sr.D_S_Other__c = true;
        sr.Delay_Status__c = 'None';
        sr.ATR_checkbox__c = true;
        sr.BGA__c = true;
        sr.Attribute_Sub__c = 'Contracts';
        sr.Attribute_Details__c = 'Late';
        sr.Contact_Name__c = c.id;
        sr.VOC_Card_Numb__c = fb.Name;
       
        insert sr;
        sr.Subject__c = 'testing';
        sr.SR_Type__c = 'VOC';
        sr.Priority__c = 'AOG';
        sr.Status__c = 'Open';
        sr.Problem_Description__c = 'testing';
        sr.Deliverable__c = 'testing';
        sr.Customer_Due_Date__c = System.today()+2;
        //sr.HON_Commit_Date__c = system.today()+2;
        sr.Atr__c = 'Quality';
        sr.Complexity_Level__c='2-Technical Lookup-Simple';
        sr.Risk_Assessment__c = 'Green';
        sr.ATR_Other__c = true;
        sr.BGA_Other__c = true;
        sr.D_S_Other__c = true;
        sr.Delay_Status__c = 'Delayed';
        sr.ATR_checkbox__c = true;
        sr.BGA__c = true;
        sr.Attribute_Sub__c = 'Hardware';
        sr.Attribute_Details__c = 'Credit Hold';
        sr.Contact_Name__c = c.id;
        sr.VOC_Card_Numb__c = fb.Name;
        sr.Customer_Reason_Change__c = 'Original';
        sr.Commit_Date_Reason_Change__c = 'Original';
        update sr;
        
        Reason_for_Delay__c rfd = new Reason_for_Delay__c();
        rfd.Name = 'Test';
        rfd.Start_Date__c = system.today();
        rfd.Status__c = 'Open';
        rfd.Service_Request__c = sr.Name;
        insert rfd;
        
        rfd.Start_Date__c = system.today()+5;
        rfd.Status__c = 'Closed';
        rfd.Service_Request__c = sr.Id;
        update rfd;
        
        rfd.Start_Date__c = system.today()+6;
        rfd.Status__c = 'Open';
        rfd.Service_Request__c = sr.Id;
        update rfd;
    }
}