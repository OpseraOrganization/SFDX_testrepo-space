/*******************************
	Created by: Accenture
	Created Date: 10th Nov 2017
	Last modified by: Accenture
	Last modified date: 17th Nov 2017
	Description: This trigger helps send bell notification and feed on quote status updation
	*******************************/
Public with sharing  class CCREProposalTriggerHelper{
	Public static Set<Id> quoteAccountIdSet = new Set<Id>();
	Public Static List<Id> accIdList = new List<Id>();
   /*****************************
	 *Method Name: createConfiguration
	 *Description: To create configurations
	 *Parameters: List of quote proposals
	*******************************/
   public static void createConfiguration(List<Apttus_Proposal__Proposal__c > ccreRecList){
		try{
		Id swxccreRecordType = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.QuoteRecordType).getRecordTypeId(); 
		List<Apttus_Proposal__Proposal__c> dsQuoteList =new List<Apttus_Proposal__Proposal__c>();   
			
		 if(!ccreRecList.isEmpty()){
			for(Apttus_Proposal__Proposal__c  quoteRec :ccreRecList){
				if(quoteRec.RecordTypeId == swxccreRecordType){
					dsQuoteList.add(quoteRec);
				}
			}
			 
			 if(!dsQuoteList.isEmpty() && dsQuoteList !=null){
			  CartCreation.createCart(dsQuoteList);
			 } 
		 }
		  }catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.quoteHelper,CSWXGlobalConstant.createConfigurationMethod);
			   
		   }  
	 }
	 
  
  /*****************************
	 *Method Name: updateQuoteShare
	 *Description: To create Quote Share 
	 *Parameters: List of quote proposals
	*******************************/
   public static void updateQuoteShare(List<Apttus_Proposal__Proposal__c > records,Map<Id,Apttus_Proposal__Proposal__c > oldrecords){
		try{
			Map<String,String> mapOfQuoteAccount=new Map<String,String>();

			Map<Id, List<User>> userAccountMap = new Map<Id,List<User>>();
			Set<Id> userIdSet = new Set<Id>();
			
			Map<String,Apttus_Proposal__Proposal__Share> propShareMap = new Map<String,Apttus_Proposal__Proposal__Share>();
			for(Apttus_Proposal__Proposal__c quo:records){
				if((oldrecords.get(quo.id)).Apttus_Proposal__Approval_Stage__c!=CSWXGlobalConstant.quoteShareApproved && quo.LOA_Status__c==CSWXGlobalConstant.quoteShareApproved && quo.Apttus_Proposal__Approval_Stage__c==CSWXGlobalConstant.quoteShareApproved){
					mapOfQuoteAccount.put(quo.id,quo.Apttus_Proposal__Account__c);
				}
				if(quo.Revision_Status__c=='Revision'){
					mapOfQuoteAccount.put(quo.id,quo.Apttus_Proposal__Account__c);
				}
					
			}
			System.debug('mapOfQuoteAccount>>>>>>'+mapOfQuoteAccount);
			if(!mapOfQuoteAccount.isEmpty()) 
			{
			   List<String> keys = mapOfQuoteAccount.values();
			   List<User> lstUser;
			   String userQuery = 'Select Id,Profile.Name,Name,ContactID,AccountId from User where AccountId=:keys  '+Label.DS_User_Filter_for_Quote_Share_With_Community_user;
			   for(User listUser : Database.Query(userQuery))
				{
					//userAccountMap.put(listUser.Id, listUser.AccountId);
					userIdSet.add(listUser.Id);
					if(!userAccountMap.containsKey(listUser.AccountId)) {
						lstUser = new List<User>();
						lstUser.add(listUser);
					}
					else {
						lstUser = new List<User>(); 
						lstUser = userAccountMap.get(listUser.AccountId);
						lstUser.add(listUser);
					}
					userAccountMap.put(listUser.AccountId,lstUser);  
				}
			
				//Creates the logics for existence of Quote share. 
				List<Apttus_Proposal__Proposal__Share> propShareList = [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause, IsDeleted FROM Apttus_Proposal__Proposal__Share where ParentId IN : mapOfQuoteAccount.keyset() and  UserOrGroupId IN :userIdSet];
				
				for(Apttus_Proposal__Proposal__Share objPropShare : [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause, IsDeleted FROM Apttus_Proposal__Proposal__Share where ParentId IN : mapOfQuoteAccount.keyset() and  UserOrGroupId IN :userIdSet]) {
					String Key  = objPropShare.ParentId + '-'+ objPropShare.UserOrGroupId;
					if(!propShareMap.containsKey(Key)) {
						propShareMap.put(Key,objPropShare);
					}
				}
			
				List<Apttus_Proposal__Proposal__Share> quoteShareList = new List<Apttus_Proposal__Proposal__Share>();
				Apttus_Proposal__Proposal__Share objQShare;
				for(String quoteId:mapOfQuoteAccount.keyset()){
					
				   Id AccountIdVal = mapOfQuoteAccount.get(quoteId);
				   if(userAccountMap.containsKey(AccountIdVal)) {
					   
					   for(User objUser :  userAccountMap.get(AccountIdVal)) {
						   String keyValue = quoteId + '-'+objUser.Id;
						   if(!propShareMap.containsKey(keyValue)) {
							  objQShare = new  Apttus_Proposal__Proposal__Share();
							  objQShare.ParentId = quoteId;
							  objQShare.UserOrGroupId = objUser.Id;
							  objQShare.AccessLevel = 'Edit';
							  quoteShareList.add(objQShare);
						   }
						  
					   }
				   }
				   
				   
					
				}
				if(!quoteShareList.isEmpty()){
					insert quoteShareList;
				}
			}
			
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.quoteHelper,CSWXGlobalConstant.updateQuoteShareHelper);
			   
		}  
	 }
	 
	 
	 
	  /*****************************
 *Method name: createCCRELineItemForProposal
 *Description: This method will create CCRE Product Info Line Items and CCRE Service Info Line Items  related with Offer
 *Parameters: Quote/Proposal List
 *Test coverage from: 
 *******************************/
   public static void createCCRELineItemForProposal(List<Apttus_Proposal__Proposal__c> ProposalList){
   try{
	  Map<Id,Id> offerToUpsellProposal = new Map<Id,Id>();
	  Map<Id,List<CCRE_UpSell_LineItem__c>> upsellProposaltoItems = new  Map<Id,List<CCRE_UpSell_LineItem__c>>();
	  Set<Id> upsellProposalId = new Set<Id>();
	  Map<Id,List<CCRE_UpSell_LineItem__c>> OffertoItems = new  Map<Id,List<CCRE_UpSell_LineItem__c>>();
	  List<CCRE_Service_Invoice_Info_line_items__c> serviceInfoLineItemList = new List<CCRE_Service_Invoice_Info_line_items__c>();
	  
	  for(Apttus_Proposal__Proposal__c proposal : ProposalList){
	   //System.debug('proposal.RecordType.Name--->'+proposal.RecordType.Name);
			   if(proposal.SWx_Upsell_Proposal__c!=NULL && proposal.Analytics_Source__c.equalsIgnoreCase(CSWXGlobalConstant.AnalyticsSource_CCRE)){
					 offerToUpsellProposal.put(proposal.Id,proposal.SWx_Upsell_Proposal__c);
					 upsellProposalId.add(proposal.SWx_Upsell_Proposal__c);  
				}   
	  }
	  
		
//	List<CCRE_UpSell_LineItem__c> lineItemList = [SELECT Id,Upsell_Proposal__c,Attribute_for_customer__c,Contracted_NEs_Per_Contract__c,Attribute_Label__c,Attribute_Type__c,Attribute_Value__c,Info_Type__c,C10_date_for_product_release__c,C8_date_for_product_release__c,Contracted_NEs_per_customer__c,M7_date_for_product__c,Product__c,Product_Family__c,Product_Group__c,Product_Release__c,Line_Item_Type__c from CCRE_UpSell_LineItem__c where Upsell_Proposal__c IN:upsellProposalId];
	  
		List<CCRE_UpSell_LineItem__c> tempList;
		
		
	  
		
		for(CCRE_UpSell_LineItem__c ccreLineItem : [SELECT Id,Upsell_Proposal__c,Attribute_for_customer__c,Contracted_NEs_Per_Contract__c,Attribute_Label__c,Attribute_Type__c,Attribute_Value__c,Info_Type__c,C10_date_for_product_release__c,C8_date_for_product_release__c,Contracted_NEs_per_customer__c,M7_date_for_product__c,Product__c,Product_Family__c,Product_Group__c,Product_Release__c,Line_Item_Type__c from CCRE_UpSell_LineItem__c where Upsell_Proposal__c IN:upsellProposalId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())] ){
		if(upsellProposaltoItems.containsKey(ccreLineItem.Upsell_Proposal__c)){
			upsellProposaltoItems.get(ccreLineItem.Upsell_Proposal__c).add(ccreLineItem);
		}
		else{
			tempList = new List<CCRE_UpSell_LineItem__c>();
			tempList.add(ccreLineItem);
			upsellProposaltoItems.put(ccreLineItem.Upsell_Proposal__c, tempList);
		}
	  
	  
	  }
	  
	   
		List<CCRE_product_info_line_items__c> ccreProductInfoList = new List<CCRE_product_info_line_items__c>(); 
		CCRE_product_info_line_items__c productInfoLineItem = new CCRE_product_info_line_items__c(); 
		CCRE_Service_Invoice_Info_line_items__c serviceInfoLineItem = new CCRE_Service_Invoice_Info_line_items__c();
	   
	   for(Id pId: offerToUpsellProposal.keyset()){
				List<CCRE_UpSell_LineItem__c> ccreList = upsellProposaltoItems.get(offerToUpsellProposal.get(pId));
				productInfoLineItem = new CCRE_product_info_line_items__c(); 
				serviceInfoLineItem = new CCRE_Service_Invoice_Info_line_items__c();
				for(CCRE_UpSell_LineItem__c ccreLineItem : ccreList){
							
							   
								if(ccreLineItem.Line_Item_Type__c.equalsIgnoreCase(CSWXGlobalConstant.Product_Info_line_items)){
									
									productInfoLineItem.Info_Type__c = ccreLineItem.Info_Type__c;
									productInfoLineItem.C10_date_for_product_release__c= ccreLineItem.C10_date_for_product_release__c;
									productInfoLineItem.C8_date_for_product_release__c = ccreLineItem.C8_date_for_product_release__c;
									productInfoLineItem.Contracted_NEs_per_customer__c = ccreLineItem.Contracted_NEs_per_customer__c;
									productInfoLineItem.Contracted_NEs_Per_Contract__c= ccreLineItem.Contracted_NEs_Per_Contract__c;
									productInfoLineItem.Info_Type__c = ccreLineItem.Info_Type__c;
									productInfoLineItem.M7_date_for_product__c = ccreLineItem.M7_date_for_product__c;
									productInfoLineItem.Product__c = ccreLineItem.Product__c;
									productInfoLineItem.Product_Family__c  = ccreLineItem.Product_Family__c;
									productInfoLineItem.Product_Group__c = ccreLineItem.Product_Group__c;
									productInfoLineItem.Product_Release__c = ccreLineItem.Product_Release__c;									 
									productInfoLineItem.Offer__c = pId;
									
									ccreProductInfoList.add(productInfoLineItem);
									productInfoLineItem=NULL;
								}
								
								
								if(ccreLineItem.Line_Item_Type__c.equalsIgnoreCase(CSWXGlobalConstant.Service_Invoice_Info_line_items)){
									   
										serviceInfoLineItem.Offer__c = pId;
										serviceInfoLineItem.Attribute_for_customer__c = ccreLineItem.Attribute_for_customer__c;
										serviceInfoLineItem.Attribute_Label__c = ccreLineItem.Attribute_Label__c;
										serviceInfoLineItem.Attribute_Type__c = ccreLineItem.Attribute_Type__c;
										serviceInfoLineItem.Attribute_Value__c = ccreLineItem.Attribute_Value__c;
										serviceInfoLineItemList.add(serviceInfoLineItem);
										serviceInfoLineItem=NULL;
								}
				   
				   }
				 
	  }
	  
	  
	  database.insert(ccreProductInfoList);
	  database.insert(serviceInfoLineItemList);
	  
	  
	 }catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.quoteHelper,CSWXGlobalConstant.createCCRELineItemForProposalMethod);
			   
		   }  
	  
 }   
 
	/*****************************
 *Method name: byPassG4
 *Description: This method will byPassG4
 *Parameters: Quote/Proposal List
 *Test coverage from: 
 *******************************/
 public static void byPassG4(List<Id> oppId ) {
 
	List<Opportunity> OpptyUpdate= new List<Opportunity>();
		try{	
			for(Opportunity opp : [select id,Apttus_Approval__Approval_Status__c,ApprovalStatusTechField__c,G2_Approval_Date__c,
							 StageName,Phase_Status__c,G5_Contract_Approval_Date__c,G5_Approval_Date__c,SWx_Upsell_Proposal__c from Opportunity where id=:oppId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
				if(opp.SWx_Upsell_Proposal__c <> null){
				opp.Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.Approval_stage_approved;
				opp.ApprovalStatusTechField__c = CSWXGlobalConstant.G4_APPROVAL_TECH;
				opp.StageName = CSWXGlobalConstant.WIN_THE_CASE_NEGOTIATE ;
				opp.Phase_Status__c = CSWXGlobalConstant.OFFER_SUBMITTED;
				opp.G4_Approval_Date__c = System.now();
			   // opp.Sales_Outcome__c=CSWXGlobalConstant.WON;
				}
				OpptyUpdate.add(opp);
			}
			if(OpptyUpdate.size()>0)
				database.update(OpptyUpdate,false);   
		}  
		   
		catch(Exception ex){
			   system.debug('G4 exception'+ex);
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.quoteHelper,CSWXGlobalConstant.BypassG4Helper );
			   
		}   

 }  
 
   /*****************************
	 *Method Name: updateOpportunityApprovalHistory
	 *Description: To update Opportunity Approvals History with G3 
	 *Parameters: Opportunity Id
	*******************************/ 
  public static void updateOpportunityApprovalHistory(Id oppId) {
		system.debug('oppId>>>>>>'+oppId);
	   
	   //Below code filters the Approval instance by passing the G3 Approvals as parameter. 
	  try{
	   Apttus_Approval__ApprovalProcessInstance__c approvalProcess = [SELECT Id, name,Apttus_Approval__PrevProcessInstanceId__c,Apttus_Approval__InstanceNumber__c,Apttus_Approval__BusinessObjectId__c
																				 FROM Apttus_Approval__ApprovalProcessInstance__c
																				 WHERE name like: CSWXGlobalConstant.G3ProcessId limit 1];
	   
	   List<Apttus_Approval__Approval_Request_History__c> approvalDataHistory=new List<Apttus_Approval__Approval_Request_History__c>(); // This is used for holding the  Approval History Record.
	   
	   
	   //This code will filter the records from the Approval Request by passing the Opportunity key as parameter.
	   
	   
	   
	  Apttus_Approval__Approval_Request_History__c approvalHistory ;
	  
	   // Below code reads Approval Request and Maps to Approval History.
	   
	   for(Apttus_Approval__Approval_Request__c approvalData: [SELECT id,Name,Apttus_Approval__StepNameLink__c,Apttus_Approval__Step_Name__c,
															   Apttus_Approval__Request_Comments__c,Apttus_Approval__Assigned_To_Type__c,Apttus_Approval__Related_Opportunity__c,
															   Apttus_Approval__ProcessInstanceId__c,Apttus_Approval__Approver_Comments__c,Apttus_Approval__StepSequenceString__c,
															   NF_Assignee_Type__c,Apttus_Approval__Approval_Status__c,Apttus_Approval__Active__c,Apttus_Approval__Object_Id__c,Apttus_Approval__Object_Type__c,
															   Apttus_Approval__StepLabel__c,Apttus_Approval__RequestType__c,Apttus_Approval__Notify_Only__c,Apttus_Approval__Initial_Submitter__c,Apttus_Approval__Assigned_To_Name__c,Apttus_Approval__Date__c
															   FROM Apttus_Approval__Approval_Request__c where Apttus_Approval__Related_Opportunity__c=:oppId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
		   
																   approvalHistory = new Apttus_Approval__Approval_Request_History__c();
		   approvalHistory.NF_Assignee_Type__c = approvalData.NF_Assignee_Type__c;
		   approvalHistory.Apttus_Approval__Assigned_To_Name__c = approvalData.Apttus_Approval__Assigned_To_Name__c;
		   if(approvalHistory.NF_Assignee_Type__c == CSWXGlobalConstant.StakeholderForInfo){
			  approvalHistory.Apttus_Approval__Assigned_To_Name__c = CSWXGlobalConstant.NokiasCRM; 
		   }

		   if(approvalHistory.Apttus_Approval__Assigned_To_Name__c == Null){
				approvalHistory.Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.NONE;
				approvalHistory.Apttus_Approval__Approver_Comments__c = approvalData.Apttus_Approval__Approver_Comments__c;
		   }
		   else{
				approvalHistory.Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.Notified;
				approvalHistory.Apttus_Approval__Approver_Comments__c = CSWXGlobalConstant.ApttusApprovalApproverComments+approvalHistory.Apttus_Approval__Assigned_To_Name__c+CSWXGlobalConstant.space+String.Valueof(System.now());
		   }
		   approvalHistory.Apttus_Approval__Related_Opportunity__c = approvalData.Apttus_Approval__Related_Opportunity__c;
		   approvalHistory.Apttus_Approval__Step_Name__c = approvalData.Apttus_Approval__Step_Name__c;
		   approvalHistory.Apttus_Approval__Assigned_To_Type__c = approvalData.Apttus_Approval__Assigned_To_Type__c;
		   approvalHistory.Apttus_Approval__Active__c = approvalData.Apttus_Approval__Active__c;
		   approvalHistory.Apttus_Approval__Object_Id__c = approvalData.Apttus_Approval__Object_Id__c;
		   approvalHistory.Apttus_Approval__Object_Type__c = approvalData.Apttus_Approval__Object_Type__c;
		   approvalHistory.Apttus_Approval__RequestType__c = approvalData.Apttus_Approval__RequestType__c;
		   approvalHistory.Apttus_Approval__StepLabel__c = approvalData.Apttus_Approval__StepLabel__c;
		   approvalHistory.Apttus_Approval__Notify_Only__c = True;
		   approvalHistory.Apttus_Approval__Initial_Submitter__c = approvalData.Apttus_Approval__Initial_Submitter__c;
		   approvalHistory.Apttus_Approval__ProcessInstanceId__c = approvalProcess.Id;
		   approvalHistory.Apttus_Approval__Date__c = System.now();
		   approvalDataHistory.add(approvalHistory);
	   } 
	   system.debug('approvalDataHistory'+approvalDataHistory);
	   if(! approvalDataHistory.isEmpty()){
		   Database.SaveResult[] lsr = Database.insert(approvalDataHistory);   
	   }
	  }
	  catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.quoteHelper,CSWXGlobalConstant.updateOpportunityApprovalHistory);
			   
		   }
	  
	   
   } 

  /*****************************
	 *Method Name: checkQuoteApprovalStage
	 *Description: Method to checkApprovalStage
	 *Parameters: List of quote proposals
	*******************************/
   public static void checkQuoteApprovalStage(List<Apttus_Proposal__Proposal__c > records,Map<Id,Apttus_Proposal__Proposal__c > oldrecords){
		try{
			Integer flag=0;
			List<Apttus_Proposal__Proposal__c> quoList = new List<Apttus_Proposal__Proposal__c>();
			Set<id> recordsIdSet = new  Set<id>();
			 for (Apttus_Proposal__Proposal__c q: records){
				 recordsIdSet.add(q.id);
			 }
			
		 
			  for(Apttus_Proposal__Proposal__c quo: [Select Id from Apttus_Proposal__Proposal__c where id in :recordsIdSet]){
			  // Apttus_Proposal__Proposal__c newQuote=[Select Id from Apttus_Proposal__Proposal__c where id=:quo.Id LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			   
				String yes=(oldrecords.get(quo.id)).Apttus_Proposal__Approval_Stage__c;
				system.debug('oldrecords'+yes);
				system.debug('newrecords'+quo.Apttus_Proposal__Approval_Stage__c);
				if((oldrecords.get(quo.id)).Apttus_Proposal__Approval_Stage__c==CSWXGlobalConstant.Approval_stage_inReview && quo.Apttus_Proposal__Approval_Stage__c==CSWXGlobalConstant.Approval_stage_approved){
				  quo.Changed_Approval_Stage__c=true;
				  quoList.add(quo);
				}
				
			}  
			
			if(!quoList.isEmpty()){update quoList;}
		   // if(flag==1){
				//quo.addError('Click on button Download Recommendation to track the history of the revisions');
			  //records.addMessage();
			  //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid Input.');
			 //ApexPages.addMessage(myMsg);
		   // }
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.quoteHelper,CSWXGlobalConstant.updateQuoteShareHelper);
			   
		}  
	 }
	 /*****************************
 *Method name: shareQuoteWithAccountOwner
 *Description: This method will share DS Quote with Account Owner
 *Parameters: Quote/Proposal ID List
 *Test coverage from: 
 *******************************/
	Public static void shareQuoteWithAccountOwner(List<Apttus_Proposal__Proposal__c > quotesToShare ) {
			list<Apttus_Proposal__Proposal__Share> quoteShareList = new list<Apttus_Proposal__Proposal__Share >();
			set<ID> accIds = new set<ID>();
			map<id, id> AccToOwnerid = new map<id, id>();
		try{
			system.debug('quotesToShare : '+quotesToShare);
			for(Apttus_Proposal__Proposal__c quote : quotesToShare){
				accIds.add(quote.Apttus_Proposal__Account__c);  
			}
			system.debug('accIds : '+accIds);
			
			for(account acc : [select id, ownerid from account where id in: accIds]){
				AccToOwnerid.put(acc.id, acc.ownerid);
			}
			system.debug('AccToOwnerid : '+AccToOwnerid);
			
			for(Apttus_Proposal__Proposal__c quote : quotesToShare){
				Apttus_Proposal__Proposal__Share QuoteShare= new Apttus_Proposal__Proposal__Share();
				QuoteShare.AccessLevel = 'Edit';
				QuoteShare.ParentID = quote.id;
				QuoteShare.RowCause = 'Manual';
				QuoteShare.UserOrGroupId = AccToOwnerid.get(quote.Apttus_Proposal__Account__c);
				quoteShareList.add(QuoteShare);
			}
			
			system.debug('quoteShareList : '+quoteShareList);
			if(!quoteShareList.isEmpty()){
				database.insert(quoteShareList, false);
			}		
		}  
		catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.quoteHelper,CSWXGlobalConstant.DSShareQuotewithAcountOwner);}	
	}   
}