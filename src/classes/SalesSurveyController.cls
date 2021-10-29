public class SalesSurveyController {
    
    @AuraEnabled
    public static List<Opportunity> initC(id oppty ){
        
        List<Opportunity> lstopps = new List<Opportunity>([Select id, amount, StageName,AutopopOff__c, Account.id,  recordType.Name,Account_Region__c,
        End_User_Region__c,Win_Loss_Amount__c,Account.ATR_Channel_Partner__c,Is_HAT__c,Account.BGA_Account__c,Account.D_S_Channel_Partner__c,
        Pipeline_Amount__c,Reason_For_Not_Sending_Survey_Picklist__c, Qualified_Sales_Survey__c, Sales_Survey_Sent__c,End_User__c from Opportunity where id=:oppty]);
        return lstopps;
    } 
    
    @AuraEnabled
    public static List<contact> getGlobalContacts(string sterm,id acc ){
        /*List<contact> lstContact = new List<contact>([Select id, name, email, Account.Name 
                                                      from contact 
                                                      where name like :sterm and accountid !=:acc and Sales_Surveyed__c=false and email!=null 
                                                      Order By name ASC Limit 20]);*/
        List<contact> lstContact = new List<contact>([Select id, name, email, Account.Name 
                                                      from contact 
                                                      where name like :sterm and Sales_Surveyed__c=false and email!=null 
                                                      Order By name ASC Limit 20]);                                                      
        return lstContact;
    }
    @AuraEnabled
    public static boolean validateOpptyRecord(id oppty ){
        
        List<Opportunity> lstopps = new List<Opportunity>([Select id
                                                           , amount
                                                           , StageName,
                                                           AutopopOff__c, 
                                                           Account.id,
                                                           recordType.Name,
                                                           recordTypeid,
                                                           CloseDate,
                                                           End_User_Region__c,
                                                           Win_Loss_Amount__c,
                                                           Account.ATR_Channel_Partner__c,
                                                           Is_HAT__c,
                                                           Account.BGA_Account__c,
                                                           Account.D_S_Channel_Partner__c,
                                                           Account_Region__c,End_User__c
                                                          from Opportunity where id=:oppty]);
        list<OppCloseDate__c> lstOppClose = [select id,CloseDateNum__c from OppCloseDate__c];
        
        System.debug('lstOppClose---'+lstOppClose);
        
        
        if(lstopps[0].CloseDate >= System.today().addDays(-(Integer.valueOf(lstOppClose[0].CloseDateNum__c)))
          && (lstopps[0].AutopopOff__c) ) 
        
        {
            
            return true;
        }
        else
        {
            return false;
        }
        
        
    }
    @AuraEnabled
    public static List<contact> getRelatedContacts(id acc,id oppty,id euacc, string rt)
    {
        updateOppty(oppty);
        List<contact> lstContact = new List<contact>();
                                                      
        If (rt == 'D&S Standard' || rt == 'D&S Standard FollowOn'){
            lstContact = [Select id,name from contact where accountid =:acc and Sales_Surveyed__c=false and email!=null 
                                                          Order By Name ASC];
        }else{
            lstContact = [Select id,name from contact where accountid =:euacc and Sales_Surveyed__c=false and email!=null 
                                                  Order By name ASC]; 
        }
        return lstContact;
    }
    
    @AuraEnabled
    public static String updateOppty(id oppty)
    {
        system.debug('Oppty'+Oppty);
        Opportunity optyRec = new Opportunity(id=oppty,AutopopOff__c=False);
        update optyRec;
        return 'successMethod';
    }
    
    
    @AuraEnabled
    public static string sendEmailA(id[] contacts,id oppty)
    {
        boolean isfailed = false;
        String Er = 'The following error has occurred.';
        System.debug('contacts---'+contacts);
        System.debug('oppty---'+oppty);
        List<Sales_Survey__c> lstSalesSurvey =new List<Sales_Survey__c>();
        Set<Id> setSurvey =new Set<Id>();
        for(id idRec : contacts)
        {
            
            if(!setSurvey.contains(idRec))
            {
                Sales_Survey__c salesSurvey = new Sales_Survey__c();
                salesSurvey.Contact__c = idRec;
                salesSurvey.Opportunity__c =oppty;
                salesSurvey.Survey_Sent__c =true;
                lstSalesSurvey.add(salesSurvey);
            }
            setSurvey.add(idRec);
        }
        
        if(!lstSalesSurvey.isEmpty())
        {
            Database.SaveResult[] saveResultList = Database.insert(lstSalesSurvey, false);
            // Iterate through saveResultList based on isSuccess capture the failed records
            

            System.debug('saveResultList.'+saveResultList);
            for (Database.SaveResult sr : saveResultList) {
                if (!sr.isSuccess()) {
                    isfailed = true;
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) 
                    {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('fields that affected this error: ' + err.getFields());
                        Er += err.getMessage();
                        Er += err.getFields();
                    }
                }
            }
            
        }
        if (isfailed){
              return Er;  
            }else{
              return 'SUCCESS'; 
            }
        
    }    
    
    @AuraEnabled
    public static string saveReasonA(id oppty,string reason){
        System.debug('oppty'+oppty);
        Opportunity optyRec = new Opportunity(id=oppty,Reason_For_Not_Sending_Survey_Picklist__c=reason,AutopopOff__c=false );
        string Ex;
        Try{
        update optyRec;  
        }Catch(Exception e){
            System.debug('The following exception has occurred: ' + e.getMessage());
            Ex= 'The following exception has occurred: '+e.getMessage();
        }
        if(Ex == null){
            return 'SUCCESS';
        }else{
          return Ex;  
        }
        
    } 
}