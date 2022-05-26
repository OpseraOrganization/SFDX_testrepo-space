public class CSTHierarchyInterface{
	private Map<string,List<Campaign>> campaignMap;
	private List<MasterView> masterList;
	
	public CSTHierarchyInterface(){
		this.getHierarchy();
		this.dataManipulate();
		this.populateHierarchy();
	}
	
	public void getHierarchy(){
		String strResponse;
		try{
			Http http = new Http();
			HttpRequest request = new HttpRequest();
			request.setEndpoint('callout:CST_Login/api/GetCampaignList');
			request.setMethod('GET');
			HttpResponse response = http.send(request);
			System.debug('response.getStatusCode : '+response.getStatusCode());		 
			strResponse =response.getBody();
			System.debug('response of API is : '+strResponse);
			masterList = (List<MasterView>)JSON.deserialize(strResponse, List<MasterView>.class);
		}Catch(Exception exc){
			 insertInterfaceLog(strResponse,GlobalConstants.FAILURE);
		}		
	}
	
	public void dataManipulate(){
		campaignMap = new Map<string,List<Campaign>>();
		List<Campaign> upsertCampaignList = new List<Campaign>();
		for(MasterView master : masterList){
			Campaign masterCamp = createCampaign(master.CampaignId,master.NamingConvention);
			upsertCampaignList.add(masterCamp);
			//manipulateData(master.MasterId,masterCamp);
			
			for(ProgramView program : master.ProgramView){
				Campaign programCamp = createCampaign(program.ProgramId,program.PNamingConvention);
				upsertCampaignList.add(programCamp);
				manipulateData(master.CampaignId,programCamp);
				
				for(TacticViewCampaign tactic : program.TacticView){
					Campaign tacticCamp = createCampaign(tactic.TacticId,tactic.TNamingConvention);
					tacticCamp.type = tactic.tacticType;
					upsertCampaignList.add(tacticCamp);
					manipulateData(program.ProgramId,tacticCamp);
				}
			}
		}
		upsertCampaigns(upsertCampaignList);
	}
	
	@TestVisible
	private void populateHierarchy(){
		List<Campaign> upsertCampaignList = new List<Campaign>();
		for(string parentExtId : campaignMap.keySet()){
			//List<Campaign> cmpList = campaignMap.get(parentExtId);
			Campaign campRefernce = new Campaign(Campaign_ID__c = parentExtId);
			for(campaign cmp : campaignMap.get(parentExtId)){
				cmp.parent = campRefernce;
				cmp.IsActive = true;
				upsertCampaignList.add(cmp);
			}
		}
		upsertCampaigns(upsertCampaignList);
	}
	
	@TestVisible
	private void upsertCampaigns(List<Campaign> upsertCampaignList){
		String campaignIdList;
		Schema.SObjectField f = Campaign.Campaign_ID__c;
		Database.upsertresult[] results = Database.upsert(upsertCampaignList,f,false);
		
		for(Integer index = 0, size = results.size(); index < size; index++) {
			if(results[index].isSuccess()) {
				campaignIdList = campaignIdList + upsertCampaignList[index].Campaign_ID__c+'=>Success,';
				if(results[index].isCreated()) {
					//System.debug(' was created');
				} else {
					//System.debug(' was updated');
				}
			}else{
			   
				for(Database.Error err : results[index].getErrors()) {
					campaignIdList = campaignIdList + upsertCampaignList[index].Campaign_ID__c+'=>Failure {'+err.getMessage()+'},';
					System.debug('The following error has occurred.');					
					System.debug(err.getStatusCode() + ': ' + err.getMessage());
					System.debug('Fields that affected this error: ' + err.getFields());
				}
			}
		}
		insertInterfaceLog(campaignIdList,GlobalConstants.SUCCESS);
	}
	
	 public static void insertInterfaceLog(string res,string status){
		
		Interface_Log__c interfaceLog = New Interface_Log__c();
		interfaceLog.Name = 'CST GetCampaignList';
		/***************************************************************/
		interfaceLog.Message_Type__c = GlobalConstants.OUTBOUND;
		interfaceLog.Status__c = status;
		interfaceLog.Comment__c = res.length()>1000? res.substring(0,1000): res;
		interfaceLog.Operation_type__c = GlobalConstants.INSERT_VALUE; 
		interfaceLog.Interface_Request_Sent__c = 'callout:CST_Login/api/GetCampaignList';
		interfaceLog.Interface_Type__c = 'CST Integration';
		interfaceLog.Message_Type__c = GlobalConstants.OUTBOUND;  
		insert interfaceLog;
	}
	
	private Campaign createCampaign(string campaignId,string campaignName){
		Campaign cmp = new Campaign();
		cmp.Campaign_ID__c = campaignId;
		cmp.isActive = true;
		cmp.name = campaignName.length()>80? campaignName.substring(0,80): campaignName;
		return cmp;
	}
	
	private void manipulateData(String cmpId,Campaign cmp){
		if(campaignMap.containsKey(cmpId)){
			campaignMap.get(cmpId).add(cmp);
		}else{
			campaignMap.put(cmpId,new list<Campaign>{cmp});
		}
	}
	
	public class MasterView {
		public String CampaignId;
		public String CampaignName;
		public String NamingConvention;
		public Boolean IsTargetedOutreach;
		public List<ProgramView> ProgramView;
	}
	
	public class ProgramView {
		public String ProgramId;
		public String ProgramName;
		public String PNamingConvention;
		public List<TacticViewCampaign> TacticView;
	}
	
	public class TacticViewCampaign {
		public String TacticId;
		public String TacticCampaign;
		public String TNamingConvention;
		public String tacticType;
	}
	
}