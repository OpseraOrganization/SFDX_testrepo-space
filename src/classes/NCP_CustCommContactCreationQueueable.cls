public with sharing class NCP_CustCommContactCreationQueueable implements Queueable {
	public Contact contactRecord;
	
	public NCP_CustCommContactCreationQueueable(Contact contactRecord){
		this.contactRecord = contactRecord ;  
	}
	
	public void execute(QueueableContext context){
		if(!Test.isRunningTest()){update contactRecord;}
	}
}