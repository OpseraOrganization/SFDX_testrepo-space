public without sharing class CH_ProductBGBUBL_UTIL {

	public static void buildProductHierarchyBGBUBL(List <Product_Relation__c> productHierachyBLRecords){

		Set<String> childsAndProductIds = new Set<String>();
		Set<String> childsIds = new Set<String>();
		Set<String> productIds = new Set<String>();
		
		Set<String> childsBLs = new Set<String>();
		Set<String> childsBUs = new Set<String>();
		
		Set<String> childsBUForBGs = new Set<String>();
		
		Set<String> parentBGs = new Set<String>();
		Set<String> parentBLBUBGs = new Set<String>();
		
		Map<Id, String> prodBL = new Map<Id, String>();
		Map<Id, String> prodBLNull = new Map<Id, String>();
		Map<Id, String> prodBU = new Map<Id, String>();
		Map<Id, String> prodBG = new Map<Id, String>();
		
		Map<Id, String> childsAndProductIdsMap = new Map<Id, String>();
		Map<Id, String> childsBLAndProductIdsMap = new Map<Id, String>();
		Map<Id, String> childsBUAndProductIdsMap = new Map<Id, String>();
		Map<Id, String> childsBLBUAndProductIdsMap = new Map<Id, String>();
		Map<Id, String> childsBLBUBGAndProductIdsMap = new Map<Id, String>();
		Map<Id, String> childsBGAndProductIdsMap = new Map<Id, String>();
		
		List<Product2> productHierarchyToUpdate = new List<Product2>();

		for (Product_Relation__c productRelation : productHierachyBLRecords){
			childsIds.add(productRelation.Child_Name__c);
			productIds.add(productRelation.Parent_Product__r.Id);
			
			childsAndProductIdsMap.put(productRelation.Parent_Product__r.Id, productRelation.Child_Name__c);
		}
		for(ProductClassification__c productClassification : [SELECT Id, NSNClassnumber__c, NSNClassType__c, Name__c FROM ProductClassification__c WHERE NSNClassnumber__c IN :childsIds AND ClassificationStatus__c = 'Active' AND NSNClassType__c IN ('BL','BU','SU','DU') AND EDP_ActiveStatus__c = TRUE AND NSNClassLibrary__c = 'Owner Organization']){
			for(Id childs : childsAndProductIdsMap.keySet()){
				if(productClassification.NSNClassnumber__c == childsAndProductIdsMap.get(childs)){
					if(productClassification.NSNClassType__c == 'BL'){
						//LEVEL 1 = BL (BL, BU, BG)
						prodBL.put(childs, productClassification.Name__c);
						childsBLs.add(productClassification.NSNClassnumber__c);
						childsBLAndProductIdsMap.put(childs, productClassification.NSNClassnumber__c);
					} else {
						//LEVEL 1 = BU (ONLY BU AND BG)
						prodBLNull.put(childs, '');
						prodBU.put(childs, productClassification.Name__c);
						childsBUs.add(productClassification.NSNClassnumber__c);
						childsBUAndProductIdsMap.put(childs, productClassification.NSNClassnumber__c);
					}
				}
			}
		}
		//LEVEL 2 (BL, BU, BG)
		for(Product_Relation__c productHierachyBLBURecords : [SELECT Id, Parent_Name__c, Parent_Type__c, Child_Name__c, RelationType__c, RelationFor__c, Parent_Product__r.Id, Parent_Product__c FROM Product_Relation__c WHERE Child_Name__c IN :childsBLs AND RelationType__c  = 'SubClass' AND EDPActiveStatus__c = TRUE]){
			childsBUForBGs.add(productHierachyBLBURecords.Parent_Name__c);
			for(Id childBL : childsBLAndProductIdsMap.keySet()){
				if(productHierachyBLBURecords.Child_Name__c == childsBLAndProductIdsMap.get(childBL)){
					childsBLBUAndProductIdsMap.put(childBL, productHierachyBLBURecords.Parent_Name__c);
				}
			}
		}
		for(ProductClassification__c buProductClassification : [SELECT Id, NSNClassnumber__c, NSNClassType__c, Name__c FROM ProductClassification__c WHERE NSNClassnumber__c IN :childsBUForBGs AND ClassificationStatus__c = 'Active' AND NSNClassType__c IN ('BU','SU','DU') AND EDP_ActiveStatus__c = TRUE AND NSNClassLibrary__c = 'Owner Organization']){
			for(Id childBU : childsBLBUAndProductIdsMap.keySet()){
				if(buProductClassification.NSNClassnumber__c == childsBLBUAndProductIdsMap.get(childBU)){
					prodBU.put(childBU, buProductClassification.Name__c);
				}
			}
		}
		//
		
		//LEVEL 3 (BL, BU, BG)
		for(Product_Relation__c productHierachyBGRecords : [SELECT Id, Parent_Name__c, Parent_Type__c, Child_Name__c, RelationType__c, RelationFor__c, Parent_Product__r.Id, Parent_Product__c FROM Product_Relation__c WHERE Child_Name__c IN :childsBUForBGs AND RelationType__c  = 'SubClass' AND EDPActiveStatus__c = TRUE]){
			parentBLBUBGs.add(productHierachyBGRecords.Parent_Name__c);
			for(Id childBU : childsBLBUAndProductIdsMap.keySet()){
				if(productHierachyBGRecords.Child_Name__c == childsBLBUAndProductIdsMap.get(childBU)){
					childsBLBUBGAndProductIdsMap.put(childBU, productHierachyBGRecords.Parent_Name__c);
				}
			}
		}
		for(ProductClassification__c bgProductClassification : [SELECT Id, NSNClassnumber__c, NSNClassType__c, Name__c FROM ProductClassification__c WHERE NSNClassnumber__c IN :parentBLBUBGs AND ClassificationStatus__c = 'Active' AND NSNClassType__c IN ('BG') AND EDP_ActiveStatus__c = TRUE AND NSNClassLibrary__c = 'Owner Organization']){
			for(Id childBG : childsBLBUBGAndProductIdsMap.keySet()){
				if(bgProductClassification.NSNClassnumber__c == childsBLBUBGAndProductIdsMap.get(childBG)){
					prodBG.put(childBG, bgProductClassification.Name__c);
				}
			}
		}
		//
		//LEVEL 2 (ONLY BU AND BG)
		for(Product_Relation__c productHierachyBUBGRecords : [SELECT Id, Parent_Name__c, Parent_Type__c, Child_Name__c, RelationType__c, RelationFor__c, Parent_Product__r.Id, Parent_Product__c FROM Product_Relation__c WHERE Child_Name__c IN :childsBUs AND RelationType__c  = 'SubClass' AND EDPActiveStatus__c = TRUE]){
			for(Id childBU : childsBUAndProductIdsMap.keySet()){
				if(productHierachyBUBGRecords.Child_Name__c == childsBUAndProductIdsMap.get(childBU)){
					childsBGAndProductIdsMap.put(childBU, productHierachyBUBGRecords.Parent_Name__c);
					parentBGs.add(productHierachyBUBGRecords.Parent_Name__c);
				}
			}
		}
		system.debug('parentBGs ' +parentBGs);
		
		for(ProductClassification__c productClassification : [SELECT Id, NSNClassnumber__c, NSNClassType__c, Name__c FROM ProductClassification__c WHERE NSNClassnumber__c IN :parentBGs AND ClassificationStatus__c = 'Active' AND NSNClassType__c = 'BG' AND EDP_ActiveStatus__c = TRUE AND NSNClassLibrary__c = 'Owner Organization']){
			for(Id childBG : childsBGAndProductIdsMap.keySet()){
				if(productClassification.NSNClassnumber__c == childsBGAndProductIdsMap.get(childBG)){
					prodBG.put(childBG, productClassification.Name__c);
				}
			}
		}
		//
		//UPDATE
		for(Product2 product : [SELECT Id, CH_Business_Line__c, CH_Business_Unit__c, CH_Business_Group__c FROM Product2 WHERE Id IN :productIds]){
			if(prodBL.keySet().contains(product.Id)){
				product.CH_Business_Line__c = prodBL.get(product.Id);					
			}
			if(prodBLNull.keySet().contains(product.Id)){
				product.CH_Business_Line__c = prodBLNull.get(product.Id);					
			}
			if(prodBU.keySet().contains(product.Id)){
				product.CH_Business_Unit__c = prodBU.get(product.Id);					
			}
			if(prodBG.keySet().contains(product.Id)){
				product.CH_Business_Group__c = prodBG.get(product.Id);					
			}
			productHierarchyToUpdate.add(product);
		}
		if(!productHierarchyToUpdate.isEmpty()){
			update productHierarchyToUpdate;
		}
		//
	}
}