/****************************************
 * Class Name : AccountTriggerhelperCOE
 * Created Date: 13 Feb 2021
 * Created By : Wipro
 * Last Modified by: Accenture
 * Last Modified Date: 26 December 2016
 * Description : 
 *****************************************/
public with sharing class AccountTriggerhelperCOE{
	 
	public static void ValidatePricelist(List<Account> accList) 
	{
		
		List<String> allAppPL = new List<String>();
		Map<Id, List<String>> accAppPLMap = new Map<Id, List<String>>();
		List<String> accAppPL = new List<String>();
		Map<String ,String> dbNameCurrencyMap = new  Map<String ,String>();
					
		For(Account acc : accList)
		{
			
			String strAppList = acc.get('NokiaCPQ_Applicable_Price_Lists__c')==null? null :(String)acc.get('NokiaCPQ_Applicable_Price_Lists__c');
			if(strAppList != Null && strAppList != '')
			{
				accAppPL = strAppList.Split(',');
				accAppPLMap.put(acc.ID, accAppPL);
				
				For (String PricelistName : accAppPL)
				{
					allAppPL.add(PricelistName);
				} 
			}
		}
		
		if(allAppPL != Null && allAppPL.size() >0)
		{
			 //system.debug('IMR-->2.1'+allAppPL);
		   List<Apttus_Config2__PriceList__c> dbAllAppPL = [Select Id, Name, CurrencyIsoCode,Apttus_Config2__BasedOnPriceListId__c From Apttus_Config2__PriceList__c where name IN :allAppPL AND Apttus_Config2__Active__c = true];
	  //system.debug('IMR-->2.2'+dbAllAppPL);
						
			for(Apttus_Config2__PriceList__c PL : dbAllAppPL)
			{
				//system.debug('IMR-->3'+PL);
				dbNameCurrencyMap.put(PL.Name, PL.CurrencyIsoCode);
			} // this will give you map of Name and Currency
		}
		
		if(accAppPLMap != Null && accAppPLMap.size()>0)
		{
			For( Account acc : accList)
			{
				List<String> accAppPL1 = accAppPLMap.get(acc.ID);
				if(accAppPL1 != Null)
				{		
					for (String appPL : accAppPL1)
					{
						
						String sDefAcCurr = (String)acc.get('CurrencyIsoCode');
						
						if(dbNameCurrencyMap.get(appPL) == Null)
						{
							acc.addError('Invalid CLP Pricelist: '+appPL);
						}
						else if(dbNameCurrencyMap != Null && !sDefAcCurr.equals((String)dbNameCurrencyMap.get(appPL)))
						{
							//system.debug('IMR-->5'+dbNameCurrencyMap);
							acc.addError('Account currency \''+sDefAcCurr+'\' is not matching with CLP currency.Please select correct Customer Pricelist \''+dbNameCurrencyMap.get(appPL)+'\'');
						}							
					}
				}
			}
		}
	}
	
}