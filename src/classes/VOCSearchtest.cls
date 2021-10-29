@isTest(seealldata=true)
private class VOCSearchtest {

    static testMethod void myUnitTest() 
    {
    id userid = [select id from user limit 1].id;
        id accountid = [select id from voc_accounts__c limit 1].id;
         id platformid = [select id from platform__c limit 1].id;
    Voice_of_Customer__c voc7= new Voice_of_Customer__c();
        voc7.Title__c= 'VOCTest';
        voc7.Source__c ='compitetor';
        voc7.honeywell__c = userid;
        voc7.voc_account__c = accountid;
       // vc7.oem__c = 'test';
       // vc7.ExceptionRecord.Product_Family__c= 'test';
        //vc7.ExceptionRecord.Platform__c= 'test';
        //vc7.ExceptionRecord.Other_Hoenywell_Attendees__c =  'test';
        insert voc7;
        
        Voice_of_Customer__c voc= new Voice_of_Customer__c();
        ApexPages.StandardController con = new ApexPages.StandardController(voc);
        VoiceofcustomersearchClass vc= new VoiceofcustomersearchClass(con);
        vc.Keywords = 'VOCTest';
        vc.ExceptionRecord.EndDate__c =system.today();
        vc.ExceptionRecord.voc_type__c ='anecdotal';
        vc.searchform();
        
        
        ApexPages.StandardController con4 = new ApexPages.StandardController(voc);
        VoiceofcustomersearchClass vc4= new VoiceofcustomersearchClass(con4);
        vc4.Keywords = 'VOCTest';
        vc4.ExceptionRecord.voc_type__c ='anecdotal';
        vc4.searchform();
        
        ApexPages.StandardController con1 = new ApexPages.StandardController(voc);
        VoiceofcustomersearchClass vc1= new VoiceofcustomersearchClass(con1);
        vc1.Keywords = 'VOCTest';
        vc1.clearform();
          
        ApexPages.StandardController con2 = new ApexPages.StandardController(voc);
        VoiceofcustomersearchClass vc2= new VoiceofcustomersearchClass(con2);
        vc2.Keywords = 'VOCTest';
        vc2.redirect();
        
        Voice_of_Customer__c voc1= new Voice_of_Customer__c();
        ApexPages.StandardController con3 = new ApexPages.StandardController(voc1);
        VoiceofcustomersearchClass vc3= new VoiceofcustomersearchClass(con3);
        vc3.Keywords = 'VOCTest';
        vc3.ExceptionRecord.StartDateval__c =system.today();
        vc3.searchform();
        
        Voice_of_Customer__c voc5= new Voice_of_Customer__c();
        ApexPages.StandardController con5 = new ApexPages.StandardController(voc5);
        VoiceofcustomersearchClass vc5= new VoiceofcustomersearchClass(con5);
        vc5.Keywords = 'VOCTest';
        vc5.ExceptionRecord.StartDateval__c =system.today();
        vc5.ExceptionRecord.EndDate__c =system.today()-1;
        vc5.ExceptionRecord.voc_type__c ='anecdotal';
        vc5.searchform();
        
        Voice_of_Customer__c voc6= new Voice_of_Customer__c();
        ApexPages.StandardController con6 = new ApexPages.StandardController(voc6);
        VoiceofcustomersearchClass vc6= new VoiceofcustomersearchClass(con6);
        vc6.Keywords = 'VOCTest';
        vc6.ExceptionRecord.Source__c ='compitetor';
        vc6.ExceptionRecord.honeywell__c = userid;
        vc6.ExceptionRecord.voc_account__c = accountid;
        vc6.ExceptionRecord.oem__c = 'test';
        vc6.ExceptionRecord.Product_Family__c= 'test';
        vc6.ExceptionRecord.Platform__c= platformid;
        vc6.ExceptionRecord.Other_Hoenywell_Attendees__c =  'test';
        vc6.searchform();
        
         Voice_of_Customer__c voc8= new Voice_of_Customer__c();
        ApexPages.StandardController con8 = new ApexPages.StandardController(voc8);
        VoiceofcustomersearchClass vc8= new VoiceofcustomersearchClass(con8);
        PageReference pageRef = Page.Vocsearchpage;
        pageRef.getParameters().put('strCondition','');
        Test.setCurrentPage(pageRef);
        vc8.ExceptionRecord.oem__c = 'test';
        vc8.searchform();
        
        
        
        Voice_of_Customer__c voc10= new Voice_of_Customer__c();
        ApexPages.StandardController con10 = new ApexPages.StandardController(voc10);
        VoiceofcustomersearchClass vc10= new VoiceofcustomersearchClass(con10);
         PageReference pageRef2 = Page.Vocsearchpage;
        pageRef.getParameters().put('strCondition','');
        Test.setCurrentPage(pageRef2);
        vc10.ExceptionRecord.product_family__c = 'test';
        vc10.searchform();
        
    }
}