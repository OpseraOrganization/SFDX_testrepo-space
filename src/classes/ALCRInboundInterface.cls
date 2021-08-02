/***************************************************************
 Class Name:ALCRInboundInterface
 Author: Accenture
 Purpose: WSDL class for create/Update accounts from ALCR interface.

****************************************************************/
global class ALCRInboundInterface{
/***************************************************************
 Class Name:Response
 Author: Accenture
 Purpose: Response class to send status info to ALCR interface.
Requirement: Sales Process 633
****************************************************************/
	// Response class to send status info to ALCR interface
	global class Response{
		webservice String message;
		webservice Integer errorCode;
	}
/***************************************************************
 Class Name:AccountWrap class
 Author: Accenture
 Purpose: Account Wrapper class to get required accocunt info from ALCR (Through EIA interface).
****************************************************************/
	
	// Account Wrapper class to get required accocunt info from ALCR (Through EIA interface) 
	global class AccountWrap{
		webservice String customerNumber;
		webservice String legalName;
		webservice String currencyCode;
		webservice String activitySectorCode;  
		webservice String street;			 
		webservice String city;
		webservice String countryCodeISO2;		
		webservice String companyType;
		webservice String customerAccountCode;
		webservice String customerAccountName;
		webservice String fcgCode;
		webservice String fcgName;
		webservice String cat;
		webservice String keyAccountCode;
		webservice String keyAccountName;
		webservice String holdingAccountCode;
		webservice String holdingAccountName;
		webservice String salesforceRecordID; 
		webservice String legalNameExtension;							   
		webservice String businessName;				
		webservice String webAddress;
		webservice String marketCode;
		webservice String marketName;
		webservice String activityName;
		webservice String buildingFloor;
		webservice String postalCode;
		webservice String stateProvinceCountyCode;  
		//.webservice String accountManagerUPI;	   
		webservice Date companyEndDate;		
		webservice String reasonForEndName;
		webservice String assetQualityRatingCode;
		webservice String assetQualityRatingName;
		webservice String aluUnitCode;		
		webservice String qtcSoldTo;
		webservice String businessContinuation;		
		webservice String regionalUnit;
		webservice String region;
		//webservice String catLeaderUPI;
		webservice Date createdOn;
		webservice String createdByUser;
		webservice String customerUnitCode;
		webservice String customerUnitName;
		webservice String commercialCluster;
		webservice String recordType;
	}	//AccountWrap class ends here 
	
		//Interface Log Variables   
		global static String operationType;
		global static String interfaceType;
		global static String messageType;
		global static String errorMessage;
		global static String status;
		global static String name;
		global static String interfaceRequestSent;
		global static String comment;
	
	/*******************************************************************
	Purpose: webservice method to create/update Account(s)in Salesforce.
	********************************************************************/
  
	webservice static Response createAccount( AccountWrap accWrap){
	
		Response response = New Response();
		response = upsertAccount(accWrap);
		return response;
			
	}	// CreateAccount() method ends here
	
	/*******************************************************************
	Purpose: method to upsert Account(s)in Salesforce.
	********************************************************************/
	
	private static Response upsertAccount(AccountWrap accWrap){
		Response response = New Response();
		//String status, operationType;
		List<Account> accountList = new List<Account>();
		List<Opportunity> updateOpportunity = new List<Opportunity>();  
		List<Account> queryResult= new List<Account>();
		response = fieldsValidation(accWrap);
			if( response.errorCode != 0){
				status = 'Failure';
			}
			if(response.errorCode == 0){
				queryResult = [SELECT Id,AccountNumber FROM Account WHERE AccountNumber = : accWrap.CustomerNumber Limit 1];
				if(queryResult.size() > 0){// Got Result from Query Account Number,means the LE account has been created and it's an update
					accountList=queryResult;  
				}else{//LE account has not been created. As ALCR arrives before Pack 1.Then query by sf id.
					if(accWrap.salesforceRecordID != null && accWrap.salesforceRecordID != ''){
						queryResult = [SELECT Id,AccountNumber,BusinessPartnerRole__c FROM Account WHERE Id = : accWrap.salesforceRecordID Limit 1];
						if(queryResult.size() > 0){
							if('End Customer'.EqualsIgnoreCase(accWrap.recordType)){//update existing prospect to LE
							accountList=queryResult;
							}  // if BP role not equal to End Custom. We are suppose to create a new LE base on ALCR file. The new Account will be done in accountMapping method 
						}
					} 
					
				}
				Account account = accountMapping(accWrap,accountList);
					try{
						upsert account ;
						status = GlobalConstants.SUCCESS;
						System.debug('=====>Finish');
						if(!accountList.isEmpty()){
							//response.message = Label.ALCRInterface_Account_Update_Message;
							response.errorCode = 0;
							operationType = GlobalConstants.UPDATE_VALUE;
						}	
						else{
							//response.message = Label.ALCRInterface_Account_Insert_Message; 
							response.errorCode = 0; 
							operationType = GlobalConstants.INSERT_VALUE; 
						}	 
					} 
					catch(Exception e){
						response.message = e.getMessage();
						response.errorCode = 3; 
						status = GlobalConstants.FAILURE;
					}	  
			}
			
			/*if( response.errorCode == 0){
			  if((accWrap.customerNumber != null && accWrap.customerNumber != '') && (accWrap.salesforceRecordID != null && accWrap.salesforceRecordID != '')){
				  //accountList = [SELECT Id,AccountNumber FROM Account WHERE Id = : accWrap.salesforceRecordID LIMIT 1];
				  accountList = [SELECT Id,AccountNumber FROM Account WHERE (Id = : accWrap.salesforceRecordID OR AccountNumber = : accWrap.CustomerNumber) LIMIT 1];
				  //if(accountList.size() > 0)
					  //updateOpportunity = updateOpportunity(accountList,accWrap);
			  }
			  else{
				  accountList = [SELECT Id,AccountNumber FROM Account WHERE AccountNumber = : accWrap.CustomerNumber LIMIT 1];  
			  }  
				
				
			} 
			*/
			//Below method never working. thus deactive
		 /*   if(updateOpportunity.size()>0){
				try{
					  update updateOpportunity; 
				}catch(Exception e){
					String exc = e.getMessage();
					System.debug(GlobalConstants.ERROR+ exc);
				}
			}*/ 
			
			//Initializing the 'Interface log' record
			String accountKey = (accWrap.customerNumber != null && accWrap.customerNumber != '')?accWrap.customerNumber:accWrap.salesforceRecordID;
			name = GlobalConstants.ACCOUNT_NUMBER + accountKey;
			operationType = operationType;
			status = status;
			interfaceType = GlobalConstants.INTERFACE_TYPE;
			messageType = GlobalConstants.INBOUND;
			errorMessage = response.message + '\r\n' + GlobalConstants.ACCOUNT_NUMBER_COLON + accWrap.customerNumber + 
			'\r\n' + GlobalConstants.SALESFORCE_ID + accWrap.salesforceRecordID;
			//interfaceRequestSent = String.valueOf(opptyWrap);
			InterfaceLogHandler.interfaceTransactionHandler(interfaceType, messageType, operationType, name, status, errorMessage);
			return response; 
	}	// upsertAccount() method ends here
	
	
	/*******************************************************************
	Purpose: This method is used for mapping ALCR fields with fields in Salesforce.
	********************************************************************/
	
	private static Account accountMapping(AccountWrap accWrap,Account[] mapAccount){
	System.debug(GlobalConstants.MAP_ACC_SIZE+ mapAccount.size());
		Account acc = new Account();
		List<String> currencyCodeList = new List<String>();
		
			if(!mapAccount.isEmpty()){
				acc = mapAccount[0];
			}
			/*if(mapAccount.isEmpty()){ 
				if(ALCR_Account_OwnerId__c.getValues('AccountOwner') != null)   
				  acc.OwnerId = ALCR_Account_OwnerId__c.getValues('AccountOwner').Owner_Id__c;
			}*/
			acc.AccountNumber = accWrap.customerNumber;
			acc.Name = accWrap.legalName; 
			Schema.sObjectType objType = Account.getSObjectType(); 
			Schema.DescribeFieldResult objDescribe  = Account.CurrencyIsoCode.getDescribe();
			List<Schema.PicklistEntry> values  = objDescribe .getPicklistValues();
			for (Schema.PicklistEntry entry : values ){ 
				currencyCodeList.add(entry.getValue());
			}
			boolean flag = false;
			for(Integer i=0;i<currencyCodeList.size();i++){
				if(currencyCodeList[i] == accWrap.CurrencyCode){
					flag = true;	
				}
			}   
			if(flag == true){
				acc.CurrencyIsoCode = accWrap.currencyCode;
			}
			else{
				acc.CurrencyIsoCode = GlobalConstants.EUR;
			}
			acc.Activity_Sector_Code__c = accWrap.activitySectorCode;
			acc.BillingStreet = accWrap.street;
			acc.BillingCity = accWrap.city;
			acc.CountryNameISO2__c = accWrap.countryCodeISO2;
			acc.CountryCode__c = accWrap.countryCodeISO2;
			if(ISO_Country_Codes__c.getValues(accWrap.countryCodeISO2)!=NULL){
				acc.BillingCountry  = ISO_Country_Codes__c.getValues(accWrap.countryCodeISO2).Country_Name__c;
				acc.Country__c  = ISO_Country_Codes__c.getValues(accWrap.countryCodeISO2).Country_Name__c;
			}
			acc.Type = accWrap.companyType;
			acc.Customer_Account_Code__c = accWrap.customerAccountCode;
			acc.Customer_Account_Name__c = accWrap.customerAccountName;
			acc.FCG_Code__c = accWrap.fcgCode;
			acc.FCG_Name__c = accWrap.fcgName; 
			acc.CBT_CT_Code__c= accWrap.cat;
			acc.Key_Account_Code__c  = accWrap.keyAccountCode;
			acc.Key_Account_Name__c = accWrap.keyAccountName; 
			acc.Holding_Account_Code__c = accWrap.holdingAccountCode;
			acc.Holding_Account_Name__c = accWrap.holdingAccountName; 
			acc.Legal_Name_ext__c = accWrap.legalNameExtension;
			acc.Business_Name__c = accWrap.businessName;
			acc.Website = accWrap.webAddress; 
			acc.Market_Code__c = accWrap.marketCode;
			acc.Market_Segment__c = accWrap.marketName;
			acc.Activity_Sector_Name__c = accWrap.activityName;
			acc.Building_Floor__c = accWrap.buildingFloor;
			acc.BillingPostalCode  = accWrap.postalCode;  
			acc.state__c = accWrap.stateProvinceCountyCode;
			if(ISOStateCodes__c.getValues(accWrap.countryCodeISO2+'-'+accWrap.stateProvinceCountyCode)!=NULL){
				acc.BillingState = ISOStateCodes__c.getValues(accWrap.countryCodeISO2+'-'+accWrap.stateProvinceCountyCode).StateName__c;
			}
			acc.End_Date__c = accWrap.companyEndDate;
			acc.Reason_for_End__c = accWrap.reasonForEndName;
			acc.Asset_Quality_Rating_Code__c = accWrap.assetQualityRatingCode;
			acc.Asset_Quality_Rating_Name__c = accWrap.assetQualityRatingName;
			acc.ALU_Unit_Code__c = accWrap.aluUnitCode; 
			acc.QTC_Sold_To__c = accWrap.qtcSoldTo;
			acc.Business_Continuation__c = accWrap.businessContinuation;
			//acc.Regional_Unit__c = accWrap.regionalUnit;
			acc.Market__c = accWrap.region;
			acc.ALCR_Created_Date__c = accWrap.createdOn;
			acc.ALCR_Created_By__c = accWrap.createdByUser;
			acc.MU_GCBT_Code__c = accWrap.customerUnitCode; 
			acc.MU_GCBT_Name__c= accWrap.customerUnitName; 
			//acc.Commercial_Cluster__c = accWrap.commercialCluster;
			/****added by Debin Kuriakose [IDC] on 05/11/2015 for ALCR Modernization****/
		   acc.ALCR_Record_Type__c = accWrap.recordType;
		   acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(GlobalConstants.LEGAL_ENTITY).getRecordTypeId();			
		   /***************************************************************************/
			if(acc.End_Date__c <> NULL)
				acc.active__c = false;
			else
				acc.active__c = true;
			return acc;
	}	// accountMapping() method ends here
	
	/*******************************************************************
	Purpose: This method validates ALCR Interface fields .
	********************************************************************/
	private static Response fieldsValidation(AccountWrap accWrap){
		Response response = new Response();
		response.errorCode =0;   
										   
		if( accWrap.customerNumber == null || accWrap.customerNumber == ''){
			response.errorCode = 1; 
			response.message = GlobalConstants.CUSTOMER_NUMBER_BLANK; 
		} 
		else if(accWrap.legalName == null ||accWrap.legalName == ''){
			response.errorCode = 1; 
			response.message = GlobalConstants.LEGEAL_NAME_BLANK + accWrap.customerNumber; 
		} 
		else if (accWrap.currencyCode == null || accWrap.currencyCode == ''){
			response.errorCode = 1; 
			response.message = GlobalConstants.CURRENCY_CODE_BLANK+ accWrap.customerNumber; 
		}
		else if (accWrap.activitySectorCode == null || accWrap.activitySectorCode == ''){ 
			response.errorCode = 1; 
			response.message = GlobalConstants.ACTIVITY_SECTOR_BLANK + accWrap.customerNumber; 
		}
		else if (accWrap.street == null || accWrap.street == ''){ 
			response.errorCode = 1; 
			response.message = GlobalConstants.STREET_BLANK + accWrap.customerNumber; 
		}
		else if (accWrap.city == null || accWrap.city == ''){ 
			response.errorCode = 1; 
			response.message = GlobalConstants.CITY_BLANK + accWrap.customerNumber; 
		}
		else if (String.isBlank(accWrap.countryCodeISO2) || accWrap.countryCodeISO2.equals(GlobalConstants.BLANK_VALUE)){ 
			response.errorCode = 1; 
			response.message = GlobalConstants.COUNTRY_CODE_ISO2_BLANK + accWrap.customerNumber;
		}
		/*else if (accWrap.companyType == null || accWrap.companyType == ''){ 
			response.errorCode = 1; 
			response.message = 'Required Company Type field is empty. Customer Number : '+ accWrap.customerNumber; 
		}*/
		else if (accWrap.customerAccountCode == null || accWrap.customerAccountCode == ''){ 
			response.errorCode = 1; 
			response.message = GlobalConstants.CUSTOMER_ACCOUNT_CODE_BLANK + accWrap.customerNumber; 
		}
		else if (accWrap.customerAccountName == null || accWrap.customerAccountName == ''){ 
			response.errorCode = 1; 
			response.message = GlobalConstants.CUSTOMER_ACCOUNT_NAME_BLANK + accWrap.customerNumber; 
		}
		else if (accWrap.fcgCode == null || accWrap.fcgCode == ''){ 
			response.errorCode = 1; 
			response.message = GlobalConstants.FGC_CODE_BLANK+ accWrap.customerNumber; 
		}
		else if (accWrap.fcgName == null || accWrap.fcgName == ''){ 
			response.errorCode = 1; 
			response.message = GlobalConstants.FGC_NAME_BLANK+ accWrap.customerNumber; 
		}
		/*else if(accWrap.cat == null || accWrap.cat == ''){ 
			response.errorCode = 1; 
			response.message = 'Required CAT field is empty. Customer Number : '+ accWrap.customerNumber; 
		}*/
		else if (accWrap.keyAccountCode == null || accWrap.keyAccountCode == ''){ 
			response.errorCode = 1; 
			response.message = 'Required Key Account Code field is empty. Customer Number : '+ accWrap.customerNumber; 
		}
		else if (accWrap.keyAccountName == null || accWrap.keyAccountName == ''){ 
			response.errorCode = 1; 
			response.message = GlobalConstants.KEY_ACCOUNT_NAME_BLANK+ accWrap.customerNumber; 
		}
		else if (accWrap.holdingAccountCode == null || accWrap.holdingAccountCode == ''){ 
			response.errorCode = 1; 
			response.message = 'Required Holding Account Code field is empty. Customer Number : '+ accWrap.customerNumber; 
		}
		else if (accWrap.holdingAccountName == null || accWrap.holdingAccountName == ''){ 
			response.errorCode = 1; 
			response.message = GlobalConstants.HOLDING_ACCOUNT_NAME_BLANK + accWrap.customerNumber; 
		}
		/*else if (accWrap.accountManagerUPI == null || accWrap.accountManagerUPI == ''){ 
			response.errorCode = 1; 
			response.message = 'Required Account Manager UPI field is empty. Customer Number : '+ accWrap.customerNumber; 
		}*/
		//else if( accWrap.companyType != null && !(accWrap.companyType =='Prospect' || accWrap.companyType == 'Customer' || accWrap.companyType == 'ALU Unit' || accWrap.companyType == 'Partner')){
		else if( accWrap.companyType != null && !(accWrap.companyType =='Prospect' || accWrap.companyType == 'Customer' || accWrap.companyType == 'Alcatel-Lucent Unit' || accWrap.companyType == 'Partner')){
			response.errorCode = 2; 
			response.message = 'Invalid value for field Company Type. Customer Number : '+ accWrap.customerNumber;
		}
		/*else if( accWrap.countryCodeISO2 != null){
			List<String> CountryCodeList = new List<String>();
			Schema.sObjectType objType = Account.getSObjectType(); 
			Schema.DescribeFieldResult objDescribe  = Account.Country_Code__c.getDescribe();
			List<Schema.PicklistEntry> values  = objDescribe.getPicklistValues();
			for(Schema.PicklistEntry entry : values ){ 
				CountryCodeList.add(entry.getValue());
			}
			boolean flag = false;
			for(Integer i= 0;i < CountryCodeList.size();i++){
				if(CountryCodeList[i] == accWrap.countryCodeISO2){
					flag = true;
				   // break;
				}
			}  
			if( flag != true){
				response.errorCode = 2;
				response.message = 'Invalid value for field Country Code ISO2. Customer Number : '+ accWrap.customerNumber;
			} 
		}*/
			  
		return response;   
	}	// fieldsValidation() method ends here
	
	/**************************************************************************************************
	Purpose: This method is to update Opportunities associated with the incoming prospect in Salesforce.
	
	private static List<Opportunity> updateOpportunity(List<Account> accountList,AccountWrap accWrap){
	  List<Opportunity> opportunityList = new List<Opportunity>();
	  List<Opportunity> opportunityUpdate = new List<Opportunity>();
	  
	  opportunityList = [Select Id from Opportunity where AccountId =: accountList[0].Id];
			  
	  if(opportunityList.size() > 0){
		  for(Opportunity oppty: opportunityList){
			  oppty.Region__c = accWrap.region;
			  oppty.Regional_Unit__c = accWrap.regionalUnit;
			  opportunityUpdate.add(oppty);
		  }
	   }   
	   return opportunityUpdate;
	}
	***************************************************************************************************/
}	// End of main class ALCR_InboundInterface/