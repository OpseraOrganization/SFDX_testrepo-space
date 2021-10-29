trigger POTrackerOptions_UpdateProductRef on BGA_PO_Tracker_Entry__c (before insert, before update) {

try{
	
		// create object inner class ExceptionRMUnames to check exception name e.g. Baseline only and Baseline
		ExceptionRMUnames rmuValueMappedNames = new ExceptionRMUnames();
		
		// declare following set to retrive data 
		Set<String> effectedRMUValuesSet 		= 	new Set<String>();
		Set<String> effectedRMUNameSet 			= 	new Set<String>();
		
		//set for affected(updated or inserted) platforms families
		Set<String> effectedPlatformFamilies 	= 	new Set<String>();
		
		//create parent Id and makemodel(platform family) map 
		Map<Id,String> mapParentMakeModel = new Map<Id,String>();
		
		// loop around PO Tracker entry records and create Set of RMU Name, RMU Values and Map of parent ids
		for(BGA_PO_Tracker_Entry__c rec : Trigger.new){
			
			system.debug('rec.RMU_Config_Detail_Name__c****************************'+rec.RMU_Config_Detail_Name__c);
			system.debug('rmuValueMappedNames*************'+rmuValueMappedNames);
			
			mapParentMakeModel.put(rec.BGA_Purchase_Order__c,null);
			String rmuDetailName = 
			rmuValueMappedNames.getGetRMUDetailName(rec.RMU_Config_Detail_Name__c);
			
			system.debug('rmuDetailName*************'+rmuDetailName);
			
			if(!effectedRMUValuesSet.contains(rmuDetailName))					
			effectedRMUValuesSet.add(rmuDetailName);
			
			if(!effectedRMUNameSet.contains(rec.RMU_Name__c))
			effectedRMUNameSet.add(rec.RMU_Name__c);
			
			system.debug('effectedRMUValuesSet*******'+effectedRMUValuesSet);
			
			system.debug('effectedRMUNameSet********'+effectedRMUNameSet);
			
		}
		
		List<BGA_PO_Tracker__c> listParentRecords = 
							[	select 	Id,
										Charts_Platform_Family__c
								from 	BGA_PO_Tracker__c
								where	Id in :mapParentMakeModel.keySet() 
							];
		
		// loop around PO tracker table records and for parent Ids Map with platform families
		for(BGA_PO_Tracker__c rec : listParentRecords){
			
			
			mapParentMakeModel.put(rec.Id,rec.Charts_Platform_Family__c);
			// create set for platform families to qu
			if(!effectedPlatformFamilies.contains(rec.Charts_Platform_Family__c))					
			effectedPlatformFamilies.add(rec.Charts_Platform_Family__c);	
			
			system.debug('effectedPlatformFamilies******'+effectedPlatformFamilies);
			
		}
							
		// query mapping table
		List<RMU_Program_Name__c> listMapping =
							[	select 	Platform_Group_Name__c,
										RMU_Detail_Name__c,
										Product__c,
										RMU_Name__c
								from 	RMU_Program_Name__c
								where  	RMU_Detail_Name__c 			in :effectedRMUValuesSet
								and     Platform_Group_Name__c 		in :effectedPlatformFamilies
								and     RMU_Name__c 				in :effectedRMUNameSet
							];

		
		Map<String,Id> mappingRecords = new Map<String,Id>();
		//Loop aroung mapping table and create map with relavent product Ids
		for(RMU_Program_Name__c mapRec : listMapping){
			system.debug('tttttttttttttttttttttttt'+mapRec.id);
			mappingRecords.put(
										mapRec.Platform_Group_Name__c
										+'|'+
										mapRec.RMU_Detail_Name__c
										+'|'+
										mapRec.RMU_Name__c
										,
										mapRec.Product__c
								);
								system.debug('mappingRecords*********************'+mappingRecords);
		}			
		
		//Again loop around po tracker entry and assign related primary keys
		for(BGA_PO_Tracker_Entry__c rec : Trigger.new){
					try{
					String key = mapParentMakeModel.get(rec.BGA_Purchase_Order__c)+'|'+rmuValueMappedNames.getGetRMUDetailName(rec.RMU_Config_Detail_Name__c)+'|'+rec.RMU_Name__c;
					String productId = null; 
					
					if(mappingRecords.containsKey(key))
					productId = mappingRecords.get(key);
				/*** ADDED For SR#395120 **/
					if(productId!=null && productId!='')
					   rec.Product__c = productId;
					}
					catch(Exception e){}
			}
	
}
catch(Exception e){
	throw e;
}

// class to handel exception RMU details names
class ExceptionRMUnames{
	
	Map<String,String> exceptionRMUNames = null;
	
	public ExceptionRMUnames(){
	 exceptionRMUNames = 
		(Map<String,String>)Json.deserialize(Label.RMUExceptionNamesMap, Map<String,String>.class);
		system.debug('exceptionRMUNames************'+exceptionRMUNames);
	}
	
	public String getGetRMUDetailName(String rmuDetailName){
		
		return exceptionRMUNames.containsKey(rmuDetailName)
											?
											exceptionRMUNames.get(rmuDetailName)
											:
											rmuDetailName;
	}	

}

}