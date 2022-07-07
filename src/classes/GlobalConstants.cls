/******************************************************************************************************
Name : GlobalConstants
Created Date: 10th Nov 2016
Created by: Accenture
Description : This

will serve all constant values. So no hardcoding will be required in any of classes
*********************************************************************************************************/
global class GlobalConstants {
  //Approvals Sprint 14 Req#4419
  public static Boolean VALUE_FALSE = false;
  public static string OPPTY_START_NUMBER = '006';
  public static string COMPLETED_TASK = 'Completed';
  public static Boolean VALUE_TRUE = true;
  public static String NUMBER_THREE_ZERO_ONE = '301';
  public static Decimal NUMBER_ZERO = 0.0;
  public static string TASK_CREATION_HELPER;
  public static string NOT_ALLOWED_TO_CREATE_TASK;
  public static string NF_COMPLETEDOPPTASK_DELETE_UNDONE;
  public static string NOKIA_ADMIN_PROFILE='Nokia Admin Profile';
  public static string SYSTEM_AdMINISTRATOR='System Administrator';
  public static string GLOBAL_PROCESS_ADMIN_PROFILE='Global Process Admin Profile';
  public static string DATA_LOADER_PROFILE='Data Loader Profile';
  //Approvals Sprint Hypercare
  public static string G4_APPROVALS='G4 Approvals';
  public static string G5_CONTRACT_APPROVALS='G5 Contract Approvals';
  //Approvals Sprint 13.5 Req#4313
  public static Boolean DeleteOpenTaskFlag = False;
  public static string DELETE_OPEN_TASK;
  public static string CLOSED_NOT_COMPLETED = 'Closed - Not Completed';
  // Approvals Sprint 13 Req#4213
  public static string LOA_Level_C = 'C';
  public static Decimal Total_Net_Sale_Val = 10000000.00;
  // Loa Sprint 8 Req#2787
  public static string OPPORTUNITY_PHASE = 'Opportunity Phase :  ';
  public static string ACTIVEOFFER_SEMICOLON = '; Active Offer :  ';
  public static string GET_OPPTY_OFFER_VALUES ='getOpptyOfferValues';
  public static string SAVE_TASK_DETAILS = 'saveTaskDetails';
  // Loa Sprint7
  public static string LOA_Level = 'A';
  public static string WIN_THE_CASE_NEGOTIATE = 'Win the Case (Negotiate)';
  public static string OFFER_SUBMITTED_TO_CUSTOMER_MANUAL = 'Offer Submitted to Customer (Manual)';
  public static string METHOD_CREATE_SNAPSHOT_ACTIVE_OFFER = 'CreateSnapshotForActiveOffer';
  public static string METHOD_UPDATE_SNAPSHOT_ACTIVE_OFFER = 'updateOfferSnapshot';
  //LoA Sprint6
  public static string SUBMITTED_FOR_G2_APPROVAL = 'Submitted for G2 Approval';
  public static string SUBMITTED_FOR_G3_APPROVAL = 'Submitted for G3 Approval';
  public static string SUBMITTED_FOR_G4_APPROVAL = 'Submitted for G4 Approval';
  public static string SUBMITTED_FOR_G5_APPROVAL = 'Submitted for G5 Approval';
  public static string SUBMITTED_FOR_G6_APPROVAL = 'Submitted for G6 Approval';
  public static string SUBMITTED_FOR_G5_Contract_APPROVAL = 'Submitted for Gate 5 Contract Approval';
  public static string PENDING_WIN_LOSS_DECLARATION  = 'Pending Win/Loss Declaration';
  public static string METHOD_GETOPPTYID = 'getopptyIds';
  public static string METHOD_CREATE_SNAPSHOT_FOR_ACTIVE_OFFER = 'CreateSnapshotForActiveOffer';
  public static string METHOD_UPDATE_OFFER_SNAPSHOT = 'updateOfferSnapshot';
  public static boolean RUN_USER_TRIGGER_ON_OPP = false;
  public static string CHANGEMASTEROPTYONDEAL = 'changeMasterOpportunityOnDeal';
  public static string STANDARDOPPORTUNITY = 'Standard Opportunity' ;
  public static string ERROR_CHECK='ErrorcheckforOfferlevel';
  public static boolean Recursive_APPREq_CHECK=false;
  //Generic usage
  public static String SPACE = ' ';
  public static String COMMA = ',';
  public static String SEMICOLON = ';';
  public static String AT_THE_RATE_SYMBOL = '@';
  public static String DOT_SYMBOL ='.';
  public static String HASH_SYMBOL ='#';
  public static String QUESTIONMARK = '?';
  public static String HYPHEN = '-';
  public static String LOA_DATE_FORMAT = 'yyyy-MM-dd hh:mm:ss a';
  public static String MILLISEC_TIME_FORMAT = 'yyyy-MM-dd hh:mm:ss:SSS';
  public static String strSegInput = ',\n' ;

  //Access types
  public static String WRITE_ACCESS = 'Read/Write';
  public static String READ_ACCESS = 'Read Only';
  public static String EDIT = 'Edit';
  public static String ALL_ACCESS = 'All';
  public static String READ = 'Read';
  public static String ERROR = 'error';
  public static String QUERY_EXCEPTION = 'QueryException occured';
  public static String DML_EXCEPTION = 'DMLException occured';
  public static String GENERIC_EXCEPTION = 'Exception occured';
  public static String ERROR_OCCURED = 'Error occured : ';
  public static String ERROR_SYNTAX = ' ; Error::: ';
  public static String ERROR_SYNTAX_FIELDS = ' ; field(s) that affected this error : ';

  public static Integer RELATED_LIST_QUERY_LIMIT = 1000;
  public static Integer SOQL_QUERY_ROWS=50000;
  public static String LINE_NO = 'Line No';
  public static String CAUSE = 'Cause';

  public static String UNRESTRICTED_VALUE = 'Unrestricted';
  public static String RESTRICTED_VALUE = 'Restricted';
  public static String CONFIDENTIAL_VALUE = 'Confidential';
  public static String LASTMODIFIED_BY = 'LastModifiedBy';
  public static String LASTMODIFIED_DATE = 'LastModifiedDate';
  public static String CONFIDENTIAL_FILES_PERMISSION = 'Confidential_Files_Permission';

  public static String OTHER_OBJECT = 'Other';
  public static String OBJECT_ACCOUNT = 'Account';
  public static String OBJECT_OPPORTUNITY = 'Opportunity';
  public static String OBJECT_OFFER = 'Offer__c';
  public static String OBJECT_OFFER_1 = 'Offer';
  public static String OBJECT_MODIFIED_OFFER = 'Offer';
  public static String OBJECT_Document = 'Document__c';
  public static String OBJECT_Document_1 = 'Document';
  public static String BATCH_APEX = 'BatchApex';
  public static String PROCESSING = 'Processing';
  public static String PREPARING = 'Preparing';
  public static String UTF_8 ='UTF-8';
  public static String WILDCARD_SEARCH ='%';
  public static String fileDownloadURL = '/sfc/servlet.shepherd/version/download/';

  public static string UNDERSCORE_C = '__c';
  public static string UNDERSCORE = '_';
  public static string BOOKED = 'Booked';
  public static string CANCEL = 'Cancelled';
  public static string LOST = 'Lost';
  public static string BLANK_VALUE = '';
  public static string FILE_SHARE_TYPE_C = 'C';
  public static string FILE_SHARE_TYPE_V = 'V';
  public static string FILE_SHARE_TYPE_I ='I';
  public static string ALL_USERS = 'AllUsers';
  public static string CONTENT_ORIGIN = 'H';
  public static string TERMINATOR = ';';
  public static string BGROUP = 'bGroup';
  public static string OPTYID = 'optyId';
  public static string UNITED_STATES = 'United States';
  public static string FIFTY_THOUSAND = '50000';
  public static string TERRITORY_STATUS= 'Active';
  public static string EUR ='EUR';
  public static string WON ='Won';
  public static string WON_REQUESTED='Won (Requested)';
  public static string SALES_EMPTY =NULL;
  public static string CURRENCY_CHANGE='Currenychange';
  public static string CANCELLED_BY_CUSTOMER='Closed - Cancelled by Customer';
  public static string LOST_TO_COMPETITOR ='Closed - Lost to Competitor';
  public static string WITH_DRAW_BY_NOKIA ='Closed - Withdrawn by Nokia';
  public static string OBSOLETE='Closed - Obsolete';
  public static string CLOSED_CONVERTED='Closed - Converted (Qualified)';
  public static string TERRITORY2MODEL_STATE_ACTIVE = 'Active';
  public static string OPPORTUNITY_IN_PROGRESS = 'Opportunity in Progress';


  public static string CURRENT_VERSION = 'V';
  public static String BYTE_MEMORY = 'Bytes';
  public static String KILO_BYTE_MEMORY = ' KB';
  public static String MEGA_BYTE_MEMORY = ' MB';
  public static String GIGA_BYTE_MEMORY = ' GB';

  //Account Record Types
  public static string LEGAL_ENTITY = 'Legal Entity';
  public static string CUSTOMER= 'Customer';
  public static string PROSPECT = 'Prospect';
  public static string DIRECT_OPPTY = 'Create Direct Sales Opportunity';
  public static string INDIRECT_OPPTY = 'Create Indirect Sales Opportunity';
  Public static string READONLYDIRECT = 'Read Only Direct';
  Public static string READONLYINDIRECT = 'Read Only Indirect';
  public static string PREOPPORTUNITY = 'Pre-opportunity';
  //Apex class and methods name for exception handler
  public static string METHOD_GET_USER_GROUP = 'getUserGroup';
  public static string METHOD_INSERT_CONTENT_DOCUMENT_LINKS = 'insertContentDocumentLinks';
  public static string METHOD_ADDING_USER_TO_GROUP = 'addingUserToGroup';
  public static string METHOD_ADDING_USER_TO_GLOBAL_SHARING_GROUP = 'addingUserToGlobalSharingGroup';
  public static string METHOD_SHARE_WITH_GLOBAL_SHARING_GROUPS = 'shareWithGlobalSharingGroups';
  public static string METHOD_GET_LAST_MODIFIED_BY_AND_DATE = 'getLastModifiedByAndDate';
  public static string OPPTY_TRIGGER_HELPER= 'OpportunityTriggerHelper';
  public static string PROBABILITY_UPDATE= 'probabilityUpdate';
  public static string CLONE_OFFER_TEAM= 'CloneOfferTeam';
  public static string CLONE_TEAM= 'cloneTeam';
  public static string OFFER_ACTIVATION_HELPER= 'OfferActivationHelper';
  public static string METHOD_CREATE_LOA_BYPASS_DETAILS= 'createLoAByPassDetails';
  public static string METHOD_UPDATE_LOA_BYPASS_DETAILS = 'updateLoAByPassDetails';
  public static string ON_BEFORE_INSERT= 'onBeforeInsert';
  public static string ORDER_INTAKE_HELPER= 'OrderIntakeHepler';
  public static string ORDERINTAKE_HANDLER='OrderIntakeHandler';
  public static string BATCH_OIF_CURRENCY_UPDATE= 'batchoifCurrencyUpdate';
  public static string DELETE_CLONE_LINES ='DeletecloneLines';
  public static string BATCH_EXECUTE='execute';
  public static string BEFORE_UPDATE = 'BeforeUpdate';
  public static string BEFORE_INSERT= 'BeforeInsert';
  Public static string BEFORE_DELETE='BeforeDelete';
  Public static string After_UNDELETE='afterUndelete';
  Public static string After_DELETE='afterDelete';
  public static string UPDATE_OPPORTUNITY_AMOUNT='updateOpportunityAmount';
  public static string ON_DEMAND_FILE_SHARING_V2 ='OnDemandFileSharingV2';
  public static string METHOD_IS_ALLOW_TO_OPEN_FILE_DETAILS = 'IsAllowToOpenFileDetails';
  public static string METHOD_IS_CONTENT_DOC_ALREADY_SHARED = 'isContentDocAlreadyShared';
  public static string METHOD_IS_RESTRICTION_ALLOWED ='IsRestrictionAllowed';
  public static string METHOD_RETRIEVE_USER_ALLOWED_RESTRICTION_LEVELS =  'retrieveUsersAllowedRestrictionLevels';
  public static string METHOD_RETRIEVE_ASSOCIATED_RESTRICTION_LEVELS = 'retrieveAssociatedRestrictionLevels';
  public static string METHOD_GET_ACCOUNT_ID_FROM_DOCUMENT =  'GetAccountIDFromDocument';
  public static string METHOD_IS_PARTY_OF_L7_TO_TERRITORY = 'IsPartOfL7ToL4Territory';
  public static string METHOD_IS_PARTY_OF_OPPTY_OR_OFFER_TEAM =  'IsPartOfOpptyOrOfferTeam';
  public static string METHOD_SHARE_CONTENT_DOC_WITH_TERRITORY_USER =  'ShareContentDocWithTerritoryUser';
  public static string METHOD_SHARE_CONTENT_DOC_WITH_OPPTY_OFFER_TEAM =  'ShareContentDocWithOpptyOfferTeam';
  public static string METHOD_IS_CONTENT_DOC_SHARE_WITH_GLOBAL_GROUP =  'IsContentDocSharedWithGlobalGroup';
  public static string METHOD_USER_LIST_TO_STOP_FILE_SHARE_NOTIFICATION =  'usersListToStopFileShareNotifications';
  public static string METHOD_RETRIEVE_PRIORITY_TO_RESTRICTION_LEVEL =  'retrievePriorityToRestrictionLevel';
  public static string Method_BATCH_ACCOUNTTERRITORYREMOVALEXECUTE= 'Batch_AccountTerritoryRemoval'  ;
  public static string METHOD_BATCH_UNSHAREFILETERRITORYUSER='Batch_UnshareFileTerritoryUser';
  public static string METHOD_CHECK_LE_ISEMPTY ='checkLEIsEmpty';
  public static string METHOD_OFFER_PRICE_CHANGE = 'offerPriceChange';
  public static string SP_BATCHMETHOD='updateOpportunityOrgLevel';
  public static string SP_BATCHCLASS= 'SP_UpdateOrgLevelAcctoOppBL';
  public static string METHOD_ALLOW_TO_DELETE_FILE = 'allowToDeleteFile';
  public static string METHOD_DELETE_CONTENT_DOCUMENT = 'deleteContentDocument';
  //Req 3692
  public static string METHOD_OFFER_UPDATE_PrMVALIDATION = 'offerUpdatePrMValidation';
  public static string METHOD_OFFER_INSERT_PrMVALIDATION = 'offerinsertPrMValidation';
  public static string METHOD_OFFERTEAM_PrMVALIDATION = 'offerTeamPrMValidation';
  public static string METHOD_OPPORTUNITYTEAM_PrMVALIDATION = 'oppTeamPrMValidation';
  //Requirement 924
  public static string UPDATE_DEAL_MASTER = 'updateDealMasterOppty';

  public static string DATED_EXCHNAGERATE_HANDLER= 'DateExchnageRateHandler';
  public static string AFTER_INSERT='AfterInsert';
  public static string UPDATE_CURRENT_PERIOD= 'updateCurrentPeriod';
  public static string INSERT_DATED_CURRENCY ='insertDatedCurrency';
  public static string UPDATE_DATED_CURRENCY='updateDatedCurrency';
  public static string UPDATE_ACTIVE_OFFER= 'updateActiveOffers';
  public static string VALIDATE= 'validate';
  public static string CUSTOM_FILE_UPLOAD_CONTROLLER= 'CustomFileUploadController';
  public static string GET_ACCESSTYPE_AND_DOCTYPEMAP= 'getaccessTypeAndDocTypeMap';
  public static string FIND_OBJECTNAME_FROM_RECORDID_PREFIX= 'findObjectNameFromRecordIdPrefix';
  public static string SAVE_THE_FILE='saveTheFile';
  public static string SAVE_THE_CHUNK= 'saveTheChunk';
  public static string APPEND_TO_FILE= 'appendToFile';
  public static string SHARED_UPLOADED_DOCUMENT='sharedUploadedDocument';
  public static string GENERATE_CONTENT_DOCUMENT_LINK_RECORD= 'generateContentDocumentLinkRecord';
  public static string GET_USER_LIST_RELATED_BASED_ON_TERRITORY= 'getUserListRelatedBasedOnTerritory';
  public static string COLLECT_TEAM_USERS= 'collectTeamUsers';
  public static string Retrieve_ALLOWED_RESTRICTION_TYPES= 'retrieveAllowedRestrictionTypes';
  public static string LEADTRIGGERHELPER = 'leadTriggerHelper';
  public static string LEADTRIGGERHANDLER ='LeadTriggerHandler';
  public static string LEADTRIGGER = 'LEADTRIGGER';
  public static string LEAD_CONVERSION_VALIDATIONS = 'leadConversionValidations';
  public static string ADD_OPP_DEFAULT_VALUES = 'addOppDefaultValues';
  public static string NAVIGATEBACKCONTROLLER= 'NavigateBackController'; //REQ-626
  public static string GOBACKTORECORD= 'goBackToRecord'; //REQ-626
  public static string ACCOUNTTRIGGERHELPER = 'AccountTriggerHelper';//Req-654
  public static string ACCOUNTTRIGGERHANDLER ='AccountTriggerHandler';//Req-654
  public static string ACCOUNTTRIGGER = 'AccountTRIGGER';//Req-654
  public static string CHOOSE_DEFAULT_LEGAL_ENTITY = 'chooseDefaultLegalEntity';//Req-654
  public static string UPDATE_DEFAULT_LE_FOR_NEWCUSTOMER = 'updateDefaultLEforNewCustomer';//Req-654
  public static string COMPUTE_DS= 'computeDS';//Req-654
  public static string VALIDATE_DEFAULT_LEGALENTITY = 'validateDefaultLegalEntity';//Req-654
  public static string BEFORE_INSERT_OPERATION = 'beforeInsertOperation';//Req-654
  public static string BEFORE_UPDATE_OPERATION = 'beforeUpdateOperation';//Req-654
  public static string COMPUTE_LEGALENTITY_LIST = 'computeLegalEntityList';//Req-654
  public static string METHOD_GETRELATEDFILES = 'getRelatedFiles';
  public static string METHOD_RETRIEVEDOCUMENTS = 'retrieveDocuments';
  public static string METHOD_RETRIEVEALLOWEDRESTRICTIONTYPES = 'retrieveAllowedRestrictionTypes';
  public static string METHOD_RETRIEVECONTENTDOCUMENTIDS = 'retrieveContentDocumentIds';
  public static string METHOD_FILESIZETOSTRING = 'filesizeToString';
  public static string METHOD_SAVEFILEDETAILS = 'saveFileDetails';
  public static string METHOD_GETDOCUMENTTYPES = 'getDocumentTypes';
  public static string METHOD_UPDATEDOCUMENTREC ='updateDocumentRec';
  public static string CONTENTDOCUMENTID ='ContentDocumentId';
  public static string EXPRESSION ='expr0';
  public static string METHOD_FILEUPLOADALLOWED = 'fileUploadAllowed';
  //OIF class
  public static string UPDATE_OPPTY_AMOUNT = 'updateOpportunityAmount';

  // Doc Strategy : Sprint 3- REQ-605
  public static string HND_CONTENT_DOCUMENT_HANDLER= 'to be updated';
  public static string DELETE_RELATED_DOCUMENT= 'to be updated';
  public static String SHARING_OPTION_VALUE= 'R';
  public static string TERRITORY= 'Territory';

  // Doc Strategy : Sprint 3- REQ-657
  public static string OPPORTUNITY_TEAM_HELPER = 'To be Updated';
  Public static String OFFER_TEAM_HELPER = 'To be updated';

  //Exception Handler class Req: 650
  public static string VALIDATION = 'VALIDATION';
  public static string VALIDATION_EXCEPTION = 'FIELD_CUSTOM_VALIDATION_EXCEPTION,';
  public static string MIXED_DML = 'MIXED_DML_OPERATION';
  public static string DMLEXCEPTION = 'DmlException';
  public static string SYSTEM_DML = 'System.DmlException:';
  public static string REQUIRED_FILED_MISSING = 'REQUIRED_FIELD_MISSING';

  // Orderintkae batch Batch schedule Req:136

  public static String INTERNALUSERID = 'InternalUserId';
  public static String BATCH_HOUR = '00';
  public static String BATCH_MINUTES ='00';
  Public Static String EMPTY=' ';
  public static String year1 = string.valueOf(system.now().year());
  public static String strJobName = 'Batch OIF Update-' + string.valueOf(system.now().day())+ '_' + string.valueOf(system.now().month()) + '_' + string.valueOf(system.now().year())  + '_' +string.valueOf(system.now().hour())+ '_' + string.valueOf(system.now().second())+ '_' +  string.valueOf(system.now().minute());
  //Req::950
  Public Static String ZERO='0';

  public static String strSchedule = '0 ' + BATCH_MINUTES + ' ' + BATCH_HOUR + ' ' +string.valueOf(system.now().day()+1) + ' ' + string.valueOf(system.now().month()) + ' ?' + ' ' + string.valueOf(system.now().year());

  public static String restrSchedule = '0 ' + string.valueOf(system.now().minute()+15)+ ' ' + BATCH_HOUR + ' ' +string.valueOf(system.now().day()+1) + ' ' + string.valueOf(system.now().month()) + ' ?' + ' ' + string.valueOf(system.now().year());


  public static string SCHEDULEJOBNAME = 'Batch OIF Update';
  public static string STARTJOBTIME =Datetime.now().minute()+Datetime.now().getTime() + ' * ' + Datetime.now().day() + ' ' + Datetime.now().month() + ' ' + ' ? ' + Datetime.now().year();
  public static string EXCHANGERATE= 'Exchnagereate Update';
  public static string DATED_EXCHANGERATE_HELPER ='DateExchnageRateHelper';
  public static string SCHEDULE_BATCH='scheduleBatch';
  public static string OIFBATCH_UPDATE_SCHEDULE='OifBatchUpdateSchedule';
  public static string  START='start';

  //Sales Process requirement 633: SOAP class
  public static string CUSTOMER_NUMBER_BLANK = 'Required Customer Number field is empty';
  public static string LEGEAL_NAME_BLANK = 'Required Legal Name field is empty. Customer Number : ';
  public static string CURRENCY_CODE_BLANK = 'Required Currency Code field is empty. Customer Number : ';
  public static string ACTIVITY_SECTOR_BLANK = 'Required Activity Sector Code field is empty. Customer Number : ';
  public static string STREET_BLANK = 'Required Street field is empty. Customer Number : ';
  public static string CITY_BLANK = 'Required City field is empty. Customer Number : ';
  public static string COUNTRY_CODE_ISO2_BLANK = 'Required country Code ISO2 field is empty. Customer Number : ';
  public static string CUSTOMER_ACCOUNT_CODE_BLANK = 'Required customer Account Code field is empty. Customer Number : ';
  public static string CUSTOMER_ACCOUNT_NAME_BLANK = 'Required customer Account Name field is empty. Customer Number : ';
  public static string FGC_CODE_BLANK = 'Required FCG Code field is empty. Customer Number : ';
  public static string FGC_NAME_BLANK = 'Required FCG Name field is empty. Customer Number : ';
  public static string KEY_ACCOUNT_NAME_BLANK = 'Required Key Account Name field is empty. Customer Number : ';
  public static string HOLDING_ACCOUNT_NAME_BLANK = 'Required Holding Account Name field is empty. Customer Number : ';
  public static string SUCCESS = 'Success';
  public static string UPDATE_VALUE = 'Update';
  public static string INSERT_VALUE = 'Insert';
  public static string FAILURE = 'Failure';
  public static string ACCOUNT_NUMBER = 'Account # ';
  public static string INTERFACE_TYPE = 'ALCR ACC Sync';
  public static string INBOUND = 'Inbound';
  public static string ACCOUNT_NUMBER_COLON = 'Account Number: ';
  public static string SALESFORCE_ID = 'Salesforce ID: ';
  public static string MAP_ACC_SIZE = '!!!!!!! mapAccount size';
  public static string NO_ERRORS = 'No errors';
  public static string TXT_EXTENSION = '.txt';
  public static string BATCH_QUERY ='select Account_ID__c, Ready_to_Process__c from Account_Capture__c where Ready_to_Process__c = true';

  //Doc strategy FileUpload
  public static string ID= 'id';
  public static string PARAM1= 'param1';
  public static string PARAM2= 'param2';
  public static string PARAM3= 'param3';
  public static string UNRESTRICTED = 'Unrestricted';
  public static string ERROR_MSG= 'A file with the same Document Type has already been Uploaded';
  public static string TERRITORYMANUAL = 'TerritoryManual';
  public static string BLANK = '';
  public static string CHARACTERTOBECOMPARE = '--';
  public static string OPTY_OFFER_TEAM_FILE_SHARING = 'Opportunity/OfferTeamFileSharingLimit';
  public static string LoA_G4_Template = 'LoA G4 Template';
  public static string LoA_G5_Template = 'LoA G5 Template';

  //Defualt legal Entity on account
  public static boolean isDefaultUpdated = true;
  public static String naviagtionURLPre = 'https://nokiasinglecrm--';
  public static String naviagtionURLPost = '.lightning.force.com';
  public static string DOCUMENTCONTROLLER= 'DocumentController';
  public static String GETNEWLISTTOINSERT = 'listToInsert';
  public static String CONTENTDOCUMENTLINK = 'createContentDocumentlink';

  //Doc Strategy Mass delete/download component
  public static string ALLOWED_PROFILE_FOR_MASS_DELETE = 'Allowed_Profiles_For_Mass_Delete';
  public static string GET_ALLOWED_PROFILE_FOR_MASS_DELETE = 'getProfileSetForMassDelete';
  public static string FETCH_RECORDS = 'fetchRecords';
  public static string DOC_SELECTION_LIMIT = 'docSelectionLimit';
  public static string RETURN_DOC_REC = 'returnDocumentRecords';
  public static string GET_CONTENT_DOC_ID = 'getContentDocId';
  public static string DOWNLOAD_FILES = 'downloadFiles';
  public static string DELETE_FILES = 'deleteRecords';
  public static string MULTI_DOC_OPERATION_LIMIT = 'MultiDocumentOperationLimit';
  //Method names
  public static string GETNEWDOCUMENTTYPELIST = 'getnewDocumentTypeList';
  public static string GETCURRENTSALESFORCEURL = 'getCurrentSalesforceURL';
  public static string GETCURRENTRECORDDETAILS = 'getCurrentRecordDetails';
  public static string GETDOCINACTIONFUNCTION = 'getDocinActionFunction';
  public static string GETRESTRICTIONTYPELIST = 'getRestrictionTypeList';
  public static string FINDOBJECTNAMEFROMRECORDIDPREFIX = 'findObjectNameFromRecordIdPrefix';
  public static string CREATECONTENTDOCUMENTLINK = 'createContentDocumentLink';
  public static string SHAREDUPLOADEDDOCUMENT = 'sharedUploadedDocument';
  public static string GENERATECONTENTDOCUMENTLINKRECORD = 'generateContentDocumentLinkRecord';
  public static string UPDATECONTENTVERSIONRECORD = 'updateContVersionForSharingTypeAndOwner';
  public static string COLLECTTEAMUSERS = 'collectTeamUsers';
  public static string RETRIEVEALLOWEDRESTRICTIONTYPES = 'retrieveAllowedRestrictionTypes';
  public static string METHOD_USERS_LIST_TO_STOP_FILE_SHARE_NOTIFICATION = 'usersListToStopFileShareNotifications' ;
  public static string CONTENT_DOCUMENT_LINK_UTILITY = 'ContentDocumentLinkUtility';
  public static String METHOD_INSERT_CONTENT_DOC_LINK_BATCH = 'insertContentDocumentLinkBatch';
  public static String METHOD_DELETE_CONTENTDOCUMENT_LINKS_FUTURE = 'deleteContentDocumentLinksFuture';
  public static String METHOD_SCHEDULERESTRICTIONLEVELUPDATEBATCH = 'scheduleRestrictionLevelUpdateBatch';
  public static String METHOD_GETRESTRICTIONLEVELCHANGED = 'getRestrictionLevelChanged';
  public static String METHOD_RETRIEVEUSERSOFFERTEAMDOCS = 'retrieveUsersOfferTeamDocs';
  public static String METHOD_RETRIEVEOFFERTEAMDOCS = 'retrieveOfferTeamDocs';
  public static String METHOD_RETRIEVEUSERSOPPORTUNITYTEAMDOCS = 'retrieveUsersOpportunityTeamDocs';
  public static String METHOD_RETRIEVEOPPORTUNITYTEAMDOCS = 'retrieveOpportunityTeamDocs';
  public static String METHOD_RETRIEVEUSERIDANDDOCLIST = 'retrieveUserIdAndDocList';
  public static String METHOD_RETRIEVEUSERSCONTENTDOCUMENTIDS = 'retrieveUsersContentDocumentIds';
  public static String METHOD_INSERTCONTENTDOCUMENTLINKS = 'insertContentDocumentLinks';
  public static String METHOD_DELETECONTENTDOCUMENTLINKS = 'deleteContentDocumentLinks';
  public static String METHOD_FUTUREINSERTCONTENTDOCUMENTLINK = 'futureInsertContentDocumentLink';
  public static String METHOD_FUTUREDELETECONTENTDOCUMENTLINK = 'futureDeleteContentDocumentLink';
  public static String METHOD_COLLECTCONTENTDOCIDCOUNT = 'collectContentDocIdCount';
  public static String METHOD_COLLECTFILTEREDUSERSCONTDOCIDS = 'collectFilteredUsersContDocIds';
  public static String METHOD_RETRIEVEUSERSCONTENTDOCUMENTWITHSHARINGLIMIT = 'retrieveUsersContentDocumentWithSharingLimit';
  public static String METHOD_FILTERCONTENTDOCUMENTSBYLIMIT = 'filterContentDocumentsByLimit';
  public static String METHOD_GETFILESHARINGLIMIT = 'getFileSharingLimit';
  public static String METHOD_RETRIEVEUSERSCURRENTTERRITORIES = 'retrieveUsersCurrentTerritories';
  public static String METHOD_RETRIEVEUSERSL7TERRITORIES = 'retrieveUsersL7Territories';
  public static String METHOD_FINDCHILDNODES = 'findChildNodes';
  public static String METHOD_RETRIEVEUSERSSPECIFIEDTERRITORIES = 'retrieveUsersSpecifiedTerritories';
  public static String METHOD_RETRIEVERELATEDOBJECTS = 'retrieveRelatedObjects';
  public static String METHOD_RETRIEVEUSERSDOCUMENTS = 'retrieveUsersDocuments';
  public static String METHOD_RETRIEVERELATEDDOCUMENTS = 'retrieveRelatedDocuments';
  public static String METHOD_RETRIEVEOLDRELATEDDOCUMENTS = 'retrieveOldRelatedDocuments';
  public static String METHOD_GETPARENTTERRITORIESOFACCOUNT = 'getParentTerritoriesOfAccount';
  public static String METHOD_COLLECTFILTEREDTERRITORYUSERS = 'collectFilteredTerritoryUsers';
  public static String METHOD_COLLECTL7TERRITORY = 'collectL7territory';
  public static String METHOD_GETALLOWEDTERRITORIES = 'getAllowedTerritories';
  public static String METHOD_INSERTUSERSOPPORTUNITYTEAMDOCS = 'insertUsersOpportunityTeamDocs';
  public static String METHOD_GETOPPORTUNITYTEAMDOCS = 'getOpportunityTeamDocs';
  public static String METHOD_INSERTUSERSOFFERTEAMDOCS = 'insertUsersOfferTeamDocs';
  public static String METHOD_GETOFFERTEAMDOCS = 'getOfferTeamDocs';
  public static String METHOD_ISSHARINGREQUIRED = 'isSharingRequired';
  public static String METHOD_EXECUTE = 'execute';
  public static String METHOD_COLLABORATIONGROUPUTILITY = 'CollaborationGroupUtility';
  public static String METHOD_BATCH_USERTERRITORY2ASSOCIATIONADD = 'Batch_UserTerritory2AssociationAdd';
  public static String METHOD_BATCH_USERTERRITORY2ASSOCIATIONREMOVE = 'Batch_UserTerritory2AssociationRemove';
  public static String METHOD_INSERTCOLLABORATIONGROUPMEMBERS = 'insertCollaborationGroupMembers';
  public static String METHOD_DELETECOLLABORATIONGROUPMEMBERS = 'deleteCollaborationGroupMembers';
  public static String METHOD_REMOVEUSERSFROMALLNSAGROUPS = 'removeUsersFromAllNSAGroups';
  public static String METHOD_GETNSAADMINPROFILES = 'getNSAAdminProfiles';
  public static String METHOD_GETNSATERRITORYLEVELS = 'getNSATerritoryLevels';
  public static String METHOD_GETNON_NSATERRITORYLEVELS = 'getNON_NSATerritoryLevels';
  public static String METHOD_RETRIEVESOQLFORL7TERRITORY = 'retrieveSOQLForL7Territory';
  public static String METHOD_RETRIEVEUSERSASSIGNEDTERRITORIES = 'retrieveUsersAssignedTerritories';
  public static String METHOD_RETRIEVEL7TERRITORIESFORPARENTTERRITORY = 'retrieveL7TerritoriesForParentTerritory';
  public static String METHOD_UPDATEUPLOADEDFILEVERSION = 'updateUploadedFileVersion';
  public static String METHOD_COLLECTASSOCIATEDL7TERRITORYFORDOCIDFUNCTION = 'collectAssociatedL7territoryForDocIdFunction';
  public static String METHOD_COLLECTASSOCIATEDL7TERRITORYFORDOCID = 'collectAssociatedL7territoryForDocId';
  public static String METHOD_UPDATEOFFER = 'updateOffer';
  public static String METHOD_UPDATEOFFERSSOONINSERT = 'updateOfferSSOOnInsert';
  public static String METHOD_UPDATEOFFERSSOONUPDATE = 'updateOfferSSOOnUpdate';
  public static String METHOD_UPDATEOFFERSSOONDELETE = 'updateOfferSSOOnDelete';
  public static String METHOD_UPDATEOFFERSSOONUNDELETE = 'updateOfferSSOOnUndelete';
  public static String METHOD_UPDATEOPPORTUNITY = 'updateOpportunity';
  public static String METHOD_EXCELADDINUPDATE = 'excelAddInUpdate';
  public static String METHOD_MARKETVALIDATION = 'marketValidation';
  public static String populateSalesOutcome = 'populateSalesOutcome';
  public static String MARKETVALIDATIONERROR_MSG = '"Pre-approved Price List for Account Managers" is not available for your market';
  public static String LOA_BYPASS = 'Pre-approved Price List for Account Managers';
  //SalesProcess 741
  public static String UPDATE_OPPTY_ACCOUNT_UPDATE = 'updateOpptyOnAccUpdate';

  public static string ACCOUNTCOUNT = 'cnt';
  public static string PARENTID = 'parentId';
  public static string CNAME = 'name';
  public static string CNUMBER = 'AccountNumber';

  //Requirement 861
  public static string USER_TERRITORY_HELPER= 'UserTerritoryHelper';
  //Requirement 649
  public static string OFFER_TEAM_HELPER_CLASS = 'OfferTeamHelper';
  public static string OFFER_SHARE = 'offerTeamRecordShare';
  //Requirement 722
  public static string FOLLOW_OPPORTUNITY = 'FollowOpportunity';
  public static string  UPDATE_USER_INFORMATION='UpdateUserinformation';

  //File Sharing
  public static Boolean RUN_USER_TRIGGER_ON_FILESHARING = true;
  public static Boolean RUN_OFFERTEAM_TRIGGER_ON_FILESHARING = true;
  public static Boolean RUN_CONTENTDOCUMENT_TRIGGER_ON_FILESHARING = true;
  public static Boolean RUN_OPPORTUNITYTEAM_TRIGGER_ON_FILESHARING = true;
  public static Boolean RUN_CONTENTDOCUMENTLINK_TRIGGER_ON_FILESHARING = true;
  public static Boolean RUN_USERTERRITORY2ASSOCIATION_TRIGGER_ON_FILESHARING = true;
  public static String ALLOWED_TERRITORIES = 'TerritoriesForSharing';
  public static String ALLOWED_TOTAL_FILE_SHARE_LIMIT = 'Allowed User Count For File Share';
  public static String BATCH_USERRESTRICTIONLEVELUPDATE_NAME = 'Batch_UserRestrictionLevelUpdate';
  public static String SCHEDULER_USERRESTRICTIONLEVELUPDATE_NAME = 'Scheduler_UserRestrictionLevelUpdate';
  public static String BATCH_USERRESTRICTIONLEVELUPDATE_SIZE = 'Batch_UserRestrictionLevelUpdateSize';
  public static String BATCH_RESTRICTIONLEVELINCREMENT_SIZE = 'Batch_RestrictionLevelIncrementSize';
  public static String BATCH_RESTRICTIONLEVELDECREMENT_SIZE = 'Batch_RestrictionLevelDecrementSize';
  public static String BATCH_ACCOUNTTERRITORYREMOVAL_SIZE = 'Batch_AccountTerritoryRemovalSize';
  public static String BATCH_UNSHAREFILETERRITORYUSER_SIZE = 'BatchSize_UnshareFileTerritoryUser';
  public static String SCHEDULER_RESTRICTIONLEVELINCREMENT_NAME = 'Scheduler_RestrictionLevelIncrement';
  public static String SCHEDULER_RESTRICTIONLEVELDECREMENT_NAME = 'Scheduler_RestrictionLevelDecrement';
  public static String SCHEDULER_ACCOUNTTERRITORYREMOVAL_NAME = 'Scheduler_AccountTerritoryRemoval';
  public static String SCHEDULER_UNSHAREFILETERRITORYUSER_NAME = 'Scheduler_UnshareFileTerritoryUser';
  public static String ALLOWED_SIZE_FOR_CONTENTDOCIDS_LIMIT = 'Allowed Size For ContentDocIds';
  public static String OPPORTUNITY_DOC_FREEZE_STAGE = 'Opportunity_SalesPhase_FinalStage';
  public static String OPPORTUNITY_SALES_OUTCOME_VALUES = 'OpportunitySalesOutcomeValues';
  public static String OPPORTUNITY_PHASE_STATUS_VALUES = 'OpportunityPhaseStatusValues';
  public static String OPPORTUNITY_GATE_VALUES = 'OpportunityGateValue';
  public static String UNDELETABLE_DOC_TYPES = 'Undeletable_Doc_Type';
  public static String UNDELETABLE_DOC_RESTRICTION_LEVEL = 'Undeletable_Doc_RestrictionLevel';
  public static String UNDELETABLE_DOC_PROFILE = 'Undeletable_Doc_Profile';
  public static String CANCELLED_LOST_OOPTY = 'Cancelled_Lost_Opportunity';
  public static String OPPORTUNITY_CANCELLED_LOST = 'Opportunity_Status_Cancelled_Lost';
  public static String OPPORTUNITY_SALES_PHASE_VALUES = 'OpportunitySalesPhase';
  public static String OPPORTUNITY_STATUS_BAR_CONTROLLER = 'opportunityStatusBarController';
  public static String SCHEDULER_NAME = 'SchedulerName';
  public static String SCHEDULERACCOUNTADDITIONBATCH = 'SchedulerAccountAdditionBatch';
  public static String SCHEDULERACCOUNTREMOVALBATCH = 'SchedulerAccountRemovalBatch';
  public static String SCHEDULERACCOUNTMOVEMENTBATCH = 'SchedulerAccountMovementBatch';
  public static String SCHEDULERACCOUNTMOVEMENTNONNSATONSA = 'SchedulerAccountMovementNonNSAToNSA';
  public static String SCHEDULER_OFFERTEAMFILEDELETEBATCH = 'Scheduler_OfferTeamFileDeleteBatch';
  public static String SCHEDULER_OFFERTEAMFILESHAREBATCH = 'Scheduler_OfferTeamFileShareBatch';
  public static String USERTERRITORYADDITIONBATCHSIZE ='UserTerritoryAdditionBatchSize';
  public static String ACCOUNT_MOVEMENT_BATCH_SIZE ='Account_Movement_Batch_Size';
  public static String USERTERRITORYREMOVALBATCHSIZE ='UserTerritoryRemovalBatchSize';
  public static String CONTENTDOCUMENTLINKBATCHSIZE ='ContentDocumentLinkBatchSize';
  public static String OPPORTUNITYTEAMBATCHSIZE = 'OpportunityTeamBatchSize';
  public static String OFFERTEAMBATCHSIZE = 'OfferTeamBatchSize';
  public static String INSERTDATAINTOSERVICEOBJECTBATCHSIZE = 'InsertDataIntoServiceObjectBatchSize';
  public static String L7_TERRITORY = 'L7';
  public static String RESCHEDULINGTIME='ReschedulingTime';
  public static String SCHEDULINGTIME='SchedulingTime';
  public static String USERTERRITORYADDITIONSCHEDULER='UserTerritoryAdditionScheduler';
  public static String SCHEDULERUSERTERRITORYADDITION= 'SchedulerUserTerritoryAddition';
  public static String SCHEDULERUSERDELETIONFROMTERRITORY= 'SchedulerUserDeletionFromTerritory';
  public static String USERTERRITORYREMOVALSCHEDULER ='UserTerritoryRemovalScheduler';
  public static String SCHEDULESHAREFILEAFTERCONDOCLINK ='ScheduleShareFileAfterConDocLink';
  public static String SCHEDULEINSERTDATAINTOSERVICEOBJECT ='ScheduleInsertDataIntoServiceObject';
  public static String SCHEDULEROPPTYTEAMFILESHAREBATCH ='SchedulerOpptyTeamFileShareBatch';
  public static String SCHEDULEROPPTYTEAMFILEDELETEBATCH ='SchedulerOpptyTeamFileDeleteBatch';
  public static String APEX_SHARING_RECALCULATION='Apex Sharing Recalculation ';
  public static String BATCH_JOB_PROCESSED='The batch Apex job processed ' ;
  public static String BATCHES_WITH=' batches with ';
  public static String FAILURES=' failures.';
  public static string SUCCESS_MESSAGE = '\nSuccess - ';
  public static string FAILURE_MESSAGE = '\nFailure - ';
  public static String EXECUTION = 'execution';
  public static String USERRESTRICTIONLEVELUPDATEBATCH_MESSAGE = 'The batch execution for Batch_UserRestrictionLevelUpdate has been finished :\n';
  public static String TERRITORY2MANUAL = 'Territory2Manual';
  public static String BATCH_USERTERRITORYADDITION_NAME = 'Batch_UserTerritoryAddition';
  public static string BATCH_RECALLOPPORTUNITY ='Batch Recall Ongoing Opportunity';
  public static String BATCH_USERTERRITORYADDITION_MESSAGE  = 'The batch execution for Batch_UserTerritoryAddition has been finished :\n';
  public static String BATCH_USERTERRITORYREMOVAL_NAME = 'Batch_UserTerritoryRemoval';
  public static String BATCH_USERTERRITORYREMOVAL_MESSAGE  = 'The batch execution for Batch_UserTerritoryRemoval has been finished :\n';
  public static String BATCH_SHAREFILEAFTERUPLOAD_NAME = 'Batch_ShareFileAfterUploadContDocLink';
  public static String BATCH_SHAREFILEAFTERUPLOAD_MESSAGE  = 'The batch execution for Batch_ShareFileAfterUploadContDocLink has been finished :\n';
  public static String ADDLEGALENTITIESINTERRITORY = 'AddLegalEntitiesInTerritory';
  public static String EXECUTE = 'execute';
  public static String DELETEPREVIOUSTERRITORYASSOCIATION = 'deletePreviousTerrritoryAssciation';
  public static String COMPUTECUSTOMERTVSLELIST = 'computeCustomerVsLEList';
  public static String CREATENEWTERRITORYASSOCIATION = 'createNewTerroitoryAssociation';
  public static String DETECTCUSTOMERTERRITORYCHANGESSCHEDULAR = 'DetectCustomerTerritoryChangesSchedular';
  public static String METHOD_GETCONTENTDOCUMENTLINKS = 'getContentDocumentLinks';
  public static String METHOD_OPPORTUNITYSALESOUTCOMEVALUE = 'getOpportunitySalesOutcomeValues';
  public static String NONCOMPLAINTACCOUNT_VALUE = 'NonComplaintAccount_Value';
  public static String NSACOMPLIANTVALUE = 'NSACompliantValue';
  public static String SSO_DOCUMENTTYPES = 'SSO_DocumentTypes';
  public static String LOA_G4_G5_DOCUMENTTYPES = 'LoA_G4_G5_DocumentTypes';

  //For new Sharing development : 6th FEB 2017.
  public static String TERRITORY_HIERARCHY_LEVEL_L1 = 'L1';
  public static String TERRITORY_HIERARCHY_LEVEL_L2 = 'L2';
  public static String TERRITORY_HIERARCHY_LEVEL_L3 = 'L3';
  public static String TERRITORY_HIERARCHY_LEVEL_L4 = 'L4';
  public static String TERRITORY_HIERARCHY_LEVEL_L5 = 'L5';
  public static String TERRITORY_HIERARCHY_LEVEL_L6 = 'L6';
  public static String TERRITORY_HIERARCHY_LEVEL_L7 = 'L7';

  public static String COLLABORATION_ROLE_STANDARD = 'Standard';
  public static String COLLABORATION_NOTIFICATION_FREQUENCY_N = 'N';
  public static String CHATTER_CONTENT_POST_TYPE = 'ContentPost';
  public static String CHATTER_FILE_UPLOAD_ERROR_MESSAGE_CUST_SETTING = 'Chatter File Upload Error Message';
  public static String CHATTER_COMMENT_CONTENT_POST_TYPE = 'ContentComment';
  public static String CHATTER_FILE_INLINE_BODY_CUST_SETTING = 'Chatter File Inline Body Content';
  public static String ALLOWED_PROFILES_FOR_CHATTER_FILES = 'Allowed Profiles For Chatter Files';
  public static String METHOD_CHECK_FILE_UPLODED_VIA_CHATTER_POST = 'checkFIleUploadedViaChatterPos()';
  public static String SANDBOX = '.cs';

  public static String TERRITORIES_FOR_NSA_COMPLIANCE = 'TerritoriesForNSACompliance';
  public static String NSA_ADMIN_PROFILES_ID = 'NSAAdminProfileIds';
  public static String NSA_COMPLIANT_ADMIN_GROUP_ID = 'NSACompliantAdmin';
  public static String NSA_NON_COMPLIANT_ADMIN_GROUP_ID = 'NSANonCompliantAdmin';
  public static String NSA_COMPLIANT_UNRESTRICTED_GROUP_ID = 'NSACompliant-Unrestricted';
  public static String NSA_COMPLIANT_RESTRICTED_GROUP_ID = 'NSACompliant-Restricted';
  public static String NSA_COMPLIANT_CONFIDENTIAL_GROUP_ID = 'NSACompliant-Confidential';
  public static String NSA_NON_COMPLIANT_UNRESTRICTED_GROUP_ID = 'NSANonCompliant-Unrestricted';
  public static String NSA_NON_COMPLIANT_RESTRICTED_GROUP_ID = 'NSANonCompliant-Restricted';
  public static String NSA_NON_COMPLIANT_CONFIDENTIAL_GROUP_ID = 'NSANonCompliant-Confidential';
  public static Boolean isNSA_COMPLIANT_RUNNING = false;

  // For Version Number of the file
  public static String VERSION_NUMBER = '1';

  // for chatter file upload
  public static String USER_UI_THEME_MOBILE = 'Theme4t';
  public static String FUNCTION_CHECK_IS_MOBILE_UPLOAD = 'checkIsItMobileUploadOrNot()';
  // for Opportunity Decison Period update
  public static String DECISION_UPDATE='DecisonUpdate';


  public static string CONTENT_DOCUMENT_HELPER= 'ContentDocumentLinkHelper'; //Requirement 773
  public static string UPDATE_CUSTOMDOCUMENT_OBJECT_FIELDS = 'updateCustomDocumentObjectFields'; //Requirement 773
  public static string CONTENT_VERSION_TRIGGER_HELPER = 'ContentVersionTriggerHelper'; //Requirement 773
  public static string UPDATE_FILE_VERSION = 'updateFileVersion';   //Requirement 773
  public static string UNDELETE_RELATED_DOCUMENT = 'undeleteRelatedDocumentHelper'; // Requirement //884

  public static string FILENAME = 'fileName'; //new Structure for fileupload
  public static string ACCESSLEVELINPUT = 'accessLevelInput';   //new Structure for fileupload
  public static string DOCUMENTTYPEINPUT = 'documentTypeInput'; //new Structure for fileupload
  public static string COMMENTINPUT = 'commentInput'; //new Structure for fileupload
  public static string FILESIZE = 'fileSize';   //new Structure for fileupload
  public static string SHAREFILESONUPLOADBATCHSIZE = 'ShareFilesOnUploadBatchSize';   //new Structure for fileupload
  public static string UNASSIGNED = 'Unassigned';

  public static string WIN_THE_CASE='Won (Requested)';

  public static string SHAREWITHLEVEL1TO3ANDWITHADMINGROUPSHARE = 'shareWithLevel1To3AndWithAdminGroupShare';
  public static string SHAREWITHLEVEL1TO3ANDWITHADMINGROUP = 'shareWithLevel1To3AndWithAdminGroup';
  public static string CONTENTDOCUMENTLINKHELPER = 'ContentDocumentLinkHelper';
  public static string INSERTINTODELETEDOTM='insertIntoDeleted_OTM';

  //Sales Process
  public static string COMPETITORTRIGGERHELPER = 'CompetitorTriggerHelper';
  public static string RETRICTCOMPETITOR= 'retrictCompetitor';
  public static string CAMPAIGNTRIGGERHELPER = 'CampaignTriggerHelper';
  public static string RETRICTCAMPAIGN= 'retrictCampaign';
  public static string RETRICTOFFER = 'retrictOffer';
  public static string RESTRICTOTM = 'retrictOTM';
  public static string IDENTIFY_OPPORTUNITY = 'Identify Opportunity';
  public static string WIN_THE_CASE_OPPORTUNITY_STAGE = 'Win the Case (Negotiate)';
  public static string CREATE_OFFER = 'Create Offer (Bid)';
  public static string DEVELOP_OPPORTUNITY = 'Develop Opportunity';
  public static string PLANNED = 'Planned';
  public static string OPTYPROGRAMFLAGJUNCTIONTRIGGERHELPER = 'OptyProgramFlagJunctionTriggerHelper';
  public static string RETRICTOPTYPROGRAMFLAGJUNCTION='retrictOptyProgramFlagJunction';
  public static string QUESTIONNAIRETRIGGERHELPER = 'QuestionnaireTriggerHelper';
  public static string RETRICTQUESTIONNAIRE = 'retrictQuestionnaire';
  public static string ACCOUNT_TERRITORY_IS_DIFFRENT_FROM_OPPORTUNITY_CREATOR_TERRITORY = 'Account Territory is different from Opportunity creator territory';
  public static string RESTRICTOPPTYCREATIONBYOTMFROMDIFFRENTTERRITORY = 'restrictOpptyCreationByOTMFromDiffrentTerritory';
  public static string POPULATEENDCUSTOMERANDENDCUSTOMERLEGALENTITYFORDIRECTRECORDTYPE = 'populateEndCustomerAndEndCustomerLegalEntityForDirectRecordType';
  public static string SETOFFERSUBMITTEDTOCUSTOMERDATE= 'setOffer_Submitted_To_Customer_Date' ;
  public static string NOTIFYHSSERISKCOUNTRY= 'notifyHSSERiskCountry';
  public static string SENDEMAIL = 'sendEmail';
  public static string FREEZEANDUNFREEZEDOCS = 'freezeAndUnfreezeOpportunityOfferDocs';
  public static string RETURN_CONTENTDOCLINK = 'returnContentDocumentLinkForFreezing';
  public static string CREATE_DIRECT_SALES_OPPORTUNITY = 'Create Direct Sales Opportunity';
  public static string CREATE_INDIRECT_SALES_OPPORTUNITY = 'Create Indirect Sales Opportunity';
  public static string OFFERSUBMITTEDTOCUSTOMER ='Offer Submitted to Customer (Manual)';
  Public Static String DATALOADERPROFILE ='Data Loader Profile';
  Public Static String ClosedLost ='Closed/Lost';
  Public Static String ClosedWon ='Closed/Won';
  Public Static String Open ='Open';
  public static String populatePhaseStatusOnInsert = 'populatePhaseStatusOnInsert';
  public static String freezeRecordforSalesUserOnClosure = 'freezeRecordforSalesUserOnClosure';

  //req 758 email
  public static string EMAILSUBJECT = 'Please be informed that an Opportunity has passed Gate 3 in a High Risk Region';
  public static string BODY1= 'Dear HSSE Ops Team,';
  public static string BODY2 = 'Please be informed that a new proposal -';
  public static string BODY3 = ' has passed Gate 3 on date ';
  public static string BODY4 ='The project details are as follows: ' ;
  public static string BODY5 =  '1. Geographical Location of project is ';
  public static string BODY6 = '2. Sales Case Owner of proposal ' ;
  public static string BODY7 = ', Email Id is ';
  public static string BODY8 = '3. Project Execution Owner is ';
  public static string BODY9 = ', Email Id is ';
  public static string BODY10 = 'Not yet assigned';
  public static string BODY11 = '4. The Lead Business Group is ' ;
  public static string BODY12 = '5. The Prospect is ';
  public static string BODY13 = '6. The Customer Team is ' ;
  public static string NEWLINE = '\n' ;
  public static string LINK1 = '<a href="';
  public static string LINK3 =  '</a>';
  public static string LINK2 =  '/';
  public static string LINK4 = '"';
  public static string PROJECTEXECUTIONOWNER = 'CDM/Project Execution Owner';
  public static string APPROVED='Approved';
  public static string REJECTED = 'Rejected';
  public static string SUBMITTED_FOR_APPROVAL = 'Submitted For Approval';
  public static string LINEBREAK = '<br><br>' ;
  public static string URLPART3 = '/servlet/servlet.ImageServer?';
  public static string URLPART1 = '<html><body> <div style = "  height:750px; width : 400px ; border-color:#384480 ; margin-left: 75px">';
  public static string URLPART2 ='<img style = " margin-left: 75px;margin-right: auto" src="';
  public static string URLPART4 = 'id=';
  public static string URLPART5 = '&oid=';
  public static string URLPART6 ='">' ;
  public static string URLPART7 ='<hr style="height:3px; border-color:#384480 ; background-color:#384480"/>';
  public static string URLPART8 ='<p style="font-family:Arial font-size:12pt"> ';
  public static string URLPART9 =  '</p>';
  public static string URLPART10 ='  <hr style="height:3px; border-color:#384480 ; background-color:#384480"/>';
  public static string URLPART11 ='<img src="';
  public static string URLPART12 =' </div> </body>  </html>';
  public static string HEADER = 'Header';
  public static string FOOTER = 'Footer' ;
  public static string BOLD = '<b>';
  public static string ENDBOLD = '</b>';
  public static string COLON = ' : ';
  public static string DISCLAIMER1 = '<p style= "font-size:10pt"> This is a system generated email sent to because you are recording in Nokia'+
  'Networks Customer Master Data as either an approver or stakeholder in the Nokia Networks Sales Process.'+
  'If you believe you have received this email in error, please kindly forward this to the CRM OM support team who will endeavour to correct any mistake. '  ;
  public static string DISCLAIMER2 ='The contents of this email are intended for the named addressee only.'+
  'It contains information which may be confidential, legally privileged and protected by law.'+
  'Unauthorized use, disclosure or copying of it may be unlawful.';
  public static string DISCLAIMER3 ='If you have received this email in error please notify us immediately by email and'+
  ' then delete the original email from your system. We make every effort to keep our network free from'+
  'computer viruses. However, internet communications are not secure and therefore you do need'+
  'to verify that this email and any attachment(s) are free of viruses as we can take no responsibility'+
  'for any computer virus which might be transferred by way of this email </p>';

  //Sales Process: 955
  public static string OFFER_WARNING_MSG = 'OfferWarningMessage';
  public static string GET_OFFER_ID = 'getOfferId';
  public static string NO_LOA = 'No LoA';
  //D-1687
  public static string PHASE_STATUS_CLOSED = 'Closed';
  public static string PHASE_STATUS_CLOSED_NOT_WON = 'Closed(not won)';
  public static string MANUAL = 'Manual';
  //End Sales Process

  //Req::995
  Public Static String BATCH_OIF_SCHEDULE='Batch OIF Update-';
  //Sales Process: Req#946
  Public Static String GET_OIF_WARNING_MESSAGE = 'getOIFWarningMessage';
  //End Sales Process Req#946
  //Sales Process Req 1454
  Public Static String OPTY_TO_OIF_PROGRAM_FLAG = 'copyOpptyProgramFlagToOif';
  //SF Ticket 00003242: Sales Process
  Public Static String REFERENCE_OPPTY_ERROR = 'Reference Opportunity cannot be blank when Offer is active and G4/G5 bypass offer condition is G4 approved or contracted'; // Label Changed - SF Ticket 00956787
  //Requirement 2381: Sales Process
  Public Static String PTA_PRODUCT_ONLY_OFFER_NOT_SAME = 'PTA Signed on Opportunity and Product/Software Only on Offer should not be checked at the same time';

  Public Static String CREATE_DEMO = 'Create Demo'; //Pre-Sales:Sprint 6: Req#2171
  Public Static String CREATE_PRE_SALES_RISK_OPPORTUNITY = 'Create Pre-Sales Risk Opportunity'; //Pre-Sales:Sprint 6: Req#2171
  Public Static String CREATE_TRIAL = 'Create Trial'; //Pre-Sales:Sprint 6: Req#2171
  Public Static String CREATE_FOC = 'Create FoC'; //Pre-Sales:Sprint 6: Req#2171
  Public Static String UPDATERECORDTYPEWHENPRESALETYPEISOTHERTHANRSRO = 'updateRecordTypeWhenPreSaleTypeIsOtherThanRSRO'; //Pre-Sales:Sprint 6: Req#2171
  Public Static String TRIAL = 'Trial'; //Pre-Sales:Sprint 6: Req#2171
  Public Static String DEMO = 'Demo'; //Pre-Sales:Sprint 6: Req#2171
  Public Static String FOC = 'Free of Charge'; //Pre-Sales:Sprint 6: Req#2171
  Public Static String RISK_ORDER = 'Risk Order'; //Pre-Sales:Sprint 6: Req#2171
  Public Static String RISK_ORDER_ONLY = 'Risk Order Only'; //Pre-Sales:Sprint 6: Req#2171
  Public static String RISK_ORDER_WITH_SHIPMENT = 'Risk Order With Risk Shipment';
  Public Static String PREPARATION = 'Preparation';  //Pre-Sales:Sprint 6: Req#2171
  Public Static String IN_EXECUTION= 'In Execution'; //Pre-Sales:Sprint 6: Req#2171
  public static string OPPERROR ='You cannot change any value When In Execution stage except Decription/Justification'; //Pre-Sales:Sprint 6: Req#2171
  public static string OPP_OUTCOME_ERROR ='You cannot change any value When In Execution stage except Decription/Justification Outcome and Outcome Detail'; //Pre-Sales:Sprint 6: Req#2171
  public static string GETNOKIAPERIODNAME = 'getNokiaPeriodName'; //Pre-Sales:Sprint 6: Req#2171
  public static string OPPORTUNITYTRIGGERHELPER_PRESALES = 'OpportunityTriggerHelper_PreSales'; //Pre-Sales:Sprint 6: Req#2171
  public static string VALIDATEFIELDSARENOTEDITABLEINEXECUTIONSTAGE= 'validateFieldsAreNotEditableInExecutionStage'; //Pre-Sales:Sprint 6: Req#2171
  public static string POPULATEPARENTCURRENCYONPRESALES= 'populateParentCurrencyOnPreSales'; //Pre-Sales:Sprint 6: Req#2171

  Public Static String LOA_TECH_USER_FUNCTIONALITY = 'LoA Tech User Functionality'; //required when LoA file owner get updated with Global FIle Owner user.

  Public Static String ACTIVE = 'Active';
  Public Static String ACC_PROSPECT = 'Prospect';
  Public Static String ACC_CUSTOMER = 'Customer';
  Public Static String ACC_Logistic = 'Logistic Account';
  //IWA Sprint 7
  Public Static String NOTIFIED='Notified';
  Public Static String ASSIGNED='Assigned';
  Public Static String REASSIGNED='Reassigned';

  Public Static String SELECT_QUERY = 'SELECT';

  //Sales Process 1507:
  Public Static String CLONE_OPPORTUNITY = 'CloneOpportunity';
  Public Static String GET_CLONE_OPPTY = 'getCloneOpp';

  Public Static String EXECUTE_OPPTY = 'Execute (Start Delivery)';
  Public Static String HANDOVER_OPPTY = 'Handover (Prepare for Delivery)';
  //Sales Process 953:
  Public Static String COMPARE_UNWEIGHTED_VALUE_DEAL = 'compareUnweightedValueOnDeal';
  Public Static String DEAL_TRIGGER_HELPER = 'DealTriggerHelper';
  Public Static String DEAL_TRIGGER_HANDLER = 'DealTriggerHandler';

  Public Static String FILTER_MASTER_OPPTY = 'filterMasterOpportunityBasedOnRelatedList';
  Public Static String RESTRICTDUPLICATEMASTEROPTY = 'RestrictDupliateMasterOppty';
  //Sales Process: 1507
  Public Static String LEAD_BG_MN = 'MN';
  Public Static String LEAD_BG_NI = 'NI';
  Public Static String LEAD_BG_CNS = 'CNS';

  public static Boolean SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = false;
  public static String  NOTIFYOPPORTUNITYTEAMMEMBERS = 'NotifyOpportunityTeamMembers';
  public static String GETISAPPLICABLEFORPRESALESLIST = 'getIsApplicableForPreSalesList';
  public static String GETISAPPLICABLEFORPRESALESMAP = 'getIsApplicableForPreSalesMap';

  //Sales Process : 663
  Public Static String lookUp_Controller = 'lookUpController';
  Public Static String fetch_Opportunity = 'fetchOpportunity';
  //End of 663

  Public Static String DEMO_READONLY = 'Read Only Demo'; //Pre-Sales:Sprint 6: Req#2171
  Public Static String READ_ONLY_FOC = 'Read Only FoC'; //Pre-Sales:Sprint 6: Req#2171
  Public Static String READ_ONLY_PRE_SALES_RISK_OPPORTUNITY = 'Read Only Pre-Sales Risk Opportunity'; //Pre-Sales:Sprint 6: Req#2171
  Public Static String READ_ONLY_TRIAL = 'Read Only Trial'; //Pre-Sales:Sprint 6: Req#2171
  Public Static String DOUBLE_STARTQUOTE = ' " ' ;
  Public Static String DOUBLE_ENDQUOTE = ' "' ;
  Public Static String APPROVAL_STATEMENT = ' Opportunity is ';
  Public Static String TRIALTYPE = 'T';
  Public Static String DEMOTYPE = 'D';
  Public Static String FOCTYPE = 'F';
  Public Static String RISKORDERTYPE = 'R';
  Public Static String APPEND_DOUBLEZERO = '00';
  Public Static String APPEND_SINGLEZERO = '0';
  //Pre sales fields

  Public static String DATE_PO_EXPECTED='Date PO Expected';
  Public static String TOTAL_COST_OF_PRESALES='Total Cost of Pre-Sales Risk Opportunity in local currency';
  Public static String PRE_Lead_BG='Lead BG';
  Public static String  PRE_TOTAL_SALES='Total Sales Value of Opportunity in local currency';
  Public static String  PRE_TRAIL_STARTDATE='Trial/Demo Start Date';
  Public static String PRE_TRAIL_DURATION='Trial/Demo Duration';
  Public static String PRE_CUSTOMER_SW_REQ='Customer Specific SW R&D Required';
  Public static String PRE_SW_RD='SW R&D Justification/Explanation';
  Public static String PRE_FRAME='Frame Agreement in Place';
  Public static String PRE_SW_SALES='SW Adaption Sales';
  Public static String PRE_TRAIL_STATUS='Trial Agreement Status';
  Public static String PRE_IS_COST_APPROVER='Is Pre_Sales Cost approved in related Sales Opportunity?'; // Label Changed - SF Ticket 00956787
  Public static String PRE_IS_COST_REF='Is Cost Reflected in Latest Estimate';
  Public static String PRE_IS_REV='Is Revenue reflected in Latest Estimate';



  //Approval Center lightning component Req no: something
  Public static String UPDATE_G4_G5_APROVALDATE_FUNCTION='updateOffersOnG4OrG5ApprovalDateIsUpdated';
  Public static String GATE_G2 = 'G2';
  Public static String G2_Approval_Date = 'G2_Approval_Date__c';
  Public static String GATE_G3= 'G3';
  Public static String  G3_Approval_Date= 'G3_Approval_Date__c';
  Public static String GATE_G4= 'G4';
  Public static String G4_Approval_Date= 'G4_Approval_Date__c';
  Public static String GATE_G5= 'G5';
  Public static String G5_Approval_Date= 'G5_Approval_Date__c';
  Public static String GATE_G6= 'G6';
  Public static String G6_Approval_Date= 'G6_Approval_Date__c';
  Public static String NUMBER_FORMAT = 'number';
  Public static String DATE_FORMAT = '###,###,##0.00';
  Public static String  CURRENTLY_NO_GATE = 'Currently not in gate';
  Public static String FORWARD_SLASH = '/';
  Public static String REMOVE_PARA_TAG = '<[^>]+>';
  Public static String NO_APPROVAL_REQ= 'No Approval Request';
  Public static String  BasicApprovalDetailsMethod = 'basicApprovalDetails';
  Public static String GATES = 'Gates';
  Public static String VALIDATOR = 'Validator';
  Public static String APPROVER = 'Approver';
  Public static String COMMITTED_UPSELL='Committed Upsell';
  Public static String OPPORTUNITY_PARTNER_AGGREMENT='Opportunity within partner agreement w/o Offer Support';
  Public static String APPROVING_AS_APPROVER = ' Approving as Approver';
  Public static String APPROVING_AS_DELEGATE = ' Approving as Delegate';
  Public static String REQUEST_CLOSED  = ' Request is Closed';
  Public static String STAKEHOLDER_INFORMATION = 'Stakeholder for Information';

  //ACL Req no:1491
  Public static String LEAD_TRIGGER_HANDLER = 'Lead Trigger Handler';
  Public static String ACCOUNT_TRIGGER_HANDLER = 'Account Trigger Handler';
  Public static String ACCOUNT_TRIGGER_HELPER = 'Account Trigger Helper';
  Public static String ACCOUNT_TRIGGER_HANDLER_BEFORE_OP = 'beforeOperation Account';
  Public static String ACCOUNT_TRIGGER_HANDLER_RESTRICTENABLINGPARTNER = 'restrictEnablingPartner';
  Public static String LEAD_TRIGGER_HANDLER_BEFORE_OP = 'beforeOperation Lead';
  Public static String BEFORE_INSERT_OPERATION_ACC = 'beforeInsertOperation';
  Public static String BEFORE_UPDATE_OPERATION_ACC = 'beforeUpdateOperation';
  Public static String AFTER_INSERT_OPERATION_ACC = 'afterInsertOperation';
  Public static String AFTER_UPDATE_OPERATION_ACC = 'afterUpdateOperation';
  Public static String ON_AFTER_UPDATE_ACC = 'onAfterUpdate';
  Public static String ON_BEFORE_UPDATE_ACC = 'onBeforeUpdate';
  Public static String ON_BEFORE_INSERT_ACC = 'onBeforeInsert';

  Public static Boolean OPPORTUNITYTRIGGER_HELPER_VALIDATE=False;
  Public static Boolean OPPORTUNITYTRIGGER_HELPER_UPDATE_G4_G5=False;
  Public static Boolean OPPORTUNITYTRIGGER_CURRENCY_CHANGE=False;
  Public static boolean OPPORTUNITYTRIGGER_PROB_UPDATE_INLINE = False;
  Public static boolean OPPORTUNITYTRIGGER_POPULATE_SALES_OUTCOME = False;
  Public static boolean OPPORTUNITYTRIGGER_POPULATE_PHASESTATUS = False;
  Public static boolean OPPORTUNITYTRIGGER_FREEZE_RECORD = False;
  Public static boolean OPPORTUNITYTRIGGER_COMPARE_UNWEIGHTED_VALUE = False;
  Public static boolean OPPORTUNITYTRIGGER_FOLLOW_OPPTY = False;
  Public static boolean OPPORTUNITYTRIGGER_PROB_UPDATE = False;
  Public static boolean OPPORTUNITYTRIGGER_CHECK_LE_EMPTY = False;
  Public static boolean OPPORTUNITYTRIGGER_UPDATE_MASTER_OPPTY = False;
  Public static boolean OPPORTUNITYTRIGGER_RESTRICT_OPPTY_CREATION = False;
  Public static boolean OPPORTUNITYTRIGGER_POPULATE_END_CUSTOMER = False;
  Public static boolean OPPORTUNITYTRIGGER_NOTIFY_HSSE = False;
  Public static boolean OPPORTUNITYTRIGGER_SEND_EMAIL = False;
  Public static boolean OPPORTUNITYTRIGGER_VALIDATE = False;
  Public static boolean OPPORTUNITYTRIGGER_CHANGE_MASTER_OPPTY = False;
  Public static boolean OPPORTUNITYTRIGGER_UPDATE_ORG_LEVEL = False;
  Public static boolean OPPORTUNITYTRIGGER_OFFER_PRICE_CHANGE = False;
  Public static boolean OPPORTUNITYTRIGGER_DECISIONDATE_UPDATE=False;
  Public static boolean OPPORTUNITYTRIGGER_CURRENCY_UPDATE=False;
  Public static boolean OPPORTUNITY_APPROVAL=false;
  Public static boolean OPPORTUNITY_DELETE_ALLOCATION=false;
  public static boolean G5_CONTRACT_APPROVAL = false;  //Req-3062

  //Req 2918: Sales Process
  Public static boolean OPPORTUNITYTRIGGER_CHATTER_POST=False;
  Public static String CREATE_CHATTER_POST = 'createChatterPost';
  Public static String TEXT_ON_CHATTER_POST = ' Phase Status changed from ';
  public static String TEXT_CLOSED = ' to Closed(not won) ';
  Public static String TEXT_BY = 'by ';
  Public static String PHASE_STATUS = 'Closed(not won)';
  public static String TEXT_OPPTY = ' Opportunity-';

  //Req 2558: Sales Process
  public static string BATCH_TO_UPDATE_ORG_LEVEL = 'Batch_UpdateOrgLevelOnOpptyFromAcc';
  public static string INTERFACE_TYPE_ACC_UPDATE = 'Account Upadet due to Organisation Level Update';
  public static string INTERFACE_TYPE_ACC = 'Organisation Level Change';
  public static string UPDATE_VALUE_ACC = 'Account Update';

  //Req 2313 Sales Process(Sprint 8)
  //public static string restrict_Direct_Opty_Creation ='restrictDirectOptyCreation';
  //public static boolean restrict_Direct_Opty_Creation_Flag = false;

  //Req 2700 Sales Process(Sprint 8)
  Public Static String COMPLETED_OPPTY='Completed';
  Public static String RESTRICT_REFERENCE_OPPTY = 'restrictReferenceOppty';
  Public static BOOLEAN RESTRICT_REFERENCE_OPPTY_FLAG = false ;

  //Req 3158 sales process(sprint 9)
  Public static String CHATTER_POST_TO_ACCOUNT_MANAGER = 'chatterPostToAccountManager';
  Public static BOOLEAN CHATTER_POST_TO_ACCOUNT_MANAGER_FLAG = false ;
  Public static String Lead_BG = 'Opportunity Lead BG: ';
  Public static String Lead_BU = 'Opportunity Lead BU: ';
  Public static String Supporting_BGs = 'Opportunity Supporting BGs: ';
  Public static String Supporting_BUs = 'Opportunity Supporting BUs: ';
  Public static String OIF_BGs = 'OIF BGs: ';
  Public static String OIF_BUs = 'OIF BUs: ';
  Public static String Unweighted_Amount = 'Unweighted Amount: ';
  Public static String Account_Name = 'Customer: ';
  Public static String Curly_Braces_Start = '{';
  Public static String Curly_Braces_End = '}';
  Public static String New_Black_Space = '&nbsp;';
  Public static String BackSlash = '/';
  Public static String Oppty_Trigger_Handler = 'OpportunityTriggerhandler';
  Public static String For_Oppty = ' for the Opportunity';
  Public static String Check_And_Update = 'Kindly check and update.';

  Public static String LOCK_DEAL_DELETION = 'lockDealDeletion';
  Public static String Lock_Master_Oppty_Change_On_Deal = 'lockMasterOpptyChangeOnDeal';

  //Req 2560 sales process(sprint 9)
  Public static String LOCK_PRESALES_OPPTY = 'lockPreSalesOppty';
  Public static BOOLEAN LOCK_PRESALES_OPPTY_FLAG = false ;

  Public Static String FALU='fALU';
  Public Static String FNOK='fNOK';
  Public Static String  DELETE_ALLOCATION_LINES ='DeleteAllocationLine';
  Public Static String populateG5ContractApprovalDate = 'populateG5ContractApprovalDate';
  public static Boolean STOP_TRIGGER_USER_ON_AFTERUPDATE = false;
  public static Boolean STOP_TRIGGER_USER_ON_BEFOERUPDATE = false;
  public static Boolean STOP_TRIGGER_USER_ON_BEFOREINSERT = false;

  //Req 2605 Sales Process(Sprint 8)
  Public Static String UPDATE_DEAL_CURRENCY='UpdateDealCurrency';
  Public Static String FORMAT_CURRENCY='formatCurrency';
  Public Static String FRAMED_DEAL='Framed Deal';
  Public Static String ERROR_TEXT='This is an error';
  Public Static String SUM_AMT='sumAmount';

  //Req.#2411
  Public Static String OFFER_ACTIVATION_HANDLER='OfferActivationHandler';

  //Req.#2790
  Public Static String FUNCTION_LOA_BYPASS_OFFER_CONDITION_VALIDATION = 'validateLoABypassOfferConditionFieldValue()';
  Public Static String PICKLIST_VALUE_AUTHORIZED_FOR_PRICING_MANAGER = 'Authorized for Pricing Manager';
  Public Static String OFFER_OPPTY_TEAM_ROLE_PRICING_MANAGER = 'Pricing Manager';
  Public Static String FUNCTION_VALIDATE_OFFER_FIELD_FOR_PRICING_MANAGER ='validateOfferFieldEditForPricingManager';

  //Req. #2661,#2662,#2664,#2768
  Public Static String METHOD_RETURN_APPROVAL_STATUS_INFO = 'returnApprovalStatusInfo';
  Public Static String SYSTEM_ADMIN_PROFILEID = 'System Admin Profile Id';
  Public Static String SYSTEM_INFO_COMMENT  = 'comments';
  Public Static String USER_COMMENT  = 'User comments - ';
  Public Static String APPROVAL_COMMENT  = 'Approver comments - ';
  Public Static String YEAT_FIRSTTWO_DIGITS = '20';
  Public Static String COLEN = ':';
  Public Static String METHOD_REMOVE_COMMENTS_SYS_INFO = 'removeCommentsSystemInfo';
  Public Static String VALIDATING_AS_VALIDATOR = 'Validator as Validator';
  Public Static String VALIDATING_AS_DELEGATE = 'Validator as Delegate';
  Public Static String STATUS_NOT_SUBMITTED = 'Not Submitted';
  Public Static String STATUS_NOTIFIED = 'Notified';
  Public Static String STATUS_NO_APPROVAL_REC = 'No Approval Record';
  Public Static String ADDING_COMMENT_AS_STAKEHOLDER = 'Adding comment as Stakeholder';
  Public Static String ADDING_COMMENT_AS_STAKEHOLDER_DELEGATE = 'Adding comment as Delegate';
  Public Static String STAKEHOLDER_ADD_CMT_BTN = 'stakeHolderAddCmtBtn';
  Public Static String VALIDATED_PICKLIST_VALUE = 'Validated';
  Public Static String REJECTED_PICKLIST_VALUE = 'Rejected';
  Public Static String USD='USD';
  public static string ORDERINTAKE_ALLOCATION_CREATE='OrderIntakeAllocationCreation';
  public static string OIF_ALLOCATION_CREATE='OIFAlloctionCreate';
  public static string ALLOCATION_CREATE='AlloctionCreate';
  //Req. 2359
  public static string METHOD_POPULATEACCOUNT = 'populateParentAccount';
  public static string METHOD_CONVERTIONUPDATE = 'convertionUpdatePreSales';
  public static string METHOD_POPULATECURRENCY = 'populateParentCurrency';
  public static string METHOD_POPULATEPRESALESOPPTYNUMBER = 'populatePreSalesOpportunityNumber';
  Public static string ALM_ADD_ERROR = 'Please consider adding additional team members to the Opportunity Team.';

  Public static string BATCH_CURRENCY_CHANGE='BatchCurrenychange';
  Public static string DELEGATE_HANDLER='DelegateHandler';
  Public static string DELEGATE_HELPER='DelegateHelper';
  Public static string DELEGATE_UPDATE='DelegateUpdate';
  Public static string USER_NSA_CHECK='UserNSACheck';

  //PreSales Req 3026
  Public static string PSRCLONEOPPORTUNITY='PSR_CloneOpportunity';
  Public static string G3_Approved='Approved G2,Approved G3';
  Public static string PENDING_APPROVAL='Pending Approval';
  Public Static String  APPROVAL_CANCELLED='Approval Cancelled for Gate';
  Public Static String BLANKET_APPROVAL_CANCELLED='Blanket Approval Request has been Cancelled';


  Public Static String RECALL_PSR_NOTIFICATION='Recall_Presales_Notification';
  Public Static String RECALL_NOTIFICATION='RecallNotification';
  Public Static String CHATTER_POST_TO_STAKEHOLDER='ChatterPostToStakeHolders';
  Public Static String CLOSED_OPPTY_POST='ClosedOpptyStatustoTeam';
  Public Static String OPPTY_CLOSED= 'Opportunity has been closed at Gate';
  Public Static String YOU_CANNOT_CHANGE_PRE_SALES_OPPORTUNITIES_CURRENCY = 'You cannot change Pre-Sales Opportunity\'s currency';
  Public Static String YOUR_SINGLECRM_SUPPORT_TEAM = '\n\n Your SingleCRM Support Team';
  Public Static String KIND_REGARDS = '\n\n Kind Regards,' ;
  Public Static String OPPORTUNITY_LINK = '\n Opportunity Link:';
  Public Static String HAS_BEEN = ' has been ';
  Public Static String THE_PRE_SALES_RISK_OPPORTUNITY = '\n The Pre-Sales Risk Opportunity ';
  Public Static String DEAR = 'Dear ';
  Public Static String DOT = '.';
  Public Static String ONE = '1';
  Public Static String CLONEOPTYNAME = '_Clone';
  Public Static String STAGECLOSED = ' Closed';
  public static String REFERENCEOPTY = ' PSR_Reference_Opportunity__r.stagename ,';
  public static String SOQLFROM = ' FROM ';
  public static String SOQLWHERE = ' WHERE Id =  \'';
  public static String SOQLLIMIT = '\'  LIMIT 1';
  public static String CUSTOMER_SUPPLY_MANAGER ='Customer Supply Manager';
  public static String OFFER_CONTROL='Offer Controller';
  Public Static Boolean OPPORTUNITY_CHATTER_CHECK=false;
  Public Static Boolean OPPORTUNITY_RECALL_CHECK=false;
  Public Static Boolean OPPORTUNITY_PSR_RECALL_CHECK=false;
  Public Static Boolean OPPORTUNITY_PSR_stakeHolder_CHECK=false;
  Public Static Boolean OPPORTUNITY_CLOSE_CHECK=false;
  public static String OPPTY_CLOSE_IDENTIFY_PHASE='Opportunity has been closed at Identify Phase';
  public static String NF_APPROVALREQUEST='NF_ApprovalRequestClass';  
  public static String PTA_HANDOVER='PTA (PROJECT TARGET AGREEMENT) HANDOVER TO DELIVERY/OPERATIONS';
  public static String G5_APPROVAL_TECH= 'Approved G2,Approved G3,Approved G4,Approved G5';

  //Sales process
  public static String SALES_OUTCOME = 'Sales_Outcome__c';
  public static String SALES_OUTCOME_REASON = 'Sales_Outcome_Reason__c';
  public static String SECOND_REASON = 'Second_Reason__c';
  public static String THIRD_REASON = 'Third_Reason__c';
  public static String NONE = '----None----';
  public static string OFFER_IN_PROGRESS = 'Offer in Progress';

  public static String PRVIEW_APPROVAL_CONTROLLER = 'APTSCU_PreviewApprovalsController';
  public static String DISPLAY_SALES_OUTCOMEREASON = 'getDisplaySalesoutcomReason';
  public static String GET_DEPEDENT_VALUES= 'getDependentValues';
  public static String GET_FIRST_REASON = 'getfirstReasons';
  public static String GET_SECOND_REASON = 'getSecondResons';
  public static String GET_THIRD_REASON = 'getThirdReasons';
  public static String GET_DISPLAY_PROBABILITY = 'getDisplayProbability';
  public static String GET_PROBABILITY = 'getProbability';
  public static String UPDATE_PROBABILITY_PER = 'updateProbabilityPercentage';
  public static String UPDATE_SALES_OUTCOME_REASON = 'updateOpportunityReasons';
  public static String TWENTY= '20';
  public static String FREASON ='Commercial';
  public static String SREASON ='Mistake/Redundant/Merged';
  public static String TREASON ='Quality';
  public static String RETURN_SUCCESS ='success';

  public static Boolean STAKE_HOLDER_FLAG=false;
  Public Static Boolean OFFER_BOOLEAN_CHECK=false;
  public static String NF_G4SUBMISSION_REQUEST= 'NF_G4SubmissionRequest';
  public static String NF_TL_UPDATE_REQUESTRCODE='NF_TL_UpdateRequestRCode';
  public static String INSERT_STAKEHOLDER_REC='InsertStakeholderRec';


  public static Boolean NEW_ACCOUNT=false;
  public static String UPDATEOPPORTUNITYBOMINSERT = 'updateOpportunityBOMInsert'; //presales : Sprint 10: Req-2766
  public static String UPDATEOPPORTUNITYBOMDELETE = 'updateOpportunityBOMInsert'; //presales : Sprint 10: Req-2766
  public static String COSTCALCULATIONWHENESTIMATEDCOSTCHECKED = 'costCalculationWhenEstimatedCostChecked'; //Pre Sales Req - 3097
  public static String WIN_POST_LINE1='Dear Gate Participants,';
  public static String WIN_POST_LINE2='we are pleased to inform you that this opportunity* has been declared won.';
  public static String WIN_POST_LINE3='Be aware that' ; //Thank you for your participation!'; //02288601
  public static String WIN_POST_LINE4=  'G6 Bypass (No Execute needed) =' ;  //'Nokia Salesforce CRM'; //02288601
  public static String WIN_POST_LINE5 = 'Please act accordingly to ensure a successful delivery.'; //02288601
  public static String WIN_POST_LINE6 = 'Thank you!' ;//02288601
  public static String WIN_DECLARATION_NOTIFICATION='WindeclarationNotification';
  public static String NOTIFY_OFFER_CONTROLER='NotifyOfferController';


  //ACL Sprint 8
  public static String LE_RECORD_TYPE = 'Legal Entity';
  public static String BUSSINESS_TYPE = 'Business_Type__c';
  public static String CONTRACT_SIGNING = 'Contract_Signing_Entity__c';





  //Upsell Opportunity Sprint 9\
  public static String UPSELL_OPPORTUNITY_UTILITY_CLASS = 'UpsellOpportunityUtility';
  public static String METHOD_TO_CREATE_UPSELL_OPPORTUNITY = 'toCreateUpsellOpportunity';
  public static String METHOD_UPSELL_DEAL_CREATION = 'upsellDealCreation - ';
  public static String METHOD_CREATE_UPSELL_OPPTY = 'createUpsellOppty';
  public static String METHOD_CREATE_UPSELL_OPPTY_RECORD = 'createUpsellOpptyRecord';
  public static String METHOD_UPDATE_UPSELL_CONTAINER_REC = 'updateUpsellContainerRec';
  public static String METHOD_CREATE_OIF_FOR_UPSELL_OPP = 'createOIFforUpsellOpp';
  public static String METHOD_RETRUN_CONSTRUCTED_OIF_LIST = 'returnConstructedOIFList';
  public static String METHOD_SEND_CHATTER_TO_UPSELL_OPP_OWNER = 'sendChatterToUpsellOppOwner';
  public static String UPSELL_DEAL = 'Upsell Deal';
  public static String UPSELL_OIF_REV_EXCEP = 'UpsellOIF_RevRecException';
  public static String UPSIDE = 'Upside';
  public static String SECURE = 'Secure';
  public static String UPSELL_OPP_CHATTER_HEADER = 'The following Upsell opportunities are automatically created for';
  public static String PSR_WARNINGNOALM = 'PSR_WarningNoALM';
  public static String GETPSRCLONE = 'getPSRClone';
  public static String OPPTYNOALMERRORMSG = 'opptyNoALMErrorMessage';
  public static String PRE_SALES_RISK_BOM_BOQ= 'Pre-Sales Risk BoM/BoQ';
  Public Static String PRESALESNULL = 'null';
  Public Static String HAS_BEEN_SET_TO_PREP_MSG= ' has been reset to Preparation';
  Public Static String GAP = ' - ';
  Public Static String FORWARDSLASH = '/';
  Public Static String PRESALES_UPLOAD_FILE_ERROR = 'go to the related tab and attach a Pre-Sales Risk BoM/BoQ document to the \'Files\' section' ;

  //Defect D-4025 LoA/Doc
  Public Static String WARNING_MESSAGE_ON_DELETING_LOA_TEMPLATE = 'Sorry you are unauthorised to delete the document' ; // Label Changed - SF Ticket 00956787
  Public Static String RESTRICTSAMETEAMROLE= 'restrictSameTeamandAdditionalTeamRole';

  //People Stream Release 4
  public static String ACCOUNT_TERRITORY_MOVEMENT = 'accountTerritoryMovement';
  public static String USER_HELPER = 'UserHelper';
  public static String USER_HANDLER = 'UserHandler';
  public static String UPDATE_NSA_MOD_USER = 'updateNSA_Mod';
  public static String UPDATE_DEACTIVATION_DATE = 'updateDeactivationDate';
  public static String ADD_TO_KEY_USER_GROUP = 'AddtoKeyUserGroup';
  public static String UPDATE_FEDERATION_ID = 'updateFederationId';
  public static String CURRENCY_ISO_CODE = 'CurrencyIsoCode';
  public static String XSD = 'xsd';
  public static String XSI = 'xsi';
  public static String START_PROCESS = 'StartProcess';
  public static String POST = 'POST';
  public static String OUTBOUND = 'Outbound';
  public static String PROSPECT_CREATION_INTERFACE = 'Prospect Creation Interface';
  public static String PROSPECT_CREATION_CALLOUT = 'ProspectCreationCallout';
  public static String CREATE_BULK_PROSPECT = 'createbulkProspect';
  public static String USER ='User';
  public static String QUEUE='Queue';
  public static String NOTIFY_TO_USER_APPROVAL='Notify Users for Approval';
  public static String FETCH_LOOKUP_VAL='fetchLookUpValues';
  public static String CHANGE_DEFAULT_LE='ChangeDefaultLE';
  public static String DO_CHANGES='doChanges';
  public static String VALIDATE_LE_DEAVTIVATE='validateLEDeactivation';
  public static String CREATE_PROSPECT_START_PROCESS='nsnComScmdCreateprospectsfstartproces';
  public static String CREATE_OPPTY_APEX_CTLR='CreateOpportunityApexCtlr';
  public static String GET_CAMPAIGN='getCampaign';
  public static String SAVE_OPPTY_WITH_CONTACT='saveOpportunityWithContact';
  public static String SAVE_INOPPTY_WITH_CONTACT='saveIndirectOpportunityWithContact';
  public static String GET_ALL_CURRENCY_VAL='getAllCurrencyValues';
  public static String GET_ALL_OPP_TYPES_VAL='getAllOppTypesValues';
  public static String GET_ALL_CONTRACT_SIGNING_VAL='getAllContractSigningValues';
  public static String CALLOUT_CUSTOM_EXCEPTION='Can not make more than 100 callout for Prospect in 1 Transaction';
  public static String REUSABLE_CUSTOM_LOOKUP_CTLR='reusableCustomLookUpController';
  public static String CREATE_PROSPECT_CREATE_REQUEST='CreateProspectCreateRequest';
  public static String CREATE_REQUEST='createRequest';
  public static String SELECT_ID_NAME_ACCNO='select id, Name, AccountNumber from ';
  public static String CUSTOM_LOOKUP_QUERY=' where Name LIKE: searchKey and recordtype.name <> \'Customer\' AND Active__c = true order by AccountNumber ASC LIMIT 10';
  public static String CONTACT_TRIGGER_HELPER='ContactTriggerHelper';
  public static String VALIDATE_AND_SEND_CONTACT='validateAndSendContact';
  public static String VALIDATE_AND_SEND_CONTACT_FOR_UPDATE='validateAndSendContactforUpdate';
  public static String VALIDATE_BLACKLISTED_EMAIL_DOMAINS='validateBlacklistedMailDomains';
  public static String NSN_TEST_CLASS='nsnComScmdCreateprospectsfstartTest';
  public static String NSN_TEST_METHOD='nsnComScmdCreateprospectsfTest';
  public static String ASC_TEST_METHOD='AscNsnComScmdCreateprospectsfstartprocesTest';
  public static String  OIF_COMPETITOR_CHECK='Request that you add at least one competitor to the opportunity, indicate “primary” competitor if known.' ;


  //D-3996 LoA release 4
  public static String PICKLIST_VALUE_NO = 'No';
  public static String PICKLIST_VALUE_YES = 'Yes';

  public static String  METHOD_DELETE_RELATED_DOC = 'deleteRelatedDocument';
  public static String  METHOD_UNDELETE_RELATED_DOC = 'undeleteRelatedDocument';
  public static String  FILE_DELETE_ERROR_MESSAGE = 'Sorry you are unauthorised to delete this document';

  public static String  SIMPLE_DEAL = 'Simple Deal';

  //LoA Upsell Chatter post
  public static String PARENT_OPP_OWNER = 'Parent Opportunity Owner : ';
  public static String NOTE = 'Note : If Committed Upsell opportunity has Business Line = Emerging Business, LTE-A or LTE-B, please validate the appropriate BL within the OIF object.  Default BL’s (selected by the system) may not be correct.';
  public static String AFTER_UPDATE= 'After Update';

  //Sales Process SF00007566
  public static String Get_Unweighted_Amount = 'getUnweightedAmount';
  public static String Remove_Unwanted_Value = '__';
  Public Static String MASS_UPDATE='MassUpdate On OIF';

  Public Static String OPP_LOST_TO_COMPETITOR='Lost to Competitor';
  Public Static String  CANCEL_BY_CUSTOMER='Cancelled by Customer';
  Public Static String WITHDRAWN_BY_NOKIA='Withdrawn by Nokia';
  Public Static String OPP_OBSOLETE='Obsolete';
  Public Static String EXCLUDED='Excluded';
  Public Static String TEAM_ROLE='Partner';
  Public Static Boolean OIF_ERROR_CHECK=False;

  //Req 3217
  public static string Populate_Reasons= 'populateReasons';

  // Req :- 3353
  public static Boolean RUN_OPPORTUNITYTEAM_TRIGGER_ON_NSACompliantAcc= false;
  public static String CHECK_NSA_COMPLIENT_ACCOUNT = 'CheckNSACompliantAccount';


  public static String  MISSING_G4_SUBMISSION='Missing Offer Submission';

  public static String  CLOSE_THE_G4_SUBMISSION_TASK='CloseTheG4SubmissionTask';
  public static String PRESALESRISKOPPORTUNITY = 'Pre-Sales Risk Opportunity';
  public static String PRESALESRISKOPPORTUNITY_READONLY= 'Pre-Sales Risk Opportunity (read only)';

  //sales process Req#3791
  public static Integer DEFAULT_PROBABILITY= 50;

  //Sales Process Req#3793
  public static String Direct= 'Direct';
  public static String Indirect= 'Indirect';
  public static String PSRGATECLASSIFICATION = 'psrGateClassificationAllocation';

  //LoA #3720
  public static String Upsell_Without_OppId = 'Upsell declaration without Opportunity ID';
  public static String Upsell_With_Invalid_OppId = 'Upsell declaration with Opportunity ID not existing in sCRM';
  public static String Upsell_With_Parent_OppId = 'Upsell declaration with Opportunity ID being the Parent Opportunity number';
  public static String Reason_For_AutoUpsell = 'Reasons for automatic creation:';
  Public Static Boolean UPDATE_VALIDATOR_REQUEST_STATUS=false;
  Public Static Boolean  NSA_CHECK=False;

  //Sales Process Req#3540
  public static string Freeze_Account_Name= 'freezeAccountName';

  //Sales Process Req#3793
  public static String Check_Read_Only = 'Read Only';

  // Req.: #LoA req.#3845
  public static string ERROR_FOR_CUSTOMER_COMPETITIVE_SITUATION_FIELD = 'Customer and Competitive Situation cannot be edited after LoA data is uploaded';
  public static string ERROR_OFFER_DESCRIPTION_FIELD = 'Offer Description cannot be edited after LoA data is uploaded';
  public static string ERROR_APPROVAL_RECOMMENDATION_FIELD = 'Approval Recommendation cannot be edited after LoA data is uploaded';

  //DefectD-5068
  public static string LIGHTNING_CMP_RESTRICTED_PROFILEID = 'LightningCmpRestrictedProfileId';

  //Requirement 3775
  public static boolean isSearchAndAddEndCustomer = false;

  //Sprint 12 - D-5240
  public static string LOA_Level_A_Plus = 'A+';

  //People Stream Release 5
  public static String OBJECT_END_CUSTOMER = 'End_Customer__c';
  public static String ISO_COUNTRY_CODES = 'ISO_Country_Codes__c';
  public static String PURCHASING_ROLE = 'Purchasing_Role__c';
  public static String ACCOUNT_ROLE = 'Account_Role__c';
  public static String SET_NAME_SPACE = 'setNamespace';
  public static String BUSINESS_USER = 'Business User';
  public static String NF_APPROVAL_REQUEST_TRIGGER = 'NF_ApprovalRequestTrigger';
  public static String AFTER_UPDATE_OPP = 'afterUpdateOPP';
  public static String PARENT_ID = 'ParentId';
  public static String CONTENT_TYPE = 'Content-Type';
  public static String TEXT_XML = 'text/xml';
  public static String QUERY = 'select Id,End_Customer__c,End_Customer_LE__c,End_Customer_LE__r.parentId from opportunity where End_Customer_LE__r.parentId<>NULL and End_Customer__c=NULL and End_Customer_LE__c<>NULL and End_Customer_LE__r.lastmodifieddate=TODAY and recordtypeId=:leRecordTypeId';
  public static String OPPORTUNITY_END_CUSTOMER_UPDATE = 'Opportunity End Customer Update';
  public static String SUCCESSFULLY_UPDATED = 'Successfully Updated';
  public static String CONTACT_TRIGGER_HANDLER='ContactTriggerHandler';
  public static String CONTACT_TRIGGER_HANDLER_BEFORE_OP = 'beforeOperation Contact';
  public static String POPULATE_END_CUST = 'populateEndCustomer';
  public static Integer NUMBER_SEVEN = 7;
  public static String NEW_BLANK_SPACE = '&nbsp;';
  public static String METHOD_ALLOWSUBMITFORAPPROVALS = 'allowSubmitForApprovals';
  public static String METHOD_GETDOCIDANDSOBJECTIDMAP = 'getDocIdAndsObjectIdMap';
  public static String METHOD_COLLECTDOCACCIDS = 'collectDocumentAccountIds';
  public static String METHOD_COLLECTCNTDOCANDCOLLABORATORGRP = 'collectContentDocIdAndCollaboratorGroup';
  public static String  METHOD_CREATECONTENTDOCUMENTLINK = 'createContentDocumentlink';
  public static String THIS_IS_AN_ERROR = 'This is an error';
  public static String OFFER_NUMBER_PREDECESSER1 = '.0';
  public static String OFFER_NUMBER_PREDECESSER2 = '.01';
  public static String METHOD_RETURNOFFERTEAMINSTANCE = 'returnOfferTeamInstance';
  public static String CANCELLED = 'Cancelled';
  public static String APPROVAL_COMPLETION_DAYS = 'ApprovalCompletionDays';

  //sales process sprint 12 'validateRefOpptyAndPTASigned' method Optimized
  //public static String Validate_Ref_Oppty_And_PTA_Signed = 'validateRefOpptyAndPTASigned';

  //CMDPack4 Scheduler & Batch
  public static String SCH_USERTERRITORY_REMOVAL_INTERVAL = 'Sch_UserTerritoryRemoval Run Interval';
  public static String TIME_DATE_FORMAT= 'MM/dd/yyyy hh:mm:ss.SSS a' ;
  public static String SCHEDULER_DELETE_FILE_SHARING = 'Scheduler_DeleteFIleSharingOnCMDPack4_Execute';
  public static String CMD_LAST_BATCH_PROCESSED_TIME = 'CMD_LastBatchProcessedTime';
  public static String METHOD_BATCH_CMD_QUERY_LOCATOR = 'Batch_DeleteFIleSharingOnCMDPack4_QueryLocator';
  public static String METHOD_BATCH_CMD_EXECUTE = 'Execute';
  public static String METHOD_BATCH_CMD_UPDATE_NXT_BATCH =  'updateNextBatchEntryTime';
  public static String METHOD_BATCH_CMD_USER_REMOVE = 'userToBeRemovedFromGroup';
  public static String METHOD_BATCH_CMD_INPUT_CMD_DATA  = 'inputCMDData';
  public static String CMD_BATCH_SIZE = 'Collob_GrpMem_Removal_BatchSize';

  //CPQ R3 Sprint 8 Req. #4161
  public static String EUR_CURRENCY_CODE = 'EUR';
  public static Integer VALUE_ONE = 1;
  public static String DIRECT_QUOTE_TYPE = 'Direct CPQ';
  public static String INDIRECT_QUOTE_TYPE = 'Indirect CPQ';
  // Req 4159
  public static Boolean ALLOW_BEFOREUPDATE_QUOTE_PROPOSAL_TRIGGER = true;
  public static String DISPLAY_ERROR_CANCEL_ACTION_ONDIRECTQUOTE = 'You are only allowed to cancel quotes in approval stage \'Approved\' or \'Accepted\'';
  public static String DISPLAY_ERROR_RECALL_ACTION_ONDIRECTQUOTE = 'A quote can just be recalled within \'In Review\' approval stage';
  //Req 4182
  public static String LOA_BYPASS_LEVEL = 'LoA Bypass';

  //Req 4215
  public static String OIF_Value_Validation = 'OIFValueValidation';
  public static String Opportunity_c= 'Opportunity__c';
  //REQ : 3856
  public static String OFFER_ERROR_MSG = 'You cannot update the Approval Scope once the LoA data has been uploaded';
  //REQ : 4185
  public static String NEEDSREPRICEQUOTEREPRICEPRICELIST= 'NeedsRepriceQuoteRepricePriceList';
  public static String UPDATEQUOTES= 'updateQuotes';


  //EPT_productuploadscontroller
  public static String FINALIZED = 'Finalized';
  public static String SAVED = 'Saved';
  public static String SOURCE = 'EPT';
  public static String WAVELITESOURCE = 'Wavelite'; //RG:8-8-2019 added for Req #6428
  public static String PORTFOLIO = 'Optics';
  public static String SMSTOOL = 'SMS TOOL'; //RG:8-8-2019 added for Req #6428
  public static String NSPTOOL = 'NSP'; //RG:8-8-2019 added for Req #6428
  public static String ENVIRONMENT = 'PRM';
  public static String EXTSMALL = 'csv';
  public static String EXTCAPS = 'CSV';
  public static String SEMICOLONMM = ';';
  public static String IGNORECASE = 'Acronym';
  public static String DOUBLEINVERTEDCOMMAS = '"';
  public static String INVERTEDCOMMA = '",';
  public static String COMMAINVERTED = ',"';
  public static String COMMAS = ',';
  public static String NOTHING = '';
  public static String PORTFOLIO2 = 'IP Routing';
  public static String NULLWORD = 'null';
  public static String COMMANULL = ',null,';
  public static String SITEQUANTITY = 'EPT_Site_Quantity__c';
  public static String SITE = 'EPT_Sites__c';
  public static String SOURCEFIELD = 'Source__c';
  public static String QUANTITYMODIFIABLE = 'Apttus_Config2__IsQuantityModifiable__c';
  public static String PRODUCTVERSION = 'Apttus_Config2__ProductVersion__c';
  public static String PROPOSALID = 'id';
  public static String ENTER = '\n';
  public static String PRODUCTCODE = 'XX';
  public static String PRODUCTCODEAA = 'AA';
  public static String APEXMESSAGE1 = 'Products loaded successfully..';
  public static String APEXMESSAGE2 = 'No valid Products';
  public static String MESSAGE1 = 'Following products are not available for shopping: ';
  public static String FULLSTOP = '.';
  public static String APEXMESSAGE3 = 'File type should be csv type';
  public static String APEXMESSAGE4 = 'CSV File Error';
  public static String APEXMESSAGE5 = 'No File Selected';
  public static String APEXMESSAGE6 = 'Products Upload Error';
  public static String APEXMESSAGE7 = 'This action is not available the portfolio selected';
  public static String APEXMESSAGE8 = 'Updation Error';
  public static String APEXMESSAGE9 = 'Product loaded....';
  public static String BREAKLINE = '<br/>';
  public static String ERROR_ST = 'Error occurred';
  public static String URLLINK1 = '/apex/Apttus_QPConfig__ProposalConfiguration?id=';
  public static String URLLINK2 = '&flow=NewUIPartner';
  public static String URLLINK3 = '/';


  //EditSitePopController
  public static String OPTION = 'Option';
  public static String PROVICE = 'Product/Service';
  public static String DOUBLEZERO = '.00';
  public static String SINGLEZERO = '0';
  public static String MINUSNONE = '-None-';
  public static String MINUSONE = '-1';
  public static String REQUESTID = 'configRequestId';
  public static String AMPREQUESTID = '&configRequestId=';
  public static String CONFIGID = '/apex/Apttus_Config2__Cart?id=';
  public static String SELECTQUERY = 'SELECT ';
  public static String COMMASPACE = ', ';
  public static String QUERYID = 'Id, Name, NokiaCPQ_Opportunity_Site__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c,Apttus_Config2__ProductId__c,Apttus_Config2__ConfigurationId__c FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c =: '+ 'currentRecordId' + ' AND Apttus_Config2__LineType__c =: lineItemType' + ' AND Apttus_Config2__ChargeType__c =: chargeTypeSet' + ' AND Source__c !=: lineItemsourceType ';
  //RG:8-8-2019 added for Req #6428 (AND Source__c !=: lineItemWavelitesource)


  //NokiaCPQ_Validate_Quote_Ctrlr
  public static String ERRORVK = 'Product Configuration Not present';
  public static String ERRORHP = 'Please finalize the cart';
  public static String ERRORHP1 = 'Please reprice the quote';
  public static String ERRORJB = 'The Quote cannot be approved. Please contact your Partner Sales Manager.';
  public static String ERRORRS = 'The Quote cannot be approved as the Opportunity has passed G5.1';
  public static String ERRORABD = 'The Quote cannot be validated as it contains products that are no longer available for purchase. Please go to the Cart to remove these items:';
  public static String ERRORBM = 'Some products contained in this quote have been updated since it was created. Please check and finalise your quote again.';
  public static String ERRORMS = 'It is possible that prices or conditions have changed since this quote was created. Please return and re-price the quote to update to the latest prices.';
  public static String ERRORSS = 'Quote cannot be validated. Please contact your Partner Sales Manager (Invalid Offer condition).';
  public static String ERRORJA = 'Quote cannot be validated against the Active Offer. Please create a new Active Offer with the required conditions.';
  //RG: 13-08-2019 Added as a part of Req# 6430 Start
  public static String ERRORMPO = 'Quote cannot be validated. Please contact your Partner Sales Manager (Maintenance Price Approval required)';
  public static String ERRORCP = 'Quote cannot be validated. Please contact your Partner Sales Manager (Custom Product requires Approval)';
  public static String ERRORLP = 'Quote cannot be validated. Please contact your Partner Sales Manager (LEO requires Approval)';
  public static String ERRORAll = 'Quote cannot be validated. Please contact your Partner Sales Manager (Maintenance Price/Custom Product/LEO/CAD Approval required)';
  public static String ERRORCAD = 'Quote cannot be validated. Please contact your Partner Sales Manager (CAD amount Approval required)';
  public static String ERROROCA = 'The quote will require G4/WTD approval. Please submit the approval. Pricing Manager will need to update the approval status in the Opportunity'; // Label Changed - SF Ticket 00956787
  public static String ERRORPSMMPO = 'Please submit the quote for approval(Maintenance Price Approval required)';
  public static String ERRORPSMCP = 'Please submit the quote for approval(Custom Product requires Approval)';
  public static String ERRORPSMLP = 'Please submit the quote for approval(LEO requires Approval)';
  public static String ERRORPSMAll = 'Please submit the quote for approval(Maintenance Price/Custom Product/LEO/CAD Approval required)';
  public static String ERRORPSMCAD = 'Please submit the quote for approval(CAD amount Approval required)';
  public static String ERRORPC = 'Please contact your PSM to check your Partner Certification';
  //RG: 13-08-2019 Added as a part of Req# 6430 End
  public static String ERRORJR = 'Please configure products in the quote to proceed';
  public static String ERRORDW = 'Quote cannot be validated at the cuurent opportunity stage';
  public static String ERRORKW = 'Opportunity is already pending approval';
  public static String ERRORCG = 'Quote cannot be validated.Opportunity should be in Create offer(bid) stage.';
  public static String REVIEW = 'In Review';
  public static String ERRORKS = 'Quote is In Review, please submit the opportunity for G4 approval to complete the quote approval. After validating your quote, please refresh your screen to see all options.';
  public static String ERRORBS = 'Quote cannot be validated at the current opportunity stage';
  public static String ERRORDS = 'Quote is In Review, please submit the opportunity for G4 approval to complete the quote approval. Please refresh your screen to see the updated quote details.';
  public static String OPPID = 'oppId';
  public static String ERRORMJ = 'Approval Page Not Found';
  public static String APPROVE = 'submitforApproval';
  public static String ERRORMH = 'Current Batch Status cannot be Found';
  public static String QUOTEID = 'quoteId';
  public static String ERRORAG = 'Cart Not Finalized';
  public static String ERRORWA = 'Quote cannot be validated.Invalid Offer condition';
  public static String ERRORBL = 'Quote is In Review. You will be notified when the Quote is approved. After validating your quote, please refresh your screen to see all options.';
  public static String WINCASE = 'Win the Case';
  public static String PENDINGWIN = 'Pending Win';
  public static String FUTURECASE = 'Future';

  // Approvals Req #3031 - Duplicate Batch Job
  Public static String csv_header = 'Grouping, Salesrole ID, Role Code, Role Name, Organisation, BG Attribute, User ID, First Name, Last Name, User Email \n';
  public static string body_txt = 'Duplicate Role codes at multiple level in Sales Role table';
  public static string sub_date_format = 'YYYY-MMM-DD-HH-MM-SS';
  Public static String Const_Market = 'Market';
  Public static String Const_APAC   = 'Asia Pacific & Japan';
  Public static String Const_GCHN   = 'Greater China';
  Public static String Const_Eur  = 'Europe';
  Public static String Const_Ind  = 'India';
  Public static String Const_LAT  = 'Latin America';
  Public static String Const_NAM  = 'North America';
  Public static String Const_MEA  = 'Middle East and Africa';
  public static string org_l2 = 'Nokia Networks';
  public static string org_l3 = 'Customer Operations';
  public static string hier_lvl4 = 'L4';
  public static string hier_lvl5 = 'L5';
  public static string hier_lvl6 = 'L6';
  Public static string spl_char1 = '_';
  public static string char_slash = '/';
  public static string file_extn = '.csv';
  public static string txt_in_mail = ' in ';
  public static string txt_lvl_mail = ' level ';
  public static string country_all = 'All';
  public static string const_global = 'Global';
  public static String RC_NSNA = 'NSNA';
  public static string RC_NSNB = 'NSNB';
  public static string RC_NSNC = 'NSNC';
  public static string RC_NSND = 'NSND';
  public static string RC_NSNE = 'NSNE';
  public static string RC_NSNG = 'NSNG';

  //SCRM LoA Sprint 14 Req-4534
  public static String Lead_BG_NSW = 'NSW';

  // SalesRoleHistory
  public static String CREATED= 'Created';
  public static String MODIFIED= 'Modified';
  public static String DELETED= 'Deleted';
  public static String DELETE_VALUE= 'Delete';
  public static String NSA= 'NSA';
  public static String UNDERSCORE_NSA= '_NSA';
  public static String SPACE_NSA= ' NSA';
  public static String NSNGCOCT= 'NSNG_COCT';

  //Sales process Req#4710-Updates in Sales Process based on new DocStrategy ReDesign
  public static String CONTENT_DOC_LINK_HELPER = 'ContentDocumentLinkHelper';
  public static String CONTENT_DOCUMENT_POC_HELPER = 'ContentDocumentHelper';
  public static String CONTENT_VERSION_HELPER = 'ContentVersionHelper';
  public static String DETERMINE_SOBJECT_TYPE = 'determineObjectType';
  public static String checkUncheckOfferSSOFlagOnInsert = 'checkUncheckOfferSSOFlagOnInsert';
  public static String checkUncheckOpportunityBOMFlagOnInsert = 'checkUncheckOpportunityBOMFlagOnInsert';
  public static String checkUncheckOpportunityPTAFlagOnInsert = 'checkUncheckOpportunityPTAFlagOnInsert';
  public static String checkUncheckOfferSSOFlagOnDelete = 'checkUncheckOfferSSOFlagOnDelete';
  public static String checkUncheckOfferSSOFlagOnUndelete = 'checkUncheckOfferSSOFlagOnUndelete';
  public static String updateOpportunityPTAOnDELETE = 'checkUncheckOpportunityPTAFLagOnDelete';
  public static String updateOpportunityPTAOnUNDELETE = 'checkUncheckOpportunityPTAFlagOnUndelete';
  public static String updateOpportunityBOMOnDelete = 'checkUncheckOpportunityBOMFlagOnDelete';
  public static String updateOpportunityBOMOnUndelete = 'checkUncheckOpportunityBOMFlagOnUndelete';
  public static String determineObjectTypeForUndelete = 'determineObjectTypeForUndelete';
  public static String determineObjectTypeForDelete = 'determineObjectTypeForDelete';
  public static String UpdateSObjectFlags = 'UpdateSObjectFlags';
  public static String PTAFlag = 'Project Target Agreement (PTA)';
  public static String SSOFlag = 'Solution Sign-Off (SSO-initial & final)';
  public static String BOMBOQFlag = 'Pre-Sales Risk BoM/BoQ';
  public static String NOTHINGTOUPDATEONDELETE = 'Nothing to Update on Delete';
  public static String NOTHINGTOUPDATEONUNDELETE = 'Nothing to Update on Unelete';
  public static String NOTHINGTOUPDATEONINSERT = 'Nothing to Update on Insert';
  public static String SSO_DocumentType = 'SSO_DocumentType label is Empty. Please add SSO Doc type in label.';
  public static String BoMBoQDocument = 'BoMBoQDocument label is Empty. Please add BOM/BOQ Doc type in label.';
  public static String PTADocument = 'PTADocument label is Empty. Please add PTA Doc type in label.';
  public static String SSO_Document_Types = 'SSO_DocumentTypes';
  public static String PTA_Documents = 'PTA_Documents';
  public static String BoMBoQ_Document = 'BoMBoQ_Document';
  public static String blockFileDeletionOnOffer = 'blockFileDeletionOnOffer';


  public static String quoteProposal = 'Apttus_Proposal__Proposal__c';
  public static String quoteStage = 'Draft';

  //Req# 4858
  public static String blockFileDeletionOppty = 'blockFileDeletionOppty';
  public static String Global_File_Owner = 'Global File Owner';
  public static String restrictNSASharing = 'restrictNSASharing';
  public static String ContentDocumentHandler= 'ContentDocumentHandler';
  public static String deleteFile = 'deleteFile';
  public static String ContentDocumentLinkHandler = 'ContentDocumentLinkHandler';
  public static String ConfidentialFileOwnerChange = 'ConfidentialFileOwnerChange';
  public static String Customers= 'Customers';
  public static String Customers_Login= 'Customers Login';
  public static String assignPermissionSetOnInsertUpdate= 'assignPermissionSetOnInsertUpdate';
  public static String removePermissionSetOnUpdate= 'removePermissionSetOnUpdate';
  public static String Project_Transfer_Agreement = 'Project Target Agreement (PTA)';
  public static String Pre_Sales_Risk_Doc_Type = 'Pre-Sales Risk BoM/BoQ';
  public static String Offer_Strategy_Sign_Off = 'Solution Sign-Off (SSO-initial & final)';
  public static String ERROR_MESSAGE_FOR_INPROGRESS_OPPTY_FILE_DELETE_RESTRICTION = 'You can\'t delete SSO / PTA / Pre-Sales Risk BoM/BoQ document if Opportunity is pending for approval.';
  public static String DOCUMENTTYPE_NULL_CHECK= 'Document Type can\'t be "N/A" for this object.';
  public static String Confidential_File = 'Confidential_File';
  public static String confidentialFileOwnerSet= 'confidentialFileOwnerSet';
  public static String createFileRecord = 'createFileRecord';
  public static String insertSObjectList= 'insertSObjectList';
  public static String getOpptyMasterAccounts= 'getOpptyMasterAccounts';
  public static String getOfferMasterAccounts= 'getOfferMasterAccounts';
  public static String shareWithConfidential= 'shareWithConfidential';
  public static String restrictFileSharing= 'restrictFileSharing';
  public static String shareWithAllUsers= 'shareWithAllUsers';
  public static String createConfidentialFiles= 'createConfidentialFiles';
  public static String validateUpload= 'validateUpload';
  public static String US_Govern = 'US_Govern';
  public static String NA= 'N/A';
  public static String Confidential_File1 = 'Confidential File';
  public static String CLOSE_OPPTY_FILE_UPLOAD_ERROR= 'File can\'t be uploaded if Opportunity is closed';
  public static String RESTRICT_NSA_ERROR= 'You can share this document with NSA Compliant user only';
  public static String SORRY_U_CNT_UPLOAD = 'Sorry, you can’t use this Document Type when uploading a file to an ';
  public static String SELECT_CORRECT_RECORD_TYPE = ' record. Please first select the appropriate ';
  public static String PLEASE_SELECT_CORRECT_REC_TYPE = ' & level value in the “Record Type” to display the associated Document Type picklist.';
  public static String HEY_UR_ON = 'Hey, as you are on ';
  public static String PLEASE_SELECT_UNRESTRICTED_FILE_FOR_OTHER = ' page, please select the Record type as "Unrestricted File to Other"';
  public static String UnrestrictedFileToAccount= 'Unrestricted File to Account';
  public static String UnrestrictedFileToOffer= 'Unrestricted File to Offer';
  public static String UnrestrictedFileToOpportunity= 'Unrestricted File to Opportunity';
  public static String UnrestrictedFileToOther= 'Unrestricted File to Other';


  // Req:4555
  public static String APPROVL_CENTER_RECORTYPE = 'Approval Center Task';

  //PS_productsuploadscontroller
  public static String CHARACTERNULL = '--null';
  public static String APEXMESSAGE10 = 'Following products are not available for shopping as pricing cluster and portfolio does not match:';
  public static String APEXMESSAGE11 = 'Following Products are Inactive Products or does not exists:';


  public static String TRUE_STRING= 'True';
  //Req 4879
  public static String G4_Planned_Date_Mandatory= 'G4_Planned_Date_Mandatory';
  public static String EXPECTED_LOA_LEVEL_G3_BYPASS= 'Expected_Loa_Level_G3_Bypass';

  public static String SPECIAL_CHARACTER ='\\r';

  // NF_EditAssignments CLass
  public static string L2_level='L2';
  public static string L3_level='L3';
  public static string L4_level='L4';
  public static string L5_level='L5';
  public static string L6_level='L6';
  public static string L7_level='L7';
  public static string NSA_Val='NSA';
  public static string IWA_Check='IWA';
  public static string Non_IWA_Check='Non-IWA';
  public static string AS_value='A&S';

  //OpportunityTriggerHandler
  public static Boolean notifyByChatter = false;

  //Req 4681
  public static string Campaign_Error1 = 'ERROR[Campaign does not exist.]';
  public static string Campaign_Error2 = 'LeadCaerror';
  public static string Campaign_Error3 = 'Errorxxx';
  public static string SENT = 'Sent';

  //Req 4989
  public static Integer INTEGER_ZERO = 0;
  public static Integer INTEGER_THREE = 3;
  public static string OBJECT_CONTACT = 'Contact';
  public static string LeadConevrtDocHandler = 'LeadConevrtDocHandler';
  public static string allowConvert = 'allowConvert';
  public static string detectLeadConvert = 'detectLeadConvert';
  public static string deleteOldLink = 'deleteOldLink';

  //Req 4943
  public static string populateUnweightedValueofGroupingObject = 'populateUnweightedValueofGroupingObject';
  public static string updateUnweightedValueofOpptyGroup = 'updateUnweightedValueofOpptyGroup';
  public static string updateUnweightedValueofOpptyGroupInFuture = 'updateUnweightedValueofOpptyGroupInFuture';
  public static string MASTER = 'Master';
  public static string SUBORDINATE= 'Subordinate';
  public static string beforeDeleteCheckOpptyRecordType= 'beforeDeleteCheckOpptyRecordType';


  //Req 4557
  public static string validateCorrectDealOpptyCombination = 'validateCorrectDealOpptyCombination';
  public static string restrictOpptyAssociationWithSameDeal = 'restrictOpptyAssociationWithSameDeal';
  public static string checkIfDealHasAlreadyMasterOppty = 'checkIfDealHasAlreadyMasterOppty';
  public static string checkIfDealHasMasterOpptyOnAssociationUpdate = 'checkIfDealHasMasterOpptyOnAssociationUpdate';
  public static string checkIfOpptyIsMasterOpptyOnAssociationUpdate = 'checkIfOpptyIsMasterOpptyOnAssociationUpdate';
  public static string associationChangeFromMasterToSubordinate = 'associationChangeFromMasterToSubordinate';

  //Req 5151
  public static string associateUpsellOpptyWithUpsellDeal = 'associateUpsellOpptyWithUpsellDeal';

  //Req 5150
  public static string restrictOpptyTypeChange = 'restrictOpptyTypeChange';

  //Release 8: Sales Process :Req4999
  public static String AVOIDCLOSINGCOMMITTEDUPSELLBYCOSALESOPMARKETHEAD = 'avoidClosingCommittedUpsellByCOSalesOpMarketHead';

  //Release 8: Sales Process: Req5090
  public static String Required = 'Required';
  public static String Required_Attached = 'Required (Attached)';
  public static String Not_Required = 'Not Required';
  public static String DefaultValueForSSOSATOnUpdate = 'defaultValueForSSOSATOnUpdate';
  public static String DefaultValueForSSOSATOnInsert = 'defaultValueForSSOSATOnInsert';
  public static String ManualChangingSSOTOAttached = 'manualChangingSSOTOAttached';
  public static String ExceptionReasonDefaultValue = 'Case with no presales solutioning work';
  public static String updateSSOOnUnweightedValueChange = 'updateSSOOnUnweightedValueChange';
  public static String updateSSOOnOffer = 'updateSSOOnOffer';

  //Release:8 : Sales Process : Req5072
  public static String UPDATEPROBABILITYOFPSROASSALESOPTYAFTERUPDATE = 'updateProbabilityOfPSROAsSalesOptyAfterUpdate';
  public static String UPDATEPROBABILITYOFPSROINFUTURE = 'updateProbabilityOfPSROInFuture';
  public static String PSRO_STAGES =  'Preparation,Submitted For Approval,In Execution,Completed,Cancelled';
  public static String TEMPLATEIDENTIFIER_G4 = 'G4';
  public static String TEMPLATEIDENTIFIER_G5 = 'G5';

  //Release : 8: Sales Process: Req:5001
  public static String VALIDATESUBSTITUTEOPTYWITHSAMEUPSELLDEAL = 'validateSubstituteOptyWithSameUpsellDeal';

  //Release 8: Sales  Process Req:5077
  public static String Regards = 'Regards';
  public static String Nokia_CRM = 'Nokia Salesforce CRM';
  public static String oppty_Name = 'Opportunity Name:';
  public static String oppty_Number = 'Opportunity Number:';
  public static String Oppty_Customer = 'Customer:';
  public static String Oppty_Lead_BG = 'Lead BG:';
  public static String Oppty_Lead_BU = 'Lead BU:';
  public static String The_Opportunity = 'The Opportunity ';
  public static String Country = 'Country:';
  public static String SupportingBG = 'Supporting BGs:';
  public static String SupportingBU = 'Supporting BUs:';
  public static String LoALevel = 'Approval Level:'; // Label Changed - SF Ticket 00956787
  public static String LoA_Level_Before_STA = 'Approval Level before STA:'; // Label Changed - SF Ticket 00956787
  public static String Sales_Outcomes= 'Sales Outcome:';
  public static String Main_Reason = 'Main Reason:';
  public static String Second_Reasons = 'Second Reason:';
  public static String Third_Reasons = 'Third Reason:';
  public static String Unweighted_Amounts = 'Unweighted Amount:';
  public static String Opportunity_Conclusion = 'Opportunity Conclusion:';
  public static String Big_Dot = '•';
  public static String NBSP = '&nbsp;';
  public static String notifyWhenPresalesOpptyClosed = 'notifyWhenPresalesOpptyClosed';
  public static String OPPTYSALESPHASE = 'Create Offer (Bid),Handover (Prepare for Delivery)';

  //Sales process Req-5003
  public static String opportunityTypeChangeRestriction = 'opportunityTypeChangeRestriction';

  public static String OIF_CHATTER1 = 'Following OIF lines on your opportunity ';
  public static String OIF_CHATTER2 = ' have been created:';
  public static String BUSINESS_LINE = '\nBusiness Line: ';
  //Added PRODUCT_LINE as part of SF 01354710
  public static String PRODUCT_LINE = '\nProduct Line: ';
  public static String FORECAST_CATEGORY = '\nForecast Category: ';
  public static String OIF_VALUE = '\nOIF Value: ';
  public static String POPLAN = '\nPO Plan/Receipt Period: ';
  public static String SOFTWARE = '\nSoftware %: ';
  public static String OIF_CHATTER3 = 'Many OIF lines on your opportunity ';
  public static String OIF_CHATTER4 = ' have been created.'   ;
  public static String OIF_CHATTER5 = '\n\nTo access this opportunity, please follow this link:\n ';
  public static String OIF_CHATTER6 = '\nTo see all created OIF lines in the last 7 days, please go to this report: \n';
  public static String OIF_CHATTER7 = '\nTo see all changed OIF lines in the last 7 days, please go to this report: \n ';
  public static String OIF_CHATTER8 ='/00O41000007Jzj5 \n\n Regards, \n Nokia Salesforce CRM';
  public static String OIF_CHATTER9 = ' have been changed';
  public static String TO = ' to ';
  public static String BL_CHANGE = '\nProduct Line is changed from ';
  public static String FORECAST_CHANGE = '\nForecast Category is changed from ';
  public static String OIF_CHANGE = '\nOIF value is changed from ';
  public static String PO_CHANGE = '\nPO Plan Period is changed from ';
  public static String SW_CHANGE = '\nSoftware % is changed from ' ;
  public static String COLON_WITHOUT_SPACE = ':';

  //Req#5004

  Public Static String LEAD_BG_GS = 'GS';
  Public Static String LEAD_BG_ION= 'ION';
  Public Static String LEAD_BG_FN = 'FN';

  //IWA Req.5005
  Public Static String NF_UPSELLNOTIFICATIONHELPER = 'NF_UpsellNotificationHelper';
  Public Static String METHOD_NOTIFY_UPSELL_APPROVERS = 'notifyUpsellApprovers';
  Public Static String METHOD_SENDEMAIL_TO_UPSELL_APPROVERS = 'sendEmailtoUpsellApprovers';
  Public Static Boolean NOTIFY_UPSELL_APPROVER = FALSE;
  Public Static Integer NF_DIVIDE = 100;
  Public Static String NF_USERHELPER = 'NF_UserHelper';
  Public Static String METHOD_FETCHINACTIVEUSERS = 'fetchInactiveUsers';
  Public Static String METHOD_DELETEUSERRELATEDENTRIES = 'deleteUserRelatedEntries';
  Public Static String PSRO_OFFERCONTROL_ERROR = 'You are not Authorized to submit this request. Please contact the involved offer controller to request the approval.';

  //OIF - Req#5123
  Public Static String BATCHOIFUPDATE = 'BatchOifUpdate';
  Public Static String BATCHOIFUPDATE_USD = 'BatchOifUpdate_USD';
  Public Static String BATCHOIFUPDATE_EUR = 'BatchOifUpdate_EUR';
  Public Static String OIF_EXCEPTION_EMAIL_HEADER = 'Record Id, OIF Name, Opportunity ID, OIF Currency, OIF Value, OIF Value EUR, OIF Value USD  \n';
  Public Static String OIF_EXCEPTION_EMAIL_PASTRECORDS_HEADER = 'Record Id, OIF Name, Opportunity ID,PO Plan/Receipt Period, OIF Currency, OIF Value\n';
  Public Static String OIF_EXCEPTION_EMAIL_PASTRECORDS_CSVFILENAME = 'Exceptions - OIFs with Past PO Periods.csv';
  Public Static String OIF_EXCEPTION_EMAIL_PASTRECORDS_MAILBODY = '\n\nFile Name: Exceptions - OIFs with Past PO Periods\nScope: This file includes records IDs of OIFs that were modified from a future PO period to a past PO period during the batch execution. '+
  'Their correct EUR and USD values are not included in the file.\nFailed Records / Total Records: ';
  Public Static String OIF_EXCEPTION_EMAIL_PASTRECORDS_INSTRUCTIONS = '\nInstructions: Please manually calculate the correct OIF Value EUR & OIF Value USD for the records in this file and proceed with the dataload.';
  Public Static String OIF_EXCEPTION_EMAIL_FUTUREPOPERIODS_CSVFILENAME = 'Exceptions - OIFs with Future PO Periods.csv';
  Public Static String OIF_EXCEPTION_EMAIL_MAILBODY_SALUTATION1 = 'Dear Admin / Dataload Team,\nPlease find attached the CSV file(s) for OIF records that were not correctly updated by the following batch: \n\nBatch Id :';
  Public Static String OIF_EXCEPTION_EMAIL_MAILBODY_SALUTATION2 = '\n\nFile Name: ' + 'Exceptions - OIFs with Future PO Periods.csv' + '\nScope: This file includes records IDs of OIFs that were not processed as part of the batch job or were processed incorrectly. '+
  'Their correct EUR and USD values are included in the file.\nFailed records / Total Records: ';
  Public Static String OIF_EXCEPTION_EMAIL_MAILBODY_INSTRUCTION = '\nInstructions: This file is ready to be directly uploaded via Dataloader, please proceed with the dataload.\n';
  Public Static String OIF_EXCEPTION_EMAIL_SIGNATURE = '\n\n Best Regards,\n Nokia SingleCRM';
  Public Static String OIF_EXCEPTION_EMAIL_SUBJECT = '[Action Needed] Failed Records for Batch: ';
  Public Static String COMPLETED_ON = ' Completed on ';
  Public Static String COMPLETED = 'Completed on ';
  Public Static String OIF_EXCEPTION_EMAIL_FILETOOLARGE_MESSAGE1 = 'Dear Admin / Dataload Team,\n The number of records to be corrected is too large to be sent via email for the following batch:\n\n ';
  Public Static String OIF_EXCEPTION_EMAIL_FILETOOLARGE_MESSAGE2 ='\nFailed Records/Total Records:';
  Public Static String OIF_EXCEPTION_EMAIL_FILETOOLARGE_MESSAGE_INSTRUCTION = 'Instructions: Please check the exception logs in sCRM and re-run the batch job if necessary.\n\n Best Regards,\n Nokia SingleCRM';
  Public Static String OIF_EXCEPTION_EMAIL_FILETOOLARGE_SUBJECT = '[Action Needed] Excessive Number of Failed Records for Batch: ';
  Public Static String OIF_EXCEPTION_EMAIL_NOFAILURE_MESSAGE1 = 'Dear Admin / Dataload Team,\nThere are no failure records for the following batch:  \n\nBatch Id :';
  Public Static String OIF_EXCEPTION_EMAIL_NOFAILURE_MESSAGE2 = '\n\nYou do not need to take any further action.\n\nBest Regards,\nNokia SingleCRM';
  Public Static String OIF_EXCEPTION_EMAIL_NOFAILURE_SUBJECT = '[Information] No Failed Records for Batch: ';
  Public Static String BATCH_ID = 'Batch Id :';


  Public Static String STAGENAME = 'Submitted for G2 Approval,Submitted for G3 Approval,Submitted for G4 Approval,Submitted for G5 Approval,Submitted for G6 Approval,Pending Win/Loss Declaration,Closed(not won),Direct_Record_Type,Indirect_Record_Type';
  Public Static String ERROR_MESSAGE_OPPTY  = 'You cannot update the opportunity, when it is pending for approval';

  Public Static String BUSINESS_LINE_RECORDTYPE = 'Business Line';
  Public Static Boolean BL_INSERT_EXECUTED = FALSE;
  Public Static Boolean BL_UPDATE_EXECUTED = FALSE;

  //Req 4422
  Public Static String  POPULATE_G4APPROVALCYCLETIMEONOFFER= 'populate_G4ApprovalCycleTimeOnOffer';




  //POC- Sales Process Req- 5595
  public static string Expected_LoA_Level = 'Expected_LoA_G4_Approval_Level__c';
  public static string TeamMember = 'Team_Member_Role__c';
  public static string AdditionalTeamMember = 'Additional_Team_Role__c';
  public static string Access_Level = 'Offer_Access__c';
  public static string CREATEOFFERAEXCTLR = 'CreateOfferApexCtlr';
  public static string GETOPPTY = 'getOppty';
  public static string SAVEOFFER = 'saveOffer';
  public static string SAVEOFFERTEAM = 'saveOfferTeam';
  public static string GETALLEXPECTEDLOALEVEL = 'getAllExpectedLoALevel';
  public static string GETFIELDMAPOFFER = 'getFieldMapOffer';
  public static string GETALLTEAMMEMBERROLE = 'getAllTeamMemberRole';
  public static string GETALLADDITIONALTEAMMEMBERROLE = 'getAllAdditionalTeamMemberRole';
  public static string GETALLACCESSLEVEL = 'getAllAccessLevel';
  public static string GETFIELDMAPOFFERTEAM = 'getFieldMapOfferTeam';
  public static string GETOPPTYTEAM = 'getOpptyTeam';
  public static string GETOFFERTEAM = 'getOfferTeam';
  public static string GETALLUSERLIST = 'getAllUserList';
  public static string GETUSER = 'getUser';
  public static string ALL_ACCESS_OFFER = 'ALL';
  public static string EDIT_ACCESS = 'Edit';
  public static string READ_ONLY_ACCESS = 'Read Only';
  public static string READ_EDIT_ACCESS = 'Read/Write';
  public static String LIST_WRAPPER = 'List<OfferTeamWrapper>';
  public static String OFFERTEAMPRMVALIDATION = 'offerTeamPrMValidation';
  public static String TEAMMEMBERROLE = 'TeamMemberRole';


  //test currencyconversion
  public static Boolean currencyChangedBefore = false;
  //Req 5252
  public static string PREVENT_DUPLICATE_COMPETITOR = 'preventDuplicateCompetitor';

  //Sales Process Sprint 18 Req 5468,PreSales 5469
  public static String TRICON_SCO_ROLE = 'Account Manager (TRICORN Sales Case Owner (SCO)';
  public static String INSERT_OWNER_IN_OPPTY_TEAM = 'insertOwnerInOpptyTeam';
  public static String UPDATE_OWNER_IN_OPPTY_TEAM = 'updateOwnerInOpptyTeam';
  public static String INSERT_OWNER_IN_OPPTY_TEAM_REOPENING = 'insertOwnerInTeamOnReopening';

  //RedBox Variables
  public static String RedboxOrders='Batch_EDP_RedboxOrders';
  public static String RedboxSalesandSalesMargin='Batch_EDP_RedboxSalesandSalesMargin';

  //fileFieldDocStrategy Req#5275
  public static String contentVersionQuery = 'Id, RecordType.Name, LastModifiedBy.Name, CreatedBy.Name  FROM ContentVersion WHERE ContentDocumentId =: docId and IsLatest = true LIMIT 1';
  public static String fileReportQuery = 'Id, LastModifiedBy.Name, CreatedBy.Name FROM File_Report__c WHERE ContentDocumentId__c =: docId  ORDER BY LastModifiedDate DESC LIMIT 1';
  public static String fileReportQueryList = 'Id, LastModifiedBy.Name, CreatedBy.Name, CreatedDate FROM File_Report__c WHERE ContentDocumentId__c =: docId  ORDER BY LastModifiedDate DESC';
  public static String FileReportObject = 'File_Report__c';
  public static String CREATED_SMALL = 'created';
  public static String FILE_VERSION = 'File Version';
  //Ticket 12448
  public static string CONTACT_MATCH_INDUSTRY_WITH_LEAD = 'contactMatchIndustryWithLead';
  //Campaign Member
  Public Static String CAMPAIGNID = 'CampaignId';
  Public Static String EXPR0 = 'expr0';
  Public Static String CampaignMemberHelper = 'CampaignMemberHelper';
  Public Static String CampaingMemberRollUp = 'campaingMemberRollUp';
  Public Static String UpdateParentCount = 'updateparentCount';
  //sf ticket 00015187
  Public static String Method_oif_deal_validate= 'UpsellDealvalidator';

  //Req 5345 sales process
  public static String OPPTYINFOCONTROLLER = 'OpptyInfoController';
  public static String  GETOPPTYINFO = 'getOpptyInfo';

  //Req 5073
  public static string CREATECOMPETITORWHENOPPORTUNITYCLOSEDNEGATIVELY = 'createCompetitorWhenOpportunityClosedNegatively';
  public static string  UPDATEWINNINGCOMPONOPPTY= 'updateWinningCompOnOppty';
  public static string  CREATEUNKNOWNCOMPETITORRECORD= 'createUnknownCompetitorRecord';
  public static string  UNKNOWN= 'Unknown';


  public static string  PROFILE_DS_SALES_CUST = 'Digital Sales Customer Profile';
  public static string  PROFILE_DS_CUSTOMERS = 'Customers';

  //Req 5684 sales process
  public static string  UPDATEWINNINGCOMPETITORONOPPTY = 'updateWinningCompetitorOnoppty';

  //Req 5592 sales process
  public static string  CONFIRMPOBOOKINGCTRL = 'confirmPOBookingCtrl';

  public static boolean isOrderIntakeInsertFirstRun = true;
  public static boolean isOrderIntakeUpdateFirstRun = true;
  public static boolean isOrderIntakeDeleteFirstRun = true;
  public static boolean isOrderIntakeFirstRun = true;

  //API names for PMDI
  public static String PRODUCTSALESITEM = 'ProductSalesItems';
  public static String PRODUCTCONFIGURATIONITEM = 'ProductConfigurationItems';
  public static String PRODUCTPORTFOLIOITEM = 'ProductPortfolioItems';
  public static String PRODUCTRELATIONS = 'ProductRelations';
  public static String Batch_EDPDataLoadToStaging = 'Batch_EDPDataLoadToStaging';
  public static String Batch_PortfolioToContent = 'Batch_PortfolioToContent';
  public static String Batch_ProductRelations = 'Batch_ProductRelations';

  public static boolean executeFALUContactSync = true;
  //Req 5783 sales process
  public static String WONSHAREALLOCATIONVALIDATION = 'wonShareAllocationValidation';
  public static String VALIDATEWONSHAREALLOCATIONSUM = 'validateWonShareAllocationSum';

  public static String BUSINESSLINEDATAINSERT = 'businessLineDataInsert';
  public static String CloneLinesChangeCurrency = 'CloneLinesChangeCurrency';
  public static String GETOPPORTUNITYDATA = 'getOpportuntityData';
  public static String CHECKFORCOMMITTEDUPSELLOPPTY = 'checkForCommittedUpsellOppty';
  public static String GETOPPORTUNITYID = 'getOpportuntityID';
  public static String CREATEALLOCATIONOIF = 'createAllocationOIF';

  //Req 5957
  public static String BatchRemoveNSAFLAG = 'Batch_Remove_NSA_FLAG';
  public static String REMOVEUSERFROMNSATERRITORY = 'removeUserFromNSATerritory';

  //F 1194
  public static Double MINUNWEIGHTEDVALUE_G2APPROVAL = 20000000;

  /*****CQ Constants*****/
  public static String QuoteProposal_RecordType_1 = 'Contracted_Quote';
  public static String QuoteProposal_RecordType_2 = 'CQ_Read_Only';
  public static String CQ_New_RecordType_Edit = 'CPQ_QTC_CQ_Quote';
  public static String CQ_New_RecordType_Read = 'CPQ_QTC_CQ_Quote_Read_Only';
  public static String CQ_ProposalTriggerHandler = 'CQ_ProposalTriggerHandler';
  public static String CQ_ProposalTriggerHandler_AfterInsert = 'AfterInsert';
  public static String CQ_ProposalTriggerHandler_AfterUpdate = 'AfterUpdate';
  public static String CQ_ProposalTriggerHandler_BeforeDelete = 'BeforeDelete';
  public static String CQ_ProposalTriggerHandler_Recordtypecheck = 'Recordtypecheck';
  public static String CQ_CONTRACTED_QUOTE_TRIGGER_HANDLER = 'ContractedQuoteTriggerHandler';
  public static String CQ_UPDATE_QUOTE_PRICING = 'updateQuotePricing';
  public static String CQ_UPDATE_QUOTE_STATUS = 'updateQuoteStatus';
  public static String CQ_CHECKSURROUNDCQ = 'checkSurroundCQ';
  public static String CQ_QuotetoReporting = 'CQ_QuotetoReporting';
  public static String CQ_QuotetoReporting_CQ_Report_Fieldmapping = 'CQ_Report_Fieldmapping';
  public static String CQ_QuotetoReporting_CQ_Report_Update = 'CQ_Report_Update';
  public static String CQ_QuotetoReporting_CQ_Report_Insert = 'CQ_Report_Insert';
  public static String QuoteProposal_API_Name = 'Apttus_Proposal__Proposal__c';
  Public static string ACCEPTED='Accepted';
  Public static string IN_PROGRESS='In Process';
  Public static string FROMADDRESS='FromAddress';
  Public static string CQ_PROCESS_QUOTE = 'CQ Process Quote';
  Public static string CQ_Lead = 'CQ Lead';
  Public static string Sales_Lead = 'Sales Lead';
  Public static string CREATE_CQREPORTING_QUEUEABLE = 'CreateCQReportingQueueable';
  Public static string CQ_STATUS_APPROVED = 'Approved';
  Public static string UPDATE_SURROUND_PRICED_ACCOUNT = 'updateSurroundPricedAccount';
  Public static string UPDATE_EQUOTE_STATUS = 'updateeQuoteStatus';
  Public static string EMAIL_MSG_DRAFT_STATUS = '5';
  Public static string CQ_STATUS_ACCEPTED = 'Accepted';
  Public static string CQ_STATUS_DRAFT = 'Draft';
  Public static string CQ_SEND_QUOTE_BY_MAIL = 'sendQuoteByMail';
  Public static string EQUOTE_STATUS_INPROGRESS = 'In Process';
  Public static string EQUOTE_STATUS_FAILURE = 'Failure';
  Public static string EQUOTE_STATUS_SUCCESS = 'Success';
  Public static string EQUOTE_ERROR_FAIL = 'Fail';
  Public static string EQUOTE_ERROR_ACCEPT = 'Accept';
  Public static string CQ_CREATESUCCESSINTERFACELOGS = 'createSuccessInterfaceLogs';
  Public static string CQ_CREATERRORINTERFACELOGS = 'createErrorInterfaceLogs';
  Public static string CQ_CREATECQREPORTINGS = 'createCQReportings';
  Public static string CQ_UPDATEQUOTEINQP = 'updateQuoteinQP';
  Public static string Direct_Quote_StatusClosed = 'Closed';
  //CQ_SyncQuote changes
  public static final String CQ_SURROUNDDOCUMENTLINKHANDLER = 'SurroundDocumentLinkHandler';
  public static final String CQ_UPDATECQNAMEFIELD = 'updateCQNameField';
  //CQ_SyncQuote
  public static  String QUOTE_PROPOSAL_OBJECT = 'Apttus_Proposal__Proposal__c';
  public static  String INTERFACE_LOG_QUOTE_INTERFACE_TYPE = 'CQ Sync Quote';
  public static  String INTERFACE_DETAILLOG_SYNC_ERROR = 'SHAREPOINT_SYNC_ERROR';
  public static  String INTERFACE_LOG_PARTIAL_STATUS = 'Partial Success (Race Conditions Occurred)';
  public static  String INTERFACE_LOG_BULK_NAME = 'Bulk Operation';
  public static  String INTERFACE_LOG_QUEUED = 'Request queued for future callout';
  public static  String CQ_EMAIL_ERROR = 'Email Error';
  public static  Integer RecursiveCount =0;
  public static String Sync_QuotestoEAI = 'Sync_QuotestoEAI';
  public static String OFFER_OBJ = 'Offer';
  public static  String INTERFACE_LOG_OFFER_INTERFACE_TYPE = 'CQ Sync Offer';
  public static  String QUOTE_REQUIRED_INFO_MISSING = 'QUOTE_REQUIRED_INFO_MISSING';
  public static  String CQ_OFFER_REQUIRED_INFO_MISSING = 'OFFER_REQUIRED_INFO_MISSING';
  public static  String CQ_MAX_SIZE = 'CQ_MAX_SIZE';
  public static  String MAX_BULK_SIZE_ERROR = 'MAX_BULK_SIZE_ERROR';
  public static  String CQ_SYNCQUOTE_INSERT = 'CQ_SYNCQUOTE_INSERT';
  public static  String CQ_SYNCQUOTE_UPDATE = 'CQ_SYNCQUOTE_UPDATE';
  public static  String CQ_SYNCOFFER_INSERT = 'CQ_SYNCOFFER_INSERT';
  public static  String CQ_SYNCOFFER_UPDATE = 'CQ_SYNCOFFER_UPDATE';
  public static  String OFFERSYNC_TOEAI = 'OfferSync_ToEAI';
  public static set<Id> OFFERSET_SYNC=new set<Id>();
  public static Integer CountCheck = 0;
  public static integer REC_Count= 0;

  //CQ_SyncQuote
  Public static string CQ_PROPOSALTRIGGERHELPER = 'CQ_ProposalTriggerHelper';
  Public static string CQ_CREATEQUOTETEAMUPONCREATION = 'createQuoteTeamoncqcreation';
  Public static string CQ_CREATEQUOTENUMBER = 'createQuoteNumber';
  Public static string CQ_REBIDQUOTECONTROLLER = 'CQ_RebidQuoteController';
  Public static string CQ_FETCHQUOTEDETAILS = 'fetchquoteDetails';
  Public static string CQ_FETCHPICKLISTVALUES = 'fetchpicklistValues';
  Public static string CQ_REBIDQUOTE = 'rebidQuote';
  Public static string CQ_UPDATEQUOTE = 'updateQuote';
  Public static string CQ_CLONEQUOTETEAM = 'cloneQuoteTeam';
  Public static string CQ_CLONECUSTOMERCONTACT = 'cloneCustomerContact';
  Public static string CQ_COS = 'CQ_Customer_Organization_Segment__c';
  Public static string QUOTES = '&quot;';
  Public static string CQ_MAXREVISIONERROR = 'Maximum revision reached for the Quote';
  Public static string CQ_STATUS_REBID = 'Rebid';
  Public static string ZEE = 'Z';
  Public static string CQ_CLONEQUOTECONTROLLER = 'CQ_CloneQuoteController';
  Public static string CQ_FETCHUSER = 'fetchUser';
  Public static string CQ_GETQUOTETEAM = 'getQuoteTeam';
  Public static string CQ_GETCUSTOMERCONTACT = 'getCustomerContact';
  Public static string CQ_CLONEQUOTE = 'cloneQuote';
  public static final String HANDLE_EXCEPTIONLOGS = 'handleExceptionLogs';
  public static final String CQ_SENDQUOTECONTROLLER = 'CQ_SendQuoteController';
  public static final String CREATEERRORLOGCUSTOMSETTING= 'CreateErrorlogCustomsetting';
  public static final String PROCESS_QUOTE_SYNC_ERROR = 'PROCESS_QUOTE_SYNC_ERROR';
  public static final String CQ_CREATEINTERFACEDETAILLOGRECORD= 'createInterfaceDetailLogRecord';
  public static Boolean IS_INBOUND = FALSE;
  public static final String CQ_QuoteVersion_Active = 'CQ_QuoteVersion_Active';
  public static final String CQ_eQuoteCheck = 'CQ_eQuoteCheck';
  public static String Sharecqfileto_CqReport = 'Sharecqfileto_CqReport';
  public static Boolean IS_CQHANDLERUPDATEFIRSTRUN = TRUE;
  public static String ACTIVE_STATUS = 'Active';
  public static String INACTIVE_STATUS = 'Active';
  public static String OFFER_REQUIRED_INFO_MISSING = 'Required information is missing. Please ensure you have Account Number value for the corresponding Account.';
  public static Boolean IS_PROCESS_QUOTE_SYNC = False;

  public static final String CL_salesorderreporting_trigger_helper = 'salesorderreporting_trigger_helper';
  public static final String M_updatecqdata= 'updatecqdata';
  public static final String M_UpdateCQNumber = 'UpdateCQNumber';
  public static final String M_Updatecurrencychange = 'Updatecurrencychange';
  public static final String M_Currencychange = 'Currencychange';
  public static final String M_CheckCQChange = 'CheckCQChange';
  public static final String CL_salesordertrigger_manager = 'salesordertrigger_manager';
  public static Boolean IS_CQREPORTINGINSERT_FIRSTRUN = FALSE;
  public static String CQ_REPORTING_TRIGGER_HELPER = 'CQ_ReportingTriggerHelper';
  public static String REPORT_TO_QUOTE = 'ReportToQuote';
  public static String EmailNotifications = 'EmailNotifications';
  public static String QuoteTeamMail='QuoteTeamMail';

  //Req 6125
  public static String UpdateDocumentType_ContentVersion = 'UpdateDocumentType_ContentVersion';
  public static String Quote_Document='Quote Document';
  public static String File_Share_From_CqToReport='Quote FileShareFromCqToReport';
  public static String Email_temp_SO_Created='SO_Created';
  public static String body = 'body';
  public static String subject = 'subject';
  public static String Approvalstage_won = 'Closed (Won)';
  public static string CL_EmailNotifications = 'EmailNotifications';
  public static string M_ExtractHTMLbody = 'ExtractHTMLbody';
  public static string M_sendmail = 'sendmail';
  public static string M_emailalert = 'emailalert';
  public static string M_upsertsoreporting = 'upsertsoreporting';
  public static string M_validate = 'validate';
  public static String CQ_StatusChange_NotificationEmail = 'CQ_StatusChange_NotificationEmail';
  public static String Approvalstage_Rebid = 'Rebid';
  public static Boolean CQ_SEND_EMAIL = False;
  public static string CQ_Business_Admin_group = 'CQ Business Admin for Files';
  public static string shareoption_restricted = 'R';
  public static string sharetype_c = 'C';
  public static string Surround_CQ_Reporting = 'Surround_CQ_Reporting__c';
  public static Boolean CQ_SEND_EMAIL_TO_QUOTETEAM = False;
  public static string CQ_QuoteTeamTriggerHelper = 'CQ_QuoteTeamTriggerHelper';
  public static string QuoteTeamMemberAssigned = 'QuoteTeamMemberAssigned';
  public static Boolean CQ_AFTERUPDATEHANDLERFIRSTRUN = True;
  public static string GETDYNAMIC_FIELDS = 'GetDynamic_fields';
  public static string GETSOBJECTFIELDS = 'GetObjectFields';
  public static String UPDATESTATUS_INTERFACETYPE = 'CQ UpdateQuote/Status';
  public static String UPDATEPRICING_INTERFACETYPE = 'CQ UpdateQuote/Pricing';
  public static String SEND_EMAIL_FALURE_STRING = 'Send Email Message Failed for VZW for ';
  public static String CQ_STATUS_SUBMIT = 'Submit';
  public static Boolean IS_CQUPDATEPRICINGMSG = false;
  public static Boolean IS_CQUPDATESTATUSMSG = false;
  public static String M_CQTerritorysharing  = 'CQTerritorysharing';
  public static String M_CQTerritorysharingupdate = 'CQTerritorysharingupdate';

  // R-opty by Partner
  public static String CustomPermission_CPQPartnerUser = 'CPQ_Partner_User';
  public static String completeOpptyInfomethod = 'completeOpptyInfo';
  public static String updateOpty_afterinsertmethod = 'updateOpty_afterinsert';
  public static String addOpptyTeamMembermethod = 'addOpptyTeamMember';
  public static String chatterNotificationToAccountOwnermethod = 'chatterNotificationToAccountOwner';
  public static String PartnerSalesManager_User = 'Partner Sales Manager';
  //public static String Alliance = 'Alliance';  // changed for SH2022: Alliance was deactivated
  public static String Distributor = 'Distributor';
  public static String DirectCustomer = 'Direct Customer';
  public static String DirectResellerPartner = 'Direct Reseller Partner';
  //public static String AlliancePartner = 'Alliance Partner'; // changed for SH2022: Alliance was deactivated
  public static String GPPDistributorPartner = 'GPP Distributor Partner';
  public static String GPPSPAAPpartner = 'GPP SPAAP partner';
  public static String GPPVARpartner = 'GPP VAR partner';
  public static string fromString = ' from ';
  public static string forString = ' for ';
  public static String chattermsg1 = 'has created a new Opportunity ';
  public static String chattermsg2 = '. The end customer needs to be reviewed and updated.';
  public static String Indirect_Record_Type='Indirect_Record_Type';
  public static String dash = '-';
  public static String IndirectOpportunityPartner= 'Indirect Sales Opportunity For Partner';
  public static String custompermission_PartnerSalesManager = 'PartnerSalesManager';
  public static String createOIFandOffermethod = 'createOIFandOffer';
  public static String CQ_Batch_CQTerritorysharing = 'Batch_CQTerritorysharing';
  public static String BATCH_FINISH = 'FINISH';
  public static final String CQ_SDL_ERROR = 'Updates are not accepted when eQuote Status is "In Progress" and Approval Stage is "Approved"';
  public static final String CQ_SDL_ERROR1 = 'Invalid CQ Id';
  //DS JSONParsing
  public static String  ValidErrorMsg='This atrribute is not available in JSON: ';

  public static String  SyncErrorMsg='This url is Not Available for sync Currently';
  public static String NoValidErrorMsg='This is field is not available in the structure: ';
  public static String EmptyErrormsg='This field cannot be empty: ';
  public static String CorrectDatamsg='This field data is not correct: ';
  public static String Duplicatemsg=' is already available in the system.Please give new value' ;
  public static String ProductNonAvailabilitymsg='This product is not available in the system :' ;
  public static String LINENUMBER='LINENUMBER';
  public static string HEADER_CS='HEADER';
  public static string WORKFLOW_TYPE='WORKFLOW_TYPE';
  public static string LINE_ITEM='LINE_ITEM';
  public static string CFA_OBJECT='CFA_OBJECT';
  public static string SALES_ITEM='SALES_ITEM';
  public static string QPLI_BUNDLEID='QPLI_BUNDLEID';
  public static string STAGING_INSERT_CS='STAGING_INSERT';
  public static string WORKFLOWTYPES_CS='WORKFLOWTYPES';
  public static string DATATYPE_CS='Datatype';
  public static string SOBJECT_CS='SOBJECT';
  public static string JSON_ATRRIBUTES='JSON_ATRRIBUTES';
  public static string DATE_ATRRIBUTE='Date';
  public static string DECIMAL_ATRRIBUTE='Decimal';
  public static string QP_ACCOUNTID='QP_ACCOUNTID';
  public static string QP_FILEREFERECEID='QP_FILEREFERECEID';
  public static string QP_OPPORTUNITY='QP_OPPORTUNITY';
  public static string QP_AGREEMENT='QP_AGREEMENT';
  public static string QPLI_CODE='QPLI_CODE';
  public static String  Bundlecodemsg='this Product code is not a Bundle: ';
  public static String  Standalonecodemsg='this Product code is not a Standalone or Option: ';
  public static string QP_SOURCEID='QP_SOURCEID';
  public static string DESERIALIZEJSON='Deserializejson';
  public static string QuoteHandling='QuoteHandling';
  public static string ResponseChange='ResponseChange';
  public static string insertInterfaceLog='insertInterfaceLog';
  public static string insertDSStaging='insertDSStaging';
  public static string LineItemDataChange='LineItemDataChange';
  public static string QuoteDataInsertion='QuoteDataInsertion';
  public static string QuoteConfigurationInsertion='QuoteConfigurationInsertion';
  public static string Bundle_Standalone_ConfigurationLineItemInsertion='Bundle_Standalone_ConfigurationLineItemInsertion';
  public static string CartFinalisation='CartFinalisation';
  public static string QPLI_BUNDLEQTY='QPLI_BUNDLEQTY';
  public static string QPLI_QUANTITY='QPLI_QUANTITY';
  public static string quoteline_items='quoteline_items';
  public static string quote='quote';
  public static String  NoLineitemMsg='There is No line item Present in the JSON.Please Upload the JSON with atleast one lineitem';
  //DS jsonparsing

  public static String CQ_Business_admin = 'CQ_Business_admin';
  public static string CQ_Services_price  = 'Services Price Detail Sheet';
  public static string VzWSpecial_price = 'Verizon Wireless Special Price';
  public static String SelectDocType = 'Please select either "Surround Document" or "Quote Document" as Document Type';
  public static String SelectRecType='Documents Attached to CQ Object should have "Unrestricted File to Other" Record Type';
  public static String CQ_ContentDocumentLinkHelper='CQ_ContentDocumentLinkHelper';
  public static String throwerroronCQ_FileUpload='throwerroronCQ_FileUpload';


  public static string ProposalTriggerHandler='ProposalTriggerHandler';
  public static string ProposalTriggerHandler_afterUpdateCPQTrigger='afterUpdateTrigger';
  public static string ProposalTriggerHandler_afterInsertCPQTrigger='afterInsertCPQTrigger';

  //EAI constants
  public static string Mapping_Value  = 'Mapping Value';
  public static string Apttus_ProposalProposal_Line_Item  = 'Apttus_Proposal__Proposal_Line_Item__c';
  public static string Quote_Delivery_Sales_Item  = 'Quote_Delivery_Sales_Item__c';
  public static string Quote_Staging  = 'Quote_Staging__c';
  public static string Mapping_Rule  = 'Mapping Rule';
  public static string Direct_Value  = 'Direct Value';
  public static string Query_Fields  = 'Query Fields';
  public static string Remove_Character  = 'Remove Character';
  public static string Currency_Conversion_EUR  = 'Currency Conversion EUR';
  public static string Currency_Conversion_USD  = 'Currency Conversion USD';
  public static string QTE_HEADER  = 'HEADER';
  public static string QTE_LINE_ITEM  = 'LINE ITEM';
  public static string Exclude  = 'Exclude';
  public static string Include  = 'Include';
  public static string Entry_Criteria  = 'Entry Criteria';
  public static string QTC_Add_Quote_Sync  = 'QtC integration';
  public static string QTC_QuoteProposalToStaging  = 'QTC_QuoteProposalToStaging';
  public static string LoadQuoteData  = 'LoadQuoteData';
  public static string SendAddQuoteMessage  = 'SendAddQuoteMessage';


  Public static String FlexibleGroupController = 'FlexibleGroupController';
  Public static String getlineitems = 'getlineitems' ;
  Public static String updatemarketmodel = 'updatemarketmodel';
  Public static String RemoveLineItems = 'RemoveLineItems';
  Public static String getbundledata = 'getbundledata';
  public static string cpqMarketModel='CPQ_Market_Model__c';

  Public static String TASK_VALUE = 'ADD';
  Public static String TASK_VALUE_ADD = 'ADD';
  Public static String TASK_VALUE_Final = 'Final';
  Public static String TASK_VALUE_UPD = 'UPD';
  Public static String Interface_String = 'Interface';
  Public static String Add_QuoteAddMessage = 'Add_QuoteAddMessage';
  Public static String QTC_ADDQUOTEADD_QTEHEADER = 'QTC_ADDQUOTEADD_QTEHEADER';
  Public static String QTC_ADDQUOTEADD_QTELINEITEM = 'QTC_ADDQUOTEADD_QTELINEITEM';
  Public static String QTC_ADDQUOTEFINAL_QTEHEADER = 'QTC_ADDQUOTEFINAL_QTEHEADER';
  Public static String QTC_ADDQUOTEFINAL_QTELINEITEM = 'QTC_ADDQUOTEFINAL_QTELINEITEM';
  Public static String PrimaryLineNumber_Field = 'Apttus_QPConfig__PrimaryLineNumber__c';
  Public static String UOM_Field = 'Apttus_QPConfig__Uom__c';
  Public static String LineNumber_Field = 'Apttus_QPConfig__LineNumber__c';
  Public static String RoundingAdjustment_Field = 'RoundingAdjustment__c';
  Public static String BASE_Field = 'BASE__c';
  Public static String CONTRACT_Field = 'CONTRACT__c';
  Public static String Request_Data_Field = 'Request_Data__c';
  Public static String DIVIDE = 'DIVIDE';
  Public static String MULTIPLY = 'MULTIPLY';
  Public static String QTELINENUM = 'QTELINENUM';
  Public static String OPERATION = 'OPERATION';
  Public static String Model = 'Model';
  Public static String UNDERSCORE_R = '__r';
  Public static String ITEMDESC = 'ITEMDESC';
  Public static String QUANTITY = 'QUANTITY';
  Public static String VALUE = 'VALUE';
  Public static String UOM = 'UOM';
  Public static String NUMOFDEC = 'NUMOFDEC';
  Public static String SIGN = 'SIGN';
  Public static String ITEM = 'ITEM';
  Public static String DATETIME_String = 'DATETIME';
  Public static String YEAR = 'YEAR';
  Public static String MONTH = 'MONTH';
  Public static String DAY = 'DAY';
  Public static String HOUR = 'HOUR';
  Public static String MINUTE = 'MINUTE';
  Public static String SECOND = 'SECOND';
  Public static String SUBSECOND = 'SUBSECOND';
  Public static String TIMEZONE = 'TIMEZONE';
  Public static String OPERAMT = 'OPERAMT';
  Public static String currencyISOCODE = 'currencyISOCODE';
  Public static String UOMNUMDEC = 'UOMNUMDEC';
  Public static String UOMVALUE = 'UOMVALUE';
  Public static String CURRENCY_String = 'CURRENCY';
  Public static Boolean QTC_BATCHEXECUTED = False;
  Public static String WarrantyContractNumber = 'WarrantyContractNumber';
  Public static String EFI = 'EFI';
  Public static String SERVICE = 'SERVICE';
  Public static String RFQTYPE_StartTag = '<RFQTYPE>';
  Public static String RFQTYPE_EndTag = '</RFQTYPE>';
  Public static String MapQuoteParameter = 'mapQuoteParameter';

  //Req 6667 CPQ
  Public static String ProductTriggerHandler = 'ProductTriggerHandler';
  Public static String PTH_updateproductdata= 'updateproductdata';
  public static String Batch_ProductUpdate='Batch_ProductUpdate';

  Public static String BUNDLE = 'Bundle';
  Public static String SOAPACTION = 'SoapAction';
  Public static String CONTENTYPE = 'Content-Type';
  Public static String ACCEPTENCODING = 'Accept-Encoding';
  Public static String CERTIFICATENAME = 'CertificateName';
  Public static String METHOD = 'Method';
  Public static String SOAPHEADER = 'SoapHeader';
  Public static String SOAPBODYENDTAG = 'SoapBodyEndTag';
  Public static String SOAPBODYSTARTTAG = 'SoapBodyStartTag';
  Public static String ADDQUOTE003ENDTAG = 'AddQuote003EndTag';
  Public static String ADDQUOTE003STARTTAG = 'AddQuote003StartTag';
  Public static String ADDQUOTEDATAAREAENDTAG = 'AddQuoteDataAreaEndTag';
  Public static String ADDQUOTEDATAAREASTARTTAG = 'AddQuoteDataAreaStartTag';
  Public static String XMLTOREMOVE = 'XmlToRemove';
  Public static String QTC_ADDQUOTEADD_GENERICHEADER = 'QTC_ADDQUOTEADD_GENERICHEADER';
  Public static String STARTMETHOD = 'Start';
  Public static String EXECUTEMETHOD = 'Execute';
  Public static String FINISHMETHOD = 'Finish';
  Public static String AT_LINE_NUMBER = ' At line number ';
  Public static String LUCENT_ParentLineNum = 'LUCENT_ParentLineNum__c';
  public static string Nokia_Enterprise = 'Nokia Enterprise';
  public static string LEAD_BG_NEN = 'NEN';
  public static string Batch_CalculateCurrentValueforPSRO = 'Batch_CalculateCurrentValueforPSRO';
  public static string Gate_R4 = 'R4';
  public static string CALCULATELOALEVEL = 'calculateLoAlevel';
  public static string PSROThresholdmail = 'psroThreholdMail';
  public static string UpdateValueinThresholdObject = 'UpdateValueinThresholdObject';
  Public Static String BG_CONTROL = 'BG Controller';
  Public static String VALIDATE_STATUS = 'Validate';

  public static String checkForValidCondition = 'checkForValidCondition';
  public static String ANDWITHSPACE = ' And ';
  public static String NOTINBRACKET = ' not in (';
  public static String CLOSEBRACKET = ')';
  public static String OPENBRACKET = '(';
  public static String PLUSSYMBOL = '+';
  public static String WHITESPACECHARACTER = '\\s';
  public static String DOCUMENTID = 'DOCUMENTID';
  public static String EFFECTIVE = 'EFFECTIVE';
  public static String EXPIRATION = 'EXPIRATION';
  public static String PRODUCTCODEFIELD = 'Product_Code__c';
  public static String ZEROPOINTZERO = '0.0';
  public static String TRIPLEZERO = '000';
  public static String EA = 'EA';
  public static String SELECTIDSTRING = 'Select Id';
  public static String QDSIQUERYSTRING = ' From Quote_Delivery_Sales_Item__c Where Proposal__c = :QuoteproposalIds';
  public static String PLIQUERYSTRING = ' from Apttus_Proposal__Proposal__c where Id=:proposalIds';
  public static String PARENTLINEITEMFIELD = 'Parent_Line_Item__c';
  public static String PARENTLINEITEMNUMBERFIELD = 'Parent_Line_Item__r.Apttus_Config2__LineNumber__c';
  public static String CASCADING = 'CASCADING';
  public static String TWO = '2';
  public static String WHITESPACECHAR = '//s+';

  public static String optyOwnertoPartnerSharingMethod = 'optyOwnertoPartnerSharing';

  //newqtc_DefectAge
  public static Boolean UPDATE_DEFECT_AGE = true;
  public static Boolean CREATE_DEFECT_AGE = true;
  public static String DEFECT_AGE = 'DefectAge';
  public static String NEW_DEFECT_AGE = 'newDefectAge';
  public static String UPSERT_DEFECT_AGE = 'upsertDefectAge';
  public static String START_DATE_BEFORE_INSERT = 'StartDatebeforeInsert';
  public static String START_DATE_BEFORE_UPDATE = 'StartdatebeforeUpdate';

  /****
  *PRM Global Constants
  *****/
 //Profiles and permission sets
  public static String NOKIA_PARTNER_PROFILE_NAME = 'PRM Partner Community User Login';
  public static String DATALOADER_PROFILE = 'Data Loader Profile';
 public static String COOP_GLOBAL_ADMIN_PERMISSION_SET = 'PRM_Co_Op_Global_Admin_Permission_Set';
 public static String COOP_PARTNER_ADMIN_PERMISSION_SET = 'PRM_Co_Op_Partner_Admins_Permission';

  //Fields, components, classes and method names
  Public static String PORTFOLIO_APINAME = 'port__c';
  Public static String BUSINESS_PLAN_APINAME = 'Business_Plan__c';
  Public static String GPP_CERTIFICATION_APINAME = 'GPP_Certification_Name__c';
  Public static String CERTIF_STATUS_APINAME = 'Certification_Status__c';
  public static string CERTIF_DETAIL_CONTROLLER = 'CertificationDetails';
  public static string CERTIF_RECORDS_CONTROLLER = 'CertificationRecords';
  public static string GET_CERT_VALUES_METHOD = 'getCertificationsValuesforComponent';
  public static string GET_ACCR_VALUES_METHOD = 'getAccreditationValuesforComponent';

  //Erros and success messagesfor CoOpInvoiceManager component
 public static String ERROR_MESSAGE_UPDATE = 'Error updating records';
 public static String ERROR_MESSAGE_CREATE = 'Error creating a new record';
 public static String ERROR_MESSAGE_GET = 'Error retrieving records';
 public static String ERROR_MESSAGE_DELETE = 'Error deleting records';
 public static String ERROR_MESSAGE_DUPLICATE = 'Invoice number duplicated!';
 public static String SUCCESS_MESSAGE_UPDATE = 'Records updated successfully!';
 public static String SUCCESS_MESSAGE_CREATE = 'New record created successfully!';
 public static String SUCCESS_MESSAGE_GET = 'Records retrieved successfully!';
 public static String SUCCESS_MESSAGE_DELETE = 'Records deleted successfully!';

  //Field Values
  Public static String COUNT = 'mycount';
  public static string CERTIF_STATUS_INPROGRESS = 'In Progress';
  public static string CERTIF_STATUS_PENDINGAPPROVAL = 'Pending Approval';
  public static string CERTIF_STATUS_COMPLETED = 'Completed';
  public static string CERTIF_STATUS_REGISTERED = 'Registered';
  public static string CERTIF_STATUS_APPROVED = 'Approved';
  public static string PARTNER_TYPE_IR = 'Indirect Reseller';
  public static string PARTNER_TYPE_DISTR = 'Distributor';
  public static string ACC_MBR_TRAINING_MANAGER = 'Training manager';
  public static string ACC_MEMBER_PRM = 'Partner Relationship Manager';
  public static string PORTF_MICROWAVE = 'Microwave';
  public static string PORTF_WIFI = 'Airscale Wifi';
  public static string PORTF_IP_ROUTING = 'IP Routing  ';
  public static string ACCOUNT_RECTYPE_CUSTOMER = 'Customer';
  public static string ACCREDITATION_RECTYPE_GPP0 = 'Reseller GPP 0.0';
  public static string CLAIM_STATUS_CLAIMABLE = 'Claimable';
  public static string CLAIM_STATUS_INCOMPLETE = 'Incomplete';

  public static String OPEN_STATUS_OIF = 'RoP,Secure,Risk,Upside,Excluded'; //F1784
  public static String TRICORN_ROLES = 'Account Manager (TRICORN Sales Case Owner (SCO));Solution Manager (TRICORN Customer Solution Owner (CSO));Project Execution Owner (TRICORN Project Execution Owner (PEO));Solution Manager (Lead);Services Solution Manager (Lead);Pricing Manager (Lead);Bid Manager'; //F1999
  public static String OFFER_TEAM_INCOMPLETE_WARNING = 'Please complete the Offer Team nominations. Assign the Bid Manager, TRICORN Roles: SCO, CSO, PEO and Lead roles: Solution Manager, Pricing Manager, Service Solution Manager.'; //F1999
  public static string LOA_Level_D = 'D';  //F2004
  public static String ERROR_MESSAGE_COSTS_CANT_CHANGE_MANUALLY = 'To manually change cost values, you first need to turn off the automated cost calculation.';
  public static String ERROR_MESSAGE_SALES_COSTS_LOCK_AFTER_PREPARATION = 'You cannot change sales and costs values after Preparation phase. Also Automatically Costs calculation flag are not editable after this stage.';

  //Req 00197301
  Public Static String BatchPSROUpdate = 'BatchPSROUpdate';
  public static string BATCH_PSRO_CURRENCY_UPDATE= 'BatchPSROUpdate';
  Public Static String BatchPSROUpdateEUR = 'BatchPSROUpdateEUR';
  public static string BATCH_PSRO_EUR_CURRENCY_UPDATE= 'BatchPSROUpdateEUR';

  Public Static String OPPORTUNITY_EXCEPTION_EMAIL_HEADER =  'Record Id,Opportunity name, Opportunity Currency \n';
  Public Static String OPPORTUNITY_EXCEPTION_EMAIL_CLOSEDRECORDS_HEADER = 'Record Id,Opportunity name, Opportunity Currency \n';
  Public Static String OPPORTUNITY_EXCEPTION_EMAIL_CLOSEDRECORDS_CSVFILENAME = 'Exceptions - Opportunity with closed Periods.csv';
  Public Static String OPPORTUNITY_EXCEPTION_EMAIL_CLOSEDRECORDS_MAILBODY = '\n\nFile Name: Exceptions - closed opportunity \nScope: This file includes records IDs of opportunity that were modified wrongly during the batch execution. '+
  'Their correct EUR values are not included in the file.\nFailed Records / Total Records: ';
  Public Static String OPPORTUNITY_EXCEPTION_EMAIL_CLOSEDRECORDS_INSTRUCTIONS = '\nInstructions: Please manually calculate the correct OPPORTUNITY Value EUR Value for the records in this file and proceed with the dataload.';
  Public Static String OPPORTUNITY_EXCEPTION_EMAIL_FAILEDRECORDS_CSVFILENAME = 'Exceptions - opportunity with closed status Periods.csv';
  Public Static String OPPORTUNITY_EXCEPTION_EMAIL_MAILBODY_SALUTATION1 = 'Dear Admin / Dataload Team,\nPlease find attached the CSV file(s) for OPPORTUNITY records that were not correctly updated by the following batch: \n\nBatch Id :';
  Public Static String OPPORTUNITY_EXCEPTION_EMAIL_MAILBODY_SALUTATION2 = '\n\nFile Name: ' + 'Exceptions - Opportunity with failed update Periods.csv' + '\nScope: This file includes records IDs of opportunity that were not processed as part of the batch job or were processed incorrectly. '+
  'Their correct EUR values are included in the file.\nFailed records / Total Records: ';
  Public Static String OPPORTUNITY_EXCEPTION_EMAIL_MAILBODY_INSTRUCTION = '\nInstructions: This file is ready to be directly uploaded via Dataloader, please proceed with the dataload.\n';
  Public Static String OPPORTUNITY_EXCEPTION_EMAIL_SIGNATURE = '\n\n Best Regards,\n Nokia SingleCRM';
  Public Static String OPPORTUNITY_EXCEPTION_EMAIL_SUBJECT = '[Action Needed] Failed Records for Batch: ';
  Public Static String OPPORTUNITY_EXCEPTION_EMAIL_FILETOOLARGE_MESSAGE1 = 'Dear Admin / Dataload Team,\n The number of records to be corrected is too large to be sent via email for the following batch:\n\n ';
  Public Static String OPPORTUNITY_EXCEPTION_EMAIL_FILETOOLARGE_MESSAGE2 = '\nFailed Records/Total Records:';
  Public Static String OPPORTUNITY_EXCEPTION_EMAIL_FILETOOLARGE_MESSAGE_INSTRUCTION = '\nInstructions: This file is ready to be directly uploaded via Dataloader, please proceed with the dataload.\n';
  Public Static String OPPORTUNITY_EXCEPTION_EMAIL_FILETOOLARGE_SUBJECT = '[Action Needed] Excessive Number of Failed Records for Batch: ';
  Public Static String OPPORTUNITY_EXCEPTION_EMAIL_NOFAILURE_MESSAGE1 = 'Dear Admin / Dataload Team,\nThere are no failure records for the following batch:  \n\nBatch Id :';
  Public Static String OPPORTUNITY_EXCEPTION_EMAIL_NOFAILURE_MESSAGE2 = '\n\nYou do not need to take any further action.\n\nBest Regards,\nNokia SingleCRM';
  Public Static String OPPORTUNITY_EXCEPTION_EMAIL_NOFAILURE_SUBJECT = '[Information] No Failed Records for Batch: ';


  //ft-2052
  Public Static String BID_MANAGER_OFFER_TEAM_ROLE = 'Bid Manager';
  Public Static String CT_HEAD_OFFER_TEAM_ROLE = 'CT Head';
  Public Static Integer QUERRY_LIMIT_MAX_USER_PER_OFFER  = 30;
  Public Static String PRICING_MANAGER_OFFER_TEAM_ROLE = 'Pricing Manager (Lead)';
  Public Static String SS_MANAGER_OFFER_TEAM_ROLE = 'Services Solution Manager (Lead)';

  public static string ATS4='@@@@';
  public static string APPROVAL_EMAIL_CHECK = 'NF_ApprovalEmailCheck';
  public static string OPP_EMAIL_APP_FAILED = 'Email approval failed for Opportunity: ';
  public static string H_INBOUND_EMAIL = 'handleInboundEmail';
  //ft-2056
  public static String ACTIVE_OFFER_FOR_APPROVAL = 'Please Check the Active Offer Information';
  public static String MANDATORY_PARAMETERS_G2_APPROVAL_MSG = 'The following fields are mandatory for submission to G2 approval:';

  //ft-14
  public static String ACCOUNT_NOT_VALID = 'This Account is not Valid to submit the Approval';
  public static String SALES_OUTCOME_CLOSED = 'You can not submit for approval if the Sales outcome is: Cancelled by Customer or Lost to Competitor or Obsolete or Withdrawn by Nokia';
  public static String MANDATORY_OIF_FOR_APPROVAL = 'You cannot submit for approval until you create an Order Intake Forecast.';
  public static String MANDATORY_LOA_FOR_APPROVAL = 'Please indicate the Expected LoA Level before notifying the G3 Facilitator.';
  public static String CANNOT_SUBMIT_APPROVAL_FROM_PROSPECT_ACC = 'You cannot submit for approval an opportunity belonging to a Prospect account.';
  public static String MANDATORY_LEAD_BG = 'You cannot submit for Approval until you specify the Lead BG{0}{1}, Unweighted Value, G3 Planned Date, Win Declaration Planned Date and Contract Signing Entity. Please fill these fields. ';
  public static String MANDATORY_PTA_SIGNED_G6 = 'Before submitting for Gate 6 approval make sure "PTA Signed" field is ticked and PTA file uploaded to the opportunity with type "Project Target Agreement (PTA)"';
  public static String MANDATORY_ACTIVE_OFFER = 'To proceed please create an offer for real G4/G5 approval or with G4/G5 bypass condition';
  public static String MANDATORY_G4BYPASS_OFFER = 'This opportunity bypassed Gate 3 and therefore only allows G4/G5 bypass. Please select the correct "G4/G5 Bypass condition" in the active offer or perform a real G3';

  public static String ACTIVE_OFFER_G4_APPROVED = 'The offer is already G4 approved, create a new active offer for next G4';
  public static String MANDATORY_EXP_LOA_LEVEL_G3 = 'You cannot submit for Approval until you specify the Expected LoA Level.';
  public static String FILL_COSTS_INFO_PSRO_MSG = 'Please Fill the Cost value';
  public static String FILL_SALES_INFO_PSRO_MSG = 'Please Fill the Sales value';
  public static String NO_APPROVALS_NEEDED_MSG = 'No Approvals needed at this time';
  public static string STAKEHOLDERS_PREVIEW_EMPTY_MSG = ' : Approval Stakeholders Preview is empty';
  public static string BYPASS_STAKEHOLDERS_PREVIEW_EMPTY_MSG = ' offer condition activated: Approval Stakeholders Preview is empty';
  public static string BYPASS_GATE_2_MSG ='Bypass GATE 2';
  public static string BYPASS_GATE_3_MSG='Bypass GATE 3';
  public static string BYPASS_GATE_4_MSG='Bypass GATE 4';
  public static string BYPASS_GATE_5_MSG='Bypass GATE 5';
  public static string BYPASS_GATE_6_MSG='Bypass GATE 6';
  public static string G3BYPASS_LOA_MSG = 'Gate 3 Bypass (No offer support)';
  public static string G4BYPASS_LOA_MSG ='G4 Bypass: ';
  public static string G5BYPASS_LOA_MSG ='G5 Bypass: ';
  public static string G6BYPASS_LOA_MSG ='Gate 6 Bypass (No Execute needed)';
public static string SELECT_VALID_LOA_LEVEL_MSG = 'Please select valid Approval Level'; // Label Changed - SF Ticket 00956787
  public static string SELECT_VALID_EXPECTED_LOA_LEVEL_MSG = 'Please select valid Expected LoA Level';
  public static string CREATE_OFFER_MSG ='Please Create an Offer';
  public static string PTA_FIELD_MISSING_MSG = 'PTA signed field need to be checked';
  public static string G3_FACILITATOR_NOTIFIED_UPSELL = 'G3 facilitator to be notified - {0}';
  public static string G3_FACILITATOR_NOTFOUND = 'No Facilitator Found';
  public static string G3_FACILITATOR_BYPASS = 'No need to Notify the G3 facilitator in this case. Gate 3 can be bypassed. Please go ahead and submit gate 3 to bypass it.';
  public static string LOA_LEVEL_E = 'E';
  public static string G3_FACILITATOR_FOUND = 'The following is the G3 facilitator to be notified';
  public static string G3_FACILITATOR_VALID_PROBABILITY = 'Probability must be a numeric value between 1 and 100.';
  public static string MARKET_LATIN_AMERICA = 'Market Latin America';
  public static string MARKET_NORTH_AMERICA = 'Market North America';
  public static String FACILITATOR_EMAIL_TEMPLATE = 'NF_G3Facilitator_Apttus_OpptyNotifyOnly';
  public static string TYPE_REQUEST_RFP_RFI = 'RFP/RFI';
  public static string G3_FACILITATOR_INFO_MSG = 'Following parameters and completion of G3 Risk Assessment are mandatory for G3 Facilitator notification:';
  public static String G3_FACILITATOR_MANDATORY_MSG = 'All fields below and completion of G3 Risk Assessment are mandatory for G3 Facilitator notification';
  public static String G4_PLANNED_DATE_INFO = 'G4 Planned Date cannot be a past date.';

  //ft-51
  public static string NEIOT = 'IoT';
  public static string NEDAAAS = 'DAaaS';
  public static string NEEOP = 'EOP';

  //ft-79
  public static string G5_CONFIRM_POPUP_MSG = 'By submitting this offer for G5 approval, you confirm that the Contract/PO is fully in line with the last G4 Approval. Please confirm.';
  public static string G5_CONFIRM_POPUP_TITLE = 'Gate 5 Approval Request';

  //ft-57
  public static Boolean Sales_Role_Bypass = false;

  //ft-84
public static string G5_Submision_WO_RefOpp = 'Submission for Win declaration using G4/G5 bypass offer condition = "G4 approved or contracted" can be done only if an opportunity has been added in "Reference Opportunity" field and if that related oppty passed G5 contract approval'; // Label Changed - SF Ticket 00956787

  //FT-128
  public static string NON_SALES_USER_PROFILE = 'Non-Sales User Profile';
  public static string ONLY_USERS_IN_OFFER_TEAM_CAN_EDIT = 'Nokia Sales users can only update pre opportunities if they are assigned as members in the opportunity team';

  //ft-158 - ft161
  public static string EC_INFO_UNKNOWN = 'Currently Unknown End Customer';
  public static string EC_INFO_MULTI = 'Multiple End Customer';
  public static string EC_INFO_KNWON = 'Known End Customer';
  public static string EC_UNKNOWN_AT_WIN_DECLARATION= 'Please input the real End Customer legal entity name before Win Declaration, or if more than one, select the option “Multiple End Customer"';

  //QAC-803
  public static String BUSINESS_DEVELOPMENT ='Business Development';
  //Indirect_Record_Type
  public static String DIRECT_RECORD_TYPE = 'Direct_Record_Type';
  public static String PSRO_RECORD_TYPE = 'Pre_Sales_Risk_Opportunity';
  public static String PREOPPTY_RECORD_TYPE = 'Pre_opportunity';
  public static String LEGAL_ENTITY_RECORD_TYPE = 'Legal_Entity';
  public static String INDIRECT_DEAL_REGISTRATION_RECORD_TYPE = 'PRMIndirect_Deal_Registration';
  public static String BUSINESS_LINE_RECORD_TYPE = 'NokiaCPQ_Business_Line';
  public static String FIELDS_AFFECTED_BY_ERROR = 'Fields that affected this error : ';
  public static String SWX_UPSELL_PROPOSAL_RECORD_TYPE = 'SWx_Upsell_Proposal';
  public static String CCRE_UPSELL_PROPOSAL_RECORD_TYPE = 'CCRE_Upsell_Proposal';
  public static String READ_ONLY_DIRECT_RECORD_TYPE = 'Read_Only';
  public static String READ_ONLY_INDIRECT_RECORD_TYPE = 'Read_Only_Indirect';
  public static String PSR_RECORD_TYPE = 'Pre_Sales_Risk_Opportunity';
  public static String READ_ONLY_PSR_RECORD_TYPE = 'Pre_Sales_Risk_Opportunity_read_only';
  public static String UPSELL_DEAL_RECORD_TYPE= 'Upsell_Deal';
  public static String CUSTOMER_DEVNAME = 'Customer';//Customer Account record type developer name
  public static String LEGAL_ENTITY_DEVNAME = 'Legal_Entity';//Legal entity Account record type developer name
  public static String SOLUTION_MANAGER = 'Solution Manager (TRICORN Customer Solution Owner (CSO))';

  //Added by Shashikant - IP Routing Portfolio Edit restriction line no 2410 to 2412
  public static string PORTFOLIO_TYPE_IP_ROUTING = 'IP Routing';
  public static string Exchange_Rate_Update_Errormsg = 'Exchange Rate Can not modify for IP routing Portfolio';

  //ft-159
  public static String END_CUSTOMER_INFORMATION = 'End_Customer_Information__c';
  public static String GET_ALL_EC_INFORMATION_VAL='getAllOppECInformationValues';
  public static String M_O_U_EC_MARKET_SEGMENT='Multiple_or_Unknown_EC_Market_Segment__c';
  public static String GET_ALL_MTK_SEG_VAL='getAllOppECMktSegValues';
  public static String M_O_U_EC_Country='Multiple_or_Unknown_EC_Country__c';
  public static String GET_ALL_COUNTRY_VAL='getAllOppECCountryValues';
  public static String M_O_U_EC_ACT_SEC='Multiple_or_Unknown_EC_Activity_Sector__c';
  public static String GET_ALL_ACT_SEC_VAL='getAllOppActSecValues';

  public static String BG_CNS = 'CNS';
  public static String BG_NI = 'NI';
  public static String BU_NI_FN = 'NI - FN';
  public static String BU_NI_IPRTG = 'NI - IPRTG';
  public static String BU_NI_OPTICS = 'NI - OPTICS';

  public static String GATE_MANAGEMENT_WTD_ERROR = 'Gate Approval will be managed in WtD';

  //ft-241
  public static String RENEWAL_OPP_SUFFIX = '_Care Renewal';
  public static String RENEWAL_CONTRACT_TYPE = 'Renewal  of Contract';

  //Added by Christie JJ for rqmt 6987 for March 21.3
  public static string DUPLICATE = 'This CSV file is already uploaded. Please select a different file to upload';
  public static string ABANDON = 'Abandon';
  public static string PAGEACTION = 'pageAction';

  public static boolean RUNFLAG = false;
  public static string BELOW5M = '< 5M';
  public static string ABOVEOREQUAL5M = '>= 5M';
  public static String OPPTYSEGMENT_ENTERPRISE = 'ENT';

  //ft-299
  public static boolean SKIP_NO_COMPLEX_OFFER_DM_ASSIGNMENT = false;//Used to prevent the No_Complex_Offer_Decision_Maker__c fill in when the Gate_2_Bypass_no_complex_offer__c is automatically updated
  public static String RENEWAL_OF_CONTACT= 'Renewal of a Contract';
  public static String G3FACILITATORNOTIFIED = 'G3 Facilitator Notified';
  public static String G5PREPINITIATED = 'G5 Preparation Initiated';
  public static String FASTTRACKTYPE_CANNOTCHANGE = 'Not allowed to change Opportunity Type to or from Fast Track Opportunity.';
  public static Boolean BYPASS_OPPTYPECHANGE = false;

  //ft-334 - Fast Track
  public static String FAST_TRACK_OPP_TYPE = 'Fast Track Opportunity';
  public static string G4_APPROVED_TECH='Approved G2,Approved G3,Approved G4';
  public static string G4_APPROVED='Approved G4';
  public static String OPEN_OIF_RT_DEVNAME = 'OIF_Open';
  public static String ACCOUNT_MANAGER_TRICORN = 'Account Manager (TRICORN Sales Case Owner (SCO))';

  //FT-352
  public static String OPP_ACCID_ALLOCATION_ERROR= 'It is not possible to change the Account in the Opportunity to this Market NAM Account, as it is impacted by allocations logic. Please create a new Opportunity.';
  public static String OPP_REV_REC_ALLOCATION_ERROR = '';
}