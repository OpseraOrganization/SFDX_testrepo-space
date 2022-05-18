/*******************************
Class Name: DS_CreateOIFAndOffer
Created by: Accenture
Last modified by: Accenture
Description: This class will be used to create OIF and Offer
*******************************/

public with sharing class DS_CreateOIFAndOffer implements Queueable{
	private  List<Opportunity> opptyList;
	private static final Id directRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	private static final Id inDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
	
	/***************** Constructor ******************/
	public DS_CreateOIFAndOffer(List<Opportunity> tempOpptyList){
		this.opptyList= tempOpptyList;
	}
	
	
	/***************** Queueable context method ******************/
	public void execute(QueueableContext context) {
		system.debug('Inside Execute>>>>');
		createOIFandOfferonDigiSalesOpportunity(opptyList);
		
	}
	
	/*******************************
Method Name: createOIFandOfferonDigiSalesOpportunity
Description: This method will be used to create OIF and Offer
Parameter: List of Opportunities: opptyList
*******************************/
	public static void createOIFandOfferonDigiSalesOpportunity(List<Opportunity> opptyList){
		system.debug('Inside createOIFandOfferonDigiSalesOpportunity>>>>');
		system.debug('opptyList>>>>'+opptyList);
		Map<String, Id> keyToCalendar = new Map<String, Id>();
		List<Offer__c> offerList = new List<Offer__c>();
		List<Order_Intake_Forecast__c> orderIntakeList = new List<Order_Intake_Forecast__c>();
		Offer__c offer= new Offer__c();
		Order_Intake_Forecast__c orderIntake = new Order_Intake_Forecast__c();
		try{
			List<Opportunity>oppList = [SELECT id,name,SWx_Upsell_Proposal__r.Analytics_Source__c,SWx_Upsell_Proposal__r.Proposal_Recommendation_Type__c, //SWx_Upsell_Proposal__r.Expected_LoA_Level__c
	Stagename,CreatedDate, SWx_Upsell_Proposal__r.Unweighted_Value__c,SWx_Upsell_Proposal__r.Business_Line__c FROM Opportunity
	WHERE Id =:opptyList[0].id and SWx_Upsell_Proposal__c <> null and StageName =:  GlobalConstants.DEVELOP_OPPORTUNITY  and RecordType.DeveloperName =: CSWXGlobalConstant.DIRECTRECORDTYPEOPPORTUNITY
	LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			system.debug('createOIFoppList>>>'+oppList);
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
		Integer MonthIntCXM,YearInt,MonthIntCCRE,YearIntCCRE;
		String MonthStringCXM,YearString,MonthStringCCRE, keyCXM, keyCCRE,YearStringCCRE;
		Integer month =opp.CreatedDate.month();
		
		Datetime crdate1=opp.CreatedDate;
		crdate1=crdate1.addMonths(3);
		
		Datetime crdateCcre=opp.CreatedDate;
		crdateCcre=crdateCcre.addMonths(4);
		
		MonthIntCXM=crdate1.month();
		MonthIntCCRE=crdateCcre.month();
		YearInt=crdate1.year();
		YearIntCCRE=crdateCcre.year();
		
		MonthStringCXM=String.valueOf(MonthIntCXM);
		
		MonthStringCCRE=String.valueOf(MonthIntCCRE);
		YearStringCCRE=String.valueOf(YearIntCCRE);
		YearString=String.valueOf(YearInt);
		keyCXM = MonthStringCXM + YearString;
		
		keyCCRE = MonthStringCCRE + YearStringCCRE;
		Id Productforconvert = opp.SWx_Upsell_Proposal__r.Business_Line__c;
		// DSI-1252,Sprint 21 - Removed the analytic resource  dependency, added - opp.SWx_Upsell_Proposal__c != null
		//  if(opp.SWx_Upsell_Proposal__r.Analytics_Source__c == CSWXGlobalConstant.AnalyticsSource){
		System.debug('opp.SWx_Upsell_Proposal__c---->'+opp.SWx_Upsell_Proposal__c);
		if(opp.SWx_Upsell_Proposal__c != null ){
			if(opp.SWx_Upsell_Proposal__r.Business_Line__c <> Null){
	orderIntake.BusinessLine__c = Productforconvert;
			}
			else{
	orderIntake.BusinessLine__c = System.Label.SWXProductInfo;
			}
			orderIntake.Business_Group__c = CSWXGlobalConstant.BGOFFEROIF;
			orderIntake.Opportunity__c = opp.id;
			if(opp.SWx_Upsell_Proposal__r.Proposal_Recommendation_Type__c == CSWXGlobalConstant.SW_Recommendation){
	orderIntake.Software__c = CSWXGlobalConstant.HUNDRED;   
			}
			else if(opp.SWx_Upsell_Proposal__r.Proposal_Recommendation_Type__c == CSWXGlobalConstant.HW_Recommendation){
	orderIntake.Software__c = CSWXGlobalConstant.ZERO; 
			}
			else{
	orderIntake.Software__c = CSWXGlobalConstant.ZERO;
			}
			orderIntake.OIF_Value__c = CSWXGlobalConstant.ZERO;
			orderIntake.Forecast_Category__c = CSWXGlobalConstant.FORECASTCATEGORYOIF;
			orderIntake.POPlanReceipt__c = keyToCalendar.get(keyCXM);
			orderIntake.Rev_RecPlan_Receipt__c = keyToCalendar.get(keyCXM);
			orderIntake.Close_Date__c=system.today();
			orderIntakeList.add(orderIntake);
		}
		else{
			if(opp.SWx_Upsell_Proposal__r.Business_Line__c <> Null){
	orderIntake.BusinessLine__c = Productforconvert;
			}
			else{
	orderIntake.BusinessLine__c = System.Label.SWXProductInfoCCRE;
			}
			orderIntake.Business_Group__c = CSWXGlobalConstant.BGOFFEROIF;
			orderIntake.Opportunity__c = opp.id;
			orderIntake.Software__c = CSWXGlobalConstant.ZERO;
			orderIntake.OIF_Value__c = opp.SWx_Upsell_Proposal__r.Unweighted_Value__c;
			orderIntake.Forecast_Category__c = CSWXGlobalConstant.FORECASTCATEGORYOIF;
			orderIntake.POPlanReceipt__c = keyToCalendar.get(keyCCRE);
			orderIntake.Rev_RecPlan_Receipt__c = keyToCalendar.get(keyCCRE);
			orderIntake.Close_Date__c=system.today();
			orderIntakeList.add(orderIntake);
		}  
		offer.Name = CSWXGlobalConstant.OFFERNAMEAUTO+ opp.Name;
		offer.Opportunity__c = opp.id;
		DateTime dT = System.now();  
		Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
		offer.Customer_Offer_Due_Date__c = myDate;
		if(opp.SWx_Upsell_Proposal__c != null){
			offer.LOA_Bypass__c = CSWXGlobalConstant.NOLOA;
		}
		else{
			//offer.Expected_LoA_G4_Approval_Level__c = opp.SWx_Upsell_Proposal__r.Expected_LoA_Level__c; DSI-2237 Commented per request from Marta Freiri
			offer.LOA_Bypass__c = CSWXGlobalConstant.AuthorizedforPricingManager;
		}
		offerList.add(offer);
		System.debug('Optyy>>>>'+opp.SWx_Upsell_Proposal__r.Business_Line__c);
	}
	System.debug('The OIF is >>>>'+orderIntakeList);
	System.debug('The Offer is >>>>'+offerList);
	  insert offerList;
	insert orderIntakeList;
			}
			UpdateApprovalHistoryData(oppList[0].id);
		}
		catch(Exception ex){
			system.debug('ex>>>>'+ex);
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, CSWXGlobalConstant.createOIFandOfferonDigiSalesOpportunity);
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
			system.debug('oppId>>>'+oppId);
			List<Apttus_Approval__ApprovalProcessInstance__c> approvalProcessList = [SELECT Id, name,Apttus_Approval__PrevProcessInstanceId__c,Apttus_Approval__InstanceNumber__c,Apttus_Approval__BusinessObjectId__c
	FROM Apttus_Approval__ApprovalProcessInstance__c
	WHERE name like: CSWXGlobalConstant.G2ProcessId limit 1];
	
	System.debug('approvalProcessList-->'+approvalProcessList);
			List<Apttus_Approval__Approval_Request_History__c> approvalDataHistory = new List<Apttus_Approval__Approval_Request_History__c>();
			for(Apttus_Approval__Approval_Request__c approvalData:[SELECT id,Name,Apttus_Approval__StepNameLink__c,Apttus_Approval__Step_Name__c,
	Apttus_Approval__Request_Comments__c,Apttus_Approval__Assigned_To_Type__c,Apttus_Approval__Related_Opportunity__c,
	Apttus_Approval__ProcessInstanceId__c,Apttus_Approval__Approver_Comments__c,Apttus_Approval__StepSequenceString__c,
	NF_Assignee_Type__c,Apttus_Approval__Approval_Status__c,Apttus_Approval__Active__c,Apttus_Approval__Object_Id__c,Apttus_Approval__Object_Type__c,
	Apttus_Approval__StepLabel__c,Apttus_Approval__RequestType__c,Apttus_Approval__Notify_Only__c,Apttus_Approval__Initial_Submitter__c,Apttus_Approval__Assigned_To_Name__c,Apttus_Approval__Date__c
	FROM Apttus_Approval__Approval_Request__c where Apttus_Approval__Related_Opportunity__c=:oppId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
	  System.debug('approvalData---->'+approvalData);
		
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
		 approvalHisObj.Apttus_Approval__Approver_Comments__c = CSWXGlobalConstant.ApttusApprovalApproverComments + approvalHisObj.Apttus_Approval__Assigned_To_Name__c + CSWXGlobalConstant.space+String.Valueof(System.now());
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
		if(approvalProcessList[0].Id !=null){
		 approvalHisObj.Apttus_Approval__ProcessInstanceId__c = approvalProcessList[0].Id;
		}
		approvalHisObj.Apttus_Approval__Date__c = System.now();
		approvalDataHistory.add(approvalHisObj);
	}
			Insert approvalDataHistory;
			system.debug('approvalDataHistory>>>'+approvalDataHistory);
			if(!Test.isRunningTest()) {
	 Apttus_Approval.ApprovalsWebService.previewApprovals(CSWXGlobalConstant.OPPORTUNITY,oppId);
			}
			
			List<Opportunity> OpptyUpdate= new List<Opportunity>();
			Set<Id> oppRecordTypes = new Set<Id> {directRecordTypeId, inDirectRecordTypeId};
	for(Opportunity opp:[select id,RecordTypeId,Apttus_Approval__Approval_Status__c,ApprovalStatusTechField__c,G2_Approval_Date__c,
	StageName,Phase_Status__c,G3_Approval_Date__c,Probability,SWx_Upsell_Proposal__c from Opportunity where id=:oppId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
	if(oppRecordTypes.contains(opp.RecordTypeId) && opp.SWx_Upsell_Proposal__c <> null)
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
			if(OpptyUpdate.size()>0)
	database.update(OpptyUpdate,false);
		}
		
		
		catch(Exception ex){
			System.debug('ex--->'+ex);
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER,CSWXGlobalConstant.UpdateApprovalHistoryData);
		}
	}
}