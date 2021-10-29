/***********************************************
 * @Description : Utility Class where all the custom logic to retrieve pipeline review records
 * should be configured. 
 * Below Steps needs to be followed : 
 * 1. Declare a unique String literal to identify your method (Use this String in Custom Metadata)
 * 2. Add a if logic statment to compare incoming request with this string literal. 
 * 3. Define a method for your logic and this method should return List<sObject>. 
 * *********************************************/ 
public with Sharing class SG_CustomLogicHelper {
    
    private static final String ACCOUNT_WITHOUT_CONTACTS = 'ACCOUNT_WITHOUT_CONTACTS';
    private static final String OPP_WITHOUT_CONTACT_ROLES = 'OPPS_WITHOUT_ROLES';
    private static final String CURRENT_USER = UserInfo.getUserId() ;
    private static Set<Id> setUserIds = new Set<Id>(); 
    /**********************************************************
     * @Description : Utility method which is called by SalesCoach Handler to execute the 
     * custom logic. 
     * **********************************************************/
    public List<sObject> executeRequest(Pipeline_Review__mdt objInput) {
        List<sObject> lstResult = new List<sObject>(); 
        if(objInput != null) {
            if(ACCOUNT_WITHOUT_CONTACTS.equalsIgnoreCase(objInput.Apex_Unique_Identifier__c)) {
                lstResult = getAccountsWoContact(objInput); 
            }
            else if (OPP_WITHOUT_CONTACT_ROLES.equalsIgnoreCase(objInput.Apex_Unique_Identifier__c)){
                lstResult = getOppsWoContact(objInput) ; 
            }
        }
        return lstResult ; 
    }
    /**********************************************************
     * @Description : Custom Logic method to get accounts without contact. 
     
     * **********************************************************/
    private List<sObject> getAccountsWoContact(Pipeline_Review__mdt objInput) {
        List<sObject> lstDBResult = new List<sObject>(); 
        Set<Id> setAccountIds = new Set<Id>(); 
        
        SalesCoach_Utility objUtility = new SalesCoach_Utility(); 
        if(objInput.Is_Team_View__c) {
            setUserIds = objUtility.getMyTeamUsers(); 
        }
        else {
            setUserIds.clear(); 
            setUserIds.add(UserInfo.getUserId());
        }
        
        for(AccountTeamMember objTeamMember : [SELECT AccountId FROM AccountTeamMember 
                                              WHERE UserId IN: setUserIds LIMIT 50000])
        {
            setAccountIds.add(objTeamMember.AccountId); 
        }
        //get the configured fields into query & verify if there is atleast 1 contact exists
        String query = 'SELECT '+objInput.Fields_API_Name__c+' ,(SELECT ID FROM AccountContactRoles LIMIT 1) '+' FROM Account WHERE ID IN :setAccountIds ';
        Integer soqlLimit = Integer.valueOf(objInput.Limit__c); 
        query += ' LIMIT :soqlLimit ' ;
        Account objAccount = new Account(); 
        for(sObject obj : Database.query(query)) {
            objAccount = (Account) obj ; //typecast to account
            if(objAccount.contacts.size() == 0 ){//if there are no contacts , add it to results. 
                lstDBResult.add(objAccount);                 
            }
        }
        
        return lstDBResult ; 
    }

    /**********************************************************
     * @Description : Custom Logic method to get Opps. without Contact roles.  
     
     * **********************************************************/
    private List<sObject> getOppsWoContact(Pipeline_Review__mdt objInput) {
        List<sObject> lstDBResult = new List<sObject>(); 
        
        SalesCoach_Utility objUtility = new SalesCoach_Utility(); 
        if(objInput.Is_Team_View__c) {
            setUserIds = objUtility.getMyTeamUsers(); 
        }
        else {
            setUserIds.clear(); 
            setUserIds.add(UserInfo.getUserId());
        }
        //get the configured fields into query & verify if there is atleast 1 opps contact exists
        String query = 'SELECT '+objInput.Fields_API_Name__c+' ,(SELECT Id FROM OpportunityContactRoles LIMIT 1) '+' FROM Opportunity WHERE OwnerID IN :setUserIds AND IsClosed = FALSE AND RecordType.DeveloperName=\'Core\' ';
        Integer soqlLimit = Integer.valueOf(objInput.Limit__c); 
        query += ' LIMIT :soqlLimit ' ; 
        Opportunity objOpp = new Opportunity(); 
        for(sObject obj : Database.query(query)) {
            objOpp = (Opportunity) obj ; //typecast to opp
            if(objOpp.OpportunityContactRoles.size() == 0 ){//if there are no contacts , add it to results. 
                lstDBResult.add(objOpp);                 
            }
        }
        
        return lstDBResult ; 
    }
}