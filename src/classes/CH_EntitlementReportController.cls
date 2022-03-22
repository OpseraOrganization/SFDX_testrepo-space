/****************************************
* Class Name : CH_EntitlementReportController
* Created Date: 15th May 2019
* Created By : TCS
* Last Modified by: Prateek Sarangi
* Last Modified Date: 19 November 2019
* Description : Display Entitlement Report 
* Test Class: CH_EntitlementReportControllerTest
*****************************************/
public class CH_EntitlementReportController {
	@AuraEnabled
	public static List < ContractLineItem > getLineItemReport(String caseId, String reportType) {
		List < ContractLineItem > lineItemList = new List < ContractLineItem > ();
		if(String.isNotBlank(caseId)) {
			Case caseObj = [SELECT Id, AccountId, Account.Name, ContactId, ProductId, Contact.account.Name, Country__c, CH_ServiceType__c FROM Case WHERE Id = :caseId limit 1];
			if(caseObj != null) {
				//Added by Prateek for NOKIASC-22364
				String ServiceType = caseObj.CH_ServiceType__c;
				String Contact_Account_Name = caseObj.Contact.account.Name;
				//String contact_LegalEntityName = caseObj.Contact.CH_Legal_Entity_Name__c ;
				String Account_Name = caseObj.Account.Name;
				String serviceContractAccountName = 'nokia%';
				//System.debug(ServiceType+'\n'+Contact_Account_Name+'\n'+Account_Name+'\n'+reportType+'\n'+contact_LegalEntityName);
				if(reportType == 'ReportType-A') {
					// Button 1 "Search Service Contracts + AC Check"
					Set < Id > contractIds = new Set < Id > ();
					for(EntitlementContact entContactObj: [SELECT Entitlement.ServiceContractId FROM EntitlementContact WHERE ContactId = :caseObj.contactId]) {
						contractIds.add(entContactObj.Entitlement.ServiceContractId);				
					}
					//Added by Prateek for NOKIASC-22364
					if(ServiceType == 'Internal Support'){
						lineItemList = [SELECT ServiceContractId, ServiceContract.Name, ServiceContract.Account.Name, ServiceContract.CH_Project__c, LineItemNumber, AssetId, Asset.Name, CH_ServiceOffering__c, StartDate, EndDate, ServiceContract.NCP_External_Status__c, NCP_External_Status__c FROM ContractLineItem 
								WHERE ServiceContractId IN :contractIds 
								AND ServiceContract.NCP_External_Status__c = 'Active' 
								AND Asset.Product2Id = :caseObj.ProductId 
								AND Asset.CH_CountryISOName__c = :caseObj.Country__c 
								AND CH_ServiceType__c = :caseObj.CH_ServiceType__c	 
		AND (ServiceContract.Account.Name like :serviceContractAccountName )					 
								AND NCP_External_Status__c = 'Active'];
					}
					else if (ServiceType == 'Customer Support'){
						lineItemList = [SELECT ServiceContractId, ServiceContract.Name, ServiceContract.CH_Project__c, LineItemNumber, AssetId, Asset.Name, CH_ServiceOffering__c, StartDate, EndDate, ServiceContract.NCP_External_Status__c, NCP_External_Status__c FROM ContractLineItem 
								WHERE ServiceContractId IN :contractIds 
								AND ServiceContract.AccountId = :caseObj.AccountId 
								AND ServiceContract.NCP_External_Status__c = 'Active' 
								AND Asset.Product2Id = :caseObj.ProductId 
								AND Asset.CH_CountryISOName__c = :caseObj.Country__c 
								AND CH_ServiceType__c = :caseObj.CH_ServiceType__c 
								AND NCP_External_Status__c = 'Active'];
					}
					
				} else if(reportType == 'ReportType-B') {
					// Button 2 "Search Service Contracts – Ignore AC Check"
					//Added by Prateek for NOKIASC-22364
					if(ServiceType == 'Internal Support'){
						lineItemList = [SELECT ServiceContractId, ServiceContract.Name, ServiceContract.Account.Name, ServiceContract.CH_Project__c, LineItemNumber, AssetId, Asset.Name, CH_ServiceOffering__c, StartDate, EndDate, ServiceContract.NCP_External_Status__c, NCP_External_Status__c FROM ContractLineItem 
							WHERE ServiceContract.NCP_External_Status__c = 'Active' 
							AND Asset.Product2Id = :caseObj.ProductId 
							AND Asset.CH_CountryISOName__c = :caseObj.Country__c 
							AND CH_ServiceType__c = :caseObj.CH_ServiceType__c  
				AND (ServiceContract.Account.Name like :serviceContractAccountName )
							AND NCP_External_Status__c = 'Active'];
					}
					else if (ServiceType == 'Customer Support'){
						lineItemList = [SELECT ServiceContractId, ServiceContract.Name, ServiceContract.CH_Project__c, LineItemNumber, AssetId, Asset.Name, CH_ServiceOffering__c, StartDate, EndDate, ServiceContract.NCP_External_Status__c, NCP_External_Status__c FROM ContractLineItem 
							WHERE ServiceContract.AccountId = :caseObj.AccountId 
							AND ServiceContract.NCP_External_Status__c = 'Active' 
							AND Asset.Product2Id = :caseObj.ProductId 
							AND Asset.CH_CountryISOName__c = :caseObj.Country__c 
							AND CH_ServiceType__c = :caseObj.CH_ServiceType__c 
							AND NCP_External_Status__c = 'Active'];
					}
				} else if(reportType == 'ReportType-C') {
					// Button 3 "Search Recently Expired Service Contracts + Ignore AC Check"
					//Added by Prateek for NOKIASC-22364
					if(ServiceType == 'Internal Support'){
						lineItemList = [SELECT ServiceContractId, ServiceContract.Name, ServiceContract.Account.Name, ServiceContract.CH_Project__c, LineItemNumber, AssetId, Asset.Name, CH_ServiceOffering__c, StartDate, EndDate, ServiceContract.NCP_External_Status__c, NCP_External_Status__c FROM ContractLineItem
							WHERE (ServiceContract.NCP_External_Status__c != 'Active' OR NCP_External_Status__c != 'Active') 
							AND ServiceContract.EndDate = LAST_N_DAYS:180 
							AND Asset.Product2Id = :caseObj.ProductId 
							AND Asset.CH_CountryISOName__c = :caseObj.Country__c  
				AND (ServiceContract.Account.Name like :serviceContractAccountName )
							AND CH_ServiceType__c = :caseObj.CH_ServiceType__c];
					}
					else if (ServiceType == 'Customer Support'){
						lineItemList = [SELECT ServiceContractId, ServiceContract.Name, ServiceContract.CH_Project__c, LineItemNumber, AssetId, Asset.Name, CH_ServiceOffering__c, StartDate, EndDate, ServiceContract.NCP_External_Status__c, NCP_External_Status__c FROM ContractLineItem 
							WHERE ServiceContract.AccountId = :caseObj.AccountId 
							AND (ServiceContract.NCP_External_Status__c != 'Active' OR NCP_External_Status__c != 'Active') 
							AND ServiceContract.EndDate = LAST_N_DAYS:180 
							AND Asset.Product2Id = :caseObj.ProductId 
							AND Asset.CH_CountryISOName__c = :caseObj.Country__c 
							AND CH_ServiceType__c = :caseObj.CH_ServiceType__c];
					}
					
				} else {
					System.debug('### Invalid Report Type ### ' + reportType);
				}			   
			}						
		}
		return lineItemList;
	}
}