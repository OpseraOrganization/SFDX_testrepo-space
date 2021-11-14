/*************************************************************
@Name: CancelCollaborationHandler
@Author: Accenture
@Description: This class is used for collaboration process Logic

******************************************************************/

public without sharing class CancelCollaborationHandler{
	
	//The method is used for handling cancel collaboration request
	 public static void handleCancelCollaboration(List<Apttus_Config2__CollaborationRequest__c> canCollReqList){
	 Set<Id> quoteObjSet = new Set<Id>();
	 Set<Id> prodConObjSet = new Set<Id>();
	 //Set<String> notToBeUpdatedQuotes = new Set<String>();
	 List<Apttus_Proposal__Proposal__c> tobeUpdatedQuotes = new List<Apttus_Proposal__Proposal__c>();
	 Map<String,List<Apttus_Config2__ProductConfiguration__c>> quoteConfigMap = new Map<String,List<Apttus_Config2__ProductConfiguration__c>>();
	 try{
		   for(Apttus_Config2__CollaborationRequest__c objColl: canCollReqList){
				quoteObjSet.add(objColl.Quote_Record_ID__c);
				prodConObjSet.add(objColl.Apttus_Config2__ParentConfigurationId__c);
		   }
			system.debug('quoteObjSet**' + quoteObjSet);
			system.debug('prodConObjSet**' + prodConObjSet);
			
			for(Apttus_Config2__ProductConfiguration__c prodconfig : [Select Id, Apttus_QPConfig__Proposald__c, Apttus_Config2__CollaborationRequestId__c , Apttus_Config2__CollaborationRequestId__r.Apttus_Config2__Status__c From Apttus_Config2__ProductConfiguration__c Where Apttus_QPConfig__Proposald__c IN: quoteObjSet AND Apttus_Config2__BusinessObjectType__c =: Nokia_CPQ_Constants.COLLABORATION_REQUEST]){
				if(quoteConfigMap.containsKey(prodconfig.Apttus_QPConfig__Proposald__c)){
					quoteConfigMap.get(prodconfig.Apttus_QPConfig__Proposald__c).add(prodconfig);
				}
				else{
					quoteConfigMap.put(prodconfig.Apttus_QPConfig__Proposald__c, new List<Apttus_Config2__ProductConfiguration__c>{prodconfig});
				}
			}
			
			
			/*for(Apttus_Config2__LineItem__c lineItem : [select id, Collaboration_Status__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c IN: prodConObjSet AND Collaboration_Status__c = 'In Progress']){
				notToBeUpdatedQuotes.add(Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c);
			}*/
			
			system.debug('quoteConfigMap**' + quoteConfigMap);
			Boolean isPendingCollaboration;
			for(Apttus_Proposal__Proposal__c quoteRec : [select Id, IsCollaborationProgress__c from Apttus_Proposal__Proposal__c where Id IN:quoteObjSet]){
				isPendingCollaboration = false;
				if(!quoteConfigMap.containsKey(quoteRec.Id)){
					tobeUpdatedQuotes.add(quoteRec);
				}
				else{
					for(Apttus_Config2__ProductConfiguration__c config : quoteConfigMap.get(quoteRec.Id)){
						if(config.Apttus_Config2__CollaborationRequestId__c != null && config.Apttus_Config2__CollaborationRequestId__r.Apttus_Config2__Status__c != Nokia_CPQ_Constants.ACCEPTED_STRING){
							isPendingCollaboration = true;
							break;
						}
					}
					if(!isPendingCollaboration){
						tobeUpdatedQuotes.add(quoteRec);
					}
				}
			}
			system.debug('tobeUpdatedQuotes**' + tobeUpdatedQuotes);
			if(!tobeUpdatedQuotes.isEmpty()){
				for(Apttus_Proposal__Proposal__c quote : tobeUpdatedQuotes){
					quote.IsCollaborationProgress__c = false;
				}
				update tobeUpdatedQuotes;
			}
			
		}
		catch(Exception ex) {		   
			ExceptionHandler.addException(ex,CancelCollaborationHandler.class.getName(),Nokia_CPQ_Constants.QUOTE_NOT_FOUND);
		}
	}
}