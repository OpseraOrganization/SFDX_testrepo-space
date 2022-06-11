({    
    myAction: function(component, event, helper) {
        //Added on 01-April-2021 | NOKIASC-35109 | Added null check | Start
        if(component.get("v.simpleRecord") != null && component.get("v.simpleRecord") != undefined){
            var internalStatus = component.get("v.simpleRecord").CH_InternalStatus__c;
            var loggedUserId = $A.get("$SObjectType.CurrentUser.Id");
            var caseCreatedById = component.get("v.simpleRecord").CreatedById;
            if(internalStatus != 'Waiting for Referral Instruction' && internalStatus != 'Pending Referral Instruction' && internalStatus != 'No Referral Instruction' && loggedUserId == caseCreatedById){
                helper.subscribe(component, event, helper);
            }
        }
        //Added on 01-April-2021 | NOKIASC-35109 | Added null check | End
}
    
    
})