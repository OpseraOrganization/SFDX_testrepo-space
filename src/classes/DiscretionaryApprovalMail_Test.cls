@isTest(seeAllData = true)
private class DiscretionaryApprovalMail_Test{ 

    static testMethod void discretionaryApprovalMailTesst()
    {
        Discretionary__c disc = new Discretionary__c();
        disc.Estimated_Completion_Date__c=system.today();
        insert disc;
        
        Discretionary_Line_Item__c li = new Discretionary_Line_Item__c();
        li.Requested_Amount__c=100;
        li.Discretionary_Request__c = disc.id;
        insert li;
        
        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        System.currentPageReference().getParameters().put('id', disc.id);

        ApexPages.StandardController sc = new ApexPages.StandardController(disc);
        DiscretionaryApprovalMail dam = new DiscretionaryApprovalMail(sc);
        dam.sendMail();
        dam.Back();
    }
    static testMethod void discretionaryApprovalMailTesst1()
    {
        Discretionary__c disc = new Discretionary__c();
        disc.Estimated_Completion_Date__c=system.today();
        disc.Approval_Status__c = 'Rejected';
        insert disc;
        
        
        
        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        System.currentPageReference().getParameters().put('id', disc.id);

        ApexPages.StandardController sc = new ApexPages.StandardController(disc);
        DiscretionaryApprovalMail dam = new DiscretionaryApprovalMail(sc);
        dam.sendMail();
        dam.Back();
    }
}