@isTest
private class TestClass_OpportunityOwnerSearch{
    static testMethod void testCase(){
       OpportunityOwnerSearch_CLS opowner= new OpportunityOwnerSearch_CLS();
         Opportunity opp=new Opportunity();
            opowner.getItems();
            opowner.getfieldValues();
            opowner.value='b%%';
            opowner.operator='LIKE';
            opowner.selectedfield='lastName';
            opowner.doSearch();
        opowner= new OpportunityOwnerSearch_CLS();
            opowner.value=opp.Name;
            opowner.operator='Starts with';
            opowner.selectedfield='lastName';
            opowner.doSearch();
        opowner= new OpportunityOwnerSearch_CLS();
            opowner.value='null';
            opowner.operator='Starts with';
            opowner.selectedfield='lastName';
            opowner.doSearch();
            opowner.next();
            opowner.first();
            opowner.previous();
            opowner.last();
             
    }
   
}