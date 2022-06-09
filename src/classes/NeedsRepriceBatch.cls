public class NeedsRepriceBatch implements Database.Batchable<sObject> {
	
	String query;
	String objectName;
	
	public NeedsRepriceBatch(String queryFromPB){ 
		this.query = queryFromPB;
	}
	
	//Constructor with 2 parameters
	public NeedsRepriceBatch(String queryFromPB, String objectName){ 
		this.query = queryFromPB;
		this.objectName = objectName;
	}
	
	public Database.QueryLocator start(Database.BatchableContext bc){	   
		return Database.getQueryLocator(query);
	}
	
	public void execute (Database.BatchableContext BC, List<Apttus_Proposal__Proposal__c> quotes){
		Set<String> uniquePLNameSet = new Set<String>();
		Map<String,Apttus_Config2__PriceList__c> pLNameAndNumberMap = new Map<String,Apttus_Config2__PriceList__c>();
		String directPriceListNumber = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		String priceListName = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		
		for(Apttus_Proposal__Proposal__c quote : quotes) {
		   // system.debug('objectName ' + objectName + quote.Quote_Type__c);
			if(String.isNotBlank(objectName) && objectName.equals(Nokia_CPQ_Constants.OBJECT_ACCOUNT) && quote.Quote_Type__c.equals(Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ)){
				/*if(quote.Apttus_Proposal__Approval_Stage__c.equals(Nokia_CPQ_Constants.QUOTEDRAFT) || quote.Apttus_Proposal__Approval_Stage__c.equals(Nokia_CPQ_Constants.QUOTEREJECTED)){
					//quote.NokiaCPQ_Needs_Reprice__c = true;
				}*/
				system.debug('Direct and Account Initiated');
			}
			else{
				quote.NokiaCPQ_Needs_Reprice__c = true;
			}
		}

		if(String.isNotBlank(objectName) && objectName.equals(Nokia_CPQ_Constants.OBJECT_ACCOUNT) && quotes[0].Quote_Type__c.equals(Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ) && (quotes[0].Apttus_Proposal__Approval_Stage__c.equals(Nokia_CPQ_Constants.QUOTEDRAFT) || quotes[0].Apttus_Proposal__Approval_Stage__c.equals(Nokia_CPQ_Constants.QUOTEREJECTED))){
			if(String.isNotBlank(quotes[0].Apttus_Proposal__Account__r.NokiaCPQ_Applicable_Price_Lists__c)){
				for(String str: quotes[0].Apttus_Proposal__Account__r.NokiaCPQ_Applicable_Price_Lists__c.split(',')){
					uniquePLNameSet.add(str.trim());
				}
			}
			
			for(Apttus_Config2__PriceList__c plist : [Select Id,NokiaCPQ_Name__c,Project_Price_List_Number__c,CurrencyIsoCode From Apttus_Config2__PriceList__c Where Apttus_Config2__Active__c = true AND PriceList_Type__c =: Nokia_CPQ_Constants.PLTYPE_DIRECT AND NokiaCPQ_Name__c IN: uniquePLNameSet AND CurrencyIsoCode =: quotes[0].CurrencyIsoCode]){
				pLNameAndNumberMap.put(plist.NokiaCPQ_Name__c,plist);
			}
			
			for(String plName: uniquePLNameSet){
				if(pLNameAndNumberMap != null && pLNameAndNumberMap.containsKey(plName)){
					directPriceListNumber = directPriceListNumber + pLNameAndNumberMap.get(plName).Project_Price_List_Number__c + Nokia_CPQ_Constants.NOKIA_COMMA;
					priceListName = priceListName + pLNameAndNumberMap.get(plName).NokiaCPQ_Name__c + Nokia_CPQ_Constants.NOKIA_COMMA;
				}
			}
			if(String.isNotBlank(directPriceListNumber) && String.isNotBlank(priceListName)){
				//system.debug('Direct Price List Number** ' + quotes[0].Direct_Price_List_Number__c + '  ' +	 );
				if(quotes[0].Direct_Price_List_Number__c != directPriceListNumber.removeEnd(Nokia_CPQ_Constants.NOKIA_COMMA)){
					quotes[0].Direct_Price_List_Number__c = directPriceListNumber.removeEnd(Nokia_CPQ_Constants.NOKIA_COMMA);
					quotes[0].NokiaCPQ_Needs_Reprice__c = true;
				}
				system.debug('Price List ** ' + quotes[0].Price_List__c + '  ' + priceListName);
				if(quotes[0].Price_List__c != priceListName.removeEnd(Nokia_CPQ_Constants.NOKIA_COMMA)){
					quotes[0].Price_List__c = priceListName.removeEnd(Nokia_CPQ_Constants.NOKIA_COMMA);
					quotes[0].NokiaCPQ_Needs_Reprice__c = true;
				}
			}
			else{
				if(quotes[0].Apttus_QPConfig__PriceListId__c != null){
					system.debug('Direct Price List Number** ' + quotes[0].Direct_Price_List_Number__c);
					if(quotes[0].Direct_Price_List_Number__c != null && quotes[0].Direct_Price_List_Number__c != Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE){
						quotes[0].Direct_Price_List_Number__c = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
						quotes[0].NokiaCPQ_Needs_Reprice__c = true;
					}
					system.debug('Price List ** ' + quotes[0].Price_List__c + '  ' + quotes[0].Apttus_QPConfig__PriceListId__r.Name);
					if(quotes[0].Price_List__c != quotes[0].Apttus_QPConfig__PriceListId__r.Name){
						quotes[0].Price_List__c = quotes[0].Apttus_QPConfig__PriceListId__r.Name;
						quotes[0].NokiaCPQ_Needs_Reprice__c = true;
					}
				}
			}
		}	   
		
		update quotes;
	}
	
	public void finish(Database.BatchableContext BC){  
		System.debug('finished');
	}
}