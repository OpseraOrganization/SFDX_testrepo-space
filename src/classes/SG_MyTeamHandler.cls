/********************************************************
* @Description: Apex Class to retrieve sum of all opportunities owned by current user in Closed or Committed
* Forecast Category. 
* 
* ******************************************************/
public with Sharing Class SG_MyTeamHandler {
    
    private static final String ADJUST_API_NAME = 'Adjustment';
    private static Boolean canViewAdjustment = false ; 
    public static Map<String , CurrencyType> mapIsoToRate = new Map<String , CurrencyType>() ; 
    private static Set<Id> MY_TEAM_USERS = new Set<Id>(); 
    
    /********************************************************
* @Description: Method to retrive Opportunities owned by current user or the user's team. 
* This method calculates the sum of Opp. Amount where forecastcategory = 'Committed' or 'closed'
* for core and run rate types only. 
* ******************************************************/
    public static String getCommittedOrders(Boolean isTeamView) {
        
        Set<id> setRoles = new Set<Id>(); 
        List<Opportunity> lstOpps = new List<Opportunity>() ; 
        OrderCommittment objResult = new OrderCommittment(); 
        String usrCurIsoCode = UserInfo.getDefaultCurrency();
        String orgCurIsoCode = [SELECT IsoCode FROM CurrencyType WHERE IsCorporate = true LIMIT 1 ].IsoCode ; 
        Set<String> oppsCurCodes = new Set<String>(); 
        
      //  canViewAdjustment = hasAdjustmentAccess(); 
        SalesCoach_Utility objUtility = new SalesCoach_Utility(); 
        
        //initialize My team's set of ids
        
        if(isTeamView) {
            MY_TEAM_USERS = objUtility.getMyTeamUsers();
        }
        else{
            MY_TEAM_USERS.add(UserInfo.getUserId()); 
        }
        lstOpps = [SELECT id , Amount, CurrencyIsoCode, RecordType.Name  
                   FROM Opportunity WHERE CloseDate = THIS_FISCAL_QUARTER                   
                   LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())
                  ];
        System.debug(lstOpps+'MY_TEAM_USERS+opps==========>'+MY_TEAM_USERS);
        Map<String , Decimal> mapTypeToAmountInUsr = new Map<String , Decimal>(); 
       // Map<Integer , Decimal> mapPeriodToAmountInUsr = initInfo() ; 
        
        Map<String , Decimal> mapTypeToAmountInOrg = new Map<String , Decimal>(); 
      //  Map<Integer , Decimal> mapPeriodToAmountInOrg = initInfo() ; 
        
        
        Integer periodCloseDate = 0 ; 
        
        for(Opportunity objOpp : lstOpps) {
            if(objOpp.CurrencyIsoCode.equalsIgnoreCase(usrCurIsoCode) || 
               objOpp.CurrencyIsoCode.equalsIgnoreCase(orgCurIsoCode))
            { //if opportunity currency does not match to either user locale or org default , collect all iso codes
                oppsCurCodes.add(objOpp.CurrencyIsoCode) ; 
            }
        }
        oppsCurCodes.add(usrCurIsoCode) ; //add user currency code
        oppsCurCodes.add(orgCurIsoCode) ; //add org currency code
        for(CurrencyType objCT : [SELECT ConversionRate , DecimalPlaces , IsoCode 
                                  FROM CurrencyType LIMIT 10000])
        {
            mapIsoToRate.put(objCT.IsoCode.toUpperCase() , objCT) ; 
        }
        Decimal oppAmountInUsr = 0 ; 
        Decimal oppAmountInOrg = 0 ; 
        for(Opportunity objOpp : lstOpps)
        {
            
      //      periodCloseDate = objOpp.Fiscal_Period_APEX2__c != null ? Integer.ValueOf(objOpp.Fiscal_Period_APEX2__c) : null ;
            
            if(objOpp.CurrencyIsoCode.equalsIgnoreCase(usrCurIsoCode)) {
                oppAmountInUsr = objOpp.Amount ; //set same amount as User locale
            }
            else {//convert to user locale
              //  oppAmountInUsr = convertAmount(objOpp.CurrencyIsoCode , usrCurIsoCode , objOpp.Amount) ; 
            }
            
            if(objOpp.CurrencyIsoCode.equalsIgnoreCase(orgCurIsoCode)) {
                oppAmountInOrg = objOpp.Amount ; //set same amount as User locale
            }
            else {//convert to user locale
             //   oppAmountInOrg = convertAmount(objOpp.CurrencyIsoCode , orgCurIsoCode , objOpp.Amount) ; 
            }
            
            if(objOpp.Amount != null) {
                
                mapTypeToAmountInUsr = addOppAmount(objOpp.RecordType.Name, mapTypeToAmountInUsr, oppAmountInUsr) ; 
                mapTypeToAmountInOrg = addOppAmount(objOpp.RecordType.Name, mapTypeToAmountInOrg, oppAmountInOrg) ; 
           
            }
        }
        
        objResult.userCurrency = usrCurIsoCode ; //get the default user currency. 
        objResult.orgCurrency = orgCurIsoCode ; 
        objResult.canViewAdjustRecType = canViewAdjustment ; 
        objResult.fiscalData = getTotalAmount(mapTypeToAmountInUsr , usrCurIsoCode) ; 
        objResult.fiscalDataInOrgCur = getTotalAmount(mapTypeToAmountInOrg , orgCurIsoCode) ;
        
        System.debug('objResult===='+objResult);
        
        return JSON.serialize(objResult) ; 
    }
    
   
    
    /********************************************************
* @Description: Method to compute total amount
*    
* ******************************************************/
    private static FiscalQuarterData getTotalAmount(Map<String,Decimal> inputMap , String isoCode ) {
        FiscalQuarterData objResult = new FiscalQuarterData(); 
        Decimal amountRunRate = 0.00 ;
        Decimal amountCore = 0.00 ; 
        Decimal amountAdjusted = 0.00 ; 
        
        // Changes Added by Suman for including PO Schedule
        Decimal amountpoSchedule = 0.00 ; 
         if(inputMap.containsKey('PO Schedule')){
            amountpoSchedule = inputMap.get('PO Schedule'); amountpoSchedule = amountpoSchedule.setScale(0, System.roundingMode.HALF_UP);
            
        }
        objResult.amountpoSchedule = isoCode + ' '+ amountpoSchedule.format() ; 
        //Ends here
        if(inputMap.containsKey('Core')){
            amountCore = inputMap.get('Core'); amountCore = amountCore.setScale(0, System.roundingMode.HALF_UP);
        }
        amountCore = amountCore+amountpoSchedule; // Changes Added by Suman for Adding PO Schedule to Core
        objResult.amountCore = isoCode +' '+ amountCore.format() ; 
        
        if(inputMap.containsKey('Run Rate')){
            amountRunRate = inputMap.get('Run Rate'); amountRunRate = amountRunRate.setScale(0, System.roundingMode.HALF_UP);
            
        }
        objResult.amountRunRate = isoCode + ' '+ amountRunRate.format() ; 
        
        if(inputMap.containsKey('Adjustment')){
            amountAdjusted = inputMap.get('Adjustment'); amountAdjusted = amountAdjusted.setScale(0, System.roundingMode.HALF_UP); 
        }
        if(!canViewAdjustment && amountAdjusted == 0){
            objResult.canViewAdjustment = false ;
        }
        objResult.amountAdjusted = isoCode + ' '+ amountAdjusted.format() ; 
        
        Decimal amountTotal = amountCore + amountRunRate + amountAdjusted; 
        amountTotal = amountTotal.setScale(0, System.roundingMode.HALF_UP); 
        objResult.amountTotal = isoCode +' '+ amountTotal.format()  ;
        
        return objResult ; 
    } 
    /********************************************************
* @Description: Method to add Opportunity amount for each of opportunity. 
* 
* ******************************************************/
    private static Map<String , Decimal> addOppAmount(String inputKey , Map<String , Decimal> inputMap , Decimal currentAmount) {
        Decimal amountvalue = 0 ; 
        if(currentAmount != null) {
            if(inputMap.containsKey(inputKey)) {
                amountvalue = inputMap.get(inputKey); amountvalue += currentAmount ; 
            }
            else {
                amountvalue = 0 ; 
                amountvalue += currentAmount ;
            }    
        }
        
        inputMap.put(inputKey , amountvalue) ;
        
        return inputMap ; 
    }
    
   
    
  
    
    
    /********************************************************
* @Description: Method to retrieve all sub-roles for a given parent role ids.
* This method will be invoked when user selects My Team View
* ******************************************************/
    private static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {      
        Set<ID> currentRoleIds = new Set<ID>();
        // get all of the roles underneath the passed roles
        for(UserRole userRole :[select Id from UserRole where ParentRoleId 
                                IN :roleIds AND ParentRoleID != null LIMIT 1000]) 
        {
            currentRoleIds.add(userRole.Id);
        }       
        /*****
* @Caution:  a recursive method to identify all sub-roles within a parent role. 
* SOQL query Limit is being checked to avoid causing Run-time exceptions 

* ****/
        if(currentRoleIds.size() > 0 && (Limits.getQueries() < Limits.getLimitQueries())) {
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
        }
        
        return currentRoleIds;
    } 
    
    
    
    
    /********************************************************
* @Description: Wrapper instance to generate formatted JSON response
* 
* ******************************************************/
    public with Sharing Class OrderCommittment {
        Boolean isSuccess = true ; 
        String message ; 
        String orgCurrency ; 
        String userCurrency ; 
        Boolean canViewAdjustRecType = false ; 
        FiscalQuarterData fiscalData = new FiscalQuarterData();
        FiscalQuarterData fiscalDataInOrgCur = new FiscalQuarterData();
        List<FiscalPeriodData> lstFiscalPeriods = new List<FiscalPeriodData>();
        List<FiscalPeriodData> lstFiscalPeriodsInOrgCur = new List<FiscalPeriodData>();
    }
    /********************************************************
* @Description: Wrapper instance to generate formatted JSON response
* 
* ******************************************************/
    public with Sharing Class FiscalQuarterData {
        String amountTotal ; 
        String amountCore ; 
        String amountRunRate  ; 
        String amountAdjusted ; 
        Boolean canViewAdjustment = true ; 
        String amountpoSchedule;
    }
    
    /********************************************************
* @Description: Wrapper instance to generate formatted JSON response
* 
* ******************************************************/
    public with Sharing Class FiscalPeriodData {
        String periodName ; 
        String periodTotal  ; 
        
        public FiscalPeriodData(Integer periodValue , String amountValue) {
            this.periodName = 'P '+periodValue ; 
            this.periodTotal = amountValue ; 
        }
        
    }
    
    
}