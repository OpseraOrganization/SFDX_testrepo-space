@isTest
private class ExternalDS_NCP_GlobalSearchConnTest {
	@testSetup static void setup() {
		NCP_CustomerCommunitySetting__c setting = NCP_TestFactory.insertCustomSetting();
		Product2 productRecord = NCP_TestFactory.createProductWithName('Test');
		//PMD_Product_Item_Type__c = Design Item,Service Design Item,Complementary Item,NSN Solution
		//PMD_Portfolio_Classification__c = Product,Service Product,Complementary Product,Solution
		System.assertNotEquals(null, setting, 'Assertion');
	}
	@isTest
	static void testConnection() {
		DataSource.ConnectionParams connectionParams = new DataSource.ConnectionParams();
		DataSource.SearchContext searchcontext = new DataSource.SearchContext();
		searchcontext.searchPhrase ='Test';
		DataSource.QueryContext context = new DataSource.QueryContext();

		//create the filter class and set the ColumnName
		DataSource.Filter prodFilter = new DataSource.Filter();
		prodFilter.columnName = 'ExternalId';
		
		//create the filter class and set the ColumnName
		DataSource.Filter knowledgeFilter = new DataSource.Filter();
		knowledgeFilter.columnName = 'ExternalId';
		
		//create the TableSelection class, set the filter and add it to the QueryContext
		DataSource.TableSelection productTableSelection = new DataSource.TableSelection();
		productTableSelection.tableSelected = 'NCP_Product';
		productTableSelection.filter = prodFilter;
		searchcontext.tableSelections = new List<DataSource.TableSelection> {productTableSelection};
			
		//create the TableSelection class, set the filter and add it to the QueryContext
		DataSource.TableSelection knowledgeTableSelection = new DataSource.TableSelection();
		knowledgeTableSelection.tableSelected = 'NCP_Knowledge';
		knowledgeTableSelection.filter = knowledgeFilter;
		searchcontext.tableSelections.add(knowledgeTableSelection);

		Test.startTest();
		ExternalDS_NCP_GlobalSearch_Connection globalSearchConnection = new ExternalDS_NCP_GlobalSearch_Connection(connectionParams);
		globalSearchConnection.sync();
		//globalSearchConnection.query(context);
		List<DataSource.TableResult> tableResultData = globalSearchConnection.search(searchcontext);
		System.assertEquals(2, tableResultData?.size(), 'Found one record');
		Product2 productRecord = [SELECT Id, Name, NCP_Marketing_Text__c FROM Product2 WHERE Name = 'Test'];
		globalSearchConnection.createRow(productRecord, 'Product2');
		Test.stopTest();
	}
}