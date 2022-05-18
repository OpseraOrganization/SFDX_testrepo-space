public without sharing class HWS_UpdateReturnDeliveryAddress {

	 @future(callout=true)
	public static void updateReturnDeliveryAddressOnChildCase(Set<Id> caseIds,Id parentCaseId){
		updateReturnDeliveryAddressOnChildCaseFromBatch(caseIds,parentCaseId);
	  }
	
	//Removed future and moved to common for batch class NOKIASC-37193
	public static void updateReturnDeliveryAddressOnChildCaseFromBatch(Set<Id> caseIds,Id parentCaseId){
		List<HWS_BulkUpload__c> bulkrecList = [Select Id, Part_Code_Part_Revision__c, HWS_LSPResponse__c,ParentCaseId__c from HWS_BulkUpload__c where ParentCaseId__c=:parentCaseId];
		if(!bulkrecList.isEmpty()){
			HWS_BulkUpload__c bulkrec = bulkrecList[0];
			if(bulkrec.Part_Code_Part_Revision__c !=null && bulkrec.HWS_LSPResponse__c != null){
				HWS_WrapLSPInstructions requestObj = (HWS_WrapLSPInstructions)JSON.deserialize(bulkrec.HWS_LSPResponse__c, HWS_WrapLSPInstructions.class);
				try{
					//NOKIASC-35422-start
					Case parentCaseDetails = [Select Id, CaseNumber, HWS_Bar_Code__c,HWS_ReturnAddressReceivedFromSOO__c,HWS_Case_Ordered_Date__c,EntitlementId,(Select Id,HWS_Bar_Code_Ref1__c,HWS_Bar_Code__c,HWS_Contract_Line_Item__c,RecordTypeId,CH_ServiceType__c,CH_RecordTypeDevName__c,EntitlementId,HWS_RequestHWRCAFMA__c  from Cases where Id In: caseIds ) from Case Where Id=:parentCaseId AND HWS_ReturnAddressReceivedFromSOO__c = true];//modified for NOKIASC-37193
					Map<Id, Case> caseMap = new Map<Id, Case>();
					for(Case caseRec : parentCaseDetails.Cases){
					   
						caseMap.put(caseRec.Id, caseRec);
					}
					try{
						Map<String,HWS_WrapLSPInstructions.DeliveryAddress> mapNodeDeliveryAddress = new Map<String,HWS_WrapLSPInstructions.DeliveryAddress>();
						Map<String,String> mapSupplierNode = new Map<String,String>();
						List<Case> childList = new List<Case>();
						Set<Id> caseIdSet =new Set<Id>();
						for(HWS_WrapLSPInstructions.SupplierNodes supplierNode : requestObj.SupplierNodes){ 
							mapSupplierNode.put(supplierNode.LogisticNode,supplierNode.ReferralInstruction);
						 }
						for(HWS_WrapLSPInstructions.DeliveryAddress address: requestObj.DeliveryAddress){
							mapNodeDeliveryAddress.put(address.ReturnAddressNode,address);
						}
						for(HWS_WrapLSPInstructions.ChildCases child: requestObj.ChildCases){
							if(child.SRMServiceItemID!=null && child.SRMServiceItemID!='' && caseMap.get(child.SRMServiceItemID) != null){
								Case lSPInstructionCase = caseMap.get(child.SRMServiceItemID);
								lSPInstructionCase.HWS_LogisticNodeCode__c = child.LogisticNode;
								lSPInstructionCase.HWS_LogisticNodeName__c = child.LogisticNodeName;
								if(mapNodeDeliveryAddress.get(child.ReturnAddressNode)!=null){
									HWS_WrapLSPInstructions.DeliveryAddress returnAddressDetails = mapNodeDeliveryAddress.get(child.ReturnAddressNode);
									lSPInstructionCase.HWS_Address_Name__c = returnAddressDetails.Name;
									lSPInstructionCase.HWS_AddressType__c = returnAddressDetails.AddressType;
									lSPInstructionCase.City__c = returnAddressDetails.City;
									lSPInstructionCase.Street_Address_1__c = returnAddressDetails.Street;
									lSPInstructionCase.Street_Address_2__c = returnAddressDetails.AddressLine2;
									lSPInstructionCase.Street_Address_3__c = returnAddressDetails.AddressLine3;
									lSPInstructionCase.HWS_Region__c = returnAddressDetails.Region;
									lSPInstructionCase.POSTAL_CODE_CHQ__c = returnAddressDetails.PostalCode;
									lSPInstructionCase.Country__c = returnAddressDetails.Country;
									lSPInstructionCase.HWS_Region__c = returnAddressDetails.Region;
									lSPInstructionCase.HWS_DeliveryNote__c = returnAddressDetails.DeliveryNote;
									lSPInstructionCase.State__c = returnAddressDetails.State;
									lSPInstructionCase.HWS_StartMilestone__c = true;
									if(mapSupplierNode.get(child.LogisticNode)!=null && mapSupplierNode.get(child.LogisticNode)!=''){ lSPInstructionCase.CH_InternalStatus__c = HWS_Constants.PENDING_REFERRAL_INSTRUCTION;
										}
									childList.add(lSPInstructionCase);
								}
								else if(mapSupplierNode.get(child.LogisticNode)!=null && mapSupplierNode.get(child.LogisticNode)!=''){ lSPInstructionCase.CH_InternalStatus__c = HWS_Constants.PENDING_REFERRAL_INSTRUCTION ;childList.add(lSPInstructionCase);   
		}
								
							}
						}
						if(!childList.isEmpty()){
							HWS_Utilty.PopulateEntitlementIdOnParentChildList parentChildList = HWS_Utilty.PopulateEntitlementIdOnParentChildList.populateEntitlementIdAndStatusOrderForCases(childList,parentCaseDetails);
							childList = parentChildList.childCaseList; 
							update childList;
							System.debug('childList**'+childList);
							//CH_AuthorizedContactSharing.handleSharing(new Map<Id, Case>(childList), new Map<Id, Case>(), true, false);
			/*	 for(Case cs:childList){
		if(caseMap.get(cs.id).HWS_RequestHWRCAFMA__c){ //Added isTrue condition to check flag for NOKIASC-37600
								 caseIdSet.add(cs.id);	}
				}
				if(caseIdSet.size()>0){  //Added for NOKIASC-37600
								 HWS_EmailNotifications.RequestHWFMARCA(caseIdSet);	
		 }*/
		 //commenting and adding this code in HWS_CaseTriggerHandler after update method
		if(Limits.getQueueableJobs() == 1){
								String hour = String.valueOf(Datetime.now().hour());
								String min = String.valueOf(Datetime.now().minute()); 
								String ss = String.valueOf(Datetime.now().second() + 5);
								//parse to cron expression
								String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
								System.schedule('ScheduledJob ' + String.valueOf(Math.random()), nextFireTime, new HWS_AuthorizedContactSharingSchedulable(childList));
							}else{
								CH_AuthorizedContactSharing.handleSharing(new Map<Id, Case>(childList), new Map<Id, Case>(), true, false);
							}
						}
					}
					catch(Exception e){ 
						createInterfaceLogError(e.getMessage(),e.getLineNumber() );
						
					} 
				}Catch(Exception e){
					createInterfaceLogError(e.getMessage(),e.getLineNumber() );
					
				}
			}
		}		
	}
	Public static void createInterfaceLogError(String errorMessage, Integer lineNumber){
		Interface_Log__c ilogcallout = new Interface_Log__c();
		ilogcallout.Interface_Type__c = 'Rest Resource';
		ilogcallout.Message_Type__c = 'Inbound';
		ilogcallout.Operation_Type__c = 'Insert';
		ilogcallout.Comment__c = errorMessage + ' and Line number is: '+lineNumber;
		ilogcallout.Status__c = 'Failure';
		ilogcallout.Name = 'LSP Instraction Failure';
		Database.insert(ilogcallout,true);
	}
}