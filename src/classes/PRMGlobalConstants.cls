/******************************************************************************************************
Name : PRMGlobalConstants
Created Date: 3rd May 2017
Created by: Accenture
Description : This class will serve all constant values for PRM.
dcoding will be required in any of classes
*********************************************************************************************************/
global class PRMGlobalConstants {
  public static String getAccountIdsToDisablePartnerUser='getAccountIdsToDisablePartnerUser';
  //AccountOwnerChangeAsync
  public static String AccountOwnerChangeAsync='AccountOwnerChangeAsync';
  public static String AccountOwnerChange='accountOnwerChange'; 
  public static String updateLeadandCertificationOwner='updateLeadandCertificationOwner'; 
  public static String updateUserManager='updateUserManager'; 
  public static String accountMemberUpdate='accountMemberUpdate'; 
  //AdditionalResourceHelper
  public static String AdditionalResourceHelper='AdditionalResourceHelper';
  public static String additionalResourceAccount='additionalResourceAccount';
  // IRTermClas
  public static String FileNameForTerm='Nokia Indirect Reseller Agreement';
  public static String IRTermsClass='IRTermsClass';
  public static String getLanguageTerm='getLanguageTerm';
  public static String getTerm='getTerm';
  public static String LanguageEng='Language'; 
  public static String Remove='Remove'; 
  public static String Admin='Admin'; 
  public static boolean AccountAfterUpdate = true;
  public static String USAPricing ='USA Pricing';
  public static String English ='English';
   public static String IR_Parent_Case_ApprovalV1 ='IR_Parent_Case_ApprovalV1';
   public static String IR_Parent_Case_ApprovalNew ='IR_Parent_Case_ApprovalNew';
  //Co-Op Activity Proof of performance 
  
  // ShareSupportAsset
  public static String ShareSupportAsset='ShareSupportAsset';
  public static String getContentDetails='getContentDetails';
  public static String getuserDetail='getuserDetail';
  public static String setLikeRecord='setLikeRecord';
  public static String getDatavalues='getDatavalues';
  public static String sendMailToUser='sendMailToUser';
  public static String MailSubject='Nokia Partner Portal – Document Recommendation';
  public static String LineBreak='<br/>';
  public static String DocName=' Document Name:';
  public static String Has_recommended=' has recommended the following document to you: ';
  public static String Slash='/';
  public static String QuestionMark='?';
  public static String UrlID = '?Id';
  public static String Hyperlink ='</a>';
  public static String Hyperlinkstart = ' <a href=';
  public static String CloseBracket = '>';
  public static String OfValue = ' of ';
  
  
  
  // global multiselect lookup
  public static String GlobalLookupClass='GlobalLookupClass';
  public static String searchDB='searchDB';
  
  //getInactiveAccName
  public static String  No_Error= 'No Error';
  public static String  EndCustomerNotPresent= 'End Customer Not Present';
  public static String  BOTHInactive= 'BOTH Inactive';
  public static String  Inactive= 'Inactive';
  public static String  PartnerAccountInactive= 'Partner Account Inactive';
  public static String  EndCustomerAccountInactive= 'End Customer Account Inactive';
  
  //AccountMember 
  public static String  AccountMemberHanlderPRM= 'AccountMemberHanlderPRM';
  public static String  sharePRM= 'sharePRM';
  public static String  sharePSM= 'sharePSM';
  public static String  shareUpdatePRM= 'shareUpdatePRM';
  public static String  shareUpdatePSM= 'shareUpdatePSM';
  
  // gpp field data
  public static String  Partner_Program0= 'GPP 0.0';
  public static String  Partner_Program1= 'GPP 1.0';
  public static String  Partner_Program2= 'GPP 2.0';
  public static String  Partner_Program3= 'GPP 3.0';
  public static String CertificationDetail_Controller='CertificationDetails';
  //Lead con version Error for PRMCompetitor__c
  public static String PRMCompetitorBLANK = 'Amount is greater than 1M please enter Competitor Name';
  public static String PRMCompetitorWRONG = 'You have Entered wrong Competitor Please Correct it and then try to convert';
  public static String ACCOUNTTYPECOMPITITOR = 'Competitor';
  // certification matrix class
  public static String  CertificationMatrixHelperPRM= 'CertificationMatrixHelperPRM';
  public static String updateGPPFields='updateGPPFields';
  // additional resources object
  public static String toolAccess = 'This tool is already requested for Selected User, Please select another tool';
  public static String AdditionalResourceRequest = 'AdditionalResourceRequest';
  public static String additionalResTool = 'additionalResTool';
  
  // dynamic tool display
  public static String SFDC_PRM_Access = 'SFDC PRM Access';
  public static String Personal_Space = 'Library';
  public static String Deal_Registration = 'Deal Registration';
  public static String CPQ_Tool = 'CPQ';
  public static String toolName = 'SFDC PRM Access';
  public static String NDAC_Name = 'NDAC Info Center and Training';
  public static String NDAC_DisplayName = 'NDAC Info Center';
  public static String NDAC_OfferOrder_Name = 'NDAC Offer and Order Tool';
  public static String Request_Status = 'Request';
  public static String updateContacts = 'updateContacts';
  public static String ContactFieldUpdateOnPartnerUserCreation = 'ContactFieldUpdateOnPartnerUserCreation';
  
  
  public static String DynamicToolDisplay = 'DynamicToolDisplay';
  public static String getDynamicTool = 'getDynamicTool';
  public static String getDynamicToolURL = 'getDynamicToolURL';
  
  //Profile
  public static String SYSTEM_ADMINISTRATOR = 'System Administrator';
  public static String NOKIA_SALES_PROFILE = 'Nokia Sales Profile';
  public static String PARTNER_SALES_MANAGER = 'Partner Sales Manager';
  public static String Internal = 'Internal';
  public static String PRM_LOGIN = 'PRM Partner Relationship Manager Login';
  public static String PCU_LOGIN = 'PRM Partner Community User Login';
  
  //Objects
  public static String OBJECT_ACCOUNT = 'Account';
  public static String OBJECT_OPPORTUNITY = 'Opportunity';
  public static String OBJECT_LEAD = 'Lead';
  public static String OBJECT_OFFER = 'Offer__c';
  public static String OBJECT_MODIFIED_OFFER = 'Offer';
  public static String OBJECT_Document = 'Document__c';
  public static string INDIRECT_RECORD_TYPE = 'Indirect_Record_Type';
  public static string DIRECT_RECORD_TYPE = 'Direct_Record_Type';
  
  public static String errormessagePart1 = 'The End Customer : "';
  public static String errormessagePart2 = '" Does not Exist in our system. Please Create a new Prospect Account ';
  
  //Account Record Types
  public static string LEGAL_ENTITY = 'Legal Entity';
  public static string CUSTOMER= 'Customer';
  public static string PROSPECT= 'Prospect';
  public static string EndCustomer = 'End Customer';
  public static String USER_OBJECT = 'User';
  
  //Account Record Types Dev Name
  public static string LEGAL_ENTITY_DEV = 'Legal_Entity';
  
  //Lead Record Types
  public static string DISTRIBUTOR_DEAL_REGISTRATION = 'Distributor Deal Registration';
  public static string INDIRECT_DEAL_REGISTRATION = 'Indirect Deal Registration';
  public static string RESELLER_DEAL_REGISTRATION = 'Reseller Deal Registration';
  public static string Indirect_Deal_Registration_Approved = 'Indirect Deal Registration Approved';
  
  //Lead Record Types Dev Name
  public static string DISTRIBUTOR_DEAL_REGISTRATION_DEV = 'PRMDistributor_Deal_Registration';
  public static string INDIRECT_DEAL_REGISTRATION_DEV = 'PRMIndirect_Deal_Registration';
  public static string Indirect_Deal_Registration_Approved_DEV = 'Indirect_Deal_Registration_Approved';
  
  //Case Record Type
  public static string INDIRECT_RESELLER_APPLICATION = 'Indirect_Reseller_Application';
  public static string INDIRECT_RESELLER_APPLICATION_NEW = 'Indirect Reseller Application';
  public static string HWS_ADVANCE_EXCHANGE_IN_DAYS = 'HWS Advance Exchange In Days';
  public static string HWS_CASE_ESCALATION = 'HWS Case Escalation';
  public static string CASE_VAR_RECORDTYPE = 'VAR_Fast_Track_Form';
  public static string VAR_FORM = 'VAR Fast-Track Form';
  public static string SALES_TO_COUNTRY_RECORDTYPE = 'IR_NIRA_Sales_to_Country';
  public static string SALES_TO_COUNTRY_RECORDTYPE_NEW = 'IR/NIRA Sales to Country';
  public static string Partner_Sales_Support_Requested = 'Partner Sales Support Requested';
  //Indirect Reseller Related Constant Values
  public static string CASE_STATUS_NEW = 'New';
  public static string CASE_STATUS_APPROVED_PSM = 'Approved by PSM';
  public static string CASE_STATUS_HOLD = 'On Hold';
  public static string UPDATE_PARENT_CASE_STATUS_HOLD = 'updateParentCaseStatusHold';
  public static string CASE_STATUS_APPROVED_BG = 'Approved by BG';
  public static string CASE_STATUS_APPROVED_COMP = 'Approved by Compliance';
  public static string Requested_CMD_Account = 'Requested CMD Account';
  public static string Onboarding_In_Progress = 'Onboarding in progress';
  public static string PI_STATUS_PENDING = 'Pending';
  public static string APPROVAL_ACTION_APPROVE = 'Approve';
  public static Integer PROCESS_INSTANCE_FETCH_LIMIT = 10000;
  public static String CASE_TRIGGER_HELPER = 'CaseTriggerHelper';
  public static String AUTO_APPROVE_FIRST_STEP = 'autoApproveFirstStep';
  public static String UPDATE_PARENT_CASE = 'updateParentCase';
  public static String UPDATE_PARENT_CASE_STATUS = 'updateParentCaseStatus';
  public static String UPDATE_CHILD_CASE_STATUS = 'updateChildCaseStatus';
  public static String GET_APPROVE_REJECTED_COUNTRY = 'getApproveAndRejectedCoun';
  // irtermclass
  public static String content_disposition = 'content-disposition';
  public static String attachment = 'attachment; filename=Nokia Indirect Reseller Agreement.pdf';
  
  
  // Case share Related Constant Values(Sales Support Requested)
  public static String CASE_SHARE_TO_OPPTY_MEMBER = 'caseShareToOpptyMember';
  public static String Partner_Relationship_Manager= 'Partner Relationship Manager';
  public static String Partner_Training_Manager= 'Training Manager';
  public static String SalesSupportRequested = 'Sales Support Requested';
  
  //Trigger Flag
  public static Boolean RUN_LEAD_TRIGGER_ON_LEAD_UPDATE = true;
  public static Boolean RUN_CONTENTDOCUMENTLINK_TRIGGER_ON_PARTNER_FILESHARING = true;
  public static Boolean RUN_OPPORTUNITY_TRIGGER_ON_LEAD_CONVERSION = true;
  
  //IRTermsCLass variable
  public static String FileName = 'Nokia Indirect Reseller Agreement';
  public static String contentdisposition = 'content-disposition';
  public static String attachment_PDF = 'attachment; filename=Nokia Indirect Reseller Application.pdf';
  public static String dash = ' - ';
  
  
  
  //Boolean 
  public static Boolean TRUE_VALUE = true;
  
  //Rebate form variable 
  public static String EnrollmentNotification= 'Enrollment Notification';
  public static String FinalReview = 'Final Review';
  public static String Reminder = 'Reminder';
  public static String InReview= 'In Review';
  
  public static String RebatePeriodHelper= 'RebatePeriodHelper';
  public static String RebateFormHelper= 'RebateFormHelper';
  public static String RebateFormClass = 'RebateFormClass';
  public static String Not_Enrolled = 'Not Enrolled';
  public static String RFUrl = '';
  
  public static String StatusRejected='Rejected';
  public static String StatusAccepted='Accepted';
  public static String Duplicate_Rebate_Period_is_not_allowed='Duplicate Rebate Period is not allowed';
  public static String No_Eligible_Accreditations='No Eligible Accreditations';
  public static String Missing_Accreditations='Missing Accreditations';
  
  
  
  //Rebate email Constants
  public static String NokiaRebateProgram = 'Nokia Rebate Program: invitation to enroll';
  public static String EnrollmentEmailBody0 = 'Enclosed please find important information about the Nokia Global Partner Rebate program. This program is designed to reward our partners who lead with and sell Nokia products to enterprise commercial customers.';
  public static String EnrollmentEmailBody1 = 'To participate you must apply, meet the eligibility requirements, accept the programs terms and conditions and enroll via the online enrollment form available in the Nokia partner portal ';
  public static String EnrollmentEmail0 = 'The enrollment period for ';
  public static String EnrollmentEmail1 = ' will end on ';
  public static String EnrollmentEmailBody2 = 'The eligible Nokia products during this rebate period and their associated rebate schedule can be found in the Nokia partner portal link mentioned above. Rebates will be accrued and measured on the recognized net revenue of these products.';
  public static String EnrollmentEmail2 = 'Supporting documentation including partner eligibility requirements by Nokia region and minimum revenue thresholds for the ';
  public static String EnrollmentEmail3 = ' can be found in the rebate article in the Nokia partner portal.';
  public static String EnrollmentEmailBody3 = 'If you have any questions, please contact your Nokia Partner Sales Manager. ';
  public static String EnrollNow = 'Enroll now!';
  public static String NokiaOffice = 'The Nokia Global Partner Program Office';
  public static String NokiaOffice2 = 'The Nokia Partner Program Office';
  public static String RebateSubmitSubject = 'Nokia Rebate Program: Enrolment Accepted ';
  public static String thanksOnsubmission = 'Good luck selling!';
  public static String submissionBody = 'We gladly inform you that your enrolment for the Nokia rebate program has been accepted for this period.';
  public static String enrollmentId = 'Nokia rebate Enrolment ID: ';
  public static String dateName = 'Date: ';
  public static String RejectedContract =  'You are not qualified for Nokia rebate program';
  public static String RejectedContractPart1 =  'We regret to inform you that you are not qualified for Nokia rebate program.';
  public static String RejectedContractPart2 ='Our records show that you are not meeting all the eligibility criteria, namely ';
  public static String RejectedContractPart3 ='If you believe that the information in our databases is incorrect, please contact your Nokia Partner Sales Manager.';
  public static String ExpiredContractSubject = 'Partner Rebate Program: PPA expiration';
  public static String ExpiredContractPart1 ='We herewith inform you that the PPA of ';
  public static String ExpiredContractPart2 =' has expired since the rebate enrolment.  Consequently, your partner is not meeting all the eligibility criteria anymore and the rebate calculation for the enrolled period will not be performed.';
  public static String ExpiredContractPart3 = 'Please update the record status from “Pending” to:';
  public static String ExpiredContractPart4 = '•  “Accepted – Second Review” if negotiations for contract renewal are ongoing and the PPA will be signed soon. (rebate will be calculated)';
  public static String ExpiredContractPart5 = '•  “Rejected” if the contract will not be renewed. (no rebate calculation)';
  public static String thanksAndRegards = 'Thank you and best regards.';
  public static String rePartner = 'Re: Partner Rebate Program ';
  //Opportunity Field Picklist Values
  public static string Accepted = 'Accepted';
  public static string Declined = 'Declined';
  public static string beforeInsertOppty= 'beforeInsertOppty';
  public static string beforeUpdateOppty= 'beforeUpdateOppty';
  public static string partnerUserFromSameAccountValidation= 'partnerUserFromSameAccountValidation';
  public static string partnerUserUpdateFromSameAccountValidation= 'partnerUserUpdateFromSameAccountValidation';
  public static string partnerUserFromSameAccountValidationError = 'Please select correct Partner User Name from Same Account.';  
  public static string RebateRejectionSubject = 'Partner Rebate Program: Partner rebate rejection';  
  public static string RebateRejectionPart1 = 'We herewith inform you that your ';  
  public static string RebateRejectionPart2 = ' has rejected the calculate rebate amount.';  
  public static string RebateRejectionPart3 = '   -   get in touch with your partner to understand the reason why ';  
  public static string RebateRejectionPart4 = '   -   ask your partner to send prove of the discrepancies';   
  public static string RebateRejectionPart5 = '   -   reach out to the finance team to discuss the discrepancies';  
  public static string RebateRejectionPart6 = '   -   conclude';	
  public static string RebateRejectionPart7 = '   -   inform your partner';  
  public static string RebateRejectionPart8 = '   -   update the record in sCRM.';
  public static string RebateCalculationPart0 = 'We herewith inform you that the Nokia rebate calculation for your ';  
  public static string RebateCalculation = 'Partner Rebate Program: rebate calculation';
  public static string RebateCalculationPart1 = ' has been done and we request you to:';  
  public static string RebateCalculationPart2 = '-   review the rebate amounts in sCRM';   
  public static string RebateCalculationPart3 = '-   inform your partner'; 
  public static string RebateCalculationPart4 = '-   request your partner to confirm his agreement with the calculated rebate or proves discrepancies (if any) within 2 weeks.';   
  public static string reminderPart1 = 'May we remind you that to participate and to take advantage of the Nokia rebate program for the next period, you are invited to enroll.';
  public static string reminderPart2 = 'The eligible products and rebate schedule for this period can be found here: ';
  public static string reminderPart3 = 'Enrolment is open via the online enrolment form available in the Nokia partner portal link mentioned above.';
  public static string reminderPart4 = 'Enroll now as enrolment will end on ';
  public static string reminderPart5 = 'Important to note that, part of the enrolment, you must accept the Nokia rebate terms and conditions outlined in the enrolment form. ';
  public static string reminderSubject = ' Nokia Rebate Program: Reminder to enroll';
  public static string PSM = 'PSM';
  public static string SubjectMissingAccreditation = 'Partner Rebate Program: Partner missing accreditations';
  public static string SubjectNoAccreditation = 'Partner Rebate Program: Partner not accredited ';
  public static string PartnerSalesManager = 'Partner Sales Manager';
  public static string NokiaPartner = 'Nokia Partner';
  public static string EndOfEnrollment = 'EndOfEnrollment';
  public static string duplicateAccount = 'duplicateAccount';
  public static string ContractExpired = 'ContractExpired';
  public static string NoError = 'NoError';
  public static String SemiColon= ';';
  public static String Enrolled= 'Enrolled';
  public static String createEnrollementonRebateInsert= 'createEnrollementonRebateInsert';
  public static String noAccredidationPart1= ' is not accredited for the participating technologies since the rebate enrolment. Consequently, your partner is not meeting the rebate eligibility criteria and the rebate calculation for the enrolled period will not be performed. ';
  public static String noAccredidationPart2= ' Please update the record status from "Pending" to: ';
  public static String noAccredidationPart3= 'Accepted – Second Review” and Rebate Amount Status from "Rejected" to "Accepted" only in exceptional cases justified and approved by the sales/partner program lead. (rebate will be calculated) ';
  public static String noAccredidationPart4 = '“Rejected” if not accredited. (no rebate calculation) ';
  public static String missingAccredidationPart1= ' is not accredited for some of the participating technologies since the rebate enrolment. Consequently, your partner is not meeting the rebate eligibility criteria and the rebate calculation for the enrolled period will not be performed for the not accredited technologies. ';
  //PRM Certification object field values
  public static string Portfolio = 'port__c';
  public static string Certification_Name = 'GPP_Certification_Name__c';
  public static string Count = 'mycount';
  public static string Certification_Status = 'Certification_Status__c';
  public static string Open = 'Open';
  public static string InProgress = 'In Progress';
  public static string PendingApproval = 'Pending Approval';
  public static string Completed = 'Completed';
  public static string Registered = 'Registered';
  public static string Approved = 'Approved';
  public static String HYPHEN = '-';
  public static String COLON = ':';
  public static String ContactNamePRM= 'ContactNamePRM';
  public static String ContactNamePSM= 'ContactNamePSM';
  public static String EmailContactNamePRM= 'EmailContactNamePRM@accenture.com';
  public static String EmailContactNamePSM= 'EmailContactNamePSM@accenture.com';
  
  //Technologies available for Rebate form
  public static string AirscaleWifi = 'Wi-Fi';
  public static string FixedAccessFBA = 'Fixed Access - FBA';
  public static string FixedAccessPOL = 'Fixed Access - POL';
  public static string IPRouting = 'IP Routing';
  public static string Microwave = 'Microwave';
  public static string Nuage = 'Nuage';
  public static string Optics = 'Optics';
  public static string VitalQIP = 'Vital QIP';
  public static string VitalSuite = 'Vital Suite';
  public static string AcceptedFirstReview= 'Accepted - First Review';
  public static string AcceptedSecondReview= 'Accepted - Second Review'; 
  public static string PPAContractExpired= 'PPA Contract Expired'; 
  public static string Pending= 'Pending'; 
  public static string OpticsWaveLite= 'Optics - WaveLite'; 
  
  
  // Test class constants
  public static String SysAdmin = 'System Administrator';
  public static String DataLoader = 'Data Loader Profile';
  
  public static String Aliass = 'standt';
  public static String PartnerUserAlias = 'test123';
  public static String TestEmail = 'test@accenture.com';
  public static String TestEmailPartnerUser = 'testpartner@accenture.com';
  public static String TestLName = 'Testing';
  public static string TestLanguageLocaleKey = 'en_US';
  public static string TestTimeZone = 'America/Los_Angeles';
  public static string Testt = '@test';   
  public static string TestOrg = '.org';
  public static string AccRecType = 'Customer';
  public static string AccredRecType = 'Reseller GPP 0.0';
  public static string Testtext = 'Test';
  public static string Test2 = 'Test2';
  public static string Test3 = 'Test3';
  public static string Test4 = 'Test4';
  public static string TestEmail1 = 'test@accenture.com';
  public static string TestEmail2 = 'test@accenture.com';
  public static string TestEmail3 = 'test@accenture.com';
  public static string TestEmail4 = 'test@accenture.com';
  public static string TestCert = 'Test-Certification';
  public static string TestCert2 = 'Test-Certification2';
  public static string TestPort1 = 'Wi-Fi'; 
  public static string TestPort2 = 'Microwave'; 
  public static string TestPort3 = 'IP Routing'; 
  public static string Idtext = 'id';
  public static string TestState = 'Afghanistan';
  public static string TestState2 = 'India';
  public static string Testbool = 'True';
  public static string NokiaPortal = 'Nokia Partner Portal Profile';
  public static string Testword = 'word';
  public static string CaseObject = 'Case';
  public static string CaseRecType = 'SF Support';
  public static string NewStatus = 'New';
  public static string priority = 'Low';
  public static string attachName = 'Unit Test Attachment';
  public static string attachBody = 'Unit Test Attachment Body';
  public static string CaseId = 'case id';
  public static string errormsg = 'An error occurred';
  public static string ERROR_INACTIVE_USER = 'The Chosen Partner is not active in the System, Please select the active Partner ';
  public static string Distibutor = 'Market North America';
  public static string targeted = 'Agriculture';
  public static string manufact = 'Ericsson';
  public static string primaryInt = 'Fixed networks (DSL, GPON, Passive Optical LAN)';
  public static string accName = 'STARHUB LIMITED';
  public static string countryHq = 'Albania';
  public static string Distr = 'Distributor';
  public static string IndirectReseller= 'Indirect Reseller';
  public static string BillingSt = '1660 International Dr';
  public static string BillingCity = 'McLean';
  public static string BillingState = 'Virginia';
  public static string postalCode = '22102';
  public static string BillingCountry = 'Canada';
  public static string ActiveSt = 'Active';
  public static string Industry = 'Enterprise';
  public static string BusinessType = 'Consultant';
  public static string MarketAcc = 'Market North America';
  public static string CountryAcc = 'Canada';
  public static string CBTCode = 'NAM US Regionals';
  public static string CustomerComp = 'Unassigned';
  public static string AccountNum = '301030871';
  public static string AccountProsp = 'Prospect';
  public static string BusinessPartnerRole = 'Value Added Reseller';
  public static string contactLastname = 'TestCon';
  public static string countryData = '{\n'+
  ' "Afghanistan": ' +
  '{  "distributor":"Wayne Enterprises",' +
  '"state":"",' +
  '"affil":"sss",' +
  '"regno":"222",' +
  '"sa1":"s",' +
  '"sa2":"s",' +
  '"sa3":"s",' +
  '"fax":"455",' +
  '"website":"ss",' +
  '"domain":"ss",' +
  '"phone":"22",' +
  '"postal":"22",' +
  '"city":"ss",' +
  '"saleslname":"ss",' +
  '"salesfname":"ss",' +
  '"checkbox":false,'+
  '"salesemail":"ss@ss.com",' +
  '"salesphone":"22",' +
	'"markfname":"ss",' +
	'"marklname":"ss",' +
	'"markemail":"ss@ss.com",' +
	'"markphone":"22",' +
	'"servfname":"ss",' +
	'"servlname":"ss",' +
	'"servemail":"ss@ss.com",' +
	'"servphone":"22"}\n' +
'}';
  public static string countryData1 = '{\n'+
  ' "Afghanistan": ' +
  '{  "distributor":"Wayne Enterprises",' +
  '"state":"",' +
  '"affil":"sss",' +
  '"regno":"222",' +
  '"sa1":"s",' +
  '"sa2":"s",' +
  '"sa3":"s",' +
  '"fax":"455",' +
  '"website":"ss",' +
  '"domain":"ss",' +
  '"phone":"22",' +
  '"postal":"22",' +
  '"city":"ss",' +
  '"saleslname":"ss",' +
  '"salesfname":"ss",' +
  '"id":"50021000003NPiI",' +  
  '"checkbox":false,'+
  '"salesemail":"ss@ss.com",' +
  '"salesphone":"22",' +
	'"markfname":"ss",' +
	'"marklname":"ss",' +
	'"markemail":"ss@ss.com",' +
	'"markphone":"22",' +
	'"servfname":"ss",' +
	'"servlname":"ss",' +
	'"servemail":"ss@ss.com",' +
	'"servphone":"22"}\n' +
'}';
  
  // Exception Handing variables
  public static string IRApplicationCase = 'IRApplicationCase';
  public static string VARApplicationCase = 'VARApplicationCase';
  public static string getCurrentUser = 'getCurrentUser';
  
  public static string afterDelete = 'afterDelete';
  public static string afterUpdateOppty = 'afterUpdateOppty';
  public static string afterInsert = 'afterInsert';
  public static string sendNotificationOnApproved = 'sendNotificationOnApproved';
  public static string sendNotificationOnDeclined = 'sendNotificationOnDeclined';
  public static string partnerOpportunityTeam = 'partnerOpportunityTeam';
  public static string OpportunityTriggerHandlerPRM = 'OpportunityTriggerHandlerPRM';
  public static string OpportunityTeamHandlerPRM = 'OpportunityTeamHandlerPRM';
  public static string beforeInsertOTM= 'beforeInsertOTM';
  public static string OpportunityTriggerHelperPRM = 'OpportunityTriggerHelperPRM';
  public static string mGetCaseDetails = 'mGetCaseDetails';
  public static string saveTheFile = 'saveTheFile';
  public static string saveTheChunk = 'saveTheChunk';
  public static string getCaseMarket = 'getCaseMarket';
  public static string getCaseCompanytype = 'getCaseCompanytype';
  public static string getCaseAnnualRevenue = 'getCaseAnnualRevenue';
  public static string getCaseRevServices = 'getCaseRevServices';
  public static string getCaseNumOfEmployees = 'getCaseNumOfEmployees';
  public static string getCaseTechProfessional = 'getCaseTechProfessional';
  public static string getCaseEmpInSales = 'getCaseEmpInSales';
  public static string getCaseEmpInService = 'getCaseEmpInService';
  public static string getCaseEmpInMarketing = 'getCaseEmpInMarketing';
  public static string getCaseRepNokia = 'getCaseRepNokia';
  public static string getCaseVerticalFocus = 'getCaseVerticalFocus';
  public static string getCaseManufacture = 'getCaseManufacture';
  public static string getCasePrimaryInterest = 'getCasePrimaryInterest';
  public static string getCaseMaintenanceSupport = 'getCaseMaintenanceSupport';
  public static string getCaseCountry = 'getCaseCountry';
  public static string getCaseState = 'getCaseState';
  public static string getCaseSellNokia = 'getCaseSellNokia';
  public static string getDistributor = 'getDistributor';
  public static string getStateValues = 'getStateValues';
  public static string CaseName = 'Case';
  public static string FileUTF = 'UTF-8';
  public static String Message ='true';
  public static String uProfile ='Nokia Partner Portal Profile';
  public static String recordType_case='Indirect_Reseller_Application';
  public static String CaseStatus ='New';
  public static String Distributor1 ='Europe';
  public static string getCaseSalesTerr = 'getCaseSalesTerr';  
  public static string getValuesFromAccount = 'getValuesFromAccount';  
  public static String LeadToOpptyConversionMail ='Lead Converted to Opprtunity';
  public static String OtherSupportMessage ='Other Support Accept/Decline';
  public static String PricingSupportMessage ='Pricing Support Accept/Decline';
  public static String TechnicalSupportMessage ='Technical Support Accept/Decline';
  public static String SalesSupportMessage ='Sales Support Accept/Decline';
  public static string ValueAddedReseller = 'Value Added Reseller'; 
  public static string indirectToDirectUpdate = 'indirectToDirectUpdate'; 
  public static string Closed = 'Closed'; 
  public static string Cancelled = 'Cancelled'; 
  
  //opportunity value picklist value
  public static String OPPORTUNITYTYPE = 'Standard Opportunity';
  public static String ContractSigningEntity = 'fALU';
  //AccountROle
  public static String AlliancePartner = 'Alliance Partner';
  public static String GPPDistributorPartner = 'GPP Distributor Partner';
  public static String GPPSPAAPpartner = 'GPP SPAAP partner';
  public static String GPPVARpartner = 'GPP VAR partner';
  public static String Industrialpartner = 'Industrial partner';
  //Account Partner Type
  public static String IndustrialPartnerSystemIntegrator = 'Industrial Partner / System Integrator';
  public static String ServiceProvider = 'Service Provider';
  
  //Email Template Support Request
  public static String SubjectSales = 'Sales Support Request has been approved';
  public static String SubjectOther = 'Other Support Request has been approved';
  public static String SubjectPricing = 'Pricing Support Request has been approved';
  public static String SubjectTechnical = 'Technical Support Request has been approved';
  public static String SubjectSalesReject = 'Sales Support Request has been Declined';
  public static String SubjectOtherReject = 'Other Support Request has been Declined';
  public static String SubjectPricingReject = 'Pricing Support Request has been Declined';
  public static String SubjectTechnicalReject = 'Technical Support Request has been Declined';
  public static String SalesApproved = 'A request for Sales support has been Accepted.';
  public static String OtherApproved = 'A request for Other support has been Accepted.';
  public static String PricingApproved = 'A request for Pricing support has been Accepted.';
  public static String TechnicalApproved = 'A request for Technical support has been Accepted.';
  public static String SalesRejected = 'A request for Sales support has been Declined.';
  public static String OtherRejected = 'A request for Other support has been Declined.';
  public static String PricingRejected = 'A request for Pricing support has been Declined.';
  public static String TechnicalRejected = 'A request for Technical support has been Declined.';
  public static String NextLine =  '\n' ;
  public static String LinkforPartner = 'Please Click on the link below to access the Opportunity details.';
  public static String Thanks = 'Thanks,';
  public static String OpptyName = 'Opportunity Name: ';
  public static String NokiaTeam = 'Nokia Global Partner Program Team';
  public static String Opportunity = 'opportunity/';
  public static String PRMcommunityURLExt = '/s/';
  public static String Dear = 'Dear ';
  public static String SenderMail = 'no-reply@nokia.com';
  public static String comma = ',';
  public static String Convert = 'Your Deal has been converted to Opportunity.';
  public static String YES= 'Yes';
  public static String NO= 'No';
  public static String makeCommentsMandatoryRejectedDeal= 'makeCommentsMandatoryRejectedDeal';
  public static String Lead_Share= 'afterInsertLead';
  public static String activeAccountAsCompany= 'activeAccountAsCompany';
  public static String activeAccountAsCompany_ErrorMSG= 'activeAccountAsCompany_ErrorMSG';
  
  
  //IRApplication related constants
  //Access Type
  public static String WRITE_ACCESS = 'Read/Write';
  public static String READ_ACCESS = 'Read Only';
  public static String EDIT = 'Edit';
  public static String ALL_ACCESS = 'All';
  public static String READ = 'Read';
  public static String ERROR = 'error';
  public static String QUERY_EXCEPTION = 'QueryException occured';
  public static String DML_EXCEPTION = 'DMLException occured';
  public static String GENERIC_EXCEPTION = 'Exception occured';
  
  public static Integer RELATED_LIST_QUERY_LIMIT = 1000;
  public static Integer SOQL_QUERY_ROWS=50000;
  public static String LINE_NO = 'Line No';
  public static String CAUSE = 'Cause';
  public static String OTHER = 'Other';
  public static String ROP ='RoP';
  public static String UNRESTRICTED_VALUE = 'Unrestricted';
  public static String RESTRICTED_VALUE = 'Restricted';
  public static String CONFIDENTIAL_VALUE = 'Confidential';
  public static String LASTMODIFIED_BY = 'LastModifiedBy';
  public static String LASTMODIFIED_DATE = 'LastModifiedDate';
  public static String afterUpdateLead= 'afterUpdateLead';
  
  public static String BATCH_APEX = 'BatchApex';
  public static String PROCESSING = 'Processing';
  public static String PREPARING = 'Preparing';
  public static String UTF_8 ='UTF-8';
  
  public static string UNDERSCORE_C = '__c';
  public static string PARTNER = 'Partner';
  public static string BOOKED = 'Booked';
  public static string CANCEL = 'Cancelled';
  public static string LOST = 'Lost';
  public static string BLANK_VALUE = '';
  public static string FILE_SHARE_TYPE_C = 'C';
  public static string FILE_SHARE_TYPE_V = 'V';
  public static string FILE_SHARE_TYPE_I ='I';
  public static string ALL_USERS = 'AllUsers';
  
  //Variables for Announcement Class
  public static string LANGUAGE = 'en_US';
  public static string PUBLISH_STATUS = 'Online';
  public static Integer ANNOUNCEMENT_LIMIT = 1000;
  public static String ANNOUNCEMENT_CONTROLLER = 'AnnouncementController';
  public static String GET_ANNOUNCEMENT = 'getAnnouncements';
  public static String CaseTriggerHandler = 'CaseTriggerHandler';
  public static String BusinessPlanTriggerHandler = 'BusinessPlanTriggerHandler';
  public static String BusinessPlanTriggerHelper = 'BusinessPlanTriggerHelper';
  public static String BusinessPlanShare = 'businessplanShare';
  public static String  businessplanSharePSM= 'businessplanSharePSM';
  public static String BPApprovalStatus = 'Submitted';
  public static String ObjBusinessPlan = 'Business_Plan__c';
  public static String afterInsertCertificateOperation= 'afterInsertCertificateOperation';
  
  //Variables for adding Exceptions in Class
  public static String CertificationTriggerHelper = 'CertificationTriggerHelper';
  public static String CertificationTriggerHandler = 'CertificationTriggerHandler';
  public static String updateGPPFieldsonCert= 'updateGPPFieldsonCert';
  public static String updateGPPFieldsonCertonInsert= 'updateGPPFieldsonCertonInsert';
  public static String GET_CertValues = 'getCertificationsValuesforComponent';
  public static String GET_AccredValues = 'getAccreditationValuesforComponent';
  public static String GET_Wrapper = 'getWrapper';
  public static String CertificationRecords_Controller = 'CertificationRecords';
  public static String CommunityDynamic_Controller = 'CommunityDynamicImage';
  public static String GET_UserPartner = 'getUserPartner';
  public static String GET_UserHeading = 'getUserHeading';
  public static String LeadConversionTriggerHelper = 'LeadConversionTriggerHelper';
  public static String ConversionFutureMethod = 'ConversionFutureMethod';
  public static String leadConversion = 'leadConversion';
  public static String beforeConversion= 'beforeConversion';
  public static String afterUpdateCertificationSharePSM = 'afterUpdateCertificationSharePSM';
  public static String afterUpdateCertificationSharePRM= 'afterUpdateCertificationSharePRM';
  
  public static String NoAccreditation= 'No Accreditation';
  
  
  
  public static String populateDistributorAccount= 'populateDistributorAccount';
  
  public static String updateDistributorAccount = 'updateDistributorAccount';
  
  //Variables for AccountTriggerHandler Class
  public static String ACCOUNT_TRIGGER_HANDLER = 'AccountTriggerHandler';
  public static String RESTRICT_RNABLING_PARTNER = 'restrictEnablingPartner';
  public static String createPartnerLibrary = 'createPartnerLibrary';
  public static String updateARRtools = 'updateARRtools';
  public static String deactivateUser = 'deactivateUser';
  
  
  //Variables for AccountTriggerHelperPRM Class
  public static String ACCOUNT_TRIGGER_HELPER_PRM = 'AccountTriggerHelperPRM';
  public static String DeactivateUserfuture = 'deactivateUserfuture';
  public static String updateCertValueONPaertnerProgram = 'updateCertValueONPaertnerProgram ';
  public static String UPDATE_PARTNER_COMPANY = 'updatePartnerCompany';
  public static String DELETE_PARTNER_COMPANY = 'deletePartnerCompany';
  public static String UPDATE_PARTNER_COMPANY_ON_CHANGE = 'UPDATE_PARTNER_COMPANY_ON_CHANGE';
  
  //Variables for LeadTriggerHandler Class 
  public static String LEAD_TRIGGER_HALPER = 'LeadTriggerHelperPRM';
  public static String MAKE_REJECTCOMMENTS_MANDATORY = 'makeRejectCommentsMandatory';
  public static String PENDING_STATUS = 'Pending';
  public static String REJECTED_STATUS = 'Rejected';
  public static String LEAD_TRIGGER_HANDLER_PRM= 'LeadTriggerHandlerPRM';
  public static String BEFORE_UPDATE_OPERATION= 'beforeUpdateOperation';
  public static String updateValueAssignment = 'updateValueAssignment';
  
  //Variables for OpportunityTeamHelper_PRM Class
  public static String MANUAL = 'Manual';
  public static String OPPORTUNITY_TEAM_HELPER_PRM ='OpportunityTeamHelper_PRM';
  public static String SHARE_FILES_ON_INSERT = 'shareFilesOnInsert';
  public static String UNSHARE_FILES_ON_DELETE = 'unshareFilesOnDelete'; 
  public static string ShareOpptyWithApprover = 'ShareOpptyWithApprover';
  public static string populateDODRevokedDate = 'populateDODRevokedDate';
  public static string restrictDODStatusforBusOps = 'restrictDODStatusforBusOps';
  public static string afterOTMDelete= 'afterOTMDelete'; 
  public static string deletePartnerFromOTM= 'deletePartnerFromOTM';
  public static string ACC_LINK_MERGED= 'ACC_LINK_MERGED';
  public static string accountSlash = 'account/';
  public static string deletePartnerFromDiffAccount= 'deletePartnerFromDiffAccount';
  public static string deletePartnerFromDiffAccountValidationError = 'Due to confidentiality of information limitations between Partners, adding a Partner User of one Account to an Opportunity of a different Account is not allowed for these Partners. If further clarification is required, open a PRM Support ticket.';
  public static string dodErrorMessage = 'Deal Origination Discount Status can only be edited by Bus Ops Approver or PSM.';
  public static string dodErrorMessage2 = 'You are not authorized to select this Deal Origination Discount Status.';
  //Variable for AccountTriggerHandlerPRM class
  public static string AccountTriggerHandlerPRM = 'AccountTriggerHandlerPRM';
  public static string afterUpdate= 'afterUpdate'; 
  public static string beforeDelete= 'beforeDelete'; 
  //public static string beforeUpdateOperation= 'beforeUpdateOperation'; 
  //varibale for rebate form
  public static string RebateAmountHandler= 'RebateAmountHandler';
  public static string RebateAmountHelper= 'RebateAmountHelper';
  public static string amountUpdate= 'amountUpdate';
  //Variable for AccountTeamMemberPRM class
  
  public static string OpenLead='Open';
  public static string RedirectedPRM='Redirected - Partner Sales Manager';
  public static string SentToPartner='Sent to Partner';
  //Variable for LeadTriggerHelperPRM class
  public static String AccountTeamMemberPRM ='AccountTeamMemberPRM';
  public static String unshareCertificationOnDelete ='unshareCertificationOnDelete';
  public static String unshareLeadOnDelete ='unshareLeadOnDelete';
  public static String shareLeadOnInsert ='shareLeadOnInsert';
  public static String shareCertificationOnInsertPRM ='shareCertificationOnInsertPRM';
  public static String shareLeadOnUpdate ='shareLeadOnUpdate';
  public static String shareCertificationOnUpdatePRM ='shareCertificationOnUpdatePRM';
  public static String shareCertificationOnUpdatePSM ='shareCertificationOnUpdatePSM';
  public static String shareLeadOnUpdateAccountRole ='shareLeadOnUpdateAccountRole';
  public static String shareCertificationOnUpdateAccountRolePRM ='shareCertificationOnUpdateAccountRolePRM';
  public static String shareCertificationOnUpdateAccountRolePSM ='shareCertificationOnUpdateAccountRolePSM';
  public static String shareCertificationOnInsertPSM ='shareCertificationOnInsertPSM';
  public static String OrgWideAddress= 'Nokia Global Partner Communications';
  public static String NotificationEmailTemplate = 'Business Planning Notification Email Template';
  public static String ReminderEmailTemplate = 'Business Planning Reminder Email Template';
  public static String NotificationSubject = 'Nokia Partner Business Plan Template – Invitation to Submit';
  public static String BpReminderSubject = 'Nokia Business Plan Template – Reminder to Submit';
  public static string partner_email_community_URL = System.Label.partner_email_community_URL;
  
  public static string BusinessPlanningBatch = 'BusinessPlanningBatch';
  public static string Execute = 'Execute';
  Public static String ACCOUNT_TRIGGER_HANDLER_RESTRICTENABLINGPARTNER = 'restrictEnablingPartner';
  public static String OBJECT_BUSINESS_PLAN = 'Business_Plan__c';
  public static String OBJECT_BUSINESSPLAN = 'Business Plan';
  public static String UNDERSCORE = '_';
  public static String EMPTY_STRING = '';
  public static String OR_STRING = ' OR ';
  public static String BPR = 'BPR';
  public static String BPN = 'BPN';
  public static String BP_Subject = 'Apex Sharing Recalculation ';
  public static String BP_body = 'The batch Apex job processed ';
  public static String BP_batches = 'batches with ';
  public static String BP_failures = ' failures.';
  public static String afterUpdateCertificateOperation = 'CertificationTerigger - afterUpdateCertificateOperation';
  //bp validation error messages
  public static String sellIONs = 'Please complete “ION service(s) you intend to sell”.';
  public static String exIONs = 'Please complete "Expected Amount ION Service Revenue".';
  public static String sellIONp = 'Please complete “ION product(s) you intend to sell”.';
  public static String exIONp = 'Please complete "Expected Amount ION Product Revenue".';
  public static String onlyYYION= 'If you select "Expected YY Growth by ION", please enter either ION Product or/and ION Service details.';
  public static String noYYION= 'Please select a value for “Expected YY Growth by ION”.';
  public static String sellFNs ='Please complete “FN service(s) you intend to sell”.';
  public static String exFNs = 'Please complete "Expected Amount FN Service Revenue".';
  public static String sellFNp = 'Please complete “FN product(s) you intend to sell”.';
  public static String exFNp = 'Please complete "Expected Amount FN Product Revenue".';
  public static String onlyYYFN = 'If you select "Expected YY Growth by FN", please enter either FN Product or/and FN Service details.';
  public static String noYYFN = 'Please select a value for “Expected YY Growth by FN”.';
  public static String sellMNs ='Please complete “MN service(s) you intend to sell”.';
  public static String exMNs = 'Please complete "Expected Amount MN Service Revenue".';
  public static String sellMNp = 'Please complete “MN product(s) you intend to sell”.';
  public static String exMNp = 'Please complete "Expected Amount MN Product Revenue".';
  public static String onlyYYMN = 'If you select "Expected YY Growth by MN", please enter either MN Product or/and MN Service details.';
  public static String noYYMN = 'Please select a value for “Expected YY Growth by MN”.';
  public static String sellAAs ='Please complete “AA service(s) you intend to sell”.';
  public static String exAAs = 'Please complete "Expected Amount AA Service Revenue".';
  public static String sellAAp = 'Please complete “AA product(s) you intend to sell”.';
  public static String exAAp = 'Please complete "Expected Amount AA Product Revenue".';
  public static String onlyYYAA = 'If you select "Expected YY Growth by AA", please enter either AA Product or/and AA Service details.';
  public static String noYYAA = 'Please select a value for “Expected YY Growth by AA”.';
  public static String sellGSs ='Please complete “GS service(s) you intend to sell”.';
  public static String exGSs = 'Please complete "Expected Amount GS Service Revenue".';
  public static String sellGSp = 'Please complete “GS solution(s) you intend to sell”.';
  public static String exGSp = 'Please complete "Expected Amount GS Solutions Revenue".';
  public static String onlyYYGS = 'If you select "Expected YY Growth by GS", please enter either GS Solution or/and GS Service details.';
  public static String noYYGS = 'Please select a value for “Expected YY Growth by GS”.';
  public static String noBPI = 'Please complete all mandatory fields in “Business Plan Information” section';
  public static String noPSS = 'Please complete all mandatory fields in “Partner Overview – Company Profile and Strategy Summary” section';
  public static String noGIS = 'Please complete all mandatory fields in “Business Objectives - Global Information” section';
  public static String noMTI = 'Please create at least one record of each related plan: “Marketing” and “Training and Certification”';
  public static String ServiceDefaultVal = 'Enter Service';
  public static String ProductDefaultVal = 'Enter Product';
  public static String BPTRiggerHelper = 'BusinessPlanTriggerHelper';
  public static String ValidateApprovalProcessCriteria = 'ValidateApprovalProcessCriteria';
  public static String NewLineChar = '\n';
  public static String parameterChar = '?Id';
  public static String ofChar = ' of ';
  public static String CustomLeadConversion = 'CustomLeadConversion';
  public static String UpdateLead = 'updateLead';
  public static String GetInactiveAccName = 'getInactiveAccName';
  public static String GetName = 'getName';
  public static String ConvertLead = 'ConvertLead';
  public static String GetContactDeatils = 'getContactDeatils';
  public static String GetLeadDeatils = 'getLeadDeatils';
  
  // PRM trigger
  public static String beforeInsertOperation = 'beforeInsertOperation';
  public static String beforeUpdateOperation = 'beforeUpdateOperation';
  public static String beforeDeleteOperation = 'beforeDeleteOperation';
  public static String afterInsertOperation = 'afterInsertOperation';
  public static String afterUpdateOperation = 'afterUpdateOperation';
  public static String afterUpdateForCOOP = 'afterUpdateForCOOP';
  public static String afterInsertForCOOP = 'afterInsertForCOOP';
  public static String afterDeleteForDeal = 'afterDeleteForDeal';
  
  //Co-Op Allocation/ Accrual/ Payment/Claim Constants
   public static String CoopFundHandlerPRM = 'CoopFundHandlerPRM';
  public static String CoOpActivitHandler = 'CoOpActivitHandler';
  public static String CoOpActivityTriggerHelper = 'CoOpActivityTriggerHelper';
  public static String CoopAccrualHandler = 'CoOpAccrualHelperHandler';
  public static String DealProductHelper = 'DealProductHelper';
  public static String UserHandler = 'UserHandler';
  public static String UserHandlerPRM = 'UserHandlerPRM';
  public static String CoopAccrualHelper = 'CoopAccrualHelper';
  public static String CoOpPaymentHandler = 'CoOpPaymentHandler';
  public static String CoOpPaymentHelper = 'CoOpPaymentHelper';
  public static String CoOpClaimHandler = 'CoOpClaimHandler';
  public static String CoOpClaimTriggerHelper = 'CoOpClaimTriggerHelper';
  public static String CoOpTransferHandler = 'CoOpTransferHandler';  
  public static String AllocationClaimJunctionHelper = 'AllocationClaimJunctionHelper';
  public static String monthlyAccrualCreation = 'monthlyAccrualCreation'; 
  public static String createAccuarls = 'createAccuarls';
  public static String CoopFundHelperPRM = 'CoopFundHelperPRM';
  public static String populateApprovers = 'populateApprovers';
  public static String On_Hold = 'On Hold';
  public static String Today = 'Today';
  public static String autoReject = 'Auto Reject By System.'; 
  public static String autoRejectActivity = 'autoRejectActivity';
  public static String activityPending = 'Pending Approval';
  public static String pastDateException = 'Activity Start Date occurred in the past';
  public static String unshareFundOnDelete = 'unshareFundOnDelete';
  public static String shareFundOnCreation = 'shareFundOnCreation';
  public static String updateShowEmailToExternalUsers = 'updateShowEmailToExternalUsers';
  public static String unshareFundOnUserDeactivation = 'unshareFundOnUserDeactivation';
  public static String coopEligibleAccountAccrualandFundCreation = 'coopEligibleAccountAccrualandFundCreation';
  public static String CoopHFLOF = 'HFLOF';
  public static String CoopSubmitted = 'Submitted';
  public static String Claimable = 'Claimable';
  public static String CoopEscalated = 'Escalated';
  public static String CoopIncomplete = 'Incomplete';
  public static String CoopNormal = 'Normal';
  public static String CoopReimbursed = 'Reimbursed';
  public static String CoopPendingReimbursement =  'Pending Reimbursement';
  public static String CoopAwaitingReimbursement = 'Awaiting Reimbursement';
  public static String CoopPassedAudit = 'Passed Audit';
  public static String Coopactive = 'Active';
  public static String coopRejected = 'Rejected';
  public static Integer CoopHFLOFExpiryDuration = 180 ;
  public static Decimal Zero = 0;
  public static String December = 'December';
  public static String January = 'January';
  public static String February = 'February';
  public static String March = 'March';
  public static String April = 'April';
  public static String May = 'May';
  public static String June = 'June';
  public static String July = 'July';
  public static String August = 'August';
  public static String September = 'September';
  public static String October = 'October';
  public static String November = 'November';
  public static String CLAIM_OBJECT = 'Claim__c';
  public static String EXPIRED = 'Expired';
  public static String Partially_active = 'Partially active';
  public static String Main_Fund = 'Main Fund';
  public static String Validation_Error_Message_For_COOP_Approval = '   Co-op activities must be submitted for approval at least 15 Days prior to the activity start date';
  public static String Validation_Error_Message_For_Version_upload = 'You are only allowed to upload the New Version of Proof of Performance if the Claim is in following Status: Claimable, Escalated , Incomplete';
  public static String Fifteen_DAY = '15 DAY';
  public static String FIFTEENDAYSUBJECT = '15 Days Co-op Allocation Expiry Notification. Please submit claims for audit.';
  public static String FIFTEENDAYDISCRIPTION = 'The identified Co-op allocation will expire in 15 days and will be removed from your Co-op balance. Submit claims for audit prior to the Allocation expiry date. Allocations may NOT be reinstated or extended.';
  public static String THEERTYDAY = '30 DAY';
  public static String THEERTYDAYSUBJECT = '30 Days Co-op Allocation Expiry Notification. Please submit claims for audit.';
  public static String THEERTYDAYDISCRIPTION = 'The identified Co-op allocation will expire in 30 days and will be removed from your Co-op balance. Submit claims for audit prior to the Allocation expiry date. Allocations may NOT be reinstated or extended.';
  
  //Claim File upload 
  public static String ContentDocumentHandlerPRM = 'ContentDocumentHandlerPRM';
  public static String restrictFileDeleteOnClaim = 'restrictFileDeleteOnClaim';
  public static String restrictFileUploadOnClaim = 'restrictFileUploadOnClaim';
  public static String restrictFileUploadOnClaimErrorMessage = 'You are only allowed to Upload the Proof of Performance if the Claim is in the following Status: Claimable, Escalated, Incomplete';
  public static String restrictFileDeleteOnClaimErrorMessage = 'You are only allowed to delete the Proof of Performance if the Claim is in the following Status: Claimable, Escalated, Incomplete';
  //Coop Email templates
  public static String URGENT = 'URGENT';
  public static String Co_op_Allocation_of = 'Co-op Allocation of';
  public static String EXPIRING_IN_15_DAYS_FINAL_NOTICE = 'EXPIRING IN 15 DAYS - FINAL NOTICE';
  public static String Dear_User = 'Dear User';
  public static String The_Co_op_allocation_identified_below_will_expire_on = 'The Co-op allocation identified below will expire on';
  public static String and_will_be_removed_from_your_Co_op_balanceOpen_activitieswillNOT_prevent_allocations_from_expiring = 'and will be removed from your Co-op balance.  Open activities will NOT prevent allocations from expiring.';
  public static String Dear_User2 = 'Dear User2';
  public static String Dear_User3 = 'Dear User3';
  
  //AccreditationAutomation
  public static String AccreditationLevelChange = 'AccreditationLevelChange';
  public static String evaluteAccreditationForLevelChange = 'evaluteAccreditationForLevelChange';
  public static String SendEmailManualAccreditationUpdate = 'SendEmailManualAccreditationUpdate';
  public static String SendEmailAccreditationLevelDowngarde = 'SendEmailAccreditationLevelDowngarde';
  public static String updateAccNAccreditation = 'updateAccNAccreditation';
  public static String AccreditationHandler = 'AccreditationHandler';
  public static String AccreditationHelper = 'AccreditationHelper';
  public static String updateAccreditationCont = 'updateAccreditationCont';
  public static String accountAcreditationUpdate = 'accountAcreditationUpdate';
  public static String ContractHandler = 'ContractHandler';
  public static String ContractHelper = 'ContractHelper';
  public static String updateAccreditation = 'updateAccreditation';
  public static String accreditationUpdate = 'accreditationUpdate';
  public static String emailOptOutPolicy_Filter = 'FILTER';
  public static String accrdeitationQuery_Part1 = 'select id, name, Accreditation_Level__c, Pricing_Level_Override__c, Pricing_Override_Expiration__c, Accreditation_Type__c, Evaluated_Accreditation__c, Manual_Accreditation_Level_Update__c, Market__c, Downgrade_Grace_Period_End_Date__c, Meets_Lab_Equipment_Requirements__c, Partner__c, Partner__r.name, Partner_Program__c, Partner_Type__c, Portfolio__c, Active_Contract_Types__c, Partner_Business_Plan_Status__c, Shift_Model__c, Third_Party_Screening__c, Geo_Level_1_Name__c, ';
  public static String accrdeitationQuery_Part2 = ' from Accreditation__c where Evaluated_Accreditation__c = true';
  public static String BPQuery = 'select id, Partner_Business_Plan_Status__c from Accreditation__c where Partner_Business_Plan_Status__c = \'Approved\' OR Partner_Business_Plan_Status__c = \'Submitted\'';
  public static String accreditationueryBP_Part1= 'select id, name, Portfolio__c, Partner__c, ';
  public static String accreditationueryBP_Part2= ' from Accreditation__c where Partner__c in: accID';
  public static String BPStatus_NotSubmitted = 'Not Submitted';
  public static String BPStatus_Approved = 'Approved';
  public static String BPStatus_Submitted = 'Submitted';
  public static String ContractActive = 'Active_Contract_Types__c';
  public static boolean CertificationCountUpdateExecuted= false;
  public static boolean accreditationAutomationRepricing = false;
  
  //Contentdochandler
  public static boolean CustomLeadConversionFile = false; 
  public static String ContentDocumentLinkHandlerPRM = 'ContentDocumentLinkHandlerPRM';
  public static String Read_Only_Direct = 'Read Only Direct';
  public static String Read_Only_Indirect = 'Read Only Indirect';
  public static String Oppotunity_error_version_update = 'You cannot upload a new version once opportunity is closed';
   public static String Contentdocumhandlererror ='You Cannot Delete a file after your Opportunity is Closed';
  public static String Contentdocumhandlererror2='You Cannot Delete a file after your Lead is approved';
  public static String ContentVersionHandlerPRM = 'ContentVersionHandlerPRM';
  public static String restrictNewVersionUpload = 'restrictNewVersionUpload';
   public static String restrictNewVersionUploadOnClaim = 'restrictNewVersionUploadOnClaim';
  //uploadfiles
  public static String UploadPOPClaim = 'UploadPOPClaim';
  public static String SUCCESS = 'SUCCESS';
  public static String getClaimData = 'getClaimData';
  public static String BPN_PRM_SUBJECT = 'Reminder to renew your annual Nokia Business Plan by February 28th.';
  public static String BPN_PRM_COMMENT = 'Reminder to renew your annual Nokia Business Plan by February 28th. A Business Plan is required for all Partners and Distributors to maintain an expert or premier status. This Business Plan is designed to help determine the level of investment required to continue to grow and sell Nokia products and services to enterprise commercial customers.  If you have any questions, please contact your Nokia Partner Sales Manager.';
  public static String BPN_PSM_SUBJECT = 'Reminder to renew Partner Business Plans by February 28th.';
  public static String BPN_PSM_COMMENT = 'Your business partner has been issued a task reminder to update their annual Nokia Business Plan by February 28th. Please follow up with your partners as necessary.';
  public static String BPR1_PRM_SUBJECT = 'Reminder to renew your Nokia Business Plan by February 28th.';
  public static String BPR1_PRM_COMMENT= 'Reminder to renew your annual Nokia Business Plan by February 28th. A Business Plan is required for all Partners and Distributors to maintain an expert or premier status. This Business Plan is designed to help determine the level of investment required to continue to grow and sell Nokia products and services to enterprise commercial customers.   any questions, please contact your Nokia Partner Sales Manager.';
  public static String BPR2_PRM_SUBJECT = 'Reminder your Nokia Business Plan is due today.';
  public static String BPR2_PRM_COMMENT = 'Reminder to renew your annual Nokia Business Plan by February 28th. A Business Plan is required for all Partners and Distributors to maintain an expert or premier status. This Business Plan is designed to help determine the level of investment required to continue to grow and sell Nokia products and services to enterprise commercial customers.  If you have any questions, please contact your Nokia Partner Sales Manager.';
  public static String REVIEW_PSM_SUBJECT = 'Reminder to conduct your mid-year Business Plan review with your Partners.';
  public static String REVIEW_PSM_COMMENT = 'If you have not done so, please conduct a Business Plan review with your Partners to ensure they are tracking to the business objectives set for the year.';
  public static String createTaskForReviewEmail = 'createTaskForReviewEmail';
  public static String createTasksForBPR2 = 'createTasksForBPR2';
  public static String createTasksForBPR1 = 'createTasksForBPR1';
  public static String createTasksForBPN = 'createTasksForBPN';
  public static String BPR1 = 'BPR1';
  public static String BPR2 = 'BPR2';
  public static String BP_Bacth_Query1 = 'SELECT Id, Partner_Type__c FROM Account ';
  public static String BP_Bacth_Query2 = 'WHERE Active__c = True AND (';
  public static String BP_Bacth_Query3 = ')';
  public static String Id = 'Id';
  public static String None = 'None';
  public static String AccreditationLevelChangeReason_AutoUpdate = 'Automated Level Change';
  public static String Quote_repricing = 'Quote-repricing';
  public static String downgradeSubject = ' is marked for level downgrade';
  public static String downgradeMsg1 = 'Dear Reginal Leads,' + '\r\n' + '\r\n' + 'Acceriditation # ';
  public static String downgradeMsg2 = ' is marked for level downgrade.' + '\r\n' + 'Kindly work with PRM uses  to take appropriate action to maintain the Current accreditation level. Please find more details for accreditation as below:' + '\r\n' + '\r\n';
  public static String accNameText  = 'Account Name : ';
  public static String spaceLine = '\r\n';
  public static String accreName = 'Accreditation Name : ';
  public static String accrePortfolio= 'Accreditation Portfolio : ';
  public static String currentLevel = 'Current Level  : ';
  public static String levelDowngradeDate = 'Level Downgrade Grace Period End Date : ';
  public static String ThanksText = 'Thanks!!!';
  public static String manualAccreSubject1 = 'Need Attention : ';
  public static String manualAccreSubject2 = ' need manual Level update';
  public static String manualAccreMsg1 = 'Dear Reginal Leads,' + '\r\n' + '\r\n' + 'Acceriditation # ';
  public static String manualAccreMsg2 = ' is marked for Manual level  update.' + '\r\n' + '\r\n' + 'Kindly take appropriate action for level change if applicable. Please find more details for accreditation as below:' + '\r\n' + '\r\n';
  public static String setAccrdRuleLevelRank = 'setAccrdRuleLevelRank';
  public static String AccreLevelQuery1 = 'select id, name, Accreditation_Level__c, Accreditation_Type__c, Business_Plan_Status__c, Contract_Type__c, Market__c, Partner_Program__c, Partner_Type__c, Portfolio__c, Third_Party_Screening__c, Shift_Model__c, Lab_Equipment_Requirements__c, Level_Rank__c, Geo_Level_1_Name__c, ';
  public static String AccreLevelQuery2 = ' from Accreditation_Level_Rule__c order by Level_Rank__c';
  public static String NotApplicable = 'Not Applicable';
  
  //added by deeksha
  public static String duplicateError ='Error! You are entering a duplicate rule.';
  public static String beforeInsertOrUpdate ='beforeInsertOrUpdate';
  public static String AccreditationLevelChangeHandler ='AccreditationLevelChangeHandler';
  public static String AccreditationLevelChangeHelper ='AccreditationLevelChangeHelper';
  public static String checkDuplicate ='checkDuplicate';
  
  public static String autoSubmitParentCaseForApproval = 'autoSubmitParentCaseForApproval';
  public static String releaseOnHold = 'releaseOnHold';
  
  //Record Type Dev Names for getRecordTypeInfosByDeveloperName
	public static string ACCREDITATION_RECTYPE_GPP0 = 'Distributor_GPP_0_0';
  
  
  //Req 5179 Partner Portal
  Public Static String  CoOpAllocation= 'Co_Op_Allocation__c';
  Public Static String  PartnerName= 'Partner_Name__c';
  Public Static String  FundId= 'Fund_Id__c';
  public static String INlineSpace=' ';
   public static String IndependentContractor='Independent Contractor'; 
  //accreditationhelper
	public static String Sales_Associate='Sales Associate';
  public static String Sales_Engineer='Sales Engineer';
  public static String Field_Technician='Field Technician';
  public static String Network_Integration_Engineer='Network Integration Engineer';
  public static String Service_Desk_Clerk='Service Desk Clerk';
  public static String Administration_Software_Only='Administration Software Only';
  public static String Partner_Marketing_Manager='Partner Marketing Manager';
  public static String Partner_Relationship_Manager_acc='Partner Relationship Manager';
  public static String Technical_Support_Level1='Technical Support Level 1';
  public static String Technical_Support_Level2='Technical Support Level 2';
  public static String Network_Planning_Engineer='Network Planning Engineer';
  public static String No_Certification_Optional='No Certification (Optional)';
  public static String DirectSales_Distr_Req = 'Enterprise Main Solution, Lead BG, Lead BU, End Customer Legal Entity, Direct Sales Approver and Distributor PRM fields are required before Approving this Deal';
  public static String DirectSales_Distr_Req_v2 = 'Enterprise Main Solution, Lead BG, Lead BU, End Customer Legal Entity and Direct Sales Approver fields are required before Approving this Deal';
  public static String DistPRM_Rejection_Reason_Erros='Please provide Distributor PRM Rejection Reason';
  public static String Deferred_DOD_Error = 'Please uncheck Deferred DOD before approving. However if you want to defer the DOD decision, select Reject in the approval process.';
   //JIT Constants
  public static String CustomerPermissionSet = 'NCP_Customer_Portal_Access';
  public static String NULL_VALUE = null;
  public static String ApprovalStatus = 'ApprovalStatus';
  public static String Customer_Name = 'Customer Name';
  public static String P20 = 'P20';
  public static String ALCR = 'ALCR';
  public static String Zero_Val = '0';
  public static String emailID = 'emailID';
  public static String Fname = 'Fname';
  public static String Lname = 'Lname';
  public static String City = 'City';
  public static String Street = 'Street';
  public static String Phone = 'Phone';
  public static String State = 'State';
  public static String MobilePhone = 'MobilePhone';
  public static String Country = 'Country';
  public static String PersonalID = 'PersonalID';
  public static String HorizontalFlag = 'HorizontalFlag';
  public static String HorizontalCustomerName = 'HorizontalCustomerName';
  public static String SSOPID = 'SSOPID';
  public static String CountryCode = 'CountryCode';
  public static String Relationship = 'Relationship';
  public static String One_val = '1';
  public static String false_val = 'false';
  public static String true_val = 'true';
  public static String Single_Sign_On_Error = 'Single Sign On Error';
  public static String ErrorCode = 'ErrorCode';
  public static String ErrorDescription = 'ErrorDescription';
  public static String ErrorDetails = 'ErrorDetails';
  public static String PRM_Partner_FederationID = 'PRM Partner FederationID : ';
  public static String Inbound = 'Inbound';
  public static String Upsert_Val = 'Upsert';
  public static String Failure = 'Failure';
  public static String FederationID = 'FederationID';
  //LeadConversion Recursive Checking
  public static Boolean LeadConversion_Run_Once = true;
  
  //Partner Locator Constants
  public static String AccredAdvanced = 'Advanced';
  public static String AccredExpert = 'Expert';
  public static String AccredPremier = 'Premier';
  
  //Bypass G3 on Lead Conversion
  Public static String NSNG_COCT='NSNG_COCT';
  public static String Approved_G2 = 'Approved G2';
  Public static String G2_Approvals_New ='G2 Approvals New';
  Public static String Gate_2 ='Gate 2';
  Public static String SalesPhaseIdentifyOpportunity ='(Sales Phase = Identify Opportunity)';
  Public static String NotifiedName ='Notified';
  Public static String Notified_System_Info_Notified_User='Notified - System Info - Notified User:';
  Public static String Notify_CT_Head='Notify - CT Head';
  Public static String Gate_2_Bypass='Gate 2 Bypass';
}