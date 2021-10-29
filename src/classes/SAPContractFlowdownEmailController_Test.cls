@istest
public class SAPContractFlowdownEmailController_Test {
    public static testmethod void getdetails(){
        Id recordTypeIdcs = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Contract Administration').getRecordTypeId();
        Id recordTypeIdContr = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Contracts').getRecordTypeId();
        Account acc = new Account();
        acc.name = 'test';
        insert acc;
        Contract ctr = new Contract();
		ctr.RecordTypeId = recordTypeIdContr;  
        ctr.Type__c = 'APM';
        ctr.Contract_Number_I_Many__c = '12345';
        ctr.Asset_Program__c = 'Yes';
        ctr.Status = 'Draft';
        ctr.StartDate = System.today();
        ctr.End_date_Required__c = 'Yes';
        ctr.EndDate = System.today()+1;
        ctr.Revision__c = '2';
        ctr.Currency__c = 'USD';
        ctr.AccountId = acc.id;
        insert ctr;
        Case cs = new Case();
        cs.RecordTypeId = recordTypeIdcs;
        cs.Origin = 'Phone';
        cs.Export_Compliance_Content_ITAR_EAR__c = 'Yes';
        cs.Government_Compliance_SM_M_Content__c = 'Yes';
        cs.Status = 'Open';
        cs.Classification__c = 'Other';
        cs.Type = 'Commercial';
        cs.Serv_Contract__c = ctr.id;
        insert cs;
        Performing_Site__c prf = new Performing_Site__c();
        prf.Contract_Number__c = ctr.id;
        prf.Type__c = 'R&O';
        prf.Sales_Office__c = 'Test';
        prf.Finance_Reserve__c = 'Yes';
        insert prf;
        
        Test.StartTest(); 
			ApexPages.StandardController sc = new ApexPages.StandardController(cs);
			SAPContractFlowdownEmailController obj = new SAPContractFlowdownEmailController();
        	obj.Casid = cs.id;
			List<Performing_Site__c> lstperfms = obj.perfms;
		Test.StopTest();
    }
}