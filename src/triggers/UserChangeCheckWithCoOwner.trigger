trigger UserChangeCheckWithCoOwner on Opportunity_Sales_Team__c (before update) {
    for(Opportunity_Sales_Team__c newRec:Trigger.New){
        Opportunity_Sales_Team__c oldRec = Trigger.oldMap.get(newRec.Id);
        if(oldRec.User__c != newRec.User__c && oldRec.Opportunity_Team_Role__c=='Co-Owner'&&
            oldRec.Opportunity_Team_Role__c == newRec.Opportunity_Team_Role__c){
            newRec.addError('The User Can not be changed, please delete and add new Opportunity Team');
                    
        }
    }
    for(Opportunity_Sales_Team__c newRec:Trigger.New){
        Opportunity_Sales_Team__c oldRec = Trigger.oldMap.get(newRec.Id);
        if(oldRec.User__c != newRec.User__c && oldRec.Opportunity_Team_Role__c=='Co-Owner2'&&
            oldRec.Opportunity_Team_Role__c == newRec.Opportunity_Team_Role__c){
            newRec.addError('The User Can not be changed, please delete and add new Opportunity Team');
                    
        }
    }
}