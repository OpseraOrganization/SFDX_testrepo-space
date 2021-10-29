/*********************************************************************************************************************************************
Name            : OrderHistory class
Created BY      : Karnatakam Ganguraju
Project         : Honeywell - NGBSS
Created Date    : 2nd December 2019
Modified Date   : 21th Jan 2020
Modified By     : Karnatakam Ganguraju
Class           : OrderHistory 
Test Class      : OrderHistoryTest
Description     : OrderHistory class used for getting order details from backend
***********************************************************************************************************************************************/
@RestResource(UrlMapping = '/ngbss/orderhistory/*')
global with sharing class OrderHistory{
    @HttpGet
    global static void doGetOrderHistory(){
    
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try{
            res.addHeader('Content-Type','Application/Json');
            String OrderId = req.params.get('orderId');
            String soldTos = req.params.get('soldTos');
            string category = req.params.get('categoryName');
            String orderStatus = req.params.get('orderStatus');
            String query='';
            String fields = req.params.get('fields');
            
            list<Apttus_Config2__OrderLineItem__c> olis= new list<Apttus_Config2__OrderLineItem__c>();
            Map<Id,Apttus_Config2__Order__c> ordMap;
            
            if(OrderId != Null && OrderId != ''){
            
                
                ordMap = new Map<Id,Apttus_Config2__Order__c>([select id,Name,Apttus_Config2__Status__c,Case_Number__c,NGBSS_Processing_Status__c,
                                                                Apttus_Config2__SoldToAccountId__r.Name,soldToNumber__c,Aspire_InvoiceId__c,
                                                                Apttus_Config2__PONumber__c,Apttus_Config2__PODate__c,Card_Token__c,
                                                                CreatedDate,Apttus_Config2__PaymentTermId__r.name from Apttus_Config2__Order__c where id =:orderId]);
                
                if(ordMap.keySet().size() == 0 || ordMap.keySet().size() > 1)
                   throw new MyException('OrderId is Invalid');
                   
                else if(ordMap.keySet().size() == 1){ 
                
                    olis = [select id,name,License_Expiry_Date__c,Activation_Key__c,
                                Apttus_Config2__OptionId__r.Part_Number__c,Apttus_Config2__OptionId__r.Product_Type_c__c,Apttus_Config2__OptionId__r.Description,Apttus_Config2__OptionId__r.name,
                                Apttus_Config2__ProductId__r.name,Apttus_Config2__ProductId__r.Family,Apttus_Config2__ProductId__r.License_Type__c,Apttus_Config2__OptionId__r.License_Type__c,
                                Apttus_Config2__ProductId__c,Apttus_Config2__OptionId__c,
                                Apttus_Config2__OrderId__c, Apttus_Config2__OrderId__r.createddate,Apttus_Config2__OrderId__r.soldToNumber__c,Apttus_Config2__OrderId__r.Apttus_Config2__SoldToAccountId__r.Name, 
                                (select id,Name,Activation_Key__c,License_Status__c,Distribution_Number__c,License_Expiry_Date__c from CPQ_Platforms__r) 
                                from Apttus_Config2__OrderLineItem__c 
                                where Apttus_Config2__OrderId__c =:ordMap.keySet().iterator().next()];
                        
                        system.debug('olis'+olis);  
                }
            
            }
            else if(soldTos != null && soldTos != ''){
                List<String> soldToList = soldTos.split(',');
                List<String> soldToListTemp = new List<String>();
                for(String acc:soldToList){
                   soldToListTemp.addAll(searchAccList(acc)); 
                }
                soldToList.addAll(soldToListTemp);
                String pricelists = label.AspirePriceList;
                List<String> pricelilist = pricelists.split(';');
                if(orderStatus != null && orderStatus != ''){
                                
                    ordMap = new Map<Id,Apttus_Config2__Order__c>([select id,Name,Apttus_Config2__SoldToAccountId__r.Name,soldToNumber__c,Aspire_InvoiceId__c,
                                                                    CreatedDate,Apttus_Config2__Status__c,Case_Number__c,NGBSS_Processing_Status__c,
                                                                    Apttus_Config2__PaymentTermId__r.name,Apttus_Config2__PONumber__c,Apttus_Config2__PODate__c,Card_Token__c 
                                                                    from Apttus_Config2__Order__c where soldToNumber__c IN:soldToList and Apttus_Config2__Status__c  =: orderStatus and Apttus_Config2__PriceListId__c IN: pricelilist]);
                }
                else{
                    ordMap = new Map<Id,Apttus_Config2__Order__c>([select id,Name,Apttus_Config2__SoldToAccountId__r.Name,soldToNumber__c,Aspire_InvoiceId__c,
                                                                    CreatedDate,Apttus_Config2__Status__c,Case_Number__c,NGBSS_Processing_Status__c,
                                                                    Apttus_Config2__PaymentTermId__r.name,Apttus_Config2__PONumber__c,Apttus_Config2__PODate__c,Card_Token__c 
                                                                    from Apttus_Config2__Order__c where soldToNumber__c IN:soldToList and Apttus_Config2__PriceListId__c IN: pricelilist]);
                
                }
                
                if(ordMap.keySet().size() > 0){
                  
                   SET<ID> keys = ordMap.keyset();
                
                    /*query = 'select id,name,License_Expiry_Date__c,Activation_Key__c,'
                               +'Apttus_Config2__OptionId__r.Part_Number__c,Apttus_Config2__OptionId__r.Product_Type_c__c,Apttus_Config2__OptionId__r.Description,Apttus_Config2__OptionId__r.name,'
                                +'Apttus_Config2__ProductId__r.name,Apttus_Config2__ProductId__r.Family,Apttus_Config2__ProductId__r.License_Type__c,Apttus_Config2__OptionId__r.License_Type__c,'
                                +'Apttus_Config2__OrderId__c, Apttus_Config2__OrderId__r.createddate,Apttus_Config2__OrderId__r.soldToNumber__c,Apttus_Config2__OrderId__r.Apttus_Config2__SoldToAccountId__r.Name,'
                                +'Apttus_Config2__ProductId__c,Apttus_Config2__OptionId__c,' 
                                +'(select id,Name,Activation_Key__c,Distribution_Number__c,License_Status__c,License_Expiry_Date__c from CPQ_Platforms__r)' 
                                +' from Apttus_Config2__OrderLineItem__c' 
                                +' where Apttus_Config2__OrderId__c IN: keys';
                                
                                        
                    if(category != null && category != '')                   
                         query = query + ' and Apttus_Config2__ProductId__r.Family =' + '\'' + category + '\'';
                                                        
                    system.debug('query is '+query);
                    olis = database.query(query);*/
                    
                    if(category != null && category != '') {
                        olis = [select id,name,License_Expiry_Date__c,Activation_Key__c,
                                Apttus_Config2__OptionId__r.Part_Number__c,Apttus_Config2__OptionId__r.Product_Type_c__c,Apttus_Config2__OptionId__r.Description,Apttus_Config2__OptionId__r.name,
                                Apttus_Config2__ProductId__r.name,Apttus_Config2__ProductId__r.Family,Apttus_Config2__ProductId__r.License_Type__c,Apttus_Config2__OptionId__r.License_Type__c,
                                Apttus_Config2__OrderId__c, Apttus_Config2__OrderId__r.createddate,Apttus_Config2__OrderId__r.soldToNumber__c,Apttus_Config2__OrderId__r.Apttus_Config2__SoldToAccountId__r.Name,
                                Apttus_Config2__ProductId__c,Apttus_Config2__OptionId__c, 
                                (select id,Name,Activation_Key__c,Distribution_Number__c,License_Status__c,License_Expiry_Date__c from CPQ_Platforms__r) 
                                from Apttus_Config2__OrderLineItem__c 
                                where Apttus_Config2__OrderId__c IN: keys and Apttus_Config2__ProductId__r.Family =: category];
                    
                    }
                    else{
                        olis = [select id,name,License_Expiry_Date__c,Activation_Key__c,
                                Apttus_Config2__OptionId__r.Part_Number__c,Apttus_Config2__OptionId__r.Product_Type_c__c,Apttus_Config2__OptionId__r.Description,Apttus_Config2__OptionId__r.name,
                                Apttus_Config2__ProductId__r.name,Apttus_Config2__ProductId__r.Family,Apttus_Config2__ProductId__r.License_Type__c,Apttus_Config2__OptionId__r.License_Type__c,
                                Apttus_Config2__OrderId__c, Apttus_Config2__OrderId__r.createddate,Apttus_Config2__OrderId__r.soldToNumber__c,Apttus_Config2__OrderId__r.Apttus_Config2__SoldToAccountId__r.Name,
                                Apttus_Config2__ProductId__c,Apttus_Config2__OptionId__c, 
                                (select id,Name,Activation_Key__c,Distribution_Number__c,License_Status__c,License_Expiry_Date__c from CPQ_Platforms__r) 
                                from Apttus_Config2__OrderLineItem__c 
                                where Apttus_Config2__OrderId__c IN: keys];
                    
                    }
                    
                    system.debug('oli is '+olis);    
                }
            }
            
            else{
               throw new MyException('Please provide either OrderId or soldTos'); 
            }
            
            map<id,list<Apttus_Config2__OrderLineItem__c>> maporditems= new map<id,list<Apttus_Config2__OrderLineItem__c>>();
            
            for(Apttus_Config2__OrderLineItem__c oli:olis){
                    
                if(!maporditems.containsKey(oli.Apttus_Config2__OrderId__c)) {
                        maporditems.put(oli.Apttus_Config2__OrderId__c, new List<Apttus_Config2__OrderLineItem__c>()); 
                }
                maporditems.get(oli.Apttus_Config2__OrderId__c).add(oli);
                
            }
            system.debug('maporditems'+maporditems);
            Set<Id> finalordset = new Set<Id>();
            Set<Id> invoiceIdset = new Set<Id>();
            List<Apttus_Billing__Invoice__c> invoicelist = New List<Apttus_Billing__Invoice__c>();
            for(Apttus_Config2__Order__c ordin : ordMap.values())
            {
               invoiceIdset.Add(ordin.Aspire_InvoiceId__c);
            }
            
            If(invoiceIdset.Size()>0)
            {
              invoicelist = [Select id,APTS_DMR_Number__c from Apttus_Billing__Invoice__c Where ID In:invoiceIdset];
            }
            
            if(OrderId != Null && OrderId != ''){
                finalordset = ordMap.keySet();
            }
            else if(soldTos != null && soldTos != ''){
                finalordset = maporditems.keySet();
            }
            list<OrderResp> ordresplist= new list<OrderResp>();
                for(id ordid: finalordset){
                    list<OrderResp_LineItems> OrderRespLiList = new list<OrderResp_LineItems>();
                    if(olis.size() > 0 && maporditems.get(ordid) != null){
                        for(Apttus_Config2__OrderLineItem__c aoli:maporditems.get(ordid)){
                            System.debug('aoli ='+ aoli);

                            OrderResp_LineItems orli= new OrderResp_LineItems();
                            orli.productName=aoli.Apttus_Config2__ProductId__r.name; 
                            orli.productId = aoli.Apttus_Config2__ProductId__c;
                            orli.subProductId = aoli.Apttus_Config2__OptionId__c;
                            orli.partNumber=aoli.Apttus_Config2__OptionId__r.Part_Number__c;
                            orli.distributionType=aoli.Apttus_Config2__OptionId__r.Product_Type_c__c;
                            orli.licenseType=aoli.Apttus_Config2__ProductId__r.License_Type__c;
                            orli.expiryDate=aoli.License_Expiry_Date__c;
                            orli.subProductName=aoli.Apttus_Config2__OptionId__r.name;   
                            orli.subProductDesc=aoli.Apttus_Config2__OptionId__r.Description;
                            orli.categoryName=aoli.Apttus_Config2__ProductId__r.Family;
                            orli.LineItemId=aoli.id;
                            orli.activationKey=aoli.Activation_Key__c;
                                         
                            list<OrderResp_Platforms> cpfs= new list<OrderResp_Platforms>();
                            list<CPQ_Platform__c> Platforms=new list<CPQ_Platform__c>();
                            Platforms = aoli.CPQ_Platforms__r;
                            system.debug('Platforms'+Platforms);
                            for(CPQ_Platform__c Pf: Platforms){
                                OrderResp_Platforms cpf= new OrderResp_Platforms();
                                cpf.serialNumber=pf.Name;
                                cpf.platformId=Pf.id;
                                cpf.distributionNo=pf.Distribution_Number__c;
                                cpf.activationKey=pf.Activation_Key__c;
                                cpf.expiryDate=pf.License_Expiry_Date__c;
                                cpf.licenseStatus=pf.License_Status__c;
                                cpfs.add(cpf);
                            }
                            if(fields == 'platforms'){
                                orli.platforms=cpfs;
                            }
                            if(fields == 'platforms' || fields == 'lineItems')
                                OrderRespLiList.add(orli);
                           
                    }
                 }
                 OrderResp ordResponse =new OrderResp();
                    
                 ordResponse.orderId=ordid;
                 ordResponse.customerName = ordMap.get(ordid).Apttus_Config2__SoldToAccountId__r.Name;
                 ordResponse.orderDate = ordMap.get(ordid).CreatedDate.formatGMT('MM-dd-yyyy\' \'HH:mm');
                 ordResponse.soldTo = ordMap.get(ordid).soldToNumber__c;
                 ordResponse.caseNo = ordMap.get(ordid).Case_Number__c;
                 ordResponse.orderStatus = ordMap.get(ordid).Apttus_Config2__Status__c;
                 ordResponse.ngbssProcessingStatus = ordMap.get(ordid).NGBSS_Processing_Status__c;
                 ordResponse.orderNo = ordMap.get(ordid).Name;
                 ordResponse.paymentTerm = ordMap.get(ordid).Apttus_Config2__PaymentTermId__r.name;
                 System.debug(invoicelist);
                 For(Apttus_Billing__Invoice__c Abinv : invoicelist)
                 {
                    System.debug('invoicelist invoice'+abinv.id); 
                    System.debug('invoicelist order'+ordMap.get(ordid).Aspire_InvoiceId__c); 
                    IF(abinv.id == ordMap.get(ordid).Aspire_InvoiceId__c)
                    {
                      System.debug(abinv.APTS_DMR_Number__c); 
                      ordResponse.salesOrderNumber = abinv.APTS_DMR_Number__c;
                    }
                 }
                 
                 if(ordMap.get(ordid).Card_Token__c != null && ordMap.get(ordid).Card_Token__c != '')
                     ordResponse.creditCard = 'Y';
                 
                 OrderResp_PurchaseOrder po= new OrderResp_PurchaseOrder();
                 po.poNumber = ordMap.get(ordid).Apttus_Config2__PONumber__c;
                 po.poDate = String.valueOf(ordMap.get(ordid).Apttus_Config2__PODate__c);
                 
                 ordResponse.purchaseOrder = po;
                   
                 ordResponse.lineItems = OrderRespLiList;
                 ordresplist.add(ordResponse);
                 system.debug('OrderRespLiList '+OrderRespLiList);
               }
                
             system.debug('ordresplist'+ordresplist);
             GetResponse resp = new GetResponse();
             resp.orders = ordresplist;
             res.statuscode = 200;
             res.responsebody = Blob.ValueOf(Json.serialize(resp));
               
        }
        catch(Exception e){
            system.debug('error is at '+e.getLineNumber()+e.getMessage());
            MyExc error = new MyExc('BAD_REQUEST',e.getMessage());
            res.responseBody = Blob.valueOf(json.serialize(error));
            res.statusCode = 400;   
        }
    
    }
    
    
    
    @HttpPost
    global static void doPostOrderHistory(){
    
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
    
        try{
        
            res.addHeader('Content-Type','Application/Json');
        
            String orderId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            String ReqJSON = req.requestBody.toString();
            PostRequest pr = (PostRequest)(JSON.deserialize(ReqJSON,PostRequest.class)); 
            
            if(orderId == 'order_history'){
                throw new MyException('OrderId is mandatory');
            }
            
            List<Apttus_Config2__Order__c> ord = [select Apttus_Config2__Status__c,Case_Number__c,NGBSS_Processing_Status__c from Apttus_Config2__Order__c where id =:orderId];
            if(ord.size() == 0 || ord.size() > 1)
               throw new MyException('OrderId is Invalid');
            else if(ord.size() == 1){
                if(pr.caseNo != Null && pr.caseNo != '')
                    ord[0].Case_Number__c = pr.caseNo;
                ord[0].NGBSS_Processing_Status__c = pr.ngbssProcessingStatus;
                update ord[0];
                res.statusCode = 200;  
            }
             
        }
        catch(Exception e){
            system.debug('error is at '+e.getLineNumber()+e.getMessage());
            MyExc error = new MyExc('BAD_REQUEST',e.getMessage());
            res.responseBody = Blob.valueOf(json.serialize(error));
            res.statusCode = 400;   
        }
    
    }
    
    global class PostRequest{
        public String caseNo;  
        public String ngbssProcessingStatus;
    }
    
    global class GetResponse{
        public List<OrderResp> orders;
    }
    global class OrderResp{
        public String caseNo;
        public String orderStatus; 
        public String orderId;
        public String orderNo;
        public String ngbssProcessingStatus;
        public String customerName;
        public String orderDate;
        public String soldTo;
        public String paymentTerm;
        public String creditCard;
        Public String salesOrderNumber;
        public OrderResp_PurchaseOrder purchaseOrder;
        public OrderResp_LineItems[] lineItems;
        //public OrderResp_Invoices[] invoices;
    }
    
    global class OrderResp_PurchaseOrder{
        public String poNumber;
        public String poDate;
    }
    
    global class OrderResp_LineItems {
        public String productName;  //Aspire 400License/Activation Keys
        public String partNumber;   //90408779-1Y
        public String subProductName;   //Cabin SIP PBX capability License Key
        public String subProductDesc;   //Aspire Part Number: 90408779
        public String categoryName; //Aspire
        public String lineItemId;   
        public String activationKey;    //licenseType
        public String expiryDate;
        public String distributionType;
        public String licenseType;   
        public String productId;
        public String subProductId;
        public OrderResp_Platforms[] platforms;
    }
    global class OrderResp_Invoices{
        public String invoiceDate;
        public String invoiceStatus;
        public String invoiceId;
        public String invoiceNo;
    
    }
    global class OrderResp_Platforms {
        public String serialNumber; //12345
        public String distributionNo;
        public String platformId;   //status
        public String activationKey;    
        public String expiryDate;
        public String licenseStatus;
    }
    
    global class MyExc { 
        public string errorCode;
        public string message;
        MyExc(string errorCode, string message){
            this.errorCode = errorCode;
            this.message = message;
        }
    }
    
    public class MyException extends Exception {}
    
     public static List<String> searchAccList(String Accnt){
        
        List<String> accntList = new List<String>();
            String newaccnt;
            Integer size = accnt.length();
            if(size < 10){
                Integer sizetoadd = 10 - size;
                String append = '0';
                for(integer i=1;i<sizetoadd;i++){
                    append = append+'0';
                }           
                newaccnt = append + accnt;
                system.debug('newaccnt' +newaccnt);
                accntList.add(newaccnt);
                accntList.add(newaccnt+'-01');
                accntList.add(newaccnt+'-02');
            }
            
            accntList.add(accnt);
            accntList.add(accnt+'-01');
            accntList.add(accnt+'-02');
            //To identify shipTo which is truncated
            String accntT = accnt.replaceFirst('^0+', '');
            accntList.add(accntT);
            accntList.add(accntT+'-01');
            accntList.add(accntT+'-02');
            return accntList;
    }
 }