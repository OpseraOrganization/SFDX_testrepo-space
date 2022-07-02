/*
Tamir weinberger Jan-8-2019
 */
global class NCP_Import_Product_BATCH implements Database.Batchable<sObject> {

	//Static methods

	public Static List<String> commaSeparation(String stringWithCommaSeparation) {
		List<String> strList = stringWithCommaSeparation.split(',');
		return strList;
	}

	public Static Map <String, List<NCP_Product_Content__c>> getProductIdAndContentMap(List<product2> product2List) {

		List<NCP_Product_Content__c> currentProductContentList = [
				SELECT Id, NCP_Product__c, NCP_Service__c, NCP_External_Id__c
				FROM NCP_Product_Content__c
				WHERE NCP_Product__c IN :product2List
		];
		Map<String, List<NCP_Product_Content__c>> allProductIdAndContentMap = new Map<String, List<NCP_Product_Content__c>>();
		//Create a map
		for (NCP_Product_Content__c SingleProductContent : currentProductContentList) {

			if (allProductIdAndContentMap.containsKey(SingleProductContent.NCP_Product__c)) {
				List<NCP_Product_Content__c> contentByProductOdList = allProductIdAndContentMap.get(SingleProductContent.NCP_Product__c);
				contentByProductOdList.add(SingleProductContent);
				allProductIdAndContentMap.put(SingleProductContent.NCP_Product__c, contentByProductOdList);
			} else {
				allProductIdAndContentMap.put(SingleProductContent.NCP_Product__c, new List<NCP_Product_Content__c>{
						SingleProductContent
				});
			}
		}
		return allProductIdAndContentMap;
	}

	public static Map<String, String> getPickListValuesIntoMap() {
		Map<String, String> pickListValuesMap = new Map<String, String>();
		Schema.DescribeFieldResult fieldResult = NCP_Product_Content__c.NCP_Service__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for (Schema.PicklistEntry pickListVal : ple) {
			String labelName = pickListVal.getLabel();
			pickListValuesMap.put(labelName.toUppercase(), labelName);
		}
		return pickListValuesMap;
	}

	//End of Static methods

	global Database.QueryLocator start(Database.BatchableContext bc) {
		return Database.getQueryLocator(
				'SELECT ID, NSNLegacyCode__c, DataUsage__c ' +
						'FROM product_portfolio_item__c ' +
						'Where NCP_Processed__c = ' + False
		);
	}

	global void execute(Database.BatchableContext bc, List<product_portfolio_item__c> scope) {
//Get the product2 real Id
		List<String> product2NokiaProductIdList = new List<String>();
		for (product_portfolio_item__c productPortfolioItem : scope) {
			product2NokiaProductIdList.add(String.valueOf(productPortfolioItem.NSNLegacyCode__c));
		}

		List<product2> product2List = [SELECT Id, NCP_Nokia_Product_id__c from product2 WHERE NCP_Nokia_Product_id__c IN :product2NokiaProductIdList];
//Map <NCP_Nokia_Product_id__c,prduct2 record>
		Map<String, Id> product2IdMap = new Map<String, Id>();
		for (product2 singleProduct : product2List) {
			product2IdMap.put(singleProduct.NCP_Nokia_Product_id__c, singleProduct.Id);
		}

//For delete - Get all product Content related to product2 and create a map <Prouct2Id,List<NCP_Product_Content__c>>
		Map<String, List<NCP_Product_Content__c>> allProductIdAndContentMap = getProductIdAndContentMap(product2List);

//End delete section

//Identify the product2 record
		List<NCP_Product_Content__c> newContentList = new List<NCP_Product_Content__c>();
		List<NCP_Product_Content__c> deleteContentList = new List<NCP_Product_Content__c>();
		List<product_portfolio_item__c> productPortfolioList = new List<product_portfolio_item__c>();
		System.debug('Start Execute 1');
		for (product_portfolio_item__c productPortfolioItem : scope) {
//Do a comment separation
			List<String> commaSeparatedList = new List<String>();
			if (productPortfolioItem.DataUsage__c != null && productPortfolioItem.DataUsage__c != '') {
				commaSeparatedList = commaSeparation(productPortfolioItem.DataUsage__c);
			}

			Id product2Id = product2IdMap.get(productPortfolioItem.NSNLegacyCode__c);
			List<NCP_Product_Content__c> prdocutContentByProductIdList = allProductIdAndContentMap.get(product2Id);
			System.debug('Start Execute 2');
			//Updating or Deleting product content
			for (String singleContentName : commaSeparatedList) {
				Integer index = 0;
				Boolean found = false;
				String singleContentNameUpper = singleContentName.toUppercase();
				if (prdocutContentByProductIdList != null) {
					for (NCP_Product_Content__c singleContent : prdocutContentByProductIdList) {
						if (singleContent.NCP_Service__c!=null && singleContent.NCP_Service__c.toUppercase() == singleContentNameUpper) {
							found = true;
							break;
						}
						index++;
					}
				}
				if (found) {
					prdocutContentByProductIdList.remove(index);
				} else {
//Creating new product content
					//Check if singleContentName is a valid name and exists as a value in the NCP_Service__c picklist
					Map<String,String> pickListValuesMap = getPickListValuesIntoMap();

					if (pickListValuesMap.containsKey(singleContentNameUpper)) {
						System.debug('product2Id:' + product2Id + ', singleContentName=' + singleContentName + ',NSNLegacyCode__c=' + productPortfolioItem.NSNLegacyCode__c);
						NCP_Product_Content__c productContent = new NCP_Product_Content__c();
						productContent.NCP_Product__c = product2Id;
						productContent.NCP_Service__c = pickListValuesMap.get(singleContentNameUpper);
						//Call to log if one is fail - not in picklist
						productContent.NCP_External_Id__c = String.valueOf(productPortfolioItem.NSNLegacyCode__c) + '-' + singleContentName;
						newContentList.add(productContent);

					}

				}
			}
			if (prdocutContentByProductIdList != null) {
				deleteContentList.addAll(prdocutContentByProductIdList);
			}
			productPortfolioItem.NCP_Processed__c = true;
			productPortfolioList.add(productPortfolioItem);
		}
		system.debug('deleteContentList ' + deleteContentList);
		system.debug('newContentList ' + newContentList);
		system.debug('productPortfolioList ' + productPortfolioList);
		try {
			delete deleteContentList;
			insert newContentList;
			update productPortfolioList;
		} catch (DmlException ex) {
			//interfaceType, messageType, operationType, name, status, message, data
			Interface_Log__c log = NCP_InterfaceLog.createInterfaceLog('Product Content', 'Inbound', 'Insert', 'Success', 'Success', 'newContentList', '');
			insert log;
			system.debug('DML Exception');
		}


	}
	global void finish(Database.BatchableContext bc) {
// execute any post-processing operations
		//interfaceType, messageType, operationType, name, status, message, data
		Interface_Log__c log = NCP_InterfaceLog.createInterfaceLog('Product Content', 'Inbound', 'Insert', 'Success', 'Success', 'newContentList', '');
		insert log;
	}

}