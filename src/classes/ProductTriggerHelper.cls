public class ProductTriggerHelper{
	
	public static void sendChatter(List<Product2> validProdList){
		Map<Id,String> productIdPortfolioMap = new Map<Id,String>();
		Map<String,String> productPortfolioNameMap = new Map<String,String>();
		Set<String> userContactSet = new Set<String>();
		Map<Id,Id> contactIdUserIdMap = new Map<Id,Id>();
		Map<Id,String> allAccountMap = new Map<Id,String>();
		Map<Id,Id> accountIdContactIdMap = new Map<Id,Id>();
		Set<Id> finalAccountIdSet = new Set<Id>();
		Map<Id,Set<String>> accntPortfolioMap = new Map<Id,Set<String>>();
		Map<Id,Id> contactAccountMap = new Map<Id,Id>();
		Set<String> chatterGroupSet = new Set<String>();
		chatterGroupSet.addAll(Label.ChatterGroups_ProductVersion.split(';'));
		
		for(Product2 prod : validProdList){
			productIdPortfolioMap.put(prod.Id,prod.Portfolio__c);
			if(productPortfolioNameMap.containsKey(prod.Portfolio__c)){
				//productPortfolioNameMap.get(prod.Portfolio__c).add(prod.Name);
				String tempString = productPortfolioNameMap.get(prod.Portfolio__c) + ',' + prod.Name;
				productPortfolioNameMap.put(prod.Portfolio__c,tempString);
			}
			else{
				productPortfolioNameMap.put(prod.Portfolio__c,prod.Name);
			}
		}
		system.debug('productIdPortfolioMap**' + productIdPortfolioMap);
		system.debug('productPortfolioNameMap**' + productPortfolioNameMap);
		
		for(CollaborationGroupMember mem : [Select memberId, Member.ContactId From CollaborationGroupMember where CollaborationGroup.Name IN: chatterGroupSet limit 1000]){
			if(mem.Member.ContactId != null){
				userContactSet.add(mem.Member.ContactId);
				contactIdUserIdMap.put(mem.Member.ContactId,mem.memberId);
			}
		}
		system.debug('userContactSet**' + userContactSet);
		system.debug('contactIdUserIdMap**' + contactIdUserIdMap);
		
		if(!userContactSet.isEmpty()){
			for(Contact con: [Select Id, AccountId, Account.Nokia_Selected_Portfolio__c From Contact Where Id IN: userContactSet]){
				allAccountMap.put(con.AccountId,con.Account.Nokia_Selected_Portfolio__c);
				accountIdContactIdMap.put(con.AccountId,con.Id);
			}
			system.debug('allAccountMap**' + allAccountMap);
			system.debug('accountIdContactIdMap**' + accountIdContactIdMap);
			
			for(Id prodId : productIdPortfolioMap.keySet()){
				String prodPortfolio = productIdPortfolioMap.get(prodId);
				for(String accntId : allAccountMap.keySet()){
					String accntPortfolios = allAccountMap.get(accntId);
					if(String.isNotBlank(accntPortfolios) && String.isNotBlank(prodPortfolio) && accntPortfolios.contains(prodPortfolio)){
						finalAccountIdSet.add(accntId);
						if(accntPortfolioMap.containsKey(accntId)){
							accntPortfolioMap.get(accntId).add(prodPortfolio);
							//String tempString = accntPortfolioMap.get(accntId) + ',' + portfolio;
							//accntPortfolioMap.put(accntId,tempString);
						}
						else{
							accntPortfolioMap.put(accntId, new Set<String>{prodPortfolio});
						}
					}
				}
			}
			system.debug('accntPortfolioMap**' + accntPortfolioMap);
			
			for(Contact cont : [Select Id,AccountId From Contact Where AccountId IN: finalAccountIdSet]){
				contactAccountMap.put(cont.Id,cont.AccountId);
			}
			
			system.debug('contactAccountMap**' + contactAccountMap);
			
			if(!finalAccountIdSet.isEmpty()){
				List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
				for(Id accId : accntPortfolioMap.keySet()){
					for(String accntPortfolio : accntPortfolioMap.get(accId)){
						if(String.isNotBlank(accntPortfolio)){
							ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
							input.subjectId = accId;
				
							ConnectApi.MessageBodyInput body = new ConnectApi.MessageBodyInput();
							body.messageSegments = new List<ConnectApi.MessageSegmentInput>();

							ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
							if(String.isNotBlank(productPortfolioNameMap.get(accntPortfolio)) && productPortfolioNameMap.get(accntPortfolio).split(',').size() > 1){
								textSegment.text = 'Products \'' + productPortfolioNameMap.get(accntPortfolio) + '\' have been updated.\n Please refer below report for further details -' + '\n\n' + Label.Lightening_URL + Label.ProductVersionReportId + '?fv0=' + EncodingUtil.urlEncode(accntPortfolio,'UTF-8');
							}
							else if(String.isNotBlank(productPortfolioNameMap.get(accntPortfolio)) && productPortfolioNameMap.get(accntPortfolio).split(',').size() == 1){
								textSegment.text = 'Product \'' + productPortfolioNameMap.get(accntPortfolio) + '\' has been updated.\n Please refer below report for further details -' + '\n\n' + Label.Lightening_URL + Label.ProductVersionReportId + '?fv0=' + EncodingUtil.urlEncode(accntPortfolio,'UTF-8');
							}

							body.messageSegments.add(textSegment);
							input.body = body;
							input.visibility = ConnectApi.FeedItemVisibilityType.AllUsers;
							ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(input);
							batchInputs.add(batchInput);
						}
					}
				}
				
				for(Id contId : contactAccountMap.keySet()){
					for(String accntPortfolio : accntPortfolioMap.get(contactAccountMap.get(contId))){
						if(String.isNotBlank(accntPortfolio)){
							//For Contact Record
							ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
							input.subjectId = contId;
				
							ConnectApi.MessageBodyInput body = new ConnectApi.MessageBodyInput();
							body.messageSegments = new List<ConnectApi.MessageSegmentInput>();

							ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
							if(String.isNotBlank(productPortfolioNameMap.get(accntPortfolio)) && productPortfolioNameMap.get(accntPortfolio).split(',').size() > 1){
								textSegment.text = 'Products \'' + productPortfolioNameMap.get(accntPortfolio) + '\' have been updated.\n Please refer below report for further details -' + '\n\n' + Label.Lightening_URL + Label.ProductVersionReportId + '?fv0=' + EncodingUtil.urlEncode(accntPortfolio,'UTF-8');
							}
							else if(String.isNotBlank(productPortfolioNameMap.get(accntPortfolio)) && productPortfolioNameMap.get(accntPortfolio).split(',').size() == 1){
								textSegment.text = 'Product \'' + productPortfolioNameMap.get(accntPortfolio) + '\' has been updated.\n Please refer below report for further details -' + '\n\n' + Label.Lightening_URL + Label.ProductVersionReportId + '?fv0=' + EncodingUtil.urlEncode(accntPortfolio,'UTF-8');
							}

							body.messageSegments.add(textSegment);
							input.body = body;
							input.visibility = ConnectApi.FeedItemVisibilityType.AllUsers;
							ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(input);
							
							//For User Record
							ConnectApi.FeedItemInput input1 = new ConnectApi.FeedItemInput();
							input1.subjectId = contactIdUserIdMap.get(contId);
				
							ConnectApi.MessageBodyInput body1 = new ConnectApi.MessageBodyInput();
							body1.messageSegments = new List<ConnectApi.MessageSegmentInput>();

							body1.messageSegments.add(textSegment);
							input1.body = body1;
							input1.visibility = ConnectApi.FeedItemVisibilityType.AllUsers;
							ConnectApi.BatchInput batchInput1 = new ConnectApi.BatchInput(input1);
							
							batchInputs.add(batchInput);
							batchInputs.add(batchInput1);
						}
					}
				}
				
				List<Network> communityList = new List<Network>();
				communityList = [Select Id From Network where Name = 'Nokia Partner Portal' Limit 1];
				if(!communityList.isEmpty()){
					ConnectApi.ChatterFeeds.postFeedElementBatch(communityList[0].Id, batchInputs);
				}
			}
		}
	}
}