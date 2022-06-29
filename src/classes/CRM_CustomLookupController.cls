public with sharing class CRM_CustomLookupController
{
	@AuraEnabled
	public static List<RecordsData> fetchRecords(String objectName, String filterField, String searchString, String globalFilter, String value, String recordCount)
	{
		try
		{
			
		
			List<String> filterFieldList = filterField.split(',');  
			String mainInfo = filterFieldList[0];
			String additionalInfo;
			if(filterFieldList.size() > 1)
			{
				additionalInfo = filterFieldList[1];
			}
			
			List<RecordsData> recordsDataList = new List<RecordsData>();
			if(objectName.equals('Contact') && filterField.equals('Name'))//SOSL Query
			{
	if(String.isNotBlank(value))
	{
		String soqlQuery = 'SELECT Id, ' + String.escapeSingleQuotes(mainInfo) + ', accName__c FROM '+ String.escapeSingleQuotes(objectName)+' WHERE Id = \''+ String.escapeSingleQuotes(value) + '\' LIMIT ' + String.escapeSingleQuotes(recordCount);
		for(SObject s : Database.query(soqlQuery))
		{
			RecordsData item = new RecordsData((String)s.get(mainInfo), (String)s.get('id'));
			item.additionalInfo = (String)s.get('accName__c');
			recordsDataList.add(item);
		}
	}
	else
	{
		String soslQuery = 'FIND \''+String.escapeSingleQuotes(searchString)+'*\' IN '+String.escapeSingleQuotes(mainInfo)+' FIELDS RETURNING '+ String.escapeSingleQuotes(objectName) +'(Id, '+String.escapeSingleQuotes(filterField)+', accName__c) LIMIT ' + String.escapeSingleQuotes(recordCount);
		System.debug('SOSL QUERY: '+soslQuery);
		List<List<SObject>> results = Search.query(soslQuery);
		for(SObject s : results[0])
		{
			RecordsData item = new RecordsData((String)s.get(mainInfo), (String)s.get('Id'));
			item.additionalInfo = (String)s.get('accName__c');
			recordsDataList.add(item);
		}
	}
			}
			else//SOQL Query
			{
	String query = 'SELECT Id, ' + String.escapeSingleQuotes(filterField) + ' FROM '+ String.escapeSingleQuotes(objectName);
	if(String.isNotBlank(value))
	{
		query += ' WHERE Id = \''+ String.escapeSingleQuotes(value) + '\' LIMIT ' + String.escapeSingleQuotes(recordCount);
	}
	else
	{
					query += ' WHERE '+ setFilter(filterField, searchString);
					if(!(globalFilter == null || globalFilter.equals('')))
					{
						query += ' AND ' + globalFilter;
					}
		query += ' LIMIT ' + String.escapeSingleQuotes(recordCount);
	}
				
				System.debug('JOTATR1 QUERY');
				System.debug(query);
	for(SObject s : Database.query(query))
	{
					System.debug('JOTATR2');
					RecordsData item = new RecordsData((String)s.get(mainInfo), (String)s.get('id'));
					if(additionalInfo != null)
					{
						item.additionalInfo = (String)s.get(additionalInfo);
					}
		recordsDataList.add(item);
	}
			}
			System.debug('JOTATR3');
			System.debug(recordsDataList);
			return recordsDataList;
		}
		catch (Exception err)
		{
			if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) )
			{
	throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
			}
			else
			{
	throw new AuraHandledException(err.getMessage());
			}
		}
	}
	
	private static String setFilter(String filterField, String searchString)
	{
		String filterFinal = '(';
		List<String> filterFieldList = filterField.split(',');
		for(String filter : filterFieldList)
		{
			filterFinal += String.escapeSingleQuotes(filter) + ' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\' OR ';
		}
		return filterFinal.Substring(0,filterFinal.length()-3) + ')';
	}
	
	public class RecordsData
	{
		@AuraEnabled public String label;
		@AuraEnabled public String value;
		@AuraEnabled public Boolean hide;
		@AuraEnabled public String additionalInfo;
		public RecordsData(String label, String value)
		{
			this.label = label;
			this.value = value;
			this.hide = false;
			this.additionalInfo = '';
		}
		public RecordsData(String label, String value, Boolean hide)
		{
			this.label = label;
			this.value = value;
			this.hide = hide;
			this.additionalInfo = '';
		}
	}
}