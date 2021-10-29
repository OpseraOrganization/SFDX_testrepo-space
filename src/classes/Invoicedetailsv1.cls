@RestResource(UrlMapping = '/ngbss/invoices/*')
global with sharing class Invoicedetailsv1{
    @HttpGet
    global static void getInvoice(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try{
            list<Apttus_Billing__Invoice__c> Invoicelis = new list<Apttus_Billing__Invoice__c>();
            res.addHeader('Content-Type','Application/Json');
            List<String> invoceliresult = new List<String>();
            invocedetails mainresult = new invocedetails();
            String invoceIdNo = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            if(invoceIdNo == 'invoices')
                throw new MyException('Invoice Id number is mandatory');
            system.debug('req.requestURI'+req.requestURI);
            system.debug('invoiceId'+invoceIdNo);
            
            if(invoceIdNo != null && invoceIdNo != ''){
                Invoicelis= [select id, name,Apttus_Billing__Status__c,Plant__c,SendToSAP__c,Card_Holder_Name__c,Card_Token__c,Card_Type__c,Authorization_Code__c,Authorization_Reference_Code__c,CC_Amount__c,Apttus_Billing__PONumber__c,ValidTo__c,Assignment__c,InternalsalesHdrInstrn__c,Apttus_Billing__PaymentTermId__r.APTS_External_Id__c,Apttus_Billing__SoldToAccountId__r.SAP_Sold_To__c,Apttus_Billing__BillToAccountId__r.SAP_Sold_To__c,Apttus_Billing__ShipToAccountId__r.SAP_Sold_To__c, 
                             Apttus_Billing__InvoiceDate__c,Is_License_Required__c,APTS_Integration_Status__c,Case_Number__c,SoldToXref_SAP_Number__c,ShipToXref_SAP_Number__c,BillToXref_SAP_Number__c,APTS_PO_Date__c from Apttus_Billing__Invoice__c where id=:invoceIdNo];
                //Card_Holder_Name__c,Card_Token__c ,Card_Type__c ,ValidTo__c
                system.debug('InvoiceLineItems' + Invoicelis);
                //list<Apttus_Billing__Invoice__c> Invoicelits = new list<Apttus_Billing__Invoice__c>();
                if(Invoicelis.size() > 0){
                    invocedetails getresult = new invocedetails();
                    mainresult = getresult.invoicedata(Invoicelis[0]);
                    system.debug('gwtresult'+getresult);
                    res.statusCode = 200;
                    res.responseBody = Blob.valueOf(json.serialize(mainresult));
                    //return result;
                }
                else{ 
                    
                    throw new MyException('InvoiceId number is Invalid');   
                }
            }    
        }
        catch(Exception e) 
        {
            MyExc error = new MyExc('BAD_REQUEST',e.getMessage());
            
            res.statusCode = 400;
            res.responseBody = Blob.valueOf(json.serialize(error));
            
        }                  
    }
    
    global class invocedetails{  
        public string invoiceStatus;
        public decimal plant;
        public string soldTo;
        public string shipTo;
        public string billTo;
        public string invoiceNo;
        public datetime invoiceDate;
        public string assignment;
        public string internalsalesHdrInstrn;
        public string paymentTerm;
        public boolean licenseRequired;
        public string cardType;
        public string cardToken;
        public string validTo;
        public string cardHolderName;
        Public String authorizationCode;
        Public String authorizationReferenceCode;
        Public String ccAmount;
        public string integrationStatus;
        public String caseNo; 
        public boolean sendToSAP;
        Public String poNumber;
        Public Date poDate;  
        list<items> items = new list<items>();
        
        public invocedetails invoicedata(Apttus_Billing__Invoice__c invoice){  
            //string invoceId =invoceIdNo;
            integer iteamcount=0;
            Apttus_Billing__Invoice__c inv = invoice;
            list<Apttus_Billing__InvoiceLineItem__c> invitems = new list<Apttus_Billing__InvoiceLineItem__c>();
            system.debug('invoce'+inv);
            invocedetails invoiceWrap=new invocedetails();
            invoiceWrap.invoiceStatus= inv.Apttus_Billing__Status__c;
            invoiceWrap.plant= inv.Plant__c;
            invoiceWrap.caseNo = inv.Case_Number__c;
            invoiceWrap.poNumber = inv.Apttus_Billing__PONumber__c;
            invoiceWrap.poDate = inv.APTS_PO_Date__c;
            invoiceWrap.integrationStatus =inv.APTS_Integration_Status__c;
           invoiceWrap.soldTo= inv.SoldToXref_SAP_Number__c;
            invoiceWrap.billTo= inv.BillToXref_SAP_Number__c;
            invoiceWrap.shipTo= inv.ShipToXref_SAP_Number__c;
            invoiceWrap.invoiceNo= inv.name;
            invoiceWrap.invoiceDate= inv.Apttus_Billing__InvoiceDate__c;
            invoiceWrap.paymentTerm= inv.Apttus_Billing__PaymentTermId__r.APTS_External_Id__c;
            invoiceWrap.licenseRequired = inv.Is_License_Required__c;
            invoiceWrap.assignment= inv.Assignment__c;
            invoiceWrap.internalsalesHdrInstrn= inv.InternalsalesHdrInstrn__c;
            invoiceWrap.cardType= inv.Card_Type__c;
            invoiceWrap.cardToken= inv.Card_Token__c;
            invoiceWrap.validTo= inv.ValidTo__c;
            invoiceWrap.cardHolderName= inv.Card_Holder_Name__c;
            invoiceWrap.authorizationCode  =inv.Authorization_Code__c; 
            invoiceWrap.authorizationReferenceCode =inv.Authorization_Reference_Code__c;
            invoiceWrap.ccAmount=inv.CC_Amount__c;
            invoiceWrap.sendToSAP = inv.SendToSAP__c; 
            invitems = [select id, name,Apttus_Billing__StartDate__c,Apttus_Billing__EndDate__c,Apttus_Billing__Amount__c,Apttus_Billing__Quantity__c,Send_INV_To_SAP__c,CurrencyIsoCode,Apttus_Billing__AssetLineItemId__r.Apttus_Config2__ProductId__r.ProductCode,Apttus_Billing__AssetLineItemId__r.APTS_Product_Code__c,Integration_Sequence_Line_Number__c,Apttus_Billing__Description__c,Apttus_Billing__AssetLineItemId__r.Apttus_Config2__NetUnitPrice__c from Apttus_Billing__InvoiceLineItem__c where Apttus_Billing__InvoiceId__c=:inv.id ];
            if(invitems.size()>0){
                
                
                //Adding invioce Line iteams
                for(Apttus_Billing__InvoiceLineItem__c invitem:invitems){
                    items ints = new items();
                    ints.lineItemId= invitem.Id;
                    iteamcount++;
                    ints.itemNo= String.valueOf(iteamcount);
                    //ints.materialNo= invitem.Apttus_Billing__AssetLineItemId__r.Apttus_Config2__ProductId__r.ProductCode;
                    ints.materialNo= invitem.Apttus_Billing__AssetLineItemId__r.APTS_Product_Code__c;
                    ints.quantity=  Integer.valueOf(invitem.Apttus_Billing__Quantity__c);  // invitem.Apttus_Billing__Quantity__c;(To request tax from SAP NGBSS API is using Quantity field, when multiple orders for same product is giving duplicate tax. So hard coding the quantity value to 1)
                    ints.invoiceAmount= invitem.Apttus_Billing__AssetLineItemId__r.Apttus_Config2__NetUnitPrice__c; //Apttus_Billing__Amount__c;
                    ints.integrationSequenceLineNo = invitem.Integration_Sequence_Line_Number__c;
                    ints.freightAmount= '0';
                    if(invitem.Apttus_Billing__StartDate__c == invitem.Apttus_Billing__EndDate__c){
                        ints.transactionalOrAnnual= 'T';
                    }else{
                        ints.transactionalOrAnnual= 'A';
                    }
                    //ints.transactionalOrAnnual= 'T';
                    ints.currencyKey= invitem.CurrencyIsoCode;
                    ints.materialDesc = invitem.Apttus_Billing__Description__c;
                    
                    invoiceWrap.items.add(ints);
                }
            }
            system.debug('invoiceWrap.items'+invoiceWrap.items);
            system.debug('invoiceWrap'+invoiceWrap);
            return invoiceWrap;
        }
        
    }
    global class items{
        public string lineItemId;
        public string itemNo;
        public string materialNo;
        public string transactionalOrAnnual;
        public decimal quantity;
        public decimal invoiceAmount;
        public string freightAmount;
        public string currencyKey;
        public string integrationSequenceLineNo;
        public string materialDesc;
    }
    
    global class MyException extends Exception { }
    /*
    global class Err
    {
        public string errorCode;
        public string message;
        
        Err(string errorCode, string message)
        {
            this.errorCode = errorCode;
            this.message = message;
        }
        
    }
    */
    @HttpPost
    global static void postrequest() {
        list<Apttus_Billing__Invoice__c> Invoicelis = new list<Apttus_Billing__Invoice__c>();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try{
            String JSONreq = req.requestbody.toString();   
            postdetails pd = (postdetails)(JSON.deserialize(JSONreq,postdetails.class));
            string responcerslt='Success';
            system.debug('post request='+pd);
            // Logic need to update
            String invoceIdNo = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            if(invoceIdNo == 'invoices')
                throw new MyException('Invoice Id number is mandatory');
            if(pd.integrationStatus == null || pd.integrationStatus == '')
                throw new MyException('integrationStatus is mandatory in request body');
            if(pd.integrationMethod == null || pd.integrationMethod == '')
                throw new MyException('integrationMethod is mandatory in request body');
            if(pd.integrationMethod != 'Debit Memo Request'&& pd.integrationMethod != 'Simulate Order')
                throw new MyException('Invalid integrationMethod');
                
            system.debug('req.requestURI'+req.requestURI);
            system.debug('invoiceId'+invoceIdNo);
        
            Apttus_Billing__Invoice__c billinv= new Apttus_Billing__Invoice__c();
            list<Apttus_Billing__InvoiceLineItemTaxBreakup__c> taxbreks = new list<Apttus_Billing__InvoiceLineItemTaxBreakup__c>();
            if(invoceIdNo != null && invoceIdNo != ''){
                Apttus_Billing__Invoice__c billinvcheck=[select id,Apttus_Billing__TotalInvoiceAmount__c,Apttus_Billing__TotalFeeAmount__c,Apttus_Billing__TotalTaxAmount__c,
                                                         Apttus_Billing__Status__c,APTS_SAP_Invoice_Number__c,APTS_Billing_Document_Number__c from Apttus_Billing__Invoice__c where id =: invoceIdNo limit 1];
                If(billinvcheck == null)
                    throw new MyException('Invalid Invoice Id');
                system.debug('billinvcheck'+billinvcheck);
                system.debug('billinvcheck.Apttus_Billing__Status__c'+billinvcheck.Apttus_Billing__Status__c);
                if(billinvcheck.Apttus_Billing__Status__c != 'Draft' && billinvcheck.Apttus_Billing__Status__c != 'Submitted')
                    throw new MyException('Invoice Status should not be '+ billinvcheck.Apttus_Billing__Status__c + ' to update Invoice details');
                if(billinvcheck!=null && billinvcheck.Apttus_Billing__Status__c=='Draft'){
                    billinv.id=invoceIdNo;
                    if(pd.billingDocument != null && pd.billingDocument != ''){
                        billinv.APTS_Billing_Document_Number__c =pd.billingDocument;
                        billinv.APTS_SAP_Invoice_Number__c = pd.billingDocument;
                     }
                    if(pd.dmrCMR != null && pd.dmrCMR != '')
                        billinv.APTS_DMR_Number__c =pd.dmrCMR;
                    billinv.ccauthRefNo__c =pd.ccauthRefNo;
                    billinv.ccauthorizationBlock__c =pd.ccauthorizationBlock;
                    //billinv.APTS_Integration_Status__c ='Completed';
                    billinv.APTS_Integration_Status__c =pd.integrationStatus;
                    //billinv.APTS_Integration_Method__c='Debit Memo Request';
                    billinv.APTS_Integration_Method__c =pd.integrationMethod;
                    billinv.APTS_Integration_Result__c=pd.integrationResult; 
                    billinv.Case_Number__c = pd.caseNo;

                    if(pd.invoiceStatus != null && pd.invoiceStatus != '')                   
                        billinv.Apttus_Billing__Status__c=pd.invoiceStatus;

                    if(pd.billingDocument != null && pd.billingDocument != '')
                        billinv.APTS_DMR_Status__c='Closed';
                    else 
                        billinv.APTS_DMR_Status__c='Open';
                    If(pd.tax != Null)
                    {
                    billinv.Apttus_Billing__TotalTaxAmount__c=pd.tax;
                    billinv.Apttus_Billing__TotalInvoiceAmount__c = billinvcheck.Apttus_Billing__TotalFeeAmount__c + pd.tax;
                    }
                   
                    System.debug(billinv.Apttus_Billing__TotalInvoiceAmount__c);
                    list<itemse> items = new list<itemse>();
                    if(pd.items!=null){
                            items=pd.items;
                          
                        for(itemse it:items){
                            Apttus_Billing__InvoiceLineItemTaxBreakup__c taxbrek = new Apttus_Billing__InvoiceLineItemTaxBreakup__c();
                            taxbrek.xr1__c=integer.valueof(it.xr1);
                            taxbrek.xr2__c=it.xr2;
                            taxbrek.xr3__c=it.xr3;
                            taxbrek.xr4__c=it.xr4;
                            taxbrek.xr5__c=it.xr5;
                            taxbrek.xr6__c=it.xr6;
                            taxbrek.mwst__c=it.mwst;
                            taxbrek.Apttus_Billing__TaxAmount__c=it.totalTaxAmount;
                            taxbrek.Apttus_Billing__InvoiceLineItemId__c=it.lineItemId;
                            taxbrek.Apttus_Billing__Sequence__c=1;
                            taxbreks.add(taxbrek);
                        }
                        
                    }                    
                    
                }
            }
            system.debug('billinv'+billinv);
            system.debug('taxbreks'+taxbreks);
            
            if(taxbreks!=null && taxbreks.size()>0)
                insert taxbreks;
            if(billinv.id!=null)
                update billinv;
            
            res.addHeader('Content-Type','application/json');
            res.responseBody = Blob.valueOf('{"Status":"Success"}');
            res.statusCode = 201;
            system.debug('try block '+res.statusCode +res.responseBody);
        }catch(Exception e){
            system.debug('exception e is '+e +'exception line number' +e.getLineNumber());
            MyExc error = new MyExc('BAD_REQUEST',e.getMessage());
            res.responseBody = Blob.valueOf(json.serialize(error));
            res.statusCode = 400; 
            system.debug('exception is '+res.statusCode +res.responseBody);
        } 
    }
    global class postdetails{
        string billingDocument;
        string dmrCMR;
        string ccauthRefNo;
        double tax;
        string ccauthorizationBlock;    
        string integrationMethod;
        string integrationStatus;
        string integrationResult;
        string invoiceStatus;
        public String caseNo; 
        list<itemse> items;
    }
    global class itemse{
        string lineItemId;
        double xr1;
        double xr2;
        double xr3;
        double xr4;
        double xr5;
        double xr6;
        double mwst;
        double totalTaxAmount;
        // integer grossAmount;//need to be implemented
    }
    
    
    
    global class MyExc { 
        public string errorCode;
        public string message;
        MyExc(string errorCode, string message){
            this.errorCode = errorCode;
            this.message = message;
        }
    }    
}