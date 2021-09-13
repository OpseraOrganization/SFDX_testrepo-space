/**************************************** 
 * Class Name : Batch_GBOMRelation
 * Created Date: 4 dec 18
 * Created By : Accenture
 * Last Modified by:  
 * Last Modified Date:  
 * Description : Batch used to update GBOM relation table
 * Test Class: 
 *****************************************/

global class Batch_GBOMRelation implements Database.Batchable<sObject>, Database.Stateful {
   
	//Constructor
	public Batch_GBOMRelation(){ 
		

	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		// return Database.getQueryLocator([select id, Description__c, ItemId__c, NSN_Code__c, NSNClassification__c, ItemType__c 
											//	from ProductFeature__c where id = 'a9Y210000004K5V' OR id = 'a9Y210000004K5Q']);
		 date dt = system.today();			   
		 return Database.getQueryLocator([select id, Description__c, ItemId__c, NSN_Code__c, NSNClassification__c, ItemType__c 
											   from ProductFeature__c where createdDate >=: dt ]);
	}

	global void execute(Database.BatchableContext BC, List<ProductFeature__c>  ProdFeatureToProcess){
		set<string> ProdFeatureID = new set<string>();
		set<string> productCodeSet = new set<string>();
		map<string, ID> productCodeToId = new map<string, ID>();
		set<string> allFeature = new set<string>();
		map<string, ID> featureItemToId = new map<string, ID>();
		map<string, set<string>> featureToProd = new map<string, set<string>>();
		map<string, set<string>> existingFeatureToProd = new map<string, set<string>>();
		Set<string> pciSet = new Set<string>();
		
		list<Product_Feature_Junction__c> newJunctionlist = new list<Product_Feature_Junction__c>();
	   
	   try{system.debug('ProdFeatureToProcess: '+ ProdFeatureToProcess);
for(ProductFeature__c ProdFeat :  ProdFeatureToProcess){
	ProdFeatureID.add(ProdFeat.NSN_Code__c);
	featureItemToId.put(ProdFeat.NSN_Code__c, ProdFeat.id);
}


system.debug(' ProdFeatureID: '+ ProdFeatureID );
system.debug(' featureItemToId: '+ featureItemToId );

list<Product_Relation__c> ProdRelationToProcess = [select id, Child_ID__c, Child_Name__c, Parent_ID__c, Parent_Name__c, Parent_Type__c,Child_Type__c, EDPActiveStatus__c,												   RelationType__c 
												from Product_Relation__c
												where Parent_Name__c in: ProdFeatureID and RelationType__c =: CSWXGlobalConstant.GBOM AND Parent_Type__c =: CSWXGlobalConstant.Feature AND 
												(Child_Type__c =: CSWXGlobalConstant.NSN_Software_SI OR Child_Type__c =: CSWXGlobalConstant.PCI)];
	
system.debug(' ProdRelationToProcess: '+ ProdRelationToProcess );   
for (Product_Relation__c prodRel : ProdRelationToProcess ){
	set<String> productList = new set<String>();
	if(prodRel.Parent_Type__c == CSWXGlobalConstant.Feature){
		system.debug(' prodRel : '+ prodRel);
		if(featureItemToId.containsKey(ProdRel.Parent_Name__c) && featureItemToId.get(ProdRel.Parent_Name__c) != Null){
		if(featureToProd.containsKey(featureItemToId.get(ProdRel.Parent_Name__c)) && featureToProd.get(featureItemToId.get(ProdRel.Parent_Name__c)) != Null){
			productList = featureToProd.get(featureItemToId.get(ProdRel.Parent_Name__c));
						
		}
		}
		productList.add(prodRel.Child_Name__c);
		productCodeSet.add(prodRel.Child_Name__c);
		system.debug('productCodeSet : '+productCodeSet );
		if(prodRel.Child_Type__c == CSWXGlobalConstant.PCI){
			pciSet.add(prodRel.Child_Name__c);
		}
		
		}
		featureToProd.put(featureItemToId.get(ProdRel.Parent_Name__c), productList );
		allFeature.add(featureItemToId.get(prodRel.Parent_Name__c));
		system.debug('final in loop productList : '+productList );
		system.debug('featureToProd : '+featureToProd );
		
			
		
	}
	/*else if(prodRel.Parent_Type__c == 'SMB'){
		
		if(smbToProd.containsKey(Prodrel.Parent_ID__c) && !smbToProd.get(prodRel.Parent_ID__c)){
			productList = smbToProd.get(prodRel.Parent_ID__c);
			productList.add(prodRel.Child_ID__c);
			productCodeSet.add(prodRel.Child_ID__c);
			allFeature.add(featureItemToId.get(prodRel.Parent_ID__c));
		}
		smbToProd.put(featureItemToId.get(ProdRel.Parent_ID__c), productList )
	} */

system.debug('productCodeSet : '+productCodeSet );
		
system.debug('featureToProd : '+ featureToProd );
system.debug(' allFeature : '+ allFeature);

list<Product2> relatedProduct = [select id, ProductCode
												from Product2
												where ProductCode in: productCodeSet];
system.debug('relatedProduct : '+ relatedProduct );										 
for(Product2 prod : relatedProduct){

	productCodeToId.put(prod.ProductCode, prod.id);

}
system.debug('productCodeToId : '+ productCodeToId );

list <Product_Feature_Junction__c> existingJunction = [select id, Product__c, Product__r.ProductCode, Product_Feature__c from Product_Feature_Junction__c where Product_Feature__c in: allFeature];
system.debug(' existingJunction: '+ existingJunction );

for(Product_Feature_Junction__c exisitingJunc : existingJunction){
	set<String> productList = new set<String>();
	if(existingFeatureToProd.containskey(exisitingJunc.Product_Feature__c) && existingFeatureToProd.get(exisitingJunc.Product_Feature__c) != Null){
		productList = existingFeatureToProd.get(exisitingJunc.Product_Feature__c);
	}
	productList.add(exisitingJunc.Product__r.ProductCode);
	existingFeatureToProd.put(exisitingJunc.Product_Feature__c, productList);
}
system.debug('existingFeatureToProd  : '+  existingFeatureToProd);

for(string feature: allFeature){
	system.debug(' feature : '+  feature);
	if(featureToProd.containskey(feature)){
			set<String> exisitngProductList = new set<String>();
			if(existingFeatureToProd.containsKey(feature) && existingFeatureToProd.get(feature) != Null){
				exisitngProductList = existingFeatureToProd.get(feature);
			}
			system.debug(' exisitngProductList: '+ exisitngProductList );
			set<String> productList = featureToProd.get(feature);
			system.debug('productList : '+ productList);
			for(String prod : productList){
				if(!exisitngProductList.contains(prod)){
					Product_Feature_Junction__c newJunction = new Product_Feature_Junction__c();
					newJunction.Product__c = productCodeToId.get(prod);
					newJunction.Product_Feature__c = feature;
					newJunction.PMDI_Created__c = true;
					if(pciSet.contains(prod)){
					   newJunction.isPCI__c = true;
					}
					newJunctionlist.add(newJunction);
				}
			}
		}
	system.debug(' newJunctionlist: '+ newJunctionlist );
}
system.debug('newJunctionlist : '+newJunctionlist );
database.insert(newJunctionlist);
	   }
		catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.GBOM_BATCH,'GBOM relation Batch');
		}			  
  } 
	global void finish(Database.BatchableContext BC) {
		try{		   
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.GBOM_BATCH,'GBOM relation Batch' );
		} 
	}
  
}