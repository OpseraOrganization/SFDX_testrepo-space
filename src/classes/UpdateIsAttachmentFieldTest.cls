@isTest
private class UpdateIsAttachmentFieldTest{
    static testmethod void myUnitTest(){

    date testdate = System.today();
    Account acc = new Account();
    acc.Name = 'Honeywell Test';
    acc.Customer_Status__c = 'Active';
    acc.Strategic_Business_Unit__c = 'ATR';
    acc.CBT__c = 'Airbus';
    acc.Region_Name__c = 'Americas';
    acc.Sub_Region_Name__c = 'Canada';
    acc.Service_Level__c = 'Standard';
    acc.Type = 'OEM';
    acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';

    insert acc;

    Contact con = new Contact();
    con.LastName = 'Singh';
    con.FirstName = 'Kapil';
    con.AccountId = acc.Id;
    con.Primary_Email_Address__c = 'kapil.nowhere@gmail.com';
    con.Email='kapil.nowhere@gmail.com';
    insert con;

    Case cs = new Case();
    cs.Origin = 'Phone';
    cs.Status = 'Open';
    cs.ContactId = con.Id;
    cs.Classification__c = 'GTO Field Service';
    cs.HON_Commit_Date__c = System.now() + 1;
    cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
    cs.Government_Compliance_SM_M_Content__c = 'NO';
    //cs.No_FCR_Reason__c='test'; For Ticket INC000009687923
    Attachment at3;
    try {
            insert cs;
              
            Blob b3=Blob.valueOf('test Body');
            at3=new Attachment();
            at3.name='Test attachment';
            at3.body=b3;
            at3.ParentId=cs.id;
            insert at3;
                  
                   
        }catch(Exception ex){
           System.debug('Exception == '+ex);     
         }
    Event__c evt = new Event__c();
    evt.Name = 'Test Event';
    insert evt;


    Test.startTest();

    Blob b2=Blob.valueOf('test Body');
    Attachment at2=new Attachment();
    at2.name='Test attachment';
    at2.body=b2;
    at2.ParentId=evt.id;
    insert at2;

    Planned_Meeting__c pm = new Planned_Meeting__c();
    pm.Assigned_To__c = [SELECT id FROM User limit 1].Id;
    pm.Name = 'Test PM';
    pm.Location__c = 'Bangalore';
    pm.Start_Date__c = testdate;
    pm.End_Date__c = testdate;
    pm.Meeting_Purpose__c = 'Test meeting';
    pm.SBU__c = 'ATR';
    pm.CBT__c = 'Airbus';

    insert pm;

    ENZ__FTPAttachment__c ftpa4=new ENZ__FTPAttachment__c();
    ftpa4.name='Test FTP attachment';
    ftpa4.Planned_Meeting__c=pm.id;
    insert ftpa4;

    Blob b1=Blob.valueOf('test Body');
    Attachment at1=new Attachment();
    at1.name='Test attachment';
    at1.body=b1;
    at1.ParentId=pm.id;
    insert at1;

    Opportunity opp = new Opportunity();
    opp.Name = 'Test Method Opportunity';
    opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND name like '%D&S PrePriced' limit 1].Id;
    opp.SBU__c = 'ATR';
    opp.CBT_Tier_2__c = 'Airbus';
    opp.AccountId = acc.Id;
    opp.End_User__c = acc.Id;
    opp.Prime_Sub__c = 'Prime';
    opp.StageName = 'Cultivate';
    opp.CloseDate = testdate;
    opp.Revenue_Type__c = 'ENG';
    opp.Bid_Type_Name__c = 'LTA';
    opp.International_Code__c = 'FMS';
    opp.Incumbent__c = 'Incumbent';
    opp.RMU__c = 'YES';
    opp.Tech_Sales_Product_Area__c='APU';
    opp.IC_Scorecard_Opportunity__c = false;
    insert opp;

    Blob b=Blob.valueOf('test Body');
    Attachment at=new Attachment();
    at.name='Test attachment';
    at.body=b;
    at.ParentId=opp.id;
    insert at;
    List<Attachment> attList=new List<Attachment>();
    if(at3!=null){
        attList.add(at3);
    }
    if(at2!=null){
        attList.add(at2);
    }
    if(attList!=null && attList.size()>0){
        delete attList;
    }
    Test.stopTest();
    }
}