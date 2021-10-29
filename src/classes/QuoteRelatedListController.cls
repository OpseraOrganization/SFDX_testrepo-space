public class QuoteRelatedListController {
    
    
    @AuraEnabled
    public static QuoteWrapper getContacts(Id aid) {
        
        
        QuoteWrapper ObjQuoteWrapper = new QuoteWrapper();
       Opportunity objOpp = [select Id,Name,StageName,CloseDate,Solution_Type__c,Sub_Solution_Type__c,
                                                    AccountId,Account.ATR_Channel_Partner__c,Account.Strategic_Business_Unit__c,Account.CBT__c,Account.Type from Opportunity where Id =:aid]; 
        ObjQuoteWrapper.oppObjRec = objOpp;
        
        Boolean boolStage = objOpp.CloseDate < Date.today();
        system.debug('duedate::'+objOpp.CloseDate);
        system.debug('ate::'+Date.today());
        system.debug(boolStage);
        string NewQuoteButtonSwitch=label.NewQuoteButtonSwitch;
        if(test.isrunningtest())
        NewQuoteButtonSwitch='ON';  
      /*  if(objOpp.StageName=='Closed Lost'){
             ObjQuoteWrapper.boolQuoteFlag = false;
        }*/
       ObjQuoteWrapper.lstRecords =  [SELECT Id,Status__c,Name,Quote_Number__c,Total_Net_Price__c,quote_value__c,Primary_Quote__c,LastModifiedDate,Quote_Expiration_Date__c,opportunity__c,Quote_ID__c,Revision_Number__c,Revision__c,
                                      opportunity__r.StageName,opportunity__r.Name FROM quote__c where opportunity__c=:aid ORDER BY Primary_Quote__c ASC NULLS LAST limit 5];
        List<Quote__c> quoteLst = [SELECT Id,Status__c,Name,Quote_Number__c,QuoteID__c,Revenue_Amount__c,Primary_Quote__c,quote_value__c,Total_Net_Price__c,LastModifiedDate,Quote_Expiration_Date__c,Revision__c,opportunity__c,Quote_ID__c,
                                      opportunity__r.StageName,opportunity__r.Name,Revision_Number__c FROM quote__c where opportunity__c=:aid ORDER BY Primary_Quote__c ASC NULLS LAST];
        if(quoteLst.size()>0)
        ObjQuoteWrapper.quoteObjRec = quoteLst[0];   
        ObjQuoteWrapper.lstQuoteRecords=quoteLst;
        ObjQuoteWrapper.intRecCount = ObjQuoteWrapper.lstRecords.size();
        ObjQuoteWrapper.TotalQuoteRecCount=quoteLst.size();
        if(objOpp.StageName=='Closed Lost'  || ObjQuoteWrapper.intRecCount >= 1){
            ObjQuoteWrapper.boolQuoteFlag = false;
        }
        else{
                Boolean newquotebutton=false;
                String[] NewQuoteButtonOppStages = (label.NewQuoteButtonOppStages).split(',');       
                if(NewQuoteButtonOppStages.size() > 0){            
                  for(String i : NewQuoteButtonOppStages){
                    if(i==objOpp.StageName)
                    {
                      newquotebutton = true; 
                    }
                  }
                }
                if((newquotebutton==true) && (objOpp.Solution_Type__c == 'Repair and Overhaul' && objOpp.Sub_Solution_Type__c == 'Flat Rate')){
                       for(NewQuoteAccountFieldValidator__c custObj : NewQuoteAccountFieldValidator__c.getAll().values()){
                           if(custObj.SBU__c == objOpp.Account.Strategic_Business_Unit__c && custObj.CBT__c == objOpp.Account.CBT__c 
                              && custObj.TYPE__c == objOpp.Account.Type && custObj.STATUS__c == 'True'){
                                  if((objOpp.Account.Type =='MRO' || objOpp.Account.Type =='Product/Service Provider' || objOpp.Account.Type =='Repair Shop' || objOpp.Account.Type =='Service Center') && (objOpp.Account.ATR_Channel_Partner__c==true))
                                  {
                                      if(NewQuoteButtonSwitch=='ON' )
                                    {
                                        List<String> NewQuoteButtonUseridlist = new List<String>(); 
                                        String[] NewQuoteButtonUseridlst = (label.NewQuoteButtonUsersList).split(','); 
                                        string userid=userinfo.getuserid();       
                                        if(NewQuoteButtonUseridlst.size() > 0){            
                                            for(String i : NewQuoteButtonUseridlst){
                                                if(i==userid)
                                                {
                                                    ObjQuoteWrapper.boolQuoteFlag = true;
                                                }
                                            }
                                        }  
                                    }
                                    else
                                    {
                                      ObjQuoteWrapper.boolQuoteFlag = true;
                                    }
                                  }
                                  else if((objOpp.Account.Type =='MRO' || objOpp.Account.Type =='Product/Service Provider' || objOpp.Account.Type =='Repair Shop' || objOpp.Account.Type =='Service Center') && (objOpp.Account.ATR_Channel_Partner__c==false))
                                  {
                                      ObjQuoteWrapper.boolQuoteFlag = false;
                                  }
                                  else{
                                   if(NewQuoteButtonSwitch=='ON' )
                                    {
                                        List<String> NewQuoteButtonUseridlist = new List<String>(); 
                                        String[] NewQuoteButtonUseridlst = (label.NewQuoteButtonUsersList).split(','); 
                                        string userid=userinfo.getuserid();       
                                        if(NewQuoteButtonUseridlst.size() > 0){            
                                            for(String i : NewQuoteButtonUseridlst){
                                                if(i==userid)
                                                {
                                                    ObjQuoteWrapper.boolQuoteFlag = true;
                                                }
                                            }
                                        }  
                                    }
                                    else
                                    {
                                      ObjQuoteWrapper.boolQuoteFlag = true;
                                    }   
                                  }
                                  
                           }
                   }
                   }
        }
        if(quoteLst.size()>0){
            if(quoteLst.size()>5)
            ObjQuoteWrapper.viewAllFlag = true;
          ObjQuoteWrapper.EditFlag = true;  
        }
        else{
            ObjQuoteWrapper.viewAllFlag = false;
            ObjQuoteWrapper.EditFlag = false;
        }    
        User userRec = [SELECT id,Profile.Name FROM User WHERE id=:Userinfo.getUserId()];
    if((!(objOpp.StageName.contains('Closed Won'))) && (!(objOpp.StageName.contains('Closed Lost'))) && (!(objOpp.StageName.contains('Closed Cancelled'))) && (!(objOpp.StageName.contains('Closed Channel Partner'))) && (!(objOpp.StageName.contains('Closed/Lost'))) && (!(objOpp.StageName.contains('Closed Abandoned'))) )
    {
      if(NewQuoteButtonSwitch=='ON' )
      {
        List<String> NewQuoteButtonUseridlist = new List<String>(); 
        String[] NewQuoteButtonUseridlst = (label.NewQuoteButtonUsersList).split(','); 
        string userid=userinfo.getuserid();       
        if(NewQuoteButtonUseridlst.size() > 0){            
          for(String i : NewQuoteButtonUseridlst){
            if(i==userid)
            {
              ObjQuoteWrapper.blnPermission = true;  
            }
          }
        }  
      }
      else {
        ObjQuoteWrapper.blnPermission = true;  
      }
    }
    else{
      ObjQuoteWrapper.blnPermission = false; 
      ObjQuoteWrapper.EditFlag = false; 
    }
      return ObjQuoteWrapper;
    }
    
    @Auraenabled
    public static void delteQuoteById(String strQuoteId)
    {
       Delete [SELECT id, Account__c,Account__r.Name,Revision__c,Status__c,Name FROM quote__c WHERE id=:strQuoteId LIMIT 1];
    }
    
    // wrapper or Inner class with @AuraEnabled {get;set;} properties*    
    public class QuoteWrapper{
        @AuraEnabled public Integer intRecCount {get;set;}
        @AuraEnabled public Integer TotalQuoteRecCount {get;set;}
        @AuraEnabled public List<Quote__c> lstRecords {get;set;}
        @AuraEnabled public List<Quote__c> lstQuoteRecords {get;set;}
        @AuraEnabled public Boolean blnPermission{get;set;}
         @AuraEnabled public Boolean boolQuoteFlag{get;set;}
        @AuraEnabled public Boolean viewAllFlag{get;set;}
        @AuraEnabled public Boolean EditFlag{get;set;}
         @AuraEnabled public Opportunity oppObjRec {get;set;}
        @AuraEnabled public Quote__c quoteObjRec {get;set;}
        
    }
    
   
}