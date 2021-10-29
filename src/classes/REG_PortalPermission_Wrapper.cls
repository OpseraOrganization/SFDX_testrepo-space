public class REG_PortalPermission_Wrapper {
    public String honeywellId = '';
    public String contactId = '';
    list<String> portalContentPermission ;
    set<string> crmId ;
    public boolean isInternal = false;
    public String primaryCrmId = '';
    
    public REG_PortalPermission_Wrapper(String honID, String conID, list<String> roles,set<string> relatedAccounts,List<Account_Email_Domains__c> internalUser,String primaryAccSblId){
        this.honeywellId = honID;
        this.ContactId = conID;
        if(!roles.IsEmpty()){
            this.portalContentPermission = roles;
        }
        if(!relatedAccounts.IsEmpty()){
            this.crmId = relatedAccounts;
        }
        if(!internalUser.isEmpty()){
            this.isInternal = internalUser[0].Internal_Email_Domain__c;
        }
        
        this.primaryCrmId = primaryAccSblId;
        
        
    }
}