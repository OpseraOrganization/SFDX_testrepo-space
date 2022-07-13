/*************************************************************
@Name: PMDI_Constants
@Author: Accenture
@CreateDate: 30 Aug 2018.
@Description: This class contains constants used in apex code
@UsedBy: Many PMDI Classes and Triggers
******************************************************************/
public class PMDI_Constants {
	
	//Product Portfolios
	public static final String IP_ROUTING = 'IP Routing';
	public static final String FIXED_ACCESS_POL = 'Fixed Access - POL';
	public static final String FIXED_ACCESS_FBA = 'Fixed Access - FBA';
	public static final String NUAGE = 'Nuage';
	
	//Product states
	public static final String RELEASE_STATE = 'Release';
	public static final String RAMP_DOWN_STATE = 'Ramp Down';
	public static final String RAMP_UP_STATE = 'Ramp Up';
	public static final String IMPLEMENT_STATE = 'Implement';
	public static final String FIELD_MAINTENANCE_STATE = 'Field Maintenance';
	public static final String AVAILABLE_STATE = 'Available';
	public static final String OBSOLETE_STATE = 'Obsolete';
	public static final String CREATE_STATE = 'Create';
	public static final String MAINTAIN_STATE = 'Maintain';
	public static final String REJECTED_STATE = 'Rejected';
	
	//Batch apex variables
	public static final string BATCHAPEX_STRING = 'BatchApex';
	public static final string PROCCESSING_STRING = 'Processing';
	public static final string PREPARING_STRING = 'Preparing';
	public static final string HOLDING_STRING = 'Holding';
	public static final string QUEUED_STRING = 'Queued';
	public static final string PENDING_STRING = 'Pending';
	
	//static variable to handle recursion in product trigger
	public static Boolean productTriggerExecuteRecursion = false;
	public static Boolean priceListItemTriggerExecuteRecursion = false;
	
	//static variable to hold class and method names
	public static String EDP_SI_Staging = 'EDP_SI_Staging'; 
	public static String UPLOADTOSTAGINGTABLE = 'uploadToStagingTable';
	public static String BATCH_EDPDATALOADTOSTAGING = 'Batch_EDPDataLoadToStaging';
	public static String EDP_ResultEmail = 'EDP_ResultEmail';
	public static String sendEmail = 'sendEmail';
	public static String BATCH_ProductRelations='BATCH_ProductRelations';
	public static String ResultString = 'Result of batch execution';
	public static String errorString = '\n\nFailed Loads';
	public static String APIstring = '\n API : ';
	public static String RecordsProcessedString = '\n Number of Records Processed : ';
	public static String SLASH = ' \\ ';

	//PMDSOR Product2 Integration
	public static final String PMDSOR_SALES_ITEMS = 'SalesItems';
	public static final String PMDSOR_PRODUCT_CONFIGURATION_ITEMS = 'ProductConfigurationItems';
	public static final String PMDSOR_CUSTOM_SETTING_RESOURCE = 'PMDSOR_Resource';
	public static final String PMDSOR_CUSTOM_SETTING_SI = 'PMDSOR_SI';
	public static final String PMDSOR_CUSTOM_SETTING_PCI = 'PMDSOR_PCI';
	public static final String PMDSOR_SI_NSN_PUBLISHED_TO_QTC =  'NSN Published to QtC';
	public static final String PMDSOR_SI_NSN_SECONDARY_CATEGORY =  'NSN Secondary Category';
	public static final String PMDSOR_SI_NSN_TERTIARY_CATEGORY =  'NSN Tertiary Category';
	public static final String PMDSOR_SI_NSN_FINANCE_REPORTING_STRUCTURE =  'NSN Finance Reporting Structure';
	public static final String PMDSOR_PCI_VALID_SI_RELATION_INFO_RELTYPE =  'EBOM';
	public static final String PMDSOR_PCI_VALID_RELATION_INFO_RELTYPE =  'Classified Item';
	public static final String PMDSOR_PCI_VALID_RELATION_INFO_PARENTTYPE =  'Part Family';
	public static final String PMDSOR_PCI_VALID_RELATION_INFO_PARENTNAME =  'Portfolio Element';
	public static final string CLASS_NAME_Batch_PMDSoRToStagingDataLoad = 'Batch_PMDSoRToStagingDataLoad';
	public static final string CLASS_NAME_Batch_PMDSoRStagingDataToProductMaster = 'Batch_PMDSoRStagingDataToProductMaster';
	public static final string PMDSOR_STAGING_TO_PRODUCT_JOB_NAME = 'PMDSoRStaging To Product Master Data Job';
	public static final string PMDSOR_NOTIFICATION_SUBJECT = 'PMDSOR QTC Surround Attributes Automation Status';
	public static final Integer PMDSOR_PCI_RELATIONINFO_MAXSIZE = 1000;
}