@isTest
/****************************************
* Name : DS_GetQuoteLITest 
* Author : Accenture
* Description : Test class DS_GetQuoteLI 
*****************************************/
private with sharing class DS_GetQuoteLITest {
/******************************
	*Method Name: getLineItemRecTest
	*Description: Test Method to cover getLineItemRec method
	********************************/
	
	Public Static String prodCode = '1AF24258AAAA';
	Public Static String prodCode2 = '';

	Static testMethod void getLineItemRecTest(){
		List<Product_Feature_Junction__c> FJListReturn = new LIST<Product_Feature_Junction__c>();
		FJListReturn = DS_GetQuoteLI.getLineItemRec(prodCode);
		DS_GetQuoteLI.getLineItemRec(prodCode2);
		
	}
	Static testMethod void callGetLineItemRecTest(){
		DS_GetQuoteLI.getLineItemRec(null);
	}
	
}