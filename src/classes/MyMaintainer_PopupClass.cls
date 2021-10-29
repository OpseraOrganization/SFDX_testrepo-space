public class MyMaintainer_PopupClass {
    public String caseid { get; set; }
    public string cs{get;set;}
    public MyMaintainer_PopupClass(ApexPages.StandardController controller) {
        caseid = apexpages.currentpage().getparameters().get('Id');
        cs = [SELECT MyMaintainer_Roles__c from Case_Extension__c where Case_object__c=:caseid].MyMaintainer_Roles__c;
        system.debug(cs);
    }
}