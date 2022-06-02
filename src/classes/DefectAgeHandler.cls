/*******************************
Class Name: DefectAgeHandler
Created By: Accenture - December 2019
Description:  Class for new Defect age creation for each status change in Defect object
*******************************/
public class DefectAgeHandler {
	
	/*****************************
*Method Name: afterInsert
*Description: This method is used to create DefectAge record team on new defect creation
*Parameters:  Defect Map
*Created By: Accenture - December 2019
*******************************/		
	public static void afterInsert(Map<Id,Defect__c> newmap_defect){			   
		DefectAge.newDefectAge(newmap_defect);		
	}
	
	/*****************************
*Method Name: afterUpdate
*Description: This method is used to create DefectAge record team on defect status changes
*Parameters:  Defect Maps
*Created By: Accenture - December 2019
*******************************/	
	public static void afterUpdate(Map<Id,Defect__c> newmapdefect , Map<Id,Defect__c> oldmapDefect){
		system.debug('handler new map-->'+newmapdefect);
		system.debug('handler old map-->'+oldmapDefect);
		
		for(Defect__c def:newmapdefect.values()){
			if((!String.isEmpty(def.Status__c)&&!def.Status__c.equalsignorecase(oldmapDefect.get(def.Id).Status__c)) ||
			   (!String.isEmpty(def.Owning_Group__c)&&!def.Owning_Group__c.equalsignorecase(oldmapDefect.get(def.Id).Owning_Group__c)) ){
				   if(GlobalConstants.UPDATE_DEFECT_AGE==true)
					   DefectAge.upsertDefectAge(newmapdefect, oldmapDefect);
				   GlobalConstants.UPDATE_DEFECT_AGE=false;
			   }			
		}				
	}
	/*****************************
*Method Name: beforeInsert
*Description: This method is used to insert status start date field value on defect creation
*Parameters:  Defect List
*Created By: Accenture - December 2019
*******************************/	 
	public static void beforeInsert(List<Defect__c> newDefectList){		
		system.debug('beforeNewDefectList-->'+newDefectList);
		DefectAge.StartDatebeforeInsert(newDefectList);
	}
	
	/*****************************
*Method Name: beforeUpdate
*Description: This method is used to Update status start date field value on defect status changes
*Parameters:  Defect List
*Created By: Accenture - December 2019
*******************************/ 
	public static void beforeUpdate(Map<Id,Defect__c> before_newmapdefect , Map<Id,Defect__c> before_oldmapdefect){	   
		for(Defect__c def_bef:before_newmapdefect.values()){
			if((!String.isEmpty(def_bef.Status__c)&&!def_bef.Status__c.equalsignorecase(before_oldmapDefect.get(def_bef.Id).Status__c)) ||
			   (!String.isEmpty(def_bef.Owning_Group__c)&&!def_bef.Owning_Group__c.equalsignorecase(before_oldmapDefect.get(def_bef.Id).Owning_Group__c)) ){
				   DefectAge.StartdatebeforeUpdate(before_newmapdefect,before_oldmapdefect);
				   
			   }			
		}
		
	}
	
}