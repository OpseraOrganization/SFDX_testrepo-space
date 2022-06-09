/****************************************
	 * Name : CurrenychangeSchedulable 
	 * Author : HCL
	 * Description : For Sf ticket 18212 Queueable  class called from OrderIntakeHandler before update operation
	 *****************************************/
public class CurrenychangeSchedulable implements Schedulable {
	 public final Set<ID>  Opptyid;
	public CurrenychangeSchedulable (Set<ID>  Opptyid){
		this.Opptyid = Opptyid;
	}	
	
	
	public void execute(SchedulableContext sc) {
	System.debug('INSIDE ========>Schedulable Classs');
	 System.debug('INSIDE Set in Schedulable class ========>'+Opptyid );
		System.enqueueJob(new Currenychangequeueablehelper(OpptyId));
		// Abort the job once the job is queued
		System.abortJob(sc.getTriggerId());
	}
}