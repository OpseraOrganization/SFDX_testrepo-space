/********************************************
Test Class Name: TestClass_CasePopUpMsgOnOwnerAssignClass
********************************************/

global with sharing class CasePopUpMsgOnOwnerAssignClass{
    public String caseid { get; set; }
    public String casowner{get;set;}
    public CasePopUpMsgOnOwnerAssignClass(ApexPages.StandardController controller) {
        caseid = apexpages.currentpage().getparameters().get('Id');
    }
    @RemoteAction
    global static Case getCase(String casid) {
        Case cs = [select id,CaseOwnerChanged__c from Case where id=:casid limit 1];
        if(cs.CaseOwnerChanged__c!=null && cs.CaseOwnerChanged__c=='005'){
            cs.CaseOwnerChanged__c = '';
            update cs;
        }else if(cs.CaseOwnerChanged__c!=null && cs.CaseOwnerChanged__c=='005 CHINA NAT ACC'){
            cs.CaseOwnerChanged__c = '';
            update cs;
        }
        return cs;
    }
}