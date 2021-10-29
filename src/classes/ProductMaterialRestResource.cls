@RestResource(urlMapping = '/ngbss/api/v1/products/materials')
global with sharing class ProductMaterialRestResource{
    @Httpget
    //global static Map<String,List<productattr>> getmaterial() { 
    global static void getmaterial() { 
        Map<String,List<productattr>> response = new Map<String,List<productattr>>();      
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type','application/json');
        try{
            List<productattr> Prodcuidlst = New List<productattr>();
            List<String> ProdId = New List<String>();
            List<String> ProdpId = New List<String>();
            Set<id> ProdbId = New Set<id>();
            RestRequest req = RestContext.request;
            
            //To Update discount
            //******************************
            string discount='0';
            String soldToNo = req.params.get('soldTo');
            
             if(soldToNo != null){                              
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
                       
            //******************************
             
            String BId= req.params.get('bId');
            String PId= req.params.get('pId');
            System.debug (PId);
            
            List<APTS_Aspire_Order__c> cso = APTS_Aspire_Order__c.getAll().values();
            List<String> plIds = new List<String>();
            for(APTS_Aspire_Order__c cs:cso){
               if(cs.name.contains('Portal_To_Apttus')){
                  plIds.add(cs.Price_List_Id__c);
               }
            }
                 
            IF(BId != Null){
                String[] queryParams = BId.split(',');
                System.debug(queryParams );
                for(String queryParam: queryParams) {
                    ProdbId.Add(queryParam);
                }
                
                List<Product2> productIds = [Select id,name,Apttus_Config2__HasOptions__c,Purchase_Option__c,family,(Select id,Name,Apttus_Config2__ComponentProductId__r.Purchase_Option__c,Apttus_Config2__ComponentProductId__r.name,Apttus_Config2__ComponentProductId__c,Apttus_Config2__ParentProductId__c,Apttus_Config2__ComponentProductId__r.ProductCode from Apttus_Config2__Options__r where Apttus_Config2__ComponentProductId__r.Isactive = True),Plant__c,Inte__c,Assignment__c,ProductCode from Product2 where Id IN : ProdbId AND IsActive = True];
                
                
                 
                List<id> prodoids = new List<id>();
                for(Product2 p :productIds){
                    for(Apttus_Config2__ProductOptionComponent__c op:p.Apttus_Config2__Options__r)
                        prodoids.add(op.Apttus_Config2__ComponentProductId__c);
                }
                Map<Id,Product2> plmap = new Map<Id,Product2>([select id,(select id,Apttus_Config2__ListPrice__c from Apttus_Config2__PriceLists__r where Apttus_Config2__PriceListId__c IN: plIds) from product2 where id IN:prodoids AND IsActive = True]);
                for(Product2 p :productIds){
                    System.debug(P.id);
                    System.debug(P.name);
                    System.debug('product---'+P);
                    System.debug(p.Apttus_Config2__Options__r);
                    for(Apttus_Config2__ProductOptionComponent__c OP :p.Apttus_Config2__Options__r){
                        System.debug(op.Apttus_Config2__ComponentProductId__c);
                        System.debug(P.id);
                        productattr Patt = New productattr();
                        Patt.plant = p.Plant__c;
                        Patt.assignment= p.Assignment__c;
                        Patt.salesHdr= p.Inte__c;
                        patt.purchaseOption = op.Apttus_Config2__ComponentProductId__r.purchase_Option__c;
                        Patt.materialNo = op.Apttus_Config2__ComponentProductId__r.ProductCode;
                        Patt.bId = op.Apttus_Config2__ParentProductId__c;
                        Patt.productId = op.Apttus_Config2__ComponentProductId__c;
                        if(soldToNo != null){
                            if(p.family != null && p.family.contains('Aspire'))
                                Patt.discountPercentage = Integer.valueOf(discount);
                            else
                                Patt.discountPercentage = 0;
                            if(plmap.containsKey(op.Apttus_Config2__ComponentProductId__c)){
                                system.debug('op.Apttus_Config2__ComponentProductId__c'+op.Apttus_Config2__ComponentProductId__c);
                                if(plmap.get(op.Apttus_Config2__ComponentProductId__c).Apttus_Config2__PriceLists__r[0].Apttus_Config2__ListPrice__c != null)
                                    Patt.price = plmap.get(op.Apttus_Config2__ComponentProductId__c).Apttus_Config2__PriceLists__r[0].Apttus_Config2__ListPrice__c;
                            }
                        }
                        Prodcuidlst.Add(Patt);
                        System.debug(Prodcuidlst); 
                        response.Put('products',Prodcuidlst);
                        System.debug(response);
                    }
                    
                }
            }
            if(pId != null) {
                String[] queryParamspid = pId.split(',');
                System.debug (queryParamspid);
                for(String queryParam: queryParamspid) {
                    ProdpId.Add(queryParam);
                }
                System.debug(ProdpId);
                List<Product2> productpIds = [Select id,Plant__c,Inte__c,Assignment__c,Purchase_Option__c,ProductCode,family,(select id,Apttus_Config2__ListPrice__c from Apttus_Config2__PriceLists__r where Apttus_Config2__PriceListId__c IN: plIds) from Product2 where Id IN : ProdpId AND IsActive = True];
                for(Product2 p :productpIds){
                    System.debug(p);
                    productattr Patt = New productattr();
                    Patt.plant = p.Plant__c;
                    Patt.assignment= p.Assignment__c;
                    Patt.salesHdr= p.Inte__c;
                    Patt.materialNo = P.ProductCode;
                    patt.purchaseOption = p.purchase_Option__c;
                    Patt.productId= p.id;
                    if(soldToNo != null){
                        if(p.family != null && p.family.contains('Aspire'))
                            Patt.discountPercentage = Integer.valueOf(discount);
                        else
                            Patt.discountPercentage = 0;
                        if(p.Apttus_Config2__PriceLists__r[0].Apttus_Config2__ListPrice__c != null)
                            Patt.price = p.Apttus_Config2__PriceLists__r[0].Apttus_Config2__ListPrice__c;
                    }
                    Prodcuidlst.Add(Patt);
                    System.debug(Prodcuidlst); 
                    response.Put('products',Prodcuidlst);
                    System.debug(response);
                } 
                
            } 
            
            res.responseBody = Blob.valueOf(json.serialize(response));
            res.statusCode = 200;
            // return response;
            
        }
        catch(Exception e){
            MyExc error = new MyExc('BAD_REQUEST',e.getMessage());
            system.debug('error is at '+ e.getLineNumber());
            res.responseBody = Blob.valueOf(json.serialize(error));
            res.statusCode = 400;
            //return response;
        }
    } 
    global class productattr{
        public decimal plant;
        public String assignment;
        public String salesHdr;
        public String materialNo;
        public String productId;
        Public String bId;
        Public String purchaseOption;
        public decimal price;
        public integer discountPercentage;
        
    }
    global class productListAttr{
        public List<productattr> products;
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