public class CH_CustomLookup_Controller {
	@AuraEnabled
	public static List<RecordsData> fetchRecords(String objectName, String filterField, String searchString, String value) {
		try {
			List<RecordsData> recordsDataList = new List<RecordsData>();
			String query = '';
			if(objectName == 'Account' && filterField == 'Name'){
				query = 'SELECT Id, RecordType.Name, Type, AccountNumber, ' + filterField + ' FROM '+objectName;
				if(String.isNotBlank(value)) {
					query += ' WHERE RecordType.Name = \'Legal Entity\' AND Type != \'Vendor\' AND Id = \''+ value + '\' LIMIT 49999';
				} else {
					query += ' WHERE RecordType.Name = \'Legal Entity\' AND Type != \'Vendor\' AND '+filterField+
						' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\' LIMIT 49999';
				}
				System.debug(query);
			} 
			else{
				query = 'SELECT Id, ' + filterField + ' FROM '+objectName;
				if(String.isNotBlank(value)) {
					query += ' WHERE Id = \''+ value + '\' LIMIT 49999';
				} else {
					query += ' WHERE '+filterField+
						' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\' LIMIT 49999';
				}
				
			}
			
			for(SObject s : Database.query(query)) {
				if(objectName == 'Account' && filterField == 'Name'){
					recordsDataList.add( new RecordsData((String)s.get(filterField), (String)s.get('id'), (String)s.get('AccountNumber') ));
				}
				else{
					recordsDataList.add( new RecordsData((String)s.get(filterField), (String)s.get('id'), null ));
				}
				
			}
			return recordsDataList;
		} catch (Exception err) {
			if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
				throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
			} else {
				throw new AuraHandledException(err.getMessage());
			}
		}
	}
	
	public class RecordsData {
		@AuraEnabled public String label;
		@AuraEnabled public String value;
		@AuraEnabled public String accountNumber;
		public RecordsData(String label, String value, String accountNumber) {
			this.label = label;
			this.value = value;
			this.accountNumber = accountNumber;
		}
	}
}