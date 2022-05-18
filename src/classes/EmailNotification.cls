/*******************************
  *Class name: EmailNotification
  *Description: This Method will send mail on approved/Reject support to otm
  *Parameter: Opportunity Values
  *******************************/  
public without sharing class EmailNotification {
  private static string partner_email_community_URL = System.Label.partner_email_community_URL;
   /*******************************
  *Method name: sendMails
  *Description: This Method will send mail on conversion to OTM
  *Parameter: Opportunity Values
  *******************************/  
  public static void sendMails(List<Id> lstId, opportunity opp, List<OpportunityTeamMember> otm, Map<id,String> userIdToNameMap){
  try{ 
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  for(OpportunityTeamMember otmInstance : otm){
  Messaging.SingleEmailMessage mail =  getSingleEmailMessage();
  mail.setTargetObjectId(otmInstance.userId); 
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  mail.setSenderDisplayName(PRMGlobalConstants.NokiaTeam);
  mail.setSaveAsActivity(false); 
  mail.subject = PRMGlobalConstants.Convert;
  mail.plainTextBody = PRMGlobalConstants.Dear + userIdToNameMap.get(otmInstance.userId)  + PRMGlobalConstants.comma + PRMGlobalConstants.NextLine +
  PRMGlobalConstants.Convert +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.OpptyName + opp.Name +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.LinkforPartner +PRMGlobalConstants.NextLine  
  +partner_email_community_URL +'/s/' +PRMGlobalConstants.Opportunity +Opp.Id +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine  + 
  PRMGlobalConstants.Thanks +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.NokiaTeam;
  //List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  mailList.add(mail);
  //Messaging.sendEmail( mailList);
  }
  Messaging.sendEmail( mailList);
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.LeadToOpptyConversionMail,PRMGlobalConstants.getCurrentUser);
  
  }
  
  }

   /*******************************
  *Method name: sendMailsOnSupportRequestApproved
  *Description: This Method will send mail on Slaes Support Approved
  *Parameter: Opportunity Values
  *******************************/  
  public static void sendMailsOnSupportRequestApproved(List<Id> lstId, opportunity opp, List<OpportunityTeamMember> otm){
  try{
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  for(OpportunityTeamMember otmInstance : otm){
  Messaging.SingleEmailMessage mail =  getSingleEmailMessage();
  mail.setTargetObjectId(otmInstance.userId); 
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  mail.setSenderDisplayName(PRMGlobalConstants.NokiaTeam);
  mail.setSaveAsActivity(false); 
  mail.subject = PRMGlobalConstants.SubjectSales;
  mail.plainTextBody = PRMGlobalConstants.Dear + otmInstance.Name  + PRMGlobalConstants.comma + PRMGlobalConstants.NextLine +
  PRMGlobalConstants.SalesApproved+PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.OpptyName + opp.Name +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.LinkforPartner +PRMGlobalConstants.NextLine  
  +partner_email_community_URL +PRMGlobalConstants.Opportunity +Opp.Id +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine  + 
  PRMGlobalConstants.Thanks +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.NokiaTeam;
  //List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  mailList.add(mail);
  //Messaging.sendEmail( mailList);
  }
  Messaging.sendEmail( mailList);
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.SalesSupportMessage,PRMGlobalConstants.getCurrentUser);
  
  }
  
  }

   /*******************************
  *Method name: sendMailsOnSupportRequestDeclined
  *Description: This Method will send mail on Sales Support Reject
  *Parameter: Opportunity Values
  *******************************/  
  public static void sendMailsOnSupportRequestDeclined(List<Id> lstId, opportunity opp, List<OpportunityTeamMember> otm){
  try{
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  for(OpportunityTeamMember otmInstance : otm){
  Messaging.SingleEmailMessage mail =  getSingleEmailMessage();
  mail.setTargetObjectId(otmInstance.userId); 
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  mail.setSenderDisplayName(PRMGlobalConstants.NokiaTeam);
  mail.setSaveAsActivity(false); 
  mail.subject = PRMGlobalConstants.SubjectSalesReject;
  mail.plainTextBody = PRMGlobalConstants.Dear + otmInstance.Name  + PRMGlobalConstants.comma + PRMGlobalConstants.NextLine +
  PRMGlobalConstants.SalesRejected+PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.OpptyName + opp.Name +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.LinkforPartner +PRMGlobalConstants.NextLine  
  +partner_email_community_URL +PRMGlobalConstants.Opportunity +Opp.Id +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine  + 
  PRMGlobalConstants.Thanks +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.NokiaTeam;
  //List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  mailList.add(mail);
  //Messaging.sendEmail( mailList);
  }
  Messaging.sendEmail( mailList);
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.SalesSupportMessage,PRMGlobalConstants.getCurrentUser);
   
  }
  }

   /*******************************
  *Method name: sendMailsOnOtherSupportRequestApproved
  *Description: This Method will send mail on Other Support Approved
  *Parameter: Opportunity Values
  *******************************/   
  public static void sendMailsOnOtherSupportRequestApproved(List<Id> lstId, opportunity opp, List<OpportunityTeamMember> otm){
  try{
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  for(OpportunityTeamMember otmInstance : otm){
  Messaging.SingleEmailMessage mail =  getSingleEmailMessage();
  mail.setTargetObjectId(otmInstance.userId); 
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  mail.setSenderDisplayName(PRMGlobalConstants.NokiaTeam);
  mail.setSaveAsActivity(false); 
  mail.subject = PRMGlobalConstants.SubjectOther;
  mail.plainTextBody = PRMGlobalConstants.Dear + otmInstance.Name  + PRMGlobalConstants.comma + PRMGlobalConstants.NextLine +
  PRMGlobalConstants.OtherApproved+PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.OpptyName + opp.Name +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.LinkforPartner +PRMGlobalConstants.NextLine  
  +partner_email_community_URL +PRMGlobalConstants.Opportunity +Opp.Id +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine  + 
  PRMGlobalConstants.Thanks +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.NokiaTeam;
  //List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  mailList.add(mail);
  //Messaging.sendEmail( mailList);
  
  }
  Messaging.sendEmail( mailList);
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.OtherSupportMessage,PRMGlobalConstants.getCurrentUser);
   
  }
  
  }

   /*******************************
  *Method name: sendMailsOnOtherSupportRequestDeclined
  *Description: This Method will send mail on Other Support Rejected
  *Parameter: Opportunity Values
  *******************************/   
  public static void sendMailsOnOtherSupportRequestDeclined(List<Id> lstId, opportunity opp, List<OpportunityTeamMember> otm){
  try{
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  for(OpportunityTeamMember otmInstance : otm){
  Messaging.SingleEmailMessage mail =  getSingleEmailMessage();
  mail.setTargetObjectId(otmInstance.userId); 
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  mail.setSenderDisplayName(PRMGlobalConstants.NokiaTeam);
  mail.setSaveAsActivity(false); 
  mail.subject = PRMGlobalConstants.SubjectOtherReject;
  mail.plainTextBody = PRMGlobalConstants.Dear + otmInstance.Name  + PRMGlobalConstants.comma + PRMGlobalConstants.NextLine +
  PRMGlobalConstants.OtherRejected+PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.OpptyName + opp.Name +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.LinkforPartner +PRMGlobalConstants.NextLine  
  +partner_email_community_URL +PRMGlobalConstants.Opportunity +Opp.Id +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine  + 
  PRMGlobalConstants.Thanks +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.NokiaTeam;
  //List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  mailList.add(mail);
  //Messaging.sendEmail( mailList);
  
  }
  Messaging.sendEmail( mailList);
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.OtherSupportMessage,PRMGlobalConstants.getCurrentUser);
   
  }
  
  }

   /*******************************
  *Method name: sendMailsOnPricingSupportRequestApproved
  *Description: This Method will send mail on Pricing Support Approved
  *Parameter: Opportunity Values
  *******************************/  
  public static void sendMailsOnPricingSupportRequestApproved(List<Id> lstId, opportunity opp, List<OpportunityTeamMember> otm){
  try{
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  for(OpportunityTeamMember otmInstance : otm){
  Messaging.SingleEmailMessage mail =  getSingleEmailMessage();
  mail.setTargetObjectId(otmInstance.userId); 
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  mail.setSenderDisplayName(PRMGlobalConstants.NokiaTeam);
  mail.setSaveAsActivity(false); 
  mail.subject = PRMGlobalConstants.SubjectPricing;
  mail.plainTextBody = PRMGlobalConstants.Dear + otmInstance.Name  + PRMGlobalConstants.comma + PRMGlobalConstants.NextLine +
  PRMGlobalConstants.PricingApproved+PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.OpptyName + opp.Name +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.LinkforPartner +PRMGlobalConstants.NextLine  
  +partner_email_community_URL +PRMGlobalConstants.PRMcommunityURLExt +PRMGlobalConstants.Opportunity +Opp.Id +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine  + 
  PRMGlobalConstants.Thanks +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.NokiaTeam;
  //List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  mailList.add(mail);
  //Messaging.sendEmail( mailList);
  
  }
  Messaging.sendEmail( mailList);
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.PricingSupportMessage,PRMGlobalConstants.getCurrentUser);
   
  }
  
  }

   /*******************************
  *Method name: sendMailsOnPricingSupportRequestDeclined
  *Description: This Method will send mail on Pricing Support Reject
  *Parameter: Opportunity Values
  *******************************/  
  public static void sendMailsOnPricingSupportRequestDeclined(List<Id> lstId, opportunity opp, List<OpportunityTeamMember> otm){
  try{
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  for(OpportunityTeamMember otmInstance : otm){
  Messaging.SingleEmailMessage mail =  getSingleEmailMessage();
  mail.setTargetObjectId(otmInstance.userId); 
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  mail.setSenderDisplayName(PRMGlobalConstants.NokiaTeam);
  mail.setSaveAsActivity(false); 
  mail.subject = PRMGlobalConstants.SubjectPricingReject;
  mail.plainTextBody = PRMGlobalConstants.Dear + otmInstance.Name  + PRMGlobalConstants.comma +PRMGlobalConstants.NextLine +
  PRMGlobalConstants.PricingRejected +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.OpptyName + opp.Name +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.LinkforPartner +PRMGlobalConstants.NextLine  
  +partner_email_community_URL +PRMGlobalConstants.Opportunity +Opp.Id +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine  + 
  PRMGlobalConstants.Thanks +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.NokiaTeam;
  
  mailList.add(mail);
  
  }
  Messaging.sendEmail( mailList);
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.PricingSupportMessage,PRMGlobalConstants.getCurrentUser);
   
  }
  
  }

   /*******************************
  *Method name: sendMailsOnTechnicalSupportRequestApproved
  *Description: This Method will send mail on Technical Support Approved
  *Parameter: Opportunity Values
  *******************************/   
  public static void sendMailsOnTechnicalSupportRequestApproved(List<Id> lstId, opportunity opp, List<OpportunityTeamMember> otm){
  try{
  
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  for(OpportunityTeamMember otmInstance : otm){
  Messaging.SingleEmailMessage mail =  getSingleEmailMessage();
  mail.setTargetObjectId(otmInstance.userId); 
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  mail.setSenderDisplayName(PRMGlobalConstants.NokiaTeam);
  mail.setSaveAsActivity(false); 
  mail.subject = PRMGlobalConstants.SubjectTechnical;
  mail.plainTextBody = PRMGlobalConstants.Dear + otmInstance.Name  + PRMGlobalConstants.comma + PRMGlobalConstants.NextLine +
  PRMGlobalConstants.TechnicalApproved+PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.OpptyName + opp.Name +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.LinkforPartner +PRMGlobalConstants.NextLine  
  +partner_email_community_URL +PRMGlobalConstants.Opportunity +Opp.Id +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine  + 
  PRMGlobalConstants.Thanks +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.NokiaTeam;
  mailList.add(mail);
  
  
  }
  Messaging.sendEmail( mailList);
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.TechnicalSupportMessage,PRMGlobalConstants.getCurrentUser);
   
  }
  
  }

   /*******************************
  *Method name: sendMailsOnTechnicalSupportRequestDeclined
  *Description: This Method will send mail on Technical Support Decline
  *Parameter: Opportunity Values
  *******************************/  
  public static void sendMailsOnTechnicalSupportRequestDeclined(List<Id> lstId, opportunity opp, List<OpportunityTeamMember> otm){
  try{
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  for(OpportunityTeamMember otmInstance : otm){
  Messaging.SingleEmailMessage mail = getSingleEmailMessage();
  mail.setTargetObjectId(otmInstance.userId); 
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  mail.setSenderDisplayName(PRMGlobalConstants.NokiaTeam);
  mail.setSaveAsActivity(false); 
  mail.subject = PRMGlobalConstants.SubjectTechnicalReject;
  mail.plainTextBody = PRMGlobalConstants.Dear + otmInstance.Name  + PRMGlobalConstants.comma + PRMGlobalConstants.NextLine +
  PRMGlobalConstants.TechnicalRejected+PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.OpptyName + opp.Name +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.LinkforPartner +PRMGlobalConstants.NextLine  
  +partner_email_community_URL +PRMGlobalConstants.Opportunity +Opp.Id +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine  + 
  PRMGlobalConstants.Thanks +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.NokiaTeam;
  mailList.add(mail);
  
  }  
  Messaging.sendEmail( mailList);
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.TechnicalSupportMessage,PRMGlobalConstants.getCurrentUser);
   
  }
  }
   /*******************************
  *Method name: sendMailstoPRMs
  *Description: This Method will send mail to PRMs for rebate form
  *Parameter: Opportunity Values
  *******************************/  
  public static void sendMailsToPRM( List<Account_Member__c> accountMemberList, rebate_period__c period){
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  try{
  string rebate_Form_Link = System.Label.Rebate_Form_Link;
  for(Account_Member__c accountMember : accountMemberList){
  Messaging.SingleEmailMessage mail = getSingleEmailMessage();
  mail.setTargetObjectId(accountMember.Name__c); 
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  // mail.setSenderDisplayName(PRMGlobalConstants.NokiaTeam);
  mail.setOrgWideEmailAddressId(system.Label.Nokia_Global_Partner_CommunicationsID);
  mail.setSaveAsActivity(false); 
  mail.subject = PRMGlobalConstants.NokiaRebateProgram;
  mail.plainTextBody = PRMGlobalConstants.Dear + PRMGlobalConstants.NokiaPartner  + PRMGlobalConstants.comma + PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NextLine +PRMGlobalConstants.EnrollmentEmailBody0  +PRMGlobalConstants.NextLine +PRMGlobalConstants.NextLine
  +PRMGlobalConstants.EnrollmentEmailBody1 +PRMGlobalConstants.NextLine  
  +rebate_Form_Link +PRMGlobalConstants.NextLine +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.EnrollmentEmail0 +period.Name +PRMGlobalConstants.EnrollmentEmail1 +period.Enrollment_End_Date_Formula__c
  +PRMGlobalConstants.NextLine +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.EnrollmentEmailBody2 +PRMGlobalConstants.NextLine +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.EnrollmentEmail2 +period.Name +PRMGlobalConstants.EnrollmentEmail3 +PRMGlobalConstants.NextLine +PRMGlobalConstants.NextLine
  +PRMGlobalConstants.EnrollmentEmailBody3 +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NokiaOffice;
  mailList.add(mail);
  
  }  
  Messaging.sendEmail( mailList);
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.TechnicalSupportMessage,PRMGlobalConstants.getCurrentUser);
   
  }
  }
   /*******************************
  *Method name: sendMailstoPRMs
  *Description: This Method will send mail to PRMs for rebate form
  *Parameter: Opportunity Values
  *******************************/  
  public static void sendMailsOnRebateSubmission( List<Account_Member__c> accountMemberList,rebate_form__c rebate){
  try{
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  for(Account_Member__c accountMember : accountMemberList){
  Messaging.SingleEmailMessage mail = getSingleEmailMessage();
  mail.setTargetObjectId(accountMember.Name__c); 
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  //mail.setSenderDisplayName(PRMGlobalConstants.NokiaTeam);
  mail.setOrgWideEmailAddressId(system.Label.Nokia_Global_Partner_CommunicationsID);
  mail.setSaveAsActivity(false); 
  mail.subject = PRMGlobalConstants.RebateSubmitSubject;
  mail.plainTextBody = PRMGlobalConstants.Dear +PRMGlobalConstants.NokiaPartner + PRMGlobalConstants.comma + PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.enrollmentId +rebate.name +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.submissionBody +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.thanksOnsubmission  +PRMGlobalConstants.NextLine +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.NokiaOffice;
  mailList.add(mail);
  } 
  Messaging.sendEmail( mailList);
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.TechnicalSupportMessage,PRMGlobalConstants.getCurrentUser);
   
  }
  }
   /*******************************
  *Method name: sendMailstoPRMs
  *Description: This Method will send mail to PRMs for rebate form
  *Parameter: Opportunity Values
  *******************************/  
  public static void sendMailsOnRejection( List<Account_Member__c> accountMemberList,rebate_form__c rebate){
  try{
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  for(Account_Member__c accountMember : accountMemberList){
  Messaging.SingleEmailMessage mail = getSingleEmailMessage();
  mail.setTargetObjectId(accountMember.Name__c); 
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  //mail.setSenderDisplayName(PRMGlobalConstants.NokiaTeam);
  mail.setOrgWideEmailAddressId(system.Label.Nokia_Global_Partner_CommunicationsID);
  mail.setSaveAsActivity(false); 
  mail.subject = PRMGlobalConstants.RejectedContract;
  mail.plainTextBody = PRMGlobalConstants.Dear + PRMGlobalConstants.NokiaPartner  + PRMGlobalConstants.comma + PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.enrollmentId +rebate.name +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.RejectedContractPart1 +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.RejectedContractPart2 +rebate.Pending_Rejection_Reason__c +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.RejectedContractPart3 +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.thanksAndRegards  +PRMGlobalConstants.NextLine+PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NokiaOffice;
  mailList.add(mail);
  } 
  Messaging.sendEmail( mailList);
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.TechnicalSupportMessage,PRMGlobalConstants.getCurrentUser);
   
  }
  }
   /*******************************
  *Method name: sendMailstoPRMs
  *Description: This Method will send mail to PRMs for rebate form
  *Parameter: Opportunity Values
  *******************************/  
  public static void sendEmailOnRejectionRebate( List<Account_Member__c> accountMemberList,rebate_form__c rebate){
  string rebateFormUrl = System.Label.rebateFormURL;
  try{
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  for(Account_Member__c accountMember : accountMemberList){
  Messaging.SingleEmailMessage mail = getSingleEmailMessage();
  mail.setTargetObjectId(accountMember.Name__c); 
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  //mail.setSenderDisplayName(PRMGlobalConstants.NokiaTeam);
  mail.setOrgWideEmailAddressId(system.Label.Nokia_Global_Partner_CommunicationsID);
  mail.setSaveAsActivity(false); 
  mail.subject = PRMGlobalConstants.RebateRejectionSubject;
  mail.plainTextBody = PRMGlobalConstants.Dear + PRMGlobalConstants.PSM  + PRMGlobalConstants.comma +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NextLine  +PRMGlobalConstants.rePartner
  +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.NextLine  
  
  +PRMGlobalConstants.RebateRejectionPart1 +accountMember.Account__r.Name
  +PRMGlobalConstants.RebateRejectionPart2 +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.RebateRejectionPart3 +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.RebateRejectionPart4 +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.RebateRejectionPart5 +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.RebateRejectionPart6 +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.RebateRejectionPart7 +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.RebateRejectionPart8 +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.thanksAndRegards  +PRMGlobalConstants.NextLine+PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NokiaOffice
  +PRMGlobalConstants.NextLine
  +PRMGlobalConstants.NextLine
  +rebateFormUrl +rebate.Id;
  mailList.add(mail);
  } 
  Messaging.sendEmail( mailList);
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.TechnicalSupportMessage,PRMGlobalConstants.getCurrentUser);
   
  }
  }
   /*******************************
  *Method name: sendMailstoPRMs
  *Description: This Method will send mail to PRMs for rebate form
  *Parameter: Opportunity Values
  *******************************/  
  public static void sendMailsForExpiredContract( List<Account_Member__c> accountMemberList , Map<id,Rebate_form__c> accToRebateMap){
  string rebateFormUrl = System.Label.rebateFormURL;
  try{
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  for(Account_Member__c accountMember : accountMemberList){
  string rebateId = String.valueOf(accToRebateMap.get(accountMember.Account__c).id);
  Messaging.SingleEmailMessage mail = getSingleEmailMessage();
  mail.setTargetObjectId(accountMember.Name__c); 
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  //mail.setSenderDisplayName(PRMGlobalConstants.NokiaTeam);
  mail.setOrgWideEmailAddressId(system.Label.Nokia_Global_Partner_CommunicationsID);
  mail.setSaveAsActivity(false); 
  mail.subject = PRMGlobalConstants.ExpiredContractSubject;
  mail.plainTextBody = PRMGlobalConstants.Dear + PRMGlobalConstants.PartnerSalesManager  + PRMGlobalConstants.comma + PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.rePartner 
  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.ExpiredContractPart1 +accountMember.Account__r.name
  +PRMGlobalConstants.ExpiredContractPart2
  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NextLine
  +PRMGlobalConstants.ExpiredContractPart3
  +PRMGlobalConstants.NextLine
  +PRMGlobalConstants.ExpiredContractPart4 +PRMGlobalConstants.NextLine +PRMGlobalConstants.ExpiredContractPart5
  +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine +PRMGlobalConstants.thanksAndRegards  +PRMGlobalConstants.NextLine+PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NokiaOffice2
  +PRMGlobalConstants.NextLine
  +PRMGlobalConstants.NextLine
  +rebateFormUrl +rebateId;
  
  mailList.add(mail);
  
  }
  Messaging.sendEmail( mailList);
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.TechnicalSupportMessage,PRMGlobalConstants.getCurrentUser);
   
  }
  }
   /*******************************
  *Method name: sendMailstoPRMs
  *Description: This Method will send mail to PRMs for rebate form
  *Parameter: Opportunity Values
  *******************************/  
  public static void sendMailReminders( List<Account_Member__c> accountMemberList,rebate_period__c period){
  string rebateFormUrl = System.Label.Rebate_Form_Link;
  try{
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  for(Account_Member__c accountMember : accountMemberList){
  Messaging.SingleEmailMessage mail = getSingleEmailMessage();
  mail.setTargetObjectId(accountMember.Name__c); 
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  //mail.setSenderDisplayName(PRMGlobalConstants.NokiaTeam);
  mail.setOrgWideEmailAddressId(system.Label.Nokia_Global_Partner_CommunicationsID);
  mail.setSaveAsActivity(false); 
  mail.subject = PRMGlobalConstants.reminderSubject;
  mail.plainTextBody = PRMGlobalConstants.Dear + PRMGlobalConstants.NokiaPartner  + PRMGlobalConstants.comma + PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.reminderPart1  +PRMGlobalConstants.NextLine   +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.reminderPart2 +rebateFormUrl +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.reminderPart3 +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.reminderPart4 +period.Enrollment_End_Date_Formula__c +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.reminderPart5  +PRMGlobalConstants.NextLine+PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.EnrollmentEmailBody3  +PRMGlobalConstants.NextLine+PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NokiaOffice;
  mailList.add(mail);
  } 
  Messaging.sendEmail( mailList);
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.TechnicalSupportMessage,PRMGlobalConstants.getCurrentUser);
   
  }
  }
/*******************************
  *Method name: sendMailstoPRMs
  *Description: This Method will send mail to PRMs for rebate form
  *Parameter: Opportunity Values
  *******************************/  
  public static void sendMailforNoAccreditation( List<Account> accountList,map<id,Rebate_form__c> accToRebateMap){
  string rebateFormUrl = System.Label.rebateFormURL;
  try{
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  for(Account acc : accountList){
  string rebateId = accToRebateMap.get(acc.id).id;
  Messaging.SingleEmailMessage mail = getSingleEmailMessage();
  mail.setTargetObjectId(acc.ownerId); 
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  //mail.setSenderDisplayName(PRMGlobalConstants.NokiaTeam);
  mail.setOrgWideEmailAddressId(system.Label.Nokia_Global_Partner_CommunicationsID);
  mail.setSaveAsActivity(false); 
  mail.subject = PRMGlobalConstants.SubjectNoAccreditation;
  mail.plainTextBody = PRMGlobalConstants.Dear + PRMGlobalConstants.PartnerSalesManager  + PRMGlobalConstants.comma + PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.RebateRejectionPart1  +acc.Name   +PRMGlobalConstants.noAccredidationPart1 
  +PRMGlobalConstants.NextLine +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.noAccredidationPart2 +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.noAccredidationPart3 +PRMGlobalConstants.NextLine  +PRMGlobalConstants.noAccredidationPart4
  +PRMGlobalConstants.NextLine+PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.thanksAndRegards  +PRMGlobalConstants.NextLine
  +PRMGlobalConstants.NokiaOffice2 +PRMGlobalConstants.NextLine
  +rebateFormUrl +rebateId;
  mailList.add(mail);
  } 
  Messaging.sendEmail( mailList);
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.TechnicalSupportMessage,PRMGlobalConstants.getCurrentUser);
   
  }
  }
/*******************************
  *Method name: sendMailstoPRMs
  *Description: This Method will send mail to PRMs for rebate form
  *Parameter: Opportunity Values
  *******************************/  
  public static void sendMailforMissingAccreditation( List<Account> accountList,map<id,Rebate_form__c> accToRebateMap){
  string rebateFormUrl = System.Label.rebateFormURL;
  try{
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  for(Account acc : accountList){
  string rebateId = accToRebateMap.get(acc.id).id;
  Messaging.SingleEmailMessage mail = getSingleEmailMessage();
  mail.setTargetObjectId(acc.ownerId); 
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  //mail.setSenderDisplayName(PRMGlobalConstants.NokiaTeam);
  mail.setOrgWideEmailAddressId(system.Label.Nokia_Global_Partner_CommunicationsID);
  mail.setSaveAsActivity(false); 
  mail.subject = PRMGlobalConstants.SubjectMissingAccreditation;
  mail.plainTextBody = PRMGlobalConstants.Dear + PRMGlobalConstants.PartnerSalesManager  + PRMGlobalConstants.comma + PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.RebateRejectionPart1  +acc.Name   +PRMGlobalConstants.missingAccredidationPart1 
  +PRMGlobalConstants.NextLine +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.noAccredidationPart2 +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.noAccredidationPart3 +PRMGlobalConstants.NextLine  +PRMGlobalConstants.noAccredidationPart4
  +PRMGlobalConstants.NextLine+PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.thanksAndRegards  +PRMGlobalConstants.NextLine
  +PRMGlobalConstants.NokiaOffice2 +PRMGlobalConstants.NextLine
  +rebateFormUrl +rebateId;
  mailList.add(mail);
  } 
  Messaging.sendEmail( mailList);
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.TechnicalSupportMessage,PRMGlobalConstants.getCurrentUser);
   
  }
  }
   /*******************************
  *Method name: sendMailstoPRMs
  *Description: This Method will send mail to PRMs for rebate form
  *Parameter: Opportunity Values
  *******************************/  
  public static void sendMailsForAmountFilling( List<Account_Member__c> accountMemberList,rebate_form__c rebate){
  string rebateFormUrl = System.Label.rebateFormURL;
  try{
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  for(Account_Member__c accountMember : accountMemberList){
   
  Messaging.SingleEmailMessage mail = getSingleEmailMessage();
  mail.setTargetObjectId(accountMember.Name__c); 
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  //mail.setSenderDisplayName(PRMGlobalConstants.NokiaTeam);
  mail.setOrgWideEmailAddressId(system.Label.Nokia_Global_Partner_CommunicationsID);
  mail.setSaveAsActivity(false); 
  mail.subject = PRMGlobalConstants.RebateCalculation;
  mail.plainTextBody = PRMGlobalConstants.Dear + PRMGlobalConstants.PSM + PRMGlobalConstants.comma + PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NextLine
  +PRMGlobalConstants.rePartner
  +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.RebateCalculationPart0 +accountMember.Account__r.Name +PRMGlobalConstants.RebateCalculationPart1
  +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.RebateCalculationPart2
  +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.RebateCalculationPart3
  +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine  
  +PRMGlobalConstants.RebateCalculationPart4
  +PRMGlobalConstants.NextLine  +PRMGlobalConstants.NextLine +PRMGlobalConstants.thanksAndRegards  +PRMGlobalConstants.NextLine+PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NokiaOffice
  +PRMGlobalConstants.NextLine
  +PRMGlobalConstants.NextLine
  +rebateFormUrl +rebate.id;
  
  mailList.add(mail);
  }  
  Messaging.sendEmail( mailList);
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.TechnicalSupportMessage,PRMGlobalConstants.getCurrentUser);
   
  }
  }
  
  /*******************************
  *Method name: sendMailstoPRMsandPSMs
  *Description: This Method will send mail to PRMs for business planning form
  *Parameter: account members Values
  *******************************/  
  public static void sendMailsForBusinessPlanning( List<Account_Member__c> accountMemberList, String subject, String emailBody) {
  try{
  OrgWideEmailAddress owe = [SELECT ID, DisplayName,Address 
  FROM OrgWideEmailAddress 
  WHERE DisplayName =: PRMGlobalConstants.OrgWideAddress Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  List<String> toaddresses = new List<String>();
  List<String> ccaddresses = new List<String>();
  String msgBody = PRMGlobalConstants.RFUrl;
  Map<Id, List<Account_Member__c>> mapAccToAccMem = new Map<Id, List<Account_Member__c>>();
  for(Account_Member__c am : accountMemberList) {
  if(!mapAccToAccMem.containsKey(am.Account__c)) {
  mapAccToAccMem.put(am.Account__c, new List<Account_Member__c>());
  }
  mapAccToAccMem.get(am.Account__c).add(am);
  }
  for(Id accId : mapAccToAccMem.keySet()) {
  for(Account_Member__c am : mapAccToAccMem.get(accId)) {
  if(am.Account_Role__c == PRMGlobalConstants.Partner_Relationship_Manager) {
  toaddresses.add(am.Email__c);
  }else if(am.Account_Role__c == PRMGlobalConstants.PARTNER_SALES_MANAGER) {
  ccaddresses.add(am.Email__c);
  }else{}
  }
  Messaging.SingleEmailMessage mail = getSingleEmailMessage();
  //mail.setTargetObjectId(am.Name__c); 
  mail.setToAddresses(toaddresses);
  if(ccaddresses.size() > 0) {
  mail.setCcAddresses(ccaddresses);
  }
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setSaveAsActivity(false); 
  mail.setOrgWideEmailAddressId(owe.Id);
  mail.subject = subject;
  msgBody = emailBody.replace(PRMGlobalConstants.ACC_LINK_MERGED, PRMGlobalConstants.partner_email_community_URL+PRMGlobalConstants.accountSlash+accId);
  mail.plainTextBody = msgBody; 
  mailList.add(mail);
  toaddresses.clear();
  ccaddresses.clear();
  
  }
  Messaging.sendEmail( mailList);
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.TechnicalSupportMessage,PRMGlobalConstants.getCurrentUser);
   
  }
  }
  
  /*******************************
  *Method name: getSingleEmailMessage
  *Description: This Method craete mail unstance
  *Parameter: Opportunity Values
  *******************************/  
  public static Messaging.SingleEmailMessage getSingleEmailMessage()
  {
  return new Messaging.SingleEmailMessage();
  }
   /*******************************
  *Method name: getSingleEmailMessageList
  *Description: This Method craete mail unstance
  *Parameter: Opportunity Values
  *******************************/  
  public static List<Messaging.SingleEmailMessage> getSingleEmailMessageList()
  {
  return new List<Messaging.SingleEmailMessage>();
  }
   /*******************************
  *Method name: sendMailstoPartnerusers
  *Description: This Method will send mail to partnerusers for allocation expire in 15 days
  *Parameter: allocation Values
  *******************************/  
  public static void sendMailforexpirenotification(List<Co_Op_Allocation__c> allocationList,Map<id,List<String>> acctoUserMap){
  try{
  Set<Id> accountSet = new Set<Id>();
  set<id> Partnerset = new set<id>();
	 list<string> approverlist = new list<string>();
  list<string> Partneremailuserlist = new list<string>();
  system.debug('Partneremailuserlist'+Partneremailuserlist);
  for(Co_Op_Allocation__c allocationex : [Select Id,Expiration_Date__c,Allocation_Period_Balance__c,Partner_Name__c,Partner_Name__r.name,Status__c from Co_Op_Allocation__c where Id In: allocationList  Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
  accountSet.add(allocationex.Partner_Name__c);
  
  }
  /*  for(Additional_Resource_Request__c Partner : [Select id,Partner_Account__c,Partner_Contact__c,Additional_Resource__c,Procurement_Status__c FROM Additional_Resource_Request__c WHERE (Partner_Account__r.id IN :accountSet AND Additional_Resource__c = 'Co-op' AND Procurement_Status__c= 'Completed') Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
	Partnerset.add(Partner.Partner_Contact__c);
  }*/
  for(Contact partnercon : [Select Id,AccountId FROM Contact WHERE AccountId IN :accountSet Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
	Partnerset.add(partnercon.AccountId);
	system.debug('Partnerset.add(partnercon.Account.id)'+Partnerset.add(partnercon.AccountId));
  }
  for(User PartnerUser : [Select id,AccountId, ContactId,Email,Co_op_User__c FROM User WHERE AccountId IN :accountSet AND Co_op_User__c = TRUE Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
	Partneremailuserlist.add(PartnerUser.Email);
	system.debug('Partneremailuserlist.add(PartnerUser.Email'+Partneremailuserlist.add(PartnerUser.Email));
  }
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  List<Co_Op_Allocation__c> allocationt = [Select Id,Expiration_Date__c,Allocation_Period_Balance__c,Partner_Name__c,Partner_Name__r.name,Status__c from Co_Op_Allocation__c where Id In: allocationList  Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];
  Set<Id> accountSetex = new Set<Id>();
  for(Co_Op_Allocation__c allocation1 :allocationt ){
  accountSetex.add(allocation1.Partner_Name__c);
  }
  List<Co_Op_Approvals_Master_Data__c> accmasterdata = [Select Id,Partner_Account__c,Activity_Approver_Level_1__c,Activity_Approver_Level_2__c,Activity_Approver_Level_3__c FROM Co_Op_Approvals_Master_Data__c WHERE Partner_Account__r.id IN :accountSetex  Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];
  for(Co_Op_Allocation__c allocation : allocationList){
   list<string> userlist = new list<string>();
	
   approverlist.add(System.Label.PRM_Coop_global_admin);
   approverlist.add(System.Label.PRM_GSS_Mail);
  
  set<id>allocationex = new set<id>();
  //set<id> claimactivity = new set<id>();
  //set<id> allocationclaim = new set<id>();
  
  // Set<Id> accountSetex = new Set<Id>();
  //  List<Co_Op_Allocation__c> allocationt = [Select Id,Expiration_Date__c,Allocation_Period_Balance__c,Partner_Name__c,Partner_Name__r.name,Status__c from Co_Op_Allocation__c where Id In: allocationList  Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];
  for(Co_Op_Allocation__c allocation1 :allocationt ){
  accountSetex.add(allocation1.Partner_Name__c);
  }
  //  List<Co_Op_Approvals_Master_Data__c> accmasterdata = [Select Id,Partner_Account__c,Activity_Approver_Level_1__c,Activity_Approver_Level_2__c,Activity_Approver_Level_3__c FROM Co_Op_Approvals_Master_Data__c WHERE Partner_Account__r.id IN :accountSetex  Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];
  for(Co_Op_Approvals_Master_Data__c masterdata :accmasterdata){
  approverlist.add(masterdata.Activity_Approver_Level_1__c);
   approverlist.add(masterdata.Activity_Approver_Level_2__c);
   approverlist.add(masterdata.Activity_Approver_Level_3__c);
  system.debug('masterdata.Activity_Approver_Level_1__c'+masterdata.Activity_Approver_Level_1__c);
  } 
  //  List<Accrual_junction__c> activityapprovars = new List<Accrual_junction__c>();
  /*  for( Accrual_junction__c accuraljunction : [SELECT id,Accrual__c,Partner_Fund_Claim__c FROM Accrual_junction__c where Accrual__c IN : allocationList Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
  allocationclaim.add(accuraljunction.Partner_Fund_Claim__c);
  system.debug('claimrecord'+accuraljunction.Partner_Fund_Claim__c);
  system.debug('claimrecord'+accuraljunction.Accrual__c);
  
  }
  userEmailList1 =acctoUserMap.get(allocation.Partner_Name__c);
  
  userEmailList1.add(System.Label.PRM_Coop_global_admin);
  for(Claim__c activityclaim: [SELECT id,Activity_Number__c FROM Claim__c WHERE id IN : allocationclaim Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
  claimactivity.add(activityclaim.Activity_Number__c);
  system.debug('activity record'+activityclaim.Activity_Number__c);
  }
  for(Co_Op_Activity__c activityapprovers : [SELECT id,Approver_Level_2__c,Approver_Level_1__c,Approver_Level_3__c FROM Co_Op_Activity__c WHERE id IN :claimactivity Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
  userEmailList4.add(activityapprovers.Approver_Level_1__c);
  userEmailList4.add(activityapprovers.Approver_Level_2__c);
  userEmailList4.add(activityapprovers.Approver_Level_3__c);
  system.debug('activity approver level1' +activityapprovers.Approver_Level_1__c);
   system.debug('activity approver level2' +activityapprovers.Approver_Level_2__c);
   system.debug('activity approver level3' +activityapprovers.Approver_Level_3__c);
  }
  String account = allocation.Account_Name__c;
  //system.debug('account+++++++++++++++account'+account);
  //  String reglead1 = PRM_Regional_Leads_per_Market__c.getInstance(allocation.Market__c).Regional_Leads_Email__c;
  List<String> userEmailList2 = new List<String>();
  //  userEmailList2 =reglead1.Split(PRMGlobalConstants.SemiColon);
  userEmailList3.addAll(userEmailList2);
  userEmailList3.addAll(userEmailList4);
  userEmailList3.addAll(userEmailList5);
  userEmailList3.addAll(userEmailList6);
  // System.debug('reglead1   ' + reglead1);
  //System.debug('UserEmailList2   ' + UserEmailList2); */
  if(allocation.days_to_expire__c == '15 DAY' && allocation.Allocation_Period_Balance__c != 0 && allocation.Status__c == PRMGlobalConstants.ActiveSt){
  Messaging.SingleEmailMessage mail = getSingleEmailMessage();
  mail.toAddresses = Partneremailuserlist;
  mail.ccaddresses = approverlist;
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  mail.setOrgWideEmailAddressId(system.Label.Nokia_Global_Partner_CommunicationsID);
  mail.setSaveAsActivity(false); 
  mail.subject = 'URGENT ' + allocation.Account_Name__c + ' Co-op Allocation of ' + allocation.Allocation_Period_Balance__c + ' EXPIRING IN 15 DAYS - FINAL NOTICE';
  mail.plainTextBody = 'Dear Co-op User, '+ PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NextLine  
  +'The Co-op allocation identified below will expire on ' + allocation.Expiration_Date__c.format() + ' and will be removed from your Co-op balance.'+ PRMGlobalConstants.NextLine
  +PRMGlobalConstants.NextLine
  +'Open activities will NOT prevent allocations from expiring.'
  +PRMGlobalConstants.NextLine +PRMGlobalConstants.NextLine 
  +'Partner Name: ' + allocation.Account_Name__c + PRMGlobalConstants.NextLine 
  +'Allocation Period: '+allocation.Co_Op_Allocation_Period__c  +PRMGlobalConstants.NextLine
  +'Allocation Expiration Date: '+ allocation.Expiration_Date__c.format()  + PRMGlobalConstants.NextLine
  +'Amount at Risk of Expiring: ' + allocation.Allocation_Period_Balance__c + PRMGlobalConstants.NextLine
  + PRMGlobalConstants.NextLine
  +'How to prevent allocations from expiring:' +PRMGlobalConstants.NextLine 
  +'1. Log on to the Nokia Partner Portal at: ' +System.Label.Partner_email_community_URL +
  PRMGlobalConstants.NextLine
  +'2. Review Claims with "Claimable" status.' +PRMGlobalConstants.NextLine 
  +'3. Submit claims prior to the expiration date.' +PRMGlobalConstants.NextLine +PRMGlobalConstants.NextLine
  +'Co-op training materials are available on the Partner Portal' +PRMGlobalConstants.NextLine
  +'1. Log on to the Nokia Partner Portal at: '+System.Label.Partner_email_community_URL +PRMGlobalConstants.NextLine
  +'2. Click Topic Catalog.'+PRMGlobalConstants.NextLine
  +'3. Click the Partner Portal Training tile.'+PRMGlobalConstants.NextLine
  +'4. Click Partner Portal Training to access Partner Portal Training including Co-op training materials.'+PRMGlobalConstants.NextLine +PRMGlobalConstants.NextLine
  +'Please contact the Partner Support Team at Partner.Support@Nokia.com with any questions or if assistance is needed.'+PRMGlobalConstants.NextLine+PRMGlobalConstants.NextLine
  +'Regards, '+PRMGlobalConstants.NextLine
  +'Your Co-op Program Team'+PRMGlobalConstants.NextLine;
  
  mailList.add(mail);
  }
  else if(allocation.days_to_expire__c == '30 DAY' && allocation.Allocation_Period_Balance__c != 0 && allocation.Status__c == PRMGlobalConstants.ActiveSt){
  Messaging.SingleEmailMessage mail = getSingleEmailMessage();
  mail.toAddresses = Partneremailuserlist;
  mail.ccaddresses = approverlist;
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  mail.setOrgWideEmailAddressId(system.Label.Nokia_Global_Partner_CommunicationsID);
  mail.setSaveAsActivity(false); 
  mail.subject = 'URGENT ' + allocation.Account_Name__c + ' Co-op Allocation of ' + allocation.Allocation_Period_Balance__c + ' EXPIRING IN 30 DAYS';
  mail.plainTextBody = 'Dear Co-op User, '+ PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NextLine  
  +'The Co-op allocation identified below will expire on ' + allocation.Expiration_Date__c.format() + ' and will be removed from your Co-op balance.' + PRMGlobalConstants.NextLine+ PRMGlobalConstants.NextLine +'Open activities will NOT prevent allocations from expiring.'+
  PRMGlobalConstants.NextLine +PRMGlobalConstants.NextLine 
  +'Partner Name: ' + allocation.Account_Name__c + PRMGlobalConstants.NextLine 
  +'Allocation Period: '+allocation.Co_Op_Allocation_Period__c  +PRMGlobalConstants.NextLine
  +'Allocation Expiration Date: '+ allocation.Expiration_Date__c.format()  + PRMGlobalConstants.NextLine
  +'Amount at Risk of Expiring: ' + allocation.Allocation_Period_Balance__c + PRMGlobalConstants.NextLine+ PRMGlobalConstants.NextLine
  
  +'How to prevent allocations from expiring:' +PRMGlobalConstants.NextLine
  +'1. Log on to the Nokia Partner Portal at: ' +System.Label.Partner_email_community_URL  +
  PRMGlobalConstants.NextLine
  +'2. Review Claims with "Claimable" status.' +PRMGlobalConstants.NextLine 
  +'3. Submit claims prior to the expiration date.'+PRMGlobalConstants.NextLine+PRMGlobalConstants.NextLine
  +'Please contact the Partner Support Team at Partner.Support@Nokia.com with any questions or if assistance is needed.'+PRMGlobalConstants.NextLine+PRMGlobalConstants.NextLine
  +'Regards, '+PRMGlobalConstants.NextLine
  +'Your Co-op Program Team'+PRMGlobalConstants.NextLine;
  mailList.add(mail);
  }
  else if(allocation.Status__c == PRMGlobalConstants.EXPIRED && (allocation.Allocation_Period_Balance__c != 0 )){
   Messaging.SingleEmailMessage mail = getSingleEmailMessage();
  mail.toAddresses = Partneremailuserlist;
  mail.ccaddresses = approverlist;
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  mail.setOrgWideEmailAddressId(system.Label.Nokia_Global_Partner_CommunicationsID);
  mail.setSaveAsActivity(false); 
  mail.subject = allocation.Account_Name__c + ' Co-op Allocation: ' + allocation.Expiration_Amount__c + '- HAS EXPIRED';
  mail.plainTextBody = 'Dear Co-op User, '+ PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NextLine  
  +'The Co-op Allocation amount identified below expired on ' + allocation.Expiration_Date__c.format() + ' and is reflected on your Co-op Account Statement:'+
  PRMGlobalConstants.NextLine +PRMGlobalConstants.NextLine 
  +'Partner Name: ' + allocation.Account_Name__c + PRMGlobalConstants.NextLine 
  +'Allocation Expiration Date: '+ allocation.Expiration_Date__c.format() + PRMGlobalConstants.NextLine
  +'Allocation Amount Expired: ' + allocation.Allocation_Period_Balance__c + PRMGlobalConstants.NextLine+ PRMGlobalConstants.NextLine
  +'Expired Co-op Allocation amounts may NOT be reinstated and Co-op Allocation Expiration Dates may NOT be extended.' +PRMGlobalConstants.NextLine +PRMGlobalConstants.NextLine
   +'How to prevent allocations from expiring:'+PRMGlobalConstants.NextLine
  +'1. Log on to the Nokia Partner Portal at: ' +System.Label.Partner_email_community_URL +
  PRMGlobalConstants.NextLine
  +'2. Review Claims with "Claimable" status.' +PRMGlobalConstants.NextLine 
  +'3. Submit Claimable claims prior to the expiration date.'+PRMGlobalConstants.NextLine+PRMGlobalConstants.NextLine
  +'Co-op training materials are available on the Partner Portal' +PRMGlobalConstants.NextLine
  +'1. Log on to the Nokia Partner Portal at: '+System.Label.Partner_email_community_URL +PRMGlobalConstants.NextLine
  +'2. Click Topic Catalog.'+PRMGlobalConstants.NextLine
  +'3. Click the Partner Portal Training tile.'+PRMGlobalConstants.NextLine
  +'4. Click Partner Portal Training to access Partner Portal Training including Co-op training materials.'+PRMGlobalConstants.NextLine +PRMGlobalConstants.NextLine
  +'Please contact the Partner Support Team at Partner.Support@Nokia.com with any questions or if assistance is needed.'+PRMGlobalConstants.NextLine+PRMGlobalConstants.NextLine
  +'Regards, '+PRMGlobalConstants.NextLine
  +'Your Co-op Program Team'+PRMGlobalConstants.NextLine;
  mailList.add(mail);
  }
  else{}
  } 
  Messaging.sendEmail( mailList);
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.TechnicalSupportMessage,PRMGlobalConstants.getCurrentUser);
   
  }
  }   
  /*******************************
  *Method name: sendMailstoPartnerusers
  *Description: This Method will send mail to partnerusers for allocation expire in 15 days
  *Parameter: allocation Values
  *******************************/  
   public static void sendMailforUploadAllocation(List<Co_Op_Allocation__c> allocationList,Map<id,List<String>> acctoUserMap){
  try{
  List<Messaging.SingleEmailMessage> mailList = getSingleEmailMessageList();
  list<string> userlist = new list<string>();
  list<string> approverlist = new list<string>();
  List<String> userEmailList = new List<String>();
  system.debug('approverlist'+approverlist);
  approverlist.add(System.Label.PRM_Coop_global_admin);
  approverlist.add(System.Label.PRM_GSS_Mail);
   Set<Id> accountSet = new Set<Id>();
  set<id> Partnerset = new set<id>();
  list<string> Partneremailuserlist = new list<string>();
  for(Co_Op_Allocation__c allocation : [Select Id,Expiration_Date__c,Allocation_Period_Balance__c,Partner_Name__c,Partner_Name__r.name,Status__c from Co_Op_Allocation__c where Id In: allocationList  Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
  accountSet.add(allocation.Partner_Name__c);
	system.debug('>>>>>>>>>allocation.Partner_Name__c'+allocation.Partner_Name__c);
  }
   /*   for(Additional_Resource_Request__c Partner : [Select id,Partner_Account__c,Partner_Contact__c,Additional_Resource__c,Procurement_Status__c FROM Additional_Resource_Request__c WHERE (Partner_Account__r.id IN :accountSet AND Additional_Resource__c = 'Co-op' AND Procurement_Status__c= 'Completed') Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
	Partnerset.add(Partner.Partner_Contact__c);
  } */
   for(Contact partnercon : [Select Id,Account.id FROM Contact WHERE Account.id IN :accountSet Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
	Partnerset.add(partnercon.Account.id);
  }
  for(User PartnerUser : [Select id,AccountId, ContactId,Email,Co_op_User__c FROM User WHERE AccountId IN :accountSet AND Co_op_User__c = true Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
	Partneremailuserlist.add(PartnerUser.Email);
	system.debug('Partneremailuserlist.add(PartnerUser.Email'+PartnerUser);
  }
  for(Co_Op_Approvals_Master_Data__c masterdata :[Select Id,Partner_Account__c,Activity_Approver_Level_1_Email__c,Activity_Approver_Level_2_Email__c,Activity_Approver_Level_3_Email__c,Activity_Approver_Level_1__c,Activity_Approver_Level_2__c,Activity_Approver_Level_3__c FROM Co_Op_Approvals_Master_Data__c WHERE Partner_Account__r.id IN :accountSet  Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
  approverlist.add(masterdata.Activity_Approver_Level_1__c);
   approverlist.add(masterdata.Activity_Approver_Level_2__c);
   approverlist.add(masterdata.Activity_Approver_Level_3__c);
  system.debug('masterdata.Activity_Approver_Level_1__c'+masterdata.Activity_Approver_Level_1_Email__c);
  } 
   //   List<Co_Op_Approvals_Master_Data__c> masterdata = [Select Id,Partner_Account__c,Activity_Approver_Level_1__c,Activity_Approver_Level_2_Email__c,Activity_Approver_Level_3_Email__c FROM  Co_Op_Approvals_Master_Data__c WHERE Partner_Account__r.id IN :accountSet  Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];
  for(Co_Op_Allocation__c allocation : allocationList){
   
  system.debug('allocation'+allocationList);
  system.debug('Gopi testallocation'+allocationList);
  
   userEmailList = (acctoUserMap.get(allocation.Partner_Name__c));
  if(allocation.PRM_Co_op_Allocation_Amount__c != 0 ){
	system.debug('allocation.PRM_Co_op_Allocation_Amount__c'+allocation.PRM_Co_op_Allocation_Amount__c);
  Messaging.SingleEmailMessage mail = getSingleEmailMessage();
  mail.toAddresses = Partneremailuserlist;
  mail.ccaddresses = approverlist;
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setReplyTo(PRMGlobalConstants.SenderMail);
  mail.setOrgWideEmailAddressId(system.Label.Nokia_Global_Partner_CommunicationsID);
  mail.setSaveAsActivity(false); 
  mail.subject = 'Co-op Allocation added to Co-op Account:  ' + allocation.Account_Name__c ;
  mail.plainTextBody = 'Dear Co-op User, '+ PRMGlobalConstants.NextLine 
  +PRMGlobalConstants.NextLine  
  +'A Co-op Allocation has been added to your Co-op Account. ' +PRMGlobalConstants.NextLine +PRMGlobalConstants.NextLine
  
  +'Allocation Period: '+allocation.Co_Op_Allocation_Period__c +PRMGlobalConstants.NextLine
  +'Date Available: '+allocation.Available_Date__c.format() +PRMGlobalConstants.NextLine
  +'Expiration Date: '+allocation.Expiration_Date__c.format() +PRMGlobalConstants.NextLine 
  +'Co-op Allocation Amount: ' +allocation.PRM_Co_op_Allocation_Amount__c +PRMGlobalConstants.NextLine
  +'Total Co-Available in Co-op Account: ' +allocation.Allocation_Period_Balance__c +PRMGlobalConstants.NextLine+PRMGlobalConstants.NextLine
  +'View and Co-op funds and Allocations:'
  +'1. Log on to the Nokia Partner Portal at: ' +System.Label.Partner_email_community_URL+PRMGlobalConstants.NextLine 
  +'2. Click Co-op.'+PRMGlobalConstants.NextLine
  +'3. Click the Fund name.'+PRMGlobalConstants.NextLine
  +'4. Click the Related tab.'+PRMGlobalConstants.NextLine+PRMGlobalConstants.NextLine
  +'OR'+PRMGlobalConstants.NextLine+PRMGlobalConstants.NextLine
  +'To run an Allocation report:'+PRMGlobalConstants.NextLine
  +'1. Log on to the Nokia Partner Portal at: '+System.Label.Partner_email_community_URL +PRMGlobalConstants.NextLine
  +'2. Click Reports.'+PRMGlobalConstants.NextLine
  +'3. Under All Folders, click My Partner Co-op Reporting.'+PRMGlobalConstants.NextLine
  +'4. Select the report you would like to view.'+PRMGlobalConstants.NextLine+PRMGlobalConstants.NextLine
  +'Any unused allotments will expire 12 months after the Available Date. Extensions are NOT ALLOWED.'+PRMGlobalConstants.NextLine+PRMGlobalConstants.NextLine
  +'Co-op training materials are available on the Partner Portal'+PRMGlobalConstants.NextLine
  +'1. Log on to the Nokia Partner Portal at: ' +System.Label.Partner_email_community_URL +PRMGlobalConstants.NextLine
  +'2. Click Topic Catalog.'+PRMGlobalConstants.NextLine
  +'3. Click the Partner Portal Training tile.'+PRMGlobalConstants.NextLine
  +'4. Click Partner Portal Training to access Partner Portal Training including Co-op training materials.'+PRMGlobalConstants.NextLine+PRMGlobalConstants.NextLine
  +'Please contact the Partner Support Team at Partner.Support@Nokia.com with any questions or if assistance is needed.'+PRMGlobalConstants.NextLine+PRMGlobalConstants.NextLine
  +'Regards, '+PRMGlobalConstants.NextLine
  +'Your Co-op Program Team'+PRMGlobalConstants.NextLine;
  
  mailList.add(mail);
  }
  
  Messaging.sendEmail( mailList);
  }
  }
  Catch(System.Exception e)
  {
  ExceptionHandler.addException(e,PRMGlobalConstants.TechnicalSupportMessage,PRMGlobalConstants.getCurrentUser);
   
  }
  }
}