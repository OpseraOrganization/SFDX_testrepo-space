/******************************************************************
 * @Description: 
 * ****************************************************************/
public with Sharing class SPoG_DashboardMetricHelper {
    /***********************************************
    * @Description : Default Construcor to load default Data
    *  or Intialise parameters.
    * **********************************************/
    public Map<String,SPoG_Dashboard_Categories__mdt> mapendscategories = new Map<String,SPoG_Dashboard_Categories__mdt>();
    public Map<String,SPoG_Dashboard_Categories__mdt> mapshpscategories = new Map<String,SPoG_Dashboard_Categories__mdt>();
    public SPoG_DashboardMetricHelper(){
        for(SPoG_Dashboard_Categories__mdt each_catg : [Select DeveloperName,SPoG_Category_Name__c,SPoG_Category_Label__c,SPoG_Color_Code__c,SPoG_Order__c FROM SPoG_Dashboard_Categories__mdt WHERE ( MasterLabel = 'Encumbered' OR MasterLabel = 'Shipments' ) Order By SPoG_Order__c ASC]){
            if(each_catg.DeveloperName.startsWith('Encumbered')){
                mapendscategories.put(each_catg.SPoG_Category_Name__c,each_catg);
            }else{
                mapshpscategories.put(each_catg.SPoG_Category_Name__c,each_catg);
            }
        }
    }
    /***********************************************
    * @Description : Method will be invoked from Aura action handler class
    * and response is sent back to the calling class. 
    * **********************************************/
    public String getOrderMetrics(Map<String , Object> mapInputRequest) {
        String result = '';
        EncumberedMetricResults objResult = new EncumberedMetricResults(); 
        SPoG_InterfaceHelper objHandler = new SPoG_InterfaceHelper(); 
        Map<String,List<EncumberedMetricInfo>> encumberedDataInfo = new Map<String,List<EncumberedMetricInfo>>();
        List<ChartInfo> encumberedChartInfo = new List<ChartInfo>();
        Map<String,Object> mapInputs = mapInputRequest.containsKey('filtersData') && mapInputRequest.get('filtersData')!=null?(Map<String,Object>)mapInputRequest.get('filtersData'):new Map<String,Object>();
        System.debug('::=mapInputs=:: '+mapInputs);
        String custVal = (String) mapInputs.get('accname');
        String assignVal = (String) mapInputs.get('assgnval');
        String segVal = (String) mapInputs.get('segval');
        String regionVal = (String) mapInputs.get('regionval');
        String typeVal = (String) mapInputs.get('typeval');
        HttpResponse objResponse = objHandler.getOrderMetrics(custVal, assignVal, segVal, regionVal, typeVal);
        System.debug('Response received for order metrics '+objResponse.getBody());
        if(objResponse.getStatusCode() == 200 ) {
            objResult.isSuccess = true ; 
            EncumberedOrdersMetric objMetric = new  EncumberedOrdersMetric();
            Set<String> unique_orders = new Set<String>();
            objMetric = (EncumberedOrdersMetric) JSON.deserialize(objResponse.getBody(), EncumberedOrdersMetric.Class);    
            if(objMetric.OPEN_ORDERS.results.isEmpty()) {//empty results from SAP HANA
                objResult.isNoResult = true ; 
            }else {
                Integer counter = 0;
                for(EncumberedMetricInfo objInfo : objMetric.OPEN_ORDERS.results) {
                    if(mapendscategories.containsKey(objInfo.BLOCK_TYPE)) {
                        counter++;
                        unique_orders.add(objInfo.HW_ORDER_NUMBER);
                        if(encumberedDataInfo.containsKey(mapendscategories.get(objInfo.BLOCK_TYPE).SPoG_Category_Label__c)){
                        	encumberedDataInfo.get(mapendscategories.get(objInfo.BLOCK_TYPE).SPoG_Category_Label__c).add(objInfo);
                        }else{
                            encumberedDataInfo.put(mapendscategories.get(objInfo.BLOCK_TYPE).SPoG_Category_Label__c,new List<EncumberedMetricInfo>{objInfo});
                        }
                    }
                    objInfo.PO_NUMBER = objInfo.PO_NUMBER.contains('#')? objInfo.PO_NUMBER.replaceAll('#',''):objInfo.PO_NUMBER;
                   
                } 
                for(String key : mapendscategories.keySet()){
                    if(encumberedDataInfo.containsKey(mapendscategories.get(key).SPoG_Category_Label__c) && encumberedDataInfo.get(mapendscategories.get(key).SPoG_Category_Label__c)!=null){
                    	encumberedChartInfo.add(new ChartInfo(mapendscategories.get(key).SPoG_Category_Label__c,encumberedDataInfo.get(mapendscategories.get(key).SPoG_Category_Label__c).size(),mapendscategories.get(key).SPoG_Color_Code__c));
                    }
                }
                objResult.encumberedChartInfo = encumberedChartInfo;
                objResult.encumberedDataInfo  = encumberedDataInfo;
                objResult.uniqueorderscount		  = unique_orders.size();
                objResult.totalorderscount		  = counter;
            }
        }
        else {//returns isSuccess as false to UI denoting there was an error. 
            objResult.isSuccess = false ;            
        }
        result = JSON.serialize(objResult); 
        return result ; 
	} 
    /******************************************************
    * @Description : Wrapper instance to create JSON serialization
    * to be used by UI. 
    * ****************************************************/
    public with Sharing Class EncumberedMetricResults {
        public Boolean isSuccess = false ; 
        public Boolean isNoResult = false ;
        public Integer uniqueorderscount = 0;
        public Integer totalorderscount = 0;
        public List<ChartInfo> encumberedChartInfo = new List<ChartInfo>();
        public Map<String,List<EncumberedMetricInfo>> encumberedDataInfo = new Map<String,List<EncumberedMetricInfo>>();
    }
    /*************************************************
    * @Description : De-serialize class for JSON response.
    * Do Not modify variable names
    * *************************************************/
    public with Sharing Class EncumberedMetricInfo {
        public String GenID;
        public String SOLD_TO_NUMBER;
        public String ACCOUNT_NAME;
        public String HW_ORDER_NUMBER;
        public String PO_NUMBER;
        public String ITEM_NUMBER;
        public String MATERIAL;
        public String CRM_CASE;
        public String SERIAL_NUMBER;
        public String EDD_DATE;
        public String BLOCK_TYPE;
        public String SCHEDULE_LINE;
        public String SCHEDULE_LINE_BLOCK;
        public String DELIVERY_HEADER_BLOCK;
    }
    /******************************************************
    * @Description : Wrapper instance to combine label , value pair
    * to be used by chart UI. 
    * ****************************************************/
    public with Sharing Class ChartInfo {
        String label = '' ; 
        Integer count = 0 ; 
        String color = '';
        public ChartInfo(String displayValue , Integer displayCount, String displayColor) {
            label = displayValue ; 
            count = displayCount ; 
            color = displayColor ;
        }
    }
    /*************************************************
    * @Description : De-serialize class for JSON response.
    * Do Not modify variable names
    * *************************************************/
    private with Sharing Class EncumberedOrdersMetric {
        MetricResult OPEN_ORDERS = new MetricResult(); 
        public EncumberedOrdersMetric(){}
    }
    /*************************************************
    * @Description : De-serialize class for JSON response.
    * Do Not modify variable names
    * *************************************************/
    private with Sharing Class MetricResult {
        List<EncumberedMetricInfo> results = new List<EncumberedMetricInfo>(); 
        public MetricResult(){}
    }
    /***********************************************
    * @Description : Method will be invoked from Aura action handler class
    * and response is sent back to the calling class. 
    * **********************************************/
    public String getShipmentMetrics(Map<String , Object> mapInputRequest){
        String result = '';
        ShipmentMetricResults objResult = new ShipmentMetricResults(); 
        SPoG_InterfaceHelper objHandler = new SPoG_InterfaceHelper(); 
        List<ChartInfo> shipmentChartInfo = new List<ChartInfo>();
        Map<String,List<ShipmentMetricInfo>> shipmentDataInfo = new Map<String,List<ShipmentMetricInfo>>();
        Map<String,Object> mapInputs = mapInputRequest.containsKey('filtersData') && mapInputRequest.get('filtersData')!=null?(Map<String,Object>)mapInputRequest.get('filtersData'):new Map<String,Object>();
        System.debug('::=mapInputs=:: '+mapInputs);
        String custVal = (String) mapInputs.get('accname');
        String assignVal = (String) mapInputs.get('assgnval');
        String segVal = (String) mapInputs.get('segval');
        String regionVal = (String) mapInputs.get('regionval');
        String typeVal = (String) mapInputs.get('typeval');
        HttpResponse objResponse = objHandler.getShipmentMetrics(custVal, assignVal, segVal, regionVal, typeVal);
        System.debug('Response received for order metrics '+objResponse.getBody());
        if(objResponse.getStatusCode() == 200 ) {
            objResult.isSuccess = true ; 
            ShipmentMetric objMetric = new ShipmentMetric(); 
            objMetric= (ShipmentMetric) JSON.deserialize(objResponse.getBody(), ShipmentMetric.Class);    
            if(objMetric.SHIPMENTS.results.isEmpty()) {//empty results from SAP HANA
                objResult.isNoResult = true ; 
            }
            else {
                for( ShipmentMetricInfo objInfo : objMetric.SHIPMENTS.results){
                    if(mapshpscategories.containsKey(objInfo.DELIVERY_CATEGORY)) {
                        if(shipmentDataInfo.containsKey(mapshpscategories.get(objInfo.DELIVERY_CATEGORY).SPoG_Category_Label__c)){
                        	shipmentDataInfo.get(mapshpscategories.get(objInfo.DELIVERY_CATEGORY).SPoG_Category_Label__c).add(objInfo);
                        }else{
                            shipmentDataInfo.put(mapshpscategories.get(objInfo.DELIVERY_CATEGORY).SPoG_Category_Label__c,new List<ShipmentMetricInfo>{objInfo});
                        }
                    }
                    objInfo.PURCHASE_ORDER_NUMBER = objInfo.PURCHASE_ORDER_NUMBER.contains('#')? objInfo.PURCHASE_ORDER_NUMBER.replaceAll('#',''):objInfo.PURCHASE_ORDER_NUMBER;
                }
                System.debug('::= shipmentDataInfo =:: '+shipmentDataInfo);
                for(String key : mapshpscategories.keySet()){
                    if(shipmentDataInfo.containsKey(mapshpscategories.get(key).SPoG_Category_Label__c) && shipmentDataInfo.get(mapshpscategories.get(key).SPoG_Category_Label__c)!=null){
                    	shipmentChartInfo.add(new ChartInfo(mapshpscategories.get(key).SPoG_Category_Label__c,shipmentDataInfo.get(mapshpscategories.get(key).SPoG_Category_Label__c).size(),mapshpscategories.get(key).SPoG_Color_Code__c));
                    }
                }
                objResult.shipmentChartInfo = shipmentChartInfo;
                objResult.shipmentDataInfo = shipmentDataInfo;
            }
        }
        else {//returns isSuccess as false to UI denoting there was an error. 
            objResult.isSuccess = false ;            
        }
        result = JSON.serialize(objResult); 
        return result ; 
    }
        /******************************************************
    * @Description : Wrapper instance to create JSON serialization
    * to be used by UI. 
    * ****************************************************/
    public with Sharing Class ShipmentMetricResults {
        public Boolean isSuccess = false ; 
        public Boolean isNoResult = false ;
        public List<ChartInfo> shipmentChartInfo = new List<ChartInfo>();
        public Map<String,List<ShipmentMetricInfo>> shipmentDataInfo = new Map<String,List<ShipmentMetricInfo>>();
    }
    /*************************************************
    * @Description : De-serialize class for JSON response.
    * Do Not modify variable names
    * *************************************************/
    public with Sharing Class ShipmentMetricInfo {
        public String GenID;
         public String SOLD_TO_NUMBER ;
        public String SOLD_TO_NAME;
        public String SALES_ORDER_NUMBER;
        public String PURCHASE_ORDER_NUMBER;
        public String SERIAL_NUMBER;
        public String CLIN;
        public String PLANT;
        public String MATERIAL;
        public String AWB;
        public String ACTUAL_GI_DATE;
        public String DELIVERY_NUMBER;
        public String DELIVERY_DATE;
        public String DELIVERY_CATEGORY;
        public String LINE_ITEM;
        public String SCHEDULE_LINE;
        public String YOMT_WADAT; 
        public String LINE_ITEM_NUMBER;
    }
    /*************************************************
    * @Description : De-serialize class for JSON response.
    * Do Not modify variable names
    * *************************************************/
    private with Sharing Class ShipmentMetric {
        ShipmentMetricResult SHIPMENTS = new ShipmentMetricResult(); 
        public ShipmentMetric(){}
    }
    /*************************************************
    * @Description : De-serialize class for JSON response.
    * Do Not modify variable names
    * *************************************************/
    private with Sharing Class ShipmentMetricResult {
        List<ShipmentMetricInfo> results = new List<ShipmentMetricInfo>(); 
        public ShipmentMetricResult(){}
    }
}