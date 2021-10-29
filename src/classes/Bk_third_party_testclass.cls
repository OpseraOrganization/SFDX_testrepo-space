@isTest(SeeAllData=true)
private class Bk_third_party_testclass {
    static testMethod void Tstcls_Bk_thirdparty_Form_class1(){
     Test.StartTest();
        PageReference pageRef1  = Page.BKThirdPartyTecIssueform;
        pageRef1.getParameters().put('Requestor_Email_Address__c','kayalvizhi.kandasamy@nttdata.com');
        Test.setCurrentPage(pageRef1);
        Case cc = new Case();
        //cc.Requestor_Email_Address__c = 'kayalvizhi.kandasamy@nttdata.com';
         system.debug('Case :'+cc);
        bkthirdpartyclass cpa = new bkthirdpartyclass(new ApexPages.StandardController(cc));
        cpa.savecase();
        Test.StopTest();
    }
    static testMethod void Tstcls_Bk_thirdparty_Form_class2(){
        Test.StartTest();
        
        PageReference pageRef1  = Page.BKThirdPartyTecIssueform;
        pageRef1.getParameters().put('EmailAddress','harikishore.vutukuri@honeywell.com');
         Test.setCurrentPage(pageRef1);
        Case cc = new Case();
           bkthirdpartyclass cpa = new    bkthirdpartyclass(new ApexPages.StandardController(cc));
        cpa.cancelform();
        PageReference pageRef2  = Page.casesubmitBkthirdparty;
        Test.setCurrentPage(pageRef2);
       casesubmitbkthirdpartyclass cs = new casesubmitbkthirdpartyclass();
        cs.closeform();
            
        Test.StopTest();
    }

}