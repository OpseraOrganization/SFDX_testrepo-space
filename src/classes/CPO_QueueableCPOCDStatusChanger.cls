public with sharing class CPO_QueueableCPOCDStatusChanger { 
	public static void checkCPOCommercialEnrichmentEligibity(
		List<Apttus_Config2__CustomerPurchaseOrder__c> purchaseOrders,
		Map<Id, Apttus_Config2__CustomerPurchaseOrder__c> purchaseOrderOldDetails
	) {
		List<Id> eligibleCustomerPurchaseOrderIds = new List<Id>();
		for(Apttus_Config2__CustomerPurchaseOrder__c purchaseOrder : purchaseOrders) {
			if (purchaseOrder.Apttus_Config2__Status__c == 'Fully Enriched' &&
				purchaseOrderOldDetails.get(purchaseOrder.Id).Apttus_Config2__Status__c <> 'Fully Enriched') {
				eligibleCustomerPurchaseOrderIds.add(purchaseOrder.Id);
			}
		}
		if (!eligibleCustomerPurchaseOrderIds.isEmpty()) { changeStatusAndCreateTasks(eligibleCustomerPurchaseOrderIds); }
	}

	public static void changeStatusAndCreateTasks(List<Id> customerPurchaseOrderIds) {
		List<Task> tasks = new List<Task>();
		List<Apttus_Config2__CustomerPurchaseOrder__c> purchaseOrdersToUpdate = new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		List<Customer_Document__c> customerDocumentsToUpdate = new List<Customer_Document__c>();
		QTO_Exception_Configuration__mdt exceptionMetadata602 = QTO_Exception_Configuration__mdt.getInstance('Enrichment_602');
		QTO_Exception_Configuration__mdt exceptionMetadata621 = QTO_Exception_Configuration__mdt.getInstance('Enrichment_621');
		Map<Id, Integer> riskOrderAlertCPOLineItemsCountByCPOId = getCPOLineItemsCountHavingRiskOrderAlertByCPOId(customerPurchaseOrderIds);
		for (Apttus_Config2__CustomerPurchaseOrder__c purchaseOrder : getCustomerPurchaseOrdersById(customerPurchaseOrderIds).values()) {
			System.debug(LoggingLevel.INFO, 'dsi-2300:::' + purchaseOrder + '::CD Offering Type::' +
						 purchaseOrder.Nokia_Customer_Document_ID__r?.QTO_OfferingType__c);
			if (purchaseOrder.Nokia_Customer_Document_ID__r?.QTO_OfferingType__c !=null && purchaseOrder.Nokia_Customer_Document_ID__r?.QTO_OfferingType__c.containsIgnoreCase('Maintenance')) {
				tasks.add(new Task(
					WhatId = purchaseOrder.Id,
					QTO_Error_Code__c = String.valueOf(exceptionMetadata621?.QTO_Return_Code__c),
					Status = exceptionMetadata621?.QTO_Tasks_Status__c,
					Subject = exceptionMetadata621?.QTO_Task_Subject__c,
					Description = exceptionMetadata621?.QTO_Return_Description__c,
					Investigating_Groups__c = exceptionMetadata621?.QTO_Investigating_Group__c
				));
			}
			
			if (riskOrderAlertCPOLineItemsCountByCPOId.get(purchaseOrder.Id) > 0) {
				tasks.add(new Task(
					WhatId = purchaseOrder.Id,
					QTO_Error_Code__c = String.valueOf(exceptionMetadata602.QTO_Return_Code__c),
					Status = exceptionMetadata602.QTO_Tasks_Status__c,
					Subject = exceptionMetadata602.QTO_Task_Subject__c,
					Description = exceptionMetadata602.QTO_Return_Description__c,
					Investigating_Groups__c = exceptionMetadata602.QTO_Investigating_Group__c,
					ActivityDate = Date.today()
				));
			}
			
			purchaseOrdersToUpdate.add(new Apttus_Config2__CustomerPurchaseOrder__c(
				Id = purchaseOrder.Id,
				Apttus_Config2__Status__c = 'Commercially Enriched'
			));
			
			customerDocumentsToUpdate.add(new Customer_Document__c(
				Id = purchaseOrder.Nokia_Customer_Document_ID__c,
				Status__c = QTO_Constants.CD_STATUS_LEGACY
			));
		}
		
		if(purchaseOrdersToUpdate.size() > 0)	
			update purchaseOrdersToUpdate;
		if(customerDocumentsToUpdate.size() > 0)
			update customerDocumentsToUpdate;
		if(tasks.size() > 0)		
			insert tasks;
	}

	@TestVisible
	private static Map<Id, Apttus_Config2__CustomerPurchaseOrder__c> getCustomerPurchaseOrdersById(List<Id> customerPurchaseOrderIds) {
		if (customerPurchaseOrderIds == null || customerPurchaseOrderIds.isEmpty()) { return null; }
		return new Map<Id, Apttus_Config2__CustomerPurchaseOrder__c>(
			[
				SELECT Id, Apttus_Config2__Status__c,
				Nokia_Customer_Document_ID__c,
				Nokia_Customer_Document_ID__r.QTO_OfferingType__c
				FROM Apttus_Config2__CustomerPurchaseOrder__c
				WHERE Id = :customerPurchaseOrderIds
				AND Apttus_Config2__Status__c = 'Fully Enriched'
			   
			]
		);
	}

	@TestVisible
	private static Map<Id, Integer> getCPOLineItemsCountHavingRiskOrderAlertByCPOId(List<Id> customerPurchaseOrderIds) {
		if (customerPurchaseOrderIds == null || customerPurchaseOrderIds.isEmpty()) { return null; }
		Map<Id, Integer> cpoLineItemsCountHavingRiskOrderAlertByCPOId = new Map<Id, Integer>();
		for(AggregateResult result : [
			SELECT COUNT(Id), Apttus_Config2__PurchaseOrderId__c
			FROM Apttus_Config2__CustomerPOItem__c
			WHERE Apttus_Config2__PurchaseOrderId__c = :customerPurchaseOrderIds
			AND QTO_POI_Risk_Order_Alert__c <> NULL
		   
			GROUP BY Apttus_Config2__PurchaseOrderId__c
		]) {
			cpoLineItemsCountHavingRiskOrderAlertByCPOId.put(
				Id.valueOf(String.valueOf(result.get('Apttus_Config2__PurchaseOrderId__c'))),
				Integer.valueOf(result.get('expr0'))
			);
		}
		return cpoLineItemsCountHavingRiskOrderAlertByCPOId;
	}
}