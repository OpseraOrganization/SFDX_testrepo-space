/*********************************************************************
* Class Name : QTO_ProcessBlanketPoTest
* Test Class : QTO_ProcessBlanketPoTest
* Created Date: 24 Feb 2022
* Created By : Shaik Johny Basha
* Description : DSI-2410 Blanket PO chnages
*******************************************************************/
@isTest
public class QTO_ProcessBlanketPoTest {
@testsetup
	static void testSetupData() {
		List<Account> accList = QTO_TestDataFactory.createAccount(2);
		insert accList; 
		
		Customer_Document__c cd = QTO_TestDataFactory.createCustomerDocument();
		cd.Status__c = 'Draft';
		cd.Customer_Document_ID__c = '12435678';
		cd.Classification__c = 'Purchase Order';
		cd.Sub_Classification__c = 'Standard';
		cd.Nokia_Legal_Entity_Account__c = accList[0].Id;
		cd.Customer__c = accList[0].Id;
		insert cd;
		
		cd.Customer__c = accList[0].Id;
		cd.QTO_Classification__c = 'Purchase Order';
		cd.QTO_Sub_Classification__c = 'Standard';
		cd.Classification__c = 'Purchase Order';
		cd.Sub_Classification__c = 'Standard';
		cd.Status__c =  QTO_Constants.CD_STATUS_LINES_HANDOFF;
		update cd;
		
		List<Customer_Document_Line_Items__c> customerDocLines = new List<Customer_Document_Line_Items__c>();
		
		Customer_Document_Line_Items__c cdli1 = new Customer_Document_Line_Items__c();		
		cdli1.High_level_Product__c = 'My SFR Cutlery';
		cdli1.High_level_Product_Description__c = 'My SFR Bundle Description';
		cdli1.Detailed_Product__c = 'Bundle1S4ABIA';
		cdli1.Detailed_Product_Description__c = 'Test Detailed Product Description';
		cdli1.QTO_PDF_Quantity__c = '1';
		cdli1.Quantity__c = '1';
		cdli1.QTO_PDF_Unit_Of_Measure__c = 'PCE';
		cdli1.QTO_Unit_Of_Measure__c = 'PCE';
		cdli1.QTO_PDF_Unit_Price__c = '2222,00';
		cdli1.Total_Value__c = 50;
		cdli1.QTO_PDF_Currency_Code__c = 'EUR';
		cdli1.CurrencyIsoCode = 'EUR';
		cdli1.QTO_Unit_Price__c = 2222.00;
		cdli1.Customer_Document__c = cd.Id;
		customerDocLines.add(cdli1);
		insert customerDocLines;
	}
	
	@isTest
	static void procesBlanketPOTest() {
		test.startTest();
		Customer_Document__c cd = [Select Id, QTO_Customer_Name__c from Customer_Document__c limit 1];
		QTO_ProcessBlanketPo.procesBlanketPO(new Set<Id>{cd.Id});
		test.stopTest();
	}
	
	@isTest
	static void procesBlanketPOTestNatureCancel() {
		test.startTest();
		Customer_Document__c cd = [Select Id, QTO_Customer_Name__c from Customer_Document__c limit 1];
		cd.QTO_Nature__c= QTO_Constants.CANCEL;
		update cd;
		QTO_ProcessBlanketPo.procesBlanketPO(new Set<Id>{cd.Id});
		test.stopTest();
	}
	@isTest
	static void procesBlanketPOTestNatureBlankValues() {
		test.startTest();
		Customer_Document__c cd = [Select Id, QTO_Customer_Name__c from Customer_Document__c limit 1];
		cd.QTO_Nature__c= QTO_Constants.CANCEL;
		update cd;
		
		Customer_Document_Line_Items__c cdline = [Select Id, QTO_PDF_Currency_Code__c, QTO_PDF_Unit_Of_Measure__c, High_level_Product__c, High_level_Product_Description__c, Detailed_Product_Description__c, Detailed_Product__c from Customer_Document_Line_Items__c limit 1];
		cdline.QTO_PDF_Currency_Code__c = '';
		cdline.QTO_PDF_Unit_Of_Measure__c = '';
		cdline.High_level_Product__c = null;
		cdline.Detailed_Product__c = null;
		cdline.High_level_Product_Description__c = null;
		cdline.Detailed_Product_Description__c = null;
		update cdline;
		QTO_ProcessBlanketPo.procesBlanketPO(new Set<Id>{cd.Id});
		test.stopTest();
	}
}