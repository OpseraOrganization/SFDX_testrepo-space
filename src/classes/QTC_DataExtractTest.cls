@isTest
public  with sharing class QTC_DataExtractTest {
	public static product2 prod1 = new product2();
	public static set<Id> prodset = new set<Id>();
	public static List<Id> prodlist = new List<Id>();
	@testSetup 
	Public static void Testdata(){
			List<User> sysAdminUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'System Administrator');
	System.runAs(sysAdminUser[0]){
	CPQ_Enterprise_Customer_Floor_Price__mdt cfp = new CPQ_Enterprise_Customer_Floor_Price__mdt();
	cfp.account_number__c = '30110456';
	cfp.Label = 'TestData';
	cfp.Type__c = 'PDC';
	
	
			prod1.name = 'A2';
			prod1.CurrencyIsoCode = 'EUR';
	//  prod1.Business_Group__c='FN';
			prod1.Family= 'A&A-CEM';
			prod1.IsActive=True;
			prod1.Partner_Visible__c=True;
			prod1.ProductCode='3HE10869AAAA';
			prod1.Apttus_Config2__Version__c= 1;
			prod1.Portfolio__c= 'Fixed Access - FBA';
			prod1.Pricing_Clusters__c='NAM';
			prod1.IsActive= True;
			insert prod1;
	Product_Extension__c PDE1 = new Product_Extension__c();
	PDE1.Floor_Price__c = 300;
	PDE1.Business_Group__c = 'ION';
	PDE1.Market__c = 'Market NAM';
	PDE1.Stream__c = 'QTC';
	PDE1.Product__c = prod1.id;
	insert PDE1;
		 }}
	public static testMethod void Testmethod1(){
	test.startTest();
	
	prodset.add(prod1.id);
			
	
	List<Product_Extension__c> pde  = QTC_DataExtract.getrelatedproductextensions(prodset,'USD','USD','IP Routing','30110456');
	List<Product_Extension__c> pde1  = QTC_DataExtract.getrelatedproductextensions(prodset,'USD','USD','IP Routing','30110453');
	List<Product_Extension__c> pde2  = QTC_DataExtract.getrelatedproductextensions(prodset,'USD','USD','QTC','30110453');
	 List<Product_Extension__c> NCQpde  = QTC_DataExtract.getrelatedNCQproductextensions(prodset,'USD');
	List<Product_Extension__c> NCQpde1  = QTC_DataExtract.getrelatedNCQproductextensions(prodset,'EUR');
	List<product2> NCQpde2  = QTC_DataExtract.getrelatedproductList(prodset); 
	
	test.stopTest();
}

}