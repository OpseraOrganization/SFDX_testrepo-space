/****************************************
* Class Name : CH_CA_WorkgroupInstructionsTriggerHelper
* Created Date: 03 Dec 2019
* Created By : TCS
* Last Modified by: TCS
* Last Modified Date: 
* Description : Contains common business logic
*****************************************/

public class CH_CA_WorkgroupInstructionsTriggerHelper {
	
	Public static void duplicateworkgroupInstructions(List < CH_WorkgroupInstructions__c > newworkgroupList) {
		set<string> getAssignmentTypes = new set<string>();
		set<Id> getworkgroupId = new set<Id>();
		set<string> getAssignmentValue = new set<string>();
		set<string> oldSeverityValues = new set<string>();
		set<string> newSeverityValues = new set<string>();
		Set<String> commonSeverityValues = new Set<String>();
		Boolean isKBRecordType=false;
		for(CH_WorkgroupInstructions__c newwrkgpInstrtions : newworkgroupList){
			getAssignmentTypes.add(newwrkgpInstrtions.CH_AssignmentType__c);
			getworkgroupId.add(newwrkgpInstrtions.CH_Workgroup__c);
		}
		Id getKbRecordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByName().get('Workgroup').getRecordTypeId();
		system.debug('CH_KB_Workgroup'+getKbRecordTypeId);
		
		List<CH_Workgroup__c> validatewrkgprecordType=[SELECT Id, RecordtypeId from CH_Workgroup__c where Id in :getworkgroupId AND RecordtypeId=:getKbRecordTypeId];
		
		if(validatewrkgprecordType.size()>0) {
			isKBRecordType=true;
		}
		
		
		for(CH_WorkgroupInstructions__c getWrkgrpInstructions : [SELECT Id, CH_AssignmentType__c, CH_Severity__c,CH_Workgroup__c FROM CH_WorkgroupInstructions__c WHERE CH_AssignmentType__c IN: getAssignmentTypes AND CH_Active__c=true AND CH_Workgroup__c IN :getworkgroupId]){
			getAssignmentValue.add(getWrkgrpInstructions.CH_AssignmentType__c);
			
			if(getWrkgrpInstructions.CH_Severity__c!=Null){
				oldSeverityValues.addAll(getWrkgrpInstructions.CH_Severity__c.split(';'));
			}
			
		}
		
		
		for(CH_WorkgroupInstructions__c newwrkgpInstruction : newworkgroupList){
			if(isKBRecordType == true){
				newwrkgpInstruction.addError('The selected Workgroup isn’t a Case Handling Workgroup');
			}
			else{
				if(newwrkgpInstruction.CH_Severity__c!=null){
					newSeverityValues.addAll(newwrkgpInstruction.CH_Severity__c.split(';'));
					commonSeverityValues.addall(oldSeverityValues);
					commonSeverityValues.retainAll( newSeverityValues);
					if(getAssignmentValue.contains(newwrkgpInstruction.CH_AssignmentType__c) && commonSeverityValues.size()>0 && newwrkgpInstruction.CH_Active__c==true){
						newwrkgpInstruction.addError('Active Assignment Instruction is already activated for this severity for this Workgroup');
					}
				}
				else{
					if(getAssignmentValue.contains(newwrkgpInstruction.CH_AssignmentType__c) && newwrkgpInstruction.CH_AssignmentType__c=='Passive'  && newwrkgpInstruction.CH_Active__c==true){
						newwrkgpInstruction.addError(' Passive Assignment Instruction is already activated for this Workgroup ');
					}
					if(getAssignmentValue.contains(newwrkgpInstruction.CH_AssignmentType__c) && newwrkgpInstruction.CH_AssignmentType__c=='Case Team'  && newwrkgpInstruction.CH_Active__c==true){
						newwrkgpInstruction.addError('Case Team Member Engagement Instruction is already activated for this Workgroup ');
						
					}
				}
			}
		}
	}
	
	Public static void ValidateworkInstructions(List < CH_WorkgroupInstructions__c > newwrkgroupList,Map < Id, CH_WorkgroupInstructions__c >oldworkgroupInstructionsMap) {
		Set<Id> getworkgroupId = new Set<Id>();
		Set<string> getAssignmentTypes = new Set<string>();
		Set<string> oldSeverityValues = new Set<string>();
		Set<string> newSeverityValues = new Set<string>();
		Set<String> commonSeverityValues = new Set<String>();
		
		List<CH_WorkgroupInstructions__c> WorkgroupInstructions =new  List<CH_WorkgroupInstructions__c>();
		for(CH_WorkgroupInstructions__c workgpId:newwrkgroupList){
			getworkgroupId.add(workgpId.CH_Workgroup__c);
			getAssignmentTypes.add(workgpId.CH_AssignmentType__c);
			if(workgpId.CH_Severity__c!=Null){
				oldSeverityValues.addAll(workgpId.CH_Severity__c.split(';'));
			}
		}
		
		
		WorkgroupInstructions=[SELECT Id, CH_AssignmentType__c, CH_Severity__c,CH_Active__c,
							   CH_Workgroup__r.name FROM CH_WorkgroupInstructions__c 
							   WHERE  CH_Active__c=true
							   AND CH_Workgroup__c IN :getworkgroupId AND CH_AssignmentType__c IN :getAssignmentTypes];
		
		for(CH_WorkgroupInstructions__c getWrkgrpInstructions :WorkgroupInstructions){
			if(getWrkgrpInstructions.CH_Severity__c!=Null){
				CH_WorkgroupInstructions__c getoldWrkgpId=  oldworkgroupInstructionsMap.get(getWrkgrpInstructions.Id);
				if(getoldWrkgpId == null){
					newSeverityValues.addAll(getWrkgrpInstructions.CH_Severity__c.split(';'));
				}
			}
			
		}
		
		if(WorkgroupInstructions.size()>0 ){
			for(CH_WorkgroupInstructions__c wrkgroupListRec: newwrkgroupList)  {
				CH_WorkgroupInstructions__c getoldWrkgpSeverity=  oldworkgroupInstructionsMap.get(wrkgroupListRec.Id);
				if(wrkgroupListRec.CH_Severity__c!=null){
					commonSeverityValues.addall(oldSeverityValues);
					commonSeverityValues.retainAll( newSeverityValues);
					if(commonSeverityValues.size()>0 && wrkgroupListRec.CH_Active__c==true && getoldWrkgpSeverity.CH_Severity__c !=wrkgroupListRec.CH_Severity__c){
						wrkgroupListRec.addError('Active Assignment Instruction is already activated for this severity for this Workgroup');
					}
				}
				else{
					if( getoldWrkgpSeverity.CH_AssignmentType__c !=wrkgroupListRec.CH_AssignmentType__c || getoldWrkgpSeverity.CH_Active__c !=wrkgroupListRec.CH_Active__c){
						if(wrkgroupListRec.CH_AssignmentType__c=='Passive' && wrkgroupListRec.CH_Active__c==true ){
							wrkgroupListRec.addError('Passive Assignment Instruction is already activated for this Workgroup ');
						}
						if(wrkgroupListRec.CH_AssignmentType__c=='Case Team' && wrkgroupListRec.CH_Active__c==true){
							wrkgroupListRec.addError('Case Team Member Engagement Instruction is already activated for this Workgroup ');
						}
						
					}
					
				}
			}
		}
	}
}