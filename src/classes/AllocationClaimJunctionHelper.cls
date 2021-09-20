public without sharing class AllocationClaimJunctionHelper {
	public static void beforeInsertOperation(List<Accrual_junction__c> newJunctionList){
		 
		try{
			Set<Id> allocationIdSet = new Set<Id>();
			for(Accrual_junction__c junction : newJunctionList){
				allocationIdSet.add(junction.Accrual__c);
			}
			Map<Id, Co_Op_Allocation__c> allocationMap = new Map<Id, Co_Op_Allocation__c>([SELECT Id, Fund_Id__c, A_A_VITAL_Allocation__c, PRM_A_A_VITAL__c, FN_Allocation__c, PRM_FN__c, ION_Allocation__c, PRM_ION__c,
																						   ION_NUAGE_Allocation__c, PRM_ION_NUAGE__c, ION_OPTICS_Allocation__c, PRM_ION_OPTICS__c, ION_Routing_Allocation__c, PRM_ION_Routing__c,
																						   MN_Allocation__c, PRM_MN__c, Partner_Name__c, Status__c FROM Co_Op_Allocation__c where Id in :allocationIdSet]);
			for(Accrual_junction__c junction : newJunctionList){
				junction.PRM_A_A_VITAL__c = (junction.Amount_deducted_from_accrual__c * allocationMap.get(junction.Accrual__c).PRM_A_A_VITAL__c / 100).setScale(2);
				junction.PRM_FN__c = (junction.Amount_deducted_from_accrual__c * allocationMap.get(junction.Accrual__c).PRM_FN__c / 100).setScale(2);
				junction.PRM_ION__c = (junction.Amount_deducted_from_accrual__c * allocationMap.get(junction.Accrual__c).PRM_ION__c / 100).setScale(2);
				junction.PRM_ION_NUAGE__c = (junction.Amount_deducted_from_accrual__c * allocationMap.get(junction.Accrual__c).PRM_ION_NUAGE__c / 100).setScale(2);
				junction.PRM_ION_OPTICS__c = (junction.Amount_deducted_from_accrual__c * allocationMap.get(junction.Accrual__c).PRM_ION_OPTICS__c / 100).setScale(2);
				junction.PRM_ION_Routing__c = (junction.Amount_deducted_from_accrual__c * allocationMap.get(junction.Accrual__c).PRM_ION_Routing__c / 100).setScale(2);
				junction.PRM_MN__c = (junction.Amount_deducted_from_accrual__c * allocationMap.get(junction.Accrual__c).PRM_MN__c / 100).setScale(2);
				
				System.debug('MSilva junction.PRM_FN__c --> ' + junction.PRM_FN__c);
				System.debug('MSilva junction.PRM_ION_OPTICS__c --> ' + junction.PRM_ION_OPTICS__c);
				
				allocationMap.get(junction.Accrual__c).A_A_VITAL_Allocation__c = (allocationMap.get(junction.Accrual__c).A_A_VITAL_Allocation__c != null ? allocationMap.get(junction.Accrual__c).A_A_VITAL_Allocation__c : 0) - junction.PRM_A_A_VITAL__c;
				allocationMap.get(junction.Accrual__c).FN_Allocation__c = (allocationMap.get(junction.Accrual__c).FN_Allocation__c != null ? allocationMap.get(junction.Accrual__c).FN_Allocation__c : 0) - junction.PRM_FN__c;
				allocationMap.get(junction.Accrual__c).ION_Allocation__c = (allocationMap.get(junction.Accrual__c).ION_Allocation__c != null ? allocationMap.get(junction.Accrual__c).ION_Allocation__c : 0) - junction.PRM_ION__c;
				allocationMap.get(junction.Accrual__c).ION_NUAGE_Allocation__c = (allocationMap.get(junction.Accrual__c).ION_NUAGE_Allocation__c != null ? allocationMap.get(junction.Accrual__c).ION_NUAGE_Allocation__c : 0) - junction.PRM_ION_NUAGE__c;
				allocationMap.get(junction.Accrual__c).ION_OPTICS_Allocation__c = (allocationMap.get(junction.Accrual__c).ION_OPTICS_Allocation__c != null ? allocationMap.get(junction.Accrual__c).ION_OPTICS_Allocation__c : 0) - junction.PRM_ION_OPTICS__c;
				allocationMap.get(junction.Accrual__c).ION_Routing_Allocation__c = (allocationMap.get(junction.Accrual__c).ION_Routing_Allocation__c != null ? allocationMap.get(junction.Accrual__c).ION_Routing_Allocation__c : 0) - junction.PRM_ION_Routing__c;
				allocationMap.get(junction.Accrual__c).MN_Allocation__c = (allocationMap.get(junction.Accrual__c).MN_Allocation__c != null ? allocationMap.get(junction.Accrual__c).MN_Allocation__c : 0) - junction.PRM_MN__c;
			}
			update allocationMap.values();
			
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.AllocationClaimJunctionHelper,PRMGlobalConstants.beforeInsertOperation);}
	}
	
	public static void beforeDeleteOperation(Map<Id, Accrual_junction__c> oldJunctionMap){
		try{
			Set<Id> allocationIdSet = new Set<Id>(); 
			for(Accrual_junction__c junction : oldJunctionMap.values()){
				allocationIdSet.add(junction.Accrual__c);
			}
			Map<Id, Co_Op_Allocation__c> allocationMap = new Map<Id, Co_Op_Allocation__c>([SELECT Id, Fund_Id__c, A_A_VITAL_Allocation__c, FN_Allocation__c, ION_Allocation__c,
																						   ION_NUAGE_Allocation__c, ION_OPTICS_Allocation__c, ION_Routing_Allocation__c,
																						   MN_Allocation__c, Partner_Name__c, Status__c FROM Co_Op_Allocation__c where Id in :allocationIdSet]);
			for(Accrual_junction__c junction : oldJunctionMap.values()){
				allocationMap.get(junction.Accrual__c).A_A_VITAL_Allocation__c = (allocationMap.get(junction.Accrual__c).A_A_VITAL_Allocation__c != null ? allocationMap.get(junction.Accrual__c).A_A_VITAL_Allocation__c : 0) +  junction.PRM_A_A_VITAL__c;
				allocationMap.get(junction.Accrual__c).FN_Allocation__c = (allocationMap.get(junction.Accrual__c).FN_Allocation__c != null ? allocationMap.get(junction.Accrual__c).FN_Allocation__c : 0) + junction.PRM_FN__c;
				allocationMap.get(junction.Accrual__c).ION_Allocation__c = (allocationMap.get(junction.Accrual__c).ION_Allocation__c != null ? allocationMap.get(junction.Accrual__c).ION_Allocation__c : 0) + junction.PRM_ION__c;
				allocationMap.get(junction.Accrual__c).ION_NUAGE_Allocation__c = (allocationMap.get(junction.Accrual__c).ION_NUAGE_Allocation__c != null ? allocationMap.get(junction.Accrual__c).ION_NUAGE_Allocation__c : 0) + junction.PRM_ION_NUAGE__c;
				allocationMap.get(junction.Accrual__c).ION_OPTICS_Allocation__c = (allocationMap.get(junction.Accrual__c).ION_OPTICS_Allocation__c != null ? allocationMap.get(junction.Accrual__c).ION_OPTICS_Allocation__c : 0) + junction.PRM_ION_OPTICS__c;
				allocationMap.get(junction.Accrual__c).ION_Routing_Allocation__c = (allocationMap.get(junction.Accrual__c).ION_Routing_Allocation__c != null ? allocationMap.get(junction.Accrual__c).ION_Routing_Allocation__c : 0) + junction.PRM_ION_Routing__c;
				allocationMap.get(junction.Accrual__c).MN_Allocation__c = (allocationMap.get(junction.Accrual__c).MN_Allocation__c != null ? allocationMap.get(junction.Accrual__c).MN_Allocation__c : 0) + junction.PRM_MN__c;
			}
			update allocationMap.values();
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.AllocationClaimJunctionHelper,PRMGlobalConstants.beforeDeleteOperation);}
		
	}
}