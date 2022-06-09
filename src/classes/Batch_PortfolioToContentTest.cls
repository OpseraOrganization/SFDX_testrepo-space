@ISTest
public class Batch_PortfolioToContentTest {

	@IsTest static void PortfolioToContentTestMock(){
		
	
	Product_Portfolio_Item__c pi=new Product_Portfolio_Item__c();
	pi.AlternateCode__c = '3MN00029AAAA';
	pi.NSNLegacyCode__c = '833-007800';
	pi.DataUsage__c = 'SWST';
		
	Product_Portfolio_Item__c pi1=new Product_Portfolio_Item__c();
	pi1.AlternateCode__c = 'ML1-0000000002922';
	pi1.NSNLegacyCode__c = '833-007818';
	pi1.DataUsage__c = 'CARES,SWST'; 
		
	Product_Portfolio_Item__c pi2=new Product_Portfolio_Item__c();
	pi2.NSNLegacyCode__c = '833-007944';
	pi2.AlternateCode__c='3MN00107AAAA';
	pi2.DataUsage__c = '2345';
	
		
	Product2 p= new Product2();
	p.ProductCode = '833-007818';
	p.Name = 'TestProduct1';
	p.APTS_Ext_ID__c = '833-007818';
	
	insert p;
		
	Product2 p1= new Product2();
	p1.ProductCode = '833-007800';
	p1.Name = 'TestProduct2';
	p1.APTS_Ext_ID__c = '833-007800';
	
	insert p1;
		
	Product2 p2= new Product2();
	p2.ProductCode = '833-007944';
	p2.Name = 'TestProduct3';
	p2.APTS_Ext_ID__c = '833-007944';
		
	insert p2;
	
	
		
	List<Product_Portfolio_Item__c> DataList = new List<Product_Portfolio_Item__c>();
	DataList.add(pi);
	DataList.add(pi1);
	DataList.add(pi2);
		
	insert DataList;
	 
	Test.startTest();
	SchedulableContext SC = null;
	Batch_PortfolioToContent  batch= new Batch_PortfolioToContent();
	Database.BatchableContext BC;
	batch.start(BC);
	batch.execute(SC);
	batch.execute(BC, DataList);
	batch.finish(BC);
				
	Test.stopTest();
	
		
	}
   
}