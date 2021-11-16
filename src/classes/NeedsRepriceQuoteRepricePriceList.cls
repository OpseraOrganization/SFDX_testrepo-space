/**
* @description: Called by Process Builder to flag Needs Reprice on associated Quotes on creating 
*		record of  Quotes Reprice object for a pricelist	
* @author:  Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION AUTHOR	  DATE	DETAIL					  FEATURES/CSR/TTP
* 1.0		  23/02/2018  Requirement 2599
* 1.1		  18/04/2018  Requirement 4185			   To include Direct Functionality
* 1.2		  24/12/2018  Requirement 5679			   To trigger reprice for Direct CLPs
* ============================================================================ 
*/
public class NeedsRepriceQuoteRepricePriceList {
	
	/**********************************************************************************************************************
	* Date: Feb - 2017
	* Param: List<String> priceListId
	* Return: None
	* Description: Used to check Needs Reprice Checkbox on Quotes in case of Pricelist changes. Req 2599(Indirect), Req 4185(Direct), Req 6712(Indirect) 
	********************************************************************************************************************* */ 
	@InvocableMethod(label='Needs Reprice Price List' description='Returns the list of account names corresponding to the specified account IDs.')
	public static void updateQuotes(List<String> priceListId){
		try{
			
			Set<Id> priceListRecId = new Set<Id>();
			Set<String> customerPLId = new Set<String>();
			Set<String> marketPLId = new Set<String>(); //RG: for 6712
			String query = '';
			
			//collect pricelist Ids and derived pricelist Ids
			for(Apttus_Config2__PriceList__c objPriceListRec: [SELECT Id, PriceList_Type__c, Project_Price_List_Number__c FROM Apttus_Config2__PriceList__c WHERE Apttus_Config2__BasedOnPriceListId__c =: priceListId OR Id =: priceListId]){
				if(objPriceListRec.PriceList_Type__c != Nokia_CPQ_Constants.PLTYPE_DIRECT){
					priceListRecId.add(objPriceListRec.Id);
				}
				else{ 
					customerPLId.add(objPriceListRec.Project_Price_List_Number__c);
				}   
			}
			//ADDED BY RG FOR REQ: 6712 START
			for(Apttus_Config2__PriceList__c objmPriceListRec: [SELECT Id, PriceList_Type__c, Project_Price_List_Number__c FROM Apttus_Config2__PriceList__c WHERE Id =: priceListId]){
				if(objmPriceListRec.PriceList_Type__c == 'Indirect Market'){
				   marketPLId.add(objmPriceListRec.Project_Price_List_Number__c);
				}
			}
			//ADDED BY RG FOR REQ: 6712 END
			//System.debug('marketPLId-->'+marketPLId);
			if(!priceListRecId.isEmpty()){
				query = 'SELECT Id,NokiaCPQ_Needs_Reprice__c,NokiaCPQ_Net_Amount_Quote__c FROM Apttus_Proposal__Proposal__c WHERE (Apttus_QPConfig__PriceListId__c IN (\'';
				Integer count = 0;
				//add pricelist Ids in IN clause
				for(Id idStr: priceListRecId){	
					if(count != priceListRecId.size()-1)
						query+= idStr+'\',\'';
					else
						query+= idStr+'\')';	
					
					count++;
				}
				//ADDED BY RG FOR REQ: 6712 START
				if(!marketPLId.isEmpty()){
					Integer mcount = 0;
					query+= ' OR Project_Price_List_Number__c LIKE \'%';
					for(String midStr: marketPLId){	
						if(mcount != marketPLId.size()-1)
							query+= midStr+'%\' OR Project_Price_List_Number__c  LIKE \'%';
						else
							query+= midStr+'%\'';	
						
						mcount++;
						}
				}
				//ADDED BY RG FOR REQ: 6712 END
				query+= ') AND NokiaCPQ_Net_Amount_Quote__c > 0';
			}
			else if(!customerPLId.isEmpty()){
				query = 'SELECT Id,NokiaCPQ_Needs_Reprice__c,NokiaCPQ_Total_CNP__c FROM Apttus_Proposal__Proposal__c WHERE (Direct_Price_List_Number__c LIKE \'%';
				Integer count = 0;
				//add pricelist Ids in IN clause
				for(String idStr: customerPLId){	
					if(count != customerPLId.size()-1)
						query+= idStr+'%\' OR Direct_Price_List_Number__c LIKE \'%';
					else
						query+= idStr+'%\'';	
					
					count++;
				}
				query+= ') AND NokiaCPQ_Total_CNP__c > 0';
			}
			
			system.debug('>>>'+query);
			NeedsRepriceBatch repriceBatch = new NeedsRepriceBatch(query);
			Database.executeBatch(repriceBatch, 1);
		}
		catch(Exception ex){		   
			ExceptionHandler.addException(ex,GlobalConstants.UPDATEQUOTES,GlobalConstants.NEEDSREPRICEQUOTEREPRICEPRICELIST);
		} 
	}
}