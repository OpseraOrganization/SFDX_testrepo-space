/*************************************************************************************************
* Class Name : CAPS_UpdateToCAPS4NAIPAttachment
* Created Date: 14 March 2019
* Created By : TCS
* Description: Update Attachment Metadata to CAPS for attachment-data comes from NAIP 
* Last Modified by: 
* Last Modified Date: 
* Description : 
*************************************************************************************************/
global class CAPS_UpdateToCAPS4NAIPAttachment{
	Public static Set<String> caseStatusSet = new Set<String>{'Completed','Closed','Cancelled'};
	Public static Boolean scrambled;
	public static Boolean decideToCallOrNot(){
		Boolean sendOrnot = false;
		String sendUpdateToCAPS = CH_Settings__c.getValues('SendAttachmentUpdateToCAPS') != null ? CH_Settings__c.getValues('SendAttachmentUpdateToCAPS').SettingValue__c :'';
		String enableUser = CH_Settings__c.getValues('UseIntegrtionCusSetUser4MetadataUpdate') != null ? CH_Settings__c.getValues('UseIntegrtionCusSetUser4MetadataUpdate').SettingValue__c :'';
		if('Yes'.equalsIgnoreCase(enableUser)){
			sendOrnot = CH_Integration__c.getInstance().EnableIntegration__c;
		}else{sendOrnot = true;}
		return 'Yes'.equalsIgnoreCase(sendUpdateToCAPS) && sendOrnot;
	}
	/*********************************************************************
	*Description: Process Attachments came on case creation or update, created as Part of NOKIASC-27612 Code-Opt.
	*Author:	TCS
	*Date:	  27 March 2020
	*Method Name: processAttachmentOnCase
	*Parameter: <oldmap of Case>, <List of Case - Trigger.new>
	*Return: None
	*********************************************************************/
	public static void processAttachmentOnCase(Map<Id,Case> oldCaseMap,List<Case> caseList){
		Boolean notificationToSend = false;
		if(decideToCallOrNot()){
			List<Case> caseHavingAttachmentList = new List<Case>();
			for(Case cas: caseList){
	if(trigger.isInsert){
		if(!string.isBlank(cas.CH_CAPS_AttachmentMetadatafromNAIP__c) && !string.isBlank(cas.Origin) && cas.Origin == 'S2S'){
			caseHavingAttachmentList.add(cas);
		}
	}
	if(Trigger.isUpdate){
		if(!string.isBlank(cas.CH_CAPS_AttachmentMetadatafromNAIP__c) && !string.isBlank(cas.Origin) && 
			cas.Origin == 'S2S' && cas.CH_CAPS_AttachmentMetadatafromNAIP__c != oldCaseMap.get(cas.Id).CH_CAPS_AttachmentMetadatafromNAIP__c && !caseStatusSet.contains(cas.Status))
		{
			caseHavingAttachmentList.add(cas);
		}
		notificationToSend = true;
	}	
			}
			if(!caseHavingAttachmentList.isEmpty()){
	processCAPSAttachment(JSON.serialize(caseHavingAttachmentList),notificationToSend);
			}
		}
	}
	/*********************************************************************
	*Commented the method as part of NOKIASC-27612
	*Description: Process Attachments came on case creation
	*Author:	TCS
	*Date:	  14 March 2019
	*Method Name: processAttachmentOnCaseCreation
	*Parameter: <List of Case - Trigger.new>
	*Return: None
	*********************************************************************/
	/*public static void processAttachmentOnCaseCreation(List<Case> caseList){
		if(decideToCallOrNot()){
			List<Case> caseHavingAttachmentList = new List<Case>();
			for(Case cas: caseList){
				if(!string.isBlank(cas.CH_CAPS_AttachmentMetadatafromNAIP__c) && !string.isBlank(cas.Origin) && cas.Origin == 'S2S'){
					caseHavingAttachmentList.add(cas);
				}
			}
			if(!caseHavingAttachmentList.isEmpty()){
				processCAPSAttachment(JSON.serialize(caseHavingAttachmentList),false);
			}
		}
	}*/
	/*********************************************************************
	*Commented the method as part of NOKIASC-27612
	*Description: Process Attachments came on case update
	*Author:	TCS
	*Date:	  14 March 2019
	*Method Name: processAttachmentOnCaseUpdate
	*Parameter: <oldmap of Case>, <List of Case - Trigger.new>
	*Return: None
	*********************************************************************/
	/*public static void processAttachmentOnCaseUpdate(Map<Id,Case> oldCaseMap, List<Case> caseList){
		if(decideToCallOrNot()){
			List<Case> caseHavingAttachmentList = new List<Case>();
			system.debug('CH_CAPS_AttachmentMetadatafromNAIP__c>'+caseList[0].CH_CAPS_AttachmentMetadatafromNAIP__c);
			
			system.debug('CH_CAPS_AttachmentMetadatafromNAIP__c>'+caseList[0].Origin);
			for(Case cas: caseList){
				if(!string.isBlank(cas.CH_CAPS_AttachmentMetadatafromNAIP__c) && !string.isBlank(cas.Origin) && 
					cas.Origin == 'S2S' && cas.CH_CAPS_AttachmentMetadatafromNAIP__c != oldCaseMap.get(cas.Id).CH_CAPS_AttachmentMetadatafromNAIP__c && !caseStatusSet.contains(cas.Status))
				{
					caseHavingAttachmentList.add(cas);
				}
			}
			if(!caseHavingAttachmentList.isEmpty()){
				processCAPSAttachment(JSON.serialize(caseHavingAttachmentList),true);
			}
		}
	}*/
	/*********************************************************************
	*Description: Process Attachments
	*Author:	TCS
	*Date:	  14 March 2019
	*Method Name: processCAPSAttachment
	*Parameter: <serialized case List>, <Boolean - true if update>
	*Return: None
	*********************************************************************/
	@future(callout=true)
	public static void processCAPSAttachment(String caseListStr,Boolean notificationToSend){
		List<Case> newCaseList = new List<Case>();
		newCaseList = (List<Case>)JSON.deserialize(caseListStr, List<Case>.class);
		Map<String,String> caseIdVsAttachmentDataMap = new Map<String,String>();
		Map<String,String> caseIdVsProductIdMap = new Map<String,String>();
		Map<String,String> caseIdVsProductReleaseIdMap = new Map<String,String>();
		Map<String,String> caseIdVsEntitlementIdMap = new Map<String,String>();
		Map<String,String> caseIdVsSecurityMap = new Map<String,String>();
		Map<String,String> caseIdVsCaseNumberMap = new Map<String,String>();
		Map<String,String> caseIdVsAccountIdMap = new Map<String,String>();
		Map<String,String> caseIdVsCaseOwnerQueueMap = new Map<String,String>();
		Map<String,Set<String>> caseIdVsUserIdListMap = new Map<String,Set<String>>();
		if(!newCaseList.isEmpty())
		{
			Map<id,case> caseMap=new Map<id,case>();
			Map<String,String> caseIdVsProductCodeMap = new Map<String,String>();
			Map<String,String> caseIdVsProductReleaseCodeMap = new Map<String,String>();
			Map<String,String> caseIdVsContractCDBIdMap = new Map<String,String>();
			Map<String,String> caseIdVsAccountNumberMap = new Map<String,String>();
			List<CH_Attachment__c> listattach =new List<CH_Attachment__c>();
			List<CH_Outbound_Log__c> listobLogs =new List<CH_Outbound_Log__c>();
			for(Case csObj: newCaseList){
	caseMap.put(csObj.id,csObj);
				caseIdVsAttachmentDataMap.put(csObj.Id, csObj.CH_CAPS_AttachmentMetadatafromNAIP__c);
				caseIdVsProductIdMap.put(csObj.Id, csObj.ProductId);
				caseIdVsProductReleaseIdMap.put(csObj.Id, csObj.CH_Product_Release__c);
				caseIdVsEntitlementIdMap.put(csObj.Id, csObj.EntitlementId);
				caseIdVsSecurityMap.put(csObj.Id, csObj.CH_SecurityGroup__c);
				caseIdVsCaseNumberMap.put(csObj.Id, csObj.CaseNumber);
				caseIdVsAccountIdMap.put(csObj.Id, csObj.AccountId);
				if(notificationToSend){
					if(string.valueof(csObj.OwnerId).startsWithIgnoreCase('005')){
						Set<String> userSet = new Set<String>();
						userSet.add(csObj.OwnerId);
						caseIdVsUserIdListMap.put(csObj.Id, userSet);
					}
					else if(string.valueof(csObj.OwnerId).startsWithIgnoreCase('00G')){
						caseIdVsCaseOwnerQueueMap.put(csObj.Id,csObj.OwnerId);
					}
				}
			}
			//NOKIASC-28441:Added FOR UPDATE to avoid unable to lock row error
			for(Product2 productObj: [SELECT Id, ProductCode 
									FROM Product2 
									WHERE Id 
									IN: caseIdVsProductIdMap.values()])
			{
				for(String caseId: caseIdVsProductIdMap.keySet()){
					if(!caseIdVsProductCodeMap.containsKey(caseId)){
						if(caseIdVsProductIdMap.get(caseId) == productObj.Id){
							caseIdVsProductCodeMap.put(caseId, productObj.ProductCode);
						}
					}
				}
			}
			//NOKIASC-28441:Added FOR UPDATE to avoid unable to lock row error
			for(CH_ProductRelease__c productRelase : [SELECT Id, CH_NSNLegacyCode__c
														FROM CH_ProductRelease__c
														WHERE Id 
														IN: caseIdVsProductReleaseIdMap.values()])
			{
				for(String caseId: caseIdVsProductReleaseIdMap.keySet()){
					if(!caseIdVsProductReleaseCodeMap.containsKey(caseId)){
						if(caseIdVsProductReleaseIdMap.get(caseId) == productRelase.Id){
							caseIdVsProductReleaseCodeMap.put(caseId, productRelase.CH_NSNLegacyCode__c);
						}
					}
				}
			}
			//NOKIASC-28441:Added FOR UPDATE to avoid unable to lock row error
			for(Entitlement entlment: [SELECT Id, ServiceContract.CH_CDB_CustomerId__c 
										FROM Entitlement 
										WHERE Id 
										IN: caseIdVsEntitlementIdMap.values()
										LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				for(String caseId: caseIdVsEntitlementIdMap.keySet()){
					if(!caseIdVsContractCDBIdMap.containsKey(caseId)){
						if(caseIdVsEntitlementIdMap.get(caseId) == entlment.Id && entlment.ServiceContract != null){
							caseIdVsContractCDBIdMap.put(caseId, entlment.ServiceContract.CH_CDB_CustomerId__c);
						}
					}
				}
			}
			//NOKIASC-28441:Added FOR UPDATE to avoid unable to lock row error
			for(Account acc: [SELECT Id, AccountNumber 
										FROM Account 
										WHERE Id 
										IN: caseIdVsAccountIdMap.values()
										LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				for(String caseId: caseIdVsAccountIdMap.keySet()){
					if(!caseIdVsAccountNumberMap.containsKey(caseId)){
						if(caseIdVsAccountIdMap.get(caseId) == acc.Id){
							caseIdVsAccountNumberMap.put(caseId, acc.AccountNumber);
						}
					}
				}
			}
			Set<String> caseIdSetForNotification = new Set<String>();
			final String DECODED_SIGNATUREKEY =  DecodeEncodeUtility.decodeValues(CAPS_ConstantHandler.SIGNATURE_KEYID2);
			for(String caseId : caseIdVsAttachmentDataMap.keySet()){//NAIP will create always single case in one call
				Map<String, Object> objMap = (Map<String, Object>)JSON.deserializeUntyped(caseIdVsAttachmentDataMap.get(caseId));
				system.debug(objMap);
				List<Map<String, Object>> objData = new List<Map<String, Object>>();
				for (Object instance : (List<Object>)objMap.get('attachments')){
					objData.add((Map<String, Object>)instance);
				}
				system.debug(objData);
				for(integer i=0; i< objData.size(); i++)
				{
					
					String attachmentId = (String)objData.get(i).get('AttachmentID__c');
					String fileName = (String)objData.get(i).get('File_Name__c');
					String description = (String)objData.get(i).get('CH_Description__c');
					String classification = (String)objData.get(i).get('CH_Classification__c');
					Decimal fileSize = (Decimal)objData.get(i).get('CH_Size__c');
					Boolean customervisible = (Boolean)objData.get(i).get('Customer_Visible__c');
					DateTime currentTime = DateTime.now();
					string nowFormatted = currentTime.formatGMT(CAPS_ConstantHandler.DATE_FORMAT);
					CAPS_Attachment_Util attachmentUtil = new CAPS_Attachment_Util();
					HttpRequest req = new HttpRequest();
					String url = '';
						url = CAPS_ConstantHandler.SYSTEM_URL + attachmentId;
						req = attachmentUtil.createRequest( CAPS_ConstantHandler.BASE_URL , url, CAPS_ConstantHandler.PUT_METHOD, 
														   CAPS_ConstantHandler.CAPS_ENDUSER,  DECODED_SIGNATUREKEY);
					JSONGenerator gen = JSON.createGenerator(true);
					gen.writeStartObject();
					gen.writeFieldName(CAPS_ConstantHandler.CUSTOMER);
					gen.writeStartObject();
					if(!caseIdVsContractCDBIdMap.isEmpty() && caseIdVsContractCDBIdMap.containsKey(caseId) && caseIdVsContractCDBIdMap.get(caseId) != null)
					{
						gen.writeStringField(CAPS_ConstantHandler.ID_CDB, caseIdVsContractCDBIdMap.get(caseId));
					}else if(!caseIdVsAccountNumberMap.isEmpty() && caseIdVsAccountNumberMap.containsKey(caseId) && caseIdVsAccountNumberMap.get(caseId) != null)
					{
						gen.writeStringField(CAPS_ConstantHandler.ID_CDB, caseIdVsAccountNumberMap.get(caseId));
					}
					gen.writeEndObject();
					if(!caseIdVsProductCodeMap.isEmpty() && caseIdVsProductCodeMap.containsKey(caseId) && caseIdVsProductCodeMap.get(caseId) != null)
					{
						gen.writeFieldName(CAPS_ConstantHandler.PRODUCT);
						gen.writeStartObject();
							gen.writeStringField(CAPS_ConstantHandler.ID_CDB, caseIdVsProductCodeMap.get(caseId));
						gen.writeEndObject();
					}
					if(!caseIdVsProductReleaseCodeMap.isEmpty() && caseIdVsProductReleaseCodeMap.containsKey(caseId) && caseIdVsProductReleaseCodeMap.get(caseId) != null){
						gen.writeFieldName(CAPS_ConstantHandler.PRODUCTVERSION);
						gen.writeStartObject();
						gen.writeStringField(CAPS_ConstantHandler.ID_CDB, caseIdVsProductReleaseCodeMap.get(caseId)); 
						gen.writeEndObject();
					}
					gen.writeStringField(CAPS_ConstantHandler.PURPOSE,CAPS_ConstantHandler.CASE_HANDLING);
					gen.writeStringField(CAPS_ConstantHandler.DESCRIPTIONJSON,description);
					if(Label.CAPS_AppName != null && !caseIdVsCaseNumberMap.isEmpty() && caseIdVsCaseNumberMap.containsKey(caseId) && caseIdVsCaseNumberMap.get(caseId) != null){
						gen.writeFieldName(CAPS_ConstantHandler.TICKET);
						gen.writeStartObject();
						gen.writeStringField(CAPS_ConstantHandler.APP_NAME, Label.CAPS_AppName);
						gen.writeStringField(CAPS_ConstantHandler.TICKET_ID, caseIdVsCaseNumberMap.get(caseId));
						gen.writeEndObject();
					}
					if(!caseIdVsSecurityMap.isEmpty() && caseIdVsSecurityMap.containsKey(caseId) && caseIdVsSecurityMap.get(caseId) != null){
						gen.writeStringField(CAPS_ConstantHandler.SF_SECURITY_GROUPS, caseIdVsSecurityMap.get(caseId));
					}
					gen.writeStringField(CAPS_ConstantHandler.SF_CASE_STATUS, CAPS_ConstantHandler.OPEN_STATUS);
					gen.writeEndObject();
					String jsonString = gen.getAsString();
					req.setBody(jsonString);
					Http http = new Http();
					HTTPResponse res = http.send(req);
					CH_Outbound_Log__c chlogRecord;
					if(res != null && res.getStatusCode() == 200){// check if this can be taken in seprate method
						Map<String, Object> objMapApiResponse = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
						scrambled = (Boolean)objMapApiResponse.get('scrambled');
						List<Map<String, Object>> objDataApiResponse = new List<Map<String, Object>>();
						for (Object instance : (List<Object>)objMapApiResponse.get(CAPS_ConstantHandler.FILES)){
							objDataApiResponse.add((Map<String, Object>)instance);
						}
						string encryptedFileName = fileName + CAPS_ConstantHandler.ENCRYPTEDDOTZIP;
						string capsStatus = CAPS_ConstantHandler.UPLOADING;
						for(integer j=0; j< objDataApiResponse.size(); j++){
							
							string capsFileName = (String)objDataApiResponse.get(j).get(CAPS_ConstantHandler.NAMES);
							if(capsFileName == encryptedFileName){
								capsStatus = (String)objDataApiResponse.get(j).get(CAPS_ConstantHandler.STATUS);
							}
						}
						CH_Attachment__c chAttachmentRecord = new CH_Attachment__c();
						chAttachmentRecord = getCHattachmentdata(caseId,customervisible,fileName,description,fileSize,classification,attachmentId,false,capsStatus);
						listattach.add(chAttachmentRecord);
						if(scrambled)
						{
							chAttachmentRecord = new CH_Attachment__c();
							chAttachmentRecord = getCHattachmentdata(caseId,customervisible,fileName,description,fileSize,classification,attachmentId,true,'');
							listattach.add(chAttachmentRecord);
						}
						if(notificationToSend){
							caseIdSetForNotification.add(caseId);
						}
						//Start-US 25958
					   chlogRecord = new CH_Outbound_Log__c();
						chlogRecord =getCHoutboundlogdata(caseId,res.getBody(),res.getStatusCode(),jsonString,attachmentId);
						listobLogs.add(chlogRecord);//END-US 25958
					}else{
						//Start-US 25958
						chlogRecord = new CH_Outbound_Log__c();
						chlogRecord =getCHoutboundlogdata(caseId,res.getBody(),res.getStatusCode(),jsonString,attachmentId);
						listobLogs.add(chlogRecord);//END-US 25958
						//return error message. add try catch and add errors from all methods
					}
				}
			}
			CH_CaseCommentTriggerHandler.doNotNotifyForNAIPAttachment = false;//Added to fix NOKIASC-26225
			List<Case> newCaseList1=[Select id from Case where id in :caseMap.keyset() FOR UPDATE];//added to fix NOKIASC-28441
			Database.insert(listattach,true);//get case id for successful case ids
			system.debug('listattach***'+listattach);
			Database.insert(listobLogs,true);//US 25958
			if(notificationToSend && !caseIdSetForNotification.isEmpty()){
				if(!caseIdVsCaseOwnerQueueMap.isEmpty()){
				for(GroupMember grpMmber : [SELECT Id, GroupId, UserOrGroupId 
											FROM GroupMember 
											WHERE GroupId 
											IN : caseIdVsCaseOwnerQueueMap.values()])
					{
						if(string.valueof(grpMmber.UserOrGroupId).startsWithIgnoreCase('005')){
							for(String csId : caseIdVsCaseOwnerQueueMap.keySet())
							{
								if(caseIdVsCaseOwnerQueueMap.get(csId) == grpMmber.GroupId){
									Set<String> userIdSet = new Set<String>();
									if(caseIdVsUserIdListMap.containsKey(csId)){
										userIdSet = caseIdVsUserIdListMap.get(csId);
									}
									userIdSet.add(grpMmber.UserOrGroupId);
									caseIdVsUserIdListMap.put(csId, userIdSet);
								}
							}
						}
					}
				}//The customer has provided a new attachment to this case
				if(!caseIdVsUserIdListMap.isEmpty()){
					for(String parentId : caseIdVsUserIdListMap.keySet()){
						if(caseIdSetForNotification.contains(parentId)){
							ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
							textSegmentInput.text = 'The customer has provided a new attachment to this '+ caseIdVsCaseNumberMap.get(parentId) +' '+ '\n\n';
							ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
							messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
							messageBodyInput.messageSegments.add(textSegmentInput);
							// Create an @mention for all queue members  
							for (String usrId : caseIdVsUserIdListMap.get(parentId)){
								ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
								mentionSegmentInput.id = usrId;
								messageBodyInput.messageSegments.add(mentionSegmentInput);
							}
							ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
							feedItemInput.body = messageBodyInput;
							feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
							feedItemInput.subjectId = parentId;
				if(!Test.isRunningTest()){
							ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);//not is running test
				}
						}
					}
				}
			}
		}
	}
	/******************************************
	* Method Name : getCHattachmentdata
	* Created Date: 14-March-2019
	* Created By : TCS
	* Descsription: Create Ch_Attachment records in Salesforce
	* Parameter: ID,Boolean,String,String,Decimal,String,String,Boolean,String
	* Return: CH_Attachment__c
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/
	public static CH_Attachment__c getCHattachmentdata
		(String caseRecordId, 
		Boolean customervisible, 
		String fileName,
		String description,
		Decimal fileSize,
		String classification,
		String attachmentId,
		Boolean isScrambled,
		String capsStatusforEncryptedfile)
	{
		CH_Attachment__c chattch = new CH_Attachment__c();
		chattch.Name = fileName;
		chattch.CH_Size__c = fileSize;
		chattch.CH_Description__c = description;
		chattch.CH_Puropse__c = CAPS_ConstantHandler.CASE_HANDLING;
		chattch.CH_Service_Class__c = CAPS_ConstantHandler.CARE_SREVICECLASS;
		chattch.CH_Classification__c = classification;
		chattch.Case__c = caseRecordId;
		//get status from caps, else file not present then uploading
		chattch.AttachmentID__c = attachmentId;
		chattch.Customer_Visible__c = customervisible;
		chattch.CH_Uploaded__c = system.now();
		chattch.CH_Portal_or_Email_to_Case__c = 'Customer System';	   
		if(!isScrambled){
			chattch.CH_Status__c = capsStatusforEncryptedfile;
			chattch.File_Name__c = fileName + CAPS_ConstantHandler.ENCRYPTEDDOTZIP;
			chattch.CH_FileType__c = CAPS_ConstantHandler.ENCRYPTED;
		}
		if(isScrambled){
			/*Adding scrambled attachment*/ 
			chattch.CH_Status__c = CAPS_ConstantHandler.UPLOADING;
			chattch.File_Name__c = fileName +CAPS_ConstantHandler.SCRAMBLEDDOTZIP;
			chattch.CH_FileType__c = CAPS_ConstantHandler.SCRAMBLED; 
		}
		return chattch;
	}
	
	/******************************************
	* Method Name : getCHoutboundlogdata
	* Created Date: 10th-Feb-2020
	* Created By : TCS
	* Descsription: Create CH_Outbound_Log__c records in Salesforce
	* Parameter: CaseRecordID,ResponseBody,Response Status,RequestBody,AttachementID
	* Return: CH_Outbound_Log__c
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/
	public static CH_Outbound_Log__c getCHoutboundlogdata
		(String caseRecordId,String Comment,Integer Status,String messageBody, String attId)
	{
		CH_Outbound_Log__c chlog = new CH_Outbound_Log__c();
		chlog.CH_Name__c='CAPS Metadata Update';
		chlog.CH_Attachment_Id__c=attId;
		chlog.CH_Comment__c=Comment;
		chlog.CH_Interface_Type__c='CAPS';
		chlog.CH_Message_body__c=messageBody;
		chlog.CH_SF_Ticket_Id__c=caseRecordId;
		chlog.CH_Created_Date__c=datetime.now();
		if(Status==200){
		chlog.CH_Number_of_Records_Success__c=1;
		chlog.CH_Resend__c=False;
		chlog.CH_Status__c ='Success';
	   
		}
		else{
		chlog.CH_Number_of_Records_Failed__c=1;
		chlog.CH_Resend__c=True;
		chlog.CH_Status__c='Failure';
		}	   
		return chlog;
	}
	
	
}