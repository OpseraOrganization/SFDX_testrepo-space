/*********************************************************************************************************************************************
Name            : CreateOrderRestResource class
Created BY      : Karnatakam Ganguraju
Project         : Honeywell - NGBSS
Created Date    : 2nd December 2019
Modified Date   : 21th Jan 2020
Modified By     : Karnatakam Ganguraju
Class           : CreateOrderRestResource 
Test Class      : CreateOrderRestResourceTest
Description     : CreateOrderRestResource class used for creating a Order from backend
***********************************************************************************************************************************************/

@RestResource(UrlMapping = '/ngbss/orders/*')
global with sharing class CreateOrderRestResource{
    @HttpPost
    global static void createOrderHeader(){
    
        String InvoiceStatementTemplate1;
        String InvoiceStatementTemplate2;
        String InvoiceStatementTemplate3;
        String InvoiceStatementTemplate4;
        String InvoiceStatementTemplate5;
        String InvoiceStatementTemplate6;
        String InvoiceStatementTemplate7;
        String InvoiceStatementTemplate8;
        String InvoiceStatementTemplate9;
        String InvoiceStatementTemplate10;
        String InvoiceStatementTemplate11;
        String InvoiceStatementTemplate12;
        String InvoiceStatementTemplate13;
        String InvoiceStatementTemplate14;
        String InvoiceStatementTemplate15;
        String InvoiceStatementTemplate16;
        String InvoiceStatementTemplate17;
        String InvoiceStatementTemplate18;
        String InvoiceStatementTemplate19;
        String InvoiceStatementTemplate20;
        String InvoiceStatementTemplate21;
        String InvoiceStatementTemplate22;
        String InvoiceStatementTemplate23;
        String InvoiceStatementTemplate24;
        String InvoiceStatementTemplate25;
        String InvoiceStatementTemplate26;
        String InvoiceStatementTemplate27;
        String InvoiceStatementTemplate28;
        String InvoiceStatementTemplate29;
        String InvoiceStatementTemplate30;
        String InvoiceStatementTemplate31;
        String InvoiceStatementTemplate32;
        String InvoiceStatementTemplate33;
        String InvoiceStatementTemplate34;
        String InvoiceStatementTemplate35;
        String InvoiceStatementTemplate36;
        String InvoiceStatementTemplate37;
        String InvoiceStatementTemplate38;
        String InvoiceStatementTemplate39;
        String InvoiceStatementTemplate40;
        String InvoiceStatementTemplate41;
        String InvoiceStatementTemplate42;
        String InvoiceStatementTemplate43;
        String InvoiceStatementTemplate44;
        String InvoiceStatementTemplate45;
        String InvoiceStatementTemplate46;
        String InvoiceStatementTemplate47;
        String InvoiceStatementTemplate48;
        String InvoiceStatementTemplate49;
        String InvoiceStatementTemplate50;
         String InvoiceStatementTemplate51;
        String InvoiceStatementTemplate52;
        String InvoiceStatementTemplate53;
        String InvoiceStatementTemplate54;
        String InvoiceStatementTemplate55;
        String InvoiceStatementTemplate56;
        String InvoiceStatementTemplate57;
        String InvoiceStatementTemplate58;
        String InvoiceStatementTemplate59;
        String InvoiceStatementTemplate60;
        String InvoiceStatementTemplate61;
        String InvoiceStatementTemplate62;
        String InvoiceStatementTemplate63;
        RestResponse res = RestContext.response;
        try{ 
            String orderJSON = RestContext.request.requestbody.toString(); 
            system.debug('orderJSON Body -  '+orderJSON);
            OrderDetails od = (OrderDetails)(JSON.deserialize(orderJSON,OrderDetails.class));  
            system.debug('request Body - OrderDetails '+od);
            res.addHeader('Content-Type','application/json');
            List<Account> soldto, shipto, billTo ;
            List<Account_Cross_Ref__c> soldToXref,shiptoXref, billToXref;
            
            if(od.origin == NULL)
                //throw new MyException('origin is Missing');
                od.origin = 'Portal_To_Apttus';
            
            APTS_Aspire_Order__c cso = new APTS_Aspire_Order__c();
            
            if(od.origin == 'Portal_To_Apttus'){
                //Reading the custom setting to create Order triggered from portal
                cso = APTS_Aspire_Order__c.getValues('Portal_To_Apttus');
            }
            else if (od.origin == 'SAP_To_Apttus'){
                cso = APTS_Aspire_Order__c.getValues('SAP_To_Apttus');
            }
            else{ 
                throw new MyException('origin is Invalid');
            }   
            
            //********************************
            //Basic Exception Handling start
            //********************************
            
            if(od.soldTo == NULL || od.soldTo == '')
                throw new MyException('SoldTo number is Missing');
            
            if(od.shipTo == NULL|| od.shipTo == '')
                throw new MyException('ShipTo number is Missing'); 
            
            if(od.origin == 'SAP_To_Apttus' && (od.billTo == NULL|| od.billTo == ''))
                throw new MyException('BillTo number is missing');
            
            if(od.origin == 'Portal_To_Apttus' && (od.emailIds == Null || (od.emailIds != Null && od.emailIds.size()<=0)))
                throw new MyException('CPQ emails are mandatory');
            /*if(od.creditCard == Null && od.purchaseOrder ==Null)
                throw new MyException('Credit Card or Purchase Order are Mandatory');
            if(od.creditCard != Null && od.purchaseOrder !=Null)
                throw new MyException('Either Credit Card or Purchase Order details only  ');*/
            //********************************
            //Basic Exception Handling End
            //********************************
            
            Id soldToId, billToId, shipToId, soldToXrefId, shipToXrefId, billToXrefId;
            boolean isGenericSoldTo = false;
            boolean isGenericBillTo = false;
            boolean isGenericShipTo = false;
            
            List<String> soldTos = createAccList(od.soldTo);
            system.debug('soldTos '+soldTos);
            //Identifying SoldTo Id
           /* soldto = [select name,id,SAP_Sold_To__c from Account where SAP_Sold_To__c IN:soldTos];
             system.debug('soldto'+soldto);
            if(soldto.size() > 1){
                throw new MyException('Duplicate soldTo Number at Account Level');
            }
            else if(soldto.size() == 1)
                soldToId = soldto[0].id;
            system.debug('soldto.size()'+soldto.size());
            system.debug('soldto'+soldto); */
            
            if(soldTos.size()>0){
                
                soldToXref = [select id, External_Account_Name__c, Account_Name__r.id, External_Account_ID__c,XREF_Type__c,Account_Name__c,Name,External_Address_Line_1__c,External_City_Name__c,External_Postal_Code__c,External_State_Name__c,External_Country_Name__c from Account_Cross_Ref__c where XREF_Type__c = 'SAP_SOLD_TO' and Account_Name__r.Customer_Status__c = 'Active' and External_Account_ID__c IN:soldTos]; 
                System.debug(soldToXref.Size());
                System.debug(soldToXref);
                if(soldToXref.size() > 1)
                    throw new MyException('Duplicate soldTo Number ');
                
                if(soldToXref.size() == 1){    
                    soldToId = soldToXref[0].Account_Name__r.id ; 
                    System.debug('soldToXref='+soldToXref[0].id); 
                    soldToXrefId = soldToXref[0].id;
                }
                
                if(soldToXref.size() == 0 && od.origin == 'Portal_To_Apttus')
                    throw new MyException('soldTo Number is invalid');
                
                if(soldToXref.size() == 0 && od.origin == 'SAP_To_Apttus'){
                    if(od.soldToAddr !=Null){
                        soldToId = Label.Aspire_GenericAccountId ;
                        isGenericSoldTo = true; 
                    } 
                    else
                        throw new MyException('Missing SoldTo address');
                }
            }
            //Identifying BillTo Id
          //if(od.origin == 'SAP_To_Apttus'){
            List<String> billTos = createAccList(od.billTo);
          /*  billTo = [select name,id,SAP_Sold_To__c from Account where SAP_Sold_To__c IN : billTos];
            
            if(billTo.size() > 1){
                throw new MyException('Duplicate billTo Number');
            }
            else if(billTo.size() == 1)
                billToId = billTo[0].id;
            system.debug('billTo.size()'+billTo.size());
            system.debug('billTo'+billTo); */
            
            if(billTos.size()>0){
                
                billToXref = [select id, External_Account_Name__c, Account_Name__r.id, External_Account_ID__c,XREF_Type__c,Account_Name__c,Name,External_Address_Line_1__c,External_City_Name__c,External_Postal_Code__c,External_State_Name__c,External_Country_Name__c from Account_Cross_Ref__c where XREF_Type__c = 'SAP_SOLD_TO' and Account_Name__r.Customer_Status__c = 'Active' and External_Account_ID__c IN: billTos]; 
                
                if(billToXref.size() > 1)
                    throw new MyException('Duplicate billTo Number');
                
                if(billToXref.size() == 1){    
                    billToId = billToXref[0].Account_Name__r.id ;  
                    billToXrefId = billToXref[0].id;
                }
                
                if(billToXref.size() == 0 && od.origin == 'Portal_To_Apttus')
                    throw new MyException('billTo Number is invalid');
                
                if(billToXref.size() == 0 && od.origin == 'SAP_To_Apttus'){
                    if(od.billToAddr !=Null){
                        billToId = Label.Aspire_GenericAccountId;
                        isGenericBillTo = true; 
                    } 
                    else
                        throw new MyException('Missing billTo address');
                }
            }
         //}
            
           //Identifying ShipTo Id
            List<String> shipTos = createAccList(od.shipTo);
          /* shipto = [select name,id,SAP_Sold_To__c from Account where SAP_Sold_To__c IN : shipTos];

            if(shipto.size() > 1)
               throw new MyException('Duplicate Ship To number');
            else if(shipto.size() == 1)    
                shipToId = shipto[0].id;
            
            else  */
            if(shipTos.size()> 0){               
                shiptoXref = [select id, External_Account_Name__c, Account_Name__r.id, External_Account_ID__c,XREF_Type__c,Account_Name__c,Name,External_Address_Line_1__c,External_City_Name__c,External_Postal_Code__c,External_State_Name__c,External_Country_Name__c from Account_Cross_Ref__c where XREF_Type__c = 'SAP_SOLD_TO' and Account_Name__r.Customer_Status__c = 'Active' and External_Account_ID__c IN : shipTos ]; 
                
                if(shiptoXref.size() > 1)
                    throw new MyException('Duplicate ShipTo Number');
                 System.debug('shiptoXref'+shiptoXref.Size());
                if(shiptoXref.size() == 1){    
                    shipToId = shiptoXref[0].Account_Name__r.id ;  
                    shipToXrefId = shipToXref[0].id;
                }
                
                if(shiptoXref.size() == 0 && od.origin == 'Portal_To_Apttus')
                    throw new MyException('shipTo Number is invalid');
                
                if(shiptoXref.size() == 0 && od.origin == 'SAP_To_Apttus'){
                    if(od.shipToAddr !=Null){
                        shipToId = Label.Aspire_GenericAccountId;
                        isGenericShipTo = true; 
                    } 
                    else
                        throw new MyException('Missing ShipTo address');
                }
                
            }

            system.debug('shipToId'+shipToId);
 
            system.debug('soldToId--'+soldToId);
            system.debug('cso.Price_List_Id__c--'+cso.Price_List_Id__c);
            system.debug('billToId--'+billToId);
            Apttus_Config2.CPQStruct.CreateOrderRequestDO oreq = new Apttus_Config2.CPQStruct.CreateOrderRequestDO();
            oreq.AccountId = soldToId ;
            oreq.PriceListId = cso.Price_List_Id__c;
            oreq.PricingDate = Datetime.now();
            system.debug('oreq--'+oreq);
            // Create a new order
            Apttus_Config2.CPQStruct.CreateOrderResponseDO ores = Apttus_Config2.OrderWebService.createOrder(oreq);
            // Assign orderId to local variable
            Id orderId = ores.OrderSO.Id;
            Apttus_Config2__Order__c ord = [select id,Name from Apttus_Config2__Order__c where id = : orderId];
            String orderNumber = ord.Name;
            ord.Apttus_Config2__BillingPreferenceId__c = cso.Billing_Preference_Id__c;
            //ord.Apttus_Config2__PaymentTermId__c = cso.Payment_Terms_Id__c;
            if(od.paymentTerm == null || od.paymentTerm == ''){
                ord.Apttus_Config2__PaymentTermId__c = cso.Payment_Terms_Id__c;
            }
            else{
                List<Apttus_Config2__PaymentTerm__c> pt = [select id from Apttus_Config2__PaymentTerm__c where APTS_External_Id__c =: od.paymentTerm];
                if(pt.size() == 1)
                    ord.Apttus_Config2__PaymentTermId__c = pt[0].id;                   
                else
                   throw new MyException('Invalid Payment Terms'); 
            }
            ord.Apttus_Config2__ShipToAccountId__c = shipToId ;
            ord.Apttus_Config2__OrderStartDate__c =  Date.Today();
            ord.Apttus_Config2__OrderEndDate__c = Date.Today();
            ord.Apttus_Config2__AutoActivateOrder__c = true;
            ord.Apttus_Config2__ActivatedDate__c = DateTime.now();
            ord.Apttus_Config2__ReadyForBillingDate__c = DateTime.now();
            ord.Honeywell_ID__c = od.UserId;
            ord.DeliveryNumber__c = od.deliveryNo;
            if( od.origin == 'SAP_To_Apttus'){
                ord.Send_INV_To_SAP__c = false;
                ord.Apttus_Config2__BillToAccountId__c = billToId;
            }
            if(isGenericSoldTo){
                system.debug('od.soldToAddr.Name'+od.soldToAddr.Name);
                ord.SoldTo_Number__c  = od.soldTo;
                ord.SoldTo_SAP_Account_Name__c = od.soldToAddr.Name;
                
                ord.Sold_To_Street__c = od.soldToAddr.street;
                ord.Sold_To_City__c = od.soldToAddr.city;
                ord.Sold_To_State__c = od.soldToAddr.region;
                ord.Sold_To_Country__c = od.soldToAddr.country;
                ord.Sold_To_Postal_Code__c = od.soldToAddr.zip;
                ord.Generic_xref_SoldTo__c = true;
            }
            else if(soldToXrefId !=Null){    
                ord.SoldTo_Number__c  = od.soldTo;
                ord.SoldToXref__c  = soldToXrefId;
                ord.SoldTo_SAP_Account_Name__c = soldToXref[0].External_Account_Name__c;
                ord.Sold_To_Street__c = soldToXref[0].External_Address_Line_1__c;
                ord.Sold_To_City__c = soldToXref[0].External_City_Name__c;
                ord.Sold_To_Postal_Code__c = soldToXref[0].External_Postal_Code__c;
                ord.Sold_To_State__c = soldToXref[0].External_State_Name__c;
                ord.Sold_To_Country__c = soldToXref[0].External_Country_Name__c ;
                ord.Generic_xref_SoldTo__c = true;      
            }
            
            if(isGenericBillTo){
                system.debug('od.BillToAddr.Name'+od.BillToAddr.Name);
                ord.BillTo_Number__c  = od.BillTo;
                ord.BillTo_SAP_Account_Name__c = od.BillToAddr.Name;
                
                ord.Billing_Street__c = od.BillToAddr.street;
                ord.Billing_City__c = od.BillToAddr.city;
                ord.Billing_State__c = od.BillToAddr.region;
                ord.Billing_Country__c = od.BillToAddr.country;
                ord.Billing_Postal_Code__c = od.BillToAddr.zip;
                
                ord.Generic_xref_BillTo__c = true;
            }
            else if(BillToXrefId !=Null){    
                ord.BillToXref__c  = BillToXrefId;
                ord.BillTo_SAP_Account_Name__c = BillToXref[0].External_Account_Name__c;
                ord.BillTo_Number__c  = od.BillTo;
                ord.Billing_Street__c = BillToXref[0].External_Address_Line_1__c;
                ord.Billing_City__c = BillToXref[0].External_City_Name__c;
                ord.Billing_Postal_Code__c = BillToXref[0].External_Postal_Code__c;
                ord.Billing_State__c = BillToXref[0].External_State_Name__c;
                ord.Billing_Country__c = BillToXref[0].External_Country_Name__c ;  
                
                ord.Generic_xref_BillTo__c = true;    
            }
            
            if(isGenericShipTo){
                system.debug('od.ShipToAddr.Name'+od.ShipToAddr.Name);
                ord.ShipTo_Number__c  = od.shipTo;
                ord.ShipTo_SAP_Account_Name__c = od.ShipToAddr.Name;
                ord.Ship_To_Street__c = od.ShipToAddr.street;
                ord.Ship_To_City__c = od.ShipToAddr.city;
                ord.Ship_To_State__c = od.ShipToAddr.region;
                ord.Ship_To_Country__c = od.ShipToAddr.country;
                ord.Ship_To_Postal_Code__c = od.ShipToAddr.zip;
                
                ord.Generic_xref_ShipTo__c = true;
            }
            else if(ShipToXrefId !=Null){    
                ord.ShipToXref__c  = ShipToXrefId;
                ord.ShipTo_SAP_Account_Name__c = ShipToXref[0].External_Account_Name__c;
                ord.ShipTo_Number__c  = od.shipTo;
                ord.Ship_To_Street__c = ShipToXref[0].External_Address_Line_1__c;
                ord.Ship_To_City__c = ShipToXref[0].External_City_Name__c;
                ord.Ship_To_Postal_Code__c = ShipToXref[0].External_Postal_Code__c;
                ord.Ship_To_State__c = ShipToXref[0].External_State_Name__c;
                ord.Ship_To_Country__c = ShipToXref[0].External_Country_Name__c ; 
                
                 ord.Generic_xref_ShipTo__c = true;     
            }
           
            
            //creditCard / creditCards
            if(od.creditCard != Null){
                ord.cardType__c = od.creditCard.cardType;
                ord.Card_Token__c = od.creditCard.cardToken;
                ord.ValidTo__c = od.creditCard.validTo;
                ord.Card_Holder_Name__c = od.creditCard.cardHolderName;
                ord.Authorization_Code__c = od.creditCard.authorizationCode;
                ord.Authorization_Reference_Code__c = od.creditCard.authorizationReferenceCode;
                ord.CC_Amount__c = od.creditCard.ccAmount;
            }
            //purchaseOrders/purchaseOrder
            if(od.purchaseOrder != Null){
                if(od.purchaseOrder.poNumber ==null || od.purchaseOrder.poNumber==''){
                    throw new MyException('Purchase Order PONumber is mandatory');
                }else{
                    ord.Apttus_Config2__PONumber__c = od.purchaseOrder.poNumber;
                    ord.Apttus_Config2__PODate__c = od.purchaseOrder.poDate;
                }
                //if(validContacts>0)
                
            }
            update ord;
            system.debug('od.purchaseOrder'+od.purchaseOrder);
            if(od.purchaseOrder != Null && od.purchaseOrder.poDocument != Null){
                //save a file in Notes and Attachments based purchaseOrder content
                string document = od.purchaseOrder.poDocument;
                string filename = od.purchaseOrder.poFileName;
                string ContentType = od.purchaseOrder.poContentType;
                system.debug('od.purchaseOrder.poDocument'+od.purchaseOrder.poDocument);
                attachment att=new attachment();
                att.parentId = ord.Id;
                system.debug('ContentType'+ContentType);
                if(ContentType.containsIgnoreCase('pdf')){
                    system.debug('ContentType'+ContentType);
                    att.name = filename+'.pdf';
                    att.Body = EncodingUtil.base64Decode(document);//PDF base 64 data to blog
                    //att.Body = Blob.toPDF(document);//String to PDF
                }else if(ContentType.containsIgnoreCase('text')){
                    system.debug('ContentType'+ContentType);
                    att.Body = Blob.valueof(document);// String to a Blob
                    att.name = filename+'.text';
                }
                
                else if(ContentType.containsIgnoreCase('doc') || ContentType.containsIgnoreCase('msword')){
                    att.name = filename+'.doc'; 
                    system.debug('ContentType'+ContentType);
                    if(document.endsWith('=')){
                        att.Body = EncodingUtil.base64Decode(document+'');//binary content decode 
                    }else {
                        att.Body = EncodingUtil.base64Decode(document);//binary content decode 
                    }
                    
                }
                else
                    throw new MyException('Invalid PurchaseOrder contentType');
                
                att.ContentType = ContentType; 
                //att.Body.size();
                //att.Body..toString(); Blob to string
                //Blob c=EncodingUtil.base64Decode(document);
                //att.Body = EncodingUtil.base64Decode(document);
                insert att;
            }
            
            //list<content> conts= new list<content>();
            //Email ids 
            if(od.emailIds != Null){
                if(od.emailIds.size()>0){
                    list<CPQ_Email__c> ces= new list<CPQ_Email__c>();
                    set<string> emails = new set<string>();
                    emails.addAll(od.emailIds);
                    system.debug('emailIds' +od.emailIds);
                    system.debug('emails' +emails);
                    for(string email:emails){
                        //content contnt=new content();
                        if(checkValidEmail(email)){
                            CPQ_Email__c ce= new CPQ_Email__c();
                            //need to validate the emials and duplicates
                            ce.name= email;
                            ce.Order__c=orderId;
                            ces.add(ce);
                        }else{
                            throw new MyException('Invalid CPQ email -'+Email);
                            //contnt.issuecontent=email;
                            //conts.add(contnt);
                        }
                    }
                    if(ces.size()>0) insert ces;
                }
            }
            /*
            if(conts.size()>0){
                Partialsuccess ps= new Partialsuccess();
                ps.Status='Partial success';
                ps.message='Invalid CPQ emails';
                ps.contents=conts;
                res.responseBody = Blob.valueOf(json.serialize(ps));
                res.statusCode = 200;
            }else{
            */
                orderData odd = new orderData();
                odd.orderId = orderId ;
                odd.orderNo = orderNumber;
                res.responseBody = Blob.valueOf(JSON.serialize(odd));
                res.statusCode = 200;
            //}
        }
        catch(Exception e){
            system.debug('exception msg'+e.getMessage());
            system.debug('exception line'+e.getLineNumber());
            MyExc error = new MyExc('BAD_REQUEST',e.getMessage());
            res.responseBody = Blob.valueOf(json.serialize(error));
            res.statusCode = 400; 
        }
    }
    global class OrderDetails{
        public String soldTo;
        public String shipTo;
        public string userId;
        public String billTo;
        public String origin;
        public String deliveryNo;
        public String paymentTerm;
        public Address soldToAddr;
        public Address shipToAddr;
        public Address billToAddr;
        public creditCards creditCard;
        public purchaseOrders purchaseOrder;
        public list<String> emailIds;
        //public string systemname;
    }
    global class Address{
        public String name;
        public String street;
        public String city;
        public String region;
        public String country;
        public String zip;
    }
    global class creditCards{
        public String cardType;
        public String cardToken;
        public String validTo;
        public String cardHolderName; 
        Public String authorizationCode;
        Public String authorizationReferenceCode;
        Public String ccAmount;
    }
    global class purchaseOrders{
        public String poNumber; //Apttus_Config2__PONumber__c
        public date poDate; // Apttus_Config2__PODate__c
        public String poDocument;
        public String poFileName;
        public String poContentType;
    }
    global class MyExc { 
        public string errorCode;
        public string message;
        MyExc(string errorCode, string message){
            this.errorCode = errorCode;
            this.message = message;
        }
    }
    global class Partialsuccess{
        public string Status;
        public string message;
        public list<content> contents;
    }
    global class content{
        public String issuecontent;
    }
    public class orderData{
        public string orderId;
        public string orderNo;
    }
    public class MyException extends Exception {}
    
    public static Boolean checkValidEmail(String emailAddress){
        String emailRegex = '(?:[a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])';
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(emailAddress.toLowercase());
        if(MyMatcher.matches()){
            return true;
        }else{
            return false;
        }
    } 
    public static List<String> createAccList(String Accnt){
        
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
                // accntList.add(newaccnt+'-02');
            }
            
            accntList.add(accnt);
            accntList.add(accnt+'-01');
            // accntList.add(accnt+'-02');
            //To identify shipTo which is truncated
            String accntT = accnt.replaceFirst('^0+', '');
            accntList.add(accntT);
            accntList.add(accntT+'-01');
            // accntList.add(accntT+'-02');
            return accntList;
    }
}