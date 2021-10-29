/***********************************************************
Name            :   SAPtoSFDCPaymentTermsTest
Created By      :   Harikishore V
Company Name    :   NTTData
Created Date    :   13-April-2017
Usages          :   Test class for SAPtoSFDCPaymentTerms
************************************************************/
@isTest(SeeALLData=true)
public class SAPtoSFDCPaymentTermsTest{ 
    testMethod static void SAPtoSFDCPaymentTermsTest(){
        SAPtoSFDCPaymentTerms.PaymentInfoSAPtoSFDC sf = new SAPtoSFDCPaymentTerms.PaymentInfoSAPtoSFDC();
        sf.System_Date = '04/13/2017';
        sf.Customer_Num = '0000000391';
        sf.PaymentTerm_Newvalue = 'test payment term';
        sf.PaymentTerm_Desc = 'test payment description';
        sf.Sales_Org = '1000';
        sf.Distribution_Channel = '01';
        sf.Division = '01';
        sf.CRM_ID = 'test';
        
        List<Account> acc = new List<Account>();
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.SalesOrg_Distribution_Channel_Division__c ='Test';
        acc.add(ac);
        
        insert acc;
        
        List<Account_Cross_Ref__c> accName = new List<Account_Cross_Ref__c>();
        Account_Cross_Ref__c accCross = new Account_Cross_Ref__c();
		accCross.Account_Name__c = ac.id;  
        accCross.XREF_Type__c = 'SAP_SOLD_TO';
        accCross.External_Account_ID__c = sf.Customer_Num;
        accCross.Site_Code__c =sf.Customer_Num;
        accName.add(accCross);
        insert accCross;
        system.debug('accCross==>'+accCross);
        
        SAPtoSFDCPaymentTerms.ResponseToSAP acdata = SAPtoSFDCPaymentTerms.updateAccount(sf);
        
        SAPtoSFDCPaymentTerms.PaymentInfoSAPtoSFDC sf1 = new SAPtoSFDCPaymentTerms.PaymentInfoSAPtoSFDC();
        sf1.System_Date = '04/13/2017';
        sf1.Customer_Num = '300310';
        sf1.PaymentTerm_Newvalue = 'test payment term';
        sf1.PaymentTerm_Desc = 'test payment description';
        sf1.Sales_Org = '1000';
        sf1.Distribution_Channel = '01';
        sf1.Division = '01';
        sf1.CRM_ID = 'test';
        
        List<Account> acc1 = new List<Account>();
        Account ac1 = new Account();
        ac1.Name = 'Test Account';
        
        acc1.add(ac1);
        
        insert acc1;
        
        List<Account_Cross_Ref__c> accName1 = new List<Account_Cross_Ref__c>();
        Account_Cross_Ref__c accCross1 = new Account_Cross_Ref__c();
		accCross1.Account_Name__c = ac.id;  
        accCross1.XREF_Type__c = 'SAP_SOLD_TO';
        accCross1.External_Account_ID__c = sf1.Customer_Num;
        accCross1.Site_Code__c =sf.Customer_Num;
        accName1.add(accCross1);
        insert accName1;
        system.debug('accCross==>'+accCross);
        SAPtoSFDCPaymentTerms.ResponseToSAP acdata1 = SAPtoSFDCPaymentTerms.updateAccount(sf1);
        
        SAPtoSFDCPaymentTerms.PaymentInfoSAPtoSFDC sf11 = new SAPtoSFDCPaymentTerms.PaymentInfoSAPtoSFDC();
        sf11.System_Date = '04/13/2017';
        sf11.Customer_Num = '0000000000';
        sf11.PaymentTerm_Newvalue = 'test payment term';
        sf11.PaymentTerm_Desc = 'test payment description';
        sf11.Sales_Org = '1000';
        sf11.Distribution_Channel = '01';
        sf11.Division = '01';
        sf11.CRM_ID = 'test';
        
        
        
        SAPtoSFDCPaymentTerms.ResponseToSAP acdata11 = SAPtoSFDCPaymentTerms.updateAccount(sf11);
         date d = SAPtoSFDCPaymentTerms.stringToDate('12/27/2015');
    }
}