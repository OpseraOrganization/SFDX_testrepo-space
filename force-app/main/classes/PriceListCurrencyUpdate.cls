/****************************************
	 * Name : PriceListCurrencyUpdate
	 * Author : Accenture
	 * Description : This class is used for invoking price list update batch class 
	 *		from pmdi price list updated process builder
	 * ReqNo : 4571(D-8396), 5025
	****************************************/
public without sharing class PriceListCurrencyUpdate {
	
	/****************************************
		 * Name : updateCurrency
		 * Description : invokable method which calls price list currency update batch class
		 * Parameters: List of PMDI parameters
		 * Returns : NA
	 *****************************************/
	@InvocableMethod(label='PriceList Currency Update' description='')
	public static void updateCurrency(List<NokiaCPQ_PMDI_Parameter__c> paramterEntry)
	{
		try
		{
			System.debug('Pricelist: '+paramterEntry);
			Batch_PriceListCurrencyUpdate batch = new Batch_PriceListCurrencyUpdate(paramterEntry);
			Database.executeBatch(batch);
		}
		catch(Exception ex)
		{
			System.debug('Exception occured: '+ex);
		}
	}

}