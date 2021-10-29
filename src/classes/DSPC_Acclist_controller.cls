public with sharing class DSPC_Acclist_controller {
    public Account act {get; set;}  
 /*   public List<Account> AllSearchacts  
    {  
        get  
        {  
            if(con != null)  
                return (List<Account>)con.getRecords();  
            else  
                return null ;  
        }  
        set;}  
*/
    // Declaring Standard set controller
 /*   public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                con = new ApexPages.StandardSetController(Database.getQueryLocator([select Id,Name,Region_Name__c,phone,fax,website,Strategic_Business_Unit__c,CBT__c,Service_Level__c,Denied_Party_Alert_formula__c, CBT_Team__c, CBT_Directorate__c, Type, Ownerid, Sbl_Account_Row_Id__c, D_S_Market_Org__c, ParentId, Top_Account__c from Account where Strategic_Business_Unit__c = 'D&S']));
                con.setPageSize(10);
            }
            return con;
        }
        set;
    } */
    
    //Constructor
    public DSPC_Acclist_controller() {
       // AllSearchacts = new List<Account>() ;  
        act = new Account() ;  
    }
    
    // Method for Request New Account Button
    public pagereference New_form() {
        pagereference pageref = new pagereference('/apex/DSPC_Account_Request');
        pageref.setredirect(true);
        return pageref;
    }
    
    public pagereference AccountRequestStatus() {
        pagereference pageref = new pagereference('/apex/DSPC_Case_List');
        pageref.setredirect(true);
        return pageref;
    }

}