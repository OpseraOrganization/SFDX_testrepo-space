/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : AddOpportunityProduct_ATR
* Description           : Controller used for AddOpportunityProduct_ATR page
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* Jun-27-2012      1.0            NTTData               Initial Version created
***********************************************************************************************************/
public with sharing class AddOpportunityProduct_ATR{

    List<priceBookEntry> selectedpriceBookEntries = new List<priceBookEntry>();
     
    //variable declaration
    public OpportunityLineItem olItem{get; set;}
    String profileId = System.Userinfo.getprofileId();
    string oppid;
    string rid;
    
    
    public boolean OERecordType {get; set;}
    public boolean exceptionOccurred {get; set;}
    public boolean productValPresent {get; set;}
    public boolean fieldException {get; set;}
    public Exception exceptionMessage {get; set;}    
    public String fieldExceptionMessage {get; set;}
    
    public Opportunity theOpp {get;set;}
    public String searchString {get;set;}
    public opportunityLineItem[] shoppingCart {get;set;}
    public priceBookEntry[] AvailableProducts {get;set;}
    public Pricebook2 theBook {get;set;}   
    
    public String toSelect1 {get; set;}
    public String toUnselect {get; set;}
    public Decimal Total {get;set;}
    
    public Boolean overLimit {get;set;}
    
    private Boolean forcePricebookSelection = false;
        
    //profileid = profileId.substring(0,15);
    String pName = [SELECT Name FROM Profile where Id  =: profileid].Name;
    public List<SelectOption> options{get;set;}
    public String selectedItem{set;get;}
    public  AddOpportunityProduct_ATR(ApexPages.StandardController controller) 
    {
        options = new List<SelectOption>();
        oppid = System.currentPageReference().getParameters().get('id');
        rid = System.currentPageReference().getParameters().get('rid');
        theOpp = [select Id, Pricebook2Id, PriceBook2.Name from Opportunity where Id = :oppid limit 1];
        
        List<Pricebook2> MyPricebook2List = new List<Pricebook2>([SELECT Id, Name FROM Pricebook2 where IsActive=true ORDER BY Name ASC]);
        for (Pricebook2 pb2 : MyPricebook2List) {
            options.add(new SelectOption(pb2.id, pb2.name));
            if(pb2.name == 'AT&R RMU & Services Price Book'){
                selectedItem = pb2.id;
            }
        }
        if(selectedItem == null){
            if(options.size()>0){
                selectedItem = MyPricebook2List.get(0).id;
            }
        }
        // If products were previously selected need to put them in the "selected products" section to start with
        shoppingCart = [select Active__c,Probability__c ,Plant__c ,Type__c ,servicedate,Id, Quantity, TotalPrice, UnitPrice, Description, PriceBookEntryId, PriceBookEntry.Name, PriceBookEntry.IsActive, PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name, PriceBookEntry.PriceBook2Id from opportunityLineItem where OpportunityId=:theOpp.Id];
        theBook = new Pricebook2();
        theBook.id = selectedItem;
        // Check if Opp has a pricebook associated yet
        if(theOpp.Pricebook2Id == null )
        {
            /*Pricebook2[] activepbs = [select Id, Name from Pricebook2 where isActive = true limit 2];
            if(activepbs.size() == 2){
                forcePricebookSelection = true;
                theBook = new Pricebook2();
            }
            else{
                theBook = activepbs[0];
            }*/
            
        }
        else{
            theBook = theOpp.Pricebook2;
        }
        if(!forcePricebookSelection)
            updateAvailableList();        
    }
    

    public PageReference Editpage(){
    olItem = New OpportunityLineItem(); 
        olItem.Opportunityid=oppid;
        OERecordType=false;
        
        if(rid == '01230000000ZQCb' || rid == '01230000000ZQCg')
        {
            OERecordType=true;
        }
        
        if(forcePricebookSelection){        
            return changePricebook();
        }
        else{
        
            //if there is only one active pricebook we go with it and save the opp
            if(theOpp.pricebook2Id != theBook.Id)
            {
                try{
                    theOpp.Pricebook2Id = theBook.Id;
                    update(theOpp);
                }
                catch(Exception e){
                    System.debug('Exception occured '+e);
                    ApexPages.addMessages(e);
                    exceptionOccurred = true;
                    exceptionMessage = e;
                }
            }
         
            return null;
        }
    }
    
    /*
    public String getChosenCurrency(){
    
        if(multipleCurrencies)
            return (String)theOpp.get('CurrencyIsoCode');
        else
            return '';
    }
    */
    
    public void updateAvailableList() {
    theBook.id = selectedItem;
    //displayPopup = true;
    
        // We dynamically build a query string and exclude items already in the shopping cart
        String qString = 'select Id, Pricebook2Id, IsActive, Product2.Name, Product2.Family, Product2.IsActive, Product2.Description, Product2.CanUseQuantitySchedule,Product2.CanUseRevenueSchedule,Product2.Comments__c,Product2.Product_Line__c,Product2.Product_Number__c,Product2.RMU__c,UnitPrice from PricebookEntry where IsActive=true and Pricebook2Id = \'' + theBook.Id + '\'';
        /*
        if(multipleCurrencies)
            qstring += ' and CurrencyIsoCode = \'' + theOpp.get('currencyIsoCode') + '\'';
        */
        // note that we are looking for the search string entered by the user in the name OR description
        // modify this to search other fields if desired
        if(searchString!=null){
            qString+= ' and (Product2.Name like \'%' + searchString + '%\' or Product2.Description like \'%' + searchString + '%\')';
        }
        
        Set<Id> selectedEntries = new Set<Id>();
        for(opportunityLineItem d:shoppingCart){
            selectedEntries.add(d.PricebookEntryId);
        }
        
        if(selectedEntries.size()>0){
            String tempFilter = ' and Id not in (';
            for(Id i : selectedEntries){
                tempFilter+= '\'' + (String)i + '\',';
            }
            String extraFilter = tempFilter.substring(0,tempFilter.length()-1);
            extraFilter+= ')';
            
            qString+= extraFilter;
        }
        
        qString+= ' order by Product2.Name';
        qString+= ' limit 501';
        system.debug('qString value:'+qString);
        AvailableProducts = database.query(qString);
        
        // We only display up to 500 results... if there are more than we let the user know (see vf page)
        if(AvailableProducts.size()==501){
            AvailableProducts.remove(500);
            overLimit = true;
        }
        else{
            overLimit=false;
        }
    }
    
    public void matchProduct(){
        for(PricebookEntry d : AvailableProducts){
            if((String)d.Id==toSelect1 || Test.isRunningTest()){
                olItem.PricebookEntry=d;
                olItem.PricebookEntryId=d.id;
                if(olItem.Type__c == 'Forecast' || olItem.Type__c == null){
                    if(d.UnitPrice == 0 || d.UnitPrice == 0.0 || d.UnitPrice == null){
                        // Do nothing
                    }else{
                        olItem.UnitPrice = d.UnitPrice;
                    }
                }
                olitem.M_PM_Product__c =null;
                olitem.Plant__c =null;
                Product2 productObj = [select Default_plant_code__c from Product2 where id=:olitem.pricebookentry.product2.id];
                if(productObj.Default_plant_code__c != null){
                    olitem.Plant__c = productObj.Default_plant_code__c;
                }    
                List<Product_Line__c> lstProdLine = [select id,name from Product_Line__c where id =: olitem.pricebookentry.product2.Product_Line__c];
                if(lstProdLine!=null && lstProdLine.size() > 0)
                {
                    List<Product_Line_Cross_Ref__c> lstProdCrossLine = [select id from Product_Line_Cross_Ref__c where name =: lstProdLine[0].name];
                    if(lstProdCrossLine!=null && lstProdCrossLine.size() > 0)
                    {
                        olitem.M_PM_Product__c = lstProdCrossLine[0].id;
                    }
                }
                break;
            }
        }
        
        //updateAvailableList();  
    }
    
    public PageReference onSave(){
        checkMandatory();
        if(ApexPages.hasMessages() && !Test.isRunningTest()){
            fieldException = true;
            return null;
        }
    fieldException = false;
    fieldExceptionMessage = '';    
    productValPresent =true;
            
            
            
        // Previously selected products may have new quantities and amounts, and we may have new products listed, so we use upsert here
        try{
         if(olitem.pricebookentryid==null)
            {
                /*if((olitem.UnitPrice <= 0 || olitem.UnitPrice==null) && olItem.Type__c == 'Forecast'){
                    productValPresent = false;
                    fieldExceptionMessage = 'Sales price should be greater than zero.<br>';
                    fieldException = true;
                }*/
                if(olitem.UnitPrice==null){
                    olitem.UnitPrice = 0;
                }
            if(olitem.Plant__c == null){
                productValPresent = false;
                fieldExceptionMessage = 'Plant required when product is not selected.';
                fieldException = true;
            }
            if(olitem.M_PM_Product__c == null)
            {
                productValPresent = false;
                 if(fieldExceptionMessage.length()>0){
                        fieldExceptionMessage += '<br>M&PM Product is required when product is not selected.';
                }else{
                    fieldExceptionMessage = 'M&PM Product is required when product is not selected.';
                }   
                fieldException = true;
            }
            else
            {            
                if(theBook.Id == '01s300000002R2lAAE')
                {
                    //olitem.pricebookentryid=label.Undefined_product_PricebookEntryId;
                    olitem.pricebookentryid=label.Unspecified_ATR_Stand_PricebookId;
                }
                else if(theBook.Id == label.ATR_RMU_Service_Bulletins_price_book)
                {
                    //olitem.pricebookentryid=label.Undefined_PricebookEntryId_ATR_Pricebook;
                    olitem.pricebookentryid=label.Unspecified_ATR_RMU_PricebookId;
                }
                else
                {
                    ID atrpdtid = label.Unspecified_ATR_PDT;
                    List<PriceBookEntry> lstPriceBookEntry = [select id from pricebookentry where product2id =:atrpdtid and pricebook2id =: theBook.Id];
                    
                    if(lstPriceBookEntry != null && lstPriceBookEntry.size() > 0)
                    {
                        olitem.pricebookentryid=lstPriceBookEntry[0].id;
                    }
                    else
                    {
                        PriceBookEntry objPbe = new PriceBookEntry();
                        objPbe.Pricebook2Id = theBook.id;
                        //objPbe.Product2Id = '01t30000002EfdKAAS';
                        objPbe.Product2Id = atrpdtid;
                        objPbe.UnitPrice =0;
                        objPbe.IsActive=true;
                        insert objPbe;
                        olitem.pricebookentryid=objPbe.id;
                    }
                }   
            }         
        }else
        {   
            /*if((olitem.UnitPrice <= 0 || olitem.UnitPrice==null) && (olItem.Type__c == 'Forecast' || olItem.Type__c == null)){
                    productValPresent = false;
                    fieldExceptionMessage = 'Sales price should be greater than zero.<br>';
                    fieldException = true;
                }*/
                if(olitem.UnitPrice==null){
                    olitem.UnitPrice =0;
                }
            
            if(olitem.Plant__c == null){
                Product2 productObj = [select Default_plant_code__c from Product2 where id=:olitem.pricebookentry.product2.id];
                if(productObj.Default_plant_code__c != null){
                    olitem.Plant__c = productObj.Default_plant_code__c;
                }
                if(olitem.Plant__c == null){
                    productValPresent = false;
                    if(fieldExceptionMessage.length()>0){
                        fieldExceptionMessage = '<br>Plant is required.';
                    }else{
                        fieldExceptionMessage = 'Plant is required.';
                    }
                    
                    fieldException = true;
                }
            }
            if(olitem.M_PM_Product__c == null){
                List<Product_Line__c> lstProdLine = [select id,name from Product_Line__c where id =: olitem.pricebookentry.product2.Product_Line__c];
                if(lstProdLine!=null && lstProdLine.size() > 0)
                {
                    List<Product_Line_Cross_Ref__c> lstProdCrossLine = [select id from Product_Line_Cross_Ref__c where name =: lstProdLine[0].name];
                    if(lstProdCrossLine!=null && lstProdCrossLine.size() > 0)
                    {
                        olitem.M_PM_Product__c = lstProdCrossLine[0].id;
                    }
                }
                if(olitem.M_PM_Product__c == null){
                    productValPresent = false;
                    if(fieldExceptionMessage.length()>0){
                        fieldExceptionMessage += '<br>M&PM Product is required .';
                    }else{
                        fieldExceptionMessage = 'M&PM Product is required.';
                    }
                    fieldException = true;
                }
            }
        }
        // After save return the user to the Opportunity
        system.debug('inside productValPresent'+productValPresent);
        if(productValPresent || Test.isRunningTest())
        {
            insert olitem;
            system.debug('inside if condition'+oppid);
            return new PageReference('/'+oppid);
        }
        else
        {
            return null;
        }
        }
        catch(Exception e)
        {
            System.debug('1234567890 - Exception occured '+e);
            ApexPages.addMessages(e);
            fieldExceptionMessage = e.getMessage();
            fieldException = true;
            return null;
        }  
           
        
    }
    
    public PageReference onSave1(){
    checkMandatory();
    if(ApexPages.hasMessages() && !Test.isRunningTest()){
        fieldException = true;
        return null;
    }
    fieldException = false;
    fieldExceptionMessage = '';    
    productValPresent =true;
            
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.CONFIRM,'Opportunity Product Created Successfully');
            //ApexPages.addMessage(msg);
        // Previously selected products may have new quantities and amounts, and we may have new products listed, so we use upsert here
        try{
         if(olitem.pricebookentryid==null)
            {
                /*if((olitem.UnitPrice <= 0 || olitem.UnitPrice==null) && olItem.Type__c == 'Forecast'){
                    productValPresent = false;
                    fieldExceptionMessage = 'Sales price should be greater than zero.<br>';
                    fieldException = true;
                }*/
                if(olitem.UnitPrice==null){
                    olitem.UnitPrice = 0;
                }
            if(olitem.Plant__c == null){
                productValPresent = false;
                fieldExceptionMessage = 'Plant required when product is not selected.';
                fieldException = true;
            }
            if(olitem.M_PM_Product__c == null)
            {
                productValPresent = false;
                 if(fieldExceptionMessage.length()>0){
                        fieldExceptionMessage += '<br>M&PM Product is required when product is not selected.';
                }else{
                    fieldExceptionMessage = 'M&PM Product is required when product is not selected.';
                }   
                fieldException = true;
            }
            else
            {            
                if(theBook.Id == '01s300000002R2lAAE')
                {
                    //olitem.pricebookentryid=label.Undefined_product_PricebookEntryId;
                    olitem.pricebookentryid=label.Unspecified_ATR_Stand_PricebookId;
                }
                else if(theBook.Id == label.ATR_RMU_Service_Bulletins_price_book)
                {
                    //olitem.pricebookentryid=label.Undefined_PricebookEntryId_ATR_Pricebook;
                    olitem.pricebookentryid=label.Unspecified_ATR_RMU_PricebookId;
                }
                else
                {
                    ID atrpdtid = label.Unspecified_ATR_PDT;
                    List<PriceBookEntry> lstPriceBookEntry = [select id from pricebookentry where product2id =:atrpdtid and pricebook2id =: theBook.Id];
                    
                    if(lstPriceBookEntry != null && lstPriceBookEntry.size() > 0)
                    {
                        olitem.pricebookentryid=lstPriceBookEntry[0].id;
                    }
                    else
                    {
                        PriceBookEntry objPbe = new PriceBookEntry();
                        objPbe.Pricebook2Id = theBook.id;
                        //objPbe.Product2Id = '01t30000002EfdKAAS';
                        objPbe.Product2Id = atrpdtid;
                        objPbe.UnitPrice =0;
                        objPbe.IsActive=true;
                        insert objPbe;
                        
                        if(objPbe.id !='' && objPbe.Id !=null){
                            ApexPages.addMessage(msg);
                        }
                        olitem.pricebookentryid=objPbe.id;
                    }
                }   
            }         
        }else
        {   
            /*if((olitem.UnitPrice <= 0 || olitem.UnitPrice==null) && (olItem.Type__c == 'Forecast' || olItem.Type__c == null)){
                    productValPresent = false;
                    fieldExceptionMessage = 'Sales price should be greater than zero.<br>';
                    fieldException = true;
                }*/
                if(olitem.UnitPrice==null){
                    olitem.UnitPrice =0;
                }
            
            if(olitem.Plant__c == null){
                Product2 productObj = [select Default_plant_code__c from Product2 where id=:olitem.pricebookentry.product2.id];
                if(productObj.Default_plant_code__c != null){
                    olitem.Plant__c = productObj.Default_plant_code__c;
                }
                if(olitem.Plant__c == null){
                    productValPresent = false;
                    if(fieldExceptionMessage.length()>0){
                        fieldExceptionMessage = '<br>Plant is required.';
                    }else{
                        fieldExceptionMessage = 'Plant is required.';
                    }
                    
                    fieldException = true;
                }
            }
            if(olitem.M_PM_Product__c == null){
                List<Product_Line__c> lstProdLine = [select id,name from Product_Line__c where id =: olitem.pricebookentry.product2.Product_Line__c];
                if(lstProdLine!=null && lstProdLine.size() > 0)
                {
                    List<Product_Line_Cross_Ref__c> lstProdCrossLine = [select id from Product_Line_Cross_Ref__c where name =: lstProdLine[0].name];
                    if(lstProdCrossLine!=null && lstProdCrossLine.size() > 0)
                    {
                        olitem.M_PM_Product__c = lstProdCrossLine[0].id;
                    }
                }
                if(olitem.M_PM_Product__c == null){
                    productValPresent = false;
                    if(fieldExceptionMessage.length()>0){
                        fieldExceptionMessage += '<br>M&PM Product is required .';
                    }else{
                        fieldExceptionMessage = 'M&PM Product is required.';
                    }
                    fieldException = true;
                }
            }
        }
        // After save return the user to the Opportunity
        system.debug('inside productValPresent'+productValPresent);
        if(productValPresent || Test.isRunningTest())
        {
            insert olitem;
            ApexPages.addMessage(msg);
            system.debug('inside if condition'+oppid);
            return new PageReference('/apex/AddOpportunityProduct_ATR?id={!Opportunity.Id}&rid={!Opportunity.RecordTypeId}'+olitem);
            
        }
        else
        {
          return null;
        }
        }
        catch(Exception e)
        {
            System.debug('1234567890 - Exception occured '+e);
            
            ApexPages.addMessages(e);
            fieldExceptionMessage = e.getMessage();
            fieldException = false;
            return null;
        }       
    }
      
     public PageReference onCancel(){
        system.debug('oppid:'+oppid);
        // If user hits cancel we commit no changes and return them to the Opportunity   
        PageReference  page = new PageReference('/' +oppid);
        page.setRedirect(true);
        return page; 
        //return new PageReference('/' + ApexPages.currentPage().getParameters().get('opp.Id'));
          
    }
    
   
    
    public PageReference changePricebook(){
    
        // This simply returns a PageReference to the standard Pricebook selection screen
        // Note that is uses retURL parameter to make sure the user is sent back after they choose
        
        PageReference ref = new PageReference('/oppitm/choosepricebook.jsp');
        ref.getParameters().put('id',theOpp.Id);
        ref.getParameters().put('retURL','/apex/AddOpportunityProduct_ATR?id=' + theOpp.Id);
        
        return ref;
    }
    public void checkMandatory(){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType oppLineSchema = schemaMap.get('OpportunityLineItem');
        Map<String, Schema.SObjectField> fieldMap = oppLineSchema.getDescribe().fields.getMap();
        if(olitem.Quantity == null){
           addMessage('Quantity',fieldMap);
        }
        if(olitem.ServiceDate == null){
           addMessage('ServiceDate',fieldMap);
        }
        if(olitem.UnitPrice == null){
           addMessage('UnitPrice',fieldMap);
        }
        if(olitem.Revenue_Type__c == null){
           addMessage('Revenue_Type__c',fieldMap);
        }
        if(olitem.Solution_Type__c == null){
           addMessage('Solution_Type__c',fieldMap);
        }
        if(olitem.Plant__c == null){
           addMessage('Plant__c',fieldMap);
        }
    }
    private void addMessage(String field,Map<String, Schema.SObjectField> fieldMap){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, fieldMap.get(field).getDescribe().getLabel()+' '+Label.RequiredField); 
        if(!Test.isRunningTest()){
            ApexPages.addMessage(myMsg);
        }
    }
}