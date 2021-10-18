@isTest
private class ExternalDS_ConnectionTest {
	
	@isTest
	static void testQuery_MIKA() {
	   
	//create MIKA Custom Setting
	MikaAuthentication__c csMikaAuthentication = new MikaAuthentication__c();
		csMikaAuthentication.Name = 'basic';
		csMikaAuthentication.external_src_url__c = 'https://staging-mika.nokia.com:8080/ssp-api/rest/opensearch/';
		csMikaAuthentication.post_external_src_url__c = 'https://staging-mika.nokia.com:8080/ssp-api/rest/search/id/';
		csMikaAuthentication.password__c = 'c3NwOnNzcC1wYXNz';
		csMikaAuthentication.username__c = 'ssp';
		insert csMikaAuthentication;
		
	//create the QueryContext class
	DataSource.QueryContext context = new DataSource.QueryContext();
	DataSource.ConnectionParams connectionParams = new DataSource.ConnectionParams();
	
	//create the filter class and set the ColumnName
	DataSource.Filter filter = new DataSource.Filter();
	filter.columnName = 'ExternalId';
	
	//create the TableSelection class, set the filter and add it to the QueryContext
	DataSource.TableSelection tableSelection = new DataSource.TableSelection();
	tableSelection.tableSelected = 'NIDD KPIs';
	tableSelection.filter = filter;
	context.TableSelection = tableSelection;
		
	// tell the Testing framework to use the ConnectionMock for all Http Callouts in this test
	Test.setMock(HttpCalloutMock.class, new ExternalDS_HttpCalloutMock(true));
	Test.startTest();
	ExternalDS_MIKA connection = new ExternalDS_MIKA(connectionParams);
		connection.sync();
	Test.stopTest();
	}
}