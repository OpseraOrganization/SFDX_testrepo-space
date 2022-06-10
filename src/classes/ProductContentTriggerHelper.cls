/**
Description: This Class is used as handler for ProductContentTriggerHandler class.
  
Created: 11 Feb 2021
 */

public with sharing class ProductContentTriggerHelper {
	
	public static void updateProductContentCount(List<NCP_Product_Content__c> newProdContent, List<NCP_Product_Content__c> oldProdContent){
		
		Set<Id> ids = new Set<Id>();
		List<Product2> prToUpdate = new List<Product2>();
		Map<Id,List<Id>> mapPC = new Map<Id,List<Id>>();
		
		if(newProdContent != null){
			for(NCP_Product_Content__c  pc: newProdContent)
				ids.add(pc.NCP_Product__c);
				//System.Debug('>>>> newProdContent >>> '+newProdContent);
		}if(oldProdContent !=null){
			for(NCP_Product_Content__c  pc: oldProdContent)
				ids.add(pc.NCP_Product__c);
				//System.Debug('>>>> oldProdContent >>> '+oldProdContent);
		}
		
		for(NCP_Product_Content__c p:[select Id,NCP_Product__c from NCP_Product_Content__c where NCP_Product__c IN:ids]){
			if(!mapPC.containsKey(p.NCP_Product__c)){
				mapPC.put(p.NCP_Product__c,new List<Id>());
				mapPC.get(p.NCP_Product__c).add(p.Id);
				//System.Debug('>>>> NCP_Product_Content__c >> if ');
			}else{
				mapPC.get(p.NCP_Product__c).add(p.Id);
				//System.Debug('>>>> NCP_Product_Content__c >> else');
			}
		}
		for(Product2 p:[select Id,NCP_Product_Content_Count__c from Product2 where id IN:ids]){
			if( mapPC.get(p.Id) == null){
				p.NCP_Product_Content_Count__c = 0;
				//System.Debug('>>>> Product2 If >> ');
			}else{
				p.NCP_Product_Content_Count__c  = mapPC.get(p.Id).size();
				//System.Debug('>>>> Product2 else >> ');
			}
			prToUpdate.add(p);
		}
		/**Update Product**/
		if(prToUpdate != null)
			update prToUpdate;
	}
}