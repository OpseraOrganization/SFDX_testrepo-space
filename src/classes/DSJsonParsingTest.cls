@IsTest

public class DSJsonParsingTest {
	private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.CREATE_DIRECT_SALES_OPPORTUNITY).getRecordTypeId();
	public static Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('CCRE Upsell Proposal').getRecordTypeId();
	private static  Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
	private static  Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
	 
	 
	 static testMethod void TestData() {
		Test.startTest();
		
		 List<DS_ObjectFieldjsonmap__c> DS_ObjectJsonList = new List<DS_ObjectFieldjsonmap__c>();
		
		//Final custom settings

		DS_ObjectFieldjsonmap__c setting1 = new DS_ObjectFieldjsonmap__c(name='Apttus_Proposal__Proposal__cLINENUMBER',
			Field_Object__c='Apttus_Config2__LineNumber__c',
			FieldDefinition__c='Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting1);
	
		DS_ObjectFieldjsonmap__c setting2 = new DS_ObjectFieldjsonmap__c(name = 'APT_QTY',
			Field_Object__c = 'Apttus_Config2__Quantity__c',
			FieldDefinition__c = 'Decimal',
			RecordDefinition__c = 'Datatype');
		
		DS_ObjectJsonList.add(setting2);		
		DS_ObjectFieldjsonmap__c setting3 = new DS_ObjectFieldjsonmap__c(name = 'CE_DATE',
			Field_Object__c = 'Contract_End_Date__c',
			FieldDefinition__c = 'Date',
			RecordDefinition__c = 'Datatype');
		
		DS_ObjectJsonList.add(setting3);
		
		DS_ObjectFieldjsonmap__c setting4 = new DS_ObjectFieldjsonmap__c(name = 'CFA_ATTRLABEL',
			Field_Object__c = 'attributes label',
			FieldDefinition__c = 'Attribute_Label__c',
			RecordDefinition__c = 'Customer_facing_Attribute__c');	
		
		DS_ObjectJsonList.add(setting4);
		
		DS_ObjectFieldjsonmap__c setting5 = new DS_ObjectFieldjsonmap__c(name = 'CFA_ATTRNAME',
			Field_Object__c = 'attributes name',
			FieldDefinition__c = 'Attribute_Name__c',
			RecordDefinition__c = 'Customer_facing_Attribute__c');	
		
		DS_ObjectJsonList.add(setting5);
		
		DS_ObjectFieldjsonmap__c setting6 = new DS_ObjectFieldjsonmap__c(name = 'CFA_ATTRVALUE',
			Field_Object__c = 'attributes value',
			FieldDefinition__c = 'Attribute_Value__c',
			RecordDefinition__c = 'Customer_facing_Attribute__c');
		
		DS_ObjectJsonList.add(setting6);
		
		DS_ObjectFieldjsonmap__c setting7 = new DS_ObjectFieldjsonmap__c(name = 'CFA_ATTRVISIBILITY',
			Field_Object__c = 'attributes visibility',
			FieldDefinition__c = 'Attribute_Visibility__c',
			RecordDefinition__c = 'Customer_facing_Attribute__c');
		
		DS_ObjectJsonList.add(setting7);
		
		DS_ObjectFieldjsonmap__c setting8 = new DS_ObjectFieldjsonmap__c(name = 'CFA_HEADEROBJ',
			Field_Object__c = 'header attribute',
			FieldDefinition__c = 'Customer_facing_Attribute__c',
			RecordDefinition__c = 'SOBJECT');
		
		DS_ObjectJsonList.add(setting8);
		
		DS_ObjectFieldjsonmap__c setting9 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.CFA_OBJECT,
			Field_Object__c = 'item attribute',
			FieldDefinition__c = 'Customer_facing_Attribute__c',
			RecordDefinition__c = 'SOBJECT');
		
		DS_ObjectJsonList.add(setting9);
		
		DS_ObjectFieldjsonmap__c setting10 = new DS_ObjectFieldjsonmap__c(name = 'CPE_DATE',
			Field_Object__c = 'Collection_Period_End_Date__c',
			FieldDefinition__c = 'Date',
			RecordDefinition__c = 'Datatype');
		
		DS_ObjectJsonList.add(setting10);
		
		DS_ObjectFieldjsonmap__c setting11 = new DS_ObjectFieldjsonmap__c(name = 'CPS_DATE',
			Field_Object__c = 'Collection_Period_Start_Date__c',
			FieldDefinition__c = 'Date',
			RecordDefinition__c = 'Datatype');
		
		DS_ObjectJsonList.add(setting11);
		
		DS_ObjectFieldjsonmap__c setting12 = new DS_ObjectFieldjsonmap__c(name = 'CRE_DATE',
			Field_Object__c = 'Creation_Date__c',
			FieldDefinition__c = 'Date',
			RecordDefinition__c = 'Datatype');
		
		DS_ObjectJsonList.add(setting12);
		
		DS_ObjectFieldjsonmap__c setting13 = new DS_ObjectFieldjsonmap__c(name = 'CS_DATE',
			Field_Object__c = 'Contract_Start_Date__c',
			FieldDefinition__c = 'Date',
			RecordDefinition__c = 'Datatype');
		
		DS_ObjectJsonList.add(setting13);
		
		DS_ObjectFieldjsonmap__c setting14 = new DS_ObjectFieldjsonmap__c(name = 'dp',
			FieldDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting14);
		
		DS_ObjectFieldjsonmap__c setting15 = new DS_ObjectFieldjsonmap__c(name = 'dpline_items',
			FieldDefinition__c = 'SWx_Upsell_Items__c');
		
		DS_ObjectJsonList.add(setting15);
		
		DS_ObjectFieldjsonmap__c setting16 = new DS_ObjectFieldjsonmap__c(name = 'DPSWX_BUNDLEID',
			Field_Object__c = 'bundle_id',
			FieldDefinition__c = 'Bundle_ID__c',
			RecordDefinition__c = 'SWx_Upsell_Items__c');
		
		DS_ObjectJsonList.add(setting16);
		
		DS_ObjectFieldjsonmap__c setting17 = new DS_ObjectFieldjsonmap__c(name = 'DPSWX_BUNDLEQTY',
			Field_Object__c = 'bundle_qty',
			FieldDefinition__c = 'Quantity__c',
			RecordDefinition__c = 'SWx_Upsell_Items__c');
		
		DS_ObjectJsonList.add(setting17);
		
		DS_ObjectFieldjsonmap__c setting18 = new DS_ObjectFieldjsonmap__c(name = 'DPSWX_CODE',
			Field_Object__c = 'code',
			FieldDefinition__c = 'Sales_Item_Code__c',
			RecordDefinition__c = 'SWx_Upsell_Items__c');
		
		DS_ObjectJsonList.add(setting18);
		
		DS_ObjectFieldjsonmap__c setting19 = new DS_ObjectFieldjsonmap__c(name = 'DPSWX_QUANTITY',
			Field_Object__c = 'quantity',
			FieldDefinition__c = 'Quantity__c',
			RecordDefinition__c = 'SWx_Upsell_Items__c');
		
		DS_ObjectJsonList.add(setting19);
		
		DS_ObjectFieldjsonmap__c setting20 = new DS_ObjectFieldjsonmap__c(name = 'DP_ACCOUNTID',
			Field_Object__c = 'account_id',
			FieldDefinition__c = 'Sold_To_Party__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting20);
		
		DS_ObjectFieldjsonmap__c setting21 = new DS_ObjectFieldjsonmap__c(name = 'DP_AGREEMENT',
			Field_Object__c = 'agreement',
			FieldDefinition__c = 'Frame_Contract__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		
		DS_ObjectJsonList.add(setting21);
		
		DS_ObjectFieldjsonmap__c setting22 = new DS_ObjectFieldjsonmap__c(name = 'DP_CATEGORYTYPE',
			Field_Object__c = 'category_type',
			FieldDefinition__c = 'Proposal_Recommendation_Type__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting22);
		
		DS_ObjectFieldjsonmap__c setting23 = new DS_ObjectFieldjsonmap__c(name = 'DP_CELLQUANTITY',
			Field_Object__c = 'cell_quantity',
			FieldDefinition__c = 'Identified_Cells__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting23);
		
		DS_ObjectFieldjsonmap__c setting24 = new DS_ObjectFieldjsonmap__c(name = 'DP_CREATEDATE',
			Field_Object__c = 'creation_date',
			FieldDefinition__c = 'Creation_Date__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting24);
		
		DS_ObjectFieldjsonmap__c setting25 = new DS_ObjectFieldjsonmap__c(name = 'DP_CREDATE',
			Field_Object__c = 'Date',
			FieldDefinition__c = 'Creation_Date__c',
			RecordDefinition__c = 'Datatype');
		
		DS_ObjectJsonList.add(setting25);
		
		DS_ObjectFieldjsonmap__c setting26 = new DS_ObjectFieldjsonmap__c(name = 'DP_ENDDATE',
			Field_Object__c = 'end_date',
			FieldDefinition__c = 'Collection_Period_End_Date__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting26);
		
		DS_ObjectFieldjsonmap__c setting27 = new DS_ObjectFieldjsonmap__c(name = 'DP_FILEREFERECEID',
			Field_Object__c = 'file_reference_id',
			FieldDefinition__c = 'Analytics_File_Refer_ID__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting27);
		
		DS_ObjectFieldjsonmap__c setting28 = new DS_ObjectFieldjsonmap__c(name = 'DP_OPPORTUNITY',
			Field_Object__c = 'opportunity',
			FieldDefinition__c = 'SWX_Reference_Opportunity__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting28);
		
		DS_ObjectFieldjsonmap__c setting29 = new DS_ObjectFieldjsonmap__c(name = 'DP_SCOPE',
			Field_Object__c = 'scope',
			FieldDefinition__c = 'Analysed_Cells__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting29);
		
		DS_ObjectFieldjsonmap__c setting30 = new DS_ObjectFieldjsonmap__c(name = 'DP_SOURCEID',
			Field_Object__c = 'source_id',
			FieldDefinition__c = 'Analytics_Source__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting30);
		
		DS_ObjectFieldjsonmap__c setting31 = new DS_ObjectFieldjsonmap__c(name = 'DP_STARTDATE',
			Field_Object__c = 'start_date',
			FieldDefinition__c = 'Collection_Period_Start_Date__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting31);
		
		DS_ObjectFieldjsonmap__c setting32 = new DS_ObjectFieldjsonmap__c(name = 'DP_UNWEIGHTEDVAL',
			Field_Object__c = 'Unweighted_Value__c',
			FieldDefinition__c = 'unweighted_value',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c'); 
		
		DS_ObjectJsonList.add(setting32);
		
		DS_ObjectFieldjsonmap__c setting33 = new DS_ObjectFieldjsonmap__c(name = 'DP_UNWEVAL',
			Field_Object__c = 'Decimal',
			FieldDefinition__c = 'Unweighted_Value__c',
			RecordDefinition__c = 'Datatype');
		
		DS_ObjectJsonList.add(setting33);
		
		DS_ObjectFieldjsonmap__c setting34 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.HEADER_CS,
			Field_Object__c = 'header');
		
		DS_ObjectJsonList.add(setting34);
		
		DS_ObjectFieldjsonmap__c setting35 = new DS_ObjectFieldjsonmap__c(name = 'IDE_CELLS',
			Field_Object__c = 'Identified_Cells__c',
			FieldDefinition__c = 'Decimal',
			RecordDefinition__c = 'Datatype');
		
		DS_ObjectJsonList.add(setting35);
		
		DS_ObjectFieldjsonmap__c setting36 = new DS_ObjectFieldjsonmap__c(name = 'JSON_ATRRIBUTES',
			Field_Object__c = 'line_items,bundle_id,bundle_qty,sales_item',
			FieldDefinition__c = 'code,quantity,item attribute,purchase_customer_validation',
			RecordDefinition__c = 'attributes visibility,start_date',
			Message__c = 'header,source_id,file_reference_id,account_id,creation_date, ,e,end_date,cell_quantity,scope,category_type,workflow_type,commercial_customer_validation,agreement,opportunity,header attribute,attributes name,attributes label,attributes value');
	
		DS_ObjectJsonList.add(setting36);
		
		DS_ObjectFieldjsonmap__c setting37 = new DS_ObjectFieldjsonmap__c(name = 'LINEITEMS_OBJECT_DP',
			Field_Object__c = 'line_items',
			FieldDefinition__c = 'SWx_Upsell_Items__c',
			RecordDefinition__c = 'SOBJECT');
		
		DS_ObjectJsonList.add(setting37);
		
		DS_ObjectFieldjsonmap__c setting38 = new DS_ObjectFieldjsonmap__c(name = 'LINEITEMS_OBJECT_QP',
			Field_Object__c = 'line_items',
			FieldDefinition__c = 'Apttus_Config2__LineItem__c',
			RecordDefinition__c = 'SOBJECT');
		
		DS_ObjectJsonList.add(setting38);
		
		DS_ObjectFieldjsonmap__c setting39 = new DS_ObjectFieldjsonmap__c(name = 'LINEITEM_MANDATORY',
			Field_Object__c = 'bundle_id',
			FieldDefinition__c = 'bundle_qty',
			RecordDefinition__c = 'MANDATORYFIELDS');
		
		DS_ObjectJsonList.add(setting39);
		
		DS_ObjectFieldjsonmap__c setting40 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.LINE_ITEM,
			FieldDefinition__c = 'line_items');
		
		DS_ObjectJsonList.add(setting40);
		
		DS_ObjectFieldjsonmap__c setting41 = new DS_ObjectFieldjsonmap__c(name = 'OPTIONITEM_MANDATORY',
			Field_Object__c = 'bundle_id,quantity',
			FieldDefinition__c = 'code',
			RecordDefinition__c = 'MANDATORYFIELDS');
		
		DS_ObjectJsonList.add(setting41);
		
		DS_ObjectFieldjsonmap__c setting42 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.QPLI_BUNDLEID,
			Field_Object__c = 'bundle_id',
			FieldDefinition__c = 'Apttus_Config2__ProductId__c',
			RecordDefinition__c = 'Apttus_Config2__LineItem__c');
		
		DS_ObjectJsonList.add(setting42);
		
		DS_ObjectFieldjsonmap__c setting43 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.QPLI_BUNDLEQTY,
			Field_Object__c = 'bundle_qty',
			FieldDefinition__c = 'Apttus_Config2__Quantity__c',
			RecordDefinition__c = 'Apttus_Config2__LineItem__c');
		
		DS_ObjectJsonList.add(setting43);
		
		DS_ObjectFieldjsonmap__c setting44 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.QPLI_CODE,
			Field_Object__c = 'code',
			FieldDefinition__c = 'Apttus_Config2__ProductOptionId__c',
			RecordDefinition__c = 'Apttus_Config2__LineItem__c');
		
		DS_ObjectJsonList.add(setting44);
		
		DS_ObjectFieldjsonmap__c setting45 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.QPLI_QUANTITY,
			Field_Object__c = 'quantity',
			FieldDefinition__c = 'Apttus_Config2__Quantity__c',
			RecordDefinition__c = 'Apttus_Config2__LineItem__c');
		
		DS_ObjectJsonList.add(setting45);
		
		DS_ObjectFieldjsonmap__c setting46 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.QP_ACCOUNTID,
			Field_Object__c = 'account_id',
			FieldDefinition__c = 'Sold_To_Party__c',
			RecordDefinition__c = 'Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting46);
		
		DS_ObjectFieldjsonmap__c setting47 = new DS_ObjectFieldjsonmap__c(name = 'QP_AGREEMENT',
			Field_Object__c = 'agreement',
			FieldDefinition__c = 'Agreement_Lookup__c',
			RecordDefinition__c = 'Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting47);
		
		DS_ObjectFieldjsonmap__c setting48 = new DS_ObjectFieldjsonmap__c(name = 'QP_CATEGORYTYPE',
			Field_Object__c = 'category_type',
			FieldDefinition__c = 'Proposal_Recommendation_Type__c',
			RecordDefinition__c = 'Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting48);
		
		DS_ObjectFieldjsonmap__c setting49 = new DS_ObjectFieldjsonmap__c(name = 'QP_CREATEDATE',
			Field_Object__c = 'creation_date',
			FieldDefinition__c = 'Creation_Date__c',
			RecordDefinition__c = 'Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting49);
		
		DS_ObjectFieldjsonmap__c setting50 = new DS_ObjectFieldjsonmap__c(name = 'QP_ENDDATE',
			Field_Object__c = 'end_date',
			FieldDefinition__c = 'Contract_End_Date__c',
			RecordDefinition__c = 'Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting50);
		
		DS_ObjectFieldjsonmap__c setting51 = new DS_ObjectFieldjsonmap__c(name = 'QP_FILEREFERECEID',
			Field_Object__c = 'file_reference_id',
			FieldDefinition__c = 'Analytics_File_Refer_ID__c',
			RecordDefinition__c = 'Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting51);
		
		DS_ObjectFieldjsonmap__c setting52 = new DS_ObjectFieldjsonmap__c(name = 'QP_OPPORTUNITY',
			Field_Object__c = 'opportunity',
			FieldDefinition__c = 'Apttus_Proposal__Opportunity__c',
			RecordDefinition__c = 'Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting52);
		
		DS_ObjectFieldjsonmap__c setting53 = new DS_ObjectFieldjsonmap__c(name = 'QP_SOURCEID',
			Field_Object__c = 'source_id',
			FieldDefinition__c = 'Analytics_Source__c',
			RecordDefinition__c = 'Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting53);
		
		DS_ObjectFieldjsonmap__c setting54 = new DS_ObjectFieldjsonmap__c(name = 'QP_STARTDATE',
			Field_Object__c = 'start_date',
			FieldDefinition__c = 'Contract_Start_Date__c',
			RecordDefinition__c = 'Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting54);
		
		DS_ObjectFieldjsonmap__c setting55 = new DS_ObjectFieldjsonmap__c(name = 'QTY',
			Field_Object__c = 'Quantity__c',
			FieldDefinition__c = 'Decimal',
			RecordDefinition__c = 'Datatype');
		
		DS_ObjectJsonList.add(setting55);
		
		DS_ObjectFieldjsonmap__c setting56 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.quote,
			FieldDefinition__c = 'Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting56);
		
		DS_ObjectFieldjsonmap__c setting57 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.quoteline_items,
			Field_Object__c = '',
			FieldDefinition__c = 'Apttus_Config2__LineItem__c',
			RecordDefinition__c = '');
		
		DS_ObjectJsonList.add(setting57);
		
		DS_ObjectFieldjsonmap__c setting58 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.SALES_ITEM,
			Field_Object__c = 'sales_item',
			FieldDefinition__c = 'SWx_Upsell_Items__c',
			RecordDefinition__c = 'SOBJECT');
		
		DS_ObjectJsonList.add(setting58);
		
		DS_ObjectFieldjsonmap__c setting59 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.STAGING_INSERT_CS,
			Sync__c = True);
		
		
		DS_ObjectJsonList.add(setting59);
		
		DS_ObjectFieldjsonmap__c setting60 = new DS_ObjectFieldjsonmap__c(name = 'SWx_Upsell_Proposal__cLINENUMBER',
			Field_Object__c = 'LineNumber__c');
		
		DS_ObjectJsonList.add(setting60);
		
		DS_ObjectFieldjsonmap__c setting61 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.WORKFLOWTYPES_CS,
			Message__c = 'dp,quote');
		
		DS_ObjectJsonList.add(setting61);
		
		DS_ObjectFieldjsonmap__c setting62 = new DS_ObjectFieldjsonmap__c(name = 'WORKFLOW_DP',
			Field_Object__c = 'dp',
			FieldDefinition__c = 'SWx_Upsell_Proposal__c',
			RecordDefinition__c = 'SOBJECT');
		
		DS_ObjectJsonList.add(setting62);
		
		DS_ObjectFieldjsonmap__c setting63 = new DS_ObjectFieldjsonmap__c(name = 'WORKFLOW_QUOTE',
			Field_Object__c = 'quote',
			FieldDefinition__c = 'Apttus_Proposal__Proposal__c',
			RecordDefinition__c = 'SOBJECT');
		
		DS_ObjectJsonList.add(setting63);
		
		DS_ObjectFieldjsonmap__c setting64 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.WORKFLOW_TYPE,
			Field_Object__c = 'workflow_type');
		
		
		DS_ObjectJsonList.add(setting64);
		
		database.insert(DS_ObjectJsonList);
		
		
		
		List<DS_Json_Mandatory_fields__c> DS_JsonMandFieldsList = new List<DS_Json_Mandatory_fields__c>();
		
		DS_Json_Mandatory_fields__c setting65 = new DS_Json_Mandatory_fields__c(name = 'account_id');
		
		DS_JsonMandFieldsList.add(setting65);

		DS_Json_Mandatory_fields__c setting66 = new DS_Json_Mandatory_fields__c(name = 'file_reference_id');
		
		DS_JsonMandFieldsList.add(setting66);
		
		database.insert(DS_JsonMandFieldsList);
		
		List<DS_JSON_Conditional_Fields__c> DS_JSONCondFieldsList = new List<DS_JSON_Conditional_Fields__c>();
		
		DS_JSON_Conditional_Fields__c setting67 = new DS_JSON_Conditional_Fields__c(name = 'quote',
			Conditional_Fields_API_Name__c = 'agreement,opportunity');
		
		DS_JSONCondFieldsList.add(setting67);
		
		database.insert(DS_JSONCondFieldsList);
		
		List<Account> accounts=new List<Account>();
		Account Customeraccount = NF_TestDataFactory.createAccount('1TestNONV0000');
		Customeraccount.RecordTypeId=custRecordTypeId;
		accounts.add(Customeraccount);
		Database.insert(accounts);
		
		Account LegalEntityaccount = NF_TestDataFactory.createAccount('10308719999AIA');
		LegalEntityaccount.Accountnumber='1323242223i';
		LegalEntityaccount.Recordtypeid=LERecordTypeId;
		LegalEntityaccount.ParentId=accounts[0].Id;
		LegalEntityaccount.Default_Legal_Entity__c = true;
		LegalEntityaccount.Partner_Program__c=null;
		accounts.add(LegalEntityaccount);
		Database.upsert(accounts); 
		
		/*
		Opportunity Opportunity_v1= NF_TestDataFactory.createOpportunity(accounts[0].Id, 'Create offer (bid)', 'Offer in Progress', Date.today().addDays(10), 7000000);
		Opportunity_v1.Lead_BG__c='NSW';
		Opportunity_v1.RecordTypeId = oppDirectRecordTypeId;
		Opportunity_v1.Business_Type__c = 'Standard Opportunity';
		*/
		Opportunity Opportunity_v1= NF_TestDataFactory.createOpportunity(accounts[0].Id, 'Execute (Start Delivery)', 'In Execution', Date.today().addDays(10), 7000000);
		Opportunity_v1.Lead_BG__c='NSW';
		Opportunity_v1.Opportunity_ID__c='19.IN.856951';
		Opportunity_v1.RecordTypeId = oppDirectRecordTypeId;
		Opportunity_v1.Business_Type__c = 'Standard Opportunity';
		/*
		oppty.Opportunity_ID__c = '19.IN.856950';
		oppty.StageName = 'Execute (Start Delivery)';
		oppty.Phase_Status__c = 'In Execution';
		*/
		Database.insert(Opportunity_v1);
		
		List<product2> productObj2 = TestDataFactory.productCreation(3);
		productObj2[0].ProductCode = 'RL000277.T';
		productObj2[0].Apttus_Config2__ConfigurationType__c = 'Standalone';
		productObj2[1].ProductCode = 'var-opt';
		productObj2[1].name = 'Variable Option';
		productObj2[1].Apttus_Config2__ConfigurationType__c = 'Option';
		productObj2[2].ProductCode = 'vb';
		productObj2[2].name = 'Variable Bundle';
		productObj2[2].Apttus_Config2__ConfigurationType__c = 'Bundle';
		database.insert(productObj2);
		 
		 String json = '{'+
		'  \"header\":{'+
		'   '+
		' '+
		'			\"source_id\":\"CXM-ASDFG\",'+
		'   '+
		'			\"file_reference_id\":\"LTE AIR Interface AR\",'+
		'   '+
		'			\"account_id\":\"1323242223i\",'+
		'   '+
		'			\"creation_date\":\"2018-10-29\",'+
		'  '+
		'	\"start_date\":\"2018-10-29\",'+
		'  '+
		'	\"end_date\":\"2018-10-29\",'+
		 '  '+   
		'	\"workflow_type\" : \"Quote\",'+
		'   '+
		'			\"category_Type\":\"SW Recommendation\",'+
		'   '+	
		'	\"Agreement\" : \"00000024.0\",'+
		'   '+
		'			\"Opportunity\" : \"19.IN.856951\",'+
		'   '+	
		'			\"cell_quantity\":\"1\",'+
		'	'+
		'	\"Header attribute\" : ['+
		'	'+	
		'	{'+
		'	'+
		'			\"attributes Name\" : \"Site code\",'+
		'	'+
		'			\"attributes Label\" : \"Site Code\",'+
		'	'+
		'			\"attributes Value\" : \"SiteCodeDetails\",'+
		'	'+
		'			\"attributes Visibility\" : \"Yes\"'+
		'		}'+
		'	]'+			
		'  } ,'+
		' '+
		' '+
		 '  \"line_items\":['+
  '  {'+
  '  '+
  '	  \"bundle_id\": \"vb\",'+
	'	'+
  '	\"bundle_qty\": \"1\",'+			

  '  '+
  '	\"sales_item\": ['+
  '	'+  
  '	{'+
  '  '+
  '	\"Code\":\"var-opt\",'+
  '  '+
  '	\"quantity\": \"1\"'+
  '	}'+  
  '	],'+ 


  '	\"item attribute\" : ['+ 
  '	'+
  '	{'+
  '	\"attributes Name\" : \"Site code\",'+
  '  '+  
  '	\"attributes Label\" : \"Site Code\",'+
  '  '+
  '	\"attributes Value\" : \"SiteCodeDetails\",'+
  '  '+
  '	\"attributes Visibility\" : \"Yes\"'+
  '	}'+
  '	]'+

  '	},'+
  '	{'+
  '	  \"bundle_id\": \"\",'+
  '	  \"bundle_qty\": \"\",'+			

  '  '+
  '	\"sales_item\": ['+
  '	'+  
	'	{'+
  '  '+
  '	\"Code\":\"RL000277.T\",'+
  '  '+
  '	\"quantity\": \"1\"'+
  '	}'+
  '	],'+ 


  '	\"item attribute\" : ['+ 
  '	'+
  '	{'+
  '	\"attributes Name\" : \"Use Case\",'+
  '  '+  
  '	\"attributes Label\" : \"Use Case\",'+
  '  '+
  '	\"attributes Value\" : \"Energy Efficiency\",'+
  '  '+
  '	\"attributes Visibility\" : \"Yes\"'+
  '	}'+
  '	]'+
  '	}'+

  '  ]'+
		'}';   
		
		List<Apttus_Config2__ProductOptionComponent__c> OptionComlist=new  List<Apttus_Config2__ProductOptionComponent__c>();
	 
		Apttus_Config2__ProductOptionComponent__c prodoptioncmp = TestDataFactory.CreateproductOptionComponent(productObj2[1].id,1)[0];
		prodoptioncmp.Apttus_Config2__ParentProductId__c = productObj2[2].id;
		prodoptioncmp.Apttus_Config2__Sequence__c = 5613;
		Apttus_Config2__ProductOptionComponent__c prodoptioncmp1 = TestDataFactory.CreateproductOptionComponent(productObj2[0].id,1)[0];
		prodoptioncmp1.Apttus_Config2__Sequence__c = 5614;
		Apttus_Config2__ProductOptionComponent__c prodoptioncmp2 = TestDataFactory.CreateproductOptionComponent(productObj2[2].id,1)[0];
		prodoptioncmp2.Apttus_Config2__Sequence__c = 5616;
		OptionComlist.add(prodoptioncmp);
		OptionComlist.add(prodoptioncmp1);
		OptionComlist.add(prodoptioncmp2);
		database.insert(OptionComlist);
		
		List<Apttus_Config2__PriceList__c> priceListObj = TestDataFactory.priceList(1);
		priceListObj[0].Apttus_Config2__AccountId__c = LegalEntityaccount.id;
		priceListObj[0].Type__c  = 'CXM';
		database.insert(priceListObj[0]);
		
		List<Apttus_Config2__PriceListItem__c> priceListItemObj = TestDataFactory.createPriceListItem(3,priceListObj[0]);
		priceListItemObj[0].Apttus_Config2__PriceListId__c = priceListObj[0].id;
		priceListItemObj[0].Apttus_Config2__ProductId__c = productObj2[0].id;
		priceListItemObj[1].Apttus_Config2__PriceListId__c = priceListObj[0].id;
		priceListItemObj[1].Apttus_Config2__ProductId__c = productObj2[1].id;
		priceListItemObj[2].Apttus_Config2__PriceListId__c = priceListObj[0].id;
		priceListItemObj[2].Apttus_Config2__ProductId__c = productObj2[2].id;
		
		database.insert(priceListItemObj);
		
		Apttus__APTS_Agreement__c agreementobj= new Apttus__APTS_Agreement__c();
		agreementobj.Apttus__Agreement_Number__c='00000024';
		agreementobj.Name= 'New demo';
		agreementobj.Apttus__Account__c = accounts[1].id;
		agreementobj.CurrencyIsoCode = 'EUR';
		agreementobj.Delivery_System__c = 'Scratch Order via P20';
		agreementobj.ERP__c = 'P20';
		agreementobj.Sales_Mode__c = 'Corporate Sales Mode';
		agreementobj.Confidence_Level__c = 'Low Level';
		agreementobj.Apttus__Contract_Start_Date__c=System.today();
		agreementobj.Apttus__Contract_End_Date__c=System.today()+30;
		agreementobj.Apttus_CMConfig__PriceListId__c = priceListObj[0].id;
		database.insert(agreementobj);
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/DS/V1/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
		
		DSJsonParsing.Deserializejson();
		DSJsonParsing.getPickListValuesIntoList();
		DSJsonParsing.ResponseChange(200,'test','test1');
		Test.stopTest(); 

	}
	
	static testMethod void TestData1() {
		Test.startTest();
		
		 List<DS_ObjectFieldjsonmap__c> DS_ObjectJsonList = new List<DS_ObjectFieldjsonmap__c>();
		
		//Final custom settings

		DS_ObjectFieldjsonmap__c setting1 = new DS_ObjectFieldjsonmap__c(name='Apttus_Proposal__Proposal__cLINENUMBER',
			Field_Object__c='Apttus_Config2__LineNumber__c',
			FieldDefinition__c='Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting1);
	
		DS_ObjectFieldjsonmap__c setting2 = new DS_ObjectFieldjsonmap__c(name = 'APT_QTY',
			Field_Object__c = 'Apttus_Config2__Quantity__c',
			FieldDefinition__c = 'Decimal',
			RecordDefinition__c = 'Datatype');
		
		DS_ObjectJsonList.add(setting2);		
		DS_ObjectFieldjsonmap__c setting3 = new DS_ObjectFieldjsonmap__c(name = 'CE_DATE',
			Field_Object__c = 'Contract_End_Date__c',
			FieldDefinition__c = 'Date',
			RecordDefinition__c = 'Datatype');
		
		DS_ObjectJsonList.add(setting3);
		
		DS_ObjectFieldjsonmap__c setting4 = new DS_ObjectFieldjsonmap__c(name = 'CFA_ATTRLABEL',
			Field_Object__c = 'attributes label',
			FieldDefinition__c = 'Attribute_Label__c',
			RecordDefinition__c = 'Customer_facing_Attribute__c');	
		
		DS_ObjectJsonList.add(setting4);
		
		DS_ObjectFieldjsonmap__c setting5 = new DS_ObjectFieldjsonmap__c(name = 'CFA_ATTRNAME',
			Field_Object__c = 'attributes name',
			FieldDefinition__c = 'Attribute_Name__c',
			RecordDefinition__c = 'Customer_facing_Attribute__c');	
		
		DS_ObjectJsonList.add(setting5);
		
		DS_ObjectFieldjsonmap__c setting6 = new DS_ObjectFieldjsonmap__c(name = 'CFA_ATTRVALUE',
			Field_Object__c = 'attributes value',
			FieldDefinition__c = 'Attribute_Value__c',
			RecordDefinition__c = 'Customer_facing_Attribute__c');
		
		DS_ObjectJsonList.add(setting6);
		
		DS_ObjectFieldjsonmap__c setting7 = new DS_ObjectFieldjsonmap__c(name = 'CFA_ATTRVISIBILITY',
			Field_Object__c = 'attributes visibility',
			FieldDefinition__c = 'Attribute_Visibility__c',
			RecordDefinition__c = 'Customer_facing_Attribute__c');
		
		DS_ObjectJsonList.add(setting7);
		
		DS_ObjectFieldjsonmap__c setting8 = new DS_ObjectFieldjsonmap__c(name = 'CFA_HEADEROBJ',
			Field_Object__c = 'header attribute',
			FieldDefinition__c = 'Customer_facing_Attribute__c',
			RecordDefinition__c = 'SOBJECT');
		
		DS_ObjectJsonList.add(setting8);
		
		DS_ObjectFieldjsonmap__c setting9 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.CFA_OBJECT,
			Field_Object__c = 'item attribute',
			FieldDefinition__c = 'Customer_facing_Attribute__c',
			RecordDefinition__c = 'SOBJECT');
		
		DS_ObjectJsonList.add(setting9);
		
		DS_ObjectFieldjsonmap__c setting10 = new DS_ObjectFieldjsonmap__c(name = 'CPE_DATE',
			Field_Object__c = 'Collection_Period_End_Date__c',
			FieldDefinition__c = 'Date',
			RecordDefinition__c = 'Datatype');
		
		DS_ObjectJsonList.add(setting10);
		
		DS_ObjectFieldjsonmap__c setting11 = new DS_ObjectFieldjsonmap__c(name = 'CPS_DATE',
			Field_Object__c = 'Collection_Period_Start_Date__c',
			FieldDefinition__c = 'Date',
			RecordDefinition__c = 'Datatype');
		
		DS_ObjectJsonList.add(setting11);
		
		DS_ObjectFieldjsonmap__c setting12 = new DS_ObjectFieldjsonmap__c(name = 'CRE_DATE',
			Field_Object__c = 'Creation_Date__c',
			FieldDefinition__c = 'Date',
			RecordDefinition__c = 'Datatype');
		
		DS_ObjectJsonList.add(setting12);
		
		DS_ObjectFieldjsonmap__c setting13 = new DS_ObjectFieldjsonmap__c(name = 'CS_DATE',
			Field_Object__c = 'Contract_Start_Date__c',
			FieldDefinition__c = 'Date',
			RecordDefinition__c = 'Datatype');
		
		DS_ObjectJsonList.add(setting13);
		
		DS_ObjectFieldjsonmap__c setting14 = new DS_ObjectFieldjsonmap__c(name = 'dp',
			FieldDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting14);
		
		DS_ObjectFieldjsonmap__c setting15 = new DS_ObjectFieldjsonmap__c(name = 'dpline_items',
			FieldDefinition__c = 'SWx_Upsell_Items__c');
		
		DS_ObjectJsonList.add(setting15);
		
		DS_ObjectFieldjsonmap__c setting16 = new DS_ObjectFieldjsonmap__c(name = 'DPSWX_BUNDLEID',
			Field_Object__c = 'bundle_id',
			FieldDefinition__c = 'Bundle_ID__c',
			RecordDefinition__c = 'SWx_Upsell_Items__c');
		
		DS_ObjectJsonList.add(setting16);
		
		DS_ObjectFieldjsonmap__c setting17 = new DS_ObjectFieldjsonmap__c(name = 'DPSWX_BUNDLEQTY',
			Field_Object__c = 'bundle_qty',
			FieldDefinition__c = 'Quantity__c',
			RecordDefinition__c = 'SWx_Upsell_Items__c');
		
		DS_ObjectJsonList.add(setting17);
		
		DS_ObjectFieldjsonmap__c setting18 = new DS_ObjectFieldjsonmap__c(name = 'DPSWX_CODE',
			Field_Object__c = 'code',
			FieldDefinition__c = 'Sales_Item_Code__c',
			RecordDefinition__c = 'SWx_Upsell_Items__c');
		
		DS_ObjectJsonList.add(setting18);
		
		DS_ObjectFieldjsonmap__c setting19 = new DS_ObjectFieldjsonmap__c(name = 'DPSWX_QUANTITY',
			Field_Object__c = 'quantity',
			FieldDefinition__c = 'Quantity__c',
			RecordDefinition__c = 'SWx_Upsell_Items__c');
		
		DS_ObjectJsonList.add(setting19);
		
		DS_ObjectFieldjsonmap__c setting20 = new DS_ObjectFieldjsonmap__c(name = 'DP_ACCOUNTID',
			Field_Object__c = 'account_id',
			FieldDefinition__c = 'Sold_To_Party__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting20);
		
		DS_ObjectFieldjsonmap__c setting21 = new DS_ObjectFieldjsonmap__c(name = 'DP_AGREEMENT',
			Field_Object__c = 'agreement',
			FieldDefinition__c = 'Frame_Contract__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		
		DS_ObjectJsonList.add(setting21);
		
		DS_ObjectFieldjsonmap__c setting22 = new DS_ObjectFieldjsonmap__c(name = 'DP_CATEGORYTYPE',
			Field_Object__c = 'category_type',
			FieldDefinition__c = 'Proposal_Recommendation_Type__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting22);
		
		DS_ObjectFieldjsonmap__c setting23 = new DS_ObjectFieldjsonmap__c(name = 'DP_CELLQUANTITY',
			Field_Object__c = 'cell_quantity',
			FieldDefinition__c = 'Identified_Cells__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting23);
		
		DS_ObjectFieldjsonmap__c setting24 = new DS_ObjectFieldjsonmap__c(name = 'DP_CREATEDATE',
			Field_Object__c = 'creation_date',
			FieldDefinition__c = 'Creation_Date__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting24);
		
		DS_ObjectFieldjsonmap__c setting25 = new DS_ObjectFieldjsonmap__c(name = 'DP_CREDATE',
			Field_Object__c = 'Date',
			FieldDefinition__c = 'Creation_Date__c',
			RecordDefinition__c = 'Datatype');
		
		DS_ObjectJsonList.add(setting25);
		
		DS_ObjectFieldjsonmap__c setting26 = new DS_ObjectFieldjsonmap__c(name = 'DP_ENDDATE',
			Field_Object__c = 'end_date',
			FieldDefinition__c = 'Collection_Period_End_Date__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting26);
		
		DS_ObjectFieldjsonmap__c setting27 = new DS_ObjectFieldjsonmap__c(name = 'DP_FILEREFERECEID',
			Field_Object__c = 'file_reference_id',
			FieldDefinition__c = 'Analytics_File_Refer_ID__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting27);
		
		DS_ObjectFieldjsonmap__c setting28 = new DS_ObjectFieldjsonmap__c(name = 'DP_OPPORTUNITY',
			Field_Object__c = 'opportunity',
			FieldDefinition__c = 'SWX_Reference_Opportunity__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting28);
		
		DS_ObjectFieldjsonmap__c setting29 = new DS_ObjectFieldjsonmap__c(name = 'DP_SCOPE',
			Field_Object__c = 'scope',
			FieldDefinition__c = 'Analysed_Cells__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting29);
		
		DS_ObjectFieldjsonmap__c setting30 = new DS_ObjectFieldjsonmap__c(name = 'DP_SOURCEID',
			Field_Object__c = 'source_id',
			FieldDefinition__c = 'Analytics_Source__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting30);
		
		DS_ObjectFieldjsonmap__c setting31 = new DS_ObjectFieldjsonmap__c(name = 'DP_STARTDATE',
			Field_Object__c = 'start_date',
			FieldDefinition__c = 'Collection_Period_Start_Date__c',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c');
		
		DS_ObjectJsonList.add(setting31);
		
		DS_ObjectFieldjsonmap__c setting32 = new DS_ObjectFieldjsonmap__c(name = 'DP_UNWEIGHTEDVAL',
			Field_Object__c = 'Unweighted_Value__c',
			FieldDefinition__c = 'unweighted_value',
			RecordDefinition__c = 'SWx_Upsell_Proposal__c'); 
		
		DS_ObjectJsonList.add(setting32);
		
		DS_ObjectFieldjsonmap__c setting33 = new DS_ObjectFieldjsonmap__c(name = 'DP_UNWEVAL',
			Field_Object__c = 'Decimal',
			FieldDefinition__c = 'Unweighted_Value__c',
			RecordDefinition__c = 'Datatype');
		
		DS_ObjectJsonList.add(setting33);
		
		DS_ObjectFieldjsonmap__c setting34 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.HEADER_CS,
			Field_Object__c = 'header');
		
		DS_ObjectJsonList.add(setting34);
		
		DS_ObjectFieldjsonmap__c setting35 = new DS_ObjectFieldjsonmap__c(name = 'IDE_CELLS',
			Field_Object__c = 'Identified_Cells__c',
			FieldDefinition__c = 'Decimal',
			RecordDefinition__c = 'Datatype');
		
		DS_ObjectJsonList.add(setting35);
		
		DS_ObjectFieldjsonmap__c setting36 = new DS_ObjectFieldjsonmap__c(name = 'JSON_ATRRIBUTES',
			Field_Object__c = 'line_items,bundle_id,bundle_qty,sales_item',
			FieldDefinition__c = 'code,quantity,item attribute,purchase_customer_validation',
			RecordDefinition__c = 'attributes visibility,start_date',
			Message__c = 'header,source_id,file_reference_id,account_id,creation_date, ,e,end_date,cell_quantity,scope,category_type,workflow_type,commercial_customer_validation,agreement,opportunity,header attribute,attributes name,attributes label,attributes value');
	
		DS_ObjectJsonList.add(setting36);
		
		DS_ObjectFieldjsonmap__c setting37 = new DS_ObjectFieldjsonmap__c(name = 'LINEITEMS_OBJECT_DP',
			Field_Object__c = 'line_items',
			FieldDefinition__c = 'SWx_Upsell_Items__c',
			RecordDefinition__c = 'SOBJECT');
		
		DS_ObjectJsonList.add(setting37);
		
		DS_ObjectFieldjsonmap__c setting38 = new DS_ObjectFieldjsonmap__c(name = 'LINEITEMS_OBJECT_QP',
			Field_Object__c = 'line_items',
			FieldDefinition__c = 'Apttus_Config2__LineItem__c',
			RecordDefinition__c = 'SOBJECT');
		
		DS_ObjectJsonList.add(setting38);
		
		DS_ObjectFieldjsonmap__c setting39 = new DS_ObjectFieldjsonmap__c(name = 'LINEITEM_MANDATORY',
			Field_Object__c = 'bundle_id',
			FieldDefinition__c = 'bundle_qty',
			RecordDefinition__c = 'MANDATORYFIELDS');
		
		DS_ObjectJsonList.add(setting39);
		
		DS_ObjectFieldjsonmap__c setting40 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.LINE_ITEM,
			FieldDefinition__c = 'line_items');
		
		DS_ObjectJsonList.add(setting40);
		
		DS_ObjectFieldjsonmap__c setting41 = new DS_ObjectFieldjsonmap__c(name = 'OPTIONITEM_MANDATORY',
			Field_Object__c = 'bundle_id,quantity',
			FieldDefinition__c = 'code',
			RecordDefinition__c = 'MANDATORYFIELDS');
		
		DS_ObjectJsonList.add(setting41);
		
		DS_ObjectFieldjsonmap__c setting42 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.QPLI_BUNDLEID,
			Field_Object__c = 'bundle_id',
			FieldDefinition__c = 'Apttus_Config2__ProductId__c',
			RecordDefinition__c = 'Apttus_Config2__LineItem__c');
		
		DS_ObjectJsonList.add(setting42);
		
		DS_ObjectFieldjsonmap__c setting43 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.QPLI_BUNDLEQTY,
			Field_Object__c = 'bundle_qty',
			FieldDefinition__c = 'Apttus_Config2__Quantity__c',
			RecordDefinition__c = 'Apttus_Config2__LineItem__c');
		
		DS_ObjectJsonList.add(setting43);
		
		DS_ObjectFieldjsonmap__c setting44 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.QPLI_CODE,
			Field_Object__c = 'code',
			FieldDefinition__c = 'Apttus_Config2__ProductOptionId__c',
			RecordDefinition__c = 'Apttus_Config2__LineItem__c');
		
		DS_ObjectJsonList.add(setting44);
		
		DS_ObjectFieldjsonmap__c setting45 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.QPLI_QUANTITY,
			Field_Object__c = 'quantity',
			FieldDefinition__c = 'Apttus_Config2__Quantity__c',
			RecordDefinition__c = 'Apttus_Config2__LineItem__c');
		
		DS_ObjectJsonList.add(setting45);
		
		DS_ObjectFieldjsonmap__c setting46 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.QP_ACCOUNTID,
			Field_Object__c = 'account_id',
			FieldDefinition__c = 'Sold_To_Party__c',
			RecordDefinition__c = 'Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting46);
		
		DS_ObjectFieldjsonmap__c setting47 = new DS_ObjectFieldjsonmap__c(name = 'QP_AGREEMENT',
			Field_Object__c = 'agreement',
			FieldDefinition__c = 'Agreement_Lookup__c',
			RecordDefinition__c = 'Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting47);
		
		DS_ObjectFieldjsonmap__c setting48 = new DS_ObjectFieldjsonmap__c(name = 'QP_CATEGORYTYPE',
			Field_Object__c = 'category_type',
			FieldDefinition__c = 'Proposal_Recommendation_Type__c',
			RecordDefinition__c = 'Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting48);
		
		DS_ObjectFieldjsonmap__c setting49 = new DS_ObjectFieldjsonmap__c(name = 'QP_CREATEDATE',
			Field_Object__c = 'creation_date',
			FieldDefinition__c = 'Creation_Date__c',
			RecordDefinition__c = 'Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting49);
		
		DS_ObjectFieldjsonmap__c setting50 = new DS_ObjectFieldjsonmap__c(name = 'QP_ENDDATE',
			Field_Object__c = 'end_date',
			FieldDefinition__c = 'Contract_End_Date__c',
			RecordDefinition__c = 'Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting50);
		
		DS_ObjectFieldjsonmap__c setting51 = new DS_ObjectFieldjsonmap__c(name = 'QP_FILEREFERECEID',
			Field_Object__c = 'file_reference_id',
			FieldDefinition__c = 'Analytics_File_Refer_ID__c',
			RecordDefinition__c = 'Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting51);
		
		DS_ObjectFieldjsonmap__c setting52 = new DS_ObjectFieldjsonmap__c(name = 'QP_OPPORTUNITY',
			Field_Object__c = 'opportunity',
			FieldDefinition__c = 'Apttus_Proposal__Opportunity__c',
			RecordDefinition__c = 'Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting52);
		
		DS_ObjectFieldjsonmap__c setting53 = new DS_ObjectFieldjsonmap__c(name = 'QP_SOURCEID',
			Field_Object__c = 'source_id',
			FieldDefinition__c = 'Analytics_Source__c',
			RecordDefinition__c = 'Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting53);
		
		DS_ObjectFieldjsonmap__c setting54 = new DS_ObjectFieldjsonmap__c(name = 'QP_STARTDATE',
			Field_Object__c = 'start_date',
			FieldDefinition__c = 'Contract_Start_Date__c',
			RecordDefinition__c = 'Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting54);
		
		DS_ObjectFieldjsonmap__c setting55 = new DS_ObjectFieldjsonmap__c(name = 'QTY',
			Field_Object__c = 'Quantity__c',
			FieldDefinition__c = 'Decimal',
			RecordDefinition__c = 'Datatype');
		
		DS_ObjectJsonList.add(setting55);
		
		DS_ObjectFieldjsonmap__c setting56 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.quote,
			FieldDefinition__c = 'Apttus_Proposal__Proposal__c');
		
		DS_ObjectJsonList.add(setting56);
		
		DS_ObjectFieldjsonmap__c setting57 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.quoteline_items,
			Field_Object__c = '',
			FieldDefinition__c = 'Apttus_Config2__LineItem__c',
			RecordDefinition__c = '');
		
		DS_ObjectJsonList.add(setting57);
		
		DS_ObjectFieldjsonmap__c setting58 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.SALES_ITEM,
			Field_Object__c = 'sales_item',
			FieldDefinition__c = 'SWx_Upsell_Items__c',
			RecordDefinition__c = 'SOBJECT');
		
		DS_ObjectJsonList.add(setting58);
		
		DS_ObjectFieldjsonmap__c setting59 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.STAGING_INSERT_CS,
			Sync__c = True);
		
		
		DS_ObjectJsonList.add(setting59);
		
		DS_ObjectFieldjsonmap__c setting60 = new DS_ObjectFieldjsonmap__c(name = 'SWx_Upsell_Proposal__cLINENUMBER',
			Field_Object__c = 'LineNumber__c');
		
		DS_ObjectJsonList.add(setting60);
		
		DS_ObjectFieldjsonmap__c setting61 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.WORKFLOWTYPES_CS,
			Message__c = 'dp,quote');
		
		DS_ObjectJsonList.add(setting61);
		
		DS_ObjectFieldjsonmap__c setting62 = new DS_ObjectFieldjsonmap__c(name = 'WORKFLOW_DP',
			Field_Object__c = 'dp',
			FieldDefinition__c = 'SWx_Upsell_Proposal__c',
			RecordDefinition__c = 'SOBJECT');
		
		DS_ObjectJsonList.add(setting62);
		
		DS_ObjectFieldjsonmap__c setting63 = new DS_ObjectFieldjsonmap__c(name = 'WORKFLOW_QUOTE',
			Field_Object__c = 'quote',
			FieldDefinition__c = 'Apttus_Proposal__Proposal__c',
			RecordDefinition__c = 'SOBJECT');
		
		DS_ObjectJsonList.add(setting63);
		
		DS_ObjectFieldjsonmap__c setting64 = new DS_ObjectFieldjsonmap__c(name = GlobalConstants.WORKFLOW_TYPE,
			Field_Object__c = 'workflow_type');
		
		
		DS_ObjectJsonList.add(setting64);
		
		database.insert(DS_ObjectJsonList);
		
		
		
		List<DS_Json_Mandatory_fields__c> DS_JsonMandFieldsList = new List<DS_Json_Mandatory_fields__c>();
		
		DS_Json_Mandatory_fields__c setting65 = new DS_Json_Mandatory_fields__c(name = 'account_id');
		
		DS_JsonMandFieldsList.add(setting65);

		DS_Json_Mandatory_fields__c setting66 = new DS_Json_Mandatory_fields__c(name = 'file_reference_id');
		
		DS_JsonMandFieldsList.add(setting66);
		
		database.insert(DS_JsonMandFieldsList);
		
		List<DS_JSON_Conditional_Fields__c> DS_JSONCondFieldsList = new List<DS_JSON_Conditional_Fields__c>();
		
		DS_JSON_Conditional_Fields__c setting67 = new DS_JSON_Conditional_Fields__c(name = 'quote',
			Conditional_Fields_API_Name__c = 'agreement,opportunity');
		
		DS_JSONCondFieldsList.add(setting67);
		
		database.insert(DS_JSONCondFieldsList);
		
		List<Account> accounts=new List<Account>();
		Account Customeraccount = NF_TestDataFactory.createAccount('1TestNONV0000');
		Customeraccount.RecordTypeId=custRecordTypeId;
		accounts.add(Customeraccount);
		Database.insert(accounts);
		
		Account LegalEntityaccount = NF_TestDataFactory.createAccount('10308719999AIA');
		LegalEntityaccount.Accountnumber='1323242223i';
		LegalEntityaccount.Recordtypeid=LERecordTypeId;
		LegalEntityaccount.ParentId=accounts[0].Id;
		LegalEntityaccount.Default_Legal_Entity__c = true;
		LegalEntityaccount.Partner_Program__c=null;
		accounts.add(LegalEntityaccount);
		Database.upsert(accounts); 
		
		/*
		Opportunity Opportunity_v1= NF_TestDataFactory.createOpportunity(accounts[0].Id, 'Create offer (bid)', 'Offer in Progress', Date.today().addDays(10), 7000000);
		Opportunity_v1.Lead_BG__c='NSW';
		Opportunity_v1.RecordTypeId = oppDirectRecordTypeId;
		Opportunity_v1.Business_Type__c = 'Standard Opportunity';
		*/
		Opportunity Opportunity_v1= NF_TestDataFactory.createOpportunity(accounts[0].Id, 'Execute (Start Delivery)', 'In Execution', Date.today().addDays(10), 7000000);
		Opportunity_v1.Lead_BG__c='NSW';
		Opportunity_v1.Opportunity_ID__c='19.IN.856951';
		Opportunity_v1.RecordTypeId = oppDirectRecordTypeId;
		Opportunity_v1.Business_Type__c = 'Standard Opportunity';
		/*
		oppty.Opportunity_ID__c = '19.IN.856950';
		oppty.StageName = 'Execute (Start Delivery)';
		oppty.Phase_Status__c = 'In Execution';
		*/
		Database.insert(Opportunity_v1);
		
		List<product2> productObj2 = TestDataFactory.productCreation(3);
		productObj2[0].ProductCode = 'RL000277.T';
		productObj2[0].Apttus_Config2__ConfigurationType__c = 'Standalone';
		productObj2[1].ProductCode = 'var-opt';
		productObj2[1].name = 'Variable Option';
		productObj2[1].Apttus_Config2__ConfigurationType__c = 'Option';
		productObj2[2].ProductCode = 'vb';
		productObj2[2].name = 'Variable Bundle';
		productObj2[2].Apttus_Config2__ConfigurationType__c = 'Bundle';
		database.insert(productObj2);
		 
		 String json = '{'+
		'  \"header\":{'+
		'   '+
		' '+
		'			\"source_id\":\"CXM-ASDFG\",'+
		'   '+
		'			\"file_reference_id\":\"LTE AIR Interface AR\",'+
		'   '+
		'			\"account_id\":\"1323242223i\",'+
		'   '+
		'			\"creation_date\":\"2018-10-29\",'+
		'  '+
		'	\"start_date\":\"2018-10-29\",'+
		'  '+
		'	\"end_date\":\"2018-10-29\",'+
		 '  '+   
		'	\"workflow_type\" : \"Quote\",'+
		'   '+
		'			\"category_Type\":\"SW Recommendation\",'+
		'   '+	
		'	\"Agreement\" : \"00000024.0\",'+
		'   '+
		'			\"Opportunity\" : \"19.IN.856951\",'+
		'   '+	
		'			\"cell_quantity\":\"1\",'+
		'	'+
		'	\"Header attribute\" : ['+
		'	'+	
		'	{'+
		'	'+
		'			\"attributes Name\" : \"Site code\",'+
		'	'+
		'			\"attributes Label\" : \"Site Code\",'+
		'	'+
		'			\"attributes Value\" : \"SiteCodeDetails\",'+
		'	'+
		'			\"attributes Visibility\" : \"Yes\"'+
		'		}'+
		'	]'+			
		'  } ,'+
		' '+
		' '+
		 '  \"line_items\":['+
  '  {'+
  '  '+
  '	  \"bundle_id\": \"vb\",'+
	'	'+
  '	\"bundle_qty\": \"1\",'+			

  '  '+
  '	\"sales_item\": ['+
  '	'+  
  '	{'+
  '  '+
  '	\"Code\":\"var-opt\",'+
  '  '+
  '	\"quantity\": \"1\"'+
  '	}'+  
  '	],'+ 


  '	\"item attribute\" : ['+ 
  '	'+
  '	{'+
  '	\"attributes Name\" : \"Site code\",'+
  '  '+  
  '	\"attributes Label\" : \"Site Code\",'+
  '  '+
  '	\"attributes Value\" : \"SiteCodeDetails\",'+
  '  '+
  '	\"attributes Visibility\" : \"Yes\"'+
  '	}'+
  '	]'+

  '	},'+
  '	{'+
  '	  \"bundle_id\": \"\",'+
  '	  \"bundle_qty\": \"\",'+			

  '  '+
  '	\"sales_item\": ['+
  '	'+  
	'	{'+
  '  '+
  '	\"Code\":\"RL000277.T1\",'+
  '  '+
  '	\"quantity\": \"1\"'+
  '	}'+
  '	],'+ 


  '	\"item attribute\" : ['+ 
  '	'+
  '	{'+
  '	\"attributes Name\" : \"Use Case\",'+
  '  '+  
  '	\"attributes Label\" : \"Use Case\",'+
  '  '+
  '	\"attributes Value\" : \"Energy Efficiency\",'+
  '  '+
  '	\"attributes Visibility\" : \"Yes\"'+
  '	}'+
  '	]'+
  '	}'+

  '  ]'+
		'}';   
		
		List<Apttus_Config2__ProductOptionComponent__c> OptionComlist=new  List<Apttus_Config2__ProductOptionComponent__c>();
	 
		Apttus_Config2__ProductOptionComponent__c prodoptioncmp = TestDataFactory.CreateproductOptionComponent(productObj2[1].id,1)[0];
		prodoptioncmp.Apttus_Config2__ParentProductId__c = productObj2[2].id;
		prodoptioncmp.Apttus_Config2__Sequence__c = 5613;
		Apttus_Config2__ProductOptionComponent__c prodoptioncmp1 = TestDataFactory.CreateproductOptionComponent(productObj2[0].id,1)[0];
		prodoptioncmp1.Apttus_Config2__Sequence__c = 5614;
		Apttus_Config2__ProductOptionComponent__c prodoptioncmp2 = TestDataFactory.CreateproductOptionComponent(productObj2[2].id,1)[0];
		prodoptioncmp2.Apttus_Config2__Sequence__c = 5616;
		OptionComlist.add(prodoptioncmp);
		OptionComlist.add(prodoptioncmp1);
		OptionComlist.add(prodoptioncmp2);
		database.insert(OptionComlist);
		
		List<Apttus_Config2__PriceList__c> priceListObj = TestDataFactory.priceList(1);
		priceListObj[0].Apttus_Config2__AccountId__c = LegalEntityaccount.id;
		priceListObj[0].Type__c  = 'CXM';
		database.insert(priceListObj[0]);
		
		List<Apttus_Config2__PriceListItem__c> priceListItemObj = TestDataFactory.createPriceListItem(3,priceListObj[0]);
		priceListItemObj[0].Apttus_Config2__PriceListId__c = priceListObj[0].id;
		priceListItemObj[0].Apttus_Config2__ProductId__c = productObj2[0].id;
		priceListItemObj[1].Apttus_Config2__PriceListId__c = priceListObj[0].id;
		priceListItemObj[1].Apttus_Config2__ProductId__c = productObj2[1].id;
		priceListItemObj[2].Apttus_Config2__PriceListId__c = priceListObj[0].id;
		priceListItemObj[2].Apttus_Config2__ProductId__c = productObj2[2].id;
		
		database.insert(priceListItemObj);
		
		Apttus__APTS_Agreement__c agreementobj= new Apttus__APTS_Agreement__c();
		agreementobj.Apttus__Agreement_Number__c='00000024';
		agreementobj.Name= 'New demo';
		agreementobj.Apttus__Account__c = accounts[1].id;
		agreementobj.CurrencyIsoCode = 'EUR';
		agreementobj.Delivery_System__c = 'Scratch Order via P20';
		agreementobj.ERP__c = 'P20';
		agreementobj.Sales_Mode__c = 'Corporate Sales Mode';
		agreementobj.Confidence_Level__c = 'Low Level';
		agreementobj.Apttus__Contract_Start_Date__c=System.today();
		agreementobj.Apttus__Contract_End_Date__c=System.today()+30;
		agreementobj.Apttus_CMConfig__PriceListId__c = priceListObj[0].id;
		database.insert(agreementobj);
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/DS/V1/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
		
		DSJsonParsing.Deserializejson();
		DSJsonParsing.getPickListValuesIntoList();
		DSJsonParsing.ResponseChange(200,'test','test1');
		Test.stopTest(); 

	}
}