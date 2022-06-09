@isTest 
private class ExternalDS_ConnectionTest {
	
	@isTest 
	static void testQuery_NDA() {   
	//create the QueryContext class
		DataSource.QueryContext context = new DataSource.QueryContext();
		DataSource.ConnectionParams connectionParams = new DataSource.ConnectionParams();
		DataSource.SearchContext searchcontext=new DataSource.SearchContext();
		searchcontext.searchPhrase ='Service Port';
		
		//create the filter class and set the ColumnName
		DataSource.Filter filter = new DataSource.Filter();
		filter.columnName = 'ExternalId';
		
		//create the TableSelection class, set the filter and add it to the QueryContext
		DataSource.TableSelection tableSelection = new DataSource.TableSelection();
		tableSelection.tableSelected = 'NDA';
		tableSelection.filter = filter;
		context.TableSelection = tableSelection;
			
		// tell the Testing framework to use the ConnectionMock for all Http Callouts in this test
		Test.setMock(HttpCalloutMock.class, new ExternalDS_HttpCalloutMock(true));
		Test.startTest();
		
		ExternalDS_NDA connection = new ExternalDS_NDA(connectionParams);
		connection.sync();
		connection.query (context );
		connection.search(searchcontext);
		
		String searchTerms = 'Service Port';
		connection.getData(searchTerms);
		
		Test.stopTest();
	}
}