/*******************************************************************************************
* @Name		 CPQ_PriceListItemWrapper 
* @Author	   Jithin Sreedharan <jithin.s.ext@nokia.com>
* @Date		 02/17/2021
* @Group		Surround
* @Description  Custom sorting for price list items based on agreement number sequence.
*******************************************************************************************/
/* MODIFICATION LOG
* Version		  Developer		  Date			   Description
*-------------------------------------------------------------------------------------------
*  1.0			  Jithin	  02/17/2021		  Initial Creation													  
*******************************************************************************************/
public with sharing class CPQ_PriceListItemWrapper implements Comparable{
	public Apttus_Config2__PriceListItem__c priceListItem;
	public CPQ_PriceListItemWrapper(Apttus_Config2__PriceListItem__c priceListItem) {
		this.priceListItem = priceListItem;
	}
	public Integer compareTo(Object compareTo) {
		CPQ_PriceListItemWrapper compareToEntry = (CPQ_PriceListItemWrapper) compareTo;
		Integer returnValue = 0;
		
		List<String> agreementNumbers = Nokia_CPQ_Constants.AGREEMENT_NUMBERS;
		String pliAgreementNo = priceListItem.CPQ_Agreement_Number__c;
		String compareToPliAgreementNo = compareToEntry.priceListItem.CPQ_Agreement_Number__c;

		Integer pliRank = agreementNumbers.indexOf(pliAgreementNo);
		Integer compareToPLIRank = agreementNumbers.indexOf(compareToPliAgreementNo);

		if(pliRank > compareToPLIRank) {
			returnValue = 1;
		} else if(pliRank < compareToPLIRank) {
			returnValue = -1; 
		}
		return returnValue;
	}

}