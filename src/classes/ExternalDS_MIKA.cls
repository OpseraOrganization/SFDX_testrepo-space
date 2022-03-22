/**
About
-----
Description: Salesforce Connect Custom Adapter using Apex "MIKA"

Created for: Nokia Portugal COE
Created: 19 02 2019

Update History
--------------
Created: 16 07 2019 – flavio.toscano@nokia.com
-------------
**/
global class ExternalDS_MIKA extends DataSource.Connection {
	private DataSource.ConnectionParams conParam ;
		
	//Constructor
	global ExternalDS_MIKA(DataSource.ConnectionParams connectionParams){	
		conParam = connectionParams; 
	}	
	
	//Sync Table and Columns in Salesforce
	override global List<DataSource.Table> sync() {
		List<DataSource.Table> tables = new List<DataSource.Table>();
		List<DataSource.Column> gdcarticleColumns = new List<DataSource.Column>();
		List<DataSource.Column> featureColumns = new List<DataSource.Column>();
		List<DataSource.Column> kpiColumns = new List<DataSource.Column>();
		List<DataSource.Column> alarmColumns = new List<DataSource.Column>();
		List<DataSource.Column> parameterColumns = new List<DataSource.Column>();
		
		//columns for gdcarticle
		gdcarticleColumns.add(DataSource.Column.text('Name', 255));
		gdcarticleColumns.add(DataSource.Column.text('Meaning Of The Alarm', 100000));
		gdcarticleColumns.add(DataSource.Column.text('Domain Name', 255));
		gdcarticleColumns.add(DataSource.Column.url('DisplayUrl'));
		gdcarticleColumns.add(DataSource.Column.text('Description', 100000));
		gdcarticleColumns.add(DataSource.Column.text('ExternalId', 255));
		gdcarticleColumns.add(DataSource.Column.text('Category', 255));
		gdcarticleColumns.add(DataSource.Column.text('Product Name', 255));
		gdcarticleColumns.add(DataSource.Column.text('Business Group', 255));
		gdcarticleColumns.add(DataSource.Column.text('Business Line', 255));
		gdcarticleColumns.add(DataSource.Column.text('tc Name', 255));
		gdcarticleColumns.add(DataSource.Column.text('Product Family', 255));
		gdcarticleColumns.add(DataSource.Column.text('Product Version', 255));
		gdcarticleColumns.add(DataSource.Column.text('Diagnostic Steps', 255));
		gdcarticleColumns.add(DataSource.Column.text('Solution', 255));
		gdcarticleColumns.add(DataSource.Column.text('Workaround', 255));
		gdcarticleColumns.add(DataSource.Column.text('Tags', 255));
		gdcarticleColumns.add(DataSource.Column.text('Prerequisites', 255));
		gdcarticleColumns.add(DataSource.Column.text('Customer', 255));
		gdcarticleColumns.add(DataSource.Column.text('Risks', 255));
		gdcarticleColumns.add(DataSource.Column.text('Approval Status', 255));
		gdcarticleColumns.add(DataSource.Column.text('Last Modified', 255));
		
		//columns for feature
		featureColumns.add(DataSource.Column.text('Name', 255));
		featureColumns.add(DataSource.Column.url('DisplayUrl'));
		featureColumns.add(DataSource.Column.text('Description', 100000));
		featureColumns.add(DataSource.Column.text('ExternalId', 255));
		featureColumns.add(DataSource.Column.text('Technology', 255));
		
		//columns for kpi
		kpiColumns.add(DataSource.Column.text('Name', 255));
		kpiColumns.add(DataSource.Column.text('Domain Name', 255));
		kpiColumns.add(DataSource.Column.url('DisplayUrl'));
		kpiColumns.add(DataSource.Column.text('Description', 100000));
		kpiColumns.add(DataSource.Column.text('ExternalId', 255));
		
		//columns for alarm
		alarmColumns.add(DataSource.Column.text('Name', 255));
		alarmColumns.add(DataSource.Column.text('Meaning Of The Alarm', 100000));
		alarmColumns.add(DataSource.Column.text('Domain Name', 255));
		alarmColumns.add(DataSource.Column.url('DisplayUrl'));
		alarmColumns.add(DataSource.Column.text('Description', 100000));
		alarmColumns.add(DataSource.Column.text('ExternalId', 255));
		
		//columns for parameter
		parameterColumns.add(DataSource.Column.text('Name', 255));
		parameterColumns.add(DataSource.Column.url('DisplayUrl'));
		parameterColumns.add(DataSource.Column.text('Description', 100000));
		parameterColumns.add(DataSource.Column.text('ExternalId', 255));
		parameterColumns.add(DataSource.Column.text('Technology', 255));
		
		tables.add(DataSource.Table.get('GDC Live', 'Name', gdcarticleColumns));
		tables.add(DataSource.Table.get('NIDD Alarms', 'Name', alarmColumns));
		tables.add(DataSource.Table.get('NIDD KPIs', 'Name', kpiColumns));
		tables.add(DataSource.Table.get('webNEI Parameters', 'Name', parameterColumns));
		tables.add(DataSource.Table.get('webNEI Features', 'Name', featureColumns));		
		return tables;
	}
	
	//Called to query and get results from the external system for SOQL queries, list views, and detail pages for an external object that's associated with the external data source.
  //The QueryContext argument represents the query to run against a table in the external system.
	//Returns a list of rows as the query results.
	override global DataSource.TableResult query(DataSource.QueryContext contexts) {
		DataSource.Filter filter = contexts.tableSelection.filter;
		String url = getPOST_External_SRC_URL();
		String externalId = (filter.columnValue).toString();
		String externalIndex;
		if(contexts.tableSelection.tableSelected == 'GDC Live'){
	  externalIndex = 'gdcarticle';
	  return DataSource.TableResult.get(true, null, contexts.tableSelection.tableSelected, getPostData(url, externalId, externalIndex));
	} else if(contexts.tableSelection.tableSelected == 'NIDD Alarms'){
			externalIndex = 'alarm';
	  return DataSource.TableResult.get(true, null, contexts.tableSelection.tableSelected, getPostData(url, externalId, externalIndex));
	} else if(contexts.tableSelection.tableSelected == 'NIDD KPIs'){
			externalIndex = 'kpi';
			return DataSource.TableResult.get(true, null, contexts.tableSelection.tableSelected, getPostData(url, externalId, externalIndex));				 
	} else if(contexts.tableSelection.tableSelected == 'webNEI Parameters'){
			externalIndex = 'parameter';
			return DataSource.TableResult.get(true, null, contexts.tableSelection.tableSelected, getPostData(url, externalId, externalIndex));	
	} else if(contexts.tableSelection.tableSelected == 'webNEI Features'){
			externalIndex = 'feature';
			return DataSource.TableResult.get(true, null, contexts.tableSelection.tableSelected, getPostData(url, externalId, externalIndex));
		} else {
			return NULL;
		}
	}
	
	//Helper method to parse the data.
	//Returns a list of rows from the external system.
	public List<Map<String, Object>> getPostData(String url, String externalId, String externalIndex) {
		List<Map<String, Object>> rows = new List<Map<String, Object>>();
		HttpResponse response = postResponse(url, externalId, externalIndex);
		String body = response.getBody();
		String replaceBody = '{"items":' + body + '}';
		Map<String, Object> responseBodyMap = (Map<String, Object>)JSON.deserializeUntyped(replaceBody);
		//Checks errors.	   
		Map<String, Object> error = (Map<String, Object>)responseBodyMap.get('error');
		if (error!=null) {
			List<Object> errorsList = (List<Object>)error.get('errors');
			Map<String, Object> errors = (Map<String, Object>)errorsList[0];
			String messages = (String)errors.get('message');
			throw new DataSource.OAuthTokenExpiredException(messages);
		}
		List<Object> sItems = (List<Object>)responseBodyMap.get('items');
		if (sItems != null) {
			for (Integer i=0; i< sItems.size(); i++) {
				Map<String, Object> item = (Map<String, Object>)sItems[i];
				rows.add(createRow(item));
			}
		} else {
			rows.add(createRow(responseBodyMap));
		}
		return rows;
	}
	
  //Helper method to make the HTTP POST call.
	//The url argument is the URL of the external system.
  //The externalId argument is the Article Id of the external system.
  //The externalIndex argument is the Index Source of the external system.
	//Returns the response from the external system.
	public HttpResponse postResponse(String url, String externalId, String externalIndex) {
		String external_SRC_Username = getExternalSRC_Username();
		String external_SRC_Password = getExternalSRC_Password();
		Http httpProtocol = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndPoint(url);
		request.setMethod('POST');
	// Set the body as a JSON object
		String body = '{"parameters":{"id":"' + externalId + '","index":"' + externalIndex + '"}}';
	request.setBody(body);
		String encodedHeaderValue = EncodingUtil.base64Encode(Blob.valueOf(external_SRC_Username + ':' + external_SRC_Password));
		request.setHeader('Authorization', 'Basic ' + encodedHeaderValue);
		request.setHeader('Content-Type', 'application/json');
		HttpResponse response = httpProtocol.send(request);
		
		return response;
	}
	
	//Helper method to populate a row based on source data.
	//The item argument maps to the data that represents a row.
	//Returns an updated map with the External ID and Display URL values.
	public Map<String, Object> createPostRow(Map<String, Object> item) {
		Map<String, Object> row = new Map<String, Object>();
		for ( String key : item.keySet() ){
			//common fields between sources
			if (key == 'id') {
				row.put('ExternalId', item.get('id'));
			} else if (key == 'kpiId') {
				row.put('ExternalId', item.get('kpiId'));
			}
			if (key == 'name') {
				row.put('Name', item.get('name'));
			} else if (key == 'title') {
				row.put('Name', item.get('title'));
			}
			if (key == 'link') {
				row.put('DisplayUrl', item.get('link'));
			} else if (key == 'url') {
				row.put('DisplayUrl', item.get('url'));
			}
			row.put('Description', item.get('description'));
			
			//additional fields for "Alarm" & "kpi"
			row.put('Meaning Of The Alarm', item.get('meaningOfTheAlarm'));
			row.put('Domain Name', item.get('domainName'));
			
			//additional fields for "GDCarticle"
			row.put('Category', item.get('category'));
			row.put('Product Name', item.get('productName'));
			row.put('Business Group', item.get('businessGroup'));
			row.put('Business Line', item.get('businessLine'));
			row.put('tc Name', item.get('tcName'));
			row.put('Product Family', item.get('productFamily'));
			row.put('Product Version', item.get('productVersion'));
			row.put('Diagnostic Steps', item.get('diagnosticSteps'));
			row.put('Solution', item.get('solution'));
			row.put('Workaround', item.get('workaround'));
			row.put('Tags', item.get('tags'));
			row.put('Prerequisites', item.get('prerequisites'));
			row.put('Customer', item.get('customer'));
			row.put('Risks', item.get('risks'));
			row.put('Approval Status', item.get('approvalStatus'));
			row.put('Last Modified', item.get('lastModified'));
		}
		return row;
	}
	
	//Called to do a full text search and get results from the external system for SOSL queries and Salesforce global searches.
	//The SearchContext argument represents the query to run against a table in the external system.
	//Returns results for each table that the SearchContext requested to be searched.
	override global List<DataSource.TableResult> search(DataSource.SearchContext contexts) {
		List<DataSource.TableResult> results = new List<DataSource.TableResult>();
		String external_SRC_URL = getExternal_SRC_URL();
		
		String replaceSearchPhrase;
		String searchPhrase = contexts.searchPhrase;
		replaceSearchPhrase = searchPhrase.replace(' ','+');
		replaceSearchPhrase = replaceSearchPhrase.replace('\\','');
		replaceSearchPhrase = replaceSearchPhrase.replace('"','');
		
		for (Integer i =0; i< contexts.tableSelections.size();i++) {
			String entity = contexts.tableSelections[i].tableSelected;
			if(entity == 'GDC Live'){
				String url = external_SRC_URL + 'json?q=' + replaceSearchPhrase + '&start=0&count=50&index=gdcarticle';
			  results.add(DataSource.TableResult.get(true, null, entity, getData(url)));
			} else if(entity == 'NIDD Alarms'){
				String url = external_SRC_URL + 'json?q=' + replaceSearchPhrase + '&start=0&count=50&index=alarm';
			  results.add(DataSource.TableResult.get(true, null, entity, getData(url)));				
			} else if(entity == 'NIDD KPIs'){
				String url = external_SRC_URL + 'json?q=' + replaceSearchPhrase + '&start=0&count=50&index=kpi';
			  results.add(DataSource.TableResult.get(true, null, entity, getData(url)));				
			} else if(entity == 'webNEI Parameters'){
				String url = external_SRC_URL + 'json?q=' + replaceSearchPhrase + '&start=0&count=50&index=parameter';
			  results.add(DataSource.TableResult.get(true, null, entity, getData(url)));				
			} else if(entity == 'webNEI Features'){
				String url = external_SRC_URL + 'json?q=' + replaceSearchPhrase + '&start=0&count=50&index=feature';
			  results.add(DataSource.TableResult.get(true, null, entity, getData(url)));			  
			} 
		}
		return results;
	}

	//Helper method to parse the data.
	//Returns a list of rows from the external system.
	public List<Map<String, Object>> getData(String url) {
		HttpResponse response = getResponse(url);
		String body = response.getBody();
		List<Map<String, Object>> rows = new List<Map<String, Object>>();
		
		if(response.getStatusCode() == 200){
			Map<String, Object> responseBodyMap = (Map<String, Object>)JSON.deserializeUntyped(body);	
			List<Object> sItems = (List<Object>)responseBodyMap.get('items');
			if (sItems != null) {
				for (Integer i=0; i< sItems.size(); i++) {
					Map<String, Object> item = (Map<String, Object>)sItems[i];
					rows.add(createRow(item));
				}
			} else {
				rows.add(createRow(responseBodyMap));
			}
		} else if(response.getStatusCode() != 200){
			//Checks errors.
			Map<String, Object> responseBodyMap = (Map<String, Object>)JSON.deserializeUntyped(body);	  
			Map<String, Object> error = (Map<String, Object>)responseBodyMap.get('error');
			if (error!=null) {
				List<Object> errorsList = (List<Object>)error.get('errors');
				Map<String, Object> errors = (Map<String, Object>)errorsList[0];
				String messages = (String)errors.get('message');
				throw new DataSource.OAuthTokenExpiredException(messages);
			}
		}
		return rows;
	}

	//Helper method to populate a row based on source data.
	//The item argument maps to the data that represents a row.
	//Returns an updated map with the External ID and Display URL values.
	public Map<String, Object> createRow(Map<String, Object> item) {
		Map<String, Object> row = new Map<String, Object>();
		for ( String key : item.keySet() ){
			//common fields between sources
			if (key == 'id') {
				row.put('ExternalId', item.get('id'));
			} else if (key == 'kpiId') {
				row.put('ExternalId', item.get('kpiId'));
			}
			if (key == 'name') {
				row.put('Name', item.get('name'));
			} else if (key == 'title') {
				row.put('Name', item.get('title'));
			}
			if (key == 'link') {
				row.put('DisplayUrl', item.get('link'));
			} else if (key == 'url') {
				row.put('DisplayUrl', item.get('url'));
			}
			row.put('Description', item.get('description'));
			
			//additional fields for "Alarm" & "kpi"
			row.put('Meaning Of The Alarm', item.get('meaningOfTheAlarm'));
			row.put('Domain Name', item.get('domainName'));
			
			//additional fields for "Feature" & "Parameter"
			row.put('Technology', item.get('technology'));
			
			//additional fields for "GDCarticle"
			row.put('Category', item.get('category'));
			row.put('Product Name', item.get('productName'));
			row.put('Business Group', item.get('businesGroup'));
			row.put('Business Line', item.get('businesLine'));
			row.put('tc Name', item.get('tcName'));
			row.put('Product Family', item.get('productFamily'));
			row.put('Product Version', item.get('productVersion'));
			row.put('Diagnostic Steps', item.get('diagnosticSteps'));
			row.put('Solution', item.get('solution'));
			row.put('Workaround', item.get('workaround'));
			row.put('Tags', item.get('tags'));
			row.put('Prerequisites', item.get('prerequisites'));
			row.put('Customer', item.get('customer'));
			row.put('Risks', item.get('risks'));
			row.put('Approval Status', item.get('approvalStatus'));
			row.put('Last Modified', item.get('lastModified'));
		}
		return row;
	}

	//Helper method to make the HTTP GET call.
	//The url argument is the URL of the external system.
	//Returns the response from the external system.
	public HttpResponse getResponse(String url) {
		String external_SRC_Username = getExternalSRC_Username();
		String external_SRC_Password = getExternalSRC_Password();
		Http httpProtocol = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndPoint(url);
		request.setMethod('GET');
		String encodedHeaderValue = EncodingUtil.base64Encode(Blob.valueOf(external_SRC_Username + ':' + external_SRC_Password));
		request.setHeader('Authorization', 'Basic ' + encodedHeaderValue);
		HttpResponse response = httpProtocol.send(request);
		return response;
	}
	
	private String getExternal_SRC_URL(){
		MikaAuthentication__c mikaAuthenticationCS = MikaAuthentication__c.getValues('basic');
	return mikaAuthenticationCS.external_src_url__c;
  }
	
	private String getPOST_External_SRC_URL(){
		MikaAuthentication__c mikaAuthenticationCS = MikaAuthentication__c.getValues('basic');
	return mikaAuthenticationCS.post_external_src_url__c;
  }
	
	private String getExternalSRC_Username(){
		MikaAuthentication__c mikaAuthenticationCS = MikaAuthentication__c.getValues('basic');
		return mikaAuthenticationCS.username__c;
  }
	
	private String getExternalSRC_Password(){
		MikaAuthentication__c mikaAuthenticationCS = MikaAuthentication__c.getValues('basic');
		return mikaAuthenticationCS.password__c;
  }  
}