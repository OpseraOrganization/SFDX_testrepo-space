/**
* @description: 
*@Author	   Rajeev Ketha <rajeev.ketha.ext@nokia.com>
* @Group	   
* @return: void
*/ 

public without sharing class CLM_AgreementClauseTriggerHelper {
	
	public static void afterInsert(list<Apttus__Agreement_Clause__c> clauseLst){
		Set<string> primoduClauseIds = new Set<string>();
		Set<string> modiClauseIds = new Set<string>();
		for(Apttus__Agreement_Clause__c claus: clauseLst){
			
			if(claus.Apttus__Action__c == 'Modified' && string.isNotBlank(claus.Apttus__PrimordialVersionId__c)){
				primoduClauseIds.add(claus.Apttus__PrimordialVersionId__c);
				modiClauseIds.add(claus.Id);
			}
		}
		
		if(primoduClauseIds.size()>0){
			
			Map<Id,Apttus__Agreement_Clause__c> primodClausMap = new Map<Id,Apttus__Agreement_Clause__c>([SELECT Id,Apttus__Action__c,Apttus__PrimordialVersionId__c 
																										  FROM Apttus__Agreement_Clause__c 
																										  WHERE Apttus__PrimordialVersionId__c  IN:primoduClauseIds
																										  AND Id Not IN:modiClauseIds]);
			
			
			List<Apttus__Agreement_Clause__c> updateClauslst = new List<Apttus__Agreement_Clause__c>();
			if(primodClausMap.size() == 0){
				Apttus__Agreement_Clause__c agr = new Apttus__Agreement_Clause__c();
				for(Apttus__Agreement_Clause__c claus: clauseLst){
					if(claus.Apttus__Action__c == 'Modified' && string.isNotBlank(claus.Apttus__PrimordialVersionId__c)){
						agr = new Apttus__Agreement_Clause__c(Id=claus.Apttus__PrimordialVersionId__c,CLM_Pre_Negotiated_Clause_Text__c = claus.Apttus__PrevText__c);
						updateClauslst.add(agr);
						
					}
				}
			}
			if(!updateClauslst.isEmpty()){
				update updateClauslst;
			}
		}
	} 
	public static void updateL2DRelevantFields(list<Apttus__Agreement_Clause__c> clauseLst){
		Set<string> ltdcategorySet = new Set<string> (); 
		Set<string> categorySet = new Set<string> ();
		Set<string> subcategorySet = new Set<string> ();
		Set<string> agrmntIds = new Set<string>();
		for(Apttus__Agreement_Clause__c rec:clauseLst){
			if(rec.Apttus__Action__c == 'Inserted' 
			   && string.isNotBlank(rec.Apttus__Category__c) && string.isNotBlank(rec.Apttus__Subcategory__c)){
				   categorySet.add(rec.Apttus__Category__c);
				   subcategorySet.add(rec.Apttus__Subcategory__c);
				   agrmntIds.add(rec.Apttus__Agreement__c);
			   }
		}
		Map<Id,Apttus__APTS_Agreement__c> agrmntMap = new Map<Id,Apttus__APTS_Agreement__c>();
		if(agrmntIds.size()>0){
			agrmntMap = new Map<Id,Apttus__APTS_Agreement__c>([SELECT Id,Apttus__Status_Category__c,Apttus__Status__c 
															   FROM Apttus__APTS_Agreement__c
															   WHERE Id IN:agrmntIds]);
		}
		
		List<CLM_L2D_Trigger__c> lstL2Dtrg = [select id,CLM_Subcategory__c,CLM_Category__c 
											  FROM CLM_L2D_Trigger__c 
											  WHERE CLM_Category__c in:categorySet 
											  OR CLM_Subcategory__c in :subcategorySet];
		for(CLM_L2D_Trigger__c ldTrgr :lstL2Dtrg){
			ltdcategorySet.add((ldTrgr.CLM_Category__c+ldTrgr.CLM_Subcategory__c).toLowerCase());
		}
		
		Apttus__APTS_Agreement__c recAgrmnt = new Apttus__APTS_Agreement__c();
		for(Apttus__Agreement_Clause__c aptsCls : clauseLst){
			if(aptsCls.Apttus__Action__c == 'Inserted' 
			   && string.isNotBlank(aptsCls.Apttus__Category__c) 
			   && string.isNotBlank(aptsCls.Apttus__Subcategory__c)){ 
				   if(agrmntMap.containsKey(aptsCls.Apttus__Agreement__c)){
					   recAgrmnt = agrmntMap.get(aptsCls.Apttus__Agreement__c);
					   if(recAgrmnt.Apttus__Status__c == 'Fully Signed' || recAgrmnt.Apttus__Status__c == 'Activated'){
						   aptsCls.Apttus__Status__c = 'Signed';
					   }
				   }
				   if (ltdcategorySet.contains((aptsCls.Apttus__Category__c+aptsCls.Apttus__Subcategory__c).toLowerCase())){
					   if(aptsCls.Apttus__Status__c == 'Signed'){
						   aptsCls.CLM_L2D_Relevant__c=''; 
						   aptsCls.CLM_L2D_RelevantSignedClause__c=True; 
					   }else if(aptsCls.Apttus__Status__c != 'Signed'){
						   aptsCls.CLM_L2D_Relevant__c='Yes'; 
						   aptsCls.CLM_L2D_RelevantSignedClause__c=False;
					   }
				   }else{
					   if(aptsCls.Apttus__Status__c == 'Signed'){
						   aptsCls.CLM_L2D_Relevant__c=''; 
						   aptsCls.CLM_L2D_RelevantSignedClause__c=false; 
					   }else if(aptsCls.Apttus__Status__c != 'Signed'){
						   aptsCls.CLM_L2D_Relevant__c='No'; 
						   aptsCls.CLM_L2D_RelevantSignedClause__c=False;
					   }
				   }
			   }else{
				   aptsCls.CLM_L2D_Relevant__c='No'; 
				   aptsCls.CLM_L2D_RelevantSignedClause__c=false; 
			   }
		}
	}
}