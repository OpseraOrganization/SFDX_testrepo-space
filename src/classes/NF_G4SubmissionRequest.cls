/****************************************
 * Class Name : NF_G4SubmissionRequest 
 * Created Date: 24 Sep 2016
 * Created By : Accenture
 * Last Modified by:  
 * Last Modified Date:  
 * Description : Chatter Post to Oppty Owner, Offer,Opportunity Team Controllers
 * Test Class:  NF_G4SubmissionRequestTest
 *****************************************/


global class NF_G4SubmissionRequest implements Database.Batchable<sObject>, Database.Stateful,Schedulable  {

  Date todayDate =Date.Today();
	/********************
	*Method Name:execute 
	*Parameter:SchedulableContext SC
	*Description:Execute the bacth 
	*******************/
	
	 global void execute(SchedulableContext SC)
	 
	 {
	   NF_G4SubmissionRequest  batch= new NF_G4SubmissionRequest();
	   Database.executebatch(batch,10);
	 }
  
 

 /********************
  *Method Name:start
  *Parameter:Database.BatchableContext BC
  *Description:Collect the  today updated records
  *******************/

global Database.QueryLocator start(Database.BatchableContext BC) {

 
 
 
	return Database.getQueryLocator([select id,Customer_Offer_Due_Date__c,Opportunity__c,Opportunity__r.Name,Opportunity__r.Phase_Status__c,Opportunity__r.OwnerID,ActiveOffer__c from Offer__c where ActiveOffer__c=True AND  Customer_Offer_Due_Date__c<:todayDate AND  
					  (Opportunity__r.Phase_Status__c=:GlobalConstants.PLANNED OR Opportunity__r.Phase_Status__c=:GlobalConstants.SUBMITTED_FOR_G2_APPROVAL OR Opportunity__r.Phase_Status__c=:GlobalConstants.OPPORTUNITY_IN_PROGRESS OR Opportunity__r.Phase_Status__c=:GlobalConstants.SUBMITTED_FOR_G3_APPROVAL  OR Opportunity__r.Phase_Status__c=:GlobalConstants.OFFER_IN_PROGRESS ) ]);
						  
  }
  

 /********************
  *Method Name:execute
  *Parameter: BC,OifUpdate
  *Description:Sent the emails to users 
  *******************/

 global void execute(Database.BatchableContext BC, List<Offer__c>  OfferRec) {
	 
  Map<ID,Offer__c> OfferInfo =new Map<ID,Offer__c>();
  Map<ID,String> OpptyInfo =new Map<ID,String>();
  Map<ID,ID> Userinfo = new Map<ID,ID>();
  Map<ID,ID> OptyOfferID= new Map<ID,ID>();
  Map<ID,Date> Offerdate= new Map<ID,Date>();
  List<Task> TaskInsert =new List<Task>();
  Map<ID,ID> FinalUserinfo = new Map<ID,ID>();
	Map<ID,ID> OpptyTask = new Map<ID,ID>();
	Map<ID,Date> OfferDuedate= new Map<ID,Date>();

 
  List<Messaging.SingleEmailMessage> MailInfo = new List<Messaging.SingleEmailMessage>();
 try{
  
  for(Offer__c offerdata:OfferRec)
   {
	if(offerdata.Customer_Offer_Due_Date__c<>Null && offerdata.Customer_Offer_Due_Date__c<todayDate)
	 {
	 OfferInfo.put(offerdata.id,offerdata);
	 OptyOfferID.put(offerdata.Opportunity__c,offerdata.id);
	 Offerdate.put(offerdata.Opportunity__c,Date.ValueOf(offerdata.Customer_Offer_Due_Date__c));
	  OpptyInfo.put(offerdata.Opportunity__c,offerdata.Opportunity__r.Name);
	  
	 
		Userinfo.put(offerdata.Opportunity__c,offerdata.Opportunity__r.OwnerID);
		OfferDuedate.put(offerdata.Opportunity__c,offerdata.Customer_Offer_Due_Date__c );
	 }
   }
   
  
  // collecting the Active Task 
  
  for(Task TaskRec:[SELECT iD,Status,WhatId FROM Task where WhatID=:Userinfo.KeySet() and Subject=:GlobalConstants.MISSING_G4_SUBMISSION and Status=:GlobalConstants.Open Limit:Limits.getLimitQueryRows()])
  OpptyTask.put(TaskRec.WhatId,TaskRec.ID);
  
  System.debug('---Oppty TaskRec'+OpptyTask);
  
  for(ID OpptyID:Userinfo.KeySet())
  {
	 if(String.IsEmpty(OpptyTask.get(OpptyID)) && Userinfo.get(OpptyID)<>Null)
	 FinalUserinfo.put(OpptyID,Userinfo.get(OpptyID));
  
  }
  
  System.debug('Final USers List'+FinalUserinfo);
  
	// Chatter Post to users
	/* for(id OppId:FinalUserinfo.Keyset()) {
	   Task Taskinfo= new Task();
	  
		 String CommentsInfo='Missing G4 approval.'+GlobalConstants.SPACE+'Customer Offer Due Date expired on'+GlobalConstants.SPACE+String.ValueOf(Offerdate.get(OppId)).replaceall('00:00:00','')+GlobalConstants.SPACE+
					'for opportunity'+GlobalConstants.SPACE+OpptyInfo.get(OppId)+GlobalConstants.SPACE+' and was not submitted for Gate 4 approval. '+GlobalConstants.SPACE+
					'\n\n'+'Please, check the status of the Opportunity, and proceed accordingly.'+GlobalConstants.SPACE;
		System.debug('Start--'+FinalUserinfo.get(OppId)+Date.Today()+System.Today());
		
		Taskinfo.Subject=GlobalConstants.MISSING_G4_SUBMISSION;
		 
		 if(OfferDuedate.get(OppId)<>Null)
		 Taskinfo.ActivityDate=OfferDuedate.get(OppId);
		 Taskinfo.WhatId=OppId;
		 Taskinfo.OwnerId=FinalUserinfo.get(OppId);
		
		 Taskinfo.Status='Open';
		 Taskinfo.Priority='High';
		 Taskinfo.Description=CommentsInfo;
		  
		  Taskinfo.IsReminderSet=True;
		  
		   Database.DMLOptions dlo = new Database.DMLOptions();
			dlo.EmailHeader.triggerUserEmail = true; 
		   Taskinfo.setOptions(dlo);

		 TaskInsert.add(Taskinfo);	 
			   
			   
	 }*/
	 
		 
	 
	 if(!TaskInsert.isEmpty()){
	 List<Database.saveResult> TaskResult =Database.insert(TaskInsert,false);
	  System.debug('TaskResult--->'+TaskResult);
	  }
	 
   
	
 
   }
   catch (Exception ex) 
	{  ExceptionHandler.addException(ex, GlobalConstants.NF_G4SUBMISSION_REQUEST, GlobalConstants.BATCH_EXECUTE);
	
	 } 
 
 
 }
  /********************
  *Method Name:finish
  *Parameter:BC
  *Description:No Operation here 
  *******************/
  
  global void finish(Database.BatchableContext BC) {
  
  
  
  

  }
  
  
  
 
   
}