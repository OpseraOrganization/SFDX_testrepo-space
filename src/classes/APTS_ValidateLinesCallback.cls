global with sharing class APTS_ValidateLinesCallback implements Apttus_Config2.CustomClass.IValidationCallback2 {
  
  /**
   * Callback to validate the line items in the cart
   * @param cart the cart object to validate
   * @return the validation result
   */
	public Id ConfigId=null;
	Id Recordtype=null;

	
	global Apttus_Config2.CustomClass.ValidationResult validateCart(Apttus_Config2.ProductConfiguration cart) 
	{
		Apttus_Config2.CustomClass.ValidationResult result = new Apttus_Config2.CustomClass.ValidationResult(true);
		try{					 
			ConfigId = cart.getConfigSO().Id;		  
			// Apttus_Config2__ProductConfiguration__c Prodid=[select id,Name,Apttus_QPConfig__Proposald__r.RecordTypeid,Apttus_QPConfig__Proposald__c from Apttus_Config2__ProductConfiguration__c where id=:ConfigId]; 
			List<Apttus_Config2__LineItem__c> Lineitemlist1=[select id,Apttus_Config2__LineType__c,Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c,Apttus_Config2__ProductId__r.IsActive,
			Apttus_Config2__ProductId__r.name,Apttus_Config2__OptionId__r.name,Apttus_Config2__OptionId__r.IsActive,Apttus_Config2__ProductId__c,Apttus_Config2__OptionId__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:ConfigId];
			//Recordtype=Prodid.Apttus_QPConfig__Proposald__r.RecordTypeid;
		 
			set<Id> Pricelistid= new set<Id>();
			Map<ID,Boolean> ProductMap= new Map<ID,Boolean>();
			If(Lineitemlist1.size() > 0)
			{				 
				
				for(Apttus_Config2__LineItem__c lin:Lineitemlist1) {					
					
					if (lin.Apttus_Config2__LineType__c== 'Product/Service') 
					{
					   
						if (lin.Apttus_Config2__ProductId__r.IsActive == false ) {
							result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR,'The Quote cannot be validated as it contains products that are no longer available for purchase. Please remove the following items:' + lin.Apttus_Config2__ProductId__r.name));	
							result.isSuccess = false;
						}					   
					}else if(lin.Apttus_Config2__LineType__c == 'Option'){
						if (lin.Apttus_Config2__OptionId__r.IsActive == false ) {
							result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR,'The Quote cannot be validated as it contains products that are no longer available for purchase. Please remove the following items:' + lin.Apttus_Config2__OptionId__r.name ));	
							result.isSuccess = false;
						}					   
					}
				}
			}   
			
		}catch(exception ex){
			System.debug('EXception --- ' +ex);
		}
	   return result;
	}
  
	 
  /**
   * Callback to validate the given list ramp line items
   * @param cart the cart object associated with the ramp line items
   * @param rampLineItems the list of ramp line items
   * @return the validation result
   */
	global Apttus_Config2.CustomClass.ValidationResult validateRampLineItems(Apttus_Config2.ProductConfiguration cart, List<Apttus_Config2.LineItem> rampLineItems) {
		Apttus_Config2.CustomClass.ValidationResult result = new Apttus_Config2.CustomClass.ValidationResult(true);
		return result;
	}
	
   global Apttus_Config2.CustomClass.ValidationResult validateAssetItems(Apttus_Config2.ProductConfiguration cart, List<Apttus_Config2__TempRenew__c> Temprenew){
		Apttus_Config2.CustomClass.ValidationResult result = new Apttus_Config2.CustomClass.ValidationResult(true);
		return result;
   }
			  
	/* Gets the list of product line items associated with the Battery line
	 * @param cart the cart object
	 * @return the list of line item objects
	 */
   private static List<Apttus_Config2__LineItem__C> getLineItemsList(List<Apttus_Config2.LineItem> allLines) {
		
		List<Apttus_Config2__LineItem__C> lineItems = new List<Apttus_Config2__LineItem__C>();
		// iterate thru the cart and get the line items matching the battery code1 
		for (Apttus_Config2.LineItem lineItemMO : allLines) {
			lineItems.add(lineItemMO.getLineItemSO());
		}
		return lineItems;   
	}
  }