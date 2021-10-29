@RestResource(UrlMapping = '/ngbss/categories/products/features/*')
global with sharing class CatalogRestResourcev2{
    @HttpGet
    global static void getCatalog(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type','Application/Json');
        String soldToNo = req.params.get('soldTo');
        String productId = req.params.get('productId');
        string discount='0';
        try{
           if(productId == null)
                 throw new MyException('ProductId is Mandatory');
            List<Product2> prod1 = [select name,ProductCode,family from product2 where id =: productId];
            if(prod1.size() == 0)
              throw new MyException('ProductId is Invalid');
            String family = prod1[0].ProductCode;
            if(soldToNo != null){
                if(prod1[0].family != null && prod1[0].family.contains('Aspire'))
                {
                
                List<String> acclist = searchAccList(soldToNo);
                //To Update discount  
                List<Account> acc = [select name,Strategic_Business_Unit__c,ATR_Channel_Partner__c,
                               BGA_Account__c,D_S_Channel_Partner__c,SAP_Sold_To__c from Account where SAP_Sold_To__c IN:acclist];
                system.debug('list of accounts' + acc);
                
                if(acc.size() > 0){
                    if( (acc[0].ATR_Channel_Partner__c == true) ||
                        (acc[0].BGA_Account__c == true)         ||
                        (acc[0].D_S_Channel_Partner__c  == true)){
                        discount = Label.Aspire_DealerDiscount;
                    }
                    else if (acc[0].Strategic_Business_Unit__c == 'D&S'){
                        discount = Label.Aspire_MILGDiscount;
                    }
                    else{
                        discount = Label.Aspire_OthersDiscount;
                    }
                }
                else if(acc.size() == 0)
                {
                    List<Account_Cross_Ref__c> xref = [select id, Account_Name__r.id, External_Account_ID__c,XREF_Type__c,
                                                        Account_Name__r.ATR_Channel_Partner__c, 
                                                        Account_Name__r.BGA_Account__c,
                                                        Account_Name__r.D_S_Channel_Partner__c,  
                                                        Account_Name__r.Strategic_Business_Unit__c 
                                                        from Account_Cross_Ref__c where XREF_Type__c = 'SAP_SOLD_TO' and Account_Name__r.Customer_Status__c = 'Active' and External_Account_ID__c IN:acclist];
                    if(xref.size() > 0){
                        if( (xref[0].Account_Name__r.ATR_Channel_Partner__c == true) ||
                            (xref[0].Account_Name__r.BGA_Account__c == true)         ||
                            (xref[0].Account_Name__r.D_S_Channel_Partner__c  == true)){
                            discount = Label.Aspire_DealerDiscount;
                        }
                        else if (xref[0].Account_Name__r.Strategic_Business_Unit__c == 'D&S'){
                            discount = Label.Aspire_MILGDiscount;
                        }
                        else{
                            discount = Label.Aspire_OthersDiscount;
                        }
                   }
                   else
                     throw new MyException('SoldTo number is Invalid');  
                                                        
                }
             }
                
            }
            else{
              throw new MyException('SoldTo number is mandatory');
            }                
            Map<product2,id> PPlimap = new Map<product2,id>();
            //To get Aspire pricelist for all Aspire products
            
           /* APTS_Aspire_Order__c cso = APTS_Aspire_Order__c.getValues('Portal_To_Apttus');
            List<product2> PPli = [select name,id,Part_Number__c,Term__c,Description,Additional_Info__c,Product_Type_c__c, (select name,id,Apttus_Config2__ListPrice__c,CurrencyIsoCode from Apttus_Config2__PriceLists__r where Apttus_Config2__PriceListId__c  =: cso.Price_List_Id__c) from product2 where Family =: family order by name ASC ];
           
           */
           
           List<APTS_Aspire_Order__c> cso = APTS_Aspire_Order__c.getAll().values();
           List<String> plIds = new List<String>();
           for(APTS_Aspire_Order__c cs:cso){
               if(cs.name.contains('Portal_To_Apttus')){
                   plIds.add(cs.Price_List_Id__c);
               }
               
           
           }
            List<product2> PPli = [select name,id,Part_Number__c,Term__c,Description,Additional_Info__c,Product_Type_c__c,Comments__c, (select name,id,Apttus_Config2__ListPrice__c,CurrencyIsoCode from Apttus_Config2__PriceLists__r where Apttus_Config2__PriceListId__c  IN: plIds) from product2 where Family =: family AND IsActive = True order by Product_Number_MM__c, name ASC ];
           
            //new code
            List<FeatureInfo> featureList = new List<FeatureInfo>();
            for(product2 prod: PPli){
                FeatureInfo feature = new FeatureInfo ();
                feature.subProductName = prod.name;
                feature.partNumber = prod.Part_Number__c;
                feature.subProductDesc = prod.Description;
                feature.subProductId = prod.id;
                feature.notes = prod.Additional_Info__c;
                feature.similarProductCode = prod.Comments__c;
                feature.distributionType = prod.Product_Type_c__c;
                List<PriceInfo> priceInfoList = new List<PriceInfo>();
                //only one price list item for a product
                for(Apttus_Config2__PriceListItem__c pli : prod.Apttus_Config2__PriceLists__r){
                    system.debug('list of Apttus_Config2__PriceListItem__c==' + pli);
                    feature.price = pli.Apttus_Config2__ListPrice__c;
                    feature.term =  prod.Term__c;
                    feature.units = 'Year(s)';
                    feature.priceCurrency = pli.CurrencyIsoCode;
                    feature.discountPercentage = Integer.valueOf(discount);
                }
                //feature.price = priceInfoList;
                featureList.add(feature);
                system.debug('feature==' + feature);
            }
            //End New code
            system.debug('featurelist==' + featureList);
            Response resp = new Response();
            resp.productId = productId;
            resp.productName = prod1[0].name;
            resp.subProducts = featureList;
            res.statuscode = 200;
            res.responsebody = Blob.ValueOf(Json.serialize(resp));
        }
        catch(Exception e){
            MyExc error = new MyExc('BAD_REQUEST',e.getMessage());
            res.responseBody = Blob.valueOf(json.serialize(error));
            res.statusCode = 400; 
        }
    }
    global class PriceInfo{
        public string term;
        public string units;
        public string priceCurrency;
        public decimal price;
        public integer discountPercentage;
    }
    global class FeatureInfo{
        //Priceinfo
        public string term;
        public string units;
        public string priceCurrency;
        public decimal price;
        public integer discountPercentage;
        //feature
        public string partNumber;
        public string subProductName;
        public string subProductDesc;
        public string subProductId;
        public string distributionType;
        public string notes;
        public string similarProductCode;
        //public List<PriceInfo> price;
    }
    global class Response{
        public string productId;
        public string productName;
        public List<FeatureInfo> subProducts;
    }
     global class MyExc { 
        public string errorCode;
        public string message;
        MyExc(string errorCode, string message){
            this.errorCode = errorCode;
            this.message = message;
        }
       }
    public class MyException extends Exception { }
    
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