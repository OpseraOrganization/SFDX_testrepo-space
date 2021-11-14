public class CSTBulkCampaignMemberInterface {

	 public List<TacticView> tacticList = new List<TacticView>();
	 private string tacticID;
	 private Campaign camp;
	 private List<CampaignMemberStatus> MemstatusList = new List<CampaignMemberStatus>();

	 public CSTBulkCampaignMemberInterface(string tID, Campaign cmp, List<CampaignMemberStatus> cmsList){
		 this.tacticID = tID;
		 this.camp = cmp;
		 this.MemstatusList = cmsList;
	 }

	public	void getResponse()
	{
	String strResponse;
	try
	{
	Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('callout:CST_Login/api/sfdcmember?filtertype=EqualTo&tacticid='+tacticID);
		request.setMethod('GET');
		HttpResponse response = http.send(request);
		System.debug('response.getStatusCode : '+response.getStatusCode());		
		strResponse =response.getBody();
		System.debug('response of API is : '+strResponse);
		if(strResponse.indexof('[')==0 || strResponse.indexof('{')>-1){
			tacticList = (List<TacticView>)JSON.deserialize(strResponse, List<TacticView>.class);
		}else{
			//TO DO add error message in Intrface log
		}
		}
		Catch(Exception exc){
			strResponse = strResponse + 'Fail';
			insertInterfaceLog(GlobalConstants.FAILURE,'callout:CST_Login/api/sfdcmember',strResponse);
		} 
	
	}
	  public  Map<string,List<campaignMemberStatus>> dataManipulate(){
		Map<string,List<CampaignMemberStatus>> campMemStatusMap = new Map<string,List<CampaignMemberStatus>>();
		List<CampaignMemberStatus> upsertList = new List<CampaignMemberStatus>();
		List<CampaignMemberStatus> updelList = new List<CampaignMemberStatus>();
		Map<string,List<CampaignMemberStatus>> maptoreturn = new Map<string,List<CampaignMemberStatus>>();
		List<CampaignMemberStatus> TacticCMList = new List<CampaignMemberStatus>(); 
		Map<String,Id> campIdMap = new Map<String,ID>();
		set<string> cmpIDset = new set<String>();
		set<string> IDSet = new set<String>();
		Set<Id> updateIdSet = new Set<Id>();
	if(!tacticList.isEmpty())
	{
			System.debug('Inside Manipulate');
			
			for(TacticView Tac : tacticList){
				for(CampMemberStatus camp : Tac.MemberStatus){
					cmpIDset.add(Tac.TacticId);
					CampaignMemberStatus campStatus = createcmpStatus(camp.Label, camp.IsDefault, camp.HasResponded, camp.SortOrder);
					if(campMemStatusMap.containsKey(Tac.TacticId))
						campMemStatusMap.get(Tac.TacticId).add(campStatus);
					else
						campMemStatusMap.put(Tac.TacticId, new List<CampaignMemberStatus>{campStatus});
				}
			}
		campIdMap.put(camp.Campaign_Id__c, camp.Id);
			for(string map2map:campMemStatusMap.keyset())
			{
				List<CampaignMemberStatus> cmpMemList = new List<CampaignMemberStatus>();
				Id Campaign_Id = campIdMap.get(map2map);
				for(CampaignMemberStatus cmpMemObj : campMemStatusMap.get(map2map))
				{
					cmpMemObj.campaignId = Campaign_Id;
					cmpMemList.add(cmpMemObj);
				}
				TacticCMList.addall(cmpMemList);
			}
			system.debug('TacticCMList:'+TacticCMList);
			if(!TacticCMList.isEmpty())
			for(CampaignMemberStatus CMObj : TacticCMList)
			{
				boolean update_flag = false;
				CampaignMemberStatus upsertObj = new CampaignMemberStatus();
				if(!MemstatusList.isEmpty())
				for(CampaignMemberStatus memObj : MemStatusList)
				{	
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
					updelList.add(memStatObj);
				}
			}
			
			if(!updelList.isEmpty())
			{
				//upsertList.addAll(updelList);
	maptoreturn.put('delete',updelList);
			}
			if(!upsertList.isEmpty())			
	maptoreturn.put('upsert',upsertlist);		 
		}
		System.debug('maptoreturn is : '+maptoreturn);	   
		return maptoreturn;
	}
	@testvisible
	Private CampaignMemberStatus createcmpStatus(String Label, String Isdefault, String Hasresponded, Integer Sortorder){
		CampaignMemberStatus cmpStatus = new CampaignMemberStatus();
		cmpStatus.Label = Label;
		cmpStatus.IsDefault = Boolean.valueOf(Isdefault);
		cmpStatus.HasResponded = Boolean.valueOf(Hasresponded);
		cmpStatus.SortOrder = Sortorder;
		return cmpStatus;
	}
	public static void upsertCampaigns(List<CampaignMemberStatus> upsertCampaignList){
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
		
		Map<string,string> ErrorMap = new Map<string,String>();
		Schema.SObjectField f = CampaignMemberStatus.id; 
		system.debug('Inside Upsert...'+upsertCampaignList);
		Database.upsertresult[] results = Database.upsert(upsertCampaignList,f,false);
		
		for(Integer index = 0, size = results.size(); index < size; index++) {
			if(results[index].isSuccess()) {
				If(!success_tacticID.contains(tacticmap.get(upsertCampaignList[index].campaignId)))
	success_tacticID = success_tacticID + tacticmap.get(upsertCampaignList[index].campaignId) + ',';
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
		string tacticIDList = errormap.get(err.getMessage()) + ','+tacticmap.get(upsertCampaignList[index].campaignId) ;
		errormap.put(err.getMessage(), tacticIDList);
		}
		else
		{
		errormap.put(err.getMessage(), (tacticmap.get(upsertCampaignList[index].campaignId)));
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
		interfaceLog.Operation_type__c = 'UPSERT'; 
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