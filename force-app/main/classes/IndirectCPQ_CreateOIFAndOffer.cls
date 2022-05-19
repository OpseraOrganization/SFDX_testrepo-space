public without sharing class IndirectCPQ_CreateOIFAndOffer implements Queueable{
private  List<Opportunity> opptyList;
	private static final Id directRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	private static final Id inDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
	
	public IndirectCPQ_CreateOIFAndOffer(List<Opportunity> tempOpptyList){
		this.opptyList= tempOpptyList;
	}
	
	
	
	public void execute(QueueableContext context) {
		system.debug('Inside Execute>>>>');
		createOIFandOffer(opptyList);
		
	}
	
	public static void createOIFandOffer(List<Opportunity> opptyList){
		system.debug('Inside createOIFandOffer>>>>');
		system.debug('opptyList>>>>'+opptyList);
		Map<String, Id> keyToCalendar = new Map<String, Id>();
		String LeadBG, LeadBU , LeadBL; // HCL
		Map<String,String> BGBUMap = new Map<String,String>(); // HCL
		Map<String,String> BUBLMap = new Map<String,String>(); // HCL
		List<Offer__c> offerList = new List<Offer__c>();
		List<Order_Intake_Forecast__c> orderIntakeList = new List<Order_Intake_Forecast__c>();
		Offer__c offer = new Offer__c() ;
		Order_Intake_Forecast__c orderIntake = new Order_Intake_Forecast__c(); 
		try{
			List<Opportunity>oppList = [SELECT id,name,Lead_BG__c,Lead_BU__c ,G4_Planned_Date__c,Account.Owner.Name,Account.OwnerID, SWx_Upsell_Proposal__r.Analytics_Source__c,SWx_Upsell_Proposal__r.Proposal_Recommendation_Type__c, 
	Stagename,CreatedDate,Deal_Registration__c,SWx_Upsell_Proposal__r.Expected_LoA_Level__c, SWx_Upsell_Proposal__r.Unweighted_Value__c,SWx_Upsell_Proposal__r.Business_Line__c FROM Opportunity
	WHERE Id =:opptyList[0].id and StageName =:  GlobalConstants.DEVELOP_OPPORTUNITY  and RecordType.DeveloperName =: GlobalConstants.Indirect_Record_Type
	LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			system.debug('createOIFoppList>>>'+oppList);
			//HCL
			for(opportunity o : oppList  ){
	 LeadBG = o.Lead_BG__c;
	 LeadBU = o.Lead_BU__c;
			}
	 
			System.debug('LeadBG: '+LeadBG); // HCL
			System.debug('LeadBU: '+LeadBU); //HCL
			Set<String> productCodeSet = new Set<String>();
			Map<String,Id> prodcodeIdMap = new Map<String,String>();
			Map<String,String> BGProductCodeMap = new Map<String,String>();
			for(OIF_BL_based_on_Business_group__mdt mdrecord : [Select Id, Business_Group__c, Bussiness_Line__c,Business_Unit__c 
	from OIF_BL_based_on_Business_group__mdt Where 
	Bussiness_Line__c!= null AND Business_Group__c!=Null 
	LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
	productCodeSet.add(mdrecord.Bussiness_Line__c); 
	BGProductCodeMap.put(mdrecord.Business_Group__c, mdrecord.Bussiness_Line__c);
	BGBUMap.put(mdrecord.Business_Group__c, mdrecord.Business_Unit__c); // HCL
	BUBLMap.put(mdrecord.Business_Unit__c, mdrecord.Bussiness_Line__c); // HCL
			}
			System.debug('productCodeSet>>>'+productCodeSet);
			System.debug('BGProductCodeMap>>>'+BGProductCodeMap);
			System.debug('BGBUMap>>>'+BGBUMap); // HCL
			System.debug('BUBLMap>>>'+BUBLMap); //HCL
			
			// HCL
			if(LeadBG != null && LeadBG !=''){
	if(LeadBU !=null && LeadBU !=''){
		LeadBL = BUBLMap.get(LeadBU);
		System.debug('LeadBL: '+LeadBL);
	}else{
		LeadBU=BGBUMap.get(LeadBG);
		LeadBL=BUBLMap.get(LeadBU);
		System.debug('LeadBU: '+LeadBU);
		System.debug('LeadBL: '+LeadBL);
	}
			}
			
	 
			for(Product2 objProd : [Select Id, ProductCode from Product2 where productCode IN:productCodeSet]) {
	prodcodeIdMap.put(objProd.ProductCode,objProd.Id);
			}
			System.debug('prodcodeIdMap>>>'+prodcodeIdMap);
			if(!oppList.isEmpty()){
	Integer currentYear = System.Today().year();
	
	String CurrentYearstr = String.Valueof(currentYear);
	String CurrentYearstr1 = String.Valueof(currentYear+1);
	for(Nokia_Financial_Calendar__c calendar : [SELECT Id, Name, Period_Number__c, Year__c FROM Nokia_Financial_Calendar__c 
			WHERE (Year__c =: CurrentYearstr OR Year__c =: CurrentYearstr1) LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
	String concatKey = calendar.Period_Number__c + calendar.Year__c;
	keyToCalendar.put(concatKey, calendar.id);
			}
	
	for(Opportunity opp : oppList){
		Integer MonthIntCXM,MonthIntRecPlan,YearInt_PO,YearInt_Rec;
		String MonthStringCXM,MonthStringRecPlan,YearString_PO,YearString_Rec, keyCXM,KeyrecPlan;
		Integer month =opp.CreatedDate.month();

		Datetime crdate1=opp.CreatedDate;
		crdate1=crdate1.addMonths(3);
		MonthIntCXM=crdate1.month();
		MonthStringCXM=String.valueOf(MonthIntCXM);
		if(opp.CreatedDate.month()> 9){
		YearInt_PO=opp.CreatedDate.year() + 1;
		}
		else{
		YearInt_PO=opp.CreatedDate.year();
		}
		YearString_PO=String.valueOf(YearInt_PO);

		Datetime recPlandate = opp.CreatedDate.addMonths(4);
		MonthIntRecPlan = recPlandate.month() ;
		MonthStringRecPlan = String.valueOf(MonthIntRecPlan);
		if(opp.CreatedDate.month()> 8){
		YearInt_Rec=opp.CreatedDate.year() +1;
		}
		else{
		YearInt_Rec=opp.CreatedDate.year();
		}
		YearString_Rec=String.valueOf(YearInt_Rec);

		opp.Amount = CSWXGlobalConstant.ZERO;
		opp.Probability = CSWXGlobalConstant.ZERO;

		keyCXM = MonthStringCXM + YearString_PO;
		KeyrecPlan = MonthStringRecPlan + YearString_Rec;
		if(LeadBL!=null && LeadBL!='' && (opp.Deal_Registration__c == null || opp.Deal_Registration__c == '')){	  //HCL 
			orderIntake.BusinessLine__c = prodcodeIdMap.get(LeadBL);//prodcodeIdMap.get(BGProductCodeMap.get(opp.Lead_BG__c));
			orderIntake.Business_Group__c = opp.Lead_BG__c;
			orderIntake.Opportunity__c = opp.id;
			orderIntake.Software__c = CSWXGlobalConstant.ZERO;
			orderIntake.OIF_Value__c = CSWXGlobalConstant.ZERO;
			orderIntake.OIF_Value_EUR__c = CSWXGlobalConstant.ZERO; //hcl
			orderIntake.Forecast_Category__c = CSWXGlobalConstant.FORECASTCATEGORYOIF;
			orderIntake.POPlanReceipt__c = keyToCalendar.get(keyCXM);
			orderIntake.Rev_RecPlan_Receipt__c = keyToCalendar.get(KeyrecPlan);
			orderIntake.Close_Date__c=system.today();
			orderIntakeList.add(orderIntake);
		}
		
		offer.Name = CSWXGlobalConstant.OFFERNAMEAUTO+ opp.Name;
		offer.Opportunity__c = opp.id;
		DateTime dT = opp.CreatedDate;  
		Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
		offer.Customer_Offer_Due_Date__c = opp.G4_Planned_Date__c+2;
	// offer.G4_Approval_Date__c
		//offer.No_Support_Offer_Condition__c = CSWXGlobalConstant.Yes;
		offer.LOA_Bypass__c = CSWXGlobalConstant.NOLOA;
		offer.LoA_Approval_Level__c = GlobalConstants.LOA_BYPASS_LEVEL;
		offerList.add(offer);
		System.debug('Optyy>>>>'+opp.SWx_Upsell_Proposal__r.Business_Line__c);
	}
	System.debug('The OIF is >>>>'+orderIntakeList);
	System.debug('The Offer is >>>>'+offerList);
	insert offerList;
	if(orderIntakeList.size()>0){ insert orderIntakeList; }
			}
			UpdateApprovalHistoryData(oppList[0].id);
		}
		catch(Exception ex){
			system.debug('ex>>>>'+ex);
			ExceptionHandler.addException(ex, IndirectCPQ_CreateOIFAndOffer.class.getName(), GlobalConstants.createOIFandOffermethod);
		}
		
	}
	
	/*****************************
*Method Name: UpdateApprovalHistoryData on Opportunities.
*Description: This method will create the Approval History data for Automation in digital Sales
*Parameters: Opportunity Id: oppId
*******************************/ 
	
	public static void UpdateApprovalHistoryData(Id oppId){
		try{
			system.debug('Inside UpdateApprovalHistoryData>>>>>>>>>>>>>>');
			system.debug('oppIdStage>>>'+oppId);
			List<Apttus_Approval__ApprovalProcessInstance__c> approvalProcessList = [SELECT Id, name,Apttus_Approval__PrevProcessInstanceId__c,Apttus_Approval__InstanceNumber__c,Apttus_Approval__BusinessObjectId__c
	FROM Apttus_Approval__ApprovalProcessInstance__c
	WHERE name like: CSWXGlobalConstant.G2ProcessId limit 1];
			system.debug('approvalProcessList>>>>>>>>>>>>>>'+approvalProcessList);
	 
			List<Apttus_Approval__Approval_Request_History__c> approvalDataHistory = new List<Apttus_Approval__Approval_Request_History__c>();
			List<Apttus_Approval__Approval_Request__c> approvalDataList = new List <Apttus_Approval__Approval_Request__c>();
	 
			for(Apttus_Approval__Approval_Request__c approvalData:[SELECT id,Name,Apttus_Approval__StepNameLink__c,Apttus_Approval__Step_Name__c,
	Apttus_Approval__Request_Comments__c,Apttus_Approval__Assigned_To_Type__c,Apttus_Approval__Related_Opportunity__c,
	Apttus_Approval__ProcessInstanceId__c,Apttus_Approval__Approver_Comments__c,Apttus_Approval__StepSequenceString__c,
	NF_Assignee_Type__c,Apttus_Approval__Approval_Status__c,Apttus_Approval__Active__c,Apttus_Approval__Object_Id__c,Apttus_Approval__Object_Type__c,
	Apttus_Approval__StepLabel__c,Apttus_Approval__RequestType__c,Apttus_Approval__Notify_Only__c,Apttus_Approval__Initial_Submitter__c,Apttus_Approval__Assigned_To_Name__c,Apttus_Approval__Date__c
	FROM Apttus_Approval__Approval_Request__c where Apttus_Approval__Related_Opportunity__c=:oppId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
		
		if(approvalData.Apttus_Approval__Related_Opportunity__c == oppId)
		{
		Apttus_Approval__Approval_Request_History__c approvalHisObj = new Apttus_Approval__Approval_Request_History__c();
		approvalHisObj.NF_Assignee_Type__c = approvalData.NF_Assignee_Type__c;
		approvalHisObj.Apttus_Approval__Assigned_To_Name__c = approvalData.Apttus_Approval__Assigned_To_Name__c;
		if(approvalHisObj.NF_Assignee_Type__c == CSWXGlobalConstant.StakeholderForInfo){
		 approvalHisObj.Apttus_Approval__Assigned_To_Name__c = CSWXGlobalConstant.NokiasCRM; 
		}
		if(approvalHisObj.Apttus_Approval__Assigned_To_Name__c == Null){
		 approvalHisObj.Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.NONE;
		 approvalHisObj.Apttus_Approval__Approver_Comments__c = approvalData.Apttus_Approval__Approver_Comments__c;
		}
		else{
		 approvalHisObj.Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.Notified;
		 approvalHisObj.Apttus_Approval__Approver_Comments__c = CSWXGlobalConstant.ApttusApprovalApproverComments+approvalHisObj.Apttus_Approval__Assigned_To_Name__c+' '+String.Valueof(System.now());
		}
		approvalHisObj.Apttus_Approval__Related_Opportunity__c = approvalData.Apttus_Approval__Related_Opportunity__c;
		approvalHisObj.Apttus_Approval__Step_Name__c = approvalData.Apttus_Approval__Step_Name__c;
		approvalHisObj.Apttus_Approval__Assigned_To_Type__c = approvalData.Apttus_Approval__Assigned_To_Type__c;
		approvalHisObj.Apttus_Approval__Active__c = approvalData.Apttus_Approval__Active__c;
		approvalHisObj.Apttus_Approval__Object_Id__c = approvalData.Apttus_Approval__Object_Id__c;
		approvalHisObj.Apttus_Approval__Object_Type__c = approvalData.Apttus_Approval__Object_Type__c;
		approvalHisObj.Apttus_Approval__RequestType__c = approvalData.Apttus_Approval__RequestType__c;
		approvalHisObj.Apttus_Approval__StepLabel__c = approvalData.Apttus_Approval__StepLabel__c;
		approvalHisObj.Apttus_Approval__Notify_Only__c = True;
		approvalHisObj.Apttus_Approval__Initial_Submitter__c = approvalData.Apttus_Approval__Initial_Submitter__c;
		approvalHisObj.Apttus_Approval__ProcessInstanceId__c = approvalProcessList[0].Id;
		approvalHisObj.Apttus_Approval__Date__c = System.now();
		approvalDataHistory.add(approvalHisObj);
		 
	
	}
	}
			Insert approvalDataHistory;
			
			system.debug('approvalDataList>>>'+approvalDataList);
			system.debug('approvalDataHistory>>>'+approvalDataHistory); 

		 List<Opportunity> OpptyUpdate= new List<Opportunity>();
			Set<Id> oppRecordTypes = new Set<Id> {directRecordTypeId, inDirectRecordTypeId};
	for(Opportunity opp:[select id,RecordTypeId,Apttus_Approval__Approval_Status__c,ApprovalStatusTechField__c,G2_Approval_Date__c,
	StageName,Phase_Status__c,G3_Approval_Date__c,Probability,SWx_Upsell_Proposal__c from Opportunity where id=:oppId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
	if(oppRecordTypes.contains(opp.RecordTypeId))
	{
		opp.Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.Approval_stage_approved;
		opp.ApprovalStatusTechField__c = CSWXGlobalConstant.G3ApproveStatus;
		opp.StageName = CSWXGlobalConstant.OFFERSTAGEFOROPPORTUNITY;
		opp.Phase_Status__c = CSWXGlobalConstant.OFFERINPROGRESS;
		opp.G3_Approval_Date__c = System.now();
		//Digital Sales Req Need
		
	}
	OpptyUpdate.add(opp);
			}
	System.debug('OpptyUpdateList>>>>'+OpptyUpdate);
			if(OpptyUpdate.size()>0)
	database.update(OpptyUpdate,false); 
		}
		
		
		catch(Exception ex){
			ExceptionHandler.addException(ex, IndirectCPQ_CreateOIFAndOffer.class.getName(),CSWXGlobalConstant.UpdateApprovalHistoryData);
		}
	}
}