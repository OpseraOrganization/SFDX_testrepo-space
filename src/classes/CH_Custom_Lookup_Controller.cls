public class CH_Custom_Lookup_Controller {
	
	@AuraEnabled
	public static List<CH_Custom_Lookup_Result> searchObjects(String searchKeyWord, string objectName, string objectDisplayField, 
															  List<string> queryFieldsList, string objectFilter) {
		String searchKey = searchKeyWord + '%';
		String filterKey = (String.isBlank(objectFilter))? '': ' AND ' + objectFilter;
		String queryFields = string.join(queryFieldsList,',');														
		String query = 'SELECT id, ' + queryFields + ' FROM ' + objectName + ' WHERE ' + objectDisplayField + ' LIKE \'' + searchKey +'\'' + filterKey;
		System.debug(query);
		list<sObject> foundRecords = Database.query(query);
		
		integer counter = 0;
		List<CH_Custom_Lookup_Result> resultRecords = new List<CH_Custom_Lookup_Result>();
		for (sObject record : foundRecords){
			CH_Custom_Lookup_Result newResultRecord = new CH_Custom_Lookup_Result();
			newResultRecord.recordId = record.id;
			if (queryFieldsList[0].contains('__r')){
				List<string> elements = queryFieldsList[0].split('\\.');
				newResultRecord.recordValue1 = String.valueOf(record.getSObject(elements[0]).get(elements[1]));
			}
			else {
				newResultRecord.recordValue1 = String.valueOf(record.get(queryFieldsList[0]));
			} 
			if (queryFieldsList.size() == 2){
				if (queryFieldsList[1].contains('__r')){
					List<string> elements = queryFieldsList[1].split('\\.');
					newResultRecord.recordValue2 = String.valueOf(record.getSObject(elements[0]).get(elements[1]));
				}
				else {
					newResultRecord.recordValue2 = String.valueOf(record.get(queryFieldsList[1]));
				}
			}
			newResultRecord.recordValue = newResultRecord.recordValue1 + ' - ' + ((newResultRecord.recordValue2 == null) ? '' : newResultRecord.recordValue2);
			resultRecords.add(newResultRecord);
		}
	   
		return resultRecords;
	}
}