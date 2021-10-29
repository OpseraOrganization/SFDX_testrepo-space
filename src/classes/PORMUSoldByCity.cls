public  class PORMUSoldByCity {
	/*
		This program is developed to export PO Tracker data, RMUs installed in a perticular region.
		Data is exported in excel file with installed and remaining RMU options
		Created By : Varun Nirala (Jul22,2013)
	*/
	// Varibale declarations
	public String stateCode{get;set;}
	public String countryCode{get;set;}
	public String regionName{get;set;}
	public Map<String,List<Map<String,object>>> displayData {get;set;}
	public Map<String,List<String>> rmuDetailList {get;set;}
	
	// Naming exceptions RMU Names
	Map<String,String> exceptionRMUNames;
	//Constructor, initlize 
	public PORMUSoldByCity(){
			createPlatformGroupList();
			exceptionRMUNames = 
			(Map<String,String>)Json.deserialize(Label.RMUExceptionNamesMap, Map<String,String>.class);
			try{
				stateCode 	=   ApexPages.CurrentPage().getParameters().get('stateCode');
				countryCode =  	ApexPages.CurrentPage().getParameters().get('cntryCode');
				
				
				if(stateCode != null){
					stateCode = String.escapeSingleQuotes(stateCode);
				}
				if(countryCode != null){
					countryCode = String.escapeSingleQuotes(countryCode);
				}
				
			}catch(Exception e){}
	}
	
	//processData prepares data for display
	Map<String,List<Map<String,object>>> processData(){
		//populatePlatformRMUDetailList create platform groups and rmus mapping, populates rmuDetailList list 
	 	populatePlatformRMUDetailList(platformsList);
	 	
		Map<String,List<Map<String,object>>>  finalDataMap = new Map<String,List<Map<String,object>>>();
		// loop around each platform group name list, fetch and create data form export
		for(String pltfrmName : platformsList){
			
				finalDataMap.put(	
									pltfrmName,
									convertSobjectListToMap(//create platform rmu installed data from PO tracker
															getPlatformRMUInstalledData(
																							pltfrmName,
																							stateCode,
																							countryCode
																						)
																					,pltfrmName	
													  )
								  );
								  
			}					  
		
		return finalDataMap;
		
	}
	
	List<Map<String,object>> convertSobjectListToMap(List<sObject> lstSobject,String pltfrmName){
		
		List<Map<String,object>> retList = new List<Map<String,object>>();
		// loop around each record
		for(sObject poRecord : lstSobject){
					Map<String,object> mapRecord = new Map<String,object>();
					
					// fill data for parent po tracker columns
					for(String colApiName : getParentColsApiNamesList()){
						mapRecord.put(colApiName,(poRecord.get(colApiName) == null? '-': poRecord.get(colApiName)));
					}
					// now default fill all po tracker options values with hypen
					for(String rmuDetailName : rmuDetailList.get(pltfrmName)){
						mapRecord.put(rmuDetailName,'-');
					}
					
					// fetch po tracker option details
					List<sObject> poDetailRecords = poRecord.getSObjects('PO_Tracker_Options__r');
					//fill Y, for installed options
					if(poDetailRecords!=null)
					for(sObject poDetlRec : poDetailRecords){
						String rmuDetailName = 
						createRMUNameKey(nvlString(poDetlRec.get('RMU_Name__c')),nvlString(poDetlRec.get('RMU_Config_Detail_Name__c')));
						mapRecord.put(rmuDetailName,'Y');
					}
					
					retList.add(mapRecord);
			}
			
		return retList;
	}
	//query string building method
	String getQuery(String parentCols,String childCols,String whereClauseParent , String whereClauseChild){
			String qry = 
					' select '+parentCols+', '+
						' ('+
						' select '+ 
						+ childCols + 
						' from PO_Tracker_Options__r  where Sales_Price__c >= 0'+ 
						(whereClauseChild!=null ? ' '+ whereClauseChild : '' ) +
						' order by RMU_Date__c,Sales_Price__c ' +
						' )   '+
					' from BGA_PO_Tracker__c '+
					(whereClauseParent!=null ? ' where  '+ whereClauseParent : '' ) +  
					' Order By Make_model__c,SN__C' 
					;
					
					//System.debug('******************************************************'+qry);
					return qry;	
	}
	//prepare where clause and execute query
	List<sObject> getPlatformRMUInstalledData(
								String platformName,
								String stateName,
								String countryName){
		
		String pCols = 'Id,Fleet_Asset_Aircraft__r.Platform_Name__c,Charts_Platform_Family__c';
		String cCols = 'Id';
		
		for(String col : getParentColsApiNamesList())	{	pCols = col+','+pCols;	}
		for(String col : getChildColsApiNamesList()) 	{	cCols = col+','+cCols;	} 
		
		String builtWhereClause = ''; 
		if(stateName!= null){
			builtWhereClause = ' and State__c =\''+stateName+'\'';
		}
		if(countryName!= null){
			builtWhereClause = builtWhereClause + ' and Country__c =\''+countryName+'\'';
		}
		
		String whereClauseChild = '';
		try{
			whereClauseChild = whereClauseChild + 
			' and status__c in ('+
						convertToQueryInParameter(Label.penetrationStatusIncluded.split(';'))
						+')';
						
		}catch(Exception e){}
		
		return  Database.query(
								getQuery(
											pCols,
											cCols,
											'Charts_Platform_Family__c = \''+platformName+'\''+builtWhereClause, 
											whereClauseChild
										)
							);
		
		
	}	
	//create platforms group list
	public List<String> platformsList {get;set;}
	void createPlatformGroupList(){
		if(platformsList != null)
		return;
			platformsList = new List<String>();
			Schema.DescribeFieldResult fieldResult = RMU_Program_Name__c.Platform_Group_Name__c.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			   for( Schema.PicklistEntry f : ple){
			      platformsList.add(f.getValue());
			   }
			          			
	}
	
	// get po tracker displat columns
	public map<String,String> fieldNameVsLabel {get;set;}
	List<String> parentColList = null;
	public List<String> getParentColsApiNamesList(){
		if(parentColList != null)
		return parentColList;
		parentColList = new List<String>();
		fieldNameVsLabel = new Map<String,String>();
		Schema.FieldSet fs1 = Schema.SObjectType.BGA_PO_Tracker__c.fieldSets.getMap().get('AircraftDetails');
		for(FieldSetMember fsm: fs1.getFields()){
			parentColList.add(fsm.getFieldPath());
			fieldNameVsLabel.put(fsm.getFieldPath(),fsm.getLabel());
		}
		return parentColList;
	}
	
	// get po tracker options displat columns
	List<String> setCols = null;
	public  List<String> getChildColsApiNamesList(){
		if(setCols != null)
			return setCols; 
		else
			setCols = new List<String>();
		
		Schema.FieldSet fs1 = Schema.SObjectType.BGA_PO_Tracker_Entry__c.fieldSets.getMap().get('RMU_Name_Details_Fields');
		for(FieldSetMember fsm: fs1.getFields()){
			setCols.add(fsm.getFieldPath());
		}		
		return setCols;	
	}
	
	// create platform specific rmu values list
	void populatePlatformRMUDetailList(List<String> pltfrmNameList){
			
			if(rmuDetailList == null)
					rmuDetailList= new Map<String,List<String>>();
			else	return;
			
			for(String pltfrm : pltfrmNameList){
				rmuDetailList.put(pltfrm, new List<String>());
			}
			
			List<RMU_Program_Name__c>	listPltformRMUMap = [
																select 
																RMU_Name__c,RMU_Detail_Name__c,Platform_Group_Name__c
																from 
																RMU_Program_Name__c
																where Platform_Group_Name__c  in :pltfrmNameList
																and RMU_Name__c != null
																and RMU_Detail_Name__c != null
																order by RMU_Name__c,Report_Record_Display_Order__c,RMU_Detail_Name__c
															];
			
			
			for(RMU_Program_Name__c mapRec:listPltformRMUMap)	{
				String key =createRMUNameKey(mapRec.RMU_Name__c,mapRec.RMU_Detail_Name__c);
				rmuDetailList.get(mapRec.Platform_Group_Name__c).add(key);
			}
			
		
	}
	
	//to export data create region list
	public List<SelectOption> getRegionPickListValues(){
		List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--Select Region--'));
        List<BGA_Area_Contacts__c> lstBGAContacts = [select Name,State__c,Country_Code__c from BGA_Area_Contacts__c where Country_Code__c= 'US' order by Name ];
        
        for(BGA_Area_Contacts__c rec : lstBGAContacts){
        	options.add(new SelectOption(rec.Name, rec.Name));
        } 
        Schema.DescribeFieldResult fieldResult = BGA_PO_Tracker__c.Country__c.getDescribe();
   		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
   		
		   for( Schema.PicklistEntry f : ple){
		   	  if(f.getValue() != 'USA')	
		      options.add(new SelectOption(f.getLabel(), f.getValue()));
		   }
        return options;
	}
	// call data export page ( excel file page)
	public PageReference getDataExport(){
		if(regionName!=null){
				String[] regionsVals = regionName.split(' - ');
				if(regionsVals[0]!='US')
				countryCode = regionsVals[0];
				if(regionsVals.size() > 1)
				stateCode = regionsVals[1];
		}
		else{stateCode = 'CA';}

		displayData = processData();
		PageReference retPage = new PageReference('/apex/poRMUAircraftRegionOperator');
		return retPage;
	}
	//custom string null value handler
	String nvlString(object str){
		if(str == null)
		return null;
		return String.valueOf(str);
	}
	// rmu name key generator method
	String createRMUNameKey(String rmuName,String rmuDetailName){
		if(exceptionRMUNames.containsKey(rmuDetailName)){
			rmuDetailName = exceptionRMUNames.get(rmuDetailName);
		}
		return (
						rmuName == rmuDetailName ? 
							rmuDetailName : 
							rmuName+' '+rmuDetailName
					).toLowerCase();
	}
	// convert array to string to inlcude in query where clause ( using with in operator)
	String convertToQueryInParameter(List<String> inputArray){
		String retVal = '';
		for(String kyVal :inputArray){
			retVal = retVal + '\''+kyVal+'\',';
		}
		retVal = retVal + '\'\'';
		return retVal;
	}
	
	public PageReference gotoPreviousPage(){
		return new PageReference('/a39/o');
	} 
	
	@isTest(SeeAllData=true)
	public static void classTestMethod(){
		PORMUSoldByCity prsbc = new PORMUSoldByCity();
		prsbc.getRegionPickListValues();
		prsbc.getDataExport();
		prsbc.regionName='US - AZ';
		prsbc.getDataExport();
		prsbc.gotoPreviousPage();
	}
	
	
}