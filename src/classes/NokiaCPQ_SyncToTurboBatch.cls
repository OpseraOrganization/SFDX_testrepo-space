global without sharing class NokiaCPQ_SyncToTurboBatch implements Database.Batchable<Id>,Database.AllowsCallouts,Database.Stateful{
	
	set<id> objIds;
	string objectAPI;
	string syncType;
	
	global NokiaCPQ_SyncToTurboBatch(set<id> objIds,string objectAPI, string syncType) {
		this.objIds = objIds;
		this.objectAPI = objectAPI;
		this.syncType = syncType;
	}
	
	global Iterable<Id> start(Database.BatchableContext BC){
		list<Id> objIdsList = new list<Id>(objIds);
		return objIdsList;
	}

	global void execute(Database.BatchableContext BC, list<Id> objIdsList){
		NokiaCPQ_RealTimeTurboSync.syncToTurbo(new set<id>(objIdsList),objectAPI,syncType);
	}

	global void finish(Database.BatchableContext BC){ 
	}
	
}