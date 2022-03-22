public class CSTCampaignMemberStatusInterface {
	private List<TacticView> tacticList;
	private Map<string,List<CampaignMemberStatus>> campMemStatusMap; 
	private Map<String,Id> campIdMap = new Map<String,ID>();
	Private List<CampaignMemberStatus> MemStatusList = new List<CampaignMemberStatus>();
	Private List<CampaignMemberStatus> TacticCMList = new List<CampaignMemberStatus>();
	Private List<CampaignMemberStatus> upsertList = new List<CampaignMemberStatus>();
	Private Set<Id> updateIdSet = new Set<Id>();
	Private List<CampaignMemberStatus> mockUpdateList = new List<CampaignMemberStatus>();
	public String updatedDate;
	public CSTCampaignMemberStatusInterface(String uDate){
		system.debug('udate:'+udate); 
		this.updatedDate = udate;
		this.getResponse();
		this.dataManipulate();
			  
	}
	
	public void getResponse(){
		String strResponse;
		Campaign_Mem_Status_Date__c cmdate = [select Id, BatchDate__c from Campaign_Mem_Status_Date__c limit 1];
		DateTime dateValue = date.today();
		try{
			Http http = new Http();
			HttpRequest request = new HttpRequest();
			request.setEndpoint('callout:CST_Login/api/sfdcmember?filtertype=GreaterThanEqualTo&updateddate='+updatedDate);
			request.setMethod('GET');
			request.setTimeout(120000); 
			HttpResponse response = http.send(request);
			System.debug('response.getStatusCode : '+response.getStatusCode());
			System.debug('response.getStatusCode : '+response.getStatus() );
			System.debug('response.getStatusCode : '+response.getHeaderKeys()); 
			strResponse =response.getBody();
			System.debug('response of API is : '+strResponse);
			
			
			tacticList = (List<TacticView>)JSON.deserialize(strResponse, List<TacticView>.class);
			cmdate.batchdate__c = ((DateTime)dateValue).format('YYYY-MM-dd');
			if(strResponse != null)
				update cmdate;
		}Catch(Exception exc){
			strResponse = strResponse + 'Fail';
			 insertInterfaceLog(GlobalConstants.FAILURE,'callout:CST_Login/api/sfdcmember',strResponse);
		}		
	}
	
	public  void dataManipulate(){
		if(!tacticList.isEmpty()){System.debug('Inside Manipulate');
			campMemStatusMap = new Map<string,List<CampaignMemberStatus>>();
			//List<CampaignMemberStatus> cmpMemList = new List<CampaignMemberStatus>();
			set<string> cmpIDset = new set<String>();
			set<string> IDSet = new set<String>();
			system.debug('TacticList:'+tacticList.size());
			for(TacticView Tac : tacticList){
				for(CampMemberStatus camp : Tac.MemberStatus){
					cmpIDset.add(Tac.TacticId);
					system.debug('Tac.TacticId:'+Tac.TActicId);
					CampaignMemberStatus campStatus = createcmpStatus(camp.Label, camp.IsDefault, camp.HasResponded, camp.SortOrder);
					if(campMemStatusMap.containsKey(Tac.TacticId))
						campMemStatusMap.get(Tac.TacticId).add(campStatus);
					else
						campMemStatusMap.put(Tac.TacticId, new List<CampaignMemberStatus>{campStatus});
				}
			}
			system.debug('cmpIDset:'+cmpIDset);
			for(Campaign cmp : [Select Id, Campaign_Id__c from Campaign Where Campaign_Id__c in :cmpIDset])
			{
				system.debug('cmp.ID+cmp.campaign_id__C:'+cmp.ID+cmp.campaign_id__C);
				IDSet.add(cmp.Id);
				campIdMap.put(cmp.Campaign_Id__c, cmp.Id);
			}
			  system.debug('campIDMap:'+campIdmap);
			for(string map2map:campMemStatusMap.keyset())
			{	
				List<CampaignMemberStatus> cmpMemList = new List<CampaignMemberStatus>();
				system.debug('map2map:'+map2map);
				Id Campaign_Id = campIdMap.get(map2map);
				system.debug('campaign_Id:'+campaign_id);
				system.debug('campMemStatusMap.get(map2map):'+campMemStatusMap.get(map2map));
				for(CampaignMemberStatus cmpMemObj : campMemStatusMap.get(map2map))
				{
					system.debug('cmpMemObj:'+Campaign_Id);
					cmpMemObj.campaignId = Campaign_Id;
					cmpMemList.add(cmpMemObj);
				}
				system.debug('TacticCMList:'+TacticCMList);
				TacticCMList.addall(cmpMemList);
				//cmpMemList.clear();
			}
								  
			List<CampaignMemberStatus> MemStatusList = [SELECT CampaignId,HasResponded,Id,IsDefault,Label,SortOrder FROM CampaignMemberStatus where CampaignId in :IDSet];
			if(!TacticCMList.isEmpty())
				for(CampaignMemberStatus CMObj : TacticCMList)
			{
				System.debug('CMobj:'+cmObj.CampaignId);
				boolean update_flag = false;
				CampaignMemberStatus upsertObj = new CampaignMemberStatus();
				if(!MemstatusList.isEmpty())
					for(CampaignMemberStatus memObj : MemStatusList)
				{	
					System.debug('Memobj:'+memObj.CampaignId);
					if(memObj.CampaignId == CMObj.CampaignId && CMObj.SortOrder == memObj.SortOrder)
					{
						update_flag = true;		
						upsertObj = CMObj;	
						upsertObj.Id = memObj.Id;	
						upsertList.add(upsertObj);
						updateIdSet.add(upsertObj.Id);
					}			
				}
				if(update_flag == false)
				{
					upsertObj = CMObj;
					upsertList.add(upsertObj);
				}
			}
			for(CampaignMemberStatus memStatObj : MemStatusList)
			{
				if(!updateIdSet.contains(memStatObj.Id)){
					memStatObj.IsDefault = FALSE;
					memStatObj.HasResponded = FALSE;
					mockUpdateList.add(memStatObj);
				}
			}
			
			if(!mockUpdateList.isEmpty())
				upsertList.addAll(mockUpdateList);
			if(!upsertList.isEmpty())
				upsertCampaigns(upsertList);
			if(!mockUpdateList.isEmpty())
				Database.delete(mockUpdateList, false);
		}
	}
	
	Private CampaignMemberStatus createcmpStatus(String Label, String Isdefault, String Hasresponded, Integer Sortorder){
		CampaignMemberStatus cmpStatus = new CampaignMemberStatus();
		cmpStatus.Label = Label;
		cmpStatus.IsDefault = Boolean.valueOf(Isdefault);
		cmpStatus.HasResponded = Boolean.valueOf(Hasresponded);
		cmpStatus.SortOrder = Sortorder;
		return cmpStatus;
	}
	@TestVisible
	Private void upsertCampaigns(List<CampaignMemberStatus> upsertCampaignList){
	   //String campaignIdList='';
		String success_tacticID='';
		set<id> cmpIDset = new set<id>();
		for(campaignmemberstatus cmsList: upsertCampaignList)
		{
		cmpIDset.add(cmsList.campaignId);
		}
		Map<Id,string> tacticmap = new Map<Id,string>();
		for(campaign cmpMap : [select ID, campaign_id__c from campaign where ID in :cmpIDset])
		{
			tacticmap.put(cmpMap.Id,cmpMap.campaign_id__c);
		}
		system.debug('TacticMAp:'+Tacticmap);
		Map<string,string> ErrorMap = new Map<string,String>();
		Schema.SObjectField f = CampaignMemberStatus.id; 
		system.debug('Inside Upsert...'+upsertCampaignList);
		Database.upsertresult[] results = Database.upsert(upsertCampaignList,f,false);
		
		for(Integer index = 0, size = results.size(); index < size; index++) {
			if(results[index].isSuccess()) {
	success_tacticID = success_tacticID + tacticmap.get(upsertCampaignList[index].campaignId) + '-'+ upsertCampaignList[index].ID +',';
			  //  campaignIdList = campaignIdList + upsertCampaignList[index].ID+'=>Success,';
				if(results[index].isCreated()) {
					System.debug(' was created');
				} else {
					System.debug(' was updated');
				}
			}else{
				
				for(Database.Error err : results[index].getErrors()) {
					if(errormap.containsKey(err.getMessage()))
		{
		string tacticIDList = errormap.get(err.getMessage()) + ','+ tacticmap.get(upsertCampaignList[index].campaignId)+'-'+ upsertCampaignList[index].ID;
		errormap.put(err.getMessage(), tacticIDList);
		}
		else
		{
		errormap.put(err.getMessage(), (tacticmap.get(upsertCampaignList[index].campaignId)+'-'+ upsertCampaignList[index].ID));
		}
					System.debug('The following error has occurred.');					
					System.debug(err.getStatusCode() + ': ' + err.getMessage());
					System.debug('Fields that affected this error: ' + err.getFields());
				}
			}
		}
		IF(success_tacticID != null)
		insertInterfaceLog(GlobalConstants.SUCCESS,success_tacticID,GlobalConstants.SUCCESS);
		IF(!errormap.isEmpty())
		{
		for(string err:errormap.keyset())
		{
		insertInterfaceLog(GlobalConstants.FAILURE,errormap.get(err),err);
		}
		}
	}
	public static void insertInterfaceLog(string status,string res,string msg){
		
		Interface_Log__c interfaceLog = New Interface_Log__c();
		interfaceLog.Name = 'CST CampaignMemberStatus';
		/***************************************************************/
		interfaceLog.Message_Type__c = GlobalConstants.OUTBOUND;
		interfaceLog.Status__c = status;
		interfaceLog.Comment__c = msg;
		interfaceLog.Operation_type__c = GlobalConstants.INSERT_VALUE; 
		interfaceLog.Interface_Request_Sent__c = res.length()>1000? res.substring(0,1000): res; //'callout:CST_Login/api/sfdcmember';
		interfaceLog.Interface_Type__c = 'CST Tactic Status Integration';
		interfaceLog.Message_Type__c = GlobalConstants.OUTBOUND;  
		insert interfaceLog;
	}
	
	public class TacticView {
		public String TacticId;
		public String NamingConvention;
		public String UpdatedDate;
		public String CreatedDate;
		public List<CampMemberStatus> MemberStatus;
	}
	
	public class CampMemberStatus {
		public String Label;
		public String IsDefault;
		public String HasResponded;
		public Integer SortOrder;
	}
	
}