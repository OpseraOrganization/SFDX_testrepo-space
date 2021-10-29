public with sharing virtual  class POTracker{
	
    public POTracker(){
           BGA_PO_Tracker_Utility_And_Constants();
           pageHeaderDetails();
    }
       public Boolean includeBlanks {get;set;}	
       public Boolean displayStatusSection {get;set;}
       List<String> rmuValues = new List<String>();
       public String relatedReportLabel {get;set;}
       public String reportParameter {get;set;}
       public String platformsNameCSV {get;set;}
       
       public String americasASMDashbaordId {get;set;}
       public String emeiaASMDashbaordId {get;set;}
       public String apacASMDashbaordId {get;set;}
       public String includeStatus; 
       public List<String> getRMUConfigValues(){
        
            if(rmuValues.size() == 0){
            	
                    List<PO_Tracker_Dashboard_Settings__c> listMap = 
                                            [   select 
                                                 Label_Value__c
                                                from PO_Tracker_Dashboard_Settings__c 
                                                where 
                                                Type__c = 'CHART_RMU_MAP'
                                                and LabelText__c = :platformParameterName
                                                order by order_by__c
                                            ];
                                            
                    for(PO_Tracker_Dashboard_Settings__c vals : listMap)    {
                        rmuValues.add(vals.Label_Value__c);
                    }
            }               
            
            return rmuValues;          
    }
    
    public List<String> getRMUConfigValuesWithout_Others(){
        List<String> retRMUList = new List<String>();  
        if(rmuValues.size() == 0){
            getRMUConfigValues();
        }
        for(String str : rmuValues)
        if(str != rmuMapValue.get('others')) {
            retRMUList.add(str);
        }
        
        return retRMUList;
                
    }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Code from Page Header
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        public Map<String,String> poRecTypeId {get;set;}
        public String currentPageName{get;set;}
        public String platformParameterName {get;set;}
        public List<String> rmuReportPlatforms{get;set;}
        public String chatLabelColor {set;get;}
        public Boolean isPlatform{get;set;}
        
        public void pageHeaderDetails(String rmuname,String currentPageName){
            
                platformParameterName = rmuname;
                currentPageName = currentPageName;
            
            
            poRecTypeId = getPoTrackerRecTypeId(platformParameterName);
            isPlatform = false;//isRMUChart(poRecTypeId);
            
            chatLabelColor = rmuMapValue.get('chatLabelColor');
            
        }
        
        protected void pageHeaderDetails(){
            
            if(System.currentPageReference()!= null){
                platformParameterName = System.currentPageReference().getParameters().get('rmuname');
                currentPageName = System.currentPageReference().getParameters().get('currentPageName');
            }
            
            poRecTypeId = getPoTrackerRecTypeId(platformParameterName);
            isPlatform = false;//isRMUChart(poRecTypeId);
            
            chatLabelColor = rmuMapValue.get('chatLabelColor');
            
        }

       public Map<String,String> getPoTrackerRecTypeId(String reportName){
       		Map<String,String> retMap = new Map<String,String>();
            if(reportName == null || reportName == ''){
                reportName =rmuMapValue.get('EasyII_F900X');
                retMap.put(reportName,reportName);
            }
            
            List<PO_Tracker_Dashboard_Settings__c>  rptPltfrmList = [   
                                                                        select Label_Value__c,Name, LabelText__c,Type__c,Include_Blanks__c,ASM_Dashboard__c,
                                                                        Display_Status_Section__c,StatusIncluded__c
                                                                        From PO_Tracker_Dashboard_Settings__c
                                                                        where Type__c in ( 'REPORT_PLATFORM_MAP','BGA_PO_TRACKER_REC_TYPE_ID')
                                                                        and (name = :reportName or LabelText__c = :reportName)
                                                                        order by Order_By__c
                                                                    ];
                                                                
            rmuReportPlatforms = new List<String>();                                                        
            for(PO_Tracker_Dashboard_Settings__c rec : rptPltfrmList){
                if(rec.Type__c == 'REPORT_PLATFORM_MAP'){
                    rmuReportPlatforms.add(rec.Label_Value__c);
                    
	                    if(platformsNameCSV == null)
	                    platformsNameCSV = rec.Label_Value__c ;
	                    else
	                    platformsNameCSV = platformsNameCSV + ','+rec.Label_Value__c ;
	                    
                }
                else if(rec.Type__c == 'BGA_PO_TRACKER_REC_TYPE_ID'){
                		 
	                    reportName = rec.Label_Value__c;
	                    for(String s : rec.Label_Value__c.split(';')){
	                    	retMap.put(s,s);
	                    	
	                    	if(reportParameter == null)
	                    	reportParameter = s;
	                    	else
	                    	reportParameter =reportParameter + ','+s;
	                    	
	                    }
	                    
	                    includeBlanks = rec.Include_Blanks__c;
	                    relatedReportLabel = rec.LabelText__c;
	                    displayStatusSection = rec.Display_Status_Section__c;
	                    includeStatus = rec.StatusIncluded__c;
	                    
	                    if(rec.ASM_Dashboard__c != null){
			                    Integer i=0;
			                    for(String s : rec.ASM_Dashboard__c.split(';')){
			                    	
			                    	if(i==0) 		americasASMDashbaordId  = s;
			                    	else if(i==1) 	emeiaASMDashbaordId     = s;
			                    	else if(i==2) 	apacASMDashbaordId      = s;
			                    	i++;
			                    }
	                    }
                    
                }
            }
            
            return retMap;
        }
        
        
        Boolean isRMUChart(String rmuName){
                    if(                     [   select 
                                                LabelText__c 
                                                from PO_Tracker_Dashboard_Settings__c 
                                                where 
                                                Type__c = 'CHART_RMU_MAP'
                                                and Label_Value__c = :rmuName
                                                order by order_by__c
                                            ].size() == 1
                    ){
                    	return true;
                    }
            
            return false;
        }
        
List<SelectOption> optionsRMUTypeData = null;
        public List<SelectOption> getRMUTypeData(){
        	
            if(optionsRMUTypeData == null){
                    List<SelectOption> options = new List<SelectOption>();
                    List<PO_Tracker_Dashboard_Settings__c> rmuList =
                                            [select 
                                            LabelText__c ,Label_Value__c,name
                                            from PO_Tracker_Dashboard_Settings__c 
                                            where 
                                            Type__c = 'BGA_PO_TRACKER_REC_TYPE_ID' order by order_by__c];
                    
                    for(PO_Tracker_Dashboard_Settings__c recVal: rmuList){
                        options.add(new SelectOption(recVal.name,recVal.LabelText__c));
                    }
                    optionsRMUTypeData = options;
                    return options;
            }
            return optionsRMUTypeData;
        }
        
        public List<SelectOption> getListOfCharts(){
            List<SelectOption> options = new List<SelectOption>();

            options.add(new SelectOption('PIE',rmuMapValue.get('PIE')));
            //options.add(new SelectOption('TOTALPM','Totals per month'));
            //options.add(new SelectOption('REV','Revenue'));
            //options.add(new SelectOption('SCHLD','Scheduled'));
            //options.add(new SelectOption('PENETRATION','Completed aircrafts penetration pie charts'));
                        
            return options;
        }
        
        public PageReference getNextPage(){
                setPageMapping();
                String nextPageName = 
                        (
                                isRMUChart(platformParameterName) == true
                                ? 
                                getNextPageName(currentPageName+'_PLTFRM') 
                                :
                                getNextPageName(currentPageName) 
                        );
                
                
                
                PageReference pageRef = new PageReference(
                                                            '/apex/'
                                                            +nextPageName
                                                            +'?rmuname='+platformParameterName
                                                            +'&isPlatform='+isPlatform
                                                            +'&currentPageName='+currentPageName
                                                            +'&sfdc.tabName=01rQ00000004mRY'
                                                    );
                pageRef.setRedirect(true);
                return pageRef;
        }
        Map<String,String> pageMapping = null;
        
        String getNextPageName(String name){
            
            if(pageMapping.containsKey(name)){
                return pageMapping.get(name);
            }
            else{
                return rmuMapValue.get('bga_po_tracker_pie_charts');
            }
            
        }
        
        void setPageMapping(){
            pageMapping = new Map<String,String>();
            
            pageMapping.put('PIE','poTrackerPieChartsRMUDetail');
            pageMapping.put('PIE_PLTFRM','poTrackerPieChartsRMUPlatform');

        
        }
                
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 // Utility and constants section
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
        public String readHdrSetting {get;set;}
        public Map<String,String> rmuMapValue {get;set;}
        public void BGA_PO_Tracker_Utility_And_Constants(){
            setLabelNameForRMU();
            readHdrSetting = rmuMapValue.get('headcolor');
            includeBlanks = false;
            
        }
        public void setLabelNameForRMU(){
                rmuMapValue = convertJsonIntoMap(Label.PO_Tracker_Head);
        }
        
        public String rmuShortNameValue(String inpt){
            if(rmuMapValue.containsKey(inpt)){
                return rmuMapValue.get(inpt);
            }
            else{
                return inpt;
            }
        }
        
       


    public String[] monthsList = new String[]{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
    
    public List<String> getMonthsList(){
        return monthsList;
    }
    
    public Integer getCurrentYear(){
        return Date.today().year();
    }

    public Integer getCurrentMonth(){
        return Date.today().month();
    }
    
    public Integer getLastYear(){
        return Date.today().year()-1;
    }
    
    public String get3CharMonthName(String input){
        if(input == null){
            return input;
        }
        if(String.valueOf(input) != null && String.valueOf(input).length() > 2 ){
            return String.valueOf(input);
        }
        else{
            return monthsList[Integer.valueOf(input)-1];
        }
    }       
    
    public List<String> getRegionValues(){
            List<String> options = new List<String>();
            Schema.DescribeFieldResult fieldResult = BGA_PO_Tracker__c.Region__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
               for( Schema.PicklistEntry f : ple){
                  options.add(f.getLabel());
               }       
            return options;
    }
    public String debugMsg {set;get{return debugMsg == null? '' : debugMsg;}}
    
    protected Map<String,String> convertJsonIntoMap(String jsonStr){
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
    
}