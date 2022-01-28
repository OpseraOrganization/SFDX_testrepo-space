@IsTest 
public class QTO_CDToCDComparisonControllerTest {
	@isTest
	private static void positiveTest() {
		
	Customer_Document__c cd = QTO_TestDataFactory.createCustomerDocument();
		cd.Customer_Document_Id__c = '672338872039';
		
		insert cd;
		System.debug('cd:::::' + cd);
	   
		List<Customer_Document_Line_Items__c> cdLines = new List<Customer_Document_Line_Items__c>();
	   Customer_Document_Line_Items__c cdLine = QTO_TestDataFactory.createCustomerDocumentLineItem(cd);
	   cdLine.Contract_Item_Number__c = 'ABCD';
	   cdLines.add(cdLine); 
	   System.debug('cdLine:::::' + cdLine);
	   
	   Customer_Document__c nCd = QTO_TestDataFactory.createCustomerDocument();
	   nCd.Customer_Document_Id__c = '672338872039';
	   insert nCd; 
		
	   System.debug('ncd:::::' + nCd);
	   Customer_Document_Line_Items__c nCdLine = QTO_TestDataFactory.createCustomerDocumentLineItem(nCd);
	   nCdLine.Contract_Item_Number__c = 'ABCD';
	   
		cdLines.add(nCdLine); 
		
		insert cdLines;
		
	   System.debug('nCdLine:::::' + nCdLine);
		
	   CD_Association_to_CD__c associationRec = new CD_Association_to_CD__c();
		
	   associationRec.QTO_Nokia_Customer_Document_ID__c = nCd.Id;
	   associationRec.Customer_Document__c = cd.Id;
	   
	   insert associationRec;
	   System.debug('associationRec:::::' + associationRec);
		
	   
		QTO_CDToCDComparisonController.retriveCdDocuments(associationRec.Id);
	}
}