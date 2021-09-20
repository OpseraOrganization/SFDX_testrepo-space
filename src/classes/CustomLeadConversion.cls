/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:			CustomLeadConversion 
Description:	 IRApplicationCase Test class to test the class
Date	Version		 Author		Summary of Changes 
-----------	  ----------	  -----------------	---------------------------------------------------------------------------------------------------
04/15/2016		 1.0			Supriyam	  Initial Release for Convert lead custom

----------------------------------------------------------------------------------------------------------------------------------------------------------*/
			/**
* Description : Method to CustomLeadConversion
* @param Strings to stamp values to Lead Object
* @return String to with leadDetails
* @throws NA
**/
public without sharing class CustomLeadConversion {
	
	
	   /**
* Description : Method to get Lead details
* @param Strings to stamp values to Lead Object
* @return String to with lead details
* @throws NA
**/
	@AuraEnabled
	public static Lead getLeadDeatils(Id parentId) 
	{
		Lead leadDetails = new Lead();
		try {
		
		List<Account> acc=new List<Account>();
		leadDetails=[select Owner.Name,Owner.Id,Deal_Name__c,Distributor_Account__r.Name,Distributor_Account__c ,recordTypeId,Company, End_Customer_Legal_Entity_Account__c,End_Customer_Legal_Entity_Account__r.name, PartnerAccount.Name,PartnerAccount.Id,Status,Name from Lead where id=:parentId LIMIT 1];
		if(leadDetails.recordTypeId == Schema.SObjectType.Lead.getRecordTypeInfosByName().get(PRMGlobalConstants.Indirect_Deal_Registration_Approved).getRecordTypeId()){
			leadDetails.PartnerAccount.name = leadDetails.Distributor_Account__r.Name;
			leadDetails.PartnerAccount.Id = leadDetails.Distributor_Account__c;
			//leadDetails.End_Customer_Legal_Entity_Account__r.name = leadDetails.End_Customer_Legal_Entity_Account__r.name;
		}
	
	}
	Catch(System.Exception e){
	 String message=e.getMessage();
	}
	system.debug('@@@@@?>? '+leadDetails);
		 return leadDetails;
	}
	  /**
* Description : Method to getContactDeatils
* @param Strings to stamp values to Lead Object
* @return String to with contactDetails
* @throws NA
**/
	@AuraEnabled 
	public static User getContactDeatils(Id ownerID) 
	{
		User contactDetails = new User();
		try{
		contactDetails=[select Contact.Name,Contact.Id from User where id=:ownerID LIMIT 1];
		
		}
	Catch(System.Exception e)
		{
			String message=e.getMessage();
		}
		return contactDetails;
	}
	   /**
* Description : Method to ConvertLead
* @param Strings to stamp values to Lead Object
* @return String to with covertedIdString
* @throws NA
**/
	@AuraEnabled
	public static String ConvertLead(Id LeadId,Id PartnerId , String OpptyName) 
	{
		List <contact> contactList = new List <contact>();
		id conIds;
		string emailId;
		boolean checkDeletion = false ;
		List<String> successMessage= new List<String>();
		List<String> convertedId= new List<String>();
		List<account> accLEList = new List<account>();
		List<account> accList = new List<account>();
		String covertedIdString;
		Boolean flag = false;
		lead ld =[select PartnerAccountID,recordType.name,email,Indirect_Reseller_Account__c,Distributor_Account__c,Company, End_Customer_Legal_Entity_Account__c  from lead where id =: LeadId LIMIT 1];
		accLEList = [SELECT Id,Name,ParentId FROM Account WHERE id =: ld.End_Customer_Legal_Entity_Account__c /*(recordType.name =: PRMGlobalConstants.LEGAL_ENTITY OR (recordType.name =: PRMGlobalConstants.PROSPECT AND BusinessPartnerRole__c =: PRMGlobalConstants.EndCustomer) )and Name =: ld.Company */  Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];			
		accList = [SELECT Id, Name, Active__c FROM Account WHERE 
		(Id =: accLEList[0].ParentId and recordType.name =: PRMGlobalConstants.CUSTOMER) 
		 OR ( Id =: accLEList[0].id and recordType.name =: PRMGlobalConstants.PROSPECT) limit 1];
		if(ld.email  != null){
			contactList = [Select id ,AccountId,Account.name from contact where email =: ld.email];
		}

		if(!contactList.IsEmpty()){
	 // if(contactList[0].accountId == PartnerId){
	//lc.setContactId(contactList[0].id);
	 //	conIds = contactList[0].id;
	
	 // }
	 // else{
	//   if(ld.RecordType.Name =='Indirect_Deal_Registration_Approved'){
	   // if((contactList[0].accountId == accList[0].id) || (contactList[0].accountId == ld.PartnerAccountID) || (contactList[0].accountId == PartnerId)){
			system.debug('EndCustomer for Ind Reseller >>>>' +'----'+ ld.PartnerAccountID +'----'+ accList[0].id +'----' + '----'+ PartnerId);
			checkDeletion =true;
	   // }
	  // }
			//  else {
	//	if((contactList[0].accountId == accList[0].id ) || (contactList[0].accountId == ld.Indirect_Reseller_Account__c) || (contactList[0].accountId == ld.PartnerId)) {
	  //		 system.debug('?>>>>???' +contactList);
	 //	system.debug('EndCustomer for other than IR >>>>');
	   //	 emailId = 'Delete.' + ld.email ;
		 //   ld.email = emailId;
		 //   update ld;
		 //   checkDeletion =true;
	 //   }
		
	//}
	
	//lc.setContactId(contactList[0].id);
			//}
		}
		Database.LeadConvert lc = new Database.LeadConvert();
		lc.setLeadId(LeadId);
	// if(conIds !=null){
		 //   lc.setContactId(conIds);
	// }
		lc.setAccountId(PartnerId);
		lc.setOpportunityName(OpptyName);
	  
		LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
		
		lc.setConvertedStatus(convertStatus.MasterLabel);
		try{
			Database.LeadConvertResult lcr = Database.convertLead(lc, false);
		
			if(!lcr.isSuccess())
			{
	for(Database.Error error : lcr.getErrors())
	{
		successMessage.add(error.getMessage());
	}
			}
			else
			{
	lead leadInstance = [select Id, RecordType.Name , PartnerAccountId , End_Customer_Legal_Entity_Account__c, End_Customer_Legal_Entity_Account__r.ParentId, ConvertedContactId ,Indirect_Reseller_Account__c from lead where id =: LeadId LIMIT 1];
	contact con = [Select email,accountId from contact where id =: leadInstance.ConvertedContactId ];
	Account endCustAcc = [SELECT Id, Name, Active__c FROM Account WHERE 
		(Id =: leadInstance.End_Customer_Legal_Entity_Account__r.ParentId and recordType.name =: PRMGlobalConstants.CUSTOMER) 
		 OR ( Id =: leadInstance.End_Customer_Legal_Entity_Account__c and recordType.name =: PRMGlobalConstants.PROSPECT) limit 1];
				Opportunity opp =[Select Id, Name, OwnerId, Account.OwnerId, Indirect_Reseller_Account__c, Indirect_Reseller_Account__r.OwnerId from Opportunity where Id =: lcr.getOpportunityId()];
	system.debug('+++++++++++>>con>' +con);
	system.debug('+++++++++++>>checkDeletion>' +checkDeletion);
	if(checkDeletion ==true){
					delete con;
					//MSilva - SFPRM-452 creating Contact Role for the original contact
					OpportunityContactRole ocr = new OpportunityContactRole();
					ocr.ContactId = contactList[0].Id;
					ocr.IsPrimary = true;
					ocr.OpportunityId = opp.Id;
					ocr.Role = 'Business User';
					insert ocr;
				}
				if(opp.Account.OwnerId != null){
					OpportunityTeamMember otm = new OpportunityTeamMember();
					otm.OpportunityId = opp.Id;
					otm.TeamMemberRole = 'Partner Sales Manager';
					otm.OpportunityAccessLevel = 'Edit';
					otm.UserId = opp.Account.OwnerId;
					insert otm;
				}
				
	convertedId.add(opp.Id);
	convertedId.add('Success');
				
				
	if(contactList.IsEmpty() ){
	system.debug('@@@@@@@@@@'+leadInstance.RecordType.Name);
	  // if(leadInstance.RecordType.Name  ==  'Indirect_Deal_Registration_Approved'  ){
			system.debug('@@@@@@@ == endCustAcc :' + endCustAcc);
			con.accountId = endCustAcc.id;
			update con;
			 system.debug('@@@@@@@@@@ con'+ con + con.accountId);
	   // }
	}

			}
			
		}
	Catch(System.Exception e){ String message=e.getMessage();
	// return null;
	}
	
		if(successMessage.size()!=0)
		{
			String concatenatedErrorMessage = String.join(successMessage, '--');
			return concatenatedErrorMessage;   
		}
		
		else
	 // return null;
	
			covertedIdString = String.join(convertedId, ',');
			system.debug('>>>>>>>>>>>>>' +covertedIdString);
			return covertedIdString;  
		
	}
		/**
* Description : Method to GetName
* @param Strings to stamp values to Lead Object
* @return String to with OpptyName
* @throws NA
**/
	@AuraEnabled
	public static Opportunity getName(String OpptyId) 
	{
		 Opportunity opptyName = new Opportunity();
		try{
		opptyName= [Select Name from opportunity where ID =:OpptyId LIMIT 1];
	
		}	 
		Catch(System.Exception e)
		{
			String message=e.getMessage(); 
		}
		 return opptyName;
	}
	
		/**
* Description : Method to Inactive acc names 3.1 Release
* @param Strings to stamp values to Lead Object
* @return String to with acc name
* @throws NA
**/
	@AuraEnabled
	public static String getInactiveAccName(Id leadID) 
	{
		 String errorMSG = PRMGlobalConstants.No_Error ;
		 List<Account> partnerAccName = new List<Account>();
		 List<Account> endCustomer = new List<Account>();
		 Lead leadDetails = getLeadDeatils(leadID);
		try{
			partnerAccName = [SELECT Name, Active__c, AccountStatusInCRMOM__c From Account  WHERE (Id =: leadDetails.PartnerAccount.Id and recordType.name =: PRMGlobalConstants.CUSTOMER) OR ( Id =: leadDetails.PartnerAccount.Id and recordType.name =: PRMGlobalConstants.PROSPECT) Limit 1];
			endCustomer = [SELECT Name, Active__c From Account  WHERE ( id =: leadDetails.End_Customer_Legal_Entity_Account__c /* Name =: leadDetails.Company and (recordType.name =: PRMGlobalConstants.LEGAL_ENTITY OR (recordType.name =: PRMGlobalConstants.PROSPECT AND BusinessPartnerRole__c =: PRMGlobalConstants.EndCustomer) )*/) Limit 1];
		}	 
		Catch(System.Exception e){
			String message=e.getMessage();
		}
		if(endCustomer.IsEmpty()){
			errorMSG = PRMGlobalConstants.EndCustomerNotPresent ;
		}else if(!partnerAccName.IsEmpty() && partnerAccName[0].Active__c == false && !endCustomer.IsEmpty() && endCustomer[0].Active__c == false ){
			errorMSG = PRMGlobalConstants.BOTHInactive ;
		}else if(!partnerAccName.IsEmpty() && partnerAccName[0].Active__c == false && !endCustomer.IsEmpty() && endCustomer[0].Active__c == true){
	 errorMSG = PRMGlobalConstants.PartnerAccountInactive;
			}else if(!partnerAccName.IsEmpty() && partnerAccName[0].Active__c == true && !endCustomer.IsEmpty() && endCustomer[0].Active__c == false ){
	if(partnerAccName[0].AccountStatusInCRMOM__c == PRMGlobalConstants.Inactive){
		errorMSG = PRMGlobalConstants.BOTHInactive;
	}else{
		errorMSG = PRMGlobalConstants.EndCustomerAccountInactive;
	}
		}else if(!partnerAccName.IsEmpty() && partnerAccName[0].Active__c == true && !endCustomer.IsEmpty() && endCustomer[0].Active__c == true){
			if(partnerAccName[0].AccountStatusInCRMOM__c == PRMGlobalConstants.Inactive){
	errorMSG = PRMGlobalConstants.PartnerAccountInactive;
			}else{}
		}else{}
		 return errorMSG;
	}
				/**
* Description : Method to Inactive acc names 3.1 Release
* @param Strings to stamp values to Lead Object
* @return String to with acc name
* @throws NA
**/
   @AuraEnabled
	public static String getEndCustomerName(Id leadID) 
	{
		String message;
		 String endCustomerName = PRMGlobalConstants.RFUrl ;
		 List<Account> endCustomer = new List<Account>();
		 List<Account> endCustomerLE = new List<Account>();
		 Lead leadDetails = getLeadDeatils(leadID);
		try{	
			endCustomerLE = [SELECT Name, Active__c, ParentId From Account WHERE (ID =: leadDetails.End_Customer_Legal_Entity_Account__c) Limit 1];
			endCustomer = [SELECT Name, Active__c, AccountStatusInCRMOM__c From Account  WHERE(((Id =: endCustomerLE[0].ParentId AND recordType.name =: PRMGlobalConstants.CUSTOMER) AND (Active__c !=: PRMGlobalConstants.RUN_LEAD_TRIGGER_ON_LEAD_UPDATE OR AccountStatusInCRMOM__c !=: PRMGlobalConstants.ActiveSt)) OR (Id =: endCustomerLE[0].id AND Active__c !=: PRMGlobalConstants.RUN_LEAD_TRIGGER_ON_LEAD_UPDATE AND recordType.name =: PRMGlobalConstants.PROSPECT AND Id =: endCustomerLE[0].id)) Limit 1];
		}	 
		Catch(System.Exception e)
		{
	 message=e.getMessage();
		}
	if(!endCustomer.IsEmpty()){
	  endCustomerName = endCustomer[0].Name;
		}else{
	 endCustomerName= PRMGlobalConstants.ActiveSt; 
		}
		return endCustomerName;
	
  }
  
		 /**
* Description : Method to get endcustomer name for cinversion page
* @param Strings to stamp values to Lead Object
* @return String to with end customer acc name
* @throws NA
**/
@AuraEnabled
	public static String getEndCustomer(Id EndCustID) 
	{
		 String message;
		 System.debug('EndCustID '+ EndCustID);
		 String endCustomerN = PRMGlobalConstants.RFUrl ;
		 List<Account> endCustomer = new List<Account>();
		try{	
	 endCustomer = [SELECT Name, Active__c From Account  WHERE Id =: EndCustID Limit 1];
		}	 
		Catch(System.Exception e)
		{
	 message=e.getMessage();
		}
		
		System.debug('endCustomer '+ endCustomer );
	if(!endCustomer.IsEmpty()){
		endCustomerN = endCustomer[0].Name;
		}
		
	 System.debug('endCustomerN : '+ endCustomerN);
	return endCustomerN;
  }
	  /**
* Description : Method to update Lead details
* @param Strings to stamp values to Lead Object
* @return String to with lead details
* @throws NA
**/
	 @AuraEnabled
	public static void updateLead(Id LeadId,String G3_Planned_Date,String G4_Approval_Date,String G5_Planned_Date,String G6_Planned_Date){
		try{
			Lead leadUpdate=new Lead();
	// leadUpdate.G2_Planned_Date__c= Date.valueOf(G2_Planned_Date);
		leadUpdate.G3_Planned_Date__c= Date.valueOf(G3_Planned_Date);
		leadUpdate.G4_Approval_Date__c= Date.valueOf(G4_Approval_Date);
		leadUpdate.G5_Planned_Date__c= Date.valueOf(G5_Planned_Date);
		leadUpdate.G6_Planned_Date__c= Date.valueOf(G6_Planned_Date);
		leadUpdate.Id=LeadId;
		update leadUpdate;
		} Catch(System.Exception e)
		{
			String message=e.getMessage();
		}   
		
	}
	
}