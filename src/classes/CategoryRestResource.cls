@RestResource(urlMapping = '/ngbss/categories/products/*')
global with sharing class CategoryRestResource{
    @HttpGet
    global static void getCategories(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        RestContext.response.addHeader('Content-Type', 'application/json');
        String categoryId = req.params.get('categoryId');
        String fields = req.params.get('fields');
        String sear = req.params.get('search');
        String search;
        if(sear != null)
            search = String.escapeSingleQuotes(sear);
        string condition = '';
        String query = '';
        
          if(fields == 'soldTo'){
            condition = ' where Required_For_Portal__c = true and Apttus_Config2__Type__c = \'' + 'Offering' + '\' Order By Name ASC'; 
            query = 'select id,name,(select Apttus_Config2__ChildProductId__c, Apttus_Config2__ProductName__c from Apttus_Config2__ProductHierarchyView__r where Apttus_Config2__ChildProductId__c != null order by Apttus_Config2__ProductName__c ASC) from Apttus_Config2__ClassificationName__c' + condition; 
        }
        else if(fields == 'categories'){
            query = 'select id,name from Apttus_Config2__ClassificationName__c where Required_For_Portal__c = true and Apttus_Config2__Type__c = \'' +'Offering' +'\' Order By Name ASC' ; 
        }
        else if(categoryId != null && search != null){
            condition = ' where Required_For_Portal__c = true and Apttus_Config2__Type__c = \'' + 'Offering' + '\' and id=\''+ categoryId + '\' Order By Name ASC';
            query = 'select id,name,(select Apttus_Config2__ChildProductId__c, Apttus_Config2__ProductName__c from Apttus_Config2__ProductHierarchyView__r where Apttus_Config2__ChildProductId__c !=null and Apttus_Config2__ProductName__c like \'%' + search + '%\' order by Apttus_Config2__ProductName__c ASC) from Apttus_Config2__ClassificationName__c' + condition;
        }
        else if(search != null){
            query = 'select id,name,(select Apttus_Config2__ChildProductId__c, Apttus_Config2__ProductName__c from Apttus_Config2__ProductHierarchyView__r where Apttus_Config2__ChildProductId__c !=null and Apttus_Config2__ProductName__c like \'%' + search + '%\' order by Apttus_Config2__ProductName__c ASC) from Apttus_Config2__ClassificationName__c where Required_For_Portal__c = true and Apttus_Config2__Type__c = \'' + 'Offering' + '\''; 
        }
        else if(categoryId != null){
            condition = ' where Required_For_Portal__c = true and Apttus_Config2__Type__c = \'' + 'Offering' + '\' and id=\''+ categoryId + '\' Order By Name ASC';
            query = 'select id,name,(select Apttus_Config2__ChildProductId__c, Apttus_Config2__ProductName__c from Apttus_Config2__ProductHierarchyView__r where Apttus_Config2__ChildProductId__c !=null order by Apttus_Config2__ProductName__c ASC) from Apttus_Config2__ClassificationName__c' + condition; 
        }   
        else{
            condition = ' where Required_For_Portal__c = true and Apttus_Config2__Type__c = \'' + 'Offering' + '\' Order By Name ASC'; 
            query = 'select id,name,(select Apttus_Config2__ChildProductId__c, Apttus_Config2__ProductName__c from Apttus_Config2__ProductHierarchyView__r where Apttus_Config2__ChildProductId__c != null order by Apttus_Config2__ProductName__c ASC) from Apttus_Config2__ClassificationName__c' + condition; 
            
        }
        system.debug(query);
        List<CategoryInfo> categoryList = new List<CategoryInfo>();
        integer count = 0;
        try{
            List<Apttus_Config2__ClassificationName__c> categories = database.query(query);
            List<String> productnames = new List<String>();
            for(Apttus_Config2__ClassificationName__c categ : categories){
                for(Apttus_Config2__ProductHierarchyView__c subcateg:categ.Apttus_Config2__ProductHierarchyView__r){
                    if(!productnames.contains(subcateg.Apttus_Config2__ChildProductId__c))
                        productnames.add(subcateg.Apttus_Config2__ChildProductId__c);
                }
            }
            List<Product2> prod = [select name, Description, Platform__c, Platform_Lable__c, Apttus_Config2__ConfigurationType__c, DisplayUrl,
                                    (select CurrencyIsoCode, Apttus_Config2__ListPrice__c from Apttus_Config2__PriceLists__r) from product2 where id IN : productnames AND IsActive = True]; 
            if(categories.size() != 0){
                for(Apttus_Config2__ClassificationName__c categ : categories){    
                    List<Product> productList = new List<Product>();
                    List<Id> prodIds = new List<Id>();
                    for(Apttus_Config2__ProductHierarchyView__c subcateg:categ.Apttus_Config2__ProductHierarchyView__r){
                        if(!prodIds.contains(subcateg.Apttus_Config2__ChildProductId__c)){
                            prodIds.add(subcateg.Apttus_Config2__ChildProductId__c);
                            Product p = new Product();
                            p.productId = subcateg.Apttus_Config2__ChildProductId__c;
                            p.productName = subcateg.Apttus_Config2__ProductName__c;
                            p.currencyASCII = 36;
                            //p.icon = 'https://qaerospace.honeywell.com/en/~/media/aero-fss-content/ads/sdc/images/default-icon.png';
                            for(Product2 p1:prod){
                                if(p1.name == subcateg.Apttus_Config2__ProductName__c){
                                    p.productDesc = p1.Description ;
                                    p.platform = p1.Platform__c;
                                    p.platformLabel = p1.Platform_Lable__c;
                                    if(p1.Apttus_Config2__ConfigurationType__c == 'Bundle'){
                                        p.priceLabel = 'Configure for Price';
                                        p.buttonLabel = 'Configure';
                                        p.subProducts = true;
                                        if(p1.DisplayUrl != null && p1.DisplayUrl != ''){
                                            Configuration c = new Configuration();
                                            //c.icon = 'https://qaerospace.honeywell.com/en/~/media/aero-fss-content/ads/sdc/images/product-template-icon.png';
                                            c.label = 'Config. Template';
                                            c.template = p1.DisplayUrl;
                                            p.config = c;
                                        }
                                    }
                                    else{
                                        p.price = p1.Apttus_Config2__PriceLists__r[0].Apttus_Config2__ListPrice__c.setScale(2) ;
                                        p.priceCurrency = p1.Apttus_Config2__PriceLists__r[0].CurrencyIsoCode ;
                                        //p.priceLabel = (((p.priceCurrency) == 'USD')?'$':'') + (p.price.setScale(2));
                                        p.discountPercentage = 0;
                                        //p.buttonLabel = 'Add To Cart';
                                        //Based on Ramesh request on 19/sep/2019 --> Start
                                        p.priceLabel = 'Configure for Price';
                                        p.buttonLabel = 'Configure';
                                        //Based on Ramesh request on 19/sep/2019 --> End
                                        p.subProducts = false;
                                    }
                                    break;
                                }
                            } 
                            count++;
                            productList.add(p);                            
                        }  
                    }
                    if(productList.size() != 0 || fields == 'categories'){  
                                CategoryInfo c = new CategoryInfo();
                                c.systemName = 'Apttus';
                                c.categoryId = categ.id;
                                c.categoryName = categ.name;
                                c.Products = productList;
                                categoryList.add(c);  
                    } 
                } 
                Response resp = new Response();
                resp.total = count;
                resp.categories = categoryList;
                res.statuscode = 200;
                res.responsebody = Blob.ValueOf(json.serialize(resp));
            }else{
                throw new MyException('Invalid Id');
            }
        }
        catch(Exception e) 
        {
            MyExc error = new MyExc('BAD_REQUEST',e.getMessage());
            
            res.statusCode = 400;
            res.responseBody = Blob.valueOf(json.serialize(error));
            
        }                
    }
    public class MyException extends Exception{ }
    global class product{   
        public string productId;
        public string productName;
        public string productDesc;
        public string delivery;
        public string priceCurrency;
        public integer currencyASCII;
        public Decimal price;
        public Decimal discountedPrice;
        public Decimal discountPercentage;
        public string priceLabel;
        public string platform;
        public string buttonLabel;
        public string productType;
        public string note;
        public string platformLabel;
        public boolean subProducts;
        public List<DependentProduct> dependency;
        public Configuration config;
    }
    
    global class CategoryInfo{
        public string systemName;
        public string categoryId;
        public string categoryName;
        public List<product> products;
    }
    
    global class DependentProduct{
        public string productId;
        public string rel;
        public string href;
    } 
    global class Response{
        public integer page;
        public integer size;
        public integer total;
        public List<CategoryInfo> categories;
    }
    global class Configuration{
        public string label;
        public string template;
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