public class OrdersListPageController {

    public String queriedString { get; set; }
    public String presentUserHId {get; set;}
    public static Boolean testClassBool;
    
    public OrdersListPageController()
    {
        System.debug('hidden variable is '+presentUserHId);
    }
    
    public class orderclass {
        public orderclass1 d {get; set;}
    }

    public List<orderclass> orderList {get; set;}
    
    public class orderclass1{
        public List<orderclass2> results {get; set;}
    }
    
    public class orderclass2{
        public String orderNO {get; set;}
        public String custPO{get; set;}
        public String statusHDR{get; set;}
        public String orderDATE {get; set;}
        public String plant {get; set;}
        public String estShipDATE {get; set;}
        public String colourCode {get; set;}
        public Date thisOrderDate{get; set;}
        public String wayBillNo{get; set;}
    }
    
    public static Date returnDate(String dateString)
    {
        Date thisOrderDate = null;
        if(String.isNotBlank(dateString))
        {
            List<String> dlist = dateString.split('/');
            thisOrderDate = Date.newInstance(Integer.valueOf(dlist[2]), Integer.valueOf(dlist[0]), Integer.valueOf(dlist[1]));
        }
        return thisOrderDate;
    }
    
    public List<orderclass> orderList2 {get; set;} 
    public list<orderclass> a5 = new list<orderclass>();
    
    
    /*
    @RemoteAction
    public static mainWrapper SendRequest(String hId, string Status){
        
        System.debug('Now hid is '+hId);
        mainWrapper wrap = new mainWrapper();
        Map<String, orderclass2> normalOrders = new Map<String, orderclass2>();
        Map<String, orderclass2> shippedOrders = new Map<String, orderclass2>();
        //string custNo =  get_soldto('aaronf'); //Honeywell id hard coded for testing. Replace it with variable hid.
        string custNo =  get_soldto(hId);
        if(String.isNotBlank(custNo))
        {
            
            System.debug(custNo);
            String end_point;
            if(status == 'Open'){
            end_point=label.Order_Status_Endpoint+'ON%20HOLD,ON%20TIME,WAITING%20FOR%20UNIT,IN%20RECEIVING,BEHIND%20SCHEDULE,PAST%20DUE%27%20and%20custNO%20eq%20%27'
            +custNo+'%27%20&$format=json';
            }else{
            end_point=label.Order_Status_Endpoint+'SHIPPED%27%20and%20custNO%20eq%20%27'+custNo+'%27%20&$format=json';
            
            }
            String unampass =label.Order_Status_User;

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(end_point);
            request.setMethod('GET');
            Blob headerValue = Blob.valueOf(unampass);
            String authorizationHeader ='Basic ' + EncodingUtil.base64Encode(headerValue);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', authorizationHeader);
            request.setTimeout(120000);
            Integer sCode;
            HttpResponse response;

            IF(!TEST.isRunningTest())
            {
                response = http.send(request);
                System.debug(response);
                sCode = response.getStatusCode();
            }
            else
            {
                sCode=300;
                response = OrdersListPageController.testClassCall(testClassBool);
            }

            if (response.getStatusCode() == 200) {
                sCode = 200;
                
                System.debug('Response ' + response.getBody());
                orderclass o = (orderclass)JSON.deserialize(response.getBody(), orderclass.class);
                Set<String> greenSet = new Set<String>{'ON TIME', 'WAITING FOR UNIT', 'IN RECEIVING'};
                Set<String> shippedSet = new Set<String>{'SHIPPED', 'CLOSED'};
                integer i = 0;
                integer j = 0;
                
                for(orderclass2 eachwrap : o.d.results)
                {
                    if(greenSet.contains(eachwrap.statusHDR))
                    {
                        eachwrap.colourCode = 'DAR-delivered';
                    }
                    else
                    {
                        eachwrap.colourCode = 'DAR-pending';
                    }

                    if(shippedSet.contains(eachwrap.statusHDR) && i<10 )
                    {
                        //wrap.others.add(eachwrap);
                        i++;
                        shippedOrders.put(eachwrap.custPO, eachwrap);
                    }
                    else if(j<200){
                        j++;
                        //wrap.holdtime.add(eachwrap); 
                        normalOrders.put(eachwrap.custPO, eachwrap);
                        }
                }
                System.debug('normalOrders ' + normalOrders);
                System.debug('shippedOrders ' + shippedOrders);
                wrap.others = shippedOrders;
                wrap.holdtime = normalOrders;
            }

            if(sCode == 200) {
            DP_Error_Log__c elog = new DP_Error_Log__c();
                elog.time__c = datetime.now();
                elog.status__c = 'Success';
                string descp = response.getBody();
                if(string.valueof(descp).length()>32700) {  
                elog.description__c = 'Order Status'+string.valueof(descp.substring(0,32700));
                }
                else {
                elog.description__c = 'Order Status'+ response.getBody();
                }
                insert elog;
            }
            else {
                DP_Error_Log__c elog = new DP_Error_Log__c();
                elog.time__c = datetime.now();
                elog.status__c = 'Failed';
                string descp = response.getBody();
                if(string.valueof(descp).length()>32700) {  
                elog.description__c = 'Order Status'+string.valueof(descp.substring(0,32700));
                }
                else {
                elog.description__c = 'Order Status'+ response.getBody();
                }
                insert elog;
            }
            System.debug('wrap ' + wrap);
            return wrap;
        }
        else
        {
            return null;
        }
    }*/
    
    @RemoteAction
    public static List<orderclass2> SendRequest(String hId, string Status){
        
        List<orderclass2> returnList = new List<orderclass2>();
        //string custNo =  get_soldto('aaronf'); //Honeywell id hard coded for testing. Replace it with variable hid.
        string custNo =  get_soldto(hId);
        if(String.isNotBlank(custNo))
        {
            System.debug(custNo);
            String end_point;
            if(status == 'Open'){
            end_point=label.Order_Status_Endpoint+'ON%20HOLD,ON%20TIME,WAITING%20FOR%20UNIT,IN%20RECEIVING,BEHIND%20SCHEDULE,PAST%20DUE%27%20and%20custNO%20eq%20%27'
            +custNo+'%27%20&$format=json';
            }else{
            end_point=label.Order_Status_Endpoint+'SHIPPED%27%20and%20custNO%20eq%20%27'+custNo+'%27%20&$format=json';
            
            }
                        
            String unampass =label.Order_Status_User;

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(end_point);
            request.setMethod('GET');
            Blob headerValue = Blob.valueOf(unampass);
            String authorizationHeader ='Basic ' + EncodingUtil.base64Encode(headerValue);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', authorizationHeader);
            request.setTimeout(120000);
            Integer sCode;
            HttpResponse response;

            IF(!TEST.isRunningTest())
            {
                response = http.send(request);
                System.debug(response);
                sCode = response.getStatusCode();
            }
            else
            {
                sCode=300;
                response = OrdersListPageController.testClassCall(testClassBool);
            }

            if (response.getStatusCode() == 200) {
                sCode = 200;
                            
               orderclass o = (orderclass)JSON.deserialize(response.getBody(), orderclass.class);
                System.debug('!!!!!orderclass ' + o);
                Set<String> greenSet = new Set<String>{'ON TIME', 'WAITING FOR UNIT', 'IN RECEIVING', 'SHIPPED'};
                Set<String> shippedSet = new Set<String>{'SHIPPED', 'CLOSED'};
                Map<Date, List<orderclass2>> mapOrder = new Map<Date, List<orderclass2>>();
                List<orderclass2> orders;
                List<orderclass2> noOrderDateOrders = new List<orderclass2>();
                
                //newly added priya
                Map<string,DirectAccess_SiteDetails__c> mapOfDirectAccessCustomSetting = new Map<string,DirectAccess_SiteDetails__c>();
                mapOfDirectAccessCustomSetting  = DirectAccess_SiteDetails__c.getall();
            
                for(orderclass2 eachwrap : o.d.results)
                {
                    eachwrap.thisOrderDate = returnDate(eachwrap.orderDATE);
                    if(greenSet.contains(eachwrap.statusHDR))
                    {
                        eachwrap.colourCode = 'DAR-delivered';
                    }
                    else
                    {
                        eachwrap.colourCode = 'DAR-pending';
                    }
                    
                    if(!mapOfDirectAccessCustomSetting.isEmpty() && mapOfDirectAccessCustomSetting.containsKey(eachwrap.plant))
                    {
                        eachwrap.plant = mapOfDirectAccessCustomSetting.get(eachwrap.plant).Site_Name__c;
                    }
                    
                    if(eachwrap.thisOrderDate != null)
                    {
                        if(mapOrder.containsKey(eachwrap.thisOrderDate))
                        {
                            mapOrder.get(eachwrap.thisOrderDate).add(eachwrap);
                        }
                        else
                        {
                            orders = new List<orderclass2>();
                            orders.add(eachwrap);
                            mapOrder.put(eachwrap.thisOrderDate, orders);
                        }
                    }
                    
                   
                    
                    /*if(shippedSet.contains(eachwrap.statusHDR) && i<10 )
                    {
                        //wrap.others.add(eachwrap);
                        i++;
                        shippedOrders.put(eachwrap.custPO, eachwrap);
                    }
                    else if(j<200){
                        j++;
                        //wrap.holdtime.add(eachwrap); 
                        normalOrders.put(eachwrap.custPO, eachwrap);
                        }*/
                    
                }
                o = null;
                System.debug('!!!!mapOrder ' + mapOrder);
                List<Date> dateList = new List<Date>(mapOrder.keySet());
                System.debug('!!!!!!!List now is ' + dateList);
                Integer mapsize = dateList.size();
                Integer maxcount;
                Integer thisCount = 0;
                if(Status == 'Open')
                {
                    maxcount = 100;    
                }
                else
                {
                    maxcount = 10;
                }
                
                for(Integer i = (mapsize - 1); i >= 0; i--)
                {
                    System.debug('!!!!this date ' + dateList[i]);
                    for(orderclass2 order : mapOrder.get(dateList[i]))
                    {
                        thisCount += 1;
                        
                        returnList.add(order);
                        
                        if(thisCount == maxcount)
                        {
                            break;
                        }
                    }
                    
                    if(thisCount == maxcount)
                    {
                        break;
                    }
                }
                mapOrder = null;
                dateList = null;
                
                if(thisCount < maxcount)
                {
                    for(orderclass2 order : noOrderDateOrders)
                    {
                        thisCount += 1;
                        returnList.add(order);
                        
                        if(thisCount == maxcount)
                            break;
                    }
                }
                System.debug('!!!!returnList ' + returnList);
                
            }

            if(sCode == 200) {
            DP_Error_Log__c elog = new DP_Error_Log__c();
                elog.time__c = datetime.now();
                elog.status__c = 'Success';
                string descp = response.getBody();
                if(string.valueof(descp).length()>32700) {  
                elog.description__c = 'Order Status'+string.valueof(descp.substring(0,32700));
                }
                else {
                elog.description__c = 'Order Status'+ response.getBody();
                }
                insert elog;
            }
            else {
                DP_Error_Log__c elog = new DP_Error_Log__c();
                elog.time__c = datetime.now();
                elog.status__c = 'Failed';
                string descp = response.getBody();
                if(string.valueof(descp).length()>32700) {  
                elog.description__c = 'Order Status'+string.valueof(descp.substring(0,32700));
                }
                else {
                elog.description__c = 'Order Status'+ response.getBody();
                }
                insert elog;
            }
            System.debug('returnList ' + returnList);
            return returnList;
        }
        else
        {
            return null;
        }
    }
    
//removes leading zeros from a passed string of numbers or returns NULL when not all numeric characters
    public static String drop_leading_zeros(String passedValue) {
        String return_string = null; //return string for passing back
        if (passedValue != null) { //if the passed value is not null
            return_string = passedValue.trim(); //trim the whitespace from the start and end of the value
            Pattern valid_characters = Pattern.compile('([0-9]+)'); //only numbers
            Matcher check_chars = valid_characters.matcher(return_string); //compare the string to the set of valid characters
            if (check_chars.matches()) { //if we have a somewhat valid number
                if (return_string.startsWith('0') && return_string.length() > 1) { //if the string begins with a 0 and the length is greater than 1
                    boolean keepChecking = true; //create a boolean variable
                    while (keepChecking) { //if boolean is true
                        if (return_string.startsWith('0') && return_string.length() > 1) { //if the string begins with 0 and there is more than 1 character
                            return_string = return_string.substring(1); //drop the first character
                        } else { //either the string doesn't begin with 0 or the length is less than or equal to 1
                            keepChecking = false; //stop the loop
                        }
                    }
                }
                if (return_string == '0') { //if the resulting string is now a single '0'
                    return_string = null; //set the string to null
                }
            } else { //otherwise the value passed was not valid
                return_string = null; //set the string to null
            }
        }
        return return_string; //pass back a value
    }
    
    //retrives SAP Sold to numbers for the logged in customer
    /*public static String get_soldto(String passedValue) {
     String return_string; //return string for passing back
        set<string>  cn= new set<string>(); 
        if (passedValue != null) { //if the passed value is not null
            portal_honeywell_id__c phi = [select contact__c, user_type__c from portal_honeywell_id__c where primary_honeywell_id__c= true AND contact__r.contact_status__c = 'ACTIVE' AND
            name =: passedValue limit 1];
            
        if(null!=phi){
            contact_tool_access__c cta =[select request_status__c  from  
            contact_tool_access__c where name = 'Order Status' and 
            crm_contact_id__c =: phi.contact__c and request_status__c = 'Approved' limit 1];
        if(null!=cta){
            list<account_contact__c> acccon = [select   account_name__c from account_contact__c  
            where contact__c =: phi.contact__c];
        
            list<account_cross_ref__c> acr=  new list<account_cross_ref__c>([select external_account_id__c from account_cross_ref__c where 
            account_name__c in(select   account_name__c from account_contact__c  
            where contact__c =: phi.contact__c) and account_status__c =
            'ACTIVE' and (not external_account_name__c like '%do not use%') and
            (not external_account_name__c like '%reference account%') and
            (not external_account_name__c like '%various%') and account_name__r.name 
            not in ('HONEYWELL UNIDENTIFIED PORTAL USERS','Honeywell Default Account',
            'NO ACCOUNT FOUND','FSR TEMPORARY OPERATOR','Portal Missing Users (Do not use)') 
            and (external_account_id__c like '%-01'  or external_account_id__c like '%-02' ) 
            and  XREF_Type__c = 'SAP_SOLD_TO'  ]);
        if(!acr.isempty()){
            system.debug('acrsize'+acr.size());
            for(account_cross_ref__c a:acr){
                system.debug('acr'+a.external_account_id__c);
                list<string> a1 = a.external_account_id__c.split('-');
                system.debug('acr0'+a1[0]);
                string a2 =OrdersListPageController.drop_leading_zeros(a1[0]);
        if(null!= a2){
            cn.add(a2);
            system.debug('cnlist'+cn);
            }
        }
        }
        }
        }  
        }
        if(!cn.isempty()){
        for (string s:cn){
        return_string += s+',';
        }
        return_string =return_string.subString(0,return_string.length());
        }
        return return_string; //pass back a value
    }*/
    
    public static String get_soldto(String passedValue) {
        
        System.debug('!!!!!!Incoming passedValue ' + passedValue);
        String return_string; //return string for passing back
        set<string>  cn= new set<string>(); 
        if (passedValue != null) //if the passed value is not null
        { 
            List<portal_honeywell_id__c> phi = [select contact__c, user_type__c from portal_honeywell_id__c where primary_honeywell_id__c= true AND contact__r.contact_status__c = 'ACTIVE' AND
                                                name =: passedValue and user_type__c != 'CSR' and contact__r.Contact_Is_Employee__c =false limit 1];
            System.debug('!!!!phi ' + phi);
            if(!phi.isEmpty())
            {
                List<contact_tool_access__c> cta =[select request_status__c  from  
                                                    contact_tool_access__c where name = 'Order Status' and 
                                                    crm_contact_id__c =: phi[0].contact__c and request_status__c = 'Approved' limit 1];

                System.debug('!!!!cta ' + cta);
                if(!cta.isEmpty())
                {
                    list<account_contact__c> acccon = [select   account_name__c from account_contact__c  
                                                            where contact__c =: phi[0].contact__c];

                    System.debug('!!!!acccon ' + acccon);
                    list<account_cross_ref__c> acr=  new list<account_cross_ref__c>([select external_account_id__c from account_cross_ref__c where 
                                                        account_name__c in (select   account_name__c from account_contact__c  
                                                        where contact__c =: phi[0].contact__c) and account_status__c =
                                                        'ACTIVE' and (not external_account_name__c like '%do not use%') and
                                                        (not external_account_name__c like '%reference account%') and
                                                        (not external_account_name__c like '%various%') and account_name__r.name 
                                                        not in ('HONEYWELL UNIDENTIFIED PORTAL USERS','Honeywell Default Account',
                                                        'NO ACCOUNT FOUND','FSR TEMPORARY OPERATOR','Portal Missing Users (Do not use)') 
                                                        and (external_account_id__c like '%-01'  or external_account_id__c like '%-02' ) 
                                                        and  XREF_Type__c = 'SAP_SOLD_TO'  ]);
                    
                    System.debug('!!!!acr ' + acr);
                    if(!acr.isempty())
                    {
                        system.debug('acrsize'+acr.size());
                        for(account_cross_ref__c a:acr)
                        {
                            system.debug('acr'+a.external_account_id__c);
                            list<string> a1 = a.external_account_id__c.split('-');
                            system.debug('a1 ' + a1);
                            system.debug('acr0'+a1[0]);
                            string a2 =OrdersListPageController.drop_leading_zeros(a1[0]);
                            if(null!= a2)
                            {
                                cn.add(a2);
                                system.debug('cnlist'+cn);
                            }
                        }
                    }
                }
            }  
        }
        
        System.debug('!!!!cn  ' + cn);
        if(!cn.isempty())
        {
            for (string s:cn)
            {
               if (return_string != null){
                  return_string += s+',';  
                }else{
                 return_string = s+',';   
                }
            }
        return_string =return_string.subString(0,return_string.length());
        }
        
        System.debug('!!!!!!!!!return_string ' + return_string);
        return return_string; //pass back a value
    }
    
    public static HttpResponse testClassCall(Boolean flag)
    {
        HttpResponse returnResponse = new HttpResponse();
        if(flag)
        {
            returnResponse.setStatusCode(200);
            returnResponse.setBody('{  "d":{  "__count":"500", "results":[  {  "__metadata":{  "id":"", "uri":"", "type":"YAFORDSTAT_SRV.OrderSearch" }, "orderNO":"9436", "orderLINEITM":"000104", "custPO":"WF_DEMO_02", "custNO":"300043", "notifNo":"", "hwPART":"", "orderTYP":"SPARES", "plant":"1057", "orderDATE":"01/31/2006", "siteID":"1009", "lastCHNGDT":"05/24/2017", "statusHDR":"ON HOLD", "dlvblkHDR":"", "dlvblkITM":"", "hldSTATUS":"", "lctnID":"", "gateSTAT":"", "custName":"SOUTHWEST AIRLINES CO", "AtlasId":"", "xChange":true, "custPART":"", "invoiceNO":"", "serialNo":"", "userTYPE":"", "deliveryNO":"", "dateTYPE":"", "startDATE":"", "endDATE":"", "creditBLOCK":true, "SAP":"Y", "estShipDATE":"", "wayBill":"" }, {  "__metadata":{  "id":"", "uri":"", "type":"YAFORDSTAT_SRV.OrderSearch" }, "orderNO":"42396", "orderLINEITM":"001010", "custPO":"TEST_EBB_1", "custNO":"300559", "notifNo":"300073377", "hwPART":"3800708-1", "orderTYP":"REPAIRS", "plant":"1014", "orderDATE":"05/23/2016", "siteID":"1014", "lastCHNGDT":"05/23/2016", "statusHDR":"SHIPPED", "dlvblkHDR":"", "dlvblkITM":"", "hldSTATUS":"MNTN", "lctnID":"1GAI0000", "gateSTAT":"GAT1", "custName":"DUNCAN AVIATION INC", "AtlasId":"", "xChange":false, "custPART":"", "invoiceNO":"", "serialNo":"", "userTYPE":"", "deliveryNO":"", "dateTYPE":"", "startDATE":"", "endDATE":"", "creditBLOCK":false, "SAP":"Y", "estShipDATE":"06/16/2016", "wayBill":"" } ] } } ');
        }
        else
        {
            returnResponse.setStatusCode(300);
        }
        return returnResponse;
    }
}