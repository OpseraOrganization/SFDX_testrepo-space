/************************************************************************************************************ 
Class Name : DSJsonParsing
Created Date: 7 JULY 2018
Created by: Accenture
Description :it will help to parsing the Json for rest web service  
*********************************************************************************************************/
@RestResource(urlMapping='/DS/V1/*')
global without sharing class DSJsonParsing {
	private static  Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(GlobalConstants.LEGAL_ENTITY).getRecordTypeId();
	private static  Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(GlobalConstants.CUSTOMER).getRecordTypeId(); 
	public static RestResponse Response;
	public static Integer Max_SIZE=131072;
	public static Integer JsoNMaxsize=0;
	public static String NonValidAttributesMsg;
	public static String ValidAttributesMsg;
	public static String CorrectData;
	public static String EmptyField; 
	public static String DuplicateCheck;
	public static String  Productcode;
	public static String  Bundlecode;
	public static String  Analyticsource;
	public static String  Standalonecode;
	public static String  NoLineitemMsg;
	public static Id  IlogId;
	public static  string Requeststring;
	public static String SizeErrormsg='This JSON data size is more than '+Max_SIZE+'. your JSON data size is ';
	public static String Fieldmissing='This Field is Missing: ';
	
	public static String Header=DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.HEADER_CS).Field_Object__c;
	public static String WorkFlowType=DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.WORKFLOW_TYPE).Field_Object__c;	
	public static String LineItem=DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.LINE_ITEM).FieldDefinition__c;
	public static string ITEM_ATTRIBUTE=DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.CFA_OBJECT).FieldDefinition__c;
	public static String JSON_Item_Attr=DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.CFA_OBJECT).Field_Object__c;
	public static String SalesItem=DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.SALES_ITEM).Field_Object__c;
	public static String Bundle_ID=DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.QPLI_BUNDLEID).Field_Object__c;
	public static Boolean STAGING_INSERT=DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.STAGING_INSERT_CS).sync__c; 
	public static String WORKFLOWTYPES=DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.WORKFLOWTYPES_CS).Message__c;
	
	/************************************************************************************************************ 
Method Name : Deserializejson
Created Date: 7 JULY 2018
Created by: Accenture
Description :it will help to parsing the Json for rest web service  
*********************************************************************************************************/
	@Httppost
	global static void Deserializejson()
	{ 
		system.debug('WorkFlowType>>'+WorkFlowType);
		RestRequest req = RestContext.request;
		Response = RestContext.response;
		
		map<Integer,List<Sobject>> Line_AttrMap=new map<Integer,List<Sobject>>();
		List<SObject> SobjLineItemList=new List<SObject>();
		List<SObject> H_SobjItemattrList=new List<SObject>();
		Sobject HeaderObject;
		String Sobjecttype;
		String SObjectName;
		String SObjectLineitemName;
		String LineNumberField;
		list<string> missingfield = new list<String>();
		List<String> conditionalfields = new List<String>();
		Requeststring=req.requestBody.tostring();
		system.debug('Requeststring-->'+Requeststring);
		String RequeststringLowercase=req.requestBody.tostring().toLowerCase();
		try{
			if(STAGING_INSERT){
			if(Requeststring.length()<Max_SIZE){
	Map<String, Object> JSONmap = (Map<String, Object>) JSON.deserializeUntyped(Requeststring);
	Map<String, Object> JSONmapLowercase = (Map<String, Object>) JSON.deserializeUntyped(RequeststringLowercase);
	map<string,Object> HeaderMapLowerCase=new map<string,Object>();
	  
	List<String> JSON_fields=new List<String>();
	List<String> Workflowtypelist=  WORKFLOWTYPES.split(',');
	map<String,Map<string,string>> Object_FieldsMap=new map<string,Map<string,string>>();
	map<string,string> Datatypemap=new map<string,string>();
	
	if(JSONmapLowercase.containskey(Header))HeaderMapLowerCase = (map<string,object>)JSONmapLowercase.get(Header);
	else ValidAttributesMsg=Header;
	 
	Map<String, DS_Json_Mandatory_fields__c> mandtryfieldCutomSett = DS_Json_Mandatory_fields__c.getAll();
	string ConditionalfieldCutomSett;
	List<String> mandatoryfields = new List<String>();
	mandatoryfields.addAll(mandtryfieldCutomSett.keySet());
	
	for(String field : mandatoryfields){
		if(!(HeaderMapLowerCase.containskey(field) && HeaderMapLowerCase.get(field) != null)){
		missingfield.add(field);
		}
	}
	
	if(HeaderMapLowerCase.containskey(WorkFlowType)&&String.isblank(ValidAttributesMsg))
		Sobjecttype=String.valueof(HeaderMapLowerCase.get(WorkFlowType));
	else  ValidAttributesMsg=WorkFlowType;
	
	if(!String.isblank(Sobjecttype))
	if(!Workflowtypelist.contains(Sobjecttype))CorrectData=WorkFlowType;
		
	
	if(!string.isblank(Sobjecttype)&&string.isBlank(ValidAttributesMsg)&&String.isblank(CorrectData)&&Workflowtypelist.contains(Sobjecttype)){
		ConditionalfieldCutomSett = DS_JSON_Conditional_Fields__c.getValues(Sobjecttype).Conditional_Fields_API_Name__c;
		List<String> conditionalfieldlist = ConditionalfieldCutomSett.split(',');
		for(String field : conditionalfieldlist){
			if(!(HeaderMapLowerCase.containskey(field) && HeaderMapLowerCase.get(field) != null)){
		 conditionalfields.add(field);
			}
		}
		
	}
	if(!conditionalfields.isempty()&&string.isBlank(ValidAttributesMsg)&&String.isblank(CorrectData)){
		missingfield.addAll(conditionalfields);
	}
		EmptyField = string.join(missingfield,',');
	   
	if(!string.isblank(Sobjecttype)&&Workflowtypelist.contains(Sobjecttype)&&string.isBlank(ValidAttributesMsg)&&String.isblank(CorrectData)&&String.isblank(EmptyField)){	
		SObjectName=DS_ObjectFieldjsonmap__c.getValues(Sobjecttype).FieldDefinition__c;
		SObjectLineitemName=DS_ObjectFieldjsonmap__c.getValues(Sobjecttype+LineItem).FieldDefinition__c;
		LineNumberField=DS_ObjectFieldjsonmap__c.getValues(SObjectName+GlobalConstants.LINENUMBER).Field_Object__c;
	}
	else CorrectData=WorkFlowType;
	
	if(!string.isblank(SObjectName)&&!string.isblank(SObjectLineitemName)&&string.isBlank(ValidAttributesMsg)&&String.isblank(CorrectData)){
		For(DS_ObjectFieldjsonmap__c DSFIELD:DS_ObjectFieldjsonmap__c.getall().values())
		{
			if(DSFIELD.RecordDefinition__c<>Null&&(DSFIELD.RecordDefinition__c.contains(SObjectName) ||DSFIELD.RecordDefinition__c.contains(SObjectLineitemName)
				  ||DSFIELD.RecordDefinition__c.contains(GlobalConstants.SOBJECT_CS)   ||DSFIELD.RecordDefinition__c.contains(ITEM_ATTRIBUTE)))
			{
				If(!Object_FieldsMap.containskey(DSFIELD.RecordDefinition__c) ){
		map<string,string> FIELDSMAP=new map<string,string>();
		FIELDSMAP.put(DSFIELD.Field_Object__c,DSFIELD.FieldDefinition__c);
		Object_FieldsMap.put(DSFIELD.RecordDefinition__c, new map<String,string>(FIELDSMAP));
				}
				else
		Object_FieldsMap.get(DSFIELD.RecordDefinition__c).put(DSFIELD.Field_Object__c,DSFIELD.FieldDefinition__c);
				
			}
			if(DSFIELD.RecordDefinition__c<>Null&&DSFIELD.RecordDefinition__c.contains(GlobalConstants.DATATYPE_CS))
				Datatypemap.put(DSFIELD.Field_Object__c,DSFIELD.FieldDefinition__c);
			if(DSFIELD.Name.Contains(GlobalConstants.JSON_ATRRIBUTES)){
				String  JSON_ATTRIBUTES1=DSFIELD.FieldDefinition__c+','+DSFIELD.Field_Object__c+','+DSFIELD.RecordDefinition__c;
				String   JSON_ATTRIBUTES2=DSFIELD.Message__c;
				List<String> JSON_fieldsMS=JSON_ATTRIBUTES1.split(',');
				List<String> JSON_fieldsMSG=JSON_ATTRIBUTES2.split(',');
				JSON_fields.addall(JSON_fieldsMS);
				JSON_fields.addall(JSON_fieldsMSG);
			}
		}
		
		
		Schema.SObjectType HeaderSobj = Schema.getGlobalDescribe().get(SObjectName);
		Schema.SObjectType LineItemSobj= Schema.getGlobalDescribe().get(SObjectLineitemName);
		Schema.SObjectType ItemattributeSobj= Schema.getGlobalDescribe().get(ITEM_ATTRIBUTE);
		map<string,string> HeaderSobjFieldsMap=Object_FieldsMap.get(SObjectName);
		map<string,string> LineItemSobjSobjFieldsMap=Object_FieldsMap.get(SObjectLineitemName);
		map<string,string> ItemAttributeFieldsMap=Object_FieldsMap.get(ITEM_ATTRIBUTE);
		map<string,string> JSonSobjectmap=Object_FieldsMap.get(GlobalConstants.SOBJECT_CS); 
		
		
		for(String Jsonkey:JSONmap.keyset())
		{	 
			string Jsonkey_L=Jsonkey.tolowercase();
			if(JSON_fields.contains(Jsonkey_L))
			{
				if(Header.contains(Jsonkey_L)&&string.isblank( NonValidAttributesMsg))
				{	
		  HeaderObject = HeaderSobj.newSObject();
		map<string,Object>  HeaderMap = ( map<string,object>)JSONmap.get(Jsonkey);
		for(String Header_Key:HeaderMap.keyset())
		{ 
			system.debug('Header_Key>>'+Header_Key);	  
			string Headerkey_L=Header_Key.tolowercase();
			system.debug('Headerkey_L>>'+Headerkey_L);
			system.debug('JSON_fields>>'+JSON_fields);
			if(JSON_fields.contains(Headerkey_L))
			{
				if(HeaderSobjFieldsMap.containskey(Headerkey_L)){
					string ObjectField=HeaderSobjFieldsMap.get(Headerkey_L);
					system.debug('ObjectField>>'+ObjectField);
					
					if(Datatypemap.containskey(ObjectField))
					{
			string FieldVal=string.valueof(HeaderMap.get(Header_Key));
			if(Datatypemap.get(ObjectField).equalsignorecase(GlobalConstants.DATE_ATRRIBUTE)&&!String.isblank(FieldVal))
			system.debug('Datatypemap>>'+Datatypemap);
			{
				String[] strDate = FieldVal.split('-');//Yr/m/D
				Date Datefield = Date.newInstance(integer.valueOf(strDate[0]), integer.valueOf(strDate[1]), integer.valueOf(strDate[2]));
				HeaderObject.put(ObjectField,Datefield);
			}
			system.debug('Datatypemap>>'+Datatypemap);
			system.debug('Datatypemap.get(ObjectField)>>'+Datatypemap.get(ObjectField));
			system.debug('FieldVal>>'+FieldVal);
			if(Datatypemap.get(ObjectField).equalsignorecase(GlobalConstants.DECIMAL_ATRRIBUTE)&&!String.isblank(FieldVal)){
				system.debug('Datatypemap>>'+Datatypemap);
				Decimal Decimalfield= Decimal.valueof(FieldVal);
				HeaderObject.put(ObjectField,Decimalfield); 
			}
					}
					else
			HeaderObject.put(ObjectField, HeaderMap.get(Header_Key));
					
				}
				system.debug('JSonSobjectmap>>'+JSonSobjectmap);
				if(JSonSobjectmap.containskey(Headerkey_L)&&string.isblank( NonValidAttributesMsg))
				{
					List<Object> ItemAttributeListSobj = (List<Object>) HeaderMap.get(Header_Key);
					for(Object Item_atr:ItemAttributeListSobj)
					{
			Sobject HeaderItemAttributsObj = ItemattributeSobj.newSObject();  
			map<string,Object> ItemAttrmap = ( map<string,object>)Item_atr;
			for(string Attrkey:ItemAttrmap.keyset())
			{
				system.debug('Attrkey-->'+Attrkey);
					string Attrkey_L=Attrkey.tolowercase();
				if(JSON_fields.contains(Attrkey_L)&&ItemAttributeFieldsMap.containskey(Attrkey_L))
				{
					HeaderItemAttributsObj.put(ItemAttributeFieldsMap.get(Attrkey_L),ItemAttrmap.get(Attrkey));
				} 
				else 
					NonValidAttributesMsg=Attrkey;  
			}
			H_SobjItemattrList.add(HeaderItemAttributsObj);  
			System.debug('H_SobjItemattrList>>'+H_SobjItemattrList);
					}  
				}
			}
			else
				NonValidAttributesMsg=Header_Key;
		}
		SobjLineItemList.add(HeaderObject);
				}
				if(LineItem.contains(Jsonkey_L))
				{
		List<Object> SobjLineItemListv1 = (List<Object>) JSONmap.get(Jsonkey);
		Integer COuntLineItem=0;
		for(Object Obj:SobjLineItemListv1) 
		{  
			COuntLineItem=COuntLineItem+1;
			Integer CountSalesItem=0;
			map<string,Object> LineItemmap = ( map<string,object>)Obj;
			Sobject lineItemObject = LineItemSobj.newSObject();
			Boolean AddlIneItem=false;
			string BundleIdKey;
			for(String LineItemmapkey:LineItemmap.keyset()){
				string LineItemmapkey_L=LineItemmapkey.tolowercase();
				if(JSON_fields.contains(LineItemmapkey_L)){
					
					if(Bundle_ID.contains(LineItemmapkey_L))
					{  
			BundleIdKey=LineItemmapkey;
			if(LineItemmap.get(LineItemmapkey)<>null&&LineItemmap.get(LineItemmapkey)<>''){
				AddlIneItem=true;
				string SobjdField= LineItemSobjSobjFieldsMap.get(LineItemmapkey_L);
				lineItemObject.put(SobjdField,LineItemmap.get(LineItemmapkey));
				lineItemObject.put(LineNumberField,COuntLineItem);
			}
					}
					string SobjdField= LineItemSobjSobjFieldsMap.get(LineItemmapkey_L);
					if(Datatypemap.Containskey(SobjdField)){
			string FieldvalLine=string.valueof(LineItemmap.get(LineItemmapkey));
			if(Datatypemap.get(SobjdField).equalsignorecase(GlobalConstants.DECIMAL_ATRRIBUTE)&&!string.isblank(FieldvalLine)){
				Decimal Decimalfield= Decimal.valueof(FieldvalLine);
				lineItemObject.put(SobjdField,Decimalfield); 
			}
					}
					else if(!SalesItem.contains(LineItemmapkey_L)&&!JSON_Item_Attr.contains(LineItemmapkey_L))  
			lineItemObject.put(SobjdField,LineItemmap.get(LineItemmapkey));
					
					if(SalesItem.contains(LineItemmapkey_L))
					{
			List<Object> Salesitemlist=(List<Object>)LineItemmap.get(LineItemmapkey);
			for(Object Sitem:Salesitemlist)
			{
				map<string,Object> sItemmap = ( map<string,object>)Sitem;
				Sobject SalesLineItemObj = LineItemSobj.newSObject();
				CountSalesItem=CountSalesItem+1;
				for(string sItemmapkey:sItemmap.keyset())
				{
					string sItemmapkey_L=sItemmapkey.tolowercase();
					if(JSON_fields.contains(sItemmapkey_L))
					{
						if(LineItemSobjSobjFieldsMap.containskey(sItemmapkey_L)) 
						{
				string Objfield=LineItemSobjSobjFieldsMap.get(sItemmapkey_L);
				string Fieldval=string.valueof(sItemmap.get(sItemmapkey));
				if(Datatypemap.Containskey(Objfield)){
					if(Datatypemap.get(Objfield).equalsignorecase(GlobalConstants.DECIMAL_ATRRIBUTE)&&!string.isblank(Fieldval)){
						Decimal Decimalfield= Decimal.valueof(FieldVal);
						SalesLineItemObj.put(Objfield,Decimalfield); 
					}
				}
				else
					SalesLineItemObj.put(Objfield,sItemmap.get(sItemmapkey)); 
						}
					}
					else
						NonValidAttributesMsg=sItemmapkey;
				}
				SalesLineItemObj.put(LineNumberField,CountLineItem);
				SalesLineItemObj.put(LineItemSobjSobjFieldsMap.get(Bundle_ID),LineItemmap.get(Bundle_ID));
				SobjLineItemList.add(SalesLineItemObj);  
			}
			
			
					}
					
					
					if(JSON_Item_Attr.contains(LineItemmapkey_L))
					{
			List<Object> ItemAttributeListSobj = (List<Object>) LineItemmap.get(LineItemmapkey);
			List<Sobject> SobJectlistItemattrs=new  List<Sobject>();
			for(Object Item_atr:ItemAttributeListSobj)
			{
				Sobject HeaderItemAttributsObj = ItemattributeSobj.newSObject();  
				map<string,Object> ItemAttrmap = ( map<string,object>)Item_atr;
				for(string Attrkey:ItemAttrmap.keyset())
				{
					string Attrkey_L=Attrkey.tolowercase();
					if(JSON_fields.contains(Attrkey_L)&&ItemAttributeFieldsMap.containskey(Attrkey_L))
					{
						HeaderItemAttributsObj.put(ItemAttributeFieldsMap.get(Attrkey_L),ItemAttrmap.get(Attrkey));
					} 
					else 
						NonValidAttributesMsg=Attrkey;  
				}
				SobJectlistItemattrs.add(HeaderItemAttributsObj);  
				
			}
			if(!SobJectlistItemattrs.isempty())
				Line_AttrMap.put(COuntLineItem,SobJectlistItemattrs);  
			System.debug('Line_AttrMap>>'+Line_AttrMap);
					} 
				}
				else
					NonValidAttributesMsg=LineItemmapkey;
			}
			if(AddlIneItem)SobjLineItemList.add(lineItemObject); 
		}
				}
			}
			else
				NonValidAttributesMsg=Jsonkey;
		}
	}
			}
			else
	JsoNMaxsize=Requeststring.length();
	
	
	system.debug('SObjectLineitemName>>'+SObjectLineitemName);
	system.debug('SObjectName>>'+SObjectName);
	system.debug('Conditional field : '+ conditionalfields); 
	system.debug('Sobjecttype>>'+Sobjecttype);
	system.debug('ValidAttributesMsg>>'+ValidAttributesMsg);
	system.debug('WorkFlowType>>'+WorkFlowType);
	
	
			}
	 
			System.debug('NonValidAttributesMsg>>'+NonValidAttributesMsg+'ValidAttributesMsg>>'+ValidAttributesMsg+'CorrectData>>'+CorrectData+'EmptyField>>'+EmptyField);
			if(JsoNMaxsize==0&&String.isEmpty(NonValidAttributesMsg)&&String.isEmpty(ValidAttributesMsg)&&String.isEmpty(CorrectData)&&STAGING_INSERT&&String.isblank(EmptyField)&& String.isblank(NoLineitemMsg))
			{	
	List<Apttus_Proposal__Proposal__c> Quotelist=new  List<Apttus_Proposal__Proposal__c>();
	List<SWx_Upsell_Proposal__c> Dplist=new  List<SWx_Upsell_Proposal__c>();
	List<SWx_Upsell_Items__c> DplineItems=new  List<SWx_Upsell_Items__c>();
	List<Apttus_Config2__LineItem__c> QuoteLineItemsList=new  List<Apttus_Config2__LineItem__c>();
	Set<string> AgreenumberSet=new Set<string>();
	Set<string> AccNumberset=new Set<string>();
	Set<string> FilereferenceIdset=new Set<string>();
	Set<string> ProductCodeSet=new Set<string>();
	Set<string> OppNumSet=new Set<string>();
	 set<String> Bundlecodeset=new Set<String>();
		set<String> Standalonecodeset=new Set<String>();
		
	Integer ProductCodeCount=0;
	for(Sobject Sobj:SobjLineItemList)
	{
		if(Sobj.getSObjectType() == Apttus_Proposal__Proposal__c.sObjectType)
		{
			Apttus_Proposal__Proposal__c  Quote=(Apttus_Proposal__Proposal__c)Sobj;
			
			if(!String.isblank(Quote.Sold_To_Party__c))AccNumberset.add(Quote.Sold_To_Party__c);
			//else
		//  EmptyField=DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.QP_ACCOUNTID).Field_Object__c;
			if(!String.isblank(Quote.Analytics_File_Refer_ID__c))FilereferenceIdset.add(Quote.Analytics_File_Refer_ID__c);
			//else
				//EmptyField=DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.QP_FILEREFERECEID).Field_Object__c;
			
		 if(!String.isblank(Quote.Agreement_Lookup__c))AgreenumberSet.add(Quote.Agreement_Lookup__c);
			else
				EmptyField=DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.QP_AGREEMENT).Field_Object__c;
			
			if(!String.isblank(Quote.Apttus_Proposal__Opportunity__c))OppNumSet.add(Quote.Apttus_Proposal__Opportunity__c);
			else if(String.isblank(Quote.Apttus_Proposal__Opportunity__c)&&String.isblank(EmptyField)&&String.isblank(Quote.Agreement_Lookup__c))
				EmptyField=DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.QP_OPPORTUNITY).Field_Object__c;
			if(String.isblank(EmptyField))Quotelist.add(Quote);
			
		}
		System.debug('Sobj.getSObjectType()>>'+Sobj.getSObjectType());
		System.debug('SWx_Upsell_Proposal__c.sObjectType>>'+SWx_Upsell_Proposal__c.sObjectType);
		if(Sobj.getSObjectType() == SWx_Upsell_Proposal__c.sObjectType)
		{
			SWx_Upsell_Proposal__c  Dp=(SWx_Upsell_Proposal__c)Sobj;
			
			if(!String.isblank(Dp.Frame_Contract__c)) AgreenumberSet.add(Dp.Frame_Contract__c);
			else EmptyField=DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.QP_AGREEMENT).Field_Object__c;
			
			if(!String.isblank(Dp.Sold_To_Party__c))AccNumberset.add(Dp.Sold_To_Party__c);
			//else
		//  EmptyField=DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.QP_ACCOUNTID).Field_Object__c;
			
			if(!String.isblank(Dp.Analytics_File_Refer_ID__c))FilereferenceIdset.add(Dp.Analytics_File_Refer_ID__c);
		// else
			 //   EmptyField=DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.QP_FILEREFERECEID).Field_Object__c;
			
			if(!String.isblank(Dp.SWX_Reference_Opportunity__c))OppNumSet.add(Dp.SWX_Reference_Opportunity__c);
			else
				EmptyField=DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.QP_OPPORTUNITY).Field_Object__c;
			
			
			if(String.isblank(EmptyField))
				Dplist.add(Dp);
		}
		if(Sobj.getSObjectType() == SWx_Upsell_Items__c.sObjectType)
		{
			SWx_Upsell_Items__c  DpLineItem=(SWx_Upsell_Items__c)Sobj;
			DplineItems.add(DpLineItem);
		}
		
		if(Sobj.getSObjectType() == Apttus_Config2__LineItem__c.sObjectType)
		{
			
			Apttus_Config2__LineItem__c QuoteLineItem=(Apttus_Config2__LineItem__c)Sobj;
			
			if((!string.isblank(QuoteLineItem.Apttus_Config2__ProductId__c)&&!string.isblank(QuoteLineItem.Apttus_Config2__ProductOptionId__c))
		 ||(!string.isblank(QuoteLineItem.Apttus_Config2__ProductId__c)&&string.isblank(QuoteLineItem.Apttus_Config2__ProductOptionId__c))
		||(string.isblank(QuoteLineItem.Apttus_Config2__ProductId__c)&&!string.isblank(QuoteLineItem.Apttus_Config2__ProductOptionId__c))
		||(!string.isblank(QuoteLineItem.Apttus_Config2__ProductId__c)&&string.isblank(QuoteLineItem.Apttus_Config2__ProductOptionId__c)))
			{
		ProductCodeCount=ProductCodeCount+1;  
			}
			System.debug('ProductCodeSet>>'+ProductCodeSet);
			if(!string.isblank(QuoteLineItem.Apttus_Config2__ProductId__c)&&!ProductCodeSet.contains(QuoteLineItem.Apttus_Config2__ProductId__c)){
				ProductCodeSet.add(QuoteLineItem.Apttus_Config2__ProductId__c);
				Bundlecodeset.add(QuoteLineItem.Apttus_Config2__ProductId__c);
			}
				if(!string.isblank(QuoteLineItem.Apttus_Config2__ProductOptionId__c)){
				ProductCodeSet.add(QuoteLineItem.Apttus_Config2__ProductOptionId__c);
		Standalonecodeset.add(QuoteLineItem.Apttus_Config2__ProductOptionId__c);
				}
		
			if(QuoteLineItem.Apttus_Config2__Quantity__c==null|| QuoteLineItem.Apttus_Config2__Quantity__c==0)
			 EmptyField=DS_ObjectFieldjsonmap__c.getValues('DPSWX_BUNDLEQTY').Field_Object__c+' or '+DS_ObjectFieldjsonmap__c.getValues('DPSWX_QUANTITY').Field_Object__c;

			QuoteLineItemsList.add(QuoteLineItem);
			System.debug('QuoteLineItemsList>>'+QuoteLineItemsList);
		} 
		
		
	}
	  
	 if(ProductCodeCount<>QuoteLineItemsList.size())
		  EmptyField=DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.QPLI_CODE).Field_Object__c;
	
	if(!ProductCodeSet.isempty()){
		set<String> ProductCodestV1=new Set<String>();
		  
		ProductCodestV1.addAll(ProductCodeSet);
		  for(Product2 productObj : [select id,Apttus_Config2__ConfigurationType__c,ProductCode from Product2 where ProductCode in :ProductCodeSet Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()] ){
		 if(productObj.Apttus_Config2__ConfigurationType__c.contains('Bundle')&&Bundlecodeset.contains(productObj.ProductCode))
		  Bundlecodeset.remove(productObj.ProductCode);
		 if((productObj.Apttus_Config2__ConfigurationType__c.contains('Option')||productObj.Apttus_Config2__ConfigurationType__c.contains('Standalone'))&&Standalonecodeset.contains(productObj.ProductCode))
		  Standalonecodeset.remove(productObj.ProductCode);
		
		if(ProductCodestV1.contains(productObj.ProductCode))
		ProductCodestV1.remove(productObj.ProductCode);
		}
		
		if(!ProductCodestV1.isempty())
			Productcode=string.valueof(ProductCodestV1);
		if(!Bundlecodeset.isempty())
			Bundlecode=string.valueof(Bundlecodeset);
	   if(!Standalonecodeset.isempty())
			Standalonecode=string.valueof(Standalonecodeset);
			
	}
	else
	 NoLineitemMsg=Globalconstants.NoLineitemMsg;  

	System.debug('EmptyField>>'+EmptyField+'Productcode>>'+Productcode+'Bundlecode>>'+Bundlecode+'Standalonecode>>'+Standalonecode);		 
	if(string.isBlank(EmptyField)&&string.isBlank(Productcode)&&string.isBlank(Bundlecode)&&string.isBlank(Standalonecode)&& String.isblank(NoLineitemMsg))
	{
	 
		Integer AccountCount= [Select Count() From Account Where RecordtypeId=:LERecordTypeId AND Parent.RecordtypeId=:CustRecordTypeId AND AccountNumber IN :AccNumberset ];
		Integer OppCount=[Select Count() From Opportunity Where Opportunity_ID__c IN:OppNumSet ];
		List<Apttus__APTS_Agreement__c> AgrList=[Select Id,Apttus__Related_Opportunity__c from Apttus__APTS_Agreement__c where Apttus__FF_Agreement_Number__c IN :AgreenumberSet];
		
		If(AccountCount==0&&string.isBlank(EmptyField))CorrectData =DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.QP_ACCOUNTID).Field_Object__c ;
		if((((OppCount==0&&AgrList<>null&&!AgrList.isempty()&&String.isblank(AgrList[0].Apttus__Related_Opportunity__c))|| AgrList<>null&&AgrList.isempty())|| AgrList==null)&&string.isBlank(EmptyField)) CorrectData =DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.QP_AGREEMENT).Field_Object__c+' Or '+DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.QP_OPPORTUNITY).Field_Object__c ;

	}
			 
	if(!Quotelist.isempty()&&String.isBlank(CorrectData)&&String.isBlank(Productcode)&&String.isBlank(EmptyField)&&String.isBlank(DuplicateCheck)&&string.isBlank(Bundlecode)&&string.isBlank(Standalonecode)&& String.isblank(NoLineitemMsg))
	{
		Integer QuoteCount=[Select Count() From Apttus_Proposal__Proposal__c where Analytics_File_Refer_ID__c IN:FilereferenceIdset];
		if(QuoteCount>0) 
			DuplicateCheck=DS_ObjectFieldjsonmap__c.getValues(GlobalConstants.QP_FILEREFERECEID).Field_Object__c;
	}
	
	System.debug('Quotelist>>'+Quotelist+'Dplist>>'+Dplist+'CorrectData>>'+CorrectData+'Productcode>>'+Productcode+'EmptyField>>'+EmptyField+'DuplicateCheck>>'+DuplicateCheck+'Bundlecode>>'+Bundlecode+'Standalonecode>>'+Standalonecode);
	if((!Quotelist.isempty()||!Dplist.isempty())&&String.isBlank(CorrectData)&&String.isBlank(Productcode)&&String.isBlank(EmptyField)&&String.isBlank(DuplicateCheck)&&string.isBlank(Bundlecode)&&string.isBlank(Standalonecode)&& String.isblank(NoLineitemMsg))
	{   
		DS_Staging__c DS_Staging;
		Interface_Log__c Ilog = insertInterfaceLog( CSWXGlobalConstant.Success,Requeststring,string.isblank(Analyticsource)?CSWXGlobalConstant.successfulUpload.removeend(': '):CSWXGlobalConstant.successfulUpload.removeend(': ')+' , '+GlobalConstants.CorrectDatamsg+Analyticsource);
		if(Ilog<>null)
		{
		
			DS_Staging = insertDSStaging(Requeststring,CSWXGlobalConstant.Success,Ilog.Id);
			string SucccessMessage=string.isblank(Analyticsource)?CSWXGlobalConstant.successfulUpload+ DS_Staging.Id:CSWXGlobalConstant.successfulUpload+ DS_Staging.Id+' , '+GlobalConstants.CorrectDatamsg+Analyticsource;
			Response.responseBody = Blob.valueOf(SucccessMessage);
			Response.statusCode = 201;
		}
		System.debug('Quotelist>>'+Quotelist+'QuoteLineItemsList>>'+QuoteLineItemsList+'H_SobjItemattrList>>'+H_SobjItemattrList+'Line_AttrMap>>'+Line_AttrMap+'AgreenumberSet>>'+AgreenumberSet+'AccNumberset>>'+AccNumberset+'OppNumSet>>'+OppNumSet+'ProductCodeSet>>'+ProductCodeSet+'DS_Staging>>'+DS_Staging+'Ilog>>'+Ilog);
		if(!Quotelist.isempty())
			QuoteHandling(Quotelist,QuoteLineItemsList,H_SobjItemattrList,Line_AttrMap,AgreenumberSet,AccNumberset,OppNumSet,ProductCodeSet,DS_Staging,Ilog);
		if(!Dplist.isempty()) {   
		  // DPHandling(H_SobjItemattrList,SobjLineItemList,Line_AttrMap); 
		 // DS_DPNDLICreation.cxmDPCreation(SobjLineItemList, HeaderObject,DS_Staging,H_SobjItemattrList,Line_AttrMap);   
		// DS_StagingObjParsingNew.cxmDPCreation(SobjLineItemList, HeaderObject);	  
	
		}
		
	}
	
	 
		}
		
	 if(JsoNMaxsize<>0 || !String.isBlank(Productcode)||!String.isblank(NonValidAttributesMsg) ||!String.isblank(ValidAttributesMsg)||!String.isblank(CorrectData)||!String.isblank(EmptyField) ||!String.isBlank(DuplicateCheck) ||!STAGING_INSERT||!String.isblank(Bundlecode) ||!String.isBlank(Standalonecode) ||!String.isblank(NoLineitemMsg)) 
			{
			
	 string ErrorMessage=!string.isBlank(ValidAttributesMsg) ?GlobalConstants.ValidErrorMsg+ValidAttributesMsg:!string.isBlank(NonValidAttributesMsg)?GlobalConstants.NoValidErrorMsg+NonValidAttributesMsg:!string.isBlank(EmptyField)?GlobalConstants.EmptyErrormsg+EmptyField:!string.isBlank(CorrectData)?GlobalConstants.CorrectDatamsg+CorrectData:
	  JsoNMaxsize<>0?SizeErrormsg+JsoNMaxsize:!String.isBlank(DuplicateCheck)?DuplicateCheck+GlobalConstants.Duplicatemsg:!STAGING_INSERT?GlobalConstants.SyncErrorMsg:!String.isBlank(Productcode)?GlobalConstants.ProductNonAvailabilitymsg+Productcode:!string.isBlank(Bundlecode)?GlobalConstants.Bundlecodemsg+Bundlecode:
	!string.isBlank(Standalonecode)?GlobalConstants.Standalonecodemsg+Standalonecode:  !string.isBlank(NoLineitemMsg)?GlobalConstants.NoLineitemMsg:'';
	
	if((!string.isBlank(ValidAttributesMsg)||!string.isBlank(NonValidAttributesMsg))&&JsoNMaxsize==0 &&String.isBlank(Productcode)&&String.isblank(CorrectData)&&String.isblank(EmptyField)&&String.isBlank(DuplicateCheck)&&STAGING_INSERT&&String.isblank(Bundlecode)&&String.isBlank(Standalonecode)&&string.isBlank(NoLineitemMsg))
		Interface_Log__c Ilog1= ResponseChange(400,ErrorMessage,requeststring);
	else
	{
	   Interface_Log__c Ilog2 = insertInterfaceLog(CSWXGlobalConstant.Failure ,requeststring,ErrorMessage);
		DS_Staging__c DS_Staging = insertDSStaging(requeststring,CSWXGlobalConstant.Failure,Ilog2.id);
		System.debug('DS_Staging>>'+DS_Staging);
		Response.responseBody = Blob.valueOf(ErrorMessage+', Ds staging Id is: '+DS_Staging.Id);
		Response.statusCode = 400; 
	}
	

			}
		}
		catch(Exception e){
			string ErrorMessage= CSWXGlobalConstant.unsuccessfulUpload + e.getMessage() ;
			Interface_Log__c Ilog= ResponseChange(400,ErrorMessage,Requeststring);
			ExceptionHandler.addException(e, 'fee','sdfd');
			system.debug('Exception-->'+e.getMessage());
			
		}
		
		
	}
	  /************************************************************************************************************ 
Method Name : DPHandling
Created Date: 7 JULY 2018
Created by: Accenture
Description :with Correct data  for Digitalproposal this method will handle other process
*********************************************************************************************************/
	public static void DPHandling(list<SWx_Upsell_Proposal__c> Dplist,list<SWx_Upsell_Items__c>  DpLineItemList,  map<Integer,List<Sobject>> Line_AttrMap){
		
	}
	 /************************************************************************************************************ 
Method Name : QuoteHandling
Created Date: 7 JULY 2018
Created by: Accenture
Description :with Correct data  for Quote this method will handle other process
*********************************************************************************************************/
	public static void QuoteHandling(list<Apttus_Proposal__Proposal__c> QuoteList,list<Apttus_Config2__LineItem__c>QuoteLineItemList,List<Sobject> H_SobjItemattrList,  map<Integer,List<Sobject>> Line_AttrMap,Set<string> AgreenumberSet, Set<string> AccNumberset,   Set<string> OppNumSet,Set<string> ProductCodeSet, DS_Staging__c DS_Staging,Interface_Log__c Ilog){
		
		system.enqueueJob(new DS_JSONQuoteCreation(QuoteList,QuoteLineItemList,H_SobjItemattrList,Line_AttrMap,AccNumberset,ProductCodeSet,AgreenumberSet,OppNumSet,DS_Staging,Ilog)) ;
	}
	  /************************************************************************************************************ 
Method Name : ResponseChange
Created Date: 7 JULY 2018
Created by: Accenture
Description :this method will help to insert the Interface log  and return the response
*********************************************************************************************************/
	public static Interface_Log__c ResponseChange(Integer ResponseCode,String Responsemsg,String ReqBody)
	{
		String Status= ResponseCode==201?CSWXGlobalConstant.Success:CSWXGlobalConstant.Failure;
	  Interface_Log__c  Ilog = insertInterfaceLog(Status ,ReqBody,Responsemsg);
		Response.responseBody = Blob.valueOf(Responsemsg);
		Response.statusCode = ResponseCode; 
		return Ilog;
	}
	/************************************************************************************************************ 
Method Name : insertInterfaceLog
Created Date: 7 JULY 2018
Created by: Accenture
Description :this method will help to insert the Interface log  
*********************************************************************************************************/
	public static Interface_Log__c insertInterfaceLog(String status,String ReqBody,string Errormsg){
		try{
			Interface_Log__c ilog = new Interface_Log__c(
	Message_Type__c =CSWXGlobalConstant.messgaeType,
	Operation_Type__c = CSWXGlobalConstant.optionType,
	Interface_Type__c = CSWXGlobalConstant.DS,
	Status__c = status,
	DS_Payload__c=ReqBody,
	Comment__c=Errormsg
			);
			Database.insert(ilog);
			System.debug('ilog>>'+ilog);
			return ilog;
			
		}
		catch(Exception e){
			ExceptionHandler.addException(e, 'fee','sdfd');
			return null;
		}
	}
	 /************************************************************************************************************ 
Method Name : insertDSStaging
Created Date: 7 JULY 2018
Created by: Accenture
Description :this method will help to insert the DS_Staging__c  and return the response
*********************************************************************************************************/
	public static DS_Staging__c  insertDSStaging(String jsontext , String statusmsg, Id logId){
		try{
			DS_Staging__c ds_staging = new DS_Staging__c(
	DS_Payload__c=jsontext,
	Payload_Status__c=statusmsg,
	Interface_Log__c = logId
			);
			if(Globalconstants.failure.contains(statusmsg)) 
	ds_staging.Dp_Status__C=statusmsg;
	
			Database.insert(ds_staging);
			
			return ds_staging;
			
		}catch(Exception e){
			ExceptionHandler.addException(e, 'gg','gg');
			return null;
		}
		
	}
	/************************************************************************************************************ 
Method Name : getPickListValuesIntoList
Created Date: 7 JULY 2018
Created by: Accenture
Description :this method will help to get picklistvalue  and return the response
*********************************************************************************************************/
	public static List<String> getPickListValuesIntoList(){
	List<String> pickListValuesList= new List<String>();
		Schema.DescribeFieldResult fieldResult = Apttus_Proposal__Proposal__c.Analytics_Source__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(pickListVal.getValue());
		}	 
		return pickListValuesList;
	}
}