@isTest(SeeAllData=true)
private class TstCls_ApxCls_CloneButtToClearDateFields
{
    static testMethod void testCloneButtonToClearDateFields()
    {
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
        
        ID newRecordId;
        Service_Request__c sr = new Service_Request__c();
        sr.Subject__c = 'test';
        sr.SR_Type__c = 'Delivery';
        sr.Priority__c = 'High';
        sr.Status__c = 'Monitor';
        sr.Problem_Description__c = 'Hello';
        sr.Deliverable__c = 'Hii';
        sr.Contact_Name__c = c.id;
        sr.VOC_Card_Numb__c = fb.name;
        sr.Account_Name__c = acc.id;
        sr.Customer_Due_Date__c = system.today()+2;
        sr.Customer_Reason_Change__c = 'Not on list';
        sr.Atr__c = 'Quality';
        sr.Attribute_Sub__c = 'Hardware';
        sr.Attribute_Details__c = 'FAA';
        sr.Complexity_Level__c = '3-Business Issues-NonTechnical';
        //sr.HON_Commit_Date__c = system.today()+2;
        sr.Commit_Date_Reason_Change__c = 'Original';
        sr.ATR_checkbox__c = true;
        insert sr;
        Service_Request__c newsr;
        newsr = sr.clone(false);
        insert newsr;
        newRecordId = newsr.id;
        
        PageReference pageRef = Page.ClonePage;
        Test.setCurrentPage(pageRef);
        ApexPages.standardController controller = new ApexPages.standardController(sr);
        CloneButtonToClearDateFields pag = new CloneButtonToClearDateFields(controller); 
        pag.srCloneWithoutDateFields();
        
    }
}