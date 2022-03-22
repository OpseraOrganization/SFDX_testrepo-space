public with sharing class NF_BypassPreviewAndSubmitCtrl {
	
 
   
	public String currentOppId {get;set;}
	 public String GateInfo{get;set;}
	 Public String Gatecheck;
	
	
   

	 public Opportunity currentOpp {get;set;}
	Public Boolean ErrorCheck {get;set;}
	 Public Boolean ShowSubmitButtion {get;set;}
	public NF_BypassPreviewAndSubmitCtrl() {
		system.debug('in NF_BypassPreviewAndSubmitCtrl constructor************');
		currentOppId = ApexPages.currentPage().getParameters().get('oppId');
		Gatecheck=ApexPages.currentPage().getParameters().get('GateClass');
		   ErrorCheck=True;
		 
		 if(!Gatecheck.contains('Contract'))
		 GateInfo='You are  about to bypass gate '+Gatecheck+' and move the opportunity to the next phase.';
		 else
		 if(Gatecheck.contains('Contract'))
		 GateInfo='You are about to bypass G5 - Contract Approval and move the opportunity to G5 - Win/Loss Declaration.';
		 
	   
	   
	}
	
	  /**
	*   @desc : this method is used to redirect to the approvalPreview&Submit directly in the opportunity is already in Pending Approvals.
	*   @return :	PageReference
	*/
	public PageReference init(){
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
		  
		  
		   return new PageReference('/'+currentOppId);

	  }
	catch(Exception E){
	   if(sp != null) Database.rollback(sp);
	ErrorCheck=True;
	ShowSubmitButtion=false;
	  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,E.getMessage()) );
	  return null;
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