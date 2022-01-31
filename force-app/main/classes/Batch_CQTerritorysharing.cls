Global class Batch_CQTerritorysharing implements Database.Batchable<sObject>, Database.Stateful,Schedulable  {
	
	
	map<Id,Id> ter_grp_map = new map<Id,Id>();
	public Integer Count_Terr_changed_CQ = 0;
	public Integer Count_del_CQshare = 0;
	public Integer Count_new_CQshare = 0;
	public set<Id> Acctimpacted = new set<Id>();
	Static String JOB_NAME = 'Batch_CQTerritorySharing';
	//***************************************************************
	//Method: Constructor
	//Usage: Territory Group mapping is extracted and stored in a variable which is used in execute method
	//***************************************************************		
	public Batch_CQTerritorysharing(){
		
		for(group grp: [SELECT Id,RelatedId,Type FROM Group WHERE Type = 'territory'])
		{
			ter_grp_map.put(grp.RelatedId, grp.Id);
		}
		system.debug('ter_grp_map: '+ter_grp_map);
	}
	
	//***************************************************************
	//Method: execute
	//Usage: Job Scheduling Execute method
	//***************************************************************  
	
	global void execute(SchedulableContext sc) 
	{
		checkasyncqueue();
	}
	
	//***************************************************************
	//Method: Start
	//Usage: CQ's are extracted using Database.getQueryLocator
	//***************************************************************  
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		String query = 'SELECT Apttus_Proposal__Account__c,Id FROM Apttus_Proposal__Proposal__c where Quote_Type__c = \'CQ\'';
		return Database.getQueryLocator(query);
	}
	
	//***************************************************************
	//Method: Execute
	//Usage: CQ are shared with the territory group to whcih CQ Account is assigned
	//***************************************************************  
	
	global void execute(Database.BatchableContext BC, List<Apttus_Proposal__Proposal__c> CQList){
		
		set<Id> Acctid = new set<Id>();
		map<Id,Id> CQ_Acc_map = new map<Id,Id>();
		map<Id,Id> cqsharemap = new map<Id,Id>();
		// map<Id,Id> ter_grp_map = new map<Id,Id>();
		map<Id,Id> Acct_grp_map = new map<Id,Id>();
		map<Id,Apttus_Proposal__Proposal__Share> CQshareidmap = new map<Id,Apttus_Proposal__Proposal__Share>();
		map<Id,Id> Acct_terr_map = new map<Id,Id>();
		Apttus_Proposal__Proposal__Share[] CQshareList = new Apttus_Proposal__Proposal__Share[]{};
			Apttus_Proposal__Proposal__Share[] CQsharedelList = new Apttus_Proposal__Proposal__Share[]{};	
				try{
					for (Apttus_Proposal__Proposal__c cq : CQList)
					{
						if(cq.Apttus_Proposal__Account__c <> null)
						{
							CQ_Acc_map.put(cq.Id, cq.Apttus_Proposal__Account__c);
						}
					}
					system.debug('CQList: '+CQList);
					for(Apttus_Proposal__Proposal__Share cqshare : [SELECT ParentId,RowCause,UserOrGroupId,Id FROM Apttus_Proposal__Proposal__Share where	Parent.quote_type__c = 'CQ' and UserOrGroup.Type = 'Queue' and parentId in :CQ_Acc_map.keySet()])
					{
						cqsharemap.put(cqshare.ParentId, cqshare.UserOrGroupId);
						CQshareidmap.put(cqshare.ParentId, cqshare);
					}
					system.debug('cqsharemap: '+cqsharemap);
					for(objectTerritory2Association obta : [select objectId, Territory2Id from objectTerritory2Association where objectId in :CQ_Acc_map.values()])
					{
						Acct_terr_map.put(obta.objectId, obta.Territory2Id);
					}
					system.debug('Acct_terr_map: '+Acct_terr_map);
					
					
					if(!Acct_terr_map.isEmpty())
					{
						for(Id acc : Acct_terr_map.keyset())
						{
							if(ter_grp_map.get(Acct_terr_map.get(acc)) <> null)
							{
								Acct_grp_map.put(acc, ter_grp_map.get(Acct_terr_map.get(acc)));
							}
						}
					}
					system.debug('Acct_grp_map: '+Acct_grp_map);
					for(Apttus_Proposal__Proposal__c CQ : CQList)
					{
						
						if(cqsharemap.get(CQ.Id) <> null )
						{
							
						  //  Id CurrentCQsharedgrp = cqsharemap.get(CQ.Id);
						  //  Id ShouldbeCQgrp = Acct_grp_map.get(CQ.Apttus_Proposal__Account__c);
						  //  system.debug('CurrentCQsharedgrp: '+CurrentCQsharedgrp);
						  //  system.debug('ShouldbeCQgrp: '+ShouldbeCQgrp);
							
							if(!cqsharemap.get(CQ.Id).equals(Acct_grp_map.get(CQ.Apttus_Proposal__Account__c)) ){
								Apttus_Proposal__Proposal__Share CQshare = new Apttus_Proposal__Proposal__Share();
								
								CQshare.ParentId = CQ.Id;
								CQshare.AccessLevel = 'Edit';
								CQshare.UserOrGroupId = Acct_grp_map.get(CQ.Apttus_Proposal__Account__c);
								
								CQshareList.add(CQshare);
								Count_Terr_changed_CQ = Count_Terr_changed_CQ + 1;
								CQsharedelList.add(CQshareidmap.get(CQ.Id));
								Acctimpacted.add(CQ.Apttus_Proposal__Account__c);
							}
						} else{
							system.debug('entered else');
							Apttus_Proposal__Proposal__Share CQS = new Apttus_Proposal__Proposal__Share();
							
							CQS.ParentId = CQ.Id;
							CQS.AccessLevel = 'Edit';
							CQS.UserOrGroupId = Acct_grp_map.get(CQ.Apttus_Proposal__Account__c);
							
							CQshareList.add(CQS);
							Count_new_CQshare = Count_new_CQshare + 1;
						}
						
					}
					system.debug('CQshareList: '+CQshareList);
					system.debug('CQshareListsize: '+CQshareList.size());
					system.debug('CQsharedelList: '+CQsharedelList);
					system.debug('CQsharedelListsize: '+CQsharedelList.size());
					Count_del_CQshare = CQsharedelList.size() + Count_del_CQshare;
					if(CQshareList.size() > 0){
						Database.SaveResult[] saveresult =  Database.insert(CQshareList,false);
						system.debug('saveresult: '+saveresult);
					}
					if(CQsharedelList.size() > 0){
						Database.DeleteResult[] delresult =  Database.delete(CQsharedelList,false);
						system.debug('delresult: '+delresult);
					}
					
				}
		catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CQ_Batch_CQTerritorysharing, GlobalConstants.BATCH_EXECUTE);
		}
	}
	
	//***************************************************************
	//Method: Finish
	//Usage: 
	//***************************************************************  
	
	global void finish(Database.BatchableContext BC) {
		
		system.debug('Count_Terr_changed_CQ: '+ Count_Terr_changed_CQ);
		system.debug('Count_del_CQshare: '+ Count_del_CQshare);
		system.debug('Count_new_CQshare: '+ Count_new_CQshare);
		system.debug('Acctimpacted: '+ Acctimpacted);
		String accts = string.join(new List<Id>(Acctimpacted), ';');
		
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		string[] to = system.label.emailbatch_CQterrsharing.split(';');
		email.setToAddresses(to);
		email.setSubject('CQ Territory Sharing Batch RUn Details');
		
		email.setHtmlBody('Hello, <br/><br/>Count_Terr_changed_CQ : '+ Count_Terr_changed_CQ+' <br/>Count_del_CQshare: '+ Count_del_CQshare+'<br/>Count_new_CQshare: '+ Count_new_CQshare+'<br/>Acctimpacted: '+ accts+ '<br/><br/>Regards,<br/> Developer');
		
		try{
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
		}catch(exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CQ_Batch_CQTerritorysharing, GlobalConstants.BATCH_FINISH); 
		}	   
	}

//*****************************************************
//* Name : executeMethod
//* Description : checks the count of active jobs and schedules accordingly
//	*************************************************	
	public void checkasyncqueue()
	{
		Integer count;
		try{
			//check if there are 5 active batch jobs
			if(Test.isRunningTest()){
	count = 5;
			} else{
			count = [SELECT count() 
							 FROM AsyncApexJob 
							 WHERE JobType='BatchApex' 
							 AND status in ('Processing','Preparing','Queued')];}
			if (count < 5)
			{ 
				Batch_CQTerritorysharing batch = new Batch_CQTerritorysharing();
				Database.executebatch(batch,1000);				   
			} 
			else 
			{
				//unsschedule existing job
			 try
		{
			CronTrigger[] cronTrigger = [SELECT Id 
										 FROM CronTrigger 
										 where CronJobDetail.Name = :JOB_Name];
			if(cronTrigger != null && !cronTrigger.isEmpty())
				System.abortJob(cronTrigger[0].Id);
		}catch(Exception e)
		{
			System.debug('Error while aborting job :'+JOB_Name+'Exception: '+e);
		}
				
			   //schedule this same schedulable class again in 30 mins
			  
			   Batch_CQTerritorysharing batch = new Batch_CQTerritorysharing();
			   Datetime dt = Datetime.now().addMinutes(60);  // i.e. 60 mins
			   String timeForScheduler = dt.format('s m H * * \'?\' *');
			   Id schedId = System.Schedule(JOB_NAME,timeForScheduler,batch);
				
							  
			}
		}catch(Exception e)
		{
			System.debug('Exception occured in scheduled class: '+e);
		}
	}
}