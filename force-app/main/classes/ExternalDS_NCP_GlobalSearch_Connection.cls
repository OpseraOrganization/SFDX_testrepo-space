global without sharing class ExternalDS_NCP_GlobalSearch_Connection extends DataSource.Connection {
	private DataSource.ConnectionParams conParam ;

	//Constructor
	global ExternalDS_NCP_GlobalSearch_Connection(DataSource.ConnectionParams connectionParams){
		conParam = connectionParams; 
	} 
	
	override global List<DataSource.Table> sync() {
		List<DataSource.Table> tables = new List<DataSource.Table>();

		//Product Table and Columns
		List<DataSource.Column> productColumns = new List<DataSource.Column>();
		productColumns.add(DataSource.Column.text('Name', 255));
		productColumns.add(DataSource.Column.text('ExternalId', 255));
		productColumns.add(DataSource.Column.url('DisplayUrl'));
		productColumns.add(DataSource.Column.text('Description', 10000));
		tables.add(DataSource.Table.get('NCP_Product', 'Name', productColumns));

		//Knowledge Articles and Columns
		List<DataSource.Column> knowledgeArticleColumns = new List<DataSource.Column>();
		knowledgeArticleColumns.add(DataSource.Column.text('Name', 255));
		knowledgeArticleColumns.add(DataSource.Column.text('ExternalId', 255));
		knowledgeArticleColumns.add(DataSource.Column.url('DisplayUrl'));
		knowledgeArticleColumns.add(DataSource.Column.text('Description', 10000));
		tables.add(DataSource.Table.get('NCP_Knowledge', 'Name', knowledgeArticleColumns));
		
		return tables;
	}
	
	override global DataSource.TableResult query(DataSource.QueryContext c) {return DataSource.TableResult.get(c, DataSource.QueryUtils.process(c, getRows()));
	}
	
	override global List<DataSource.TableResult> search(DataSource.SearchContext contexts) {  
		List<DataSource.TableResult> results = new List<DataSource.TableResult>();  
		String replaceSearchPhrase;
		String searchPhrase = contexts.searchPhrase;
		replaceSearchPhrase = searchPhrase.replace(' ','*');
		replaceSearchPhrase = replaceSearchPhrase.replace('\\','');
		replaceSearchPhrase = replaceSearchPhrase.replace('"','');	  
		//if(!Test.isRunningTest()){
		GlobalSearchResult resultDataMaps = getData(searchPhrase);
		for (Integer i = 0; i < (contexts.tableSelections)?.size(); i++) {
			String entity = contexts.tableSelections[i].tableSelected;
			if(entity.equalsIgnoreCase('NCP_Product')){
	results.add(DataSource.TableResult.get(true, null, entity, resultDataMaps.productRows));
			}
			else if(entity.equalsIgnoreCase('NCP_Knowledge')){
	results.add(DataSource.TableResult.get(true, null, entity, resultDataMaps.knowledgeRows));
			}
		}
		return results;
	}

	// Helper method to get record values from the external system for the Sample table.
	private List<Map<String, Object>> getRows () {return new List<Map<String,Object>>();
	}

	//Helper method to parse the data.
	//Returns a list of rows from the external system.
	private GlobalSearchResult getData(String searchText) {
		GlobalSearchResult globalSearchresults = new GlobalSearchResult();
		List<Map<String, Object>> rows = new List<Map<String, Object>>();
		List<String> productItemTypes = Label.NCP_ProductItemTypeList.split(',');
		List<String> portfolioClassifications = Label.NCP_PortfolioClassificationList.split(',');
		Boolean horizontalUser = checkForHorizontalUser();
		
		
		List<List<SObject>> results;
		String searchQueryStr = 'FIND \''+String.escapeSingleQuotes(searchText)+'*\' IN ALL FIELDS RETURNING ' +
	'Product2(Id, Name, ProductCode, NCP_Marketing_Text__c ' + 
	'WHERE PMD_Additional_Classification__c != \'Product Variant\' AND ' + 
	'NokiaCPQ_State__c NOT IN (\'Obsolete\',\'Rejected\') AND IsActive=true AND ' +
	'PMD_Product_Item_Type__c IN :productItemTypes AND ' +
	'PMD_Portfolio_Classification__c IN :portfolioClassifications)';
		if(Auth.CommunitiesUtil.isGuestUser()){
			searchQueryStr += ', Knowledge__kav(Id, Title, ArticleNumber, UrlName, Description__c ' +
	'WHERE PublishStatus = \'Online\' AND ValidationStatus = \'External Approved\' AND ' +
		'RecordType.DeveloperName != \'Internal_Knowledge\' AND ' + 
		'IsVisibleInPkb = true)';
		}
		else if(!horizontalUser){
			Set<Id> product2Ids = new Set<Id>();
			Set<Id> knowledgeArticleIds = new Set<Id>();
			String productRelationQueryStr = '';
			productRelationQueryStr += 'SELECT Id, CH_Knowledge__c FROM CH_ProductRelation__c WHERE CH_Knowledge__c != NULL AND CH_Knowledge__r.PublishStatus = \'Online\' AND ' +
			'CH_Knowledge__r.ValidationStatus = \'External Approved\' AND CH_Knowledge__r.RecordType.DeveloperName != \'Internal_Knowledge\' ';

			//Check if the User is an External User or an Internal User
			User loggedInUser = [SELECT Id, IsPortalEnabled FROM User WHERE Id = :UserInfo.getUserId()];
			
			if(loggedInUser.IsPortalEnabled){//Customers, Partners
	product2Ids = NCP_Entitlements.getMyEntitledProduct(null);
			}	
			if(!product2Ids.isEmpty()){
	productRelationQueryStr += ' AND CH_Parent_Product__c IN :product2Ids';
			}
			else if(loggedInUser.IsPortalEnabled){//Customers, Partners User and no Products as well
	productRelationQueryStr = '';
			}
			//Get the Knowledge Article Ids from CH_ProductRelation object
			if(String.isNotBlank(productRelationQueryStr)){
	for(CH_ProductRelation__c productRelation : Database.query(productRelationQueryStr)){
		knowledgeArticleIds.add(productRelation.CH_Knowledge__c);
	}
			}
			searchQueryStr += ', Knowledge__kav(Id, Title, ArticleNumber, UrlName, Description__c ' +
	'WHERE PublishStatus = \'Online\' AND ValidationStatus = \'External Approved\' AND ' +
	'RecordType.DeveloperName != \'Internal_Knowledge\' AND ';
			if(!knowledgeArticleIds.isEmpty()){
	searchQueryStr += '((Id IN :knowledgeArticleIds AND ' +
	'IsVisibleInCsp = true) OR IsVisibleInPkb = true))';
			}
			else{
	searchQueryStr += ' IsVisibleInPkb = true)';
			}
		}
		results = Search.query(searchQueryStr);
		if(results?.size() == 2){
			for(Product2 productRecord: (Product2[])results[0]){globalSearchresults.productRows.add(createRow(productRecord, 'Product2'));
			}
			
			for(Knowledge__kav knowledgeRecord : (Knowledge__kav[])results[1]){globalSearchresults.knowledgeRows.add(createRow(knowledgeRecord, 'Knowledge__kav'));
			}
		}
		else if(results?.size() == 1){for(Product2 productRecord: (Product2[])results[0]){globalSearchresults.productRows.add(createRow(productRecord, 'Product2'));
			}
		}
		return globalSearchresults;
	}

	//Helper method to populate a row based on source data.
	//The item argument maps to the data that represents a row.
	//Returns an updated map with the External ID and Display URL values.
	@TestVisible
	private Map<String, Object> createRow(sObject objectRecord, String objectName) {
		Map<String, Object> row = new Map<String, Object>();
		if(objectName.equalsIgnoreCase('Product2')){
			row.put('ExternalId', objectRecord.get('Id'));
			row.put('Name', objectRecord.get('Name'));
			row.put('DisplayUrl', Network.getLoginUrl('0DB4100000003Dc').replace('/login', '/s/product2/') + objectRecord.get('Id'));
			row.put('Description', objectRecord.get('NCP_Marketing_Text__c'));
		}
		else if(objectName.equalsIgnoreCase('Knowledge__kav')){row.put('ExternalId', objectRecord.get('Id'));row.put('Name', objectRecord.get('Title'));row.put('DisplayUrl', Network.getLoginUrl('0DB4100000003Dc').replace('/login', '/s/article/') + objectRecord.get('UrlName'));row.put('Description', objectRecord.get('Description__c'));
		}
		return row;
	}

	class GlobalSearchResult{
		List<Map<String, Object>> productRows = new List<Map<String, Object>>();
		List<Map<String, Object>> knowledgeRows = new List<Map<String, Object>>();
	}

	private Boolean checkForHorizontalUser(){
		List<User> loggedInUserList = [SELECT NCP_IsHorizontal__c FROM User WHERE Id =: UserInfo.getUserId()];
		if(loggedInUserList?.size() > 0){
			return loggedInUserList[0].NCP_IsHorizontal__c;
		}
		return false;
	}
}