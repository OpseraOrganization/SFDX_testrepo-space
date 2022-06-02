public without sharing class CoOpTransferHelper{
	public static void handleNullValues(List<Co_op_Allocation_Transfer__c> newTransferList){
		for(Co_op_Allocation_Transfer__c transfer : newTransferList){
			transfer.Co_op_Allocation_Transferred_Amount__c = (transfer.Co_op_Allocation_Transferred_Amount__c == null ? 0 : transfer.Co_op_Allocation_Transferred_Amount__c);
			transfer.PRM_A_A_Vital_Amount__c = (transfer.PRM_A_A_Vital_Amount__c == null ? 0 : transfer.PRM_A_A_Vital_Amount__c);
			transfer.PRM_FN_Amount__c = (transfer.PRM_FN_Amount__c == null ? 0 : transfer.PRM_FN_Amount__c);
			transfer.PRM_ION_Amount__c = (transfer.PRM_ION_Amount__c == null ? 0 : transfer.PRM_ION_Amount__c);
			transfer.PRM_ION_NUAGE_Amount__c = (transfer.PRM_ION_NUAGE_Amount__c == null ? 0 : transfer.PRM_ION_NUAGE_Amount__c);
			transfer.PRM_ION_OPTICS_Amount__c = (transfer.PRM_ION_OPTICS_Amount__c == null ? 0 : transfer.PRM_ION_OPTICS_Amount__c);
			transfer.PRM_ION_Routing_Amount__c = (transfer.PRM_ION_Routing_Amount__c == null ? 0 : transfer.PRM_ION_Routing_Amount__c);
			transfer.PRM_MN_Amount__c = (transfer.PRM_MN_Amount__c == null ? 0 : transfer.PRM_MN_Amount__c);
		}
	}
	public static void handleTransfers(List<Co_op_Allocation_Transfer__c> newTransferList){
		Set<Id> allocationIds = new Set<Id>();
		for(Co_op_Allocation_Transfer__c transfer : newTransferList){
			allocationIds.add(transfer.Transfer_To_Co_op__c);
			allocationIds.add(transfer.Transfer_From_Co_op__c);
		}
		Map<Id,Co_op_Allocation__c> allocationMap = new Map<Id,Co_op_Allocation__c>([Select Id, A_A_VITAL_Allocation__c, PRM_A_A_VITAL_Transfers_In__c, PRM_A_A_VITAL_Transfers_Out__c, 
																					 FN_Allocation__c, PRM_FN_Transfers_In__c, PRM_FN_Transfers_Out__c, ION_Allocation__c, PRM_ION_Transfers_In__c,
																					 PRM_ION_Transfers_Out__c, ION_NUAGE_Allocation__c, PRM_ION_NUAGE_Transfers_In__c, PRM_ION_NUAGE_Transfers_Out__c,
																					 ION_Optics_Allocation__c, PRM_ION_OPTICS_Transfers_In__c, PRM_ION_OPTICS_Transfers_Out__c, ION_Routing_Allocation__c,
																					 PRM_ION_Routing_Transfers_In__c, PRM_ION_Routing_Transfers_Out__c, MN_Allocation__c, PRM_MN_Transfers_In__c,
																					 PRM_MN_Transfers_Out__c, Transfers_in_Amount__c, Transfers_out_Amount__c from Co_op_Allocation__c where Id in :allocationIds]);
		
		for(Co_op_Allocation_Transfer__c transfer : newTransferList){
			allocationMap.get(transfer.Transfer_To_Co_op__c).Transfers_in_Amount__c = (allocationMap.get(transfer.Transfer_To_Co_op__c).Transfers_in_Amount__c == null ? 0 : allocationMap.get(transfer.Transfer_To_Co_op__c).Transfers_in_Amount__c) + transfer.Co_op_Allocation_Transferred_Amount__c;
			allocationMap.get(transfer.Transfer_From_Co_op__c).Transfers_out_Amount__c = (allocationMap.get(transfer.Transfer_From_Co_op__c).Transfers_out_Amount__c == null ? 0 : allocationMap.get(transfer.Transfer_From_Co_op__c).Transfers_out_Amount__c) + transfer.Co_op_Allocation_Transferred_Amount__c;
			//BG calc
			allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_A_A_VITAL_Transfers_In__c = (allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_A_A_VITAL_Transfers_In__c == null ? 0 : allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_A_A_VITAL_Transfers_In__c) + transfer.PRM_A_A_Vital_Amount__c;
			allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_A_A_VITAL_Transfers_Out__c = (allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_A_A_VITAL_Transfers_Out__c == null ? 0 : allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_A_A_VITAL_Transfers_Out__c) + transfer.PRM_A_A_Vital_Amount__c;
			allocationMap.get(transfer.Transfer_To_Co_op__c).A_A_VITAL_Allocation__c = (allocationMap.get(transfer.Transfer_To_Co_op__c).A_A_VITAL_Allocation__c == null ? 0 : allocationMap.get(transfer.Transfer_To_Co_op__c).A_A_VITAL_Allocation__c) + transfer.PRM_A_A_Vital_Amount__c;
			allocationMap.get(transfer.Transfer_From_Co_op__c).A_A_VITAL_Allocation__c = (allocationMap.get(transfer.Transfer_From_Co_op__c).A_A_VITAL_Allocation__c == null ? 0 : allocationMap.get(transfer.Transfer_From_Co_op__c).A_A_VITAL_Allocation__c) - transfer.PRM_A_A_Vital_Amount__c;
			
			allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_FN_Transfers_In__c = (allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_FN_Transfers_In__c == null ? 0 : allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_FN_Transfers_In__c) + transfer.PRM_FN_Amount__c;
			allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_FN_Transfers_Out__c = (allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_FN_Transfers_Out__c == null ? 0 : allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_FN_Transfers_Out__c) + transfer.PRM_FN_Amount__c;
			allocationMap.get(transfer.Transfer_To_Co_op__c).FN_Allocation__c = (allocationMap.get(transfer.Transfer_To_Co_op__c).FN_Allocation__c == null ? 0 : allocationMap.get(transfer.Transfer_To_Co_op__c).FN_Allocation__c) + transfer.PRM_FN_Amount__c;
			allocationMap.get(transfer.Transfer_From_Co_op__c).FN_Allocation__c = (allocationMap.get(transfer.Transfer_From_Co_op__c).FN_Allocation__c == null ? 0 : allocationMap.get(transfer.Transfer_From_Co_op__c).FN_Allocation__c) - transfer.PRM_FN_Amount__c;
			
			allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_ION_Transfers_In__c = (allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_ION_Transfers_In__c == null ? 0 : allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_ION_Transfers_In__c) + transfer.PRM_ION_Amount__c;
			allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_ION_Transfers_Out__c = (allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_ION_Transfers_Out__c == null ? 0 : allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_ION_Transfers_Out__c) + transfer.PRM_ION_Amount__c;
			allocationMap.get(transfer.Transfer_To_Co_op__c).ION_Allocation__c = (allocationMap.get(transfer.Transfer_To_Co_op__c).ION_Allocation__c == null ? 0 : allocationMap.get(transfer.Transfer_To_Co_op__c).ION_Allocation__c) + transfer.PRM_ION_Amount__c;
			allocationMap.get(transfer.Transfer_From_Co_op__c).ION_Allocation__c = (allocationMap.get(transfer.Transfer_From_Co_op__c).ION_Allocation__c == null ? 0 : allocationMap.get(transfer.Transfer_From_Co_op__c).ION_Allocation__c) - transfer.PRM_ION_Amount__c;
			
			allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_ION_NUAGE_Transfers_In__c = (allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_ION_NUAGE_Transfers_In__c == null ? 0 : allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_ION_NUAGE_Transfers_In__c) + transfer.PRM_ION_NUAGE_Amount__c;
			allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_ION_NUAGE_Transfers_Out__c = (allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_ION_NUAGE_Transfers_Out__c == null ? 0 : allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_ION_NUAGE_Transfers_Out__c) + transfer.PRM_ION_NUAGE_Amount__c;
			allocationMap.get(transfer.Transfer_To_Co_op__c).ION_NUAGE_Allocation__c = (allocationMap.get(transfer.Transfer_To_Co_op__c).ION_NUAGE_Allocation__c == null ? 0 : allocationMap.get(transfer.Transfer_To_Co_op__c).ION_NUAGE_Allocation__c) + transfer.PRM_ION_NUAGE_Amount__c;
			allocationMap.get(transfer.Transfer_From_Co_op__c).ION_NUAGE_Allocation__c = (allocationMap.get(transfer.Transfer_From_Co_op__c).ION_NUAGE_Allocation__c == null ? 0 : allocationMap.get(transfer.Transfer_From_Co_op__c).ION_NUAGE_Allocation__c) - transfer.PRM_ION_NUAGE_Amount__c;
			
			allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_ION_OPTICS_Transfers_In__c = (allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_ION_OPTICS_Transfers_In__c == null ? 0 : allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_ION_OPTICS_Transfers_In__c) + transfer.PRM_ION_OPTICS_Amount__c;
			allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_ION_OPTICS_Transfers_Out__c = (allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_ION_OPTICS_Transfers_Out__c == null ? 0 : allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_ION_OPTICS_Transfers_Out__c) + transfer.PRM_ION_OPTICS_Amount__c;
			allocationMap.get(transfer.Transfer_To_Co_op__c).ION_Optics_Allocation__c = (allocationMap.get(transfer.Transfer_To_Co_op__c).ION_Optics_Allocation__c == null ? 0 : allocationMap.get(transfer.Transfer_To_Co_op__c).ION_Optics_Allocation__c) + transfer.PRM_ION_OPTICS_Amount__c;
			allocationMap.get(transfer.Transfer_From_Co_op__c).ION_Optics_Allocation__c = (allocationMap.get(transfer.Transfer_From_Co_op__c).ION_Optics_Allocation__c == null ? 0 : allocationMap.get(transfer.Transfer_From_Co_op__c).ION_Optics_Allocation__c) - transfer.PRM_ION_OPTICS_Amount__c;
			
			allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_ION_Routing_Transfers_In__c = (allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_ION_Routing_Transfers_In__c == null ? 0 : allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_ION_Routing_Transfers_In__c) + transfer.PRM_ION_Routing_Amount__c;
			allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_ION_Routing_Transfers_Out__c = (allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_ION_Routing_Transfers_Out__c == null ? 0 : allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_ION_Routing_Transfers_Out__c) + transfer.PRM_ION_Routing_Amount__c;
			allocationMap.get(transfer.Transfer_To_Co_op__c).ION_Routing_Allocation__c = (allocationMap.get(transfer.Transfer_To_Co_op__c).ION_Routing_Allocation__c == null ? 0 : allocationMap.get(transfer.Transfer_To_Co_op__c).ION_Routing_Allocation__c) + transfer.PRM_ION_Routing_Amount__c;
			allocationMap.get(transfer.Transfer_From_Co_op__c).ION_Routing_Allocation__c = (allocationMap.get(transfer.Transfer_From_Co_op__c).ION_Routing_Allocation__c == null ? 0 : allocationMap.get(transfer.Transfer_From_Co_op__c).ION_Routing_Allocation__c) - transfer.PRM_ION_Routing_Amount__c;
			
			allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_MN_Transfers_In__c = (allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_MN_Transfers_In__c == null ? 0 : allocationMap.get(transfer.Transfer_To_Co_op__c).PRM_MN_Transfers_In__c) + transfer.PRM_MN_Amount__c;
			allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_MN_Transfers_Out__c = (allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_MN_Transfers_Out__c == null ? 0 : allocationMap.get(transfer.Transfer_From_Co_op__c).PRM_MN_Transfers_Out__c) + transfer.PRM_MN_Amount__c;
			allocationMap.get(transfer.Transfer_To_Co_op__c).MN_Allocation__c = (allocationMap.get(transfer.Transfer_To_Co_op__c).MN_Allocation__c == null ? 0 : allocationMap.get(transfer.Transfer_To_Co_op__c).MN_Allocation__c) + transfer.PRM_MN_Amount__c;
			allocationMap.get(transfer.Transfer_From_Co_op__c).MN_Allocation__c = (allocationMap.get(transfer.Transfer_From_Co_op__c).MN_Allocation__c == null ? 0 : allocationMap.get(transfer.Transfer_From_Co_op__c).MN_Allocation__c) - transfer.PRM_MN_Amount__c;
		}
		update allocationMap.values();
	}
}