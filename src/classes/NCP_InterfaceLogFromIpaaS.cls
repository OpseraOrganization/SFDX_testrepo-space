/*****************************
* Class Name: NCP_InterfaceLogFromIpaaS
* Created Date: 01/JAN/2021
* Created By: HCL Technologies
* Description: This class is used for logging all success/failure records made through ApexJob asynchronously.
*****************************/
public class NCP_InterfaceLogFromIpaaS implements Queueable, Database.AllowsCallouts
{
	//Variables Declaration
	private string jobID {get; set;}
	private string dELIMITER {get; set;}
	private string interfaceLogName {get; set;}
	private string interfaceLogNameAbb {get; set;}
	
	/*****************************
	*Constructor of NCP_InterfaceLogFromIpaaS Class
	*Description: Used for initializing jobID & dELIMITER
	*Parameters: param
	*******************************/
	public NCP_InterfaceLogFromIpaaS(string param)
	{
		this.jobID = param;
		this.dELIMITER = '\n';
	}
	
	/*****************************
	*Method Name: execute
	*Description: Execute Method of Queueable Class
	*Parameters: context
	*******************************/
	public void execute(QueueableContext context) 
	{
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		HttpResponse response;
		
		//Get The URL
		String endPointURL = System.Url.getSalesforceBaseURL().toExternalForm() + '/services/data/v43.0/jobs/ingest/' + this.jobID;
		System.debug('Endpoint URL: ' + endPointURL);
		request.setEndpoint(endPointURL);
		request.setMethod('GET');
		//String sessionId = UserInfo.getSessionId();
		
		// set authorization header
		request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
		
		BulkApiJob job = new BulkApiJob();
		try 
		{
			response = http.send(request);
			//system.debug('Response: ' + response.getBody());
			
			//job = (BulkApiJob)System.JSON.deserialize(response.getBody(), BulkApiJob.class);
			JSONParser parser = JSON.createParser(response.getBody());			
			while (parser.nextToken() != null) 
			{
				if (parser.getCurrentName() == 'id') 
				{
					job.id = parser.getText();
				}
				if (parser.getCurrentName() == 'object')
				{
					job.objectName = parser.getText();
				}
				if (parser.getCurrentName() == 'operation') 
				{
					job.operation = parser.getText();
				}
				if (parser.getCurrentName() == 'state')
				{
					job.status = parser.getText();
				}
				if (parser.getCurrentName() == 'contentType') 
				{
					job.contentType = parser.getText();
				}
				if (parser.getCurrentName() == 'numberRecordsProcessed')
				{
					job.numberRecordsProcessed = parser.getText();
				}
				if (parser.getCurrentName() == 'numberRecordsFailed')
				{
					job.numberRecordsFailed = parser.getText();
				}
				parser.nextToken();
			}
		} 
		catch (System.Exception e)
		{
			System.debug('ERROR: ' + e);
			throw e;
		}
				
		List<Interface_Log__c> allRecords = new List <Interface_Log__c>();		
		//----- SUCCESS OPERATION -----
		try 
		{
			List<Interface_Log__c> successRecords = logSuccessRecords(this.jobID, job);
			allRecords.addAll(successRecords);
		} 
		catch (Exception ex)
		{
			System.debug('success ex >> ' + ex.getMessage());
			NCP_InterfaceLog.insertInterfaceLog('CDB/CARES Interface Generic Error', 'Inbound', 'Upsert', 'CDB/CARES Interface Generic Success Error', 'Success', 'CreateInterfaceLogFromIpaaS', ex.getMessage());
		}
		
		//----- FAILED OPERATION -----
		try 
		{
			List<Interface_Log__c> failureRecords = logFailedRecords(this.jobID, job);
			allRecords.addAll(failureRecords);
		} 
		catch (Exception ex)
		{
			System.debug('Failed ex >> ' + ex.getMessage());
			NCP_InterfaceLog.insertInterfaceLog('CDB/CARES Interface Generic Error', 'Inbound', 'Upsert', 'CDB/CARES Interface Generic Failed Error', 'Failure', 'CreateInterfaceLogFromIpaaS', ex.getMessage());
		}
		
		system.debug('All Record Size: ' + allRecords.size());
		if(allRecords.size() > 0)
		{
			Database.upsert(allRecords, false);
		}
	}
	
	/*****************************
	*Method Name: logSuccessRecords
	*Description: Used for preparing list of Interface_Log__c SUCCESS Records.
	*Parameters: jobID, job
	*******************************/
	@TestVisible
	private List <Interface_Log__c> logSuccessRecords(String jobID, BulkApiJob job) 
	{
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		HttpResponse response;
		
		//Get Success URL
		String endPointURL = System.Url.getSalesforceBaseURL().toExternalForm() + '/services/data/v43.0/jobs/ingest/' + jobID + '/successfulResults/';
		request.setEndpoint(endPointURL);
		request.setMethod('GET');
		//String sessionId = UserInfo.getSessionId();
		
		//Set Authorization Header
		request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
		List<Interface_Log__c> interfaceLogList = new List <Interface_Log__c>();
		try 
		{
			response = http.send(request);
			
			//if response is CSV
			if (response.getHeader('Content-Type') == 'text/csv') 
			{
				String resBlobString = response.getBodyAsBlob().tostring();
				String[] inputHeadervalues = new String[]{};

				//get first csv line and separate columns
				String firstRow = resBlobString.substringBefore(this.dELIMITER);
				inputHeadervalues = firstRow.split(',');
				// removing the first line
				resBlobString = resBlobString.substringAfter(this.dELIMITER);
				
				Integer intCsvHeaderRecordType;
				Integer intCsvHeaderContractType;
				Integer intCsvHeaderExternalSCId;
				Integer intPriceBook2Name;
				Integer intExternalPriceBookEntryId;
				Integer intExternalCLIId;
				Integer intExternaId;
				
				//system.debug('Start parsing csv header line. Size is iinputHeadervalues.size()=' + inputHeadervalues.size());
				for (Integer j = 0; j < inputHeadervalues.size(); j++) 
				{
					//system.debug('inputHeadervalues[' + j + ']=' + inputHeadervalues[j]);
					if (job.objectName == 'ServiceContract') 
					{
						if (inputHeadervalues[j].replaceAll('(\r\n|\r|\")', '') == 'recordType.Name')
						{
							intCsvHeaderRecordType = j;
						}
						if (inputHeadervalues[j].replaceAll('(\r\n|\r|\")', '') == 'NCP_Contract_Type__c')
						{
							intCsvHeaderContractType = j;
						}
						if (inputHeadervalues[j].replaceAll('(\r\n|\r|\")', '') == 'NCP_External_Service_Contract_Id__c')
						{
							intCsvHeaderExternalSCId = j;
						}
						if (inputHeadervalues[j].replaceAll('(\r\n|\r|\")', '') == 'PriceBook2.Name')
						{
							intPriceBook2Name = j;
						}
					} 
					else if (job.objectName == 'ContractLineItem') 
					{
						if (inputHeadervalues[j].replaceAll('(\r\n|\r|\")', '') == 'ExternalPricebookEntryId__c') 
						{
							intExternalPriceBookEntryId = j;
						}
						if (inputHeadervalues[j].replaceAll('(\r\n|\r|\")', '') == 'NCP_External_Contract_Line_Item_Id__c') 
						{
							intExternalCLIId = j;
						}
					} 
					else if (job.objectName == 'NCP_Service_Contract_Team__c') 
					{
						if (inputHeadervalues[j].replaceAll('(\r\n|\r|\")', '') == 'NCP_External_Id__c') 
						{
							intExternaId = j;
						}
					} 
					else if (job.objectName == 'NCP_Authorised_Entitlement__c')
					{
						if (inputHeadervalues[j].replaceAll('(\r\n|\r|\")', '') == 'NCP_External_Id__c') 
						{
							intExternaId = j;
							system.debug(job.objectName + ',' + inputHeadervalues[j] + ',' + intExternaId);
						}
					}
				}
				
				//Iterate through every line
				while (String.isNotBlank(resBlobString))
				{
					String[] inputvalues = new String[]{};
						String currentRow = resBlobString.substringBefore(this.dELIMITER);
					inputvalues = currentRow.split(',');
					
					// removing the first line
					resBlobString = resBlobString.substringAfter(this.dELIMITER);
					String recordType;
					String contractType;
					String externalSCId;
					String priceBook2Name;
					String externalPriceBookEntryId;
					String externalCLIid;
					String externaId;
					
					if (intCsvHeaderRecordType != null) 
					{
						recordType = inputvalues[intCsvHeaderRecordType].replaceAll('(\r\n|\r|\")', '');
					}
					if (intCsvHeaderContractType != null)
					{
						contractType = inputvalues[intCsvHeaderContractType].replaceAll('(\r\n|\r|\")', '');
					}
					if (intCsvHeaderExternalSCId != null) 
					{
						externalSCId = inputvalues[intCsvHeaderExternalSCId].replaceAll('(\r\n|\r|\")', '');
					}
					if (intPriceBook2Name != null) 
					{
						priceBook2Name = inputvalues[intPriceBook2Name].replaceAll('(\r\n|\r|\")', '');
					}
					if (intExternalPriceBookEntryId != null) 
					{
						externalPriceBookEntryId = inputvalues[intExternalPriceBookEntryId].replaceAll('(\r\n|\r|\")', '');
					}
					if (intExternalCLIId != null) 
					{
						externalCLIid = inputvalues[intExternalCLIId].replaceAll('(\r\n|\r|\")', '');
					}
					if (intExternaId != null) 
					{
						externaId = inputvalues[intExternaId].replaceAll('(\r\n|\r|\")', '');
					}
					
					Interface_Log__c log = new Interface_Log__c();
					if (job.objectName == 'ServiceContract') 
					{
						//System.debug('in if recordType= ' + recordType + ', contractType=' + contractType);
						if (recordType == 'Parent Service Contract') 
						{
							log = NCP_InterfaceLog.createInterfaceLog(contractType + ' ' + recordType, 'Inbound', job.operation, contractType + ' ' + recordType + ' ' + externalSCId, 'Success', 'Success', firstRow + '\n' + currentRow);
							interfaceLogList.add(log);
						} 
						else if (recordType == 'Child Service Contract') 
						{
							contractType = priceBook2Name.remove(' Price Book');
							log = NCP_InterfaceLog.createInterfaceLog(contractType + ' ' + recordType, 'Inbound', job.operation, contractType + ' ' + recordType + ' ' + externalSCId, 'Success', 'Success', firstRow + '\n' + currentRow);
							interfaceLogList.add(log);
						}
					} 
					else if (job.objectName == 'ContractLineItem') 
					{
						Integer pb = externalPriceBookEntryId.indexOf(' Price Book-');
						contractType = externalPriceBookEntryId.left(pb);
						//system.debug('CLI contractType:' + contractType + ', CLI externalPriceBookEntryId=' + externalPriceBookEntryId);
						log = NCP_InterfaceLog.createInterfaceLog(contractType + ' Contract Line Item', 'Inbound', job.operation, contractType + ' Contract Line Item ' + externalCLIid, 'Success', 'Success', firstRow + '\n' + currentRow);
						interfaceLogList.add(log);
					} 
					else if (job.objectName == 'NCP_Service_Contract_Team__c') 
					{
						//system.debug('externaId:' + externaId);
						log = NCP_InterfaceLog.createInterfaceLog('Service Contract Team', 'Inbound', job.operation, 'Service Contract Team ' + externaId, 'Success', 'Success', firstRow + '\n' + currentRow);
						interfaceLogList.add(log);
					} 
					else if (job.objectName == 'NCP_Authorised_Entitlement__c') 
					{
						//system.debug('externaId:' + externaId);
						this.interfaceLogName = 'CARES Authorised Entitlement ' + externaId;
						this.interfaceLogNameAbb = this.interfaceLogName.abbreviate(80);
						log = NCP_InterfaceLog.createInterfaceLog('CARES Authorised Entitlement', 'Inbound', job.operation, this.interfaceLogNameAbb, 'Success', 'Success', firstRow + '\n' + currentRow);
						interfaceLogList.add(log);
					}
				}
				//system.debug('interfaceLogList.size()=' + interfaceLogList.size());
			}
			return interfaceLogList;
		} 
		catch (System.Exception e) 
		{
			System.debug('ERROR: ' + e);
			throw e;
		}
	}
	
	/*****************************
	*Method Name: logFailedRecords
	*Description: Used for preparing list of Interface_Log__c FAILURE Records.
	*Parameters: jobID, job
	*******************************/
	@TestVisible
	private List<Interface_Log__c> logFailedRecords(String jobID, BulkApiJob job) 
	{
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		HttpResponse response;
		
		//Get Failure URL
		String endPointURL = System.Url.getSalesforceBaseURL().toExternalForm() + '/services/data/v43.0/jobs/ingest/' + jobID + '/failedResults/';
		request.setEndpoint(endPointURL);
		request.setMethod('GET');
		//String sessionId = UserInfo.getSessionId();
		
		//Set Authorization Header
		request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
		List<Interface_Log__c> interfaceLogList = new List <Interface_Log__c>();
		try 
		{
			response = http.send(request);
			
			//if response is CSV
			if (response.getHeader('Content-Type') == 'text/csv') 
			{
				String resBlobString = response.getBodyAsBlob().tostring();				
				
				//get first csv line and separate columns
				String[] inputHeadervalues = new String[]{};
					
					String firstRow = resBlobString.substringBefore(this.dELIMITER);
				inputHeadervalues = firstRow.split(',');
				
				// removing the first line
				resBlobString = resBlobString.substringAfter(this.dELIMITER);
				Integer intCsvHeaderRecordType;
				Integer intCsvHeaderContractType;
				Integer intCsvHeaderExternalSCId;
				Integer intCsvHeaderSFError;
				Integer intPriceBook2Name;
				Integer intExternalPriceBookEntryId;
				Integer intExternalCLIId;
				Integer intExternaId;
				
				//system.debug('Start parsing csv header line. Size is iinputHeadervalues.size()=' + inputHeadervalues.size());
				for (Integer j = 0; j < inputHeadervalues.size(); j++) 
				{
					//system.debug('inputHeadervalues[' + j + ']=' + inputHeadervalues[j]);
					if (job.objectName == 'ServiceContract')
					{
						if (inputHeadervalues[j].replaceAll('(\r\n|\r|\")', '') == 'recordType.Name') 
						{
							intCsvHeaderRecordType = j;
						}
						if (inputHeadervalues[j].replaceAll('(\r\n|\r|\")', '') == 'NCP_Contract_Type__c') 
						{
							intCsvHeaderContractType = j;
						}
						if (inputHeadervalues[j].replaceAll('(\r\n|\r|\")', '') == 'NCP_External_Service_Contract_Id__c') 
						{
							intCsvHeaderExternalSCId = j;
						}
						if (inputHeadervalues[j].replaceAll('(\r\n|\r|\")', '') == 'sf__Error') 
						{
							intCsvHeaderSFError = j;
						}
						if (inputHeadervalues[j] == 'PriceBook2.Name') 
						{
							intPriceBook2Name = j;
						}
					} 
					else if (job.objectName == 'ContractLineItem')
					{
						if (inputHeadervalues[j].replaceAll('(\r\n|\r|\")', '') == 'ExternalPricebookEntryId__c') 
						{
							intExternalPriceBookEntryId = j;
						}
						if (inputHeadervalues[j].replaceAll('(\r\n|\r|\")', '') == 'NCP_External_Contract_Line_Item_Id__c') 
						{
							intExternalCLIId = j;
						}
						if (inputHeadervalues[j].replaceAll('(\r\n|\r|\")', '') == 'sf__Error')
						{
							intCsvHeaderSFError = j;
						}
					} 
					else if (job.objectName == 'NCP_Service_Contract_Team__c')
					{
						if (inputHeadervalues[j].replaceAll('(\r\n|\r|\")', '') == 'NCP_External_Id__c') 
						{
							intExternaId = j;
						}
						if (inputHeadervalues[j].replaceAll('(\r\n|\r|\")', '') == 'sf__Error') 
						{
							intCsvHeaderSFError = j;
						}
					}
					else if (job.objectName == 'NCP_Authorised_Entitlement__c') 
					{
						if (inputHeadervalues[j].replaceAll('(\r\n|\r|\")', '') == 'NCP_External_Id__c')
						{
							intExternaId = j;
						}
						if (inputHeadervalues[j].replaceAll('(\r\n|\r|\")', '') == 'sf__Error') 
						{
							intCsvHeaderSFError = j;
						}
					}
				}
				
				//system.debug('intCsvHeaderRecordType=' + intCsvHeaderRecordType + ', intCsvHeaderContractType=' + intCsvHeaderContractType + ', intCsvHeaderExternalSCId=' + intCsvHeaderExternalSCId + ', intCsvHeaderSFError=' + intCsvHeaderSFError + ', intPriceBook2Name=' + intPriceBook2Name + ', intExternalPriceBookEntryId=' + intExternalPriceBookEntryId + ', intExternalCLIId=' + intExternalCLIId);
				//Iterate through every line
				while (String.isNotBlank(resBlobString))
				{
					String[] inputvalues = new String[]{};
						String currentRow = resBlobString.substringBefore(this.dELIMITER);
					inputvalues = currentRow.split(',');
					// removing the first line
					resBlobString = resBlobString.substringAfter(this.dELIMITER);
					
					if (inputHeadervalues.size() != inputvalues.size()) 
					{
						continue;
					}
					String recordType;
					String contractType;
					String externalSCId;
					String priceBook2Name;
					String sfError;
					String externalPriceBookEntryId;
					String externalCLIid;
					String externaId;
					if (intCsvHeaderRecordType != null)
					{
						recordType = inputvalues[intCsvHeaderRecordType].replaceAll('(\r\n|\r|\")', '');
					}
					if (intCsvHeaderContractType != null) 
					{
						contractType = inputvalues[intCsvHeaderContractType].replaceAll('(\r\n|\r|\")', '');
					}
					if (intCsvHeaderExternalSCId != null) 
					{
						externalSCId = inputvalues[intCsvHeaderExternalSCId].replaceAll('(\r\n|\r|\")', '');
					}
					if (intCsvHeaderSFError != null)
					{
						sfError = inputvalues[intCsvHeaderSFError].replaceAll('(\r\n|\r|\")', '');
					}
					if (intPriceBook2Name != null) 
					{
						priceBook2Name = inputvalues[intPriceBook2Name].replaceAll('(\r\n|\r|\")', '');
					}
					if (intExternalPriceBookEntryId != null)
					{
						externalPriceBookEntryId = inputvalues[intExternalPriceBookEntryId].replaceAll('(\r\n|\r|\")', '');
					}
					if (intExternalCLIId != null) 
					{
						externalCLIid = inputvalues[intExternalCLIId].replaceAll('(\r\n|\r|\")', '');
					}
					if (intExternaId != null)
					{
						externaId = inputvalues[intExternaId].replaceAll('(\r\n|\r|\")', '');
					}
					
					//system.debug('job.objectName=' + job.objectName + ',recordType=' + recordType + ',sfError=' + sfError + ',externalSCId=' + externalSCId + ', priceBook2Name=' + priceBook2Name + ', externalPriceBookEntryId=' + externalPriceBookEntryId + ', externalCLIid=' + externalCLIid);
					Interface_Log__c log = new Interface_Log__c();
					if (job.objectName == 'ServiceContract') 
					{
						//System.debug('in if recordType= ' + recordType + ', contractType=' + contractType);
						if (recordType == 'Parent Service Contract') 
						{
							//System.debug('in if if recordType= ' + recordType + ', contractType=' + contractType);
							log = NCP_InterfaceLog.createInterfaceLog(contractType + ' ' + recordType, 'Inbound', job.operation, contractType + ' ' + recordType + ' ' + externalSCId, 'Failure', 'Failure: ' + sfError, firstRow + '\n' + currentRow);
							interfaceLogList.add(log);
						} 
						else if (recordType == 'Child Service Contract') 
						{
							if (priceBook2Name != null)
							{
								contractType = priceBook2Name.remove(' Price Book');
								log = NCP_InterfaceLog.createInterfaceLog(contractType + ' ' + recordType, 'Inbound', job.operation, contractType + ' ' + recordType + ' ' + externalSCId, 'Failure', 'Failure: ' + sfError, firstRow + '\n' + currentRow);
								interfaceLogList.add(log);
							}
						}
						
					} 
					else if (job.objectName == 'ContractLineItem') 
					{
						Integer pb = externalPriceBookEntryId.indexOf(' Price Book-');
						contractType = externalPriceBookEntryId.left(pb);
						//system.debug('CLI contractType:' + contractType + ', CLI externalPriceBookEntryId=' + externalPriceBookEntryId + ',externalCLIid=' + externalCLIid);
						log = NCP_InterfaceLog.createInterfaceLog(contractType + ' Contract Line Item', 'Inbound', job.operation, contractType + ' Contract Line Item ' + externalCLIid, 'Failure', 'Failure: ' + sfError, firstRow + '\n' + currentRow);
						interfaceLogList.add(log);
					} 
					else if (job.objectName == 'NCP_Service_Contract_Team__c')
					{
						//system.debug('externaId:' + externaId);
						log = NCP_InterfaceLog.createInterfaceLog('Service Contract Team', 'Inbound', job.operation, 'Service Contract Team ' + externaId, 'Failure', 'Failure: ' + sfError, firstRow + '\n' + currentRow);
						interfaceLogList.add(log);
					} 
					else if (job.objectName == 'NCP_Authorised_Entitlement__c')
					{
						//system.debug('externaId:' + externaId);
						this.interfaceLogName = 'CARES Authorised Entitlement ' + externaId;
						this.interfaceLogNameAbb = this.interfaceLogName.abbreviate(80);
						log = NCP_InterfaceLog.createInterfaceLog('CARES Authorised Entitlement', 'Inbound', job.operation, this.interfaceLogNameAbb, 'Failure', 'Failure: ' + sfError, firstRow + '\n' + currentRow);
						interfaceLogList.add(log);
					}
				}
			}
			return interfaceLogList;
		} 
		catch (System.Exception e) 
		{
			System.debug('ERROR: ' + e);
			throw e;
		}
	}
}