/******************************************************************************************************
Name : CSWXGlobalConstant
Created Date: 11th Nov 2017
Created by: Accenture
Description : This class will serve all constant values for CSWX. So no hardcoding will be required in any of classes
*********************************************************************************************************/
public class CSWXGlobalConstant {
  //  object
  public static String OBJECT_Quotes = 'Apttus_Proposal__Proposal__c';
  public static String OBJECT_Agreement = 'Apttus__APTS_Agreement__c';
  Public static String OBJECT_QuoteItem = 'Apttus_Proposal__Proposal_Line_Item__c';
  public static String No_URL= 'NO URL';

  public static String NONE_OPTION_VALUE = '---None---';
  public static String TECHNOLOGY_API= 'Technology__c';
  public static String USE_CASE_API = 'Use_Case__c';
  public static String USE_CASE_COOKIE_NAME = 'usecaseCookie';
  public static String TECHNOLOGY_COOKIE_NAME = 'TechnologyCookie';
  public static String REPORT_DOES_NOT_EXIST_VALUE = 'false';
  public static String REPORT_DOES_EXIST_VALUE = 'true';
  public static String EMPTY_STRING = '';
  public static String POWERBI_APP_NAME = 'PowerBI';

  public static string FILE_SHARE_TYPE_V = 'V';
  public static string ALL_USERS = 'AllUsers';
  public static string DS_UserTrigger_Helper = 'DS_UserTrigger_Helper';
  public static string SWX_OpportunityTriggerHelper = 'SWX_OpportunityTriggerHelper';
  public static string postToChatteronInsert = 'postToChatteronInsert';
  public static string unsuccessfulUpload = 'The Contract upload was not successful: ';
  public static string emailUnsuccessfulUpload = 'The Contract upload was not successful.';
  public static string successfulUpload = 'The Contract upload was successful: ';
  public static string uniqueIdError = 'EXCEPTION: File with the same name already exists. Please check existing file before attempting to upload again';
  public static string uniqueId = 'Unique_Id__c';
  public static string accNotValid1 = 'The Account Number ';
  public static string accNotValid2 = ' is not present in Salesforce';
  public static string invalidJsonTag = ' JSON tag is invalid.';
  public static string startWithCXM = ' must start with "CXM" Or "RMP"';
  public static string startWithCCRE = ' must start with "CCRE"';
  public static string sourceId = 'source_id';
  public static Boolean createRecords = true;
  public static string jsonError = 'System.JSONException';
  public static string reqdField = ' is a mandatory field';
  Public static String restrictedPicklist =' is a restricted picklist';
  public static string SWX_RecordType = 'SWx Upsell Proposal';
  public static string CCRE_RecordType = 'CCRE Upsell Proposal';
  public static string SWX_CreateUpsellProposal = 'SWX_CreateUpsellProposal' ;
  public static string UpsertProposal = 'UpsertProposal';
  public static string header = 'header';
  public static string Sales_line_items = 'sales_line_items';
  public static string Product_Info_line_items = 'product_info_line_items';
  public static string Service_Invoice_Info_line_items = 'Service_Invoice_Info_line_items';
  public static string line_items = 'line_items';
  public static string bundle_id = 'bundle_id';
  public static string unweightedValue = 'Unweighted_Value';
  public static string numericCheck = ' value must be numeric';
  public static string quantity = 'quantity';
  public static string TEMPSTRING = 'Throw error';
  public static string msg = ' is mandatory';
  public static string AnalyticsSource = 'CXM';
  public static string AnalyticsSource_CCRE = 'CCRE';
  public static string statusFinalized = 'Finalized';
  public static string SWXbundle = 'SWX Commercial Bundle';
  public static string All = 'All';
  public static string EUR = 'EUR';
  public static string SWXUPSELLITEMTRIGGERHANDLERINSERTMETHOD = 'SWX_OpportunityTriggerHelper';
  public static string LNUMBER = 'Line Number:';
  Public static set<String> category_TypeSet = new set<String>{'SW Recommendation','HW Recommendation','Renewal'};
  public static set<String> dpuseCaseValue = new set<String>{'','Energy Efficiency','eNB User Capacity','Load Balancing','Air interface UL','Air interface DL','VoLTE','Transport / security','LTE Evolution','IoT','Spectrum Use','NW Coverage & Quality & NPO','WBTS Capacity','RNC Capacity','WCDMA Voice Quality','Coverage','Load Balancing & Interworking'};
  public static set<String>  techValue = new set<String>{'','TDD LTE','FDD LTE','WCDMA','HW extension','Antenna Systems'};
  public static Set<String> ccre_headerJsonTags = new Set<String>{'source_id', 'file_reference_id', 'account_id', 'strcreation_date', 'creation_date', 'category_Type', 'P20_ID', 'dolCurrency', 'Unweighted_Value'};
  public static Set<String> swx_headerJsonTags = new Set<String>{'source_id','cell_quantity','scope', 'file_reference_id', 'account_id', 'creation_date', 'category_Type', 'start_date', 'end_date'};
  public static Set<String> ccre_SIJsonTags = new Set<String>{'bundle_id', 'sales_item_code','use_case'};
  public static Set<String> ccre_PIJsonTags = new Set<String>{'Info_Type', 'Product_Family', 'Product_group', 'Product', 'M7_date_for_product', 'C8_date_for_product_release', 'C10_date_for_product_release', 'Product_Release', 'Contracted_NEs_per_customer', 'Contracted_NEs_per_contract'};
  public static Set<String> ccre_SIIJsonTags = new Set<String>{'Attribute_Label', 'Attribute_Value','Attribute_Type', 'Attribute_for_customer'};
  public static Set<String> swx_Lines_JsonTags = new Set<String>{'bundle_id', 'sales_item_code', 'quantity','use_case'};
  public static String use_case='use_case';
  public static Boolean isExcuting = true;
  public static string readyForConversion = 'Ready To Convert';
  public static string readyForReview = 'Ready For Review';
  public static string convert = 'Convert';
  public static string draft= 'Draft';
  public static string ready_for_enrichment= 'Ready for Enrichment';
  public static string ready_for_routing= 'Ready for Routing';
  public static string ready_for_review= 'Ready for Review';
  public static string SM = 'Solution Manager';
  public static string AM = 'Account Manager';
  public static string internal = 'Internal';
  Public static string Approval_stage_accepted='Accepted';
  Public static string Approval_stage_rework='Rework';
  Public static string Approval_stage_withdrawn='Withdrawn';
  Public static string Approval_stage_published='Published';
  Public static string Approval_stage_approved='Approved';
  Public static string Approval_stage_rejected='Rejected';
  Public static string Approval_stage_forPricing='For Pricing';
  Public static string Approval_stage_forApproval='For Approval';
  Public static string Approval_stage_forConfigure='For Configure';
  Public static string Approval_stage_inReview= 'In Review';
  Public static string Approval_stage_publishedReady= 'Published - Ready';
  Public static string Approval_stage_publishedInProgress= 'Published - In Progress';
  Public static string Approval_stage_callofReady = 'Call-off Ready';
  Public static String  newline ='\n';
  Public static String accMemPM = 'Pricing Manager';
  Public static string Approval_stage_Cancel='Cancel';
  Public static string Approval_stage_Reject='Reject';
  Public static string getDocumentDeatils='getDocumentDeatils';
  Public static String createProposalMethod='createProposal';
  Public static String CCRE_Offers='CCRE_Offers';
  Public static String SWX_Offers_List='SWX_Offers_List';
  Public static String Home_Page_Offers='Home_Page_Offers';
  Public static String getProposalMethod='getProposal';
  Public static String CCRE_AcceptClickFieldUpdate='CCRE_AcceptClickFieldUpdate';
  Public static String getStatusDeatilsMethod='getStatusDeatils';
  Public static String getStatusUpdateMethod='getStatusUpdate';
  Public static String getDocumentIdMethod='getDocumentId';
  Public static String createConfigurationLineItemMethod='createConfigurationLineItem';
  Public static String creatConfigurationItemMethod='creatConfigurationItem';
  Public Static String CSWX_OPPTYTRIGGERHELPER = 'Cswx_OpportunityTriggerHelper';
  Public static String cartStatus ='Saved';
  Public static Integer cartVersionNumer =1;
  Public static String cartName='Product Config - ';
  Public static String CartCreation='CartCreation';
  Public static String createCart='createCart';
  Public static String ProductCatalogue='SWX Product Catalogue';
  Public static Integer BundleQuantity =1;
  Public static Integer ccredefaultQuantity = 1;
  Public static String statuserror= 'This is an error';
  Public static String QuoteRecordType = 'SWx/CCRE Proposal';
  Public Static String ASSIGNINGG3APPROVER = 'assigningG3Approver';
  Public Static String ACC_TEAM_NOTI = 'AccountTeamNotification';
  Public Static String CREATEPROPOSAL= 'createProposal';
  //US: 163/164
  Public Static String DEAR_ACC_TEAM ='\n Dear account team,';
  Public Static String IS_CHANGED_To =' is changed to ';
  Public Static String BEST_REGARDS = 'Best regards,';
  Public Static String NOKIA_SUPPORT = 'Nokia Support';
  Public Static String DEVELOP_OPPTY = 'Develop Opportunity';

  public Static String ProposalDetail='ProposalDetail';
  Public static String getProposalLineItemMethod='getProposalLineItem';
  Public static String getProductInfoLineItemMethod='getProductInfoLineItem';
  Public static String getServiceInfoLineItemMethod='getServiceInfoLineItem';
  Public static String getDocumentIdforLineMethod='getDocumentIdforLine';
  public Static String Bundle='Bundle';
  public Static String Yes='Yes';
  public Static String VBA_and_Interdependency='VBA and Interdependency';
  public Static String Rejection_Reasons='Test Reasons';
  Public Static String quoteHandler='CCREProposalTriggerHandler';
  Public Static String createConfigurationMethod='createConfiguration';
  Public Static String quoteHelper ='CCREProposalTriggerHelper';
  Public Static String createCCRELineItemForProposalMethod='createCCRELineItemForProposal';
  Public Static String dproposalHandler ='SWxUpsellProposalTriggerHandler';
  Public Static String upsellProposalListMethod ='upsellProposalList';
  Public Static String SWxUpsellProposalTriggerHelper ='SWxUpsellProposalTriggerHelper';
  Public Static String errorOnUpdate  ='errorOnUpdate';
  Public Static String validateProductForCart  ='validateProductForCart ';
  Public Static String validateProductForPriceList  ='validateProductForPriceList ';
  Public Static String validateUpsellItem  = 'validateUpsellItem';
  Public Static String getbundleToOptionMap   = 'getbundleToOptionMap ';
  Public Static String getpriceListItem  = 'getpriceListItem';
  Public Static String Blank = '';
  Public Static String NokiaCPQShareProposalsWithOTMCls ='NokiaCPQShareProposalsWithOTM';
  Public Static String unshareProposalRecordAfterOTMTriggerDeleteMethod ='unshareProposalRecordAfterOTMTriggerDelete';
  Public Static String directOppty='Create Direct Sales Opportunity';
  Public Static String indirectOppty='Create Indirect Sales Opportunity';
  Public static String createOIFandOfferonDigiSalesOpportunity = 'createOIFandOfferonDigiSalesOpportunity';
  public static String standardOppty = 'Standard Opportunity';
  public static String identifyOppty = 'Identify Opportunity';
  public static String fnok = 'fNOK';
  public static String planned = 'Planned';
  public static String MN = 'MN';
  public static String createOppty = 'createOppty';
  public static Boolean recCheck = false;
  public static String BypassG4Helper = 'BypassG4';

  public static String SW_Recommendation = 'SW Recommendation';
  public static String HW_Recommendation = 'HW Recommendation';


  public static String ConfigLIforStandaloneProdclass= 'ConfigLIforStandaloneProd';
  public static String createConfigurationLineItem = 'createConfigurationLineItem';
  Public static String groupName ='DS_Grouping_Name__c';
  public static String technicalInfo = 'DS_Product_TechnicalInfo__c';
  public static String OFFERSTAGEFOROPPORTUNITY = 'Create Offer (Bid)';
  public static String OFFERINPROGRESS = 'Offer in Progress';
  public static String DIRECTRECORDTYPEOPPORTUNITY = 'Direct_Record_Type';
  public static String INDIRECTRECORDTYPEOPPORTUNITY='Indirect_Record_Type';
  public static String FORECASTCATEGORYOIF = 'RoP';
  public static String OFFERNAMEAUTO = 'Offer-';
  public static String LOABYPASS = 'LoA Bypass';

  public static String BGOFFEROIF = 'MN';
  Public static Integer HUNDRED =100;
  Public static Integer ZERO =0;
  Public static Integer THREE =3;
  Public static Integer FOUR =4;
  Public static String BusinessObjectType ='Proposal';
  Public static String AuthorizedforPricingManager = 'Authorized for Pricing Manager';
  Public static String NOLOA = 'No LoA';

  Public static String TechnicalInfoList = 'TechnicalInfoList';
  Public static String getPackageDetails = 'getPackageDetails';
  public static String priceListItem = 'Apttus_Config2__PriceListItemId__c';
  public static String DigisalesQuotecreation = 'DigisalesQuotecreation';
  public static String dash = '-';
  public static String Approved_G2 = 'Approved G2';
  public static String getProposalLineItemMapping = 'getProposalLineItemMapping';
  public static String getProposalLineItemGrouping = 'getProposalLineItemGrouping';
  public static String OID = '&oid=00D29000000E4g0';
  public static String CSWX_OpportunityTriggerHelper = 'CSWX_OpportunityTriggerHelper';
  Public static String quantityField = 'Apttus_Config2__Quantity__c';
  Public static String Opty_phase_Status = 'Opportunity in Progress';
  Public static String CartCreationTest='CartCreationTest';
  Public static String createQuoteTest='createQuoteTest';

  Public static String proposalCloseValidate='Close-Validated';
  Public static String updateProposalStageToCloseValidated='updateProposalStageToCloseValidated';
  public static String ACTIVE ='Active';
  public static String RED ='Red';
  public static String GREEN ='Green';
  public static String GREY ='Grey';
  public static String CLOSE_REJECT = 'Close-Reject';
  public static String VALIDATED = 'Validated';
  public static String CHECKSTATUS = 'checkStatus';
  public static String DS_ValidateButton = 'DS_ValidateButton';
  public static String getDigitalProposal = 'getDigitalProposal';
  public static String ACTIVEDP = 'An active DP ';
  public static String DP = 'A DP ';
  public static String ALREADYREADYFORREVIEW= ' is already Ready For Review, so alter one of the DP';
  public static String ALREADYREADYFORCONVERT = ' is already Ready to Convert, so alter one of the DP';
  public static String ALREADYVALIDATED = ' has already been Validated, so cancel this DP';
  public static String ALREADYREJECTED = ' has already been Rejected, so cancel this DP';
  public static Boolean recCheckStatus = false;
  public static Boolean oifCheckStatus = false;
  public static Boolean FalseVal = false;
  Public static String UpdateApprovalHistoryData = 'UpdateApprovalHistoryData';
  Public static String G3ApproveStatus = 'Approved G2,Approved G3';
  Public static String OPPORTUNITY = 'Opportunity';
  Public static String G2ProcessId = 'G2 Approvals New';
  Public static String G3ProcessId = 'G3 Approvals';
  Public Static String ApttusApprovalApproverComments = 'Notified - System Info - Notified User: ';
  Public Static String NONE = 'None';

  Public Static String Notified = 'Notified';
  Public Static String Stakeholder = 'Stakeholder';
  Public Static String StakeholderForInfo = 'Stakeholder for Information';
  Public Static String NokiasCRM = 'Nokia sCRM';
  Public Static String currencyISOCode = 'CurrencyIsoCode';
  Public Static String dsGroupingName = 'DS_Grouping_Name__c';
  Public Static String netPrice = 'Net_Price';
  Public Static String AllUsers = 'AllUsers';
  Public Static String CCRE_ContentDocumentLinkTriggerHelper = 'CCRE_ContentDocumentLinkTriggerHelper';
  Public Static String shareDocument = 'shareDocument';
  Public Static String CCRE_CreateQuoteProposal ='CCRE_CreateQuoteProposal';
  Public Static String UpsertQuote = 'UpsertQuote';
  Public Static String checkRecursive = 'checkRecursive';
  Public Static String runOnce = 'runOnce';
  Public static string usecase_technology_combination = 'The Combination of Technology and Use Case ';
  Public Static String DS_TabRendering = 'DS_TabRendering';
  Public Static String getProposalOnLoadmethod = 'getProposalOnLoad';
  Public Static String getDigitalProposalmethod = 'getProposal';
  Public Static String getQuoteStages = 'getQuoteStages';
  Public Static String getQuoteLevel3 = 'getQuoteLevel3';
  Public Static String getCategoryHierarcyDetails = 'getCategoryHierarcyDetails';
  Public Static String DS_ExecSummary= 'DS_ExecSummary';
  Public Static String DS_SWMPExecSummary= 'DS_SWMPExecSummary';
  Public Static String initialLoad= 'initialLoad';
  public static final string DOWNLOAD_RECOMMENDATION = 'Download Recommendation';
  Public Static String ExecSummary=   'Executive Summary';
  Public Static String SWMPExecSummary= 'Catalogue Executive Summary';
  public static String getAccountAttachment = 'getAccountAttachment';
  public static String getCurrentUserData = 'getCurrentUserData';
  public static String cLogo = 'Customer logo';
  public static String DS_CommunityLogo = 'DS_CommunityLogo';
  Public static String getUseCaseValues ='getUseCaseValues';

  Public static String filterDPRecord='filterDPRecord';
  public static String sortDPRec='sortDPRec';
  public static String benchmarking='Benchmarking';
  public static String ucase='Use Case';
  public static String mapview='Map View';
  public static String featuredetails='Feature Details';
  public static String Instructions='Instructions';
  public static String noURL='NULL';
  public static String getFiles='getFiles';

  public static String allProposal ='All Proposal';
  public static String closedProposal ='Closed Proposal';
  public static String forYourReview ='For Your Review';
  public static String validatedProposal ='Validated Proposal';
  public static String DigitalSalesPortalTile ='DigitalSalesPortalTile';
  public static String getTiles ='getTiles';
  public static String ContentDocumentLinkHandler ='ContentDocumentLinkHandler';
  public static String beforeInsert ='beforeInsert';

  public static Set<String> fileNameToShare = new Set<String>{'Executive Summary','Customer logo','Benchmarking','Use Case','Map View','Feature Details'};
  public static String csAllProposal='AllProposal';
  public static String csClosedProposal='Closed Proposal';
  public static String csForYourReview='For Your Review';
  public static String csValidatedProposal='Validated Proposal';
  Public static String splitBy=',';

  public static Set<String> fileObjName = new Set<String>{'Quote/Proposal','Digital Proposal'};
  public static String accObj ='Account';
  Public Static String nullValue ='null';

  public static String analyticSourceCXM='CXM';
  public static String salesLineItems='sales_line_items';
  public static String CCRE_CreateUpsellProposalHelper='CCRE_CreateUpsellProposalHelper';
  public static String checkForErrorsInLine='checkForErrorsInLine';
  public static String checkForErrors='checkForErrors';
  public static String beforeUpdateG2DataFill = 'beforeUpdateG2DataFill';
  Public static string getQuoteName ='getQuoteName';
  Public static string DS_BusinessRulesCheck_Controller = 'DS_BusinessRulesCheck_Controller';
  Public static string checkRules = 'checkRules';
  Public static string noRecord = 'Blank';
  Public static string APPTUSAPPROVALSTAGE = ' and Apttus_Proposal__Approval_Stage__c =: Approved ';
  public static String ContactNameDS= 'ContactNameDS';
  public static String EmailContactNameDS= 'EmailContactNameDS@accenture.com';
  public static String DS_TabRenderingTest= 'DS_TabRenderingTest';
  public static String createTestDP= 'createTestDP';
  public static final string DOWNLOAD_OFFER = 'Download Offer';
  public static final string EXPORT_PROPOSAL = 'Export Proposal';
  public static final string CPO_DOWNLOAD = 'CPO Download';

  Public static string Analytics_File_Refer_ID_field= 'Analytics_File_Refer_ID__c';
  Public static String Technology ='WCDMA';
  Public static String Usecase ='Energy Efficiency';

  Public static String updateQuoteShare='updateQuoteShare';
  Public static String updateQuoteShareHelper='updateQuoteShareHelper';
  Public static String dsCustomerProfile='Digital Sales Customer Profile';
  //Public static String dsCustomerProfile='Customers';
  Public static String editShare='Edit';
  Public static String quoteShareApproved='Approved';
  Public static String dataLoaderProfile='Data Loader Profile';

  public static String NetworkTrends='Network Trends';
  public static String InstalledBase='Installed Base';
  Public Static String DS_Networkoverview = 'DS_Networkoverview';
  Public Static String getTechnology = 'getTechnology';
  Public static String messgaeType = 'Inbound';
  Public static String DS = 'DS ProposalCreation';
  Public static String createDSStagingHelper='createDSStagingHelper';
  Public static String insertInterfaceLog ='insertInterfaceLog';
  public static String insertDSStaging= 'insertDSStaging';
  public static String  optionType ='Insert';
  Public Static String Failure ='Failure';
  Public static String Success = 'Success';
  Public static String msgPartTwo = ' for customer ';
  Public static String msgPartThree = ' needs attention due to found issues. ';
  Public static String msgPartFour = 'Check the ';
  Public static String msgPartFive = ' for more detailed information';
  Public static String msgPartSix= ' is ready for review on the customer portal of  ';
  Public static String TechTest='The Contract upload was not successful : Technology is missing in sourceId';
  Public static String  techError = ' Or Technology does not exist';
  Public static String  usecaseError = ' value does not exist';
  Public static String techusecasecombination ='Technology and Usecase combination are not correct';
  public static String slash = '/';
  public static String DPLink = ' \r\n DP Link : ';
  public static String accountLink = '\r\n Account Link : ';
  public static String cxmDPCreation= 'cxmDPCreation';
  public static String updateDPonFailure = 'updateDPonFailure';
  public static String sendChatterMessageToAM = 'sendChatterMessageToAM';
  public static String checkReadyForReview = 'checkReadyForReview';
  public static String DS_StagingObjParsing = 'DS_StagingObjParsing';
  public static String execute= 'execute';
  public static String checkRulesfromStagingObjParserClass= 'checkRulesfromStagingObjParserClass';
  public static String createMapPriceListToType = 'createMapPriceListToType';
  public static String getListOfPriceList = 'getListOfPriceList';
  public static String createPriceItemList= 'createPriceItemList';
  public static String getPriceListId= 'getPriceListId';
  public static String updateDPforPricingValidation= 'updateDPforPricingValidation';
  public static String updateDPforBundleValidation= 'updateDPforBundleValidation';

  public static String DS_DigitalProposalBusinessRules= 'DS_DigitalProposalBusinessRules';

  public static String updateDPProductValidation= 'updateDPProductValidation';

  Public static String creation_date='creation_date';
  Public static String category_Type='category_Type';
  Public static String quantityMsg =' quantity is a mandatory field or Exception Occured : ';
  Public static List<String>  dp_status_forfilefreeze = new List<String>{'Validated','Reject' };

  Public static String NSNG_COCT='NSNG_COCT';
  Public static String G2_Approvals_New ='G2 Approvals New';
  Public static String Gate_2 ='Gate 2';
  Public static String User ='NSNG_COCT';
  Public static String StakeholderName ='Stakeholder';
  Public static String SalesPhaseIdentifyOpportunity ='(Sales Phase = Identify Opportunity)';
  Public static String NotifiedName ='Notified';
  Public static String StandardName ='Standard';
  Public static String OpportunityName='Opportunity';
  Public static String Notified_System_Info_Notified_User='Notified - System Info - Notified User:';
  Public static String Notify_CT_Head='Notify - CT Head';
  Public static String Gate_2_Byepass='Gate 2 Byepass';
  Public static String updateG2approvalHistoryData ='updateG2approvalHistoryData ';
  Public static String Review='Review';
  Public static String DS_PortalDashboard='DS_PortalDashboard';
  Public static String getDPDashboard='getDPDashboard';
  Public static String getQuoteDashboard='getQuoteDashboard';
  Public static String getTechnicalLevel2 ='getTechnicalLevel2';
  public static String DS_DPSWXLineItem ='DS_DPSWXLineItem';
  Public static String getAllLineitem ='getAllLineitem';
  Public static String getLineItemRec = 'getLineItemRec';
  public static string restrictFileUploadOnDpErrorMessage = 'File Cannot be added or deleted for current status of Technical Recommendation.';
  public static string restrictFileUploadOnQpErrorMessage = 'File Cannot be added or deleted for current status of Commercial Proposal.';
  Public Static String restrictFileVersionOnDpErrorMessage = 'File Version cannot be uploaded for current status of Technical Recommendation.';
  Public Static String restrictFileEditOnDpErrorMessage = 'File details cannot be edited at the current status of Technical Recommendation.';
  Public Static String restrictFileVersionOnQpErrorMessage = 'File Version cannot be uploaded for current status of Commercial Proposal.';
  Public Static String restrictFileEditOnQpErrorMessage = 'File details cannot be edited at the current status of Commercial Proposal.';
  public static String OBJECT_DP = 'SWx_Upsell_Proposal__c';
  public static Set<String> dpstatusset = new Set<String>{'Validated','Reject','Replaced','Cancel','Replacement Pending','Close-Validated','Close-Reject'};
  public static Set<String> qpStatusSet = new Set<String>{'Accepted','Rejected','In Revision'};
  Public static String restrictUploadmethod ='restrictUpload';
  Public static String restrictDeletemethod ='restrictDelete';
  Public Static String DS_ContentDocumentTriggerHelper = 'DS_ContentDocumentTriggerHelper';
  Public Static String DS_ContentVersionHelper = 'DS_ContentVersionHelper';
  Public static String restrictNewVersion ='restrictNewVersion';
  Public Static String String_insert ='Insert';
  Public Static String String_update ='Update';
  Public Static String DS_DPRelatedList ='DS_DPRelatedList';
  Public Static String getOpportunity ='getOpportunity';
  Public Static String getQuote ='getQuote';
  Public Static String getCXMLineItem ='getCXMLineItem';
  Public Static String getCCRELineItem ='getCCRELineItem';
  Public Static String getDPAnalyticsSource ='getDPAnalyticsSource';
  Public Static String Networkoverview = 'Network Overview';
  Public Static String SourceID_RMP = 'RMP';
  public static string SWMP_RecordType = 'DS SWMP Proposals';
  Public static String Rejected ='Reject';
  Public static String filelogo ='ionicLogo.json';
  public static String fileloaction ='S';
  Public static String fileVisiblity ='AllUsers';
  Public static String InsertFile ='InsertFile';
  Public static String fileShareType ='V';
  Public static String getDPInfoMethod='getDPInfo';
  Public static String getJsonFileMethod ='getJsonFile';
  Public static String DS_CCREServiceInfoRelatedList = 'DS_CCREServiceInfoRelatedList';
  Public static String getCCREServiceInfoLineItem = 'getCCREServiceInfoLineItem';
  Public static String getCCREProductInfoLineItem = 'getCCREProductInfoLineItem';
  Public static String DS_QPRelatedList='DS_QPRelatedList';
  Public static String getLineItem='getLineItem';
  Public static String DS_ContentVersionHandler='DS_ContentVersionHandler';
  Public static String restrictFileDetails ='restrictFileDetails';
  Public static String TEST = 'Test';
  Public static String DS_ContractOverview = 'DS_ContractOverview';
  Public static String getFrameContractReference= 'getFrameContractReference';
  Public static String getPO= 'getPO';
  Public static String contractOverview= 'Contract Overview';
  Public static String helloMessage= 'Hello ';
  Public static String SecondMessage = ', ';
  Public static String remainingMessage= ' requires your immediate attention before the Software can be published to the Digital Marketplace. Please take action now.';
  Public static String DS_ContentDocumentTriggerHandler='DS_ContentDocumentTriggerHandler';
  Public static String beforeDelete='beforeDelete';
  Public static String updateOpportunity = 'updateOpportunity';
  Public static String LOA_STATUS = 'G4 Submission';
  Public static String Direct_DS = 'Direct DS';
  Public static String InDirect_DS = 'Indirect DS';
  Public static String updateOpportunityApprovalHistory = 'updateOpportunityApprovalHistory';
  Public static String space = ' ';
  Public static String supportingMaterialObj = 'File_Upload__c';
  Public static String revision_status='Revision';
  Public static String string_v= 'v';

  //DSI-279
  public static String SECURE= 'Secure';
  public static String byPassG5 = 'CCREProposalTriggerHelper.byPassG5';
  public static string PENDING_APPROVAL='Pending Approval';
  public static string WIN_THE_CASE_NEGOTIATE = 'Win the Case (Negotiate)';
  public static string PENDING_WIN_LOSS_DECLARATION  = 'Pending Win/Loss Declaration';
  public static String OBJECT_OPPORTUNITY = 'Opportunity';
  public static String PTA_HANDOVER='PTA (PROJECT TARGET AGREEMENT) HANDOVER TO DELIVERY/OPERATIONS';
  public Static String HANDOVER_OPPTY = 'Handover (Prepare for Delivery)';
  public static string APPROVED='Approved';
  public static String G5_APPROVAL_TECH= 'Approved G2,Approved G3,Approved G4,Approved G5';
  public static string WON ='Won';
  public static string QP_HISTORY='Apttus_Proposal__Approval_Stage__c';
  public static string DS_G5_Bypass ='DS_G5_Bypass';
  public static string DS_G5_execute='DS_G5_Bypass.execute';
  public static string CCREProposalHandler ='CCREProposalHandler';
  public static string byPassGates ='CCREProposalHandler.byPassGates';
  public static string CCREProposalHelper ='CCREProposalHelper';
  public static string CCREexecute ='CCREProposalHelper.execute';
  public static string Sales_Outcome_Reason= 'Sales and Customer Engagement';
  public static string  Second_Reason = 'Commercial';
  public static string Third_Reason = 'Mistake/Redundant/Merged';
  public static String G4_APPROVAL_TECH= 'Approved G2,Approved G3,Approved G4';
  public static double threshold = 10000;
  public static String G4_APPROVAL_BYPASS= 'G4 Approvals (Bypass)';
  public static String byPassG5Gate = 'CCREProposalHelper.byPassG5Gate';
  public static String byPassG5_2Gate = 'CCREProposalHelper.byPassG5_2Gate';
  public static String G5_2_APPROVAL_BYPASS ='G5 Contract Approvals (Bypass)';
  public static String G6_APPROVAL_TECH= 'Approved G2,Approved G3,Approved G4,Approved G5,Approved G6';
  public static String EXECUTE_STAGE = 'Execute (Start Delivery)';
  public static String EXECUTE_PHASE ='In Execution';
  public static String G5_WIN_PHASE ='G5 Win Declaration';
  public static String byPassG6 = 'CCREProposalHelper.byPassG6';
  public static String updateApprovalHistory = 'CCREProposalHelper.updateOpportunityApprovalHistory';
  public static String CLOSED_PHASE ='Closed(not won)';
  public static String CLOSED_STAGE ='Closed - Cancelled by Customer';
  public static String G6_BYPASS= 'G6 Approvals (Bypass)';
  public static String APPROVER_COMMENTS= 'Auto Approved - System ';
  public static String G5_Contract_Bypass= 'G5 Contract Bypass';
  public static String Win_Declaration= 'Win Declaration';
  public static String Gate_6_Bypass= 'Gate 6 Bypass';



  public static string upper_case='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  public static string lower_case= 'abcdefghijklmnopqrstuvwxyz';
  public static string digits=  '0123456789+/';
  Public static string DS_GetQuoteLI ='DS_GetQuoteLI';

  Public static string DS_SWCatalague_query1 ='SELECT ID,Product_Name__c,SWx_Product_Code__c,Status_In_Network__c,SWx_Upsell_Proposal__c,SWx_Upsell_Proposal__r.Name,SWx_Upsell_Proposal__r.Use_Case__c,SWx_Upsell_Proposal__r.PO__r.Name,SWx_Upsell_Proposal__r.Technology__c,SWx_Upsell_Proposal__r.Agreement_Number__c, SWx_Upsell_Proposal__r.Frame_Contract__r.Name,Acceptance_Initiation__c,Delivery_Execution__c, Acceptance_of_Delivery__c FROM SWx_Upsell_Items__c WHERE SWx_Upsell_Proposal__c IN:dpId ';
  Public static string DS_SWCatalague_query2='AND Status_In_Network__c =: status_in_network ';
  Public static string DS_UserQuery ='Select Id,Apttus_Proposal__Account__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Account__c IN :accountIdSet ';
  Public static string DS_SWCatalague='DS_SWCatalogue';
  Public static string getFeature='getFeature';

  //US-761
  Public static String Operation_Type_Update ='Update';
  Public static String  Message_Type_Outbound = 'Outbound';
  Public static String InterfaceType ='DS Southbound';
  Public static String SupportingMaterialTriggerHandler='SupportingMaterialTriggerHandler';
  Public static String SupportingMaterialTriggerHelper='SupportingMaterialTriggerHelper';
  Public static String validateDuplicateSupportingMaterialRecord='validateDuplicateSupportingMaterialRecord';
  Public static String Userobj ='User';
  Public static String APIDetails = 'APIDetail';
  Public static String jsonHeader = '{ '+
  '  "DataSources": [ '+
  '	{ '+
  '"id": "variable-source", '+
  '	"data": { '+
  '  "taskType": "Dataset", '+
  '  "type": "json", '+
  '  "parameters": { '+
  '	  "file": "dSource_file_resource", '+
  '	  "format": "json" '+
  '  } '+
  '	} '+
  '	} '+
  '  ], '+
  '  "Sinks": [ '+
  '	{ '+
  '"id": "dTarget", '+
  '	"data": { '+
  '  "taskType": "Dataset", '+
  '  "type": "json", '+
  '  "parameters": { '+
  '	  "file": "dOutput_file_resource", '+
  '	  "format": "nt" '+
  '  } '+
  '	} '+
  '	} '+
  '  ], '+
  '  "Resources": { '+
  '	"dSource_file_resource": { '+
  ' '+
  '	"__COMMENT__1": "ACTUAL PAYLOAD BEGINS...",  ' ;

  Public static String jsonFooter= '"__COMMENT__2": "... ACTUAL PAYLOAD END." '+
  ' '+
  '} '+
  '} '+
  '} ' ;

  Public static String CPOObject = 'Apttus_Config2__CustomerPurchaseOrder__c';

  Public static String DS_CPOValidity_Check = 'DS_CPOValidity_Check';
  Public static String AgreementTriggerHelper = 'AgreementTriggerHelper';
  Public static String AgreementTriggerHandler ='AgreementTriggerHandler';
  Public static String checkCPOValidity = 'checkCPOValidity';
  Public static String getCPOFields = 'getCPOFields';
  Public static String comma = ',';
  Public static String CPOStatus = 'Apttus_Config2__Status__c,';
  Public static String soql_part1 =  'Select ';
  Public static String soql_part1Vaidate =  'Select Legacy_CPO__c, ';
  Public static String soql_part2 = ' from Apttus_Config2__CustomerPurchaseOrder__c where Id in :CurrentRecordId ';
  Public static String soql_part3 = ' from Apttus_Config2__CustomerPurchaseOrder__c where Id in :cpoId ';
  Public static String soql_CPOItem =' FROM Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c  in :stQutId';
  public static String DS_CPOHandler ='DS_CPOHandler';
  public static String DS_CreateCPO='DS_CreateCPO';
  public static String DS_CPOHelper='DS_CPOHelper';

  Public static String soql_partQuote1 = 'Select ';
  Public static String soql_partQuote2 = ' from Apttus_Proposal__Proposal__c  where Id in :CurrentRecordId ';
  Public static String soql_partAgree2 = ' from Apttus__APTS_Agreement__c  where Id in :agreementRecordId ';
  Public static String getQuoteField ='getQuoteFields';
  Public static String getAgreementFields ='getAgreementFields';
  Public static String getQuoteLIFields = 'getQuoteLIFields';

  public static String PBI_CONTROLLER_NAME = 'DS_PowerBIController';
  public static String GETACCESSTOKEN_METHOD_NAME = 'getAccessToken';
  public static String GET_PBI_REPORT_URL= 'getPBIReportURL';
  public static String GET_PBI_URL_BASEDONCUSTOMER = 'getPBIURLBasedOnCustomer';
  public static String GETREPORTID_FROMREPORTURL = 'getReportIdFromReportURL';
  public static String LOAD_DEPENDENT_USECASE = 'loadDependentUsecases';
  public static String LOAD_TECHNOLOGIEs = 'loadTechnologies';
  public static String GET_VALIDATE_RESULT = 'getValidateResult';
  public static String GET_TECHNOLOGIES = 'getTechnologies';
  public static String GET_USECASE_ONTECHNOLOGY = 'getUseCaseOnTechnology';
  public static Boolean TrueVal = true;
  public static String P20 ='P20';
  public static String getCSMandCDM ='getCSMandCDM';

  public static String OFFER_SUBMITTED= 'Offer Submitted to Customer (Manual)';
  public static String G4_BYPASS= 'G4 Approvals (Bypass)';
  public static String CCREPROPOSALG4HELPER = 'CCREProposalG4Helper';
  public static String BYPASSG4= 'CCREProposalG4Helper.byPassG4';
  public static String G3_BYPASS= 'G3 Approvals (Bypass)' ;
  public static String G4_BYPASS_PROCESS= 'Gate 4 Bypass' ;
  public static String UPDATE_HISTORY = 'CCREProposalG4Helper.updateOpportunityApprovalHistory';
  public static Boolean isCPOTriggerCalled =  true;
  public static String CanBeEntitled =  'Can Be Entitled';
  public static String CanNotEntitled =  'Cannot be entitled';
  public static String Entitled =  'Entitled';
  public static String QuoteNeeded =  'Quote Needed';
  public static String CPOTriggerHelper = 'CPOTriggerHelper';
  public static String createEntitlementmethod = 'createEntitlement';
  public static String entitledValue = 'Entitled';
  public static String pendingValue = 'Pending';
  public static String Expired = 'Expired';
  public static String BLANK_VALUE = '';
  public static String DS_NetworkOverviewBanner = 'DS_NetworkOverviewBanner';
  public static String BATCH_CPOITEMS = 'Batch_CPOItems';
  public static String CPOITEMS_EXECUTE = 'Batch_CPOItems.execute'  ;
  public static String DS_SWxItemTriggerHandler = 'DS_SWxItemTriggerHandler';
  public static String beforeUpdate = 'beforeUpdate';
  public static String DS_SWxItemTriggerHelper = 'DS_SWxItemTriggerHelper';
  public static String updateEntitlementActiveQuantity = 'updateEntitlementActiveQuantity';
  public static String Replaced= 'Replaced';
  public static String CPOITEMS_Finish = 'Batch_CPOItems.finish'  ;
  public static String Batch_DPFulfillment = 'Batch_DPFulfillment'  ;
  public static String Batch_DPFulfillment_execute = 'Batch_DPFulfillment.execute()';
  public static String Batch_DPFulfillment_finish = 'Batch_DPFulfillment.finish()';
  public static String CAN_NOT_ENTITLED =  'Cannot be entitled';
  public static String CAN_BE_ENTITLED = 'Can Be Entitled';
  public static String BATCH_DP_UPDATE = 'Batch_DP_Update';
  public static String BATCH_DP_UPDATE_EXECUTE = 'Batch_DP_Update.execute()';
  public static String BATCH_DP_UPDATE_FINISH = 'Batch_DP_Update.finish()';

  public static String SCRATCH_ORDER='Scratch Order';

  public static String VALIDATE_THANKS_MESSAGE = '<h4>Thank you for validating our recommendation.\n'+
  'We\'re ready to go!</h4>';
  public static String VALIDATE_THANKS_MESSAGE1 = 'We hope you will review other recommendations and validate them successfully.\n'+
  'Would you like to share your opinion with us';
  public static String DS_Customcommunitycontroller = 'DS_Customcommunitycontroller';
  public static String DS_activateProductMethod = 'activateproducts';
  public static String DS_Relatedproducts = 'Relatedproducts';
  public static String DS_ConfirmMessage = 'You are about to activate your chosen software in the network.'+
  'By confirming the activation, you state that you have read the activaion confirmation disclaimer';
  public static String CXM_Type = 'CXM';
  public static String DS_showProducts = 'showProducts';
  public static String DS_CustomCommercialEntitlementController = 'DS_CustomCommercialEntitlementController';
  public static String DS_relatedDigitalProposals = 'relatedDigitalProposals';
  public static String DS_AccountContactRelationTriggerHelperClass = 'DS_AccountContactRelationTriggerHelper';
  public static String checkRecordExistmethod = 'checkRecordExist';
  Public Static String DS_EntitlementHeader ='DS_EntitlementHeader';
  Public Static String GetEntitleRec ='GetEntitleRec';
  Public static String DS_FeatureComponent = 'Feature Component GBOM';
  Public static String customerProfile = 'Customers';
  public static String Quote_ProposalField = 'Apttus_QPConfig__ProposalId__c';
  public static String Opportunityfield = 'Opportunity__c';
  public static string recordTypeLogisticAccount = 'Logistic Account';
  public static string DS_AccountContactRelationTriggerHandlerclass = 'DS_AccountContactRelationTriggerHandler';
  public static string logisticAccError = 'Please associate this contact to the Legal Entity, or select a contact that has already been associated to the Legal Entity.';
  public static string DS_CPOValidity_CheckTestclass = 'DS_CPOValidity_CheckTest';
  public static string checkCPOValidityTestmethod = 'checkCPOValidityTest';
  public static string checkCPOValidityTestmethod2 = 'checkCPOValidityTest2';

  public static string slds_hint_parent = 'slds-hint-parent';
  public static string getcurrentuserContactcard = 'getcurrentuserContactcard';
  public static string DS_getcurrentuser = 'getcurrentuser';
  public static string DS_legalEntity = 'Legal_Entity';
  public static string DS_RecordBanner  = 'DS_RecordBanner';
  public static string DS_Get_entitlepicklist = 'Get_entitlepicklist';
  public static string DS_getUseCaseOnTechnology = 'getUseCaseOnTechnology';
  public static string DS_getTechnologies = 'getTechnologies';

  public static string ONString = 'ON';
  Public static String ReadyforExecution = 'Ready for Execution';
  Public static String SW= 'Ready for Execution';
  Public static String SW_catalogueQueryforUSeCase= ' AND Use_Case__c=:uCase ';
  Public static String SW_catalogueQueryforPONo= ' AND PO__r.Name=:poNum ';
  Public static String SW_catalogueQueryforTech= ' AND Technology__c=:tech ';
  Public static String SW_catalogueQueryforAgreement= ' AND Frame_Contract__r.Apttus__FF_Agreement_Number__c =:agreementNo ';
  public static string CPOTriggerHandler = 'CPOTriggerHandler';
  public static string checkMandatoryFields = 'checkMandatoryFields';

  public static string SW_catalogueQueryforDP = 'SELECT ID,NAME,Frame_Contract__r.Apttus__FF_Agreement_Number__c, Frame_Contract__r.Name, PO__r.Name,Technology__c,Use_Case__c FROM SWx_Upsell_Proposal__c WHERE Analytics_Source__c =: Analytics_Source AND Upsell_Status__c!=: UpsellStatusDraft AND Account_ID__c in: accountIdSet ';
  public static string DS_CPOLineItem_Scheduler = 'DS_CPOLineItem_Scheduler';
  public static string DS_CPO_Scheduler_execute  = 'DS_CPOLineItem_Scheduler_execute';
  Public static String getCSM = 'getCSM';
  Public Static String updateCPOOwner = 'updateCPOOwner';

  Public static String noneValue = '--None--';
  public static String Get_entitlepicklistmethod = 'Get_entitlepicklist';

  public static string DS_AccountTriggerHandlerClass = 'DS_AccountTriggerHandler';
  public static string afterInsertOperationmethod = 'afterInsertOperation';
  public static string DS_AccountTriggerHelperClass = 'DS_AccountTriggerHelper';
  public static string assignTerritorymethod = 'assignTerritorymethod';
  public static string Territory2Manual = 'Territory2Manual';

  public static String grant_type = 'grant_type=authorization_code';
  public static String code = 'code=';
  public static String utf8 = 'UTF-8';
  public static String clientID = 'client_id=';
  public static String clientsecret = 'client_secret=';
  public static String redirect_uri = 'redirect_uri';
  public static String resource = 'resource';
  public static String response_type = 'response_type';
  public static string POST = 'POST';
  public static string contenttype = 'Content-Type';
  public static string appwww =  'application/x-www-form-urlencoded';
  public static string Accept =  'Accept';
  public static string apptype =  'application/json';
  public static string andchar = '&';
  public static string codechar = 'code';
  public static string granttyperefreshtoken = 'grant_type=refresh_token';
  public static string refreshtoken =  'refresh_token=';



  Public Static String MandatoryFields = 'Please fill Mandatory Fields: ';
  Public Static String mandatoryFieldsAgreementErrorMsg = 'The following mandatory fields are missing: ';

  public static String dsPermissionSet = 'DS_Digital_Sales_Customer';
  public static String DS_PBI_ReportServerController= 'DS_PBI_ReportServerController';
  public static string genarateAccessToken = 'genarateAccessToken';

  public static string getOAuthURL = 'getOAuthURL';

  public static string genarateAccessTokenFromRefreshToken = 'genarateAccessTokenFromRefreshToken';
  public static string getUniqueTechnologies = 'getUniqueTechnologies';
  public static string returnUseCaseOnTechnology = 'returnUseCaseOnTechnology';


  public static string getCurrentUserProfile =  'getCurrentUserProfile';

  public static string getTechnologies =  'getTechnologies';

  public static string getUseCaseOnTechnology =  'getUseCaseOnTechnology';
  public static String GBOM = 'GBOM';
  public static String Feature = 'Feature';
  public static String NSN_Software_SI = 'NSN Software SI';
  public static String PCI = 'NSN Product Configuration Item';
  public static String GBOM_BATCH = 'GBOM relation Batch';
  public static String GBOM_BATCH_EXECUTE = 'GBOM Batch Execute';
  public static String GBOM_BATCH_FINAL = 'GBOM Batch Final';

  public static String getListOfFieldsOnStatusMethod = 'getListOfFieldsOnStatus';
  public static String getAllFieldsFromCustomSettingMethod = 'getAllFieldsFromCustomSetting';
  public static string High_Level_value = 'High Level';
  public static String soql_Agreement_High_Level = ', Apttus_QPConfig__ProposalId__r.Agreement_Lookup__r.Confidence_Level__c,DS_CPO_Validity_Check__c ';


  public static String DS_EntitlementHeaderTest ='DS_EntitlementHeaderTest';
  public static String TestDS_EntitlementHeader = 'TestDS_EntitlementHeader';
  public static String DS_BLANKString = 'BLANK';

  public static String DS_CustomerUserShareWithAccountManager = 'DS_CustomerUserShareWithAccountManager';
  public static String getTerritoryAssociatedwithAccount = 'getTerritoryAssociatedwithAccounts';

  public static String AgreementField= 'Apttus_CMConfig__AgreementId__c';
  public static String LTE = 'LTE';
  public static String READ= 'Read';
  Public Static String OpportunityTeamHandlerDS   = 'OpportunityTeamHandlerDS';
  Public Static String afterInsert ='afterInsert';
  public Static String afterUpdate='afterUpdate';
  Public Static String afterInsertPlusDelete = 'afterInsertPlusDelete';
  Public Static String DeleteDML='Delete';
  Public Static String InsertDML='Insert';
  Public Static String InsertOTMTest ='InsertOTMTest';
  Public Static String DeleteOTMTest='DeleteOTMTest';
  Public Static String DS_OpportunityTeamHandlerTest ='DS_OpportunityTeamHandlerTest';
  Public Static String UpdateOTMTest2 ='UpdateOTMTest2';
  Public Static String DeleteOTMTest2 ='DeleteOTMTest2';
  Public Static String Option= 'Option';
  Public Static String ProductService ='Product/Service';
  Public Static String Standalone='Standalone';
  Public static Boolean Recursivecheck_CPO =false;
  Public static String trueStringValue ='false';
  Public static Boolean Recursivecheck_CPOlI = false;
  // DS Classes, methods Name
  Public Static String DS_updateComemrcialEntitlementStatus ='DS_updateComemrcialEntitlementStatus';
  Public Static String DS_CustomerPOItemTriggerHandler = 'DS_CustomerPOItemTriggerHandler';
  Public Static String DS_CustomerPOItemTriggerHelper = 'DS_CustomerPOItemTriggerHelper';
  Public Static String updateEntitlementStatus = 'updateEntitlementStatus';
  Public Static String ReadyforDelivery = 'Ready for Delivery';
  Public Static String createEntitlement ='createEntitlement';
  Public Static String filtercommercialRecord = 'filtercommercialRecord';

  Public Static Boolean recursivecheckOnEntilemntBuild = false;
  public static String dpConsumptionOnValidateMethod ='dpConsumptionOnValidate';

  Public Static String DSPriceListType ='DS';
  Public Static String DPMsgPart1='requires your immediate attention before the Technical Recommendation can be published to the Digital Marketplace of';
  Public Static String DPMsgPart2='Please take action now';
  public Static String sendJsonToEccencaMethod ='sendJsonToEccenca';
  Public Static String sendJsonMethod = 'sendJson';
  Public Static String SWMP ='SWMP';
  Public Static String InsertJson ='InsertJson';

  Public static String SWMPCalloutClass ='SWMPCalloutClass';
  Public static String InsertInterfaceLogRecord='InsertInterfaceLogRecord';
  Public static String CallingRESTAPI='CallingRESTAPI';


  public static String DS_Populate_CFAttributes='DS_Populate_CFAttributes';
  public static String createCFAforQuote='createCFAforQuote';
  public static String createCFAforConfigItem  = 'createCFAforConfigItem';
  public static String updateCFAforCPO = 'updateCFAforCPO';
  public static String attributeName = 'Attribute_Name__c';
  public static String attributeLabel = 'Attribute_Label__c';
  public static String attributeValue  = 'Attribute_Value__c';
  public static String attributeVisibility = 'Attribute_Visibility__c';


  Public static String  DS_AttachmentHandler  = 'DS_AttachmentHandler';
  Public static String  filebeforeDelete = 'beforeDelete';
  Public static String  QuoteReadOnlyLayout ='SWx/CCRE Proposal Read Only';
  Public static String  CXMDPReadOnlyLayout ='SWx Upsell Proposal Read Only';
  Public static String  RMPDPReadOnlyLayout ='DS SWMP Proposals Read Only';
  Public static String  pathOnClient = 'ionicLogo.json';
  //DS globas constant for exception
  Public static String  DSaterUpfateMethod = 'aterUpfateMethod';
  Public static String  DSshareDSQuotewithNewAccOwner = 'shareDSQuotewithNewAccOwner';
  Public static String  DSAfterInsert = 'AfterInsert';
  Public static String  DSShareQuotewithAcountOwner = 'ShareQuotewithAcount Owner';
  public static string restrictFileUploadOnDpNQpErrorMessage = 'File Cannot be added or deleted for current status of Commercial Proposal.';
  public static string header_indicator = 'Header';
  public static string item_indicator = 'Item';
  public static string Order_Management_Group = 'DS_Order_Management_Group';
  public static string CustomerDocumentLineItems = 'Customer_Document_Line_Items__c';
  public static string CustomerDocument = 'Customer_Document__c';
  public static string CustomerDocumentTriggerHelper = 'CustomerDocumentTriggerHelper';
  public static string CheckValidation = 'CheckValidation';
  public static string CloseCancelled = 'Closed-cancelled';
  public static string CustomerDocumentRegistration = 'Customer_Document_Registration';
  public static string DS_GDC = 'DS_GDC';
  public static string InRegistration = 'In Registration';
  public static string Registered = 'Registered';
  public static string Closedvalidated = 'Closed-validated';
  public static string Closedconsumed = 'Closed-consumed';
  public static string Closedrejected = 'Closed-rejected';
  public static string CD_Draft = 'Draft';
  public static string CD_SelectString = 'Select Id,';
  public static string CD_MissingFields = ',Missing_Fields__c,Customer_Document__c';
  public static string CD_From = ' from ';
  public static string CustomerDocumentJunctionTriggerHandler = 'CustomerDocumentJunctionTriggerHandler';
  public static string CustomerDocumentController = 'CustomerDocumentController';
  public static string deleteQuoteProposalAssociation = 'deleteQuoteProposalAssociation';
  public static string getselectOptions = 'getselectOptions';
  public static String ContractTypeNameProject = 'Project'; //Order Execution Flow is Project Mode
}