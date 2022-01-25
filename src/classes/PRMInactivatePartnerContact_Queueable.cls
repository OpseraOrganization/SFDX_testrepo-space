public class PRMInactivatePartnerContact_Queueable implements Queueable {
	
	List<Contact> partnerConLst;
	Set<Id> partnerConIdSet;
	public PRMInactivatePartnerContact_Queueable(List<Contact> partnerConLst) {
		this.partnerConLst = partnerConLst;
	}
	
	public void execute(QueueableContext context) {
		partnerConIdSet = new Set<Id>();
		if(partnerConLst != NULL && partnerConLst.size() > 0) {
			Database.SaveResult[] srLst = Database.update(partnerConLst);
			for(Database.SaveResult srItm : srLst) {
	if(srItm.isSuccess()) {
		partnerConIdSet.add(srItm.getId());
	}
			}
			
			if(partnerConIdSet.size() > 0)
	Database.executeBatch(new PRMPartnerUserDisable_Batch(partnerConIdSet),15);
			
		}
	}
}