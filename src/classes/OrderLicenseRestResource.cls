//Update Order licenses details
//URI: /services/apexrest/licenses
@RestResource(UrlMapping = '/ngbss/licenses/*')
global with sharing class OrderLicenseRestResource{
    @HttpPost
    global static void OrderlicensesHeader(){
        RestResponse res = RestContext.response;
        try{ 
            String licenseJSON = RestContext.request.requestbody.toString(); 
            system.debug('licenseJSON Body -  '+licenseJSON);
            OrderlineItems oli = (OrderlineItems)(JSON.deserialize(licenseJSON,OrderlineItems.class));  
            system.debug('request Body -  '+oli);
            res.addHeader('Content-Type','application/json');
            list<cls_lineItems> lis=oli.lineItems;
            list<string> liss= new list<string>();
            for(cls_lineItems li:lis){
                liss.add(li.lineItemId);
            }
            map<id,set<id>> maplisplatforms= new map<id,set<id>>();
            for(Apttus_Config2__OrderLineItem__c olis:[select id,(select id from CPQ_Platforms__r) from Apttus_Config2__OrderLineItem__c where id in:liss]){
                for(CPQ_Platform__c cpqp:olis.CPQ_Platforms__r){
                    if(!maplisplatforms.containsKey(olis.id)){
                        maplisplatforms.put(olis.id, new set<id>());
                    }
                    maplisplatforms.get(olis.id).add(cpqp.id);
                }
            }
            system.debug('cls_lineItems'+lis);
            list<Apttus_Config2__OrderLineItem__c> uolis = new list<Apttus_Config2__OrderLineItem__c>();
            list<CPQ_Platform__c> upfs = new list<CPQ_Platform__c>();
            list<invalidid> invalids=new list<invalidid>();
            for(cls_lineItems li:lis){
        set<id> pids= maplisplatforms.get(li.lineItemId);
                Apttus_Config2__OrderLineItem__c aoli= new Apttus_Config2__OrderLineItem__c();
                aoli.id=li.lineItemId;
                list<cls_platforms> pfs = new list<cls_platforms>();
                if(li.platforms!=null){
                    pfs=li.platforms;
                    system.debug('API platform'+pfs);
                    for(cls_platforms pf:pfs){
                        invalidid invds= new invalidid();
                        if(pids!=null && pids.contains(pf.platformId)){
              CPQ_Platform__c cpf= new CPQ_Platform__c();
              cpf.id=pf.platformId;
              if(pf.activationKey!=null && pf.activationKey!='')
              cpf.Activation_Key__c=pf.activationKey;
              if(pf.licenseStatus!=null && pf.licenseStatus!='')
              cpf.License_Status__c=pf.licenseStatus;
              upfs.add(cpf);
            }else{
              invds.platformid=pf.platformId;
              invds.Orderlineitemid=li.lineItemId;
                            invalids.add(invds);
            }
                        
                    }
                }
                if(li.activationKey!=null && li.activationKey!=''){
                    aoli.Activation_Key__c=li.activationKey;
                    uolis.add(aoli);
                }
            }
            system.debug('uolis'+uolis);
            system.debug('upfs'+upfs);
            if(uolis.size()>0)
                update uolis;
            if(upfs.size()>0)
                update upfs;
            system.debug('update uolis -  '+uolis);
            system.debug('update uolis -  '+upfs);
            if(invalids.size()>0){
                Partialsuccess ps= new Partialsuccess();
                ps.Status='Partial Success';
                ps.invalidids=invalids;
                res.responseBody = Blob.valueOf(json.serialize(ps));
              res.statusCode = 206;
            }else{
                res.responseBody = Blob.valueOf('{"Status":"Success"}');
               res.statusCode = 200;
            }
            
        }catch(Exception e){
            MyExc error = new MyExc('BAD_REQUEST',e.getMessage());
            res.responseBody = Blob.valueOf(json.serialize(error));
            res.statusCode = 400; 
        }
    }
    
    global class Partialsuccess{
        public string Status;
        public list<invalidid> invalidids;
    }
    global class invalidid{
        public String platformid;
        public String Orderlineitemid;
    }
    global class OrderlineItems{
        List<cls_lineItems> lineItems;
    }
    global class cls_lineItems {
        public String lineItemId;   //id
        public String activationKey;    //key
        public cls_platforms[] platforms;
    }
    global class cls_platforms {
        public String platformId;  //id
        public String activationKey;    //key
        public String licenseStatus;   //completed....
    }
    
    
    //Get Request
    @HttpGet
    global static void getOrderlicenses(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type','Application/Json');
        String invoiceId = req.params.get('invoiceId');
        string soldTos = req.params.get('soldTos');
        string category = req.params.get('categoryName');
        system.debug('invoiceId'+invoiceId);
        list<Apttus_Config2__OrderLineItem__c> olis= new list<Apttus_Config2__OrderLineItem__c>();
        
        try{
            if(soldTos != null && invoiceId !=null )
                throw new MyException('Please provide either Invoice Id or soldTo numbers. Both are not supported');
            if(invoiceId != null && invoiceId != ''){
                
                //check for Invalid Invoice id
                integer count = [select count() from Apttus_Billing__Invoice__c where id =: invoiceId];
                if(count <= 0)
                    throw new MyException('Invalid Invoice Id');
                //get BillingSchedule -> order line item ids from InvoiceLineItem based on invoice id
                list<Apttus_Billing__InvoiceLineItem__c> InvoiceLineItems= new list<Apttus_Billing__InvoiceLineItem__c>();
                InvoiceLineItems= [select id,Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__c,Apttus_Billing__InvoiceId__c from Apttus_Billing__InvoiceLineItem__c where Apttus_Billing__InvoiceId__c=:invoiceId and Is_License_Required_c__c = true];
                list<id> oliids=new list<id>();
                for(Apttus_Billing__InvoiceLineItem__c inv:InvoiceLineItems){
                    oliids.add(inv.Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__c);
                }
                system.debug('oliids'+oliids);
                //get order line item with Platforms
                if(category != null && category != ''){
                    olis = [select id,name,License_Expiry_Date__c,Activation_Key__c,
                            Apttus_Config2__OptionId__r.Part_Number__c,Apttus_Config2__OptionId__r.Product_Type_c__c,Apttus_Config2__OptionId__r.Description,Apttus_Config2__OptionId__r.name,
                            Apttus_Config2__ProductId__r.name,Apttus_Config2__ProductId__r.Family,Apttus_Config2__ProductId__r.License_Type__c,Apttus_Config2__OptionId__r.License_Type__c,
                            Apttus_Config2__OrderId__c, Apttus_Config2__OrderId__r.createddate,Apttus_Config2__OrderId__r.soldToNumber__c,Apttus_Config2__OrderId__r.Apttus_Config2__SoldToAccountId__r.Name, 
                            (select id,Name,Activation_Key__c,Distribution_Number__c,License_Status__c,License_Expiry_Date__c from CPQ_Platforms__r) 
                            from Apttus_Config2__OrderLineItem__c
                            where id=:oliids and Apttus_Config2__ProductId__r.Family =: category];
                    
                    system.debug('olis'+olis);
                }
                else{
                    olis = [select id,name,License_Expiry_Date__c,Activation_Key__c,
                            Apttus_Config2__OptionId__r.Part_Number__c,Apttus_Config2__OptionId__r.Product_Type_c__c,Apttus_Config2__OptionId__r.Description,Apttus_Config2__OptionId__r.name,
                            Apttus_Config2__ProductId__r.name,Apttus_Config2__ProductId__r.Family,Apttus_Config2__ProductId__r.License_Type__c,Apttus_Config2__OptionId__r.License_Type__c,
                            Apttus_Config2__OrderId__c, Apttus_Config2__OrderId__r.createddate,Apttus_Config2__OrderId__r.soldToNumber__c,Apttus_Config2__OrderId__r.Apttus_Config2__SoldToAccountId__r.Name, 
                            (select id,Name,Activation_Key__c,Distribution_Number__c,License_Status__c,License_Expiry_Date__c from CPQ_Platforms__r) 
                            from Apttus_Config2__OrderLineItem__c
                            where id=:oliids];
                    
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
                List<Apttus_Config2__Order__c> orders = [select id,Apttus_Config2__SoldToAccountId__r.Name,soldToNumber__c,CreatedDate from Apttus_Config2__Order__c where soldToNumber__c IN:soldToList ];
                if(orders.size() > 0){
                    List<Id> orderId = new List<Id>();
                    for(Apttus_Config2__Order__c od:orders){
                        orderId.add(od.id);
                    }
                    
                    if(category != null && category != ''){
                        olis = [select id,name,License_Expiry_Date__c,Activation_Key__c,
                                Apttus_Config2__OptionId__r.Part_Number__c,Apttus_Config2__OptionId__r.Product_Type_c__c,Apttus_Config2__OptionId__r.Description,Apttus_Config2__OptionId__r.name,
                                Apttus_Config2__ProductId__r.name,Apttus_Config2__ProductId__r.Family,Apttus_Config2__ProductId__r.License_Type__c,Apttus_Config2__OptionId__r.License_Type__c,
                                Apttus_Config2__OrderId__c, Apttus_Config2__OrderId__r.createddate,Apttus_Config2__OrderId__r.soldToNumber__c,Apttus_Config2__OrderId__r.Apttus_Config2__SoldToAccountId__r.Name, 
                                (select id,Name,Activation_Key__c,Distribution_Number__c,License_Status__c,License_Expiry_Date__c from CPQ_Platforms__r) 
                                from Apttus_Config2__OrderLineItem__c 
                                where Apttus_Config2__OrderId__c=:orderId and Apttus_Config2__ProductId__r.Family =: category and Apttus_Config2__OptionId__r.Is_License_Required__c = true];
                        
                        system.debug('olis'+olis);
                    }
                    else{
                        olis = [select id,name,License_Expiry_Date__c,Activation_Key__c,
                                Apttus_Config2__OptionId__r.Part_Number__c,Apttus_Config2__OptionId__r.Product_Type_c__c,Apttus_Config2__OptionId__r.Description,Apttus_Config2__OptionId__r.name,
                                Apttus_Config2__ProductId__r.name,Apttus_Config2__ProductId__r.Family,Apttus_Config2__ProductId__r.License_Type__c,Apttus_Config2__OptionId__r.License_Type__c,
                                Apttus_Config2__OrderId__c, Apttus_Config2__OrderId__r.createddate,Apttus_Config2__OrderId__r.soldToNumber__c,Apttus_Config2__OrderId__r.Apttus_Config2__SoldToAccountId__r.Name, 
                                (select id,Name,Activation_Key__c,License_Status__c,Distribution_Number__c,License_Expiry_Date__c from CPQ_Platforms__r) 
                                from Apttus_Config2__OrderLineItem__c 
                                where Apttus_Config2__OrderId__c=:orderId and Apttus_Config2__OptionId__r.Is_License_Required__c = true];
                        
                        system.debug('olis'+olis);
                    }
                }
                    
            }
            else{
               throw new MyException('Please provide either Invoice Id or soldTo numbers'); 
            }
               
            map<id,list<Apttus_Config2__OrderLineItem__c>> maporditems= new map<id,list<Apttus_Config2__OrderLineItem__c>>();
                set<id> ordids=new set<id>();
                for(Apttus_Config2__OrderLineItem__c oli:olis){
                    //List<Apttus_Config2__OrderId__c> orli = oli;
                    if(!maporditems.containsKey(oli.Apttus_Config2__OrderId__c)) {
                        maporditems.put(oli.Apttus_Config2__OrderId__c, new List<Apttus_Config2__OrderLineItem__c>()); 
                    }
                    maporditems.get(oli.Apttus_Config2__OrderId__c).add(oli);
                    ordids.add(oli.Apttus_Config2__OrderId__c);
                }
                system.debug('maporditems'+maporditems);
                system.debug('ordids'+ordids);
                list<cls_orders> clsords= new list<cls_orders>();
                for(id ordid: ordids){
                    list<cls_lineItemsg> clis= new list<cls_lineItemsg>();
                    string customerName;
                    string soldTo;
                    string ordcreateddate;
                    
                    for(Apttus_Config2__OrderLineItem__c aoli:maporditems.get(ordid)){
                         System.debug('aoli ='+ aoli);
                        if((aoli.License_Expiry_Date__c != null && aoli.License_Expiry_Date__c != '') && (aoli.License_Expiry_Date__c == 'Unlimited' || date.valueOf(aoli.License_Expiry_Date__c) >= Date.Today()))
                        {
                           
                            cls_lineItemsg cli= new cls_lineItemsg();
                            cli.productName=aoli.Apttus_Config2__ProductId__r.name; 
                            cli.partNumber=aoli.Apttus_Config2__OptionId__r.Part_Number__c;
                            cli.distributionType=aoli.Apttus_Config2__OptionId__r.Product_Type_c__c;
                            cli.licenseType=aoli.Apttus_Config2__ProductId__r.License_Type__c;
                            cli.expiryDate=aoli.License_Expiry_Date__c;
                            cli.subProductName=aoli.Apttus_Config2__OptionId__r.name;   
                            cli.subProductDesc=aoli.Apttus_Config2__OptionId__r.Description;
                            cli.categoryName=aoli.Apttus_Config2__ProductId__r.Family;
                            cli.LineItemId=aoli.id;
                            cli.activationKey=aoli.Activation_Key__c;
                                         
                            list<cls_platformsg> cpfs= new list<cls_platformsg>();
                            list<CPQ_Platform__c> Platforms=new list<CPQ_Platform__c>();
                            Platforms = aoli.CPQ_Platforms__r;
                            system.debug('Platforms'+Platforms);
                            for(CPQ_Platform__c Pf: Platforms){
                                cls_platformsg cpf= new cls_platformsg();
                                cpf.serialNumber=pf.Name;
                                cpf.platformId=Pf.id;
                                cpf.distributionNo=pf.Distribution_Number__c;
                                cpf.activationKey=pf.Activation_Key__c;
                                cpf.expiryDate=pf.License_Expiry_Date__c;
                                cpf.licenseStatus=pf.License_Status__c;
                                cpfs.add(cpf);
                            }
                            cli.platforms=cpfs;
                            clis.add(cli);
                            customerName=aoli.Apttus_Config2__OrderId__r.Apttus_Config2__SoldToAccountId__r.Name;
                            soldTo= aoli.Apttus_Config2__OrderId__r.soldToNumber__c; 
                            ordcreateddate=aoli.Apttus_Config2__OrderId__r.CreatedDate.formatGMT('MM-dd-yyyy\' \'HH:mm');
                            
                        }
                        Else If(aoli.Apttus_Config2__OptionId__r.License_Type__c == 'APU')
                        {
                            Boolean flag = False;
                                                         
                            list<cls_platformsg> cpfs= new list<cls_platformsg>();
                            list<CPQ_Platform__c> Platforms=new list<CPQ_Platform__c>();
                            Platforms = aoli.CPQ_Platforms__r;
                            for(CPQ_Platform__c Pf: Platforms){
                                IF((pf.License_Expiry_Date__c != null && pf.License_Expiry_Date__c != '') && (pf.License_Expiry_Date__c == 'Unlimited' || date.valueOf(pf.License_Expiry_Date__c) >= Date.Today()) )
                                {
                                   flag = true;
                                cls_platformsg cpf= new cls_platformsg();
                                cpf.serialNumber=pf.Name;
                                cpf.platformId=Pf.id;
                                cpf.distributionNo=pf.Distribution_Number__c;
                                cpf.activationKey=pf.Activation_Key__c;
                                System.debug('pf.License_Expiry_Date__c'+pf.License_Expiry_Date__c);
                                System.debug('pf.License_Expiry_Date__c'+pf);
                                cpf.expiryDate=pf.License_Expiry_Date__c;
                                cpf.licenseStatus=pf.License_Status__c;
                                cpfs.add(cpf);
                                }
                               } 
                                {
                                  flag = False;
                            cls_lineItemsg cli= new cls_lineItemsg();
                            cli.productName=aoli.Apttus_Config2__ProductId__r.name; 
                            cli.partNumber=aoli.Apttus_Config2__OptionId__r.Part_Number__c;
                            cli.distributionType=aoli.Apttus_Config2__OptionId__r.Product_Type_c__c;
                            cli.licenseType=aoli.Apttus_Config2__ProductId__r.License_Type__c;
                            cli.expiryDate=aoli.License_Expiry_Date__c;
                            cli.subProductName=aoli.Apttus_Config2__OptionId__r.name;   
                            cli.subProductDesc=aoli.Apttus_Config2__OptionId__r.Description;
                            cli.categoryName=aoli.Apttus_Config2__ProductId__r.Family;
                            cli.LineItemId=aoli.id;
                            cli.activationKey=aoli.Activation_Key__c;
                            
                            cli.platforms=cpfs;
                            clis.add(cli);
                            customerName=aoli.Apttus_Config2__OrderId__r.Apttus_Config2__SoldToAccountId__r.Name;
                            soldTo= aoli.Apttus_Config2__OrderId__r.soldToNumber__c; 
                            ordcreateddate=aoli.Apttus_Config2__OrderId__r.CreatedDate.formatGMT('MM-dd-yyyy\' \'HH:mm'); 
                                
                               
                            
                            }
                        }
                        
                    }
                    cls_orders clsord =new cls_orders();
                    clsord.orderId=ordid;
                    clsord.customerName=customerName;//Apttus_Config2__OrderId__r.Apttus_Config2__SoldToAccountId__r.Name
                    clsord.orderDate=ordcreateddate;
                    clsord.soldTo=soldTo;//Apttus_Config2__OrderId__r.CreatedDate 
                    clsord.lineItems = clis;
                    clsords.add(clsord);
                    system.debug('clis'+clis);
                }
                //}
                system.debug('clsords'+clsords);
                Response resp = new Response();
                resp.orders = clsords;
                res.statuscode = 200;
                
                
                res.responsebody = Blob.ValueOf(Json.serialize(resp));
        }catch(Exception e){
            res.statuscode = 400;
            res.responsebody = Blob.ValueOf(e.getMessage()); 
            system.debug('exception is '+e.getLineNumber());
        }
    }
    global class Response{
        public List<cls_orders> orders;
    }
    global class cls_orders {
        public String orderId;
        public String customerName;
        public String soldTo;
        public String orderDate;
        public cls_lineItemsg[] lineItems;
    }
    global class cls_lineItemsg {
        public String productName;  //Aspire 400License/Activation Keys
        public String partNumber;   //90408779-1Y
        public String subProductName;   //Cabin SIP PBX capability License Key
        public String subProductDesc;   //Aspire Part Number: 90408779
        public String categoryName; //Aspire
        public String lineItemId;   //TEST
        public String activationKey;    //licenseType
        public String expiryDate;
        public String distributionType;
        public String licenseType;   //
        public cls_platformsg[] platforms;
    }
    global class cls_platformsg {
        public String serialNumber; //12345
        public String distributionNo;
        public String platformId;   //status
        public String activationKey;    //
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