/**
 * @description	   : 
 * @author			: Yashdeep Prajapati
 * @group			 : 
 * @last modified on  : 06-15-2021
 * @last modified by  : Yashdeep Prajapati
 * Modifications Log 
 * Ver   Date		 Author			   Modification
 * 1.0   06-04-2021   Yashdeep Prajapati   Initial Version
 **/
global without sharing class NokiaCPQ_InactiveProductBatch implements Database.Batchable < sObject > , Database.Stateful {

	Boolean isSendAll{get;set;}
	//time when the last batch
	Datetime lastRun {get;set;}
	Map<string, List <Map<string,string>>> mProductPortfolio = new Map<string, List <Map<string,string>>>();
	List<NokiaCPQ_Deactivated_Products__c> processedRecords = new List<NokiaCPQ_Deactivated_Products__c>();
	public NokiaCPQ_InactiveProductBatch(Boolean isSendAll,Datetime lastRun){
		this.isSendAll = isSendAll;
		this.lastRun = lastRun;
	}
  
	global Database.QueryLocator start(Database.BatchableContext bc) {
	//   return Database.getQueryLocator([select id, name, ConfiguratorName__c from Inactive__c where createddate = today]);
	// if(this.isSendAll){
	//	 return Database.getQueryLocator([SELECT Id,Name,  NCPQ_Product__c,NCPQ_Product__r.ProductCode,NCPQ_Product__r.Name,NCPQ_Product__r.NokiaCPQ_State__c,NCPQ_Product__r.Portfolio__c, NCPQ_JobId__c FROM NokiaCPQ_Deactivated_Products__c WHERE CreatedDate >= LAST_N_DAYS:6 AND CreatedDate >= :this.lastRun ORDER BY NCPQ_Product__r.Portfolio__c]);
	// }else{
	//	 return Database.getQueryLocator([SELECT Id,Name,  NCPQ_Product__c,NCPQ_Product__r.ProductCode,NCPQ_Product__r.Name,NCPQ_Product__r.NokiaCPQ_State__c,NCPQ_Product__r.Portfolio__c, NCPQ_JobId__c FROM NokiaCPQ_Deactivated_Products__c WHERE CreatedDate >= LAST_N_DAYS:1 AND CreatedDate >= :this.lastRun AND NCPQ_JobId__c = NULL ORDER BY NCPQ_Product__r.Portfolio__c]);
	// }
	return Database.getQueryLocator([SELECT Id,Name,  NCPQ_Product__c,NCPQ_Product__r.ProductCode,NCPQ_Product__r.Name,NCPQ_Product__r.NokiaCPQ_State__c,NCPQ_Product__r.Portfolio__c, NCPQ_JobId__c FROM NokiaCPQ_Deactivated_Products__c WHERE CreatedDate >= :this.lastRun ORDER BY NCPQ_Product__r.Portfolio__c]);
	  
	}
	global void execute(Database.BatchableContext bc, List < NokiaCPQ_Deactivated_Products__c > scope) {
		System.debug('scope.size()' + scope.size());
	  if (scope.size() > 0) {
		List < Apttus_Config2__ProductOptionComponent__c > pocList = [SELECT Apttus_Config2__ComponentProductId__c,Apttus_Config2__ParentProductId__c, Apttus_Config2__ParentProductId__r.Name,Apttus_Config2__ParentProductId__r.IsActive,Apttus_Config2__ParentProductId__r.ProductCode FROM Apttus_Config2__ProductOptionComponent__c];
		for (NokiaCPQ_Deactivated_Products__c dap: scope) {
		  Map < string, string > configurtors = getParent(dap.NCPQ_Product__c, pocList);
		  System.debug('configurtors' + configurtors);
		  if (configurtors != null && configurtors.size() > 0) {
			dap.NCPQ_JobId__c = bc.getJobId();
			processedRecords.add(dap);
			for (string prodCode: configurtors.keySet()) {
			  Map < string, string > mProd = new Map < string, string > ();
			  mProd.put('Product Code', dap.NCPQ_Product__r.ProductCode);
			  mProd.put('Product Name', dap.NCPQ_Product__r.Name);
			  mProd.put('State', dap.NCPQ_Product__r.NokiaCPQ_State__c);
			  mProd.put('Configurator Product Code', prodCode);
			  mProd.put('Configurator Product Name', configurtors.get(prodCode));
			  if (mProductPortfolio.containsKey(dap.NCPQ_Product__r.Portfolio__c)) {
				List <Map<string,string>> mList = mProductPortfolio.get(dap.NCPQ_Product__r.Portfolio__c);
				mList.add(mProd);
				mProductPortfolio.put(dap.NCPQ_Product__r.Portfolio__c, mList);
			  } else {
				mProductPortfolio.put(dap.NCPQ_Product__r.Portfolio__c, new List <Map<string, string>> {
				  mProd
				});
			  }
			}
		  }
		}
	  }
	}
  
	global void finish(Database.BatchableContext BC) {
	  if (mProductPortfolio.size() > 0) {
		List<NokiaCPQ_EmailRecipient__mdt> emailRecepientMdt = [SELECT NokiaCPQ_EmailBody__c,NokiaCPQ_EmailRecipients__c,NokiaCPQ_Subject__c FROM NokiaCPQ_EmailRecipient__mdt WHERE Label = 'ConfigNMasterDataInconsistency'];
		if(emailRecepientMdt != null && emailRecepientMdt.size() > 0){
			NokiaCPQ_EmailRecipient__mdt erMdt = emailRecepientMdt[0];
			List < String > headerList = new List < String > {
				'Portfolio',
				'Product Code',
				'Product Name',
				'Product State',
				'Configurator Product Code',
				'Configurator Product Name'
			  };
			  String csvFileString = '';
			  String fileRow = '';
			  for (String fieldName: headerList) {
				String row = fieldName + ',';
				fileRow = fileRow + row;
			  }
			  csvFileString = csvFileString + fileRow + '\n';
			  for (String key: mProductPortfolio.keySet()) {
				for (Map < string, string > data: mProductPortfolio.get(key)) {
				  String row = key + ',' + (data.containskey('Product Code') ? data.get('Product Code') : '') + ',' + (data.containskey('Product Name') ? data.get('Product Name') : '') + ',' + (data.containskey('State') ? data.get('State') : '') + ',' + (data.containskey('Configurator Product Code') ? data.get('Configurator Product Code') : '') + ',' + (data.containskey('Configurator Product Name') ? data.get('Configurator Product Name') : '') + ',' + '\n';
				  csvFileString = csvFileString + row;
				}
			  }
		
			  Blob csvBlob = Blob.valueOf(csvFileString);
			  Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
			  Datetime runDate = Datetime.now();
			  String statisticsReportFileName = 'InactiveProducts-' + (this.isSendAll ? 'Consolidated-' : 'New-') + runDate.format('dd/MM/yyyy').replace('/', '') + String.valueOf(runDate.hour()) + String.valueOf(runDate.minute()) + '.csv';
			  csvAttachment.setFileName(statisticsReportFileName);
			  csvAttachment.setBody(csvBlob);
			  Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
			  List < string > recipients = erMdt.NokiaCPQ_EmailRecipients__c.split(';');
			  if (recipients != null && !recipients.isEmpty()) {
				String subject = erMdt.NokiaCPQ_Subject__c + (this.isSendAll ? 'Consolidated' : 'New');
				email.setSubject(subject);
				email.setToAddresses(recipients);
				email.setPlainTextBody(erMdt.NokiaCPQ_EmailBody__c);
				email.setFileAttachments(new Messaging.EmailFileAttachment[] {
				  csvAttachment
				});
				Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
				  email
				});
			  }
			  if(processedRecords.size() > 0){
				update processedRecords;
			  }
		}

	  }
	}
	private Map < string, string > getParent(string prodId, List < Apttus_Config2__ProductOptionComponent__c > pocList) {
		System.debug('prodId' + prodId + 'size' + pocList.size());
	  Map < string, string > configuratorMap = new Map < string, string > ();
	  if (pocList != null && pocList.size() > 0) {
		for (Apttus_Config2__ProductOptionComponent__c poc: pocList) {
		  if (poc.Apttus_Config2__ComponentProductId__c == prodId) {
			  Map < string, string > parent = getParent(poc.Apttus_Config2__ParentProductId__c, pocList);
			  if (parent == null) {
				  if(configuratorMap.size() == 0){
					configuratorMap = null;
				  }
				continue;
			  } else if (parent.size() == 0) {
				if (!poc.Apttus_Config2__ParentProductId__r.IsActive) {
					return null;
				  }
				else if (configuratorMap == null || !configuratorMap.containsKey(poc.Apttus_Config2__ParentProductId__r.ProductCode)) {
					if(configuratorMap == null){
						configuratorMap = new Map <string,string>();
					}
				  configuratorMap.put(poc.Apttus_Config2__ParentProductId__r.ProductCode, poc.Apttus_Config2__ParentProductId__r.Name);
				}
			  } else {
				configuratorMap.putAll(parent);
			  }
		  }
		}
	  }
	  return configuratorMap;
	}
  }