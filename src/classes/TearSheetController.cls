public with sharing class TearSheetController {
    
    public String getSheetHeader(){
        return stringConstants.get('customerdatasheet');
    }
    
    
    public  List<Id>            accountIds                                  {get;set;}
    private List<String>        listAircraftId                  =           new List<string>();
    public  Map<String,List<String>> cityNameAccountNameIndex               {set; get;}
    public  Map<String,String>  actSummary        {set;get;}
    public  String              errorLog          {get;set;}
    public  List<List<Id>>      accountIdMap      {get;set;}
    public  String              regionName        {get;set;}
    public  String              countryName       {get;set;}
    public  Integer             countTotal        {get;set;}
    public  String              displayIndexLabel {get;set;} 
    public  Integer             currentCount {get;set;}
    public  Integer             indexSlotRange {get;set;}
    public  String              customAccountId {get;set;}
    public  Integer             startIndex {get;set;}
    public  Map<String,String>  stringConstants{get;set;}
    
    //Added by Fanita 
    public string excelFileName{get;set;}
    
    String  range;
    List<Integer> rangeIndex = null;
    List<String> opportunityRecordTypes = null;
    List<String> excludeAccountFromContract = null;
    String regionColName = null;
    public String regionType {get;set;}
    
    //Added for the test code coverage
    public TearSheetController(String s,String i,String r,String c){
        
        this.regionName         = s;
        this.regionColName      = 'Report_State_Code__c';
        this.regionType         = 'state';
        
        if(this.regionName == null && c!= null){
            this.regionName         = c;
            this.regionColName      = 'Report_Country_Name__c';
            this.regionType         = 'country';
        }
                
        this.customAccountId    = i;
        range = r;
        stringConstants = convertJsonIntoMap(Label.TearSheet_Strings);
        opportunityRecordTypes      = stringConstants.get('oppRecordType').split(';');
        excludeAccountFromContract  = stringConstants.get('hw_defult_act').split(';');
        indexSlotRange  = Integer.valueOf(stringConstants.get('perPageSlotRange'));
        initProcess();
        fix1000ListIssueonVF();
    }


    //Start point for the execution
    public TearSheetController(ApexPages.standardController actRecord){
        
        // PDF will be generated for two sceniros 1) for All given state accounts 2) Specific account
        
        regionName      = ApexPages.currentPage().getParameters().get('state');
        regionColName   = 'Report_State_Code__c';
        regionType      = 'state';
        
        countryName     = ApexPages.currentPage().getParameters().get('country');
        customAccountId = ApexPages.currentPage().getParameters().get('id');
        range           = ApexPages.currentPage().getParameters().get('range');
        
        if(regionName=='')  regionName = null;
        if(countryName=='') countryName = null;
        
        
        if(regionName == null && countryName!= null){
            regionName      = countryName;
            regionColName   = 'Report_Country_Name__c';
            regionType      = 'country';
        }
        
        stringConstants = convertJsonIntoMap(Label.TearSheet_Strings);
        opportunityRecordTypes      = stringConstants.get('oppRecordType').split(';');
        excludeAccountFromContract  = stringConstants.get('hw_defult_act').split(';');
        indexSlotRange  = Integer.valueOf(stringConstants.get('perPageSlotRange'));
        
        initProcess();
        fix1000ListIssueonVF();
        
        //Following code added to open PDF as attached with given name
        if(regionName != null){
            Apexpages.currentPage().getHeaders().put('content-disposition', 
                            'attachment; filename='+regionName+'_Customer_Data_Sheet_'+displayIndexLabel.replace(' ','_')+'.pdf'
                        );
             excelFileName = regionName+'_Customer_Data_Sheet_'+displayIndexLabel.replace(' ','_');
        }
        else{
            Apexpages.currentPage().getHeaders().put('content-disposition', 
                            'attachment; filename='+((Account)allPulledData.get(customAccountId).get('Account').get(0)).Name.replace(' ','_')+'_Customer_Data_Sheet_'+'.pdf'
                        );
            excelFileName = ((Account)allPulledData.get(customAccountId).get('Account').get(0)).Name.replace(' ','_')+'_Customer_Data_Sheet_';           
        }       
        
        
        /*Added by fanita
        if(regionName != null){
            excelFileName = regionName+'_Customer_Data_Sheet_'+displayIndexLabel.replace(' ','_');
        }
        else{
            excelFileName = ((Account)allPulledData.get(customAccountId).get('Account').get(0)).Name.replace(' ','_')+'_Customer_Data_Sheet_';
        }*/

    }
    
    void initProcess(){
                
                // Prepare list of accounts need to be diaplay on current page
                // a) for single account or for accounts with in a state
                // b) data will be genrated for the given range, if no range specified then default will be 1 to configured range
                // 
                
                    
                initlizeVaribale();
                
                    // for single account
                    if(customAccountId!= null && customAccountId != ''){
                        accountIds.add(customAccountId);
                    }
                    // for a given state
                    else if(regionName!= null){
                            //set records range
                            // following menthod populated the rangeIndex list variable 
                            getRangeIndex();
                            
                            String queryAccountIds =                   
                                                                'Select '; 
                            queryAccountIds = queryAccountIds + 'Id '; 
                            queryAccountIds = queryAccountIds + 'From '; 
                            queryAccountIds = queryAccountIds + 'Account '; 
                            queryAccountIds = queryAccountIds + 'Where  ';
                            queryAccountIds = queryAccountIds + '(not Name like \''+stringConstants.get('Various')+'\') ';
                            queryAccountIds = queryAccountIds + 'and (not Name like \''+stringConstants.get('Honeywell')+'\') ';
                            
                            queryAccountIds = queryAccountIds + 'and '+regionColName+'          = \''+regionName+'\'  ';
                            
                            queryAccountIds = queryAccountIds + 'and Strategic_Business_Unit__c     = \''+stringConstants.get('bga') +'\' ';
                            queryAccountIds = queryAccountIds + 'Order By Report_City_Name__c,Name ';
                                                    
                            
                            List<Account>   actList =  Database.query(queryAccountIds);                     
                                
                                countTotal = actList.size();
                                // if no range provided  and total records more than slot then start = 1 and End = configured slot range
                                if( rangeIndex==null && countTotal > indexSlotRange ){
                                    rangeIndex = new List<Integer>();
                                    rangeIndex.add(1);
                                    rangeIndex.add(indexSlotRange);
                                }
                                // if only start range is provided the End = configured range
                                else if ( rangeIndex != null && rangeIndex.size() == 1){
                                    rangeIndex.add(rangeIndex.get(0)+indexSlotRange-1);
                                }
                                                    
                                Integer cnt = 1;
                                Boolean doAction = false;
                                
                                for(Account act : actList){
                                            if(rangeIndex == null){
                                                    doAction = true;
                                            }
                                            else if(cnt >= rangeIndex[0] && cnt <= rangeIndex[1]){
                                                    doAction = true;
                                            }
                                            else{
                                                    doAction = false;
                                            }
                                            
                                            if(doAction){
                                                accountIds.add(act.Id);
                                            }
                                            cnt++;
                                            doAction = false;
                                }
                                
                                // Prepare page top display current listing label 
                                if(rangeIndex == null){
                                    displayIndexLabel = stringConstants.get('all');
                                    startIndex= 1;
                                }
                                else if(rangeIndex.size() == 1){
                                    displayIndexLabel = rangeIndex[0]+ ' to ' + countTotal;
                                    currentCount = countTotal;
                                    startIndex = rangeIndex[0];
                                }
                                else if(rangeIndex.size() == 2){
                                    currentCount = rangeIndex[1];
                                    displayIndexLabel = rangeIndex[0] + ' to ' + (rangeIndex[1] > countTotal ?  countTotal :  rangeIndex[1]);
                                    startIndex = rangeIndex[0];
                                }
                            
                    }
                    
                    
                    //fecth all details  
                    getAccountDetails();
                    populateContactDetails();
                    populateAircraftsDetails();
                    populateOpportunityDetails();
                    populateContractDetails();
                    
                    //Prepare summary to display with City&Account Name index 
                    for(String act : accountIds){
                        String      
                                    summary = '( Opportunty : '     + allPulledData.get(act).get('Opportunity').size()  + ' )';
                        summary =   summary + '( Contract : '       + allPulledData.get(act).get('Contract').size()     + ' )';
                        summary =   summary + '( Aircraft : '       + allPulledData.get(act).get('Aircraft').size()     + ' )';
                        summary =   summary + '( Contacts : '       + (allPulledData.get(act).get('PrimaryContact').size()
                                                                    + allPulledData.get(act).get('OtherContact').size())    + ' )';
                        
                        Account actName = (Account)allPulledData.get(act).get('Account')[0];
                        actSummary.put(actName.Name,summary);
                        
                    }
                    
                    
                
    }

    /*
    * Prepare Account details
    */
        
    void getAccountDetails(){
        
                    List<Account>   actDetails = 
                                    [
                                        select 
                                            Id,Name,website,Report_Address_Line_1__c,
                                            Report_Address_Line_2__c,Report_Address_Line_3__c,
                                            Report_City_Name__c,Report_Country_Name__c,
                                            Report_Postal_Code__c,Report_State_Code__c,
                                            OwnerId,Owner.Name,
                                            Type,Strategic_Business_Unit__c,CBT_Team__c,
                                            Customer_Class__c,Phone,Fax 
                                        From Account 
                                        where id in :accountIds
                                        Order By Name
                                    ];
                    
                    for(Account actRec : actDetails){
                                actRec.Type                         = assignHypenToBlank(actRec.Type);
                                actRec.Customer_Class__c            = assignHypenToBlank(actRec.Customer_Class__c);
                                actRec.Strategic_Business_Unit__c   = assignHypenToBlank(actRec.Strategic_Business_Unit__c);
                                actRec.CBT_Team__c                  = assignHypenToBlank(actRec.CBT_Team__c);               
                                actRec.Phone                        = assignHypenToBlank(actRec.Phone);
                                actRec.Fax                          = assignHypenToBlank(actRec.Fax);
                                actRec.Description                  = getWebsiteShortName(actRec.Website);
                                
                                actRec.Report_City_Name__c          = actRec.Report_City_Name__c.toLowerCase().capitalize();
                                
                                
                                Map<String,List<sObject>> recordSobject = new Map<String,List<sObject>>();
                                List<sObject> listRecord = new List<sObject>();
                                
                                listRecord.add(actRec);
                                recordSobject.put('Account',listRecord);
                                
                                List<Contact>               listPContact = new List<Contact>();
                                List<Opportunity>           listOpportunities = new List<Opportunity>();
                                List<Fleet_Asset_Detail__c> listFleet = new List<Fleet_Asset_Detail__c>();
                                List<Contact>               listOtherContacts = new List<Contact>();
                                List<Maintenance_Events__c> listMaintEvents = new List<Maintenance_Events__c>();
                                List<Contract>              listContract = new List<Contract>();
                                
                                recordSobject.put('PrimaryContact',listPContact);
                                recordSobject.put('OtherContact',listOtherContacts);
                                recordSobject.put('Opportunity',listOpportunities);
                                recordSobject.put('Aircraft',listFleet);
                                recordSobject.put('Contract',listContract);
                                
                                     
                                allPulledData.put(actRec.Id,recordSobject);
                                
                                if(!cityNameAccountNameIndex.containsKey(actRec.Report_City_Name__c)){
                                    List<String> accountNameList = new List<String>();
                                    accountNameList.add(actRec.Name);
                                    cityNameAccountNameIndex.put(actRec.Report_City_Name__c,accountNameList);
                                }
                                else{
                                    cityNameAccountNameIndex.get(actRec.Report_City_Name__c).add(actRec.Name);
                                }
                                
                                actSummary.put(actRec.Report_City_Name__c+actRec.Name,'');
                    }
                                    
    }       

    /*
    * Prepare contact details
    */
                
                
    void populateContactDetails(){
        
        List<Contact> contactRecords = 
                    [   select  
                                Id,Job_Title__c,FirstName,LastName,Primary_Contact__c,Phone_1__c,Primary_Email_Address__c,Phone_5__c,
                                Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,City_Name__c,State_Code__c,Country_Name__c,
                                Postal_Code__c,AccountId
                        from    Contact 
                        where   AccountId in :accountIds 
                        and     Contact_Status__c = 'Active'
                        Order By Job_Title__c asc nulls last ,FirstName,LastName
                    ];
                    
                                            for(Contact rec : contactRecords){
                                        
                                                    rec.Address_Line_1__c= getFormatedContactAddress(rec);
                                                    
                                                    rec.Job_Title__c                = assignHypenToBlank(rec.Job_Title__c);
                                                    rec.Phone_1__c                  = assignHypenToBlank(rec.Phone_1__c);
                                                    rec.Phone_5__c                  = assignHypenToBlank(rec.Phone_5__c);
                                                    rec.Primary_Email_Address__c    = assignHypenToBlank(rec.Primary_Email_Address__c);
                                                    
                                                    // Keep primary contact and other contacts in seprate lists
                                                    
                                                    if(rec.Primary_Contact__c == true){
                                                        allPulledData.get(rec.AccountId).get('PrimaryContact').add(rec);
                                                    }
                                                    else{
                                                        if(allPulledData.get(rec.AccountId).get('OtherContact').size() < Integer.valueOf(stringConstants.get('displayContacts' )))
                                                        allPulledData.get(rec.AccountId).get('OtherContact').add(rec);
                                                    }
                                                    
                                        }
                                        
    }
    
    /*
    * Prepare aircraft and maintanance details
    */
    
    void populateAircraftsDetails(){
        
                List<Fleet_Asset_Detail__c> listAllAircrafts = [
                                                                    select 
                                                                    Id,Name,
                                                                    Aircraft_Base__r.Name,
                                                                    Base_ICAO__c,
                                                                    Base_City__c,State__c,Cntry__c,
                                                                    Entry_into_service_EIS__c,
                                                                    Bizview_Status_Desc__c,
                                                                    Account__c,
                                                                    (select Name,Event_Date__c,Event_Date_2__c from Maintenance_Events__r Order by Name)
                                                                    from
                                                                    Fleet_Asset_Detail__c
                                                                    where Account__c in :accountIds
                                    ];
                                    
                
                    for (Fleet_Asset_Detail__c reco : listAllAircrafts){
                            reco.Name = reco.Name.replace('T=','<br>T=');
                            allPulledData.get(reco.Account__c).get('Aircraft').add(reco);
                            
                    }
                    
                    
                    
        
    }
    /*
    * Prepare contract details
    */
    
    void populateContractDetails(){
        
        Map<String,List<Contract>> cntContrcts = new Map<string,List<Contract>>();
        
        List<Contract> listContract = [     
                                                    Select
                                                            Name,Status,Type__c,StartDate,
                                                            CONTRACT_BEGIN_DT__c,EndDate,
                                                            AccountID,Account__c,
                                                            Aircraft__c,Aircraft__r.Name
                                                    From    Contract
                                                    where   AccountID in :accountIds
                                                    and     Account.name not in :excludeAccountFromContract
                                                            Order By AccountID asc,EndDate desc 
                                      ];    
                                      
                                      // Display last N contacts for each Type, N is configured in Json ( label)
                                      for(Contract reco : listContract){
                                        
                                        if(reco.Type__c != null)
                                        reco.Type__c = reco.Type__c.toUpperCase();
                                        else
                                        reco.Type__c =  '-';    
                                        
                                        
                                        String key = reco.Type__c+''+reco.AccountID ;
                                          if(!cntContrcts.containsKey(key)){
                                                cntContrcts.put(key,new List<Contract>());
                                                cntContrcts.get(key).add(reco);
                                            }
                                            else if(cntContrcts.get(key).size() < Integer.valueOf(stringConstants.get('displayNumberOfLastContractRecords'))){
                                                    cntContrcts.get(key).add(reco);
                                            }
                                      }
                                      
                                      //Display in sorted order
                                      List<String> sorttedKeyNames =  new List<String>();
                                      sorttedKeyNames.addAll(cntContrcts.keySet());
                                      sorttedKeyNames.sort();
                                      for   (String key : sorttedKeyNames){
                                            for(Contract reco : cntContrcts.get(key)){
                                                    allPulledData.get(reco.AccountID).get('Contract').add(reco);    
                                            }
                                      }
                                      
                                      
    }
    
    /*
    * Prepare opportunity details
    */
    void populateOpportunityDetails(){
        
                List<Opportunity> recOpp = [
                                                select 
                                                Id,Name,StageName,Amount,
                                                CloseDate,Aircraft_Ref__c,Aircraft_Ref__r.Name,
                                                OwnerId,Owner.Name,ForecastCategory ,Probability,
                                                Reason_for_Closed_Cancelled__c,
                                                Reason_for_Closed_Lost__c,
                                                Reason_for_CLOSED_LOST_COMPETITION_1__c,
                                                Win_Loss_Reason_Text__c,AccountId
                                                from Opportunity
                                                where AccountId in  :accountIds
                                                and recordTypeId in :opportunityRecordTypes
                                                Order By Probability asc,CloseDate desc
                                            ];  
                                    /*
                                    * to display cancelled opportunity below open/won opportunities, used tmpRecords list variable, 
                                    */
                                            
                                    List<Opportunity> tmpRecords = new List<opportunity>();
                                                            
                                    for (Opportunity reco : recOpp){
                                        if(reco.Amount == null){
                                            reco.Amount = 0.0;
                                        }
                                        if(reco.Probability > 0){
                                            allPulledData.get(reco.AccountId).get('Opportunity').add(reco);
                                        }
                                        else{
                                            tmpRecords.add(reco);
                                        }
                                    }
                                    
                                    for (Opportunity reco : tmpRecords){
                                        allPulledData.get(reco.AccountId).get('Opportunity').add(reco);
                                    }
                                    
                                    tmpRecords = null;
    }
    
    /*
    * Prepare contact address
    */
                    
    String getFormatedContactAddress(Contact rec){
                    String retAddress = '';
                                if(rec.Address_Line_1__c!=null)
                                retAddress = rec.Address_Line_1__c                      + '<br>'    ;
                                if(rec.Address_Line_2__c!=null)
                                retAddress = retAddress + ' ' + rec.Address_Line_2__c   + '<br>'    ;
                                if(rec.Address_Line_3__c!=null)
                                retAddress = retAddress + ' ' + rec.Address_Line_3__c               ;
                                if(rec.City_Name__c!=null)
                                retAddress = retAddress + ' ' + rec.City_Name__c        + '<br>'    ;
                                if(rec.State_Code__c!=null)
                                retAddress = retAddress + ' ' + rec.State_Code__c       +','        ;
                                if(rec.Country_Name__c!=null)
                                retAddress = retAddress + ' ' + rec.Country_Name__c     + ''        ;
                                if(rec.Postal_Code__c!=null)
                                retAddress = retAddress + ', ' + rec.Postal_Code__c                 ;
                                
                                if(retAddress.replace('<br>', '').replace('null', '').replace(' ','').length() == 0){
                                    return '-';
                                }
                    
                    return retAddress;
    }

    /*
    * Display short URL name on page
    */
    
    public String getWebsiteShortName(String webSiteReturnName){
        
        if(webSiteReturnName == null){
            return '';
        }
        
        webSiteReturnName   =   webSiteReturnName.replace('http','');
        webSiteReturnName   =   webSiteReturnName.replace('www.','');
        webSiteReturnName   =   webSiteReturnName.replace(':','');
        webSiteReturnName   =   webSiteReturnName.replace('//','');
        
        if(webSiteReturnName.length() > 30){
            webSiteReturnName = webSiteReturnName.subString(0,30)+'....';
        }
        
        return webSiteReturnName;
        
    }
    
    
    public DateTime getCurrentTime(){
        return System.now();
    }
    
    String assignHypenToBlank(String value){
        if(value == null){
            return '-';
        }
        else{
            return value;
        }
    }
    
    private void initlizeVaribale(){
        accountIds  =       new List<Id>();
        cityNameAccountNameIndex =  new Map<String,List<String>>();
        actSummary = new Map<String,String>();
        
        errorLog = '';
    }
    
    class AccountSummary{
        public AccountSummary(String aName,String aSummary){
            accountName = aName;
            accountSummary = aSummary;
        }
        String accountName;
        String accountSummary;
    }
    
    /*
    * Fix for 1000 Limit exception
    */
    
    void fix1000ListIssueonVF(){
        accountIdMap = new List<List<Id>>();
        accountIdMap.add(new List<Id>());
        Integer mapKey = 0;
        
        for(Integer i=0;i<accountIds.size();i++){
            
            if(math.mod(i, 800) == 0){
                mapKey++;
                accountIdMap.add(new List<Id>());
            }
            accountIdMap.get(mapKey).add(accountIds.get(i));
        }
    }
    

    
    public Map<Id,Map<String,List<sObject>>> allPulledData = new Map<Id,Map<String,List<sObject>>>(); 
    
    public Map<Id,Map<String,List<sObject>>> getAllPulledData(){
        return allPulledData;
    }

    /*
    * Get City List for Index
    */
        
    public List<String> getCityList(){
        List<String> lstCity = new List<String>();
        for(String city : cityNameAccountNameIndex.keySet()){
            lstCity.add(city);
        }
        lstCity.sort();
        return lstCity;
    }
    /*
    * Prepare range index values 
    */
    void getRangeIndex(){
        if(range!=null){    
                                    String[] rangeStrArr = range.split(',');
                                    try{
                                         if(rangeStrArr.size() > 0 && rangeStrArr.size() <= 2){
                                            rangeIndex = new List<Integer>();
                                            for(String i : rangeStrArr){
                                                rangeIndex.add(Integer.valueOf(i));
                                            }
                                         }
                                    }
                                    catch(Exception e){
                                        rangeIndex = null;
                                    }
                            }
    }
    /*
    * Read Json into Map ( used with label for configuration parameters) 
    */      
    Map<String,String> convertJsonIntoMap(String jsonStr){
        Map<String,String> retMap = new Map<String,String>(); 
        JSONParser parser = JSON.createParser(jsonStr);
            while (parser.nextToken() != null) {
                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME){     
                        String fiedName = parser.getText();
                        parser.nextToken();
                        String fiedValue = parser.getText();
                        retMap.put(fiedName,fiedValue);
                    }
            }
        return retMap;  
    }
    /*
    * Test coverage code
    */
    @isTest(SeeAllData=true)
    public static void testCoverage()
    {
        TearSheetController testAccountState = new TearSheetController('CA',null,'1,500',null);
        TearSheetController testAccountCountry = new TearSheetController(null,null,'1,500','India');
        TearSheetController testAccountSingleRecord = new TearSheetController
            (
                null,
                [select id from account where name='COCA-COLA CO' LIMIT 1][0].Id,
                '1,500',
                null
            );
    }    
    
}