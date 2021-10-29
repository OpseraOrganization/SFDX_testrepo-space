@isTest(SeeAllData=true)
global class CaseNumberfromSAPtoSFDCTest{
	testMethod static void testgetCaseNumbers() {
       
        
        list<Case> sfdcCase = new list<Case>();
        Case cas = new Case();
        cas.Origin = 'XML Order';
        cas.Status = 'Open';
        cas.Sales_Order_Number__c = '0000012346';
        sfdcCase.add(cas);
        insert sfdcCase;
        
        CaseNumberfromSAPtoSFDC.CaseFieldsToRetrieve casedata = new CaseNumberfromSAPtoSFDC.CaseFieldsToRetrieve();
        casedata.SalesOrderNum = cas.Sales_Order_Number__c;
        
        test.starttest();
    		List<CaseNumberfromSAPtoSFDC.CaseNumSFDCtoSAP> retunData = CaseNumberfromSAPtoSFDC.getCaseNumbers(casedata);
    	test.stopTest();
    }
    testMethod static void testgetCaseNumbers2() {
       
        
        list<Case> sfdcCase = new list<Case>();
        Case cas = new Case();
        cas.Origin = 'XML Order';
        cas.Status = 'Open';
        cas.Sales_Order_Number__c = '0000012346';
        sfdcCase.add(cas);
        insert sfdcCase;
        
        CaseNumberfromSAPtoSFDC.CaseFieldsToRetrieve casedata1 = new CaseNumberfromSAPtoSFDC.CaseFieldsToRetrieve();
        casedata1.SalesOrderNum = ',';
        
        test.starttest();
    
        	List<CaseNumberfromSAPtoSFDC.CaseNumSFDCtoSAP> retunData1 = CaseNumberfromSAPtoSFDC.getCaseNumbers(casedata1);
    	test.stopTest();
    }

}