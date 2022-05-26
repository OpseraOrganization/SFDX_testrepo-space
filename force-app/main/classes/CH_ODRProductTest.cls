/***************************************************************
* Class Name : CH_ODRProductTest
* Created Date: 28 May 2019
* Description : Test class for CH_ODRProduct
***************************************************************/
@IsTest
public class CH_ODRProductTest {
	  /*
	  cover methods in CH_ODRProduct - method fetchProduct,builtPicklistString,fetchUnits and OdrUnitsdata
	*/
   
	public testMethod static void fetchProductTest(){
	   List<Case> caseList = new List<Case>();
	   caseList = CAPS_TestDataUtil.createCaseRecord(1);
	   insert caseList;
	   
		/***ODR Product Unit Data****/ 
		CH_ODRProductUnitsData__c c1=new CH_ODRProductUnitsData__c();
		c1.Name ='Test';
		c1.Product__c ='SLN 2000';
		c1.Unit__c = 'SLN 2000';
		insert c1;
	  
		CH_OutageDuration__c outageId = new CH_OutageDuration__c();
		outageId.CH_SupportTicket__c=caseList[0].Id;
		insert outageId;
		test.startTest();
	  
		CH_ODRProduct.fetchProduct('SLN 2000');
		CH_ODRProduct.builtPicklistString('SLN 2000');
		CH_ODRProduct.builtPicklistString('SLN 2001');
		CH_ODRProduct.fetchUnits('SLN', 'SLN 2000');
		CH_ODRProduct.OdrUnitsdata( outageId.Id, 'SLN 2000', 'SLN 2000');
		CH_ODRProduct.getProductFromCase(caseList[0].Id);
		test.stopTest();
		
		
	}
	
}