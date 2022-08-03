public class ProductHierarchyTriggerHandler {

	public static void updateproductdata(List<Product_Hierarchy__c> newHierarchyList, map<Id,Product_Hierarchy__c> oldhiermap, map<Id,Product_Hierarchy__c> newhiermap){
		
		set<Id> updatedhierset = new set<Id>();
		for(Product_Hierarchy__c hierrec: newHierarchyList){
			
			if(hierrec.Business_Group_Code__c <> oldhiermap.get(hierrec.Id).Business_Group_Code__c || hierrec.Business_Unit_Code__c <> oldhiermap.get(hierrec.Id).Business_Unit_Code__c || hierrec.Portfolio_Package_Code__c <> oldhiermap.get(hierrec.Id).Portfolio_Package_Code__c || hierrec.Business_Line_Code__c <> oldhiermap.get(hierrec.Id).Business_Line_Code__c){
				updatedhierset.add(hierrec.Id);
			}
		}
		if(!updatedhierset.isempty()){
		   Batch_ProductUpdate batchable = new Batch_ProductUpdate(updatedhierset,newhiermap);
			Database.executeBatch(batchable,2000);
		   /* List<Product2> ProductsList = new List<Product2>();
			for(Product2 Prodrec: [select Id, Family, Business_Group__c,Product_Hierarchy__c from Product2 where Product_Hierarchy__c in :(updatedhierset)]){
				
				Prodrec.Business_Group__c = newhiermap.get(Prodrec.Product_Hierarchy__c).Business_Group_Code__c;
				Prodrec.Family = newhiermap.get(Prodrec.Product_Hierarchy__c).Business_Unit_Code__c;
				ProductsList.add(Prodrec);
			}
			
			List<database.SaveResult> Updateresult = database.update(ProductsList);
			system.debug('Updateresult: '+Updateresult);*/
		}
	}
}