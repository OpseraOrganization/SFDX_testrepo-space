public with sharing class NF_BypassPreviewAndSubmitCtrl {
	public String currentOppId {get;set;}
	public String GateInfo{get;set;}
	public String Gatecheck;
	public Opportunity currentOpp {get;set;}
	public Boolean ErrorCheck {get;set;}
	public Boolean ShowSubmitButtion {get;set;}
	public Boolean G3 {get;set;}
	public Offer__c offer{get;set;}
	public NF_BypassPreviewAndSubmitCtrl() {
		system.debug('in NF_BypassPreviewAndSubmitCtrl constructor************');
		G3 = False;
		offer = null;
		currentOppId = ApexPages.currentPage().getParameters().get('oppId');
		Gatecheck=ApexPages.currentPage().getParameters().get('GateClass');
		ErrorCheck=True;
		if(!Gatecheck.contains('Contract')){
			GateInfo='You are  about to bypass gate '+Gatecheck+' and move the opportunity to the next phase.';
			if(Gatecheck.contains('G3')){
	G3=True;
	setFields();
			}
		}
		else{
			if(Gatecheck.contains('Contract'))
	GateInfo='You are about to bypass G5 - Contract Approval and move the opportunity to G5 - Win/Loss Declaration.';
		}
		
	}
	
	public void setFields(){
		for(Opportunity opptyFields:[SELECT id,G3_Planned_Date__c,G4_Planned_Date__c,G5_Planned_Date__c FROM Opportunity WHERE id=:currentOppId]){
			currentOpp = opptyFields;
		}
		for(Offer__c offerFields:[SELECT Id, Budgetary_non_binding__c FROM Offer__c WHERE Opportunity__c=:currentOppId AND ActiveOffer__c = TRUE]){
			offer = offerFields;
		}
	}
	
	/**
*   @desc : this method is used to redirect to the approvalPreview&Submit directly in the opportunity is already in Pending Approvals.
*   @return :	PageReference
*/
	public PageReference init(){
		if(G3 && offer == null){//In case it wasn't created an offer at oppty creation
			ErrorCheck=True;
			ShowSubmitButtion=false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please create an active offer to proceed' ));
			return Null;
		}
		PageReference myPage = null;
		ShowSubmitButtion=True;
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Gate Bypass Submission' ));
		return Null;
	}
	/**
*   @desc : this method is used to redirect to the approvalPreview&Submit directly in the opportunity is already in Pending Approvals.
*   @return :	PageReference
*/
	public PageReference Submit(){
		List<Opportunity> ProbUpdate=new List<Opportunity>();
		Savepoint sp = null;
		Try{
			sp = Database.setSavepoint();
			ShowSubmitButtion=false;
			for(Opportunity Opptyupdate:[select id,Probability,Is_Automated__c,Calculating_Probability__c from opportunity where id=:currentOppId])
			{
	Opptyupdate.Calculating_Probability__c=Opptyupdate.Probability;
	ProbUpdate.add(Opptyupdate);
			}
			if(ProbUpdate.size()>0)
	Database.update(ProbUpdate,false);
			System.debug(Gatecheck);
			if(GlobalConstants.GATE_G2.equalsIgnoreCase(Gatecheck)){
	Opportunity opp= [Select StageName,Phase_Status__c from Opportunity where id=:currentOppId Limit 1];
	System.debug(opp);
	if(GlobalConstants.IDENTIFY_OPPORTUNITY.equalsIgnoreCase(opp.StageName) && GlobalConstants.PLANNED.equalsIgnoreCase(opp.Phase_Status__c)){
		Apttus_Approval.ApprovalsWebService.submitForApprovals('Opportunity', currentOppId);
	}
			}else{
	Apttus_Approval.ApprovalsWebService.submitForApprovals('Opportunity', currentOppId);
			} //Adding if else to prevent several click on button/G3 facilitator by pass issue Done by Fitch SDC
			//Apttus_Approval.ApprovalsWebService.submitForApprovals('Opportunity', currentOppId);
			saveRecords();
			return new PageReference('/'+currentOppId);
			
		}
		catch(DmlException  exc){
			if(sp != null) Database.rollback(sp);
			ErrorCheck=True;
			ShowSubmitButtion=false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,exc.getDmlMessage(0)) );
			return null;
		}
		catch(Exception E){
			if(sp != null) Database.rollback(sp);
			ErrorCheck=True;
			ShowSubmitButtion=false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,E.getMessage()) );
			//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The Gate Planned Date entered is either blank, in the past, precedes the date entered for the previous gate or exceeds the date entered for the following gate'));
			return null;
		}
	}
	
	public void saveRecords(){
		if(G3){
			UPDATE currentOpp;
			UPDATE offer;
		}
	}
	
	
	/**
*   @description : Method used to redirect back to the opportunity
*   @return : PageReference
*/
	public PageReference cancel() {
		return new PageReference('/'+currentOppId);
	}
	
}