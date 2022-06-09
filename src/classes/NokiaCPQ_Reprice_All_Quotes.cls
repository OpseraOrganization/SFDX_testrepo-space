public class NokiaCPQ_Reprice_All_Quotes {
	
	public List<Apttus_Proposal__Proposal__c> quoteList = new List<Apttus_Proposal__Proposal__c>();
	public String currentOppId {get;set;}
	public List<String> quoteIds = new List<String>();
	public Map<String, String> productConfigs = new Map<String, String>();
	public List<Apttus_Config2__LineItem__c> configLineItems;
	public Apttus_Config2__ProductConfiguration__c productConfig; 
	public Id configId;
	public Boolean actionPollerActive{get; set;}
	public Boolean hasPendingItems{get; set;} 
	public Boolean flagUpdatePrice; 
	public Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO ;
	public Boolean pricingNotRequired;
	public Boolean isError{get; set;}
	public Integer totalLineItems {get; set;}
	public transient Integer completedLineItems {get; set;} 
	public Boolean isFinalized {get; set;}
	public static Integer counter = 0;
	public Boolean morePending = true;
	
	public NokiaCPQ_Reprice_All_Quotes(){ 
		currentOppId = ApexPages.currentPage().getParameters().get('OppId');
		
		quoteList = [Select id,NokiaCPQ_Last_Reprice__c,NokiaCPQ_Needs_Reprice__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c = :currentOppId AND
					NokiaCPQ_Needs_Reprice__c = true AND (Apttus_Proposal__Approval_Stage__c != 'Approved' AND Apttus_Proposal__Approval_Stage__c != 'Expired' AND Apttus_Proposal__Approval_Stage__c != 'Rejected' AND Apttus_Proposal__Approval_Stage__c != 'Closed (Not Won)')]; 
					
		for(Apttus_Proposal__Proposal__c prop : quoteList){
			quoteIds.add(prop.Id);
		}
		
		for(Apttus_Config2__ProductConfiguration__c config : [Select id,Apttus_QPConfig__Proposald__c from Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c IN:quoteIds Order by CreatedDate ASC]){
			productConfigs.put(config.Apttus_QPConfig__Proposald__c, config.Id);
		}
		
		//configId = productConfigs.get(0).Id;	   
		
	}
	
	public PageReference init() {

		
		if(quoteList.isEmpty()){   
			pricingNotRequired = true;
			hasPendingItems = false;
			actionPollerActive = false;
			isError = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Reprice not required at the moment'));
		}
		else{
		   
			configLineItems = [Select Id,Apttus_Config2__PricingStatus__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c IN: productConfigs.values()];
		
			if(!configLineItems.isEmpty()){ 
				totalLineItems  = productConfigs.values().size();
		
				for(Apttus_Config2__LineItem__c configLineItem : configLineItems){
					configLineItem.Apttus_Config2__PricingStatus__c= 'Pending';
				}
		   
				update configLineItems;
			}
		 
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Repricing.... Please Wait'));
			pricingNotRequired  = false;
			hasPendingItems = false;	
			actionPollerActive = true;
		  
			//objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
			//objUpdatePriceRequestDO.CartId = productConfigs.values()[counter];
		  
			isError = false;
 
			//Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
			//hasPendingItems = result.IsPricePending;
			//if(!hasPendingItems){
				//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Reprice Complete.Finalizing the cart......Please Wait')); 
				/*Apttus_CpqApi.CPQ.FinalizeCartRequestDO requestFinalizeCart = new Apttus_CpqApi.CPQ.FinalizeCartRequestDO();				 
				requestFinalizeCart.CartId = configId;					
				Apttus_CpqApi.CPQ.FinalizeCartResponseDO responseFinalizeCart = Apttus_CpqApi.CPQWebService.finalizeCart(requestFinalizeCart);
				if(responseFinalizeCart.IsSuccess){
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Finalize Complete'));   
					isFinalized = true;
					actionPollerActive = false;
					quote.NokiaCPQ_Last_Reprice__c = System.Now();
					quote.NokiaCPQ_Needs_Reprice__c = false;
			
					update quote;
				} */
			//}
			//else{			
			actionPollerActive = true;			 
			flagUpdatePrice = true;		
		  //}
		  
		  completedLineItems = counter;
 
		}

		return null;
	}

	public void doUpdatePrice(){			   

		if(flagUpdatePrice == true){  

			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Repricing.... Please Wait'));	  
			
			objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
			system.debug('** product config**' + productConfigs.values()[counter] + '**' + counter);
			objUpdatePriceRequestDO.CartId = productConfigs.values()[counter];
 
			Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart (objUpdatePriceRequestDO);
 
			hasPendingItems = result.IsPricePending; 
			List<Integer> pendingLineNumbers = result.PendingLineNumbers;
			List<Integer> completedLineNumbers = result.CompletedLineNumbers;
			system.debug('** hasPendingItems**' + hasPendingItems + pendingLineNumbers);
			if(hasPendingItems == false){
				morePending = checkCounter();
				if(morePending == true){
					actionPollerActive = true;
				}
				else{
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Reprice Complete. Finalizing the cart......')); 
					isFinalized = true;
					actionPollerActive = false; 
				}
				
			}
			else if(hasPendingItems == true && pendingLineNumbers.size() > 0){
				actionPollerActive = true;	
			}
			
			
			/*if(hasPendingItems == false){			
		 
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Reprice Complete. Finalizing the cart......')); 
				Apttus_CpqApi.CPQ.FinalizeCartRequestDO requestFinalizeCart = new Apttus_CpqApi.CPQ.FinalizeCartRequestDO();					   
				requestFinalizeCart.CartId = configId;						
				Apttus_CpqApi.CPQ.FinalizeCartResponseDO responseFinalizeCart = Apttus_CpqApi.CPQWebService.finalizeCart(requestFinalizeCart);
				if(responseFinalizeCart.IsSuccess){
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Finalize Complete'));   
					isFinalized = true;
					actionPollerActive = false; 
			
					quote.NokiaCPQ_Last_Reprice__c = System.Now();
					quote.NokiaCPQ_Needs_Reprice__c = false;
			
					update quote;
				}
			}		 
			else if( hasPendingItems == true && pendingLineNumbers.size() > 0 ){			
				actionPollerActive = true;		
			}*/
			completedLineItems = counter;
	  
		}
 
	}
	
   public PageReference cancel() {
		return new PageReference('/'+currentOppId);
	}

	public Boolean checkCounter(){
		Integer maxValue = productConfigs.values().size();
		system.debug('**Max Value' + maxValue + '** Counter**' + counter);
		if(counter < (maxValue - 1)){
			counter = counter + 1;
			return true;
		}
		else{
			return false;
		}
	}

}