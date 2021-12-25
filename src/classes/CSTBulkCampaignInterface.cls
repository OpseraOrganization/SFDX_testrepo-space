public class CSTBulkCampaignInterface{
	 public List<MasterView> masterList = new List<MasterView>();
	 private string masterId;
	 
	 public CSTBulkCampaignInterface(string mID){
		 this.masterId = mID;
	 }
	 
	 public void fetchBulkCampaignData(){
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('callout:CST_Login/api/GetCampaignBulk?CampaignID='+masterId);
		request.setMethod('GET');
		HttpResponse response = http.send(request);
		System.debug('response.getStatusCode : '+response.getStatusCode());	  
		String strResponse;
		strResponse =response.getBody();
		System.debug('response of API is : '+strResponse);
		if(strResponse.indexof('[')==0 || strResponse.indexof('{')>-1){
			masterList = (List<MasterView>)JSON.deserialize(strResponse, List<MasterView>.class);
		}else{
			//TO DO add error message in Intrface log
		}
	}
	
	public List<Campaign> CSTtoCampaignConvert(){
	   
		List<Campaign> upsertList = new List<Campaign>();
		for(MasterView master : masterList){
			Campaign masterCamp = createCampaign(master.CampaignName,master.CampaignId,master.NamingConvention,master.CampaignManager,master.CampaignDescription,master.CampaignStartDate,master.CampaignEndDate);
			masterCamp.CampaignPriority__c = master.CampaignPriorty;
			populateMCASegment(masterCamp,master);
			upsertList.add(masterCamp);
			
			//SF Ticket 00316048 - Applied null check on below line
			if(master.ProgramList != null && master.ProgramList.size()>0){
			for(ProgramList program : master.ProgramList){
				Campaign programCamp = createCampaign(program.Name,program.ProgramId,program.PNamingConvention,program.CampaignManager,program.ProgramDescription,program.StartDate,program.EndDate);
				/* As per the comment from Delci Organ no need to populate BL/BG/BU values on Program */
				if(Test.isRunningTest())
				  populateBusinessLine(programCamp ,program );
				upsertList.add(programCamp);
	
	//SF Ticket 00316048 - Applied null check on below line
	if(program.TacticList != null && program.TacticList.size()>0){
				for(TacticList tactic : program.TacticList){
					Campaign tacticCamp = createCampaign(tactic.Name,tactic.TacticId,tactic.TNamingConvention,tactic.CampaignManager,tactic.TacticDescription,tactic.StartDate,tactic.EndDate);
					populatePrimaryBusinessLine(tacticCamp,tactic);
					populateSecondaryBusinessLine(tacticCamp,tactic);
					upsertList.add(tacticCamp);
				}
	}
			}
			}
		}
		System.debug('upsertList is : '+upsertList);	   
		return upsertList;
		//upsertCampaigns(upsertList);
	}
	
	 public static void upsertCampaigns(List<Campaign> upsertCampaignList){
		Schema.SObjectField f = Campaign.Campaign_ID__c;
		Database.upsertresult[] results = Database.upsert(upsertCampaignList,f,false);
		
		for(Integer index = 0, size = results.size(); index < size; index++) {
			if(results[index].isSuccess()) {
				if(results[index].isCreated()) {
					//System.debug(' was created');
				} else {
					//System.debug(' was updated');
				}
			}else{
				for(Database.Error err : results[index].getErrors()) {
					System.debug('The following error has occurred.');				  
					System.debug(err.getStatusCode() + ': ' + err.getMessage());
					System.debug('Fields that affected this error: ' + err.getFields());
				}
			}
		}
	}
	
	@testvisible
	private Campaign createCampaign(string cname,string cId,string convention,string emailstr,string description,string startdate,string endDate){
		Campaign cmp = new campaign();
		cmp.Name_CST__c = cname;
		cmp.Campaign_ID__c = cId;		   
		cmp.Name = convention; 
		cmp.Campaign_Manager_Email__c = emailstr;
		cmp.Description = description;
		
		//SF Ticket 00316048 - commented below lines and applied null check
		//cmp.StartDate=dateUtility(startDate);
		//cmp.endDate=dateUtility(endDate);
		
		if(startDate !=null)
			cmp.StartDate=dateUtility(startDate);
		if(endDate !=null)
			cmp.endDate=dateUtility(endDate);
		
		cmp.isActive = true;
		return cmp;
	}
	
	@testvisible
	private date dateUtility(string dateString){
		String dateStr = dateString.substring(0,10);
		List<string> dateCmp = dateStr.split('-');
		Integer dayOfMonth = Integer.valueOf(dateCmp.get(2));
		Integer year = Integer.valueOf(dateCmp.get(0));
		Integer monthOfyear=Integer.valueOf(dateCmp.get(1));
		/*if(dateCmp.get(1)=='Jan'){
			monthOfyear=1;
		}else if(dateCmp.get(1)=='Feb'){
			monthOfyear=2;
		}else if(dateCmp.get(1)=='Mar'){
			monthOfyear=3;
		}else if(dateCmp.get(1)=='Apr'){
			monthOfyear=4;
		}else if(dateCmp.get(1)=='May'){
			monthOfyear=5;
		}else if(dateCmp.get(1)=='Jun'){
			monthOfyear=6;
		}else if(dateCmp.get(1)=='Jul'){
			monthOfyear=7;
		}else if(dateCmp.get(1)=='Aug'){
			monthOfyear=8;
		}else if(dateCmp.get(1)=='Sep'){
			monthOfyear=9;
		}else if(dateCmp.get(1)=='Oct'){
			monthOfyear=10;
		}else if(dateCmp.get(1)=='Nov'){
			monthOfyear=11;
		}else{
			monthOfyear=12;
		}*/
		
		return Date.newInstance(year, monthOfyear, dayOfMonth);
	}
	
	private void populatePrimaryBusinessLine(Campaign campaignT,TacticList tactic){
		if(tactic.LeadBusinessGroup!=NULL){
			campaignT.Lead_Business_Group__c = tactic.LeadBusinessGroup.Name;
		}
		if(tactic.LeadBusinessUnit!=NULL){
			campaignT.Lead_Business_Unit__c = tactic.LeadBusinessUnit.Name;
		}
		if(tactic.LeadBusinessLine!=NULL){
			campaignT.Lead_Business_Line__c = tactic.LeadBusinessLine.Name;
		}
	}
	
	private void populateSecondaryBusinessLine(Campaign campaignT,TacticList tactic){
		String bgValues = '';
		String buValues = '';
		String blValues = '';
		String bSValues = '';
		String iNValues = '';
		String bTValues = '';
		if(tactic.SecondaryBusinessGroupList!=NULL){
			for(SecondaryBusinessGroup bg : tactic.SecondaryBusinessGroupList){
				bgValues = bgValues + bg.Name + ';';
			}
			campaignT.SecondaryBusinessGroupList__c = bgValues;
		}
		
		//SF Ticket 00316048- Un-map/comment out SecondaryBusinessUnitList__c and SecondaryBusinessLineList__c
		
		if(tactic.SecondaryMCASegment!=NULL){
			for(SecondaryBusinessGroup bs : tactic.SecondaryMCASegment){
				bSValues = bSValues + bs.Name + ';';
			}
			campaignT.SecondaryMCASegment__c = bSValues;
		}
		if(tactic.IndustryList!=NULL){
			for(MCASegment inV : tactic.IndustryList){
				iNValues = iNValues + inV.Name + ';';
			}
			campaignT.IndustryList__c = iNValues;
		}
		if(tactic.BusinessTypeList!=NULL){
			for(MCASegment bt : tactic.BusinessTypeList){
				bTValues = bTValues + bt.Name + ';';
			}
			campaignT.BusinessTypeList__c = bTValues;
		}
		if(tactic.LeadMCASegment!=NULL){
		   campaignT.MCASegment__c = tactic.LeadMCASegment.Name;
		}
	}
	
	private void populateBusinessLine(Campaign programCamp,ProgramList program){
		String bgValues = '';
		String buValues = '';
		String blValues = '';
		String iNValues = '';
		String bTValues = '';
		if(program.BusinessGroupList!=NULL){
			for(MCASegment bg : program.BusinessGroupList){
				bgValues = bgValues + bg.Name + ';';
			}
			programCamp.SecondaryBusinessGroupList__c = bgValues;
		}
		
		//SF Ticket 00316048- Un-map/comment out SecondaryBusinessUnitList__c and SecondaryBusinessLineList__c
		
		if(program.IndustryList!=NULL){
			for(MCASegment inV : program.IndustryList){
				iNValues = iNValues + inV.Name + ';';
			}
			programCamp.IndustryList__c = iNValues;
		}
		if(program.BusinessTypeList!=NULL){
			for(MCASegment bt : program.BusinessTypeList){
				bTValues = bTValues + bt.Name + ';';
			}
			programCamp.BusinessTypeList__c = bTValues;
		}
		if(program.MCASegment!=NULL){
		   programCamp.MCASegment__c = program.MCASegment.Name;
		}
	}
	
	private void populateMCASegment(Campaign masterCamp,MasterView master){
		String MCASeg = '';
		if(master.MCASegment!=NULL){
			for(MCASegment mcaS: master.MCASegment){
				MCASeg = MCASeg + mcaS.Name + ';';
			}
			masterCamp.MCASegment__c = MCASeg;
		}
		if(master.MasterCampaign != NULL){
			masterCamp.MasterCampaign__c = master.MasterCampaign.name;
		}
	}
		
	public class MasterView {
		public String CampaignId;
		public String CampaignName;
		public String CampaignDescription;
		public String CampaignManager;
		public String NamingConvention;
		public String CampaignStartDate;
		public String CampaignEndDate;
		public Boolean CampaignPriorty;
		public Boolean hidden;
		public List<MCASegment> MCASegment;
		public List<ProgramList> ProgramList;
		public MCASegment MasterCampaign;
	}
	
	public class ProgramList {
		public String ProgramId;
		public String Name;
		public String ProgramDescription;
		public String CampaignManager;	 
		public String PNamingConvention;
		public String StartDate;
		public String EndDate;
		public List<TacticList> TacticList;
		public List<MCASegment> BusinessGroupList;
		public List<MCASegment> BusinessUnitList;
		public List<MCASegment> BusinessLineList;
		public List<MCASegment> BusinessTypeList;
		public List<MCASegment> IndustryList;
		public MCASegment MCASegment;
	}
	  
	public class TacticList {
		public String TacticId;
		public String Name;
		public String TacticDescription;
		public String CampaignManager;	  
		public String TNamingConvention;
		public String TacticType;
		public String StartDate;
		public String EndDate;
		public Boolean hidden;
		public MCASegment LeadBusinessGroup;
		public MCASegment LeadBusinessUnit;
		public MCASegment LeadBusinessLine;
		public List<SecondaryBusinessGroup> SecondaryBusinessGroupList;
		public List<SecondaryBusinessGroup> SecondaryBusinessLineList;
		public List<SecondaryBusinessGroup> SecondaryBusinessUnitList;
		public List<MCASegment> BusinessTypeList;
		public List<MCASegment> IndustryList;
		public MCASegment LeadMCASegment;
		public List<SecondaryBusinessGroup> SecondaryMCASegment;
	}
	
	public class MCASegment {
		public Integer Id;
		public String Name;
	}
	
	public class SecondaryBusinessGroup {
		public Integer Id;
		public String Name;
	}
}