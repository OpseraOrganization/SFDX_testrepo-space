/** * File Name: REG_PortalAccount_Service

* Description  Queries related to account

* * @author : TCS 

Date 01/18/2019 

* */

public with sharing class REG_PortalAccount_Service{
    
     
     
    /* get the list of tools allowed in an account*/

    public static List<Account_Tools__c> GetAccTools(string accountId){      
        List<Account_Tools__c> accuntToolList = new List<Account_Tools__c>();
        
        if(accountId != null && accountId !=''){
            accuntToolList = [SELECT Id,Portal_Tool_Master_Name__c FROM Account_Tools__c WHERE Account_Name__c =: accountId];
        }
        return accuntToolList ;
    }
    
    
    //Domain match logic
    public static REG_Result GetAccounts(string domain, string city, string stateCode, string countryCode, string output){
        REG_Result internalDomain;
        
        List<Account_Email_Domains__c > domainlist = new List<Account_Email_Domains__c >();
        List<Account_Address__c> accAddList = new List<Account_Address__c > ();
        List<Account_Address__c> accAddAllPriList = new List<Account_Address__c>();
        List <REG_PortalAccount_Intermediate_Wrapper> interWrapper = new List <REG_PortalAccount_Intermediate_Wrapper>();
        List <REG_PortalAccount_Intermediate_Wrapper> interWrapperC = new List <REG_PortalAccount_Intermediate_Wrapper>();
        List<REG_PortalAccount_Intermediate_Wrapper> interimWrapper = new List <REG_PortalAccount_Intermediate_Wrapper>();
        Map<Id,Account_Address__c> accAddPriMap = new Map<Id, Account_Address__c>();
        Map<Id,Account_Address__c> accAddNoPriMap = new Map<Id, Account_Address__c>();
        Map<Id,Account_Address__c> accAddMatchedMap = new Map<Id, Account_Address__c>();
        Map<Id,Account_Address__c> accConStCiPriMap = new Map<Id, Account_Address__c>();
        Map<Id,Account_Address__c> accConStPriMap = new Map<Id, Account_Address__c>();
        Map<Id,Account_Address__c> accConCiPriMap = new Map<Id, Account_Address__c>();
        Map<Id,Account_Address__c> accConPriMap = new Map<Id, Account_Address__c>();
        boolean isInternalDomain = false;
        string iCity = '';
        string iConCode = '';
        string iStateCode = '';
        REG_Result result = new REG_Result(); 
        try{
            internalDomain = REG_RegistrationUtility.getDomainType(domain,''); //to find if domain is internal
            domainList = (List<Account_Email_Domains__c >) internalDomain.data;
            if(domainList  != null && domainList.size() > 0){
                isInternalDomain = domainList[0].internal_email_domain__c;
            }
            system.debug('****internalDomain'+internalDomain);
            accAddList = [SELECT Sbl_Account_Row_ID__c,Country_Code__c,Account_Name__c,id,AccountNameFormula__c,Address_Name__c,
                         Address_LineFormulae1__c,Account_Address_Line2__c,Address_Line_3__c,Address_Status__c,Address_Type__c,
                         Country_Name__c,Account_City_Name__c,Account_Address_State_Code__c,Address_Postal_Code__c,Is_Primary_Address__c,
                         Denied_Party_Status__c,Account_Name__r.Customer_Status__c FROM Account_Address__c where 
                         address_status__c = 'active' and Account_Name__r.Customer_Status__c = 'active' and account_name__c in 
                         (select account__c from account_email_domains__c where account_email_domain__c =: domain and 
                         name not in ('HONEYWELL UNIDENTIFIED PORTAL USERS','Bendix King UNIDENTIFIED PORTAL USERS',
                         'Honeywell Default Account','NO ACCOUNT FOUND','FSR TEMPORARY OPERATOR','Portal Missing Users (Do not use)')  
                         and (not name like '%Various%') ) ];
            
            system.debug('****accAddList '+accAddList );
            if(accAddList.isEmpty()){
                //throw new stringException('No data found for given domain');
                result.handleError(404, 'Domain details not found for the given domain.', 'Please provide a valid domain.');
                return result;
            }
            if(city != null && city !=''){
                iCity = city;
            }else{
                iCity = 'Value not provided ';
            }
            if(stateCode != null && stateCode !=''){
                iStateCode = stateCode;
            }else{
                iStateCode = 'Value not provided ';
            }
            if(countryCode != null && countryCode !=''){
                iConCode = countryCode;
            }else{
                iConCode = 'Value not provided ';
            } 
            system.debug('*****iCity'+iCity); 
            system.debug('*****iStateCode'+iStateCode); 
            system.debug('*****iConCode'+iConCode);  
                                
            for(Account_Address__c accD : accAddList){
                //accAddMap.put(accD.Id, accD)
                
                if(accD.Is_Primary_Address__c == True){
                    accAddAllPriList.add(accD); //add all the account with primary address
                    system.debug('*****accAddAllPriList'+accAddAllPriList);
                    system.debug('*****iConCode1'+accD.Country_Code__c);
                    system.debug('*****iStateCode1'+accD.Account_Address_State_Code__c);
                     system.debug('*****iCity1'+accD.Account_City_Name__c); 
                    if(accD.Country_Code__c == iConCode && accD.Account_Address_State_Code__c == iStateCode  && accD.Account_City_Name__c == iCity){
                        accConStCiPriMap.put(accD.Id,accD);         
                        system.debug('****accAddPriMap0'+accConStCiPriMap);
                    }else if(accD.Country_Code__c == iConCode && accD.Account_City_Name__c == iCity ){
                        accConCiPriMap.put(accD.Id,accD);
                        system.debug('****accAddPriMap1'+accConCiPriMap);
                    }else if(accD.Country_Code__c == iConCode && accD.Account_Address_State_Code__c == iStateCode){
                        accConStPriMap.put(accD.Id,accD);
                        system.debug('****accAddPriMap2'+accConStPriMap);
                    }else if(accD.Country_Code__c == iConCode ){
                        accConPriMap.put(accD.Id,accD);
                        system.debug('****accAddPriMap3'+accConPriMap);
                    }
                }
    
            }
            accAddPriMap = getMatchedAcc(accConStCiPriMap, accConCiPriMap, accConStPriMap, accConPriMap );
           /* if(accConStCiPriMap.size() >= 1){
                accAddPriMap = accConStCiPriMap;
            }
            if(accConStCiPriMap.isempty() && accConCiPriMap.size() >=1){
                accAddPriMap=accConCiPriMap;
            }
            if(accConStCiPriMap.isempty() && accConCiPriMap.isEmpty() && accConStPriMap.size() >=1){
                accAddPriMap=accConStPriMap;
            }
            if(accConStCiPriMap.isempty() && accConCiPriMap.isEmpty() && accConStPriMap.isempty() && accConPriMap.size() >=1){
                accAddPriMap=accConPriMap;
            }*/
            system.debug('****accAddPriMap' +accAddPriMap);
            if(accAddPriMap.isEmpty()){
                for(Account_Address__c accD : accAddList){   
                    if(accD.Country_Code__c == iConCode && accD.Account_Address_State_Code__c == iStateCode  && accD.Account_City_Name__c == iCity){
                        accConStCiPriMap.put(accD.Account_Name__c,accD);         
                    }else
                    if(accD.Country_Code__c == iConCode && accD.Account_City_Name__c == iCity){
                        accConCiPriMap.put(accD.Account_Name__c,accD);
                    }else
                    if(accD.Country_Code__c == iConCode && accD.Account_Address_State_Code__c == iStateCode){
                        accConStPriMap.put(accD.Account_Name__c,accD);
                    }else
                    if(accD.Country_Code__c == iConCode){
                        accConPriMap.put(accD.Account_Name__c,accD);
                    }
                }    
            accAddNoPriMap= getMatchedAcc(accConStCiPriMap, accConCiPriMap, accConStPriMap, accConPriMap );
            /*if(accConStCiPriMap.size() >= 1){
                accAddNoPriMap = accConStCiPriMap;
            }
            if(accConStCiPriMap.isempty() && accConCiPriMap.size() >=1){
                accAddNoPriMap=accConCiPriMap;
            }
            if(accConStCiPriMap.isempty() && accConCiPriMap.isEmpty() && accConStPriMap.size() >=1){
                accAddNoPriMap=accConStPriMap;
            }
            if(accConStCiPriMap.isempty() && accConCiPriMap.isEmpty() && accConStPriMap.isempty() && accConPriMap.size() >=1){
                accAddNoPriMap=accConPriMap;
            }*/
            system.debug('****accAddNoPriMap' +accAddNoPriMap);        
            }
            

            system.debug('****accAddAllPriList ' +accAddAllPriList );
            //to check if account name of account without primary address is present in list of accounts with primary address 
            if(accAddPriMap.isEmpty() && !accAddNoPriMap.isEmpty()){
                system.debug('Inside if');
                for(Account_Address__c acc: accAddAllPriList ){
                    system.debug('*****acc' +acc);
                    if(accAddNoPriMap.containsKey(acc.Account_Name__c)){
                        system.debug('Inside if1');
                        accAddMatchedMap.put(acc.Id,acc);     
                    }        
                }  
                system.debug('****accAddMatchedMap' +accAddMatchedMap);  
            }
            if(output == 'filtered'){
             
                if(accAddPriMap.size() >= 1){
                  /*  for(Id acc: accAddPriMap.keySet()){
                        REG_PortalAccount_Intermediate_Wrapper interimdata = new REG_PortalAccount_Intermediate_Wrapper(domain, 
                        isInternalDomain,accAddPriMap.get(acc).AccountNameFormula__c,accAddPriMap.get(acc).Country_Name__c,
                        accAddPriMap.get(acc).Country_Code__c,accAddPriMap.get(acc).Account_Name__c,accAddPriMap.get(acc).Denied_Party_Status__c, 
                        accAddPriMap.get(acc).Address_LineFormulae1__c,accAddPriMap.get(acc).Account_Address_Line2__c, accAddPriMap.get(acc).Address_Line_3__c,
                        accAddPriMap.get(acc).Address_Status__c,accAddPriMap.get(acc).Address_Type__c,accAddPriMap.get(acc).Is_Primary_Address__c,
                        accAddPriMap.get(acc).Account_City_Name__c  );     
                        interWrapper.add(interimData);
                                   
                    }*/
                    interimWrapper = getWrapperData(domain,isInternalDomain ,  accAddPriMap );
                    system.debug('*****interimWrapper '+interimWrapper );
                    REG_PortalAccount_Wrapper finalData = new REG_PortalAccount_Wrapper(interimWrapper, null);
                    result.data = finalData ;
                }
                 else if(accAddMatchedMap.size() >= 1){
                  
                   /* for(Id acc: accAddMatchedMap.keySet()){
                        REG_PortalAccount_Intermediate_Wrapper interimdata1 = new REG_PortalAccount_Intermediate_Wrapper(domain, 
                        isInternalDomain,accAddMatchedMap.get(acc).AccountNameFormula__c,accAddMatchedMap.get(acc).Country_Name__c,
                        accAddMatchedMap.get(acc).Country_Code__c,accAddMatchedMap.get(acc).Account_Name__c,accAddMatchedMap.get(acc).Denied_Party_Status__c, 
                        accAddMatchedMap.get(acc).Address_LineFormulae1__c,accAddMatchedMap.get(acc).Account_Address_Line2__c, accAddMatchedMap.get(acc).Address_Line_3__c,
                        accAddMatchedMap.get(acc).Address_Status__c,accAddMatchedMap.get(acc).Address_Type__c,accAddMatchedMap.get(acc).Is_Primary_Address__c,
                        accAddMatchedMap.get(acc).Account_City_Name__c  );     
                        interWrapper.add(interimData1);
                                   
                    }*/
                    interimWrapper = getWrapperData(domain,isInternalDomain , accAddMatchedMap );
                    system.debug('*****interimWrapper '+interimWrapper );
                    REG_PortalAccount_Wrapper finalData = new REG_PortalAccount_Wrapper(interimWrapper, null);
                    result.data = finalData ;
                }                
   	      else {
                    interimWrapper = getWrapperData(domain,isInternalDomain , accAddMatchedMap );
                    system.debug('*****interimWrapper '+interimWrapper );
                    REG_PortalAccount_Wrapper finalData = new REG_PortalAccount_Wrapper(interimWrapper, null);
                    result.data = finalData ;
                }  
				                
            }
            if(output == 'unfiltered' || ((city == '' || city == null) && (stateCode == '' || stateCode == null) && (countryCode == '' || countryCode == null))){
                if(accAddAllPriList.size() >=1){
                    for(Account_Address__c acc:accAddAllPriList){
                        REG_PortalAccount_Intermediate_Wrapper interimdata = new REG_PortalAccount_Intermediate_Wrapper(domain, 
                        isInternalDomain,acc.AccountNameFormula__c,acc.Country_Name__c,acc.Country_Code__c,acc.Account_Address_State_Code__c,acc.Account_Name__c,
                        acc.Denied_Party_Status__c,acc.Address_LineFormulae1__c,acc.Account_Address_Line2__c, acc.Address_Line_3__c,
                        acc.Address_Status__c,acc.Address_Type__c,acc.Is_Primary_Address__c,acc.Account_City_Name__c, acc.Address_Postal_Code__c);
                        interWrapper.add(interimdata);
                    }
                    
                    system.debug('*****interWrapper '+interWrapper );                
                    REG_PortalAccount_Wrapper finalData = new REG_PortalAccount_Wrapper(null,interWrapper);
                    result.data = finalData ;
                }
           
            } 
            if(output == 'combined' || output == '' || output == null){
                if(accAddAllPriList.size() >=1){
                    for(Account_Address__c acc:accAddAllPriList){
                        REG_PortalAccount_Intermediate_Wrapper interimdata = new REG_PortalAccount_Intermediate_Wrapper(domain, 
                        isInternalDomain,acc.AccountNameFormula__c,acc.Country_Name__c,acc.Country_Code__c,acc.Account_Address_State_Code__c,acc.Account_Name__c,
                        acc.Denied_Party_Status__c,acc.Address_LineFormulae1__c,acc.Account_Address_Line2__c, acc.Address_Line_3__c,
                        acc.Address_Status__c,acc.Address_Type__c,acc.Is_Primary_Address__c,acc.Account_City_Name__c,acc.Address_Postal_Code__c);
                        interWrapperC.add(interimdata);
                    }
                    
                }    
                if(accAddPriMap.size() >= 1){
                   /* for(Id acc: accAddPriMap.keySet()){
                        REG_PortalAccount_Intermediate_Wrapper interimdata = new REG_PortalAccount_Intermediate_Wrapper(domain, 
                        isInternalDomain,accAddPriMap.get(acc).AccountNameFormula__c,accAddPriMap.get(acc).Country_Name__c,
                        accAddPriMap.get(acc).Country_Code__c,accAddPriMap.get(acc).Account_Name__c,accAddPriMap.get(acc).Denied_Party_Status__c, 
                        accAddPriMap.get(acc).Address_LineFormulae1__c,accAddPriMap.get(acc).Account_Address_Line2__c, accAddPriMap.get(acc).Address_Line_3__c,
                        accAddPriMap.get(acc).Address_Status__c,accAddPriMap.get(acc).Address_Type__c,accAddPriMap.get(acc).Is_Primary_Address__c,
                        accAddPriMap.get(acc).Account_City_Name__c  );     
                        interWrapper.add(interimData);
                                   
                    }*/
                    interimWrapper = getWrapperData(domain,isInternalDomain , accAddPriMap );
                    system.debug('*****interimWrapper '+interimWrapper );
                    REG_PortalAccount_Wrapper finalData = new REG_PortalAccount_Wrapper(interimWrapper,interWrapperC);
                    result.data = finalData ;
    
                } 
                else if(accAddMatchedMap.size() >= 1){
                    /*for(Id acc: accAddMatchedMap.keySet()){
                        REG_PortalAccount_Intermediate_Wrapper interimdata1 = new REG_PortalAccount_Intermediate_Wrapper(domain, 
                        isInternalDomain,accAddMatchedMap.get(acc).AccountNameFormula__c,accAddMatchedMap.get(acc).Country_Name__c,
                        accAddMatchedMap.get(acc).Country_Code__c,accAddMatchedMap.get(acc).Account_Name__c,accAddMatchedMap.get(acc).Denied_Party_Status__c, 
                        accAddMatchedMap.get(acc).Address_LineFormulae1__c,accAddMatchedMap.get(acc).Account_Address_Line2__c, accAddMatchedMap.get(acc).Address_Line_3__c,
                        accAddMatchedMap.get(acc).Address_Status__c,accAddMatchedMap.get(acc).Address_Type__c,accAddMatchedMap.get(acc).Is_Primary_Address__c,
                        accAddMatchedMap.get(acc).Account_City_Name__c  );     
                        interWrapper.add(interimData1);
                                   
                    }*/
                    interimWrapper = getWrapperData(domain, isInternalDomain ,accAddMatchedMap);
                    system.debug('*****interimWrapper '+interimWrapper );
                    REG_PortalAccount_Wrapper finalData = new REG_PortalAccount_Wrapper(interimWrapper,interWrapperC);
                    result.data = finalData ;
    
                }       
   	        else{
                    interimWrapper = getWrapperData(domain,isInternalDomain , accAddPriMap );
                    system.debug('*****interimWrapper '+interimWrapper );
                    REG_PortalAccount_Wrapper finalData = new REG_PortalAccount_Wrapper(interimWrapper,interWrapperC);
                    result.data = finalData ;
                }  
           
            }  
        }catch(stringException e){
            result.handleException(400, e.getMessage(), e); 
              
        }catch(Exception e){
            result.handleException(500, e.getMessage(), e); 
              
        
        }          
        system.debug('***** result'+result);
        return Result;
    
    }
    public static Map<Id,Account_Address__c> getMatchedAcc(Map<Id,Account_Address__c> accConStCiPriMap, Map<Id,Account_Address__c> accConStPriMap,
                                      Map<Id,Account_Address__c> accConCiPriMap,Map<Id,Account_Address__c> accConPriMap){
        Map<Id,Account_Address__c> accAddPriMap = new Map<Id, Account_Address__c>();
        if(accConStCiPriMap.size() >= 1){
            accAddPriMap = accConStCiPriMap;
        }
        if(accConStCiPriMap.isempty() && accConCiPriMap.size() >=1){
            accAddPriMap=accConCiPriMap;
        }
        if(accConStCiPriMap.isempty() && accConCiPriMap.isEmpty() && accConStPriMap.size() >=1){
            accAddPriMap=accConStPriMap;
        }
        if(accConStCiPriMap.isempty() && accConCiPriMap.isEmpty() && accConStPriMap.isempty() && accConPriMap.size() >=1){
            accAddPriMap=accConPriMap;
        }   
        return accAddPriMap;
    }
    
    public static List<REG_PortalAccount_Intermediate_Wrapper> getWrapperData(string domain, boolean isInternalDomain,Map<Id,Account_Address__c> accAddGeneralMap){
        List <REG_PortalAccount_Intermediate_Wrapper> interWrapper = new List <REG_PortalAccount_Intermediate_Wrapper>();    
        //string isInternalDomain = '';
        REG_Result result = new REG_Result();
       
            for(Id acc: accAddGeneralMap.keySet()){
                REG_PortalAccount_Intermediate_Wrapper interimdata = new REG_PortalAccount_Intermediate_Wrapper(domain, 
                isInternalDomain,accAddGeneralMap.get(acc).AccountNameFormula__c,accAddGeneralMap.get(acc).Country_Name__c,
                accAddGeneralMap.get(acc).Country_Code__c,accAddGeneralMap.get(acc).Account_Address_State_Code__c,accAddGeneralMap.get(acc).Account_Name__c,accAddGeneralMap.get(acc).Denied_Party_Status__c, 
                accAddGeneralMap.get(acc).Address_LineFormulae1__c,accAddGeneralMap.get(acc).Account_Address_Line2__c, accAddGeneralMap.get(acc).Address_Line_3__c,
                accAddGeneralMap.get(acc).Address_Status__c,accAddGeneralMap.get(acc).Address_Type__c,accAddGeneralMap.get(acc).Is_Primary_Address__c,
                accAddGeneralMap.get(acc).Account_City_Name__c,accAddGeneralMap.get(acc).Address_Postal_Code__c  );     
                interWrapper.add(interimData);
                           
            }
            
          
               
        return interWrapper ;
    }
    
    public static REG_Result getAllSoldtoAccounts(String searchString){
        REG_Result result = new REG_Result();
         searchString = '%'+searchString+'%';
        List<Account> acList= [Select sbl_account_row_id__c, id, name,SAP_Sold_To__c,address_line_1__c, address_line_2__c, address_line_3__c,city_name__c,state_code__c, postal_code__c, country_name__c, market_name__c, (Select country_code__c from account_address__r where is_primary_address__c = true )
                               From Account  where name LIKE :searchString and customer_status__c = 'active' and name not in ('HONEYWELL UNIDENTIFIED PORTAL USERS','Honeywell Default Account','NO ACCOUNT FOUND','FSR TEMPORARY OPERATOR','Portal Missing Users (Do not use)') LIMIT 25];
        List<REG_PortalAccount_AllSoldto_Wrapper> rpWrapList = new List<REG_PortalAccount_AllSoldto_Wrapper>();
        for(Account ac: acList){
            String countryCode = '';
            for(account_address__c ad:ac.account_address__r){
                countryCode = ad.country_code__c;
            }
            REG_PortalAccount_AllSoldto_Wrapper rpw = new REG_PortalAccount_AllSoldto_Wrapper(ac,countryCode);
            rpWrapList.add(rpw);
        }
        if(rpWrapList.size()<=0){
            result.handleError(400, 'There is no search result exists','');
        }
        result.Data = rpWrapList;
        return result;
    }

}