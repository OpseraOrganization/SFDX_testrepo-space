public class HWS_AuthorizedContactSharingSchedulable implements Schedulable{
	public List<Case> childList;
	public HWS_AuthorizedContactSharingSchedulable(List<Case> childList){
		this.childList = childList;
	}
	
	public void execute(SchedulableContext sc) {
		CH_AuthorizedContactSharing.handleSharing(new Map<Id, Case>(childList), new Map<Id, Case>(), true, false);
		// Abort the job once the job is queued
		System.abortJob(sc.getTriggerId());
	}
}