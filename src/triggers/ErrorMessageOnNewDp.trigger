trigger ErrorMessageOnNewDp on Discretionary_Plan__c(before insert,before update){
    set<id> opId = new set<id>();
    List<Discretionary_Plan__c> dpList = new List<Discretionary_Plan__c>();
    for(Discretionary_Plan__c dp:trigger.new){
        opId.add(dp.Opportunity__c);
    }
    dpList = [select id,Opportunity__c,Approved_Budget__c,Year__c from Discretionary_Plan__c where Opportunity__c =: opId];
    system.debug('list of child records' + dpList);
    for(integer i=0;i<dpList.size();i++){
        for(Discretionary_Plan__c dp1:Trigger.new){
            if(dp1.id !=dpList[i].id && dp1.Year__c == dpList[i].Year__c && dp1.Approved_Budget__c == null){
                dp1.Year__c.addError('Another DP has the same year');
            }
        }
    }
}