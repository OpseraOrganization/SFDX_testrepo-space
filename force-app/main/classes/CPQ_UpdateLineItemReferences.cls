global without sharing class CPQ_UpdateLineItemReferences implements Database.Batchable<sObject>  {
	
	Map<String,Id> actualProductcodes = new Map<String,Id>();
	Map<String,Id> actualpli = new Map<String,Id>();
	public static integer batchSize = 50;
	
	public CPQ_UpdateLineItemReferences(Map<String,Id> actualProductcodes, Map<String,Id> actualpli) {
		this.actualProductcodes = actualProductcodes;
		this.actualpli = actualpli;
	}
	
	global Database.QueryLocator start(Database.BatchableContext bc) {
		string query = 'Select id,name,Apttus_Config2__OptionId__c,Apttus_Config2__ProductId__c ,NokiaCPQ_Part_Number__c, '
						+'Apttus_Config2__LineType__c,Apttus_Config2__PriceListId__c,'
						+'Apttus_Config2__ProductId__r.productCode,Apttus_Config2__OptionId__r.productCode,Apttus_Config2__PriceListItemId__c '
						+'from Apttus_Config2__LineItem__c where Apttus_Config2__ProductId__r.productCode like \'%_TBD\' OR '
						+'Apttus_Config2__OptionId__r.productCode like \'%_TBD\' ORDER BY CreatedDate DESC';
		
		return Database.getQueryLocator(query);
	}
	global void execute(Database.BatchableContext bc, List<Apttus_Config2__LineItem__c> lineitemList){
		//system.debug('Total size productcode execute = '+actualProductcodes.size());
		//system.debug('Total size pli execute = '+actualpli.size());
		for(Apttus_Config2__LineItem__c lineitem : lineitemList) {
			//system.debug('productcode execute = '+actualProductcodes);
			//system.debug('pli execute = '+actualpli);
			string productCode='';
			string optionCode='';
			if(lineitem.Apttus_Config2__ProductId__c != null) {
				productCode = lineitem.Apttus_Config2__ProductId__r.productCode.replace('_TBD','').trim();
				//system.debug('@---product '+productCode);
				if(actualProductcodes.containsKey(productCode)) {
					//system.debug('@--working- ');
					lineitem.Apttus_Config2__ProductId__c = actualProductcodes.get(productCode);
				}
			}
			if(lineitem.Apttus_Config2__OptionId__c != null) {
				
				optionCode = lineitem.Apttus_Config2__OptionId__r.productCode.replace('_TBD','').trim();
				//system.debug('@---option '+optionCode);
				if(actualProductcodes.containsKey(optionCode)) {
					//system.debug('@--working---- ');
					lineitem.Apttus_Config2__OptionId__c = actualProductcodes.get(optionCode);
				}
			}
			
			if(lineitem.Apttus_Config2__PriceListItemId__c != null) {
				//system.debug('@---actualpli '+actualpli);
				if(lineitem.Apttus_Config2__LineType__c == 'Product/Service' && actualpli.containsKey(lineitem.Apttus_Config2__PriceListId__c+productCode)) {
					lineitem.Apttus_Config2__PriceListItemId__c = actualpli.get(lineitem.Apttus_Config2__PriceListId__c+productCode);
				}
				else if(lineitem.Apttus_Config2__LineType__c == 'Option' && actualpli.containsKey(lineitem.Apttus_Config2__PriceListId__c+optionCode)){
					lineitem.Apttus_Config2__PriceListItemId__c = actualpli.get(lineitem.Apttus_Config2__PriceListId__c+optionCode);
				}
			}
		}
		Database.update(lineitemList,false);
	}
	
	global void finish(Database.BatchableContext bc) {
		list<Apttus_Config2__PriceListItem__c> pliList = new list<Apttus_Config2__PriceListItem__c>();
		for(Apttus_Config2__PriceListItem__c pli: [Select id,Apttus_Config2__ProductId__c,Apttus_Config2__ProductCode__c 
													FROM Apttus_Config2__PriceListItem__c 
													WHERE Apttus_Config2__ProductCode__c like '%_TBD%' AND 
													Apttus_Config2__PriceListId__c IN (Select id from Apttus_Config2__PriceList__c 
													WHERE PriceList_Type__c IN ('Partner','Direct')) 
													AND (NOT Apttus_Config2__PriceListId__r.name like '%test%')]) {
			
			string pCode = pli.Apttus_Config2__ProductCode__c.replace('_TBD','').trim();
			if(actualProductcodes.containskey(pCode)) {
				pli.Apttus_Config2__ProductId__c = actualProductcodes.get(pCode);
				pliList.add(pli);
			}		   
		}
		Database.update(pliList,false);
	}	
	
	global static void execute(){
		set<string> productCodeSet = new set<string>();
		Map<String,Id> actualProductcodesLocal = new Map<String,Id>();
		Map<String,Id> actualpliLocal = new Map<String,Id>();
		for(product2 prd : [SELECT Id,productcode FROM product2 WHERE productcode like '%_TBD']) {
			productCodeSet.add(prd.productcode.replace('_TBD','').trim());
		}
		for(product2 prd : [SELECT Id,productcode FROM product2 WHERE productcode IN : productCodeSet]) {
			actualProductcodesLocal.put(prd.productcode,prd.Id);
		}
		for(Apttus_Config2__PriceListItem__c pli : [SELECT Id,Apttus_Config2__PriceListId__c,Apttus_Config2__ProductId__r.productcode 
													FROM Apttus_Config2__PriceListItem__c
													WHERE Apttus_Config2__ProductId__r.productcode IN : productCodeSet]) {
			actualpliLocal.put(pli.Apttus_Config2__PriceListId__c+pli.Apttus_Config2__ProductId__r.productcode.replace('_TBD','').trim(),pli.Id);
		}
		//system.debug('Total size productcode = '+actualProductcodesLocal.size());
		//system.debug('Total size pli = '+actualpliLocal.size());
		Database.executeBatch(new CPQ_UpdateLineItemReferences(actualProductcodesLocal,actualpliLocal),batchSize);
	}
}