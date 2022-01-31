trigger UpdateClosedDate on Defect__c (before insert,before update,after insert,after update) {
	
	List<Defect__c> oldDef = new List<Defect__c>((Defect__c[])Trigger.old);
	List<Defect__c> newDef = new List<Defect__c>((Defect__c[])Trigger.new);  
	
	try{
		if(Trigger.isBefore&&(Trigger.isInsert||Trigger.isUpdate)){
			if(Trigger.isInsert){
				system.debug('beforeInsert-->'+Trigger.isInsert);
				DefectAgeHandler.beforeInsert(trigger.new);				
			}  
			if(trigger.isUpdate){
				system.debug('beforeUpdate-->'+Trigger.isUpdate);
				DefectAgeHandler.beforeUpdate(trigger.newmap,trigger.oldmap);
				
				
				String  CurStat = newDef.get(0).Current_status__c;
				String  PrevStat = oldDef.get(0).Current_status__c;
				
				if(CurStat.length()>=6){
					CurStat = newDef.get(0).Current_status__c.substring(0,6);
				}
				
				if(PrevStat.length()>=6){
					PrevStat = oldDef.get(0).Current_status__c.substring(0,6);
				}
				
				if(CurStat.equalsIgnoreCase('CLOSED')){
					if(!PrevStat.equalsIgnoreCase('CLOSED')){
						newDef[0].Closed_Date__c = datetime.now();
					}
				}
				
				if(!CurStat.equalsIgnoreCase('CLOSED') & PrevStat.equalsIgnoreCase('CLOSED')){
					newDef[0].Closed_Date__c = null;
				}
			}
		}
		
	   
		if (Trigger.isAfter&&(Trigger.isInsert||Trigger.isUpdate)){				   
			system.debug('triggerstatus'+Trigger.isInsert);
			system.debug('triggerstatus update'+Trigger.isUpdate);
			
			if(Trigger.isInsert){						   
				DefectAgeHandler.afterInsert(trigger.newmap);									 
			}
			if(Trigger.isUpdate){
				system.debug('Isupdate trigger called for defect afe');							 
				DefectAgeHandler.afterUpdate(trigger.newmap,trigger.oldmap);
				
			}
		}
	}
	catch(NullPointerException e){
	}
}