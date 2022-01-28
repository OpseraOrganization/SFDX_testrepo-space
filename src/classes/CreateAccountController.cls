public class CreateAccountController {
   
	@AuraEnabled 
	public static String GetPicklistDateFromAccount(){
		
		List<SelectOption> options = new List<SelectOption>();
		
		Schema.DescribeFieldResult fieldResult =
			Account.Customer_Compliance__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	   List<ResultWrapper> lstRet = new List<ResultWrapper>();
		try{
			for(Schema.PicklistEntry f : ple){
				ResultWrapper obj1 = new ResultWrapper();
				obj1.CustomerCompliance = String.valueOf(f.getLabel());
				lstRet.add(obj1);
			} 
		}catch(System.Exception e){
		}
		return JSON.serialize(lstRet);
	}
	
	@AuraEnabled 
	public static List<String> getMarketSegmentMdt() {
		Set<String> segments = new Set<String>();
		List<String> options;
		try{
			for(Market_Segment_and_Activity_Sector_Name__mdt mdt : [SELECT Market_Segment__c 
																	FROM Market_Segment_and_Activity_Sector_Name__mdt
																		order by Market_Segment__c]) {
				segments.add(mdt.Market_Segment__c);										   
			}
			options = new List<String>(segments);
		}catch(Exception e) {}
		return options;
	}
	
	@AuraEnabled 
	public static List<String> getActivitySectorValues(String marketSegment) {
		List<String> options = new List<String>();
		try{
			for(Market_Segment_and_Activity_Sector_Name__mdt mdt : [SELECT Market_Segment__c, Activity_Sector_Name__c
																	FROM Market_Segment_and_Activity_Sector_Name__mdt
																	WHERE Market_Segment__c =: marketSegment
																		order by Activity_Sector_Name__c]) {
				options.add(mdt.Activity_Sector_Name__c);													  
			}
		}catch(Exception e) {}
		return options;
	}
	
	@AuraEnabled
	public static List<String> getMarketSegment(){
		List<String> options = new List<String>();
		try{
			Schema.DescribeFieldResult fieldResult = Account.Market_Segment__c.getDescribe();
			for (Schema.PicklistEntry f: fieldResult.getPicklistValues()) {
				options.add(f.getLabel());
			}
		}Catch(System.Exception e) {
			//String message=e.getMessage();
			//ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseCountry);
		}
		return options;
	}
	@AuraEnabled
	public static List<String> getCustomerCompliance(){
		List<String> options = new List<String>();
		try{
			Schema.DescribeFieldResult fieldResult = Account.Customer_Compliance__c.getDescribe();
			for (Schema.PicklistEntry f: fieldResult.getPicklistValues()) {
				options.add(f.getLabel());
			}
		}Catch(System.Exception e) {
			//String message=e.getMessage();
			//ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseCountry);
		}
		return options;
	}
	
	@AuraEnabled
	public static List<String> getMarket(){
		List<String> options = new List<String>();
		try{
			Schema.DescribeFieldResult fieldResult = Account.Market__c.getDescribe();
			for (Schema.PicklistEntry f: fieldResult.getPicklistValues()) {
				options.add(f.getLabel());
			}
		}Catch(System.Exception e) {
			//String message=e.getMessage();
			//ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseCountry);
		}
		return options;
	}
	
	
	@AuraEnabled
	public static String saveAccount(String details) {
		List<String> message = new List<String>();
		string concatMsg = 'sucesss';
		try{
			Account acc = new Account();
			List<RecordType> accRecordType = [Select Id FROM RecordType 
												 WHERE SobjectType = 'Account' AND DeveloperName ='Prospect' LIMIT 1] ;
			List<String> detailsList = (List<String>)JSON.deserialize(details,List<String>.class);
			acc.RecordTypeId = accRecordType.get(0).Id;
			acc.name = detailsList[0];
			acc.Website = detailsList[1];
			acc.Market_Segment__c = detailsList[2];
			acc.Customer_Compliance__c = detailsList[3];
			acc.BusinessPartnerRole__c = detailsList[4];
			acc.Market__c = detailsList[5];
			acc.BillingStreet = detailsList[6];
			acc.BillingpostalCode = detailsList[7];
			acc.BillingCity = detailsList[8];
			acc.BillingCountry = detailsList[9];
			acc.Activity_Sector_Name__c = detailsList[10];
			Database.SaveResult sr = Database.insert(acc, false);
			if(!sr.isSuccess()) {
				for(Database.Error error : sr.getErrors()) {
					message.add(error.getMessage());
				}
			}
			if(message.size()!=0) {
				concatMsg = String.join(message, '--');
			}
		}catch(Exception e) {
			System.debug('error::'+e.getMessage());
			concatMsg = e.getMessage();
		}
		return concatMsg;
	} 
 	
	@AuraEnabled
	public static List<String> getLeadData(String leadId) {
		Lead lead = new Lead();
		List<String> listOfData = new List<String>();
		try{
		   lead = [SELECT id, company, Activity_Sector_Name__c, market__c,street, city, country, postalCode, state
						FROM Lead WHERE ID =: leadId];
		   if(lead.Company == null) {
			   lead.Company = '';
		   }
		   listOfData.add(lead.Company);
		   if(lead.Activity_Sector_Name__c == null) {
			   lead.Activity_Sector_Name__c = '';
		   }
		   listOfData.add(lead.Activity_Sector_Name__c);
		   if(lead.street == null) {
			   lead.street = '';
		   }
		   listOfData.add(lead.street);
		   if(lead.city == null) {
			   lead.city = '';
		   }
		   listOfData.add(lead.city);
		   if(lead.postalCode == null) {
			   lead.postalCode = '';
		   }
		   listOfData.add(lead.postalCode);
		   if(lead.market__c == null) {
			   lead.market__c = '';
		   }
		   listOfData.add(lead.market__c);
		   if(lead.country == null) {
			   lead.country = '';
		   }
		   listOfData.add(lead.country);
		}catch(Exception e) {}
			 
		return listOfData;
	} 
	
	public class ResultWrapper{
		public String CustomerCompliance {get;set;}
		
	}
	
}