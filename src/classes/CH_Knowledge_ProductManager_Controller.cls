/****************************************
* Class Name : CH_Knowledge_ProductManager_Controller
* Created Date: 2 May 2019
* Created By : Tiago Almeida (tiago.almeida@nokia.com)
* Last Modified by: Tiago Almeida
* Last Modified Date: 9 May 2019
* Description : Controller for CH_Knowledge_ProductManager
* Test Class: CH_Knowledge_ProductManager_Test
*****************************************/
public class CH_Knowledge_ProductManager_Controller {
	
	@AuraEnabled
	public static Boolean canEdit(Id articleId){
		Knowledge__kav oKnowledge = [
			SELECT Id, CH_InApproval__c, PublishStatus, CH_Workgroup__c FROM Knowledge__kav  WHERE Id =: articleId LIMIT 1
		];
		
		Id userId = UserInfo.getUserId();
		Map<Id, String> wgMemberMap = new Map<Id, String>();
		for(CH_Workgroup_Member__c wgMember : [
			SELECT Id, CH_Role__c, CH_UserId__c FROM CH_Workgroup_Member__c WHERE CH_Workgroup__c =: oKnowledge.CH_Workgroup__c
		]){
			if(!wgMemberMap.keySet().contains(wgMember.CH_UserId__c)){
				wgMemberMap.put(wgMember.CH_UserId__c, wgMember.CH_Role__c);
			}
		}
		Boolean approverorpublisher = false;
		if(wgMemberMap.keySet().contains(userId)){
			approverorpublisher = (wgMemberMap.get(userId).equals('Public Approver (Publisher)') || wgMemberMap.get(userId).equals('Internal Approver (Approver)'));
		}
		return ((oKnowledge.CH_InApproval__c && !approverorpublisher) || oKnowledge.PublishStatus.equals('Online'));
	}
	
	@AuraEnabled
	public static List<CH_ProductRelation__c> getArticleProductsAndReleases(Id articleId){
		return [
			SELECT
				CH_Parent_Product__r.Id, CH_Parent_Product__r.Name, CH_Parent_Release__r.Id, CH_Parent_Release__r.Name
			FROM
				CH_ProductRelation__c
			WHERE
				CH_Knowledge__c =: articleId AND ( CH_Parent_Product__c != NULL OR CH_Parent_Release__c != NULL)
		];
	}
	
	@AuraEnabled
	public static List<CH_Workgroup_Rule__c> getValidArticleProducts(Id articleId){
		Set<Id> alreadySelectedProducts = new Set<Id>();
		Knowledge__kav oKnowledge = [
			SELECT Id, CH_Workgroup__c FROM Knowledge__kav  WHERE Id =: articleId LIMIT 1
		];
		for(CH_ProductRelation__c oProductRelation : [ SELECT 
										CH_Parent_Product__r.Id, CH_Parent_Product__r.Name
								 FROM
										CH_ProductRelation__c
								 WHERE
									CH_Knowledge__c =: articleId AND CH_Parent_Product__c != NULL AND CH_Parent_Release__c = NULL
							   ]) {
			alreadySelectedProducts.add(oProductRelation.CH_Parent_Product__r.Id);
		}
		return [SELECT Id, CH_Product__r.Id, CH_Product__r.Name FROM CH_Workgroup_Rule__c WHERE CH_Workgroup__c =: oKnowledge.CH_Workgroup__c AND CH_Product__r.Id NOT IN :alreadySelectedProducts];
	}
	
	@AuraEnabled
	public static List<CH_ProductRelease__c> getValidProductReleases(Id articleId, Id productId) {
		Set<Id> alreadySelectedProductReleases = new Set<Id>();
		Knowledge__kav oKnowledge = [
			SELECT Id, CH_Workgroup__c FROM Knowledge__kav  WHERE Id =: articleId LIMIT 1
		];
		for(CH_ProductRelation__c oProductRelation : [ SELECT 
										CH_Parent_Product__c, CH_Parent_Release__r.Id, CH_Parent_Release__r.Name
								 FROM
										CH_ProductRelation__c
								 WHERE
									CH_Knowledge__c =: articleId AND CH_Parent_Product__c != NULL AND CH_Parent_Release__c != NULL
							   ]) {
			alreadySelectedProductReleases.add(oProductRelation.CH_Parent_Release__r.Id);
		}
		return [SELECT Id, Name FROM CH_ProductRelease__c WHERE CH_ProductId__c =: productId AND Id NOT IN :alreadySelectedProductReleases];
	}
	
	@AuraEnabled
	public static Boolean saveProductRelation(Id articleId, string productRelation) {
		try {
			CH_ProductRelation__c oProductRelation = (CH_ProductRelation__c) JSON.deserialize(productRelation, CH_ProductRelation__c.class);
			insert oProductRelation;
			if(oProductRelation.CH_Parent_Product__c != NULL && oProductRelation.CH_Parent_Release__c == NULL){
				CH_Knowledge_ProductManager_Helper.updateKBProducts(articleId);
				CH_Knowledge_ProductManager_Helper.createTopic(articleId, oProductRelation.Id);
			} 
		} catch (Exception e) {
			system.debug('###Exception:' + e.getMessage());
			throw new AuraHandledException('Something went wrong! '+ e.getMessage());
		}
		return true;
	}
	
	@AuraEnabled
	public static Boolean removeProductOrReleaseRelation(Id articleId, string target, Id objId) {
		try {
			List<CH_ProductRelation__c> toDelete = new List<CH_ProductRelation__c>();
			if(target.equals('Product')){
				CH_Knowledge_ProductManager_Helper.removeTopic(articleId, [
					SELECT CH_Parent_Product__r.Name FROM CH_ProductRelation__c
					WHERE CH_Knowledge__c =: articleId AND CH_Parent_Product__c =: objId Limit 1
				].CH_Parent_Product__r.Name);
				toDelete = [
					SELECT Id FROM CH_ProductRelation__c
					WHERE CH_Knowledge__c =: articleId AND CH_Parent_Product__c =: objId
				];
			}
			else if(target.equals('Product Release')){
				toDelete = [
					SELECT Id FROM CH_ProductRelation__c
					WHERE CH_Knowledge__c =: articleId AND CH_Parent_Release__c =: objId
				];				
			}
			if(!toDelete.isEmpty()) delete toDelete; 
			if(target.equals('Product')) CH_Knowledge_ProductManager_Helper.updateKBProducts(articleId);
		} catch (Exception e) {
			system.debug('###Exception:' + e.getMessage());
			throw new AuraHandledException('Something went wrong! '+ e.getMessage());
		}
		return true;
	}
}