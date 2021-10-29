public class POTrackerRMUDetailPieChartController extends POTrackerPieChartMaster{
    
    List<BGA_PO_Tracker__c> listPO = null;
    public String newDebugMsg{get;set;}
    public Map<String,List<List<PieWedgeData>>> maplistpwd  {get;set;}
    public Map<String,Integer[]> regionCnt {get;set;}
    public Integer globalCnt {get;set;}
    	   Integer withBasicCount = 0;
    public Map<String,Map<String,Integer>> statusCnt {get;set;} 
    public Map<String,String> constantValues {get;set;}
    Map<String,String> doIncludeStatus = new Map<String,String>();
    public POTrackerRMUDetailPieChartController(){
    	constantValues = convertJsonIntoMap(Label.PieCharts_Static_String);
		String statusValues = (includeStatus == null ? Label.penetrationStatusIncluded : includeStatus );
		for(String s :statusValues.split(constantValues.get('semicolon'))){
			doIncludeStatus.put(s,s);
			if(includeBlanks == true)
			doIncludeStatus.put('','NONE');	
		}
		
        statusCnt =  new Map<String,Map<String,Integer>>();
        statusCnt.put(constantValues.get('global'),null);
        globalCnt =0;
        getPODetails();
        setLabelNameForRMU();
        getRegionalEasy2Charts();
        getMonthlySalesData();
    }
     String printStatusCount(String region){
     	String retVal = '';
     	
     	if(statusCnt == null){
     		return retVal;
     	}

     	if(statusCnt.containsKey(region) && statusCnt.get(region) == null){
     		return retVal;	
     	}
     	
     	String blankStr = '';
     	for(String s : doIncludeStatus.keySet()){
     		
     		if(statusCnt.get(region).containsKey(s) && s != blankStr )
     		if(statusCnt.get(region).get(s) != null){
     			retVal = retVal + s +'=' +statusCnt.get(region).get(s)+''+constantValues.get('semicolon')+' ';
     		}
     	}
     	
     	if(doIncludeStatus.containsKey(blankStr) && statusCnt.get(region).containsKey(blankStr)){
     			if(statusCnt.get(region).get(blankStr) != null)
     			retVal = retVal + constantValues.get('blank') +'=' +statusCnt.get(region).get(blankStr)+''+constantValues.get('semicolon');
     		}
     	
     	
     	return retVal;
     }

	

    
    Boolean hasValidStatus(String status){
    	if(status == null)
    	status = '';
    	return doIncludeStatus.containsKey(status);
    }
    
    void getPODetails(){
            		
	                listPO  =   
	                [   
	                	select Name,SN__c,Id,Region__c,Date_APM_Shipped__c,Has_Baseline_or_Basic__c,Status__c,Number_of_options__c,
	                            (
	                                select 
	                                RMU_Config_Detail_Name__c , BGA_Purchase_Order__r.Has_Baseline_or_Basic__c
	                                from PO_Tracker_Options__r 
	                                where RMU_Config_Detail_Name__c != null 
	                                and RMU_Name__c in :poRecTypeId.keySet()
	                                and RMU_Config_Detail_Name__c != :constantValues.get('others')
	                                and RMU_Config_Detail_Name__c in :getRMUConfigValues()
	                                and Status__c in :doIncludeStatus.keySet()
	                             ) 
	                    from BGA_PO_Tracker__c 
	                    where Charts_Platform_Family__c in :rmuReportPlatforms 
	                    and Region__c != ''
	                    and Aircraft_not_in_service__c = false
	                    ];
	                
	                for(BGA_PO_Tracker__c rec: listPO){
	                	if(rec.Has_Baseline_or_Basic__c > 0 && hasValidStatus(rec.Status__c))
	                    withBasicCount++;
	                }
	                    
	                 
            }
                
    public Map<String,List<List<PieWedgeData>>> getRegionalEasy2Charts(){
        
        regionCnt = new Map<String,Integer[]>();
        Map<String,RMUConfigTable>  mapCatData = new Map<String,RMUConfigTable>();
        List<String> configPickListValues  = getRMUConfigValues(); 
        
        for(String regn : getRegionValues()){
            
            for(String val : configPickListValues)
            if(val != constantValues.get('others')){
                mapCatData.put(regn+val,new RMUConfigTable(regn,0));
            }
            
            regionCnt.put(regn,new Integer[]{0,0});
            statusCnt.put(regn,null);
        }
        
        
        for(BGA_PO_Tracker__c poDetl : listPO)
        if(poDetl != null && poDetl.Region__c != null )
       	{
                    
                    regionCnt.put(	poDetl.Region__c,
                    				new Integer[]{
                    								regionCnt.get(poDetl.Region__c)[0] + 1,
                    								regionCnt.get(poDetl.Region__c)[1]+
                    									(poDetl.Has_Baseline_or_Basic__c > 0 && hasValidStatus(poDetl.Status__c)? 1:0)
                    							}
                    				);
                    
                    if(						(poRecTypeId.containsKey(Label.Easy_II) && poDetl.Has_Baseline_or_Basic__c > 0)
	                        			||  (poRecTypeId.containsKey(Label.Cert_F) && poDetl.Has_Baseline_or_Basic__c > 0)
	                        			||  (!poRecTypeId.containsKey(Label.Cert_F) && !poRecTypeId.containsKey(Label.Easy_II) && poDetl.Number_of_options__c > 0 )
	                  )
	                        			
                    		addStatusCnt(poDetl.Region__c,poDetl.Status__c);
                    

                    
                    Map<String,Integer> rmuCount = new Map<String,Integer>();
                    
                     For(BGA_PO_Tracker_Entry__c poEntry : poDetl.PO_Tracker_Options__r){
                     	
	                        if(
	                        		poEntry!=null 
	                        		&&  (
	                        				(poRecTypeId.containsKey(Label.Easy_II) && poDetl.Has_Baseline_or_Basic__c > 0)
	                        			||  (poRecTypeId.containsKey(Label.Cert_F) && poDetl.Has_Baseline_or_Basic__c > 0)
	                        			||  (!poRecTypeId.containsKey(Label.Cert_F) && !poRecTypeId.containsKey(Label.Easy_II) )
	                        			)
	                        ){ 
	                        	
	                            if(!rmuCount.containsKey(poEntry.RMU_Config_Detail_Name__c)){
	                            	
	                                rmuCount.put(poEntry.RMU_Config_Detail_Name__c,1);
	                                mapCatData.put(
	                                            poDetl.Region__c+poEntry.RMU_Config_Detail_Name__c, 
	                                            new RMUConfigTable(
	                                            	poDetl.Region__c,
	                                            	mapCatData.get(poDetl.Region__c+poEntry.RMU_Config_Detail_Name__c).cnt 
	                                            	+ 1
	                                            )
	                                        );                                      
	                            
	                            }
	                        
	            		 }
	            		 
                     }
        }
        
        
        maplistpwd = new Map<String,List<List<PieWedgeData>>>();
        for(String regn : getRegionValues())
        for(String key : getRMUConfigValues())
        if(key != constantValues.get('others')){
            String labelKey = rmuShortNameValue(key);
            key = regn+key;
            
            if(maplistpwd.get(mapCatData.get(key).region) == null){
                maplistpwd.put(mapCatData.get(key).region,new List<List<PieWedgeData>>());
            }
            
            List<PieWedgeData> data = new List<PieWedgeData>();
            
            Integer totalCnt = regionCnt.get(mapCatData.get(key).region)[0];
            Integer baselineBasicCnt = regionCnt.get(mapCatData.get(key).region)[1];
            
            if(poRecTypeId.containsKey(Label.Easy_II)){
                         if(key.contains(constantValues.get('baselineonly'))){ 
                            if(mapCatData.get(key).cnt > 0)
                            data.add(new PieWedgeData(labelKey  ,  mapCatData.get(key).cnt,'Baseline',totalCnt));
                            data.add(new PieWedgeData(constantValues.get('baseline')+' '+constantValues.get('with')+' '+constantValues.get('opt') ,   mapCatData.get(regn+'Baseline').cnt, constantValues.get('baseline'),totalCnt));
                            if(totalCnt      -  mapCatData.get(key).cnt - mapCatData.get(regn+'Baseline').cnt > 0 )
                            data.add(new PieWedgeData(constantValues.get('nobaseline'),            totalCnt      -  mapCatData.get(key).cnt - mapCatData.get(regn+'Baseline').cnt,constantValues.get('baseline')));
                            maplistpwd.get(mapCatData.get(key).region).add(data);
                            
                        }
                        else if(!key.contains(constantValues.get('baseline'))){
                            
                            data.add(new PieWedgeData(''+constantValues.get('with')+' - '+  labelKey ,        mapCatData.get(key).cnt, labelKey,baselineBasicCnt));
                            if( baselineBasicCnt - mapCatData.get(key).cnt > 0)
                            data.add(new PieWedgeData(''+constantValues.get('without')+'  - ' + labelKey ,      baselineBasicCnt - mapCatData.get(key).cnt, labelKey) );
                            maplistpwd.get(mapCatData.get(key).region).add(data);
                        
                        }
            }
            else if(poRecTypeId.containsKey(Label.Cert_F)){
                        if(key.contains(constantValues.get('sv1'))){    
                        	if(mapCatData.get(regn+constantValues.get('sv2')).cnt > 0)
                            data.add(new PieWedgeData(constantValues.get('sv1_or_sv2') ,     	mapCatData.get(regn+constantValues.get('sv2')).cnt,''+constantValues.get('sv1_or_sv2')+'',baselineBasicCnt));
                            data.add(new PieWedgeData(''+constantValues.get('sv1')+' '+constantValues.get('only') ,   	mapCatData.get(key).cnt -   mapCatData.get(regn+constantValues.get('sv2')).cnt, ''+constantValues.get('sv1_or_sv2')+'',baselineBasicCnt));
                            if(baselineBasicCnt   -  mapCatData.get(key).cnt > 0)
                            data.add(new PieWedgeData(''+constantValues.get('without')+' '+constantValues.get('sv1_or_sv2')+'', baselineBasicCnt   -  mapCatData.get(key).cnt ,''+constantValues.get('sv1_or_sv2')+''));
                            maplistpwd.get(mapCatData.get(key).region).add(data);
                        }
                        else if(!key.contains(constantValues.get('sv2'))){
                            data.add(new PieWedgeData(''+constantValues.get('with')+' - '+  labelKey ,        mapCatData.get(key).cnt, labelKey,(key.contains(constantValues.get('basic'))? totalCnt:baselineBasicCnt)));
	                        if( (key.contains(constantValues.get('basic'))? totalCnt:baselineBasicCnt) - mapCatData.get(key).cnt > 0)
                            data.add(new PieWedgeData(''+constantValues.get('without')+'  - ' + labelKey ,      (key.contains(constantValues.get('basic'))? totalCnt:baselineBasicCnt) - mapCatData.get(key).cnt, labelKey) );
                            maplistpwd.get(mapCatData.get(key).region).add(data);
                        
                        }
            }
            else{
                            data.add(new PieWedgeData(''+constantValues.get('with')+' - '+  labelKey ,        mapCatData.get(key).cnt, labelKey,totalCnt));
                            if(totalCnt - mapCatData.get(key).cnt > 0 )
                            data.add(new PieWedgeData(''+constantValues.get('without')+'  - ' + labelKey ,      totalCnt - mapCatData.get(key).cnt, labelKey) );
                            maplistpwd.get(mapCatData.get(key).region).add(data);
            }
            
            
        }
        return maplistpwd;
    }

       public List<List<PieWedgeData>> getGlobalEasy2Charts(){
        Map<String,Integer>  mapCatData = new Map<String,Integer>();
        List<String> configPickListValues  = getRMUConfigValues(); 
        
        for(String val : configPickListValues)
        if(val != constantValues.get('others')) {
            mapCatData.put(val,0);
        }
        
        globalCnt = listPO.size();
        
        for(BGA_PO_Tracker__c poDetl : listPO)
        {
            Map<String,Integer> rmuCount = new Map<String,Integer>();
            
           if((poRecTypeId.containsKey(Label.Easy_II) && poDetl.Has_Baseline_or_Basic__c > 0)
	                        			||  (poRecTypeId.containsKey(Label.Cert_F) && poDetl.Has_Baseline_or_Basic__c > 0)
	                        			||  (!poRecTypeId.containsKey(Label.Cert_F) && !poRecTypeId.containsKey(Label.Easy_II) && poDetl.Number_of_options__c > 0 ))
            addStatusCnt('Global',poDetl.status__c);
            
            for(BGA_PO_Tracker_Entry__c poEntry : poDetl.PO_Tracker_Options__r) // This line blocks with basic/basline options
                if(poEntry != null &&  (
	                        				(poRecTypeId.containsKey(Label.Easy_II) && poDetl.Has_Baseline_or_Basic__c > 0)
	                        			||  (poRecTypeId.containsKey(Label.Cert_F) && poDetl.Has_Baseline_or_Basic__c > 0)
	                        			||  (!poRecTypeId.containsKey(Label.Cert_F) && !poRecTypeId.containsKey(Label.Easy_II) )
	                        			)
	              )
		            {
		                if(!rmuCount.containsKey(poEntry.RMU_Config_Detail_Name__c)){
		                                        rmuCount.put(poEntry.RMU_Config_Detail_Name__c,1);
		                                        mapCatData.put(poEntry.RMU_Config_Detail_Name__c, mapCatData.get(poEntry.RMU_Config_Detail_Name__c) + 1)  ;
		                                    }
		            }
            
            
        }
        
        List<List<PieWedgeData>> listpwd = new List<List<PieWedgeData>>();
        for(String key : getRMUConfigValues())
        if(key != constantValues.get('others')){
            List<PieWedgeData> data = new List<PieWedgeData>();
            
            if(poRecTypeId.containsKey(Label.Easy_II)){
                    if(key.contains(constantValues.get('baseline')) && key != constantValues.get('baseline')){
                    	if(mapCatData.get(key) > 0)  
                        data.add(new PieWedgeData(constantValues.get('baselineonly') ,        mapCatData.get(key),constantValues.get('baseline'),listPO.size()));
                        data.add(new PieWedgeData(constantValues.get('baseline')+' '+constantValues.get('with')+' '+constantValues.get('opt') ,        mapCatData.get(constantValues.get('baseline')), constantValues.get('baseline'),listPO.size()));
                        
                        if(listPO.size() -  mapCatData.get(key) - mapCatData.get(constantValues.get('baseline')) > 0)
                        data.add(new PieWedgeData(constantValues.get('nobaseline'),   listPO.size() -  mapCatData.get(key) - mapCatData.get(constantValues.get('baseline')),constantValues.get('baseline')));
                        listpwd.add(data);
                    }
                    else if(key != constantValues.get('baseline')){
                        data.add(new PieWedgeData(''+constantValues.get('with')+' - '+ rmuShortNameValue(key) ,      mapCatData.get(key), rmuShortNameValue(key),withBasicCount));
                        if(withBasicCount - mapCatData.get(key) > 0)
                        data.add(new PieWedgeData(''+constantValues.get('without')+'  - ' + rmuShortNameValue(key) ,  withBasicCount - mapCatData.get(key), rmuShortNameValue(key)) );
                        
                        listpwd.add(data);
                    }
            }
            else if(poRecTypeId.containsKey(Label.Cert_F)){
                if(key == constantValues.get('sv1')){   
                		if(mapCatData.get(constantValues.get('sv2')) > 0)
                        data.add(new PieWedgeData(constantValues.get('sv1_or_sv2') ,        mapCatData.get(constantValues.get('sv2')),constantValues.get('sv1_or_sv2'),withBasicCount));
                        data.add(new PieWedgeData(''+constantValues.get('sv1')+' '+constantValues.get('only') ,      (mapCatData.get(key) -  mapCatData.get(constantValues.get('sv2'))), constantValues.get('sv1_or_sv2'),withBasicCount));
                        if(withBasicCount -  mapCatData.get(key) > 0)
                        data.add(new PieWedgeData(''+constantValues.get('without')+' '+constantValues.get('sv1_or_sv2')+'',   withBasicCount -  mapCatData.get(key),constantValues.get('sv1_or_sv2')));
                        listpwd.add(data);
                    }
                    else if(key != constantValues.get('sv2')){
                        data.add(new PieWedgeData(''+constantValues.get('with')+' - '+ rmuShortNameValue(key) ,      mapCatData.get(key), rmuShortNameValue(key),(key.contains(constantValues.get('basic'))? listPO.size():withBasicCount)));
                        if( (key.contains(constantValues.get('basic'))? listPO.size():withBasicCount) - mapCatData.get(key) > 0)
                        data.add(new PieWedgeData(''+constantValues.get('without')+'  - ' + rmuShortNameValue(key) ,  (key.contains(constantValues.get('basic'))? listPO.size():withBasicCount) - mapCatData.get(key), rmuShortNameValue(key)) );
                        listpwd.add(data);
                    }
            }
            else{
                        data.add(new PieWedgeData(''+constantValues.get('with')+' - '+ rmuShortNameValue(key) ,      mapCatData.get(key), rmuShortNameValue(key),listPO.size()));
                        if(listPO.size() - mapCatData.get(key) > 0)
                        data.add(new PieWedgeData(''+constantValues.get('without')+'  - ' + rmuShortNameValue(key) ,  listPO.size() - mapCatData.get(key), rmuShortNameValue(key)) );
                        listpwd.add(data);
            }
        
        }
        return listpwd;
    }
        
	public Map<String,Map<String,Integer>> displayMonthlyData {get;set;}
	public List<String> ytdMonthsList {get;set;}
	void getMonthlySalesData(){
		
					List<AggregateResult> dataFromMonthlySales = 
							 [	select 
							 			RMU_Config_Detail_Name__c,
							 			CALENDAR_MONTH(RMU_Date__c) month ,
							 			Count(Id) 
								from 	BGA_PO_Tracker_Entry__c  
								where 	RMU_Name__c in :poRecTypeId.keySet()
									and CALENDAR_YEAR(RMU_Date__c) 	= :getCurrentYear()
	                                and RMU_Config_Detail_Name__c 	!= :constantValues.get('others')
	                                and RMU_Config_Detail_Name__c 	in :getRMUConfigValues()								
	                                and ( Sales_Price__c = null or Sales_Price__c >= 0 )
	                                and CALENDAR_MONTH(RMU_Date__c) <= :getCurrentMonth()
	                                and BGA_Purchase_Order__r.Status__c  in :doIncludeStatus.keySet()
	                                and BGA_Purchase_Order__r.Charts_Platform_Family__c in :rmuReportPlatforms 
								group by RMU_Config_Detail_Name__c,CALENDAR_MONTH(RMU_Date__c)
								order by RMU_Config_Detail_Name__c,CALENDAR_MONTH(RMU_Date__c)
							];
				
				displayMonthlyData = new Map<String,Map<String,Integer>>();
				ytdMonthsList = new List<String>();
				Integer cnt =1;
					for(String monthName : monthsList){
						ytdMonthsList.add(monthName);
						
						if(getCurrentMonth() <= cnt){
							break;
						}
						cnt ++;
						
					}
				
				for(String rec : getRMUConfigValues()){
					
					Map<String,Integer> newNode = new Map<String,Integer>();
					for(String monthName : ytdMonthsList){
						newNode.put(monthName , 0 );
					}
					
					if(rmuShortNameValue(rec) == constantValues.get('sv1') || rmuShortNameValue(rec) == constantValues.get('sv2')){
						displayMonthlyData.put(constantValues.get('sv1_or_sv2'),newNode);
					}
					else{
						displayMonthlyData.put(rmuShortNameValue(rec),newNode);
					}
					
				}
				
				 for (AggregateResult ar : dataFromMonthlySales) {
				 	
							if(	rmuShortNameValue(String.valueOf(ar.get('RMU_Config_Detail_Name__c'))) == constantValues.get('sv1') || 
								rmuShortNameValue(String.valueOf(ar.get('RMU_Config_Detail_Name__c'))) == constantValues.get('sv2')){
								
								displayMonthlyData.get(constantValues.get('sv1_or_sv2')).
								put(
										monthsList[Integer.valueof(ar.get('month'))-1],
										displayMonthlyData.get(constantValues.get('sv1_or_sv2')).get(monthsList[Integer.valueof(ar.get('month'))-1])+
										Integer.valueof(ar.get('expr0'))
									
									);
								
								
							}
							else if(	rmuShortNameValue(String.valueOf(ar.get('RMU_Config_Detail_Name__c'))).contains(constantValues.get('baseline'))){
										displayMonthlyData.get(constantValues.get('baseline')).put(
												monthsList[Integer.valueof(ar.get('month'))-1],
															displayMonthlyData.get(constantValues.get('baseline')).get(monthsList[Integer.valueof(ar.get('month'))-1]) 
														+ Integer.valueof(ar.get('expr0'))
											);
							}
							else if(displayMonthlyData.containsKey(String.valueOf(rmuShortNameValue(String.valueOf(ar.get('RMU_Config_Detail_Name__c')))))){
									
								displayMonthlyData.get(rmuShortNameValue(String.valueOf(ar.get('RMU_Config_Detail_Name__c')))).
								put(monthsList[Integer.valueof(ar.get('month'))-1],Integer.valueof(ar.get('expr0')));
							
							}
					
				}
							
		
	}    
	
	public String getPieColors2(){
		return constantValues.get('piecolor2'); 
	}
	public String getPieColors3(){
		return constantValues.get('piecolor3'); 
	}	
	
	public String getPrintGlobalCount(){
		return printStatusCount(constantValues.get('global'));
	}
	public String getPrintAmericasCount(){
		return printStatusCount(constantValues.get('americas'));
	}
		public String getPrintEMEIACount(){
		return printStatusCount(constantValues.get('emeia'));
	}
		public String getPrintAPACCount(){
		return printStatusCount(constantValues.get('apac'));
	}
    
    void addStatusCnt(String regn,String status){
	    	if(status == null){
	    		status = '';
	    	}
	    	
	    	if(
	    	//Label.penetrationStatusIncluded.contains(status)
	    	doIncludeStatus.containsKey(status)
	    	){		
			    	if(statusCnt.get(regn) == null){
			    		statusCnt.put(regn,  new Map<String,Integer>{status => 0});
			    	}
			    	if(statusCnt.get(regn).containsKey(status)){	
			    		statusCnt.get(regn).put(status,statusCnt.get(regn).get(status)+1);
			    	}
			    	else{
			    		statusCnt.get(regn).put(status,1);
			    	}
	    	}
    }
}