/********************************************
* @Description: Aura Controller class used by SPoG UI components. 
* Aura components will pass the input parameters in form of Map<String,value>
* which will be deserialized and used in respective helper classes. 
* ******************************************/
public with Sharing class SPoG_Handler {
    //aura actions
    private static final String LOAD_DASHBOARD_FILTERS = 'loadDashboardFilters';
    private static final String GET_ACCOUNTS_FILTERS = 'getAccountFilterData';
    private static final String GET_CONTACTS_FILTERS = 'getContactFilterData';
    private static final String USER_STATUS = 'getUserStatus';
    private static final String GET_ACCOUNTS = 'getAccountData';
    private static final String GET_CASES = 'getCaseData';
    private static final String SEARCH_ACCOUNTS = 'searchAccounts';
    private static final String GET_CASE_LIST_DATA = 'getCasesList';
    private static final String GET_ORDER_METRICS = 'getOrderMetrics';
    private static final String GET_SHIPMENT_METRICS = 'getShipmentMetrics'; 
    private static final String GET_CUSTOMER_INFO = 'getCustomerInfo';
    private static final String GET_SALES_OFFICE = 'getSalesOffice';
    private static final String GET_STOCK_AVAILABILITY = 'getStockAvailability'; 
    private static final String GET_PRICING_INFO = 'getPricingInfo' ; 
    //private static final String GET_ORDER_SUMMARY = 'getOrderSummary';
    private static final String GET_PO_ATTACHMENT = 'getPOAttachment' ; 
    private static final String GET_OPEN_CLAIMS = 'getOpenClaimCases';
    private static final String GET_SAP_CLAIMS = 'getSAPClaims';
    private static final String GET_DELIVERY_SUMMARY = 'getDeliverySummary';
    private static final String SEARCH_CUSTOMER = 'customerSearch';
    private static final String COUNTRY_INFO = 'countryInfo';
    private static final String DELETE_ATTACHMENT = 'deleteAttachment'; 
    private static final String GET_DETAILS = 'getOrderDetails';
    private static final String SEARCH_ORDERS = 'searchOrders';
    //private static final String CURRENT_USER_TRACKING = 'currentUserTracking' ;
    
    /*******************************************************************
* 
* *****************************************************************/
    @AuraEnabled
    public static String executeRequest(String serverInput) {
        String result = ''; 
        System.debug('Input Value'+serverInput); 
        if(String.isNotBlank(serverInput)) {
            Map<String , Object> mapInputRequest = (Map<String , Object>) JSON.deserializeUntyped(serverInput); 
            String action = (String) mapInputRequest.get('doAction'); 
            if(LOAD_DASHBOARD_FILTERS.equalsIgnoreCase(action)) {
                SPoG_DashboardFilters objHelper = new SPoG_DashboardFilters(); 
                result = objHelper.loadFilters(); 
            }
            if(GET_ACCOUNTS_FILTERS.equalsIgnoreCase(action)) {
                String searchStr = mapInputRequest.containsKey('searchString')?(String) mapInputRequest.get('searchString'):''; 
                List<String> seldata = mapInputRequest.containsKey('selectedData')?(List<String>) JSON.deserialize(JSON.serialize(mapInputRequest.get('selectedData')), List<String>.class):new List<String>();
                SPoG_DashboardFilters objHelper = new SPoG_DashboardFilters(); 
                result = objHelper.getDynamicFiltersData(searchStr,seldata,'Account'); 
            }
            if(GET_CONTACTS_FILTERS.equalsIgnoreCase(action)) {
                String searchStr = mapInputRequest.containsKey('searchString')?(String) mapInputRequest.get('searchString'):''; 
                List<String> seldata = mapInputRequest.containsKey('selectedData')?(List<String>) JSON.deserialize(JSON.serialize(mapInputRequest.get('selectedData')), List<String>.class):new List<String>();
                SPoG_DashboardFilters objHelper = new SPoG_DashboardFilters(); 
                result = objHelper.getDynamicFiltersData(searchStr,seldata,'Contact'); 
            }
            if(USER_STATUS.equalsIgnoreCase(action)) {
                SPoG_UserStatusHelper objHelper = new SPoG_UserStatusHelper(); 
                result = objHelper.getUserStatus(); 
            }
            if(GET_CASES.equalsIgnoreCase(action)) {
                SPoG_MyCasesHelper objHelper = new SPoG_MyCasesHelper(); 
                result = objHelper.getCaseChartData(mapInputRequest); 
            }
            else if(GET_ACCOUNTS.equalsIgnoreCase(action)){
                String searchStr = mapInputRequest.containsKey('searchString')?(String) mapInputRequest.get('searchString'):''; 
                List<String> seldata = mapInputRequest.containsKey('selectedData')?(List<String>) JSON.deserialize(JSON.serialize(mapInputRequest.get('selectedData')), List<String>.class):new List<String>();
                SPoG_MyCustomerHelper objHelper = new SPoG_MyCustomerHelper(); 
                result = objHelper.getSFDCAccountInfo(searchStr,seldata);
            }
            else if(SEARCH_ACCOUNTS.equalsIgnoreCase(action)){
                SPoG_MyCustomerHelper objHelper = new SPoG_MyCustomerHelper(); 
                result = objHelper.getCustomerInfo(mapInputRequest);
            }
            else if(GET_CASE_LIST_DATA.equalsIgnoreCase(action)){
                SPoG_MyCasesHelper objHelper = new SPoG_MyCasesHelper(); 
                result = objHelper.getCasesListData(mapInputRequest);
            }
            else if(GET_ORDER_METRICS.equalsIgnoreCase(action)) {
                SPoG_DashboardMetricHelper objHelper = new SPoG_DashboardMetricHelper(); 
                result = objHelper.getOrderMetrics(mapInputRequest); 
            }
            else if(GET_SHIPMENT_METRICS.equalsIgnoreCase(action)){
                SPoG_DashboardMetricHelper objHelper = new SPoG_DashboardMetricHelper(); 
                result = objHelper.getShipmentMetrics(mapInputRequest); 
            }
            else if(GET_CUSTOMER_INFO.equalsIgnoreCase(action)){
                SPoG_MyCustomerHelper objHelper = new SPoG_MyCustomerHelper(); 
                result = objHelper.getSAPInfo(mapInputRequest);
            }
            /*else if(GET_SALES_OFFICE.equalsIgnoreCase(action)) {
                SPoG_Utility objHelper = new SPoG_Utility(); 
                result = objHelper.getCurrentUserInfo(); 
            }*/
            else if(GET_STOCK_AVAILABILITY.equalsIgnoreCase(action)){
                SPoG_StocksHelper objHelper = new SPoG_StocksHelper(); 
                result = objHelper.getStockAvailability(mapInputRequest); 
                
            }
            else if(GET_PRICING_INFO.equalsIgnoreCase(action)){
                SPoG_PricingHelper objHelper = new SPoG_PricingHelper(); 
                result = objHelper.getPricingInfo(mapInputRequest); 
                
            }
            /*else if(GET_ORDER_SUMMARY.equalsIgnoreCase(action)){
                SPoG_OrdersHelper objHelper = new SPoG_OrdersHelper(); 
                result = objHelper.getOrderSummary(mapInputRequest); 
            }*/
            else if(GET_PO_ATTACHMENT.equalsIgnoreCase(action)) {
                SPoG_OrdersHelper objHelper = new SPoG_OrdersHelper(); 
                result = objHelper.getAttachment(mapInputRequest); 
            }
            else if(GET_SAP_CLAIMS.equalsIgnoreCase(action)){
                SPoG_ClaimsHelper objHelper = new SPoG_ClaimsHelper(); 
                result = objHelper.getReturnOrders(mapInputRequest); 
                system.debug('GET_SAP_CLAIMS::::::'+result);
            }
            else if(SEARCH_CUSTOMER.equalsIgnoreCase(action)) {
                SPoG_MyCustomerHelper objHelper = new SPoG_MyCustomerHelper(); 
                result = objHelper.doCustomerSearch(mapInputRequest); 
            }
            else if(DELETE_ATTACHMENT.equalsIgnoreCase(action)){
                SPoG_OrdersHelper objHelper = new SPoG_OrdersHelper(); 
                objHelper.deleteAttachment(mapInputRequest); // deletion do not send any response back.
            }
            else if(GET_DETAILS.equalsIgnoreCase(action)) {
                SPoG_OrdersHelper objHelper = new SPoG_OrdersHelper(); 
                result = objHelper.getOrderDetails(mapInputRequest); 
            }
            else if(GET_DELIVERY_SUMMARY.equalsIgnoreCase(action)) {
                SPoG_OrdersHelper objHelper = new SPoG_OrdersHelper(); 
                result = objHelper.getDeliverySummary(mapInputRequest); 
            }
            
            
            else if(SEARCH_ORDERS.equalsIgnoreCase(action)) {
                SPoG_OrdersHelper objHelper = new SPoG_OrdersHelper(); 
                result = objHelper.searchOrders(mapInputRequest); 
            }
            else if(COUNTRY_INFO.equalsIgnoreCase(action)) {
                SPoG_MyCustomerHelper objHelper = new SPoG_MyCustomerHelper(); 
                result = objHelper.doCountryInfo();
                //result = objHelper.doCustomerSearch(mapInputRequest); 
            }
           /* else if(CURRENT_USER_TRACKING.equalsIgnoreCase(action)) {
                SPoG_MyCustomerHelper objHelper = new SPoG_MyCustomerHelper(); 
                result = objHelper.currentUserTracking(mapInputRequest); 
            } */
        }
        
        return result ; 
    }
    
    
    
    public class PicklistWrapper {
        @AuraEnabled public string labelName;
        @AuraEnabled public string labelValue;
    } 
        
      
}