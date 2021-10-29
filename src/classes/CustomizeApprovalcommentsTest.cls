@isTest
private class CustomizeApprovalcommentsTest{ 

static testMethod void CustomizeApprovalcomments_Testcls()
    {
        Account a1 = New Account(Name= 'sbuaccount', Strategic_Business_Unit__c = 'D&S', Market_Name__c = 'Military',  CBT__c = 'HTSI');
        insert a1;
        
        Date d1 =Date.newInstance(2009,08,12);
        
        //RecordType r1 = [select id , name from RecordType where name='Complex'];
        ID r1 = label.D_S_Complex;
        
        //RecordType r2 = [select id, name from Recordtype where name='ATR' and sobjecttype='Campaign' limit 1];
        Schema.DescribeSObjectResult campaignDesc = Schema.SObjectType.Campaign ;
        Map<String,Schema.RecordTypeInfo> campaignrtMapByName = campaignDesc.getRecordTypeInfosByName();
        Schema.RecordTypeInfo campaignRTByName = campaignrtMapByName.get('ATR');
        ID r2 = campaignRTByName.getRecordTypeId();
        
        //Campaign c1 = new Campaign( Name = 'Test Campaign', recordtypeid  = r2.id, CampaignPrimarySBU__c = 'ATR', CampaignPrimaryCBTTier2__c = 'Airbus', Type = 'AM - Catalog', IsActive = true, Account_Name__c = a1.id);
        Campaign c1 = new Campaign( Name = 'Test Campaign', recordtypeid  = r2, CampaignPrimarySBU__c = 'ATR', CampaignPrimaryCBTTier2__c = 'Airbus', Type = 'AM - Catalog', IsActive = true, Account_Name__c = a1.id);
        insert c1;      
        
        Campaign_Gate__c ct1 = new Campaign_Gate__c();
        ct1.Phase__c = 'Test Toll';
        ct1.Campaign__c = c1.id;
        ct1.Expected_Date__c = system.today() + 10;
        insert ct1;
        
        Campaign_Gate_Approval_History__c cgah = new Campaign_Gate_Approval_History__c();
        cgah.Approval_Status__c = 'Approved';
        cgah.Campaign_Phase__c = ct1.id;
        insert cgah;
    
        //Opportunity o1 = new Opportunity(Name='Complexopp',recordtypeid =r1.id,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1,ATR_Aircraft_Quantity__c = 1 );
        Opportunity o1 = new Opportunity(Name='Complexopp',recordtypeid =r1,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1,ATR_Aircraft_Quantity__c = 1 );
        insert o1;
    
        Opportunity_Gate__c OppGate = new Opportunity_Gate__c();
        OppGate.Opportunity__c=o1.id;
        insert OppGate;
    
        Opportunity_Gate_Approval_History__c OPpappHistry = new Opportunity_Gate_Approval_History__c();
        OPpappHistry.Opportunity_Gate__c=OppGate.id;
        insert OPpappHistry;
        system.debug('aaaaaaaa'+OPpappHistry.ID);

            PageReference pageRef  = Page.CustomizeApprovalcomments;
            pageRef.getParameters().put('Accept','True');
            pageRef.getParameters().put('Reject','False');
            pageRef.getParameters().put('Record',OPpappHistry.ID);
            pageRef.getParameters().put('CampaignRecord',cgah.ID);
            Test.setCurrentPage(pageRef);
            
        CustomizeApprovalcomments cust = new CustomizeApprovalcomments();
            cust.ok();
            String s = cust.getcomments();
            cust.setcomments(s);
            
            PageReference pageRef1  = Page.CustomizeApprovalcomments;
            pageRef1.getParameters().put('Accept','False');
            pageRef1.getParameters().put('Reject','True');
            pageRef1.getParameters().put('Record',OPpappHistry.ID);
            pageRef1.getParameters().put('CampaignRecord',cgah.ID);
            Test.setCurrentPage(pageRef1);
            
            CustomizeApprovalcomments cust1 = new CustomizeApprovalcomments();
            cust1.ok();
            String s1 = cust1.getcomments();
            cust1.setcomments(s1);
    }
}