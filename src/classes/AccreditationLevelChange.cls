/****************************************
* Class Name : AccreditationLevelChange
* Created Date: June 2018
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 
* Description : Accreditation level chnage automation using Accreditation Level Rule custom setting
* Test Class: 
*****************************************/
public without sharing class AccreditationLevelChange{
	/********************
*Method Name: evaluteAccreditationForLevelChange
*Parameter: List<Accreditation__c>
*Description: Used to evaluate ACcreditation level against ruledefined
*******************/
	public static void evaluteAccreditationForLevelChange(
	List<Accreditation__c> eligibleaccred) {
		PRMGlobalConstants.accreditationAutomationRepricing = true;
		system.debug('in evaluteAccreditationForLevelChange method of AccredittaionLevelChange class >>>> ');
		map<ID, string> cuurrentLevel = new map<id, string>();
		map<ID, string> newLevel = new map<id, string>();
		map<ID, list<Accreditation_Level_Rule__c>> accredToRule = new map<ID, list<Accreditation_Level_Rule__c>>();
		map<id, id> accreditationAcc = new Map<id, id>();
		
		set<ID> accredUpdateSuccess = new set<ID>();
		list<Accreditation__c> accredToUpdate = new list<Accreditation__c>();
		list<Accreditation__c> accredToUpgrade = new list<Accreditation__c>();
		list<Accreditation__c> accredForQuoteRepricing = new list<Accreditation__c>();
		list<Accreditation__c> accredToDowngrade = new list<Accreditation__c>();
		list<Accreditation__c> accredAtSameLevel = new list<Accreditation__c>();
		list<Accreditation__c> manualUpdateAccred = new list<Accreditation__c>();
		Map<string, List<String>> marketLeadsEmails = new Map<string, List<String>>();
		list<Accreditation_Level_Rule__c> allrules = Database.query(PRMGlobalConstants.AccreLevelQuery1+ system.label.Accredittaion_Automation_certification_Job_Function + PRMGlobalConstants.AccreLevelQuery2);			
		for(PRM_Regional_Leads_per_Market__c reginalLeadsEmails : PRM_Regional_Leads_per_Market__c.getall().values()){
			list<String> allEmails = reginalLeadsEmails.Regional_Leads_Email__c.Split(PRMGlobalConstants.SemiColon);
			marketLeadsEmails.put(reginalLeadsEmails.name, allEmails);
		}
		//system.debug('marketLeadsEmails.....' +marketLeadsEmails);			
		//list<Accreditation__c> eligibleaccred = Database.query('select id, name, Accreditation_Level__c, Accreditation_Type__c, Evaluated_Accreditation__c, Manual_Accreditation_Level_Update__c, Market__c, Meets_Lab_Equipment_Requirements__c, Partner__c, Partner_Program__c, Partner_Type__c, Portfolio__c, Active_Contract_Types__c, Partner_Business_Plan_Status__c, Shift_Model__c, Third_Party_Screening__c, ' + system.label.Accredittaion_Automation_certification_Job_Function + ' from Accreditation__c where Evaluated_Accreditation__c = true');	
		system.debug('eligibleaccred ==== '+ eligibleaccred);	  
		try{
			for(Accreditation__c accred : eligibleaccred){
	cuurrentLevel.put(accred.id, accred.Accreditation_Level__c);
	accreditationAcc.put(accred.id, accred.Partner__c); 
			}
			system.debug('cuurrentLevel  ' + cuurrentLevel);
		 
			for(Accreditation__c accrerdit : eligibleaccred){	
	list<Accreditation_Level_Rule__c> matchingRules = new list<Accreditation_Level_Rule__c>();		
	for(Accreditation_Level_Rule__c rule :allrules){
		System.Debug('Acctrdit Rule'+rule);
		if(
			accrerdit.Geo_Level_1_Name__c != Null && accrerdit.Accreditation_Type__c != Null &&
			accrerdit.Partner_Program__c != Null &&accrerdit.Partner_Type__c != Null &&
			accrerdit.Shift_Model__c != Null && accrerdit.Portfolio__c != Null &&
			rule.Geo_Level_1_Name__c.contains(String.valueOf(accrerdit.Geo_Level_1_Name__c)) &&
			rule.Accreditation_Type__c.contains(String.valueOf(accrerdit.Accreditation_Type__c) )&&
			rule.Partner_Program__c.contains(String.valueOf(accrerdit.Partner_Program__c)) &&
			rule.Partner_Type__c.contains(String.valueOf(accrerdit.Partner_Type__c))&&
		(rule.Shift_Model__c == PRMGlobalConstants.NotApplicable || rule.Shift_Model__c.contains(String.valueOf(accrerdit.Shift_Model__c)))&&
			rule.Portfolio__c.contains(String.valueOf(accrerdit.Portfolio__c))){
	matchingRules.add(rule);
			}	 
	}
	system.debug('matchingRules == '+ matchingRules);
	accredToRule.put(accrerdit.id, matchingRules);
			}
			system.debug('accredToRule == '+ accredToRule);
			for(Accreditation__c accrerd : eligibleaccred){
	list<Accreditation_Level_Rule__c> mapRules = accredToRule.get(accrerd.id);
	system.debug('mapRules == '+ mapRules);
	for(Accreditation_Level_Rule__c rule : mapRules){
		Boolean HasSharedValue = FindSharedValue(accrerd.Active_Contract_Types__c,rule.Contract_Type__c);
		if(
			((accrerd.Active_Contract_Types__c != Null && rule.Contract_Type__c != Null && 
	 HasSharedValue == true) ||
	( rule.Contract_Type__c == Null)) &&
			((accrerd.Partner_Business_Plan_Status__c != Null && rule.Business_Plan_Status__c != Null && 
		rule.Business_Plan_Status__c.containsIgnoreCase(accrerd.Partner_Business_Plan_Status__c)) ||
	(rule.Business_Plan_Status__c == Null)) &&
			((accrerd.Third_Party_Screening__c != Null && rule.Third_Party_Screening__c != Null && 
		rule.Third_Party_Screening__c.containsIgnoreCase(accrerd.Third_Party_Screening__c)) ||
	(rule.Third_Party_Screening__c == Null))&&
			((accrerd.Meets_Lab_Equipment_Requirements__c && rule.Lab_Equipment_Requirements__c) ||
	(!rule.Lab_Equipment_Requirements__c))
			){  
			system.debug('In if rule for rule #  .. '+ rule.name + rule.id);
			boolean havecertifiedUsers = false;
			for(PRM_CertificationToAccreditation_Mapping__c cert : PRM_CertificationToAccreditation_Mapping__c.getAll().values()){
	IF(accrerd.get(cert.Accreditation_Field_API_Name__c) != Null &&
	(Integer.valueOf(accrerd.get(cert.Accreditation_Field_API_Name__c)) == Integer.valueOf(rule.get(cert.Accreditation_Field_API_Name__c)) ||
		Integer.valueOf(accrerd.get(cert.Accreditation_Field_API_Name__c)) > Integer.valueOf(rule.get(cert.Accreditation_Field_API_Name__c)))
		 ){
	havecertifiedUsers = true;
		 }
	else{
		havecertifiedUsers = false;
		break;
	}
			}
			system.debug('havecertifiedUsers .. '+ havecertifiedUsers);
			if(havecertifiedUsers){
	newLevel.put(accrerd.id, rule.Accreditation_Level__c);
	break;
			}
		}   
	}
			}
			system.debug('newLevel .. '+ newLevel);			
			for(Accreditation__c accr : eligibleaccred){
				Boolean skip = false;
	integer currentLevelRank;
		if(PRM_Accreditation_Level_Ranks__c.getinstance(cuurrentLevel.get(accr.id)) != null){
	 	currentLevelRank = Integer.valueOf(PRM_Accreditation_Level_Ranks__c.getinstance(cuurrentLevel.get(accr.id)).Rank__c);
		}
				else{
					skip = true;
				}
	if(newLevel.containsKey(accr.id) && !skip){
		integer newLevelRank =  Integer.valueOf(PRM_Accreditation_Level_Ranks__c.getinstance(newLevel.get(accr.id)).Rank__c);
		system.debug('newLevelRank --> ' + newLevelRank);
		system.debug('currentLevelRank --> ' + currentLevelRank);
		
		if(accr.Manual_Accreditation_Level_Update__c){
	accr.Evaluated_Accreditation_Level__c = newLevel.get(accr.id);
	accr.Last_Accreditation_Evaluation_Date__c = system.today();
	accr.Evaluated_Accreditation__c = false;
	manualUpdateAccred.add(accr);
		}
		else if((newLevel.get(accr.id) != cuurrentLevel.get(accr.id))&& 
		((newLevelRank < currentLevelRank) || ((newLevelRank > currentLevelRank) && accr.Downgrade_Grace_Period_End_Date__c == system.today()))){
		 
		 if(PRM_Markets_Accreditation_Level_Update__c.getall().containskey(accr.Geo_Level_1_Name__c)){
		 accr.Accreditation_Level__c = newLevel.get(accr.id);
		 accr.Accreditation_Date__c = system.today();
		 }
		 if(accr.Downgrade_Grace_Period_End_Date__c == system.today()){
		accr.Downgrade_Grace_Period_End_Date__c = null;
		 }
		 accr.Evaluated_Accreditation_Level__c = newLevel.get(accr.id);
		 accr.Last_Accreditation_Evaluation_Date__c = system.today();
		 accr.Evaluated_Accreditation__c = false;
		// accr.Downgrade_Grace_Period_End_Date__c =  null;
		 accr.Reason_for_Level_Change__c = PRMGlobalConstants.AccreditationLevelChangeReason_AutoUpdate;
		 accredToUpgrade.add(accr);
		}
		else if(newLevel.get(accr.id) != cuurrentLevel.get(accr.id) && newLevelRank > currentLevelRank){
			if(accr.Downgrade_Grace_Period_End_Date__c == Null){
			accr.Downgrade_Grace_Period_End_Date__c = system.today() + 90;
			}
			accr.Last_Accreditation_Evaluation_Date__c =  system.today();
			accr.Evaluated_Accreditation_Level__c = newLevel.get(accr.id);
			accr.Evaluated_Accreditation__c = false;
			accredToDowngrade.add(accr);
		}
		else{
			accr.Last_Accreditation_Evaluation_Date__c =  system.today();
			accr.Evaluated_Accreditation_Level__c = newLevel.get(accr.id);
			accr.Evaluated_Accreditation__c = false;
			accredAtSameLevel.add(accr);
		}		
	}
	else{
		accr.Evaluated_Accreditation__c = false;
		accredAtSameLevel.add(accr);
	}
			}
			accredToUpdate.addAll(accredToUpgrade);
			accredToUpdate.addAll(accredToDowngrade);
			accredToUpdate.addAll(manualUpdateAccred);
			accredToUpdate.addAll(accredAtSameLevel);
			system.debug('accredToUpgrade .. '+ accredToUpgrade);
			system.debug('accredToDowngrade .. '+ accredToDowngrade);
			system.debug('accredAtSameLevel .. '+ accredAtSameLevel);   
			
			
			if(!accredToUpdate.isEmpty()){
	List<Database.SaveResult> results = database.update(accredToUpdate,false);
	
	for (Database.SaveResult result : results) {
		if (result.isSuccess()){
			accredUpdateSuccess.add(result.getId());
		}
	}
			}
			
			for(Accreditation__c accr : accredToUpgrade){
	if(accredUpdateSuccess.contains(accr.id) && (accr.Pricing_Level_Override__c== Null ||  (accr.Pricing_Level_Override__c != Null && accr.Pricing_Override_Expiration__c < system.today()))){
		accredForQuoteRepricing.add(accr);
	}
			}  
			
			if(!accredForQuoteRepricing.isEmpty()){
	AccreditationLevelChange.quoteRepricing(accredForQuoteRepricing);
			}
			/*
			if(!manualUpdateAccred.isEmpty()){
	AccreditationLevelChange.sendEmailManualAccreditationUpdate(manualUpdateAccred, MarketLeadsEmails);
			}
			
			if(!accredToDowngrade.isEmpty()){
	AccreditationLevelChange.sendEmailAccreditationLevelDowngarde(accredToDowngrade, MarketLeadsEmails);
			}  */
			
			
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.AccreditationLevelChange,PRMGlobalConstants.evaluteAccreditationForLevelChange);}	
	}
	
		/********************
*Method Name: QuoteRepricing
*Parameter: list<Accreditation__c> accredForRepricing
*Description: Used to update quote for repricing
*******************/
	public static void quoteRepricing(list<Accreditation__c> accredForRepricing) {		 
		try{
			set<id> quoteAccID = new set<id>();
			list<Apttus_Proposal__Proposal__c> quotesToUpdate = new list<Apttus_Proposal__Proposal__c>();
			map<id, map<string, list<Apttus_Proposal__Proposal__c>>> quoteMap =  new map<id, map<string, list<Apttus_Proposal__Proposal__c>>>();
			
			for(Accreditation__c accred : accredForRepricing){
	quoteAccID.add(accred.partner__C);
			}
			
			list<Apttus_Proposal__Proposal__c> allQuotes = [SELECT Id,NokiaCPQ_Needs_Reprice__c, NokiaCPQ_Portfolio__c, Apttus_Proposal__Account__c 
			FROM Apttus_Proposal__Proposal__c where Apttus_Proposal__Account__c in: quoteAccID 
			Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];
			for(Apttus_Proposal__Proposal__c quote : [SELECT Id,NokiaCPQ_Needs_Reprice__c, NokiaCPQ_Portfolio__c, Apttus_Proposal__Account__c FROM Apttus_Proposal__Proposal__c where Apttus_Proposal__Account__c in: quoteAccID Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]) {
	list<Apttus_Proposal__Proposal__c> quotelist = new list<Apttus_Proposal__Proposal__c>();
	map<string, list<Apttus_Proposal__Proposal__c>> porttoQuote = new map<string, list<Apttus_Proposal__Proposal__c>>();
	if(quoteMap.containsKey(quote.Apttus_Proposal__Account__c)){
		if(quoteMap.get(quote.Apttus_Proposal__Account__c).containsKey(quote.NokiaCPQ_Portfolio__c)){
			quotelist = quoteMap.get(quote.Apttus_Proposal__Account__c).get(quote.NokiaCPQ_Portfolio__c);
		}
	}
	quotelist.add(quote);
	if(quoteMap.containsKey(quote.Apttus_Proposal__Account__c)){
		porttoQuote = quoteMap.get(quote.Apttus_Proposal__Account__c);
	}
	porttoQuote.put(quote.NokiaCPQ_Portfolio__c, quotelist);
	quoteMap.put(quote.Apttus_Proposal__Account__c, porttoQuote);
	
			}
			
			//system.debug(quoteMap);
			
			for(Accreditation__c accr : accredForRepricing){
		quotesToUpdate.addall(quoteMap.get(accr.partner__C).get(accr.Portfolio__c));	
			} 
			
			for(Apttus_Proposal__Proposal__c quotereprice : quotesToUpdate){
	quotereprice.NokiaCPQ_Needs_Reprice__c = true;
			}
			
			database.update(quotesToUpdate,false);
			
	
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.Quote_repricing,PRMGlobalConstants.Quote_repricing);}	
	}
	
	/********************
*Method Name: SendEmailManualAccreditationUpdate
*Parameter: newContractList, Old Contract Map
*Description: Used to handle after Update activities
*******************/
  /*  public static void sendEmailManualAccreditationUpdate(list<Accreditation__c> manualAccred, Map<string, List<String>> MarketLeadsEmails ) {		 
		try{	
			List<Messaging.SingleEmailMessage> messages =   new List<Messaging.SingleEmailMessage>();
			for(Accreditation__c accred : manualAccred){	
	Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
	//message.setTemplateId('');
	//sendTo =
	String msgBody = PRMGlobalConstants.manualAccreMsg1+ accred.name + PRMGlobalConstants.manualAccreMsg2;
	msgBody = msgBody + PRMGlobalConstants.accNameText+ accred.Partner__r.name + 
		PRMGlobalConstants.spaceLine + PRMGlobalConstants.spaceLine + 
		PRMGlobalConstants.accreName + accred.name +  PRMGlobalConstants.spaceLine + PRMGlobalConstants.spaceLine + 
		PRMGlobalConstants.accrePortfolio +  accred.Portfolio__c +PRMGlobalConstants.spaceLine
		+ PRMGlobalConstants.spaceLine + PRMGlobalConstants.currentLevel +  accred.Accreditation_Level__c  
		+ PRMGlobalConstants.spaceLine + PRMGlobalConstants.spaceLine + PRMGlobalConstants.spaceLine + PRMGlobalConstants.Thanks;
	//message.toAddresses = new String[] { 'sonali.j.kothaval@accenture.com', 'kothavale.sonali@gmail.com' }; 
	message.toAddresses = MarketLeadsEmails.get(accred.Market__c);
	message.optOutPolicy = PRMGlobalConstants.emailOptOutPolicy_Filter;
	// message.OrgWideEmailAddressId = Label.OrgwideEmailID;
	message.OrgWideEmailAddressId = Label.PRM_Nokia_Partner_Global_Communication_Email;
	message.plainTextBody = msgBody;
	message.subject = PRMGlobalConstants.manualAccreSubject1 + accred.name + PRMGlobalConstants.manualAccreSubject2;	
	messages.add(message);	
			}
			Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
			
			if (results[0].success) {
	System.debug('The email was sent successfully.');
			} 
			else {
	System.debug('The email failed to send: ' + results[0].errors[0].message);
			}
		}
		catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.AccreditationLevelChange,PRMGlobalConstants.SendEmailManualAccreditationUpdate);}
	}*/
	
	/********************
*Method Name: SendEmailAccreditationLevelDowngarde
*Parameter: newContractList, Old Contract Map
*Description: Used to handle after Update activities
*******************/
   /* public static void sendEmailAccreditationLevelDowngarde(list<Accreditation__c> downgradeLevelAccred, Map<string, List<String>> MarketLeadsEmails ) { 
		
		try{	
			List<Messaging.SingleEmailMessage> messages =   new List<Messaging.SingleEmailMessage>();
			for(Accreditation__c accred : downgradeLevelAccred){
	Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
	//message.setTemplateId('');
	//sendTo =
	String msgBody = PRMGlobalConstants.downgradeMsg1+ accred.name + PRMGlobalConstants.downgradeMsg2;
	msgBody = msgBody + PRMGlobalConstants.accNameText+ accred.Partner__r.name + PRMGlobalConstants.spaceLine + PRMGlobalConstants.spaceLine + 
		PRMGlobalConstants.accreName + accred.name +  PRMGlobalConstants.spaceLine + PRMGlobalConstants.spaceLine 
		+ PRMGlobalConstants.Portfolio +  accred.Portfolio__c + PRMGlobalConstants.spaceLine + PRMGlobalConstants.spaceLine
		+ PRMGlobalConstants.currentLevel +  accred.Accreditation_Level__c +PRMGlobalConstants.spaceLine + PRMGlobalConstants.spaceLine 
		+ PRMGlobalConstants.levelDowngradeDate +  accred.Downgrade_Grace_Period_End_Date__c 
		+  PRMGlobalConstants.spaceLine + PRMGlobalConstants.spaceLine + PRMGlobalConstants.spaceLine + PRMGlobalConstants.ThanksText;
	message.toAddresses = MarketLeadsEmails.get(accred.Market__c);
	message.optOutPolicy = PRMGlobalConstants.emailOptOutPolicy_Filter;
	// message.OrgWideEmailAddressId = Label.OrgwideEmailID;
	message.OrgWideEmailAddressId = Label.PRM_Nokia_Partner_Global_Communication_Email;
	message.plainTextBody = msgBody;
	message.subject = accred.name + PRMGlobalConstants.downgradeSubject;	
	messages.add(message);	
			}
			Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);			
			if (results[0].success) {
	System.debug('The email was sent successfully.');
			} 
			else {
	System.debug('The email failed to send: ' + results[0].errors[0].message);
			}
		}
		catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.AccreditationLevelChange,PRMGlobalConstants.SendEmailAccreditationLevelDowngarde);}
	}  */
	/********************
*Method Name: setAccrdRuleLevelRank
*Parameter: list<Accreditation_Level_Rule__c> accredLevelRuleChange
*Description: Used to update leel renk when new rule is added or exting rule ACcreditation level is changed
*******************/
	public static void setAccrdRuleLevelRank(list<Accreditation_Level_Rule__c> accredLevelRuleChange){
		try{
			List<PRM_Accreditation_Level_Ranks__c> levelChange = PRM_Accreditation_Level_Ranks__c.getall().values();
			List<Accreditation_Level_Rule__c> accredRuleToUpdate = new List<Accreditation_Level_Rule__c>();
			accredRuleToUpdate= [select id,Accreditation_Level__c,Level_Rank__c from Accreditation_Level_Rule__c where Id In: accredLevelRuleChange Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];
			//System.debug(':::::accredRuleToUpdate.new::::::: ' + accredRuleToUpdate);
			for(Accreditation_Level_Rule__c rule :accredRuleToUpdate)
			{
	rule.Level_Rank__c = PRM_Accreditation_Level_Ranks__c.getValues(rule.Accreditation_Level__c).Rank__c;
	
			} //System.debug('beforeupdate '+ accredRuleToUpdate);
			database.update(accredRuleToUpdate,false);
			//System.debug('afterupdate '+ accredRuleToUpdate);
		}catch(Exception e) {ExceptionHandler.addException(e,PRMGlobalConstants.AccreditationLevelChange,PRMGlobalConstants.setAccrdRuleLevelRank);}
		
	}
	
	public static boolean FindSharedValue(String accrecord, String accrulerecord) {
  	
		if(accrecord != Null && accrulerecord != Null){
		for(String accrecordins : accrecord.split(';')) {
			if(accrulerecord.contains(accrecordins))
			   {
				 return true;  
			   }
	  	}
		}
	return false;
}
	   
	   
}