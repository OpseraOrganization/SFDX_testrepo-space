public with sharing class PS_ApttusCPQWebServiceCalls {

	/******* create a CART on Given Proposal  **************/
	public ID CreateApttusCart(Id ProposalID)
	{
		 Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
		 request.QuoteID = ProposalID;
		 Apttus_CPQApi.CPQ.CreateCartResponseDO cartRespDO = Apttus_CPQApi.CPQWebService.CreateCart(request);
		 ID cartID = cartRespDO.cartID;
		 return cartID;
	}
	
	//Method to add products to cart. if the Product is a Bundle then it adds the Bundle with default options on it. 
	/*public void AddMultiProduct(List<OpportunityLineItem> listOpptyProduct,ID cartID){
			
			List <Apttus_CPQApi.CPQ.SelectedProductDO> selectedProdDOList = new List <Apttus_CPQApi.CPQ.SelectedProductDO>();
			for(OpportunityLineItem eachopptyproduct :listOpptyProduct){
				system.debug(' in add multi products'+eachopptyproduct);
				Apttus_CPQApi.CPQ.SelectedProductDO selProdDO = new Apttus_CPQApi.CPQ.SelectedProductDO();
				selProdDO.ProductID = eachopptyproduct.Product2Id;
				selProdDO.Quantity = eachopptyproduct.Quantity;
				//selProdDO.SellingTerm = 12;
				//selProdDO.StartDate = Date.Today();
				//selProdDO.EndDate = Date.Today() + 12;
				selProdDO.Comments = 'Added by Batch Potential_Target Quote';
				//This is the way to add custom fields created on the line item object

				 selectedProdDOList.add(selProdDO);
			}
			
			 if(!selectedProdDOList.isEmpty() && selectedProdDOList != null){
				 Apttus_CPQApi.CPQ.AddMultiProductRequestDO bundleReqDO = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
				 bundleReqDO.cartID = cartID;
				 bundleReqDO.SelectedProducts = selectedProdDOList;
				 Apttus_CPQApi.CPQ.AddMultiProductResponseDO bundleRespDO = Apttus_CPQApi.CPQWebService.addMultiProducts(bundleReqDO);
			 }
 
		}*/
	//Method to add sample products to cart. if the Product is a Bundle then it adds the Bundle with default options on it. 
   /* public void AddsampleProduct(ID sampleProduct,ID cartID){
			
			List <Apttus_CPQApi.CPQ.SelectedProductDO> selectedProdDOList = new List <Apttus_CPQApi.CPQ.SelectedProductDO>();
				system.debug(' in add sample  products'+sampleProduct);
				Apttus_CPQApi.CPQ.SelectedProductDO selProdDO = new Apttus_CPQApi.CPQ.SelectedProductDO();
				selProdDO.ProductID = sampleProduct;
				selProdDO.Quantity = 1;
				
				//selProdDO.ListPrice = 0;
				//selProdDO.BasePrice = 0;
				//selProdDO.NetPrice = 0;
				//selProdDO.BaseExtendedPrice = 0;
				//selProdDO.ExtendedPrice = 0;
				//selProdDO.AdjustmentType = null;
				//selProdDO.AdjustmentAmount = null;
				//selProdDO.SellingTerm = 12;
				//selProdDO.StartDate = Date.Today();
				//selProdDO.EndDate = Date.Today() + 12;
				selProdDO.Comments = 'Sample product added by API';
				//This is the way to add custom fields created on the line item object
				
				List<String> customFields = new List<String>();
				 //customFields.add('Sample__c');
				 customFields.add('Apttus_Config2__IsCustomPricing__c');
				 customFields.add('Apttus_Config2__ListPrice__c');
				 customFields.add('Apttus_Config2__PriceUom__c');
				 customFields.add('Apttus_Config2__NetPrice__c');
				 customFields.add('Apttus_Config2__BasePrice__c');
				 customFields.add('Apttus_Config2__BaseExtendedPrice__c');
				 customFields.add('Apttus_Config2__ExtendedPrice__c');
				 selProdDO.CustomFields = customFields;
				 Apttus_Config2__LineItem__c liSO = new Apttus_Config2__LineItem__c();
				 //liSO.Sample__c = True;
				 liSO.Apttus_Config2__IsCustomPricing__c = True;
				 liSO.Apttus_Config2__ListPrice__c = 0.00;
				 liSO.Apttus_Config2__PriceUom__c = 'Each';
				 liSO.Apttus_Config2__NetPrice__c = 0.00;
				 liSO.Apttus_Config2__BasePrice__c = 0.00;
				 liSO.Apttus_Config2__BaseExtendedPrice__c = 0.00;
				 liSO.Apttus_Config2__ExtendedPrice__c = 0.00;
				 selProdDO.CustomData = liSO;
				 selectedProdDOList.add(selProdDO);
			// calling Apttus API to add product to the cart
			 if(!selectedProdDOList.isEmpty() && selectedProdDOList != null){
				 Apttus_CPQApi.CPQ.AddMultiProductRequestDO bundleReqDO = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
				 bundleReqDO.cartID = cartID;
				 bundleReqDO.SelectedProducts = selectedProdDOList;
				 Apttus_CPQApi.CPQ.AddMultiProductResponseDO bundleRespDO = Apttus_CPQApi.CPQWebService.addMultiProducts(bundleReqDO);
			 }
 
		}*/
	
	//Method to add  products to cart. if the Product is a Bundle then it adds the Bundle with default options on it. return the line number.
	/*public Decimal AddcustomProduct(ID cProduct,ID cartID){
			Decimal linenumber;
			List <Apttus_CPQApi.CPQ.SelectedProductDO> selectedProdDOList = new List <Apttus_CPQApi.CPQ.SelectedProductDO>();
				system.debug('in add products:'+cProduct);
				Apttus_CPQApi.CPQ.SelectedProductDO selProdDO = new Apttus_CPQApi.CPQ.SelectedProductDO();
				selProdDO.ProductID = cProduct;
				selProdDO.Quantity = 1;
				selProdDO.Comments = 'custom product added by API';
				selectedProdDOList.add(selProdDO);
		
				// calling Apttus API to add product to the cart
			 if(!selectedProdDOList.isEmpty() && selectedProdDOList != null){
				 Apttus_CPQApi.CPQ.AddMultiProductRequestDO bundleReqDO = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
				 bundleReqDO.cartID = cartID;
				 bundleReqDO.SelectedProducts = selectedProdDOList;
				 Apttus_CPQApi.CPQ.AddMultiProductResponseDO bundleRespDO = Apttus_CPQApi.CPQWebService.addMultiProducts(bundleReqDO);
				 linenumber = bundleRespDO.LineNumbers[0];
			 }
		return linenumber;
 
		}*/
		
	//Method to add products to cart from products. if the Product is a Bundle then it adds the Bundle with default options on it.   
	public void addMultiProductsfromfile(map<Id,Decimal> productmap, ID cartID){
		List <Apttus_CPQApi.CPQ.SelectedProductDO> selectedProdDOList = new List <Apttus_CPQApi.CPQ.SelectedProductDO>();
		for(String eachproduct :productmap.keySet()){
				system.debug(' in add multi products'+eachproduct);
				Apttus_CPQApi.CPQ.SelectedProductDO selProdDO = new Apttus_CPQApi.CPQ.SelectedProductDO();
				selProdDO.ProductID = eachproduct;
				system.debug('####Quantity'+productmap.get(eachproduct));
				selProdDO.Quantity = productmap.get(eachproduct);
				//selProdDO.SellingTerm = 12;
				//selProdDO.StartDate = Date.Today();
				//selProdDO.EndDate = Date.Today() + 12;
				selProdDO.Comments = 'Added by mass upload';
				//This is the way to add custom fields created on the line item object
				
				/*List<String> customFields = new List<String>();
				 customFields.add('Apttus_Config2__LocationID__c');
				 selProdDO.CustomFields = customFields;
				
				 Apttus_Config2__LineItem__c liSO = new Apttus_Config2__LineItem__c();
				 liSO.Apttus_Config2__LocationID__c = 'xxxxxxx';
				 selProdDO.CustomData = liSO;*/
				 selectedProdDOList.add(selProdDO);
			}
			
			 if(!selectedProdDOList.isEmpty() && selectedProdDOList != null){
				 Apttus_CPQApi.CPQ.AddMultiProductRequestDO bundleReqDO = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
				 bundleReqDO.cartID = cartID;
				 bundleReqDO.SelectedProducts = selectedProdDOList;
				 Apttus_CPQApi.CPQ.AddMultiProductResponseDO bundleRespDO = Apttus_CPQApi.CPQWebService.addMultiProducts(bundleReqDO);
				 
			 }
 
	}   
	
	//Method to add sample products to cart from products. if the Product is a Bundle then it adds the Bundle with default options on it.	
	/*public void addMultisampleProductsfromfile(map<Id,Decimal> productmap, ID cartID){
		List <Apttus_CPQApi.CPQ.SelectedProductDO> selectedProdDOList = new List <Apttus_CPQApi.CPQ.SelectedProductDO>();
		for(String eachproduct :productmap.keySet()){
				system.debug(' in add multi products'+eachproduct);
				Apttus_CPQApi.CPQ.SelectedProductDO selProdDO = new Apttus_CPQApi.CPQ.SelectedProductDO();
				selProdDO.ProductID = eachproduct;
				selProdDO.Quantity = productmap.get(eachproduct);
				selProdDO.Comments = 'Added by API sample product';
				List<String> customFields = new List<String>();
				 customFields.add('Sample__c');
				 customFields.add('Apttus_Config2__IsCustomPricing__c');
				 customFields.add('Apttus_Config2__ListPrice__c');
				 customFields.add('Apttus_Config2__PriceUom__c');
				 customFields.add('Apttus_Config2__NetPrice__c');
				 customFields.add('Apttus_Config2__BasePrice__c');
				 customFields.add('Apttus_Config2__BaseExtendedPrice__c');
				 customFields.add('Apttus_Config2__ExtendedPrice__c');
				 selProdDO.CustomFields = customFields;
				 Apttus_Config2__LineItem__c liSO = new Apttus_Config2__LineItem__c();
				 //liSO.Sample__c = True;
				 liSO.Apttus_Config2__IsCustomPricing__c = True;
				 liSO.Apttus_Config2__ListPrice__c = 0.00;
				 liSO.Apttus_Config2__PriceUom__c = 'Each';
				 liSO.Apttus_Config2__NetPrice__c = 0.00;
				 liSO.Apttus_Config2__BasePrice__c = 0.00;
				 liSO.Apttus_Config2__BaseExtendedPrice__c = 0.00;
				 liSO.Apttus_Config2__ExtendedPrice__c = 0.00;
				 selProdDO.CustomData = liSO;
				 selectedProdDOList.add(selProdDO);
			}
			
			 if(!selectedProdDOList.isEmpty() && selectedProdDOList != null){
				 Apttus_CPQApi.CPQ.AddMultiProductRequestDO bundleReqDO = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
				 bundleReqDO.cartID = cartID;
				 bundleReqDO.SelectedProducts = selectedProdDOList;
				 Apttus_CPQApi.CPQ.AddMultiProductResponseDO bundleRespDO = Apttus_CPQApi.CPQWebService.addMultiProducts(bundleReqDO);
				 
			 }
 
	}*/
		
	/********* Run the constRules and Reprice the cart**************/
	
	public void RepriceProposal(Id CartID){
	   
		Integer numErrors = 0;
		Integer numWarnings = 0;
		Boolean IsPricePending = true;
		List<string> errorMsgs = new List<string>();
		List<string> warningMsgs = new List<string>();
		List<Integer> primaryLines = new List<Integer>();
		Apttus_CPQApi.CPQWebService.associateConstraintRules(cartID,primaryLines);
		Apttus_CPQApi.CPQWebService.applyConstraintRules(cartID, true);
				
		Apttus_CPQApi.CPQ.ConstraintResultDO constRuleResultDO = Apttus_CPQApi.CPQWebService.getConstraintRuleResult(cartID);
		List<Apttus_CPQApi.CPQ.AppliedActionDO> appliedActionDOList = constRuleResultDO.ConstraintRuleActions;
		for(Apttus_CPQApi.CPQ.AppliedActionDO appliedActDO:appliedActionDOList) {
			if(appliedActDO.MessageType.equals('Error') && appliedActDO.IsPending) {
				numErrors++;
				errorMsgs.add(appliedActDO.Message);
			}
			else if(appliedActDO.MessageType.equals('Warning') && appliedActDO.IsPending) {
				numWarnings++;
				warningMsgs.add(appliedActDO.Message);
			}
		}
		/*************  END of ConstraintRules   *************/
		if(numErrors < = 0 ) {
			/*
				Repeat this in a javascript till IsPricePending is false. 
				This will Price the Cart Lines and will set the IsPricePendingFlag to TRUE if more lines have to be priced
				IsPricePending will be FALSE when all the Lines in the Cart are Finalized.
			*/
			do{
				Apttus_CPQApi.CPQ.UpdatePriceRequestDO priceReqDO = new Apttus_CPQApi.CPQ.UpdatePriceRequestDO();
				priceReqDO.cartID = cartID;
				Apttus_CPQApi.CPQ.UpdatePriceResponseDO priceRespDO = Apttus_CPQApi.CPQWebService.updatePriceForCart(priceReqDO);	  
				List<Decimal> complLineNums = priceRespDO.CompletedLineNumbers;
				IsPricePending = priceRespDO.IsPricePending;
				List<Decimal> PendingLineNumbers = priceRespDO.PendingLineNumbers;
				system.debug('IsPricePending :'+ IsPricePending);
				
			}while(IsPricePending);
		}
		
	}
	
	   /********  finalizeCart  *************/
		public void Finalizeproposal(ID cartID){
			
				system.debug('in FinalizeCart');
				Apttus_CPQApi.CPQ.FinalizeCartRequestDO request = new Apttus_CPQApi.CPQ.FinalizeCartRequestDO();
				request.CartId = cartID; 
				Apttus_CPQApi.CPQ.FinalizeCartResponseDO resp = Apttus_CPQApi.CPQWebService.finalizeCart(request);
		}
		
		
		/************* Save Cart ***************/
		public void saveCart(Id cartID){
			
			system.debug(' in saveCart');
			if(cartId != null){
				Apttus_Config2__ProductConfiguration__c config = new Apttus_Config2__ProductConfiguration__c(Id = cartID);
				Apttus_Config2__ProductConfiguration__c contractNumber = [Select id,Apttus_QPConfig__Proposald__r.Project_Price_List_Number__c from Apttus_Config2__ProductConfiguration__c where id =:cartID limit 1];
				config.Apttus_Config2__ContractNumbers__c = contractNumber.Apttus_QPConfig__Proposald__r.Project_Price_List_Number__c;
				config.Apttus_Config2__Status__c = 'Saved';
				update config;
			}
			 
		}
		/************update maintenance line item***********/
		//6383 Req Start--heema
	 public void updateMaintenanceLineItem(Id cardID){
		 List < Apttus_Config2__LineItem__c > updateItem = new List < Apttus_Config2__LineItem__c >();
		List<Apttus_Config2__LineItem__c> lineitems = [select Id,Apttus_Config2__AddedBy__c,NokiaCPQ_Product_Name__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__ChargeType__c,Apttus_Config2__AddedByRuleInfo__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = :cardID];
	   // system.debug('line items'+lineitems );
		   if(lineitems != null && !lineitems.isEmpty()){
			   for(Apttus_Config2__LineItem__c lineItem : lineitems){
					if(lineItem.Apttus_Config2__AddedByRuleInfo__c!=null && (lineItem.Apttus_Config2__ProductId__r.ProductCode.equalsIgnoreCase('MT001') || lineItem.Apttus_Config2__ProductId__r.ProductCode.equalsIgnoreCase('MT002') || lineItem.Apttus_Config2__ProductId__r.ProductCode.equalsIgnoreCase('SSP002') || lineItem.Apttus_Config2__ProductId__r.ProductCode.equalsIgnoreCase('SRS001') )){
					
						lineItem.Apttus_Config2__AddedByRuleInfo__c = ' ';
						lineItem.Apttus_Config2__AddedBy__c = 'User';
						updateItem.add(lineItem);
					}
				   // else if(!(lineItem.Apttus_Config2__ProductId__r.ProductCode.equalsIgnoreCase('MT001') || lineItem.Apttus_Config2__ProductId__r.ProductCode.equalsIgnoreCase('MT002') || lineItem.Apttus_Config2__ProductId__r.ProductCode.equalsIgnoreCase('SSP002') || lineItem.Apttus_Config2__ProductId__r.ProductCode.equalsIgnoreCase('SRS001') )){
					  //  lineItem.Apttus_Config2__IsHidden__c =  true;
					 //   updateItem.add(lineItem);
				  //  }
		   }
		   }
			if(updateItem != null && !updateItem.isEmpty()){
			   // system.debug('lineitem list****'+updateItem);
				update updateItem;
				}
			
	   }
	 //6383 Req end--heema
		/*********** Sync price to Opportunity Products *********/
		
	   /* Public void updateOpptyproductsprice(Id cartID,List<OpportunityLineItem> olis){
			System.debug('updated opportunity products price');
			List<OpportunityLineItem> updatedolis = new List<OpportunityLineItem>();
			if(cartID != null){
				List<Apttus_Config2__LineItem__c> lineitems = [Select id, Apttus_Config2__NetPrice__c,
																	  Apttus_Config2__BasePrice__c,
																	  Apttus_Config2__Quantity__c,
																	  Apttus_Config2__ProductId__c,
																	  Apttus_Config2__ListPrice__c
																	  from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =: cartID];
				if(lineitems != null && !lineitems.isEmpty() && olis != null && !olis.isEmpty()){
					for(Apttus_Config2__LineItem__c eachlineitems : lineitems){
						for(OpportunityLineItem eacholi : olis){
							if(eachlineitems.Apttus_Config2__ProductId__c == eacholi.Product2Id && eachlineitems.Apttus_Config2__Quantity__c == eacholi.Quantity){
								 eacholi.UnitPrice = eachlineitems.Apttus_Config2__ListPrice__c;
								 updatedolis.add(eacholi);
								 
							}

						}
					}
				}
			}
			if(updatedolis != null && !updatedolis.isEmpty()){
				update updatedolis;
				
			}
			
		}*/
		
		
}