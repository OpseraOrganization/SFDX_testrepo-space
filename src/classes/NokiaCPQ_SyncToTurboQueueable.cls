public without sharing class NokiaCPQ_SyncToTurboQueueable implements Queueable,Database.AllowsCallouts {
	
	private set<id> objIds;
	private string objectAPI;
	private string syncType;
	
	public NokiaCPQ_SyncToTurboQueueable(set<id> objIds, string objectAPI, string syncType){ 
		this.objIds = objIds;
		this.objectAPI = objectAPI;
		this.syncType = syncType;
	}
	
	public void execute(System.QueueableContext qc) { 
		NokiaCPQ_RealTimeTurboSync.syncToTurbo(objIds,objectAPI,syncType);
	}
}