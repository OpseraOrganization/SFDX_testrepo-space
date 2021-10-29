public with sharing class POTrackerDataExport {
  	
/*
	This program is developed to create po tracker excel report in summary formart.
	Developed by 		: Varun Nirala
	Development Date 	: 11-Jan-2013 
*/

public Map<String,String> constantValue{get;set;}
public Map<String,String> backGroundColor {get;set;}
public Map<String,String> doPrintExtraColumns{get;set;}
public POTrackerDataExport(){
	// Initialize constant values using JSON Label
	constantValue = convertJsonIntoMap(Label.BGAPOTrackerDataExportCustomDetails);
	doPrintExtraColumns = convertJsonIntoMap(Label.BGAPOTrackerDataExportDisplayExtraColumns);
	
	familyName    = ApexPages.currentPage().getParameters().get('familyName');
	
	if(familyName == null)
	familyName    = constantValue.get('defaultFamilyName');
	
	if(familyName!=null){
		familyFileName = familyName.replaceAll(' ', '');
	}
	
	sDate 				= ' Date';
	sValue				= ' Value';
	populateAdditionaColsDetails();
	
	// Initialize column values using JSON Label
	getParentLstColumnsList();
	getChildLstColumnsList();
	getChildAdditionaCols();
}

public String sDate 				{get;set;}
public String sValue 				{get;set;}
String familyName					= null;
public String familyFileName 		{get;set;}

public List<Map<String,String>> getListPOAircrafts(){
	//return variable listRecords
	List<Map<String,String>> listRecords = new List<Map<String,String>>();
		
		// Prepare data fetch query, dynamic based on JSON column configuration
		String qry = 
			' select '+getColumnListForQry(parentLst)+', '+
				' ('+
				' select'+ 
				' BGA_Purchase_Order__c,RMU_Config_Detail_Name__c,RMU_Date__c,Value__c,Discount__c,Sales_Price__c,'
				+ getColumnListForQry(childAdditionaCols) + 
				' from PO_Tracker_Options__r  '+ 
				' where RMU_Config_Detail_Name__c <> \'Others\' order by RMU_Date__c,Sales_Price__c' +
				' )   '+
			' from BGA_PO_Tracker__c'+
			' where Charts_Platform_Family__c = \''+familyName+'\' ' + //' and Id in (\'a39e00000008Ur0\',\'a39e00000008Uqu\') ' +
			' Order By SN__C ' + 
			+ (constantValue.containsKey('limitRec')? 'LIMIT '+constantValue.get('limitRec') : '')
			;
		
		
		Map<String,SObject> sObjectResult = 		new Map<String,SObject>(Database.query(qry));
		
		// Start preparing data map to display data into excel/view
		System.debug('record list size.............'+sObjectResult.keySet().size());
		
		for (String ky : sObjectResult.keySet())  {
				// innerMap variable will be pupulated and added to return list
				Map<String,String> innerMap = new Map<String,String>();
				
				SObject ar = sObjectResult.get(ky);
				
				// innerMap variable with the parent tracker columns
				for(String s : parentLst){
					
					Object colValue = ar.get(s);
					
					if(checkIfDate(colValue)){
						colValue = ((Date)colValue).format();
					}
					
					innerMap.put(s,nvlString(colValue));
					
				}
				
				// innerMap variable with the child tracker entry columns -- default with hypen
				for(String s : childLst){
					innerMap.put(s,				constantValue.get('hypen'));
					innerMap.put(s+sDate,		constantValue.get('hypen'));
					innerMap.put(s+sValue,		constantValue.get('hypen'));
					
					for(String addCol : mapAdditionalCols.keySet()){
						innerMap.put(s+mapAdditionalCols.get(addCol),	constantValue.get('hypen'));
					}
					
				}
				
				List<SObject> poDetlrecords = ar.getSObjects('PO_Tracker_Options__r');
				
				Map<String,SObject> rollupPoOptionsMap = new Map<String,SObject>();
				
				//rollupPoOptionsMap is prepared to rollup/sum salesprice of multiple po tracker entries for given tail with same rmu detail name
				if(poDetlrecords!= null)
					for(SObject rec : poDetlrecords){
					
							String key = rec.get('BGA_Purchase_Order__c')+' - ' + rec.get('RMU_Config_Detail_Name__c');
							
							if(!rollupPoOptionsMap.containsKey(Key)){
								
								rollupPoOptionsMap.put(key,rec.clone(true,true));
								
								if(Integer.valueOf(rec.get('Sales_Price__c')) < 0){
										rollupPoOptionsMap.get(key).put('RMU_Date__c',null);
								}
								
							}
							else{
								// if second entry for option found then goto following section and rollup data.  
													//Sum of values
													rollupPoOptionsMap.get(key).put(
														'Value__c',
														nvlInteger(Integer.valueOf(rollupPoOptionsMap.get(key).get('Value__c')))
														+
														nvlInteger(Integer.valueOf(rec.get('Value__c')))
													);
													
													//Sum of discounts
													rollupPoOptionsMap.get(key).put(
														'Discount__c',
														nvlInteger(Integer.valueOf(rollupPoOptionsMap.get(key).get('Discount__c')))
														+
														nvlInteger(Integer.valueOf(rec.get('Discount__c')))
													);
													
													if(Integer.valueOf(rec.get('Sales_Price__c')) >=0 && rollupPoOptionsMap.get(key).get('RMU_Date__c') == null){
														rollupPoOptionsMap.get(key).put('RMU_Date__c',rec.get('RMU_Date__c')); 
													}
													
													
													/* New Code to apend extra cols values e.g. APM part number/ PO# etc*/
													
													for(String addCol : mapAdditionalCols.keySet()){
															String[] colDetl = addCol.split(':');
															
															if(rec.get(colDetl[0]) != null){
																
																if(colDetl[1] == 'D'){
																	rollupPoOptionsMap.get(key).put(
																						colDetl[0],
																						getOverwriteDateReturnGreater(
																										((Date)rollupPoOptionsMap.get(key).get(colDetl[0])),
																										((Date)rec.get(colDetl[0]))
																									) 
																					);
																}
																else{
																	
																		if(	!	nvlString(rollupPoOptionsMap.get(key).get(colDetl[0])).
																				contains(String.valueof(rec.get(colDetl[0])))
																			)
																			{
																				rollupPoOptionsMap.get(key).put(
																						colDetl[0],
																						nvlString(rollupPoOptionsMap.get(key).get(colDetl[0])) + '/' +
																						rec.get(colDetl[0]) 
																					);
																		}
																}
																
															}	
													}	
													
													/* New code ends here */		
															
								
							}
							
					}
				
				// write tracker detail data into innerMap (overwrite the default hypen values) 
				
				if(poDetlrecords!=null)
				for(SObject recList : poDetlrecords){
					String key = recList.get('BGA_Purchase_Order__c')+' - ' + recList.get('RMU_Config_Detail_Name__c');
					
					SObject rec = rollupPoOptionsMap.get(key);
					
					for(String s : childLst){
						if(String.valueOf(rec.get('RMU_Config_Detail_Name__c')).equals(s)){	
							innerMap.put(s,constantValue.get('yesIndicator'));
							
							
							if(rec.get('RMU_Date__c') != null)
							innerMap.put(s+sDate,	String.valueOf(
									((Date)rec.get('RMU_Date__c')).format()
									));
							
							//if(rec.get('Sales_Price__c') != null)
							innerMap.put(s+sValue,	String.valueOf(
											nvlInteger(Integer.valueOf(rec.get('Value__c'))) - nvlInteger(Integer.valueOf(rec.get('Discount__c')))
									));
							
							
							for(String addCol : mapAdditionalCols.keySet()){
								
									String[] colDetl = addCol.split(':');
									
									if(rec.get(colDetl[0]) != null){
										if(colDetl[1] == 'D'){
											innerMap.put(s+mapAdditionalCols.get(addCol),	String.valueOf(
															((Date)rec.get(colDetl[0])).format()
															));
										}
										else{
											innerMap.put(
															s+mapAdditionalCols.get(addCol),String.valueof(rec.get(colDetl[0]))
														);
										}
										
											
									}	
												
							}

						}
					}
					
				}
				
				listRecords.add(innerMap);
			}
		
			return listRecords;
}

// get parent/tracker column list
List<String> parentLst = null;
public List<String> getParentLstColumnsList(){
		if(parentLst == null)
		parentLst = convertJsonIntoList(Label.BGAPOTrackerDataExportMasterColumns);
		
		return parentLst;
}

List<String> childAdditionaCols = null;
public List<String> getChildAdditionaCols(){
		if(childAdditionaCols == null)
		childAdditionaCols = convertJsonIntoList(Label.BGAPOTrackerDataExportChildAdditionalCols);
		
		for(Integer i=0;i<childAdditionaCols.size();i++){
			childAdditionaCols[i] = childAdditionaCols[i].split(':')[0];
		}
		
		return childAdditionaCols;
}

// get tracker entry column list
List<String> childLst = null;
public List<String> getChildLstColumnsList(){
	if(childLst == null){
		populateChildColumnsNew();
		String defaultColor = constantValue.get('colorCode1');
		for(String s : childLst){
			if(backGroundColor == null){
				backGroundColor = new Map<String,String>();
			}
			defaultColor =
			defaultColor.contains(constantValue.get('colorCode1'))
						?  constantValue.get('colorCode2') : constantValue.get('colorCode1');
			
			backGroundColor.put(s,defaultColor);
		}
	}
	return childLst;
}

 void populateChildColumnsNew(){
 	
	 	List<PO_Tracker_Dashboard_Settings__c> lstMapKey = [	select LabelText__c
																from PO_Tracker_Dashboard_Settings__c
																where Type__c =  'REPORT_PLATFORM_MAP'  
																and Label_Value__c = :familyName
														   ];
	 	
	 	if(lstMapKey!=null && lstMapKey.size() >0){
	 		
	 			String mapKey = lstMapKey[0].LabelText__c;
	 		 	List<PO_Tracker_Dashboard_Settings__c> lstRMUDetlName = 
	 		 												[	
	 		 													select Label_Value__c
																from PO_Tracker_Dashboard_Settings__c
																where Type__c in ('CHART_RMU_MAP','EXPORT_COLUMN')  
																and LabelText__c = :mapKey
																order by Order_By__c
														   ];
	 		
	 		
		 		if(childLst == null)
		 		childLst = new List<String>();
	 		
	 			for(PO_Tracker_Dashboard_Settings__c strRmuDetlName : lstRMUDetlName){
	 				childLst.add(strRmuDetlName.Label_Value__c);
	 			}
	 		
	 		
	 	}
 	
 }

// column lables
Map<String,String> parentColLabel=null;
public Map<String,String> getParentColLabel(){
	if(parentColLabel==null){
		parentColLabel = convertJsonIntoMap(Label.BGAPOTrackerDataExportMasterColumns); 
	}
	return parentColLabel;
}

// map if extra columns need to be printed
Map<String,String> doPrintOtherCol=null;
public Map<String,String> getDoPrintOtherCol(){
	if(doPrintOtherCol==null){
		doPrintOtherCol = new Map<String,String>();
		for(String rmuDetlName : childLst){
			doPrintOtherCol.put(
								rmuDetlName,
								(doPrintExtraColumns.containsKey(rmuDetlName)?doPrintExtraColumns.get(rmuDetlName) : 'false')
						);
		} 
	}
	return doPrintOtherCol;
}

public Map<String,String> mapAdditionalCols {get;set;}

void populateAdditionaColsDetails(){
	if(mapAdditionalCols == null){
		mapAdditionalCols=  convertJsonIntoMap(Label.BGAPOTrackerDataExportChildAdditionalCols);
	}
}


//prepare query columns string
String getColumnListForQry(List<String> lstVal){
	String retVal = '';
	for(Integer i=0;i<lstVal.size();i++){
		if(i==0){retVal = lstVal[i];}
		else{retVal =  retVal + ',' + lstVal[i];}
	}
	return retVal;
}

// get json into list
List<String> convertJsonIntoList(String jsonStr){
        List<String> retMap = new List<String>(); 
        JSONParser parser = JSON.createParser(jsonStr);
            while (parser.nextToken() != null) {
                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME){     
                        String fiedName = parser.getText();
                        parser.nextToken();
                        String fiedValue = parser.getText();
                        retMap.add(fiedName);
                    }
            }
        return retMap;  
    }

// get json into map
Map<String,String> convertJsonIntoMap(String jsonStr){
        Map<String,String> retMap = new Map<String,String>(); 
        JSONParser parser = JSON.createParser(jsonStr);
            while (parser.nextToken() != null) {
                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME){     
                        String fiedName = parser.getText();
                        parser.nextToken();
                        String fiedValue = parser.getText();
                        retMap.put(fiedName,fiedValue);
                    }
            }
        return retMap;  
    }

// Integer Nvl
	Integer nvlInteger(Integer IntegerVal){
		return (IntegerVal == null ? 0 : IntegerVal);
	}
	
	Boolean checkIfDate(Object chkDate){
		if(chkDate == null)
		return false;
		
		if(chkDate instanceof Date)
			return true;
		else		
			return false;
	}
	
	String nvlString(Object obj){
		return (obj == null ? '' : String.valueOf(obj));
	}

	Date getOverwriteDateReturnGreater(Date mapDate, Date newDate ){
		
		if(mapDate == null){
			
			if(newDate != null) return newDate;
			else				return mapDate;
		
		}
		else {
			
				if(newDate != null){
					if(newDate >= mapDate) return newDate;
					else 				   return mapDate;
				}
				else
				return mapDate;
			
		}
		
	}

  	@isTest(SeeAllData=true)
    public static void testCoverage()
	{
		POTrackerDataExport  ptde = new POTrackerDataExport();
		ptde.getListPOAircrafts();
		ptde.getParentColLabel();
		ptde.getDoPrintOtherCol();
		ptde.checkIfDate(System.Today());
		ptde.checkIfDate('');
		ptde.nvlInteger(null);
		ptde.nvlString(null);
	}	
		
}