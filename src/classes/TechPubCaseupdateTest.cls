@isTest(SeeAllData=true)
private class TechPubCaseupdateTest{
    public static testMethod void doget(){
    
    string cas=[select id,casenumber from case limit 1].casenumber ;
        TechPubCaseupdate.TechPubCaseupdate(cas,'test contract', 'NTT Offshore Test Account','123653','764768','12-31-2015','543'); 
    }
    public static testMethod void doget1(){
    
    string cas=[select id,casenumber from case limit 1].casenumber ;
        TechPubCaseupdate.TechPubCaseupdate(cas,'', '','','','',''); 
    }
    
}