/*******************************
Class Name: DefectAge
Created By: Accenture - December 2019
Description:  Class for new Defect age creation for each status change in Defect object
*******************************/
public class DefectAge {
	public static List<Defect_Age__c> DefectAge_List = new List<Defect_Age__c>();
	
	/*****************************
*Method Name: newDefectAge
*Description: This method is used to create DefectAge record team on new defect creation
*Parameters:  Defect Map
*Created By: Accenture - December 2019
*******************************/	
	public static void newDefectAge(Map<Id,Defect__c> newMap){
		system.debug('callaed for fresh defect age creation wth new map----'+newMap);
		
		try{
			for(Defect__c defect:newMap.values()){
				Defect_Age__c defectage = new Defect_Age__c();
				defectage.Defect__c=defect.id;
				defectage.Status__c=defect.Status__c;
				defectage.Start_Date__c=system.now(); 
				defectage.Owning_Group__c=defect.Owning_Group__c;
				DefectAge_List.add(defectage);
				
			}
			if(!DefectAge_List.isempty())
				database.insert(DefectAge_List,false); 
			
		}		
		catch(exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.DEFECT_AGE, GlobalConstants.NEW_DEFECT_AGE);			
		}
	}
	
	
	/*****************************
*Method Name: upsertDefectAge
*Description: This method is used to create DefectAge record team on defect status changes
*Parameters:  Defect Maps
*Created By: Accenture - December 2019
*******************************/	  
	public static void upsertDefectAge(Map<ID,Defect__c> upsert_newmap,Map<Id,Defect__c> upsert_oldmap){
		system.debug('called update defect age:'); 
		system.debug('upsert new map'+upsert_newmap);
		system.debug('upsert old map'+upsert_oldmap);
		
		Map<Id,Defect__c> Defect_newmap = new Map<Id,Defect__c>();
		list<Defect_Age__c> updDefageEndDate = new list<Defect_Age__c>();
		list<Defect_Age__c> newDefagelist = new list<Defect_Age__c>();	   
		Map<Id,String> mapdefect_age = new map<id,String>();
		
		try{
			if(!upsert_oldmap.isempty()){
				for(Defect_Age__c defect_age:[Select id,Defect__c,Status__c,Start_Date__c,End_Date__c,Owning_Group__c from Defect_Age__c 
											  where Defect__c IN:upsert_oldmap.keyset() AND End_Date__c = null]){
												  mapdefect_age.put(defect_age.Defect__c,defect_age.Status__c);  
												  
												  defect_age.End_Date__c=system.now();											  
												  //defect_age.Status__c=mapdefect_age.get(defect_age.Defect__c);
												  updDefageEndDate.add(defect_age);											  
											  }		   
				system.debug('End date update record-->'+updDefageEndDate);
				if(!updDefageEndDate.isempty()){
					database.update(updDefageEndDate,false);
				}						
			}
			
			for(Defect__c def :upsert_newmap.values()){
				system.debug('comparingnew map dsefect'+def.Status__c);
				system.debug('compare old map dsefect'+upsert_oldmap.get(def.Id).Status__c);
				if((!String.isEmpty(def.Status__c)&&!def.Status__c.equalsignorecase(upsert_oldmap.get(def.Id).Status__c)) || 
				   (!String.isEmpty(def.Owning_Group__c)&&!def.Owning_Group__c.equalsignorecase(upsert_oldmap.get(def.Id).Owning_Group__c)) ){
					   Defect_newmap.put(def.id,def);
				   }
			}
			//if(!Defect_newmap.isempty())
			//newDefectAge(Defect_newmap);		
			if( GlobalConstants.CREATE_DEFECT_AGE=true){
				for(Id keys:Defect_newmap.keyset()){
					Defect_Age__c newdefage = new Defect_Age__c();
					newdefage.Defect__c=keys;
					newdefage.Start_Date__c=system.now();
					newdefage.Status__c=Defect_newmap.get(keys).Status__c;
					newdefage.Owning_Group__c=Defect_newmap.get(keys).Owning_Group__c;
					newDefagelist.add(newdefage);
				}
				
				if(!newDefagelist.isempty())
					database.insert(newDefagelist,false);
				
				GlobalConstants.CREATE_DEFECT_AGE=false;
			}
			
		}catch(exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.DEFECT_AGE, GlobalConstants.UPSERT_DEFECT_AGE);			
		}
		
	}
	
	/*****************************
*Method Name: StartDatebeforeInsert
*Description: This method is used to insert status start date field value on defect creation
*Parameters:  Defect List
*Created By: Accenture - December 2019
*******************************/	  
	public static void StartDatebeforeInsert(list<Defect__c> updateDefectStardatelist){
		try{
			for(Defect__c defect :updateDefectStardatelist){			
				defect.Status_Start_Date__c=system.now();						
			}	 
		}catch(exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.DEFECT_AGE, GlobalConstants.START_DATE_BEFORE_INSERT);			
		}
	}
	
	/*****************************
*Method Name: StartdatebeforeUpdate
*Description: This method is used to Update status start date field value on defect status changes
*Parameters:  Defect List
*Created By: Accenture - December 2019
*******************************/	 
	public static void StartdatebeforeUpdate(Map<ID,Defect__c> beforeUpd_newmap,Map<Id,Defect__c> beforeUpd_oldmap){
		list<Defect__c> befUpdStartDate = new list<Defect__c>();
		map<id,Defect__c> newdefageforGroupUpd = new map<id,Defect__c>();
	   
		try{
			for(Defect__c def_before :beforeUpd_newmap.values()){				   
				def_before.Status_Start_Date__c=system.now();
				befUpdStartDate.add(def_before);			
			}  
		}catch(exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.DEFECT_AGE, GlobalConstants.START_DATE_BEFORE_UPDATE);			
		}
		
	}
}