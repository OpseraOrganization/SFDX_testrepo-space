public with sharing class TP_Maintenance_controller {

	public PageReference Run() {
		
		system.debug('running test_controller');

			Set<String> fieldSet = new Set<String>();
			Set<String> headerCriteriaFields = new Set<String>();

			Integer MAX_TEXTAREA_SIZE = 255;
			String CRITERIANAME_PREFIX = 'Criteria Set';
			String CONFIG_OBJECT_NOTATION = 'Apttus_Config2__ConfigurationId__r.';

			String MULTIVALUE_SPLIT_REGEX = ', \r\n|, \n|, |,\r\n|\r\n|,\n|,|\n';

			// get the line item custom property datasets
			for (apttus_config2__ConfigLineItemCustomFields__c prop : 
				apttus_config2__ConfigLineItemCustomFields__c.getAll().values()) {

				// build list of custom fields to read
				String fieldNamePrefix = 'apttus_config2__CustomFieldNames';

				for (Integer i = 0; i < 5; i++) {
					Integer colIndex = i+1;
					// get the field value
					String colName = fieldNamePrefix+(colIndex == 1 ? '' : String.valueOf(colIndex))+'__c';
					// get the column value
					Object colValue = prop.get(colName);
					if (colValue != null) {
						String strValue = ''+colValue;
						// get custom field names
						List<String> fieldNames = (strValue != null || strValue.trim().length() == 0)
												   ? strValue.split(MULTIVALUE_SPLIT_REGEX)
												   : new String[]{};

						// trim custom field names
						for (Integer j = 0; j < fieldNames.size(); j++) {
							fieldNames[j] = fieldNames[j].trim();
							if (fieldNames[j]. startsWith(CONFIG_OBJECT_NOTATION)) {
								headerCriteriaFields.add(fieldNames[j]. removeStart(CONFIG_OBJECT_NOTATION));
							}

						}

						// add field names
						fieldSet.addAll(fieldNames);

					}

				}

			}


// insert header fields

		Set<String> allCriteriaFields = new Set<String>(headerCriteriaFields);
		
		// rebuild criteria in custom settings
		List<apttus_config2__ConfigHeaderCriteriaFields__c> fieldsToInsert = new List<apttus_config2__ConfigHeaderCriteriaFields__c>();
		List<ID> fieldsToRemove = new List<ID>();
		
		// STEP I - build list of criteria fields to remove
		// get the line item criteria property datasets
		for (apttus_config2__ConfigHeaderCriteriaFields__c fieldsSO : apttus_config2__ConfigHeaderCriteriaFields__c.getAll().values()) {
			fieldsToRemove.add(fieldsSO.Id);
			
		}
		
		// STEP II - build list of criteria fields to insert
		if (!allCriteriaFields.isEmpty()) {
			
			// sort the list of fields
			List<String> sortedCriteriaFields = new List<String>();
			Set<String> uniqueFieldNames = new Set<String>();
			for (String str : allCriteriaFields) {
				if (!uniqueFieldNames.contains(str.toLowerCase())) {
					sortedCriteriaFields.add(str);
					uniqueFieldNames.add(str.toLowerCase());
				}
			}
			sortedCriteriaFields.sort();
			
			Integer seqNbr = 1;
			String textBuffer = '';
			
			for (String fieldName : sortedCriteriaFields) {
				
				if ((MAX_TEXTAREA_SIZE - textBuffer.length()) < (fieldName.length()+1)) {
					// create a new fields contaier
					seqNbr++;
					apttus_config2__ConfigHeaderCriteriaFields__c fieldsSO = new apttus_config2__ConfigHeaderCriteriaFields__c(Name = (CRITERIANAME_PREFIX + ' ' + seqNbr),
																							   Apttus_Config2__CriteriaFieldNames__c = textBuffer);
					
					fieldsToInsert.add(fieldsSO);
					// clear the buffer
					textBuffer = '';
					
				}
				
				// add the field to the set
				textBuffer += fieldName + '\n';
				
			}
			
			if (textBuffer.length() > 0) {
				seqNbr++;
				apttus_config2__ConfigHeaderCriteriaFields__c fieldsSO = new apttus_config2__ConfigHeaderCriteriaFields__c(Name = (CRITERIANAME_PREFIX + ' ' + seqNbr),
																						   Apttus_Config2__CriteriaFieldNames__c = textBuffer);
					
				fieldsToInsert.add(fieldsSO);
				
			}
		
		}
		
		// STEP III - remove criteria fields
		if (!fieldsToRemove.isEmpty()) {
			//Database.delete(fieldsToRemove);
						System.debug(fieldsToRemove);
			
		}
		
		// STEP IV - bulk insert criteria fields
		if (!fieldsToInsert.isEmpty()) {
			Database.insert(fieldsToInsert);
						System.debug(fieldsToInsert);
			
		}


		system.debug('Completed');
		
		return null;
	}

}