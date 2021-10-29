@RestResource(UrlMapping = '/ngbss/orders/*/cart/products/*')
global with sharing class CreateOrderLineItemsRestResource{
    @HttpPost
    global static void createLineItems(){
        RestResponse res = RestContext.response;
        
        
        try{
            RestRequest request = RestContext.request;
            system.debug('URL Data >> '+ request.requestURI.split('/')[3]);
            String orderId = request.requestURI.split('/')[3];
            integer orderCount = [select count() from Apttus_Config2__Order__c where id=:orderId];
            if(orderCount==0){
                // throw exception
                throw new MyException('OrderId is Invalid');
            }
            string  inputtype= RestContext.request.params.get('input-type');
            String orderliJSON = RestContext.request.requestbody.toString();
            system.debug('result Json=='+orderliJSON);
            
            //input-type=PID/MNO
            system.debug('inputtype'+inputtype);
            if(inputtype==null || inputtype=='')
                throw new MyException('input-type is mandatory');
            
            inputtype= inputtype.touppercase();
            
            if(inputtype!='PID' && inputtype!='MNO')
                throw new MyException('input-type is not valid');
            if(inputtype=='PID' && !orderliJSON.toLowerCase().contains('productid'))
                throw new MyException('PID not avaliable/provided');
            if(inputtype=='MNO' && !orderliJSON.toLowerCase().contains('materialno'))
                throw new MyException('MNO not avaliable/provided');
            
            
            boolean ismaterialno=false;
            boolean isproductId=false;
            if(inputtype=='PID'){
                isproductId=true;
            }else if(inputtype=='MNO'){
                ismaterialno=true;
            }
            system.debug('isproductId=='+isproductId);
            system.debug('ismaterialno=='+ismaterialno);
            
            OrderWithProducts op = (OrderWithProducts)(JSON.deserialize(orderliJSON,OrderWithProducts.class));
            system.debug('op==='+op);
            List<BundleDetails> bundle = op.products;  
             
            if(op.lockBox ==null || op.lockBox =='')
                throw new MyException('LockBox Number is mandatory');
            String lockBox = op.lockBox;
                   
            res.addHeader('Content-Type','application/json');
            Apttus_Config2.CPQStruct.CreateCartRequestDO creq = new Apttus_Config2.CPQStruct.CreateCartRequestDO();
            creq.OrderId = orderId;
            Apttus_Config2.CPQStruct.CreateCartResponseDO cres = Apttus_Config2.OrderWebService.createCart(creq);          
            List<Id> bundleIds = new List<Id>();
            set<string> materialnos = new set<string>();
            System.debug('bundle='+bundle);
            for(BundleDetails bd:bundle){ 
             System.debug('BundleDetails '+bd); 
              System.debug('bd.productId'+bd.productId);               
                    if(bd.productId == Null || bd.productId == '')
                        throw new MyException('Product Id is mandatory');
                    else
                        bundleIds.add(bd.productId); 
                 System.debug('bundleIds'+bundleIds);   
                 System.debug('ismaterialno'+ismaterialno);          
                if(ismaterialno){
                    System.debug('bd.subProducts'+bd.subProducts);
                    for(ProductDetails prod:bd.subProducts){
                    System.debug('prod.materialno'+prod.materialno);
                        if(prod.materialno != null && prod.materialno != ''){
                            if(!materialnos.contains(prod.materialno)){
                                materialnos.add(prod.materialno);
                            }else{
                                throw new MyException('Duplicate Material Number Found'+' '+prod.materialno);
                            }
                        }
                        else
                            throw new MyException('Material number cannot be null or blank');
                        
                    }
                }
            }
            List<product2> prodOg = [select name,(select id from Apttus_Config2__OptionGroups__r) from product2 where id IN:bundleIds];
            Map<string,id> mnprodids= new Map<string,id>();//Material No and Product ID
            set<string> prodmaterialno = new set<string>();
            if(ismaterialno && materialnos.size()>0){
                String families = Label.Aspire_APU_Families;
                List<String> familyList = families.split(';');
                for(product2 p2:[select id,name,Family,ProductCode from product2 where ProductCode IN:materialnos and Family IN:familyList]){
                    mnprodids.put(p2.ProductCode,p2.id);
                    prodmaterialno.add(p2.ProductCode);
                } 
                system.debug('familyList is '+familyList+'familyList size is '+familyList.size());
                system.debug('prodmaterialno '+prodmaterialno);
            }
            
            if(ismaterialno && mnprodids.isEmpty()){
                throw new MyException('Invalid Material Numbers '+materialnos);
            }else if(ismaterialno && !mnprodids.isEmpty()){
                list<string> invalidmaterialno = new list<string>();
                for(string mnos:materialnos){
                    if(!prodmaterialno.contains(mnos))
                        invalidmaterialno.add(mnos);
                }
                if(invalidmaterialno.size()>0)
                    throw new MyException('Invalid Material Numbers '+invalidmaterialno);
            }    
            system.debug('mnprodids'+mnprodids);
            Map<id,id> prodOgMap = new Map<id,id>();
            for(product2 p:prodOg ){
                for(Apttus_Config2__ProductOptionGroup__c pog:p.Apttus_Config2__OptionGroups__r){
                    prodOgMap.put(p.id,pog.id);
                }
            }
            system.debug('prodOg'+prodOg);
            system.debug('prodOgMap'+prodOgMap);            
            List<Apttus_Config2__ProductOptionGroup__c> pogc = [select id,(select id,Apttus_Config2__ComponentProductId__c from Apttus_Config2__Options__r) from Apttus_Config2__ProductOptionGroup__c where id IN:prodOgMap.values()];
            Map<id,List<Apttus_Config2__ProductOptionComponent__c>> pogcMap = new Map<id,List<Apttus_Config2__ProductOptionComponent__c>>();
            for(Apttus_Config2__ProductOptionGroup__c og:pogc){
                List<Apttus_Config2__ProductOptionComponent__c> poclist = new List<Apttus_Config2__ProductOptionComponent__c>();
                for(Apttus_Config2__ProductOptionComponent__c oc:og.Apttus_Config2__Options__r){
                    poclist.add(oc);
                }
                pogcMap.put(og.id,poclist);
            }
            system.debug('pogcMap'+pogcMap);
            List<ProductDetails> products = new List<ProductDetails>(); //Used to update platforms
            map<string,list<ProductDetails>> sproductsmap= new map<string,list<ProductDetails>>();//SubprodID and platforms
            set<string> clonespids= new set<string>();
            for(BundleDetails bd:bundle){  
               
                //Add products to the cart
                Apttus_CPQApi.CPQ.AddBundleRequestDO preq= new Apttus_CPQApi.CPQ.AddBundleRequestDO();
                preq.CartId=cres.CartId; 
                preq.SelectedBundle = new Apttus_CPQApi.CPQ.SelectedBundleDO();
                preq.SelectedBundle.SelectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
                preq.SelectedBundle.SelectedProduct.ProductId = bd.productId;
                preq.SelectedBundle.SelectedProduct.Quantity = 1;
                id ogidtemp;
                system.debug('bd.productId'+bd.productId);
               
                if(prodOgMap.containsKey(bd.productId))
                    ogidtemp = prodOgMap.get(bd.productId);
                List<ProductDetails> pd = bd.subProducts;
                List<Apttus_CPQApi.CPQ.SelectedOptionDO> SelectedProductsList= new List<Apttus_CPQApi.CPQ.SelectedOptionDO>();
                for(ProductDetails prod:pd){
                    products.add(prod); //Used to update platforms
                    Id subid;
                    if(ismaterialno){
                        subid= mnprodids.get(prod.materialno);
                        //subid='01t0U000001AzS8';
                        system.debug('subid Mno=='+subid);
                    }else {
                            if(prod.subProductId != null && prod.subProductId != '')
                                subid = prod.subProductId; //15 to 18 digit id
                            else
                                throw new MyException('subProductId cannot be null or empty');
                    }
                    system.debug('subid=='+subid);
                    if(sproductsmap.containsKey(subid)) {
                        sproductsmap.get(subid).add(prod);
                        clonespids.add(subid);//adding dupicate SubprodIDs to clone
                    } else {
                        sproductsmap.put(subid, new List<ProductDetails> { prod });
                        
                    }
                    system.debug('Quantity '+preq.SelectedBundle.SelectedProduct.Quantity);
                    Apttus_CPQApi.CPQ.SelectedOptionDO SelectedProduct= new Apttus_CPQApi.CPQ.SelectedOptionDO();
                    system.debug('ogidtemp'+ogidtemp);
                    if(pogcMap.containsKey(ogidtemp)){
                        List<Apttus_Config2__ProductOptionComponent__c> poclisttemp = pogcMap.get(ogidtemp);
                        system.debug('poclisttemp'+poclisttemp);                        
                        for(Apttus_Config2__ProductOptionComponent__c poctemp:poclisttemp){
                            if(poctemp.Apttus_Config2__ComponentProductId__c == subid){
                                SelectedProduct.ComponentId = poctemp.id;
                                //SelectedProduct.ComponentProductId = prod.subProductId;
                                SelectedProduct.ComponentProductId = subid;
                                break;
                            }
                        }
                    }
                    system.debug('SelectedProduct '+SelectedProduct);                   
                    SelectedProductsList.add(SelectedProduct);                  
                    system.debug(SelectedProductsList.size()+'---SelectedProductsList---'+SelectedProductsList); 
                }
                system.debug('Total Quantity '+preq.SelectedBundle.SelectedProduct.Quantity);
                system.debug('sproductsmap**= '+sproductsmap);
                system.debug('Final SelectedProductsList '+SelectedProductsList);
                system.debug('Final SelectedProductsList Size---'+SelectedProductsList.size());
                preq.selectedBundle.SelectedOptions = SelectedProductsList;//Apttus Duplicate Options are not insert/Allowed- Clone the subProductIds in nextstep
                Apttus_CPQApi.CPQ.AddBundleResponseDO pres =Apttus_CPQApi.CPQWebService.addBundle(preq);
                system.debug('pres is '+ pres);
               
            }
            //Clone Duplicate Option Line Items.
            if(clonespids.size()>0){
                system.debug('clonespids=Size='+clonespids.size()+'--=='+clonespids);
                List<Apttus_Config2__LineItem__c> primaryNumberitems = [SELECT id,Apttus_Config2__PrimaryLineNumber__c FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__OptionId__c in: clonespids and Apttus_Config2__ConfigurationId__c =: cres.cartId];
                system.debug('Cloned primaryNumberitems=='+primaryNumberitems);
                for(Apttus_Config2__LineItem__c cli : primaryNumberitems){
                    Apttus_CPQApi.CPQ.CloneLineItemsRequestDO crequest = new Apttus_CPQApi.CPQ.CloneLineItemsRequestDO();
                    crequest.CartId = cres.CartId;
                    Decimal prNumber = cli.Apttus_Config2__PrimaryLineNumber__c;
                    crequest.PrimaryLineNumbers.add(prNumber.intValue());
                    //crequest.PrimaryLineNumbers.add(3);
                    //Apttus_CPQApi.CPQ.CloneLineItemsResponseDO result = Apttus_CPQApi.CPQWebService.cloneLineItems(crequest); 
                    Apttus_CPQApi.CPQ.CloneLineItemsResponseDO result = Apttus_CPQApi.CPQWebService.cloneOptionLineItems(crequest);
                }
            }
            respData data = new respData();
            data.cartId = cres.cartId;  
            //Updating Platform details
            List<CPQ_Platform__c> platforms = new List<CPQ_Platform__c>();
            List<Apttus_Config2__LineItem__c> lineitems = [select id, Apttus_Config2__OptionId__c,Apttus_Config2__Quantity__c,Apttus_Config2__OptionId__r.Term__c,Apttus_Config2__OptionId__r.License_Type__c,Apttus_Config2__ProductId__r.License_Type__c,Apttus_Config2__EndDate__c,LockBox_Number__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =: cres.cartId];
            system.debug('lineitems is '+lineitems);
               Apttus_Config2__Order__c Acorder = [Select id,Apttus_Config2__OrderEndDate__c from Apttus_Config2__Order__c where id =:orderId];
            for(Apttus_Config2__LineItem__c li:lineitems){  
                system.debug(li.id+'----li.Apttus_Config2__OptionId__c==== '+li.Apttus_Config2__OptionId__c);
                list<ProductDetails> sproducts = new list<ProductDetails>();
                sproducts = sproductsmap.get(li.Apttus_Config2__OptionId__c);
                //integer quantity=0;
                //system.debug('sproducts==' +sproducts.size()+'==='+sproducts);
                if(sproductsmap.containsKey(li.Apttus_Config2__OptionId__c)){
                    for(ProductDetails Sprod : sproductsmap.get(li.Apttus_Config2__OptionId__c)){
                        system.debug('Sprod is '+Sprod);
                        for(innserData p:Sprod.platforms){       
                            system.debug('platform is '+p);
                            CPQ_Platform__c platform = new CPQ_Platform__c();
                            platform.Line_Item__c = li.id;
                            if(p.serialNumber ==null || p.serialNumber==''){
                                throw new MyException('Serial Number is mandatory');
                                }else if(Integer.valueof(p.serialNumber) <= 2000) {
                                throw new MyException('Serial Number is too short');
                            }else{
                                platform.name = p.serialNumber;
                                platform.Type__c = p.type;
                                platform.Distribution_Number__c =p.distributionNo;
                                System.debug('li.Apttus_Config2__OptionId__r.Term__c'+li.Apttus_Config2__OptionId__r.Term__c);
                                 System.debug('li.Apttus_Config2__OptionId__r.License_Type__c'+li.Apttus_Config2__OptionId__r.License_Type__c);
                                 System.debug('p.expiryDate=='+p.expiryDate);
                                If(li.Apttus_Config2__OptionId__r.Term__c != Null && li.Apttus_Config2__OptionId__r.Term__c == '1 year' && (p.expiryDate == Null || p.expiryDate == '' || String.isBlank(p.expiryDate)) && li.Apttus_Config2__OptionId__r.License_Type__c == 'APU' )
                                {
                                 
                                  Date d = Acorder.Apttus_Config2__OrderEndDate__c.AddMonths(12);
                                  platform.License_Expiry_Date__c = DateTime.newInstance(d.year(),d.month(),d.day()).format('yyyy-MM-dd');
                                                                                                  
                                }
                                Else If(li.Apttus_Config2__OptionId__r.Term__c != Null && (li.Apttus_Config2__OptionId__r.Term__c == 'Indefinite' || li.Apttus_Config2__OptionId__r.Term__c == '100 year') && (p.expiryDate ==Null || p.expiryDate =='' || String.isBlank(p.expiryDate)) && li.Apttus_Config2__OptionId__r.License_Type__c == 'APU' )
                                {
                                  Date d = Acorder.Apttus_Config2__OrderEndDate__c.Addyears(100);
                                  platform.License_Expiry_Date__c = DateTime.newInstance(d.year(),d.month(),d.day()).format('yyyy-MM-dd');
                                }
                                Else If((p.expiryDate != Null || p.expiryDate !='') && li.Apttus_Config2__OptionId__r.License_Type__c == 'APU')
                                {
                                  platform.License_Expiry_Date__c =p.expiryDate;
                                }
                                
                               
                                platforms.add(platform);
                                
                            }
                            
                            
                            system.debug('Updating platform details2' +p);
                            
                           
                        }
                        li.Apttus_Config2__Quantity__c = Sprod.platforms.size();
                        li.LockBox_Number__c = lockBox;
                    }
                }
                
            }
            system.debug('platforms' +platforms);
            if(platforms.size() > 0)
                insert platforms;
            system.debug('After insert platforms' +platforms);
            update lineitems;
            system.debug('End platforms'+platforms);
            res.responseBody = Blob.valueOf(JSON.serialize(data));//cres.CartId));
            res.statusCode = 200;
  
        }
        catch(Exception e){
            system.debug('error is at '+e.getLineNumber());
            MyExc error = new MyExc('BAD_REQUEST',e.getMessage());
            res.responseBody = Blob.valueOf(json.serialize(error));
            res.statusCode = 400;   
        }
    }
    public class innserData{
        public string type;
        public string serialNumber;
        public string distributionNo;
        public string expiryDate;
    }
    global class platforms{
        public list<innserData> platformsdata;
    }
    global class ProductDetails{
        public string subProductId;
        public string materialno;
        public List<innserData> platforms;
    }
   
    //response structure  
    global class responceDetails{
        List<resBundleDetails> Products;
        public string cartId;
        
    }
    global class resBundleDetails{//products
        List<ResProductDetails> subProducts;//lineitems
        public string productId;
    }
    global class ResProductDetails{//lineitems
        public string lineitemId;
        public string subProductId;
        public List<innserData> platforms;//platforms
    }
    //response structure
    global class MyExc { 
        public string errorCode;
        public string message;
        MyExc(string errorCode, string message){
            this.errorCode = errorCode;
            this.message = message;
        }
    }
    global class BundleDetails{
        List<ProductDetails> subProducts; 
        public string productId;
    }
    global class OrderWithProducts{
        List<BundleDetails> products;
        Public String lockBox;
    }
    global class respData{
        string cartId;
    }
    global class Partialsuccess{
        public string Status;
        public list<invalidid> invalidids;
    }
    global class invalidid{
        public String platformid;
        public String Orderlineitemid;
    }
    public class MyException extends Exception {}
}