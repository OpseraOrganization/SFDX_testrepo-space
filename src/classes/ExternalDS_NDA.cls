global without sharing class ExternalDS_NDA extends DataSource.Connection  {
	private DataSource.ConnectionParams conParam ;
		
	//Constructor
	global ExternalDS_NDA(DataSource.ConnectionParams connectionParams){
		conParam = connectionParams; 
	}   
	
	//Sync Table and Columns in Salesforce
	override global List<DataSource.Table> sync() {
		List<DataSource.Table> tables = new List<DataSource.Table>();
		List<DataSource.Column> ndaColumns = new List<DataSource.Column>();
	
		//columns for ndaColumns
		ndaColumns.add(DataSource.Column.text('Name', 255));
		ndaColumns.add(DataSource.Column.text('ExternalId', 255));
		ndaColumns.add(DataSource.Column.text('Source', 255));
		ndaColumns.add(DataSource.Column.url('DisplayUrl'));
		ndaColumns.add(DataSource.Column.text('Description', 100000));
		
		tables.add(DataSource.Table.get('NDA', 'Name', ndaColumns));
		return tables;
	}
	
	//Called to do a full text search and get results from the external system for SOSL queries and Salesforce global searches.
	//The SearchContext argument represents the query to run against a table in the external system.
	//Returns results for each table that the SearchContext requested to be searched.
	override global List<DataSource.TableResult> search (DataSource.SearchContext contexts) {
		List<DataSource.TableResult> results = new List<DataSource.TableResult>();  
		String replaceSearchPhrase;
		String searchPhrase = contexts.searchPhrase;
		replaceSearchPhrase = searchPhrase.replace(' ','+');
		replaceSearchPhrase = replaceSearchPhrase.replace('\\','');
		replaceSearchPhrase = replaceSearchPhrase.replace('"','');
		
		if(!Test.isRunningTest()){
			for (Integer i = 0; i < contexts.tableSelections.size(); i++) {
				String entity = contexts.tableSelections[i].tableSelected;
				if(entity == 'NDA'){ results.add(DataSource.TableResult.get(true, null, entity, getData(replaceSearchPhrase)));
				} 
			}
		}
		return results;
	}
	
	//Called to query and get results from the external system for SOQL queries, list views, and detail pages for an external object that's associated with the external data source.
	//The QueryContext argument represents the query to run against a table in the external system.
	//Returns a list of rows as the query results.
	override global DataSource.TableResult query (DataSource.QueryContext contexts) {
		system.debug('queryContext.tableSelection.tableselected ' + contexts.tableSelection.tableselected);
		system.debug('queryContext.tableSelection.filter.columnName ' + contexts.tableSelection.filter.columnName);
		system.debug('queryContext.tableSelection.filter.columnValue ' + contexts.tableSelection.filter.columnValue);
		system.debug('queryContext.tableSelection.filter.type ' + contexts.tableSelection.filter.type);
		
		List<Map<String,Object>> rows = new List<Map<String,Object>>();
		Map<String,Object> row = new Map<String,Object>();
		row.put('Name', contexts.tableSelection.filter.columnValue);
		row.put('ExternalId', contexts.tableSelection.filter.columnValue);
		rows.add(row);
		
		return DataSource.TableResult.get(contexts, rows);
	}

	//Helper method to parse the data.
	//Returns a list of rows from the external system.
	public List<Map<String, Object>> getData(String replaceSearchPhrase) {
		
		List<Map<String, Object>> rows = new List<Map<String, Object>>();
		//searchTerms provided by user comes on :replaceSearchPhrase
		User userInfo = [SELECT Id, Email, Nokia_ID__c, NCP_Is_Internal__c FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
		String searchTerms = replaceSearchPhrase;
		String federationid = userInfo.Nokia_ID__c;
		String email = userInfo.Email;
		String p20code = fetchP20Code();
		Boolean internalUser = userInfo.NCP_Is_Internal__c;
		Boolean includeSFCasesandArticles = false;
		Integer size = 10;
		System.debug('************************** SB - p20code: ' + p20code);
		Http httpProtocol = new Http();
		HttpRequest request = new HttpRequest();
		if(!Test.isRunningTest()){ request.setEndpoint('callout:NDA_Global_Search/?searchTerms=' + replaceSearchPhrase + '&federationid=' + federationid + '&email=' + email + '&p20code=' + p20code + '&internalUser=' + internalUser + '&includeSFCasesandArticles=' + includeSFCasesandArticles + '&size=' + size);
		} else {
			request.setEndpoint('callout:NDA_Global_Search');   
		}
		//need to enrich url with above information
		request.setHeader('Content-Type','application/json');
		request.setMethod('GET');
		request.setTimeout(120000);
		
		try{
			HttpResponse response = httpProtocol.send(request);
			String body = response.getBody();
			
			if(response.getStatusCode() == 200){
				Map<String, Object> responseBodyMap = (Map<String, Object>)JSON.deserializeUntyped(body);   
				List<Object> sItems = (List<Object>)responseBodyMap.get('items');
				if (sItems != null) {
					for (Integer i=0; i< sItems.size(); i++) {
						Map<String, Object> item = (Map<String, Object>)sItems[i];
						rows.add(createRow(item));
					}
				} else { rows.add(createRow(responseBodyMap));
				}
			} else if(response.getStatusCode() != 200){
				//Checks errors.
				Map<String, Object> responseBodyMap = (Map<String, Object>)JSON.deserializeUntyped(body);	 
				Map<String, Object> error = (Map<String, Object>)responseBodyMap.get('error');
				if (error!=null) {
					List<Object> errorsList = (List<Object>)error.get('errors'); Map<String, Object> errors = (Map<String, Object>)errorsList[0]; String messages = (String)errors.get('message'); throw new DataSource.OAuthTokenExpiredException(messages);
				}
			}
			return rows;
		} catch (Exception e){
			System.debug('Error calling NDA External Data Source: ' + e.getMessage());
			return rows;
		}
	}

	//Helper method to populate a row based on source data.
	//The item argument maps to the data that represents a row.
	//Returns an updated map with the External ID and Display URL values.
	public Map<String, Object> createRow(Map<String, Object> item) {
		Map<String, Object> row = new Map<String, Object>();
		for (String key : item.keySet()){
			row.put('ExternalId', item.get('id'));
			row.put('Name', item.get('name'));
			row.put('DisplayUrl', item.get('link'));
			row.put('Source', item.get('source'));
			row.put('Description', item.get('description'));
		}
		return row;
	}

	//Helper method to fetch the P20 Code of the Account related to the Contact
	public String fetchP20Code(){
		String p20Code = '';
		Map<Id, String> accountIdP20CodeMap = new Map<Id, String>();
		//Fetch the Contact Id from the User
		List<User> loggedInUserRecords = [SELECT Id, ContactId
										  FROM User
										  WHERE Id = :UserInfo.getUserId() AND ContactId != NULL
										  LIMIT 1];
		System.debug('************************** SB - loggedInUserRecords: ' + loggedInUserRecords);
		//Check with Flavio if this is applicable for Partner Users as well. Otherwise, in the above query we can limit it to Customers and Customers Login Profile Users
		if(loggedInUserRecords?.size() > 0 && String.isNotBlank(loggedInUserRecords[0].ContactId)){//if the loggedInUserRecord has data
			//Fetch the Accounts and the related P20 Code
			for(AccountContactRelation acr : [SELECT AccountId, Account.NCP_P20_ID__c FROM AccountContactRelation WHERE ContactId = :loggedInUserRecords[0].ContactId AND NCP_Entitlement_Relationship__c = true]){
				accountIdP20CodeMap.put(acr.AccountId, acr.Account.NCP_P20_ID__c);
			}
			System.debug('************************** SB - accountIdP20CodeMap: ' + accountIdP20CodeMap);
			if(accountIdP20CodeMap?.size() == 1){
				for(Id accountId : accountIdP20CodeMap.keySet()){ p20Code = accountIdP20CodeMap.get(accountId);
				}
			}
			else if(accountIdP20CodeMap?.size() == 2){
				//Fetch the CDB Service Contracts which are associated to the accounts fetched above
				for(ServiceContract sc : [SELECT Id, AccountId FROM ServiceContract WHERE NCP_Contract_Type__c = :NCP_Constants.TYPE_CDB AND RecordType.DeveloperName = :NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT AND AccountId IN :accountIdP20CodeMap.keySet() AND NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE AND Status = :NCP_Constants.STATUS_ACTIVE]){
					p20Code = accountIdP20CodeMap.get(sc.AccountId); break;
				}
			}
		}
		return p20Code;
	}
}