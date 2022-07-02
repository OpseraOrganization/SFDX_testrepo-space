global class ResetOIFProgramFlagJunction implements Database.Batchable<sObject>{
	
	 global Database.QueryLocator start(Database.BatchableContext bc){
		return Database.getQueryLocator('select id,(select id,Program_Flag__c from Program_Flags__r) from Opportunity');
	}
	global void execute(Database.BatchableContext bc,List<Opportunity> scope){
		Map<ID,Set<ID>> opp2pf = new Map<ID,Set<ID>>();
		Set<ID> pfids = new Set<ID>();
		List<OptyProgramFlagJunction__c> needDelete = new List<OptyProgramFlagJunction__c>();
		for(Opportunity opp: scope){
			opp2pf.put(opp.id,new Set<ID>());
			for(OptyProgramFlagJunction__c opfj:opp.Program_Flags__r){
				if(opfj.Program_Flag__c == null){
					needDelete.add(opfj);
				}else if(opp2pf.get(opp.id).contains(opfj.Program_Flag__c)){
					needDelete.add(opfj);
				}else{
				   pfids=opp2pf.get(opp.id);
				   pfids.add(opfj.Program_Flag__c);
				   opp2pf.put(opp.id,pfids);
				}
			}
		}
		delete needDelete;
	}
	global void finish(Database.BatchableContext bc){
		
	}

}