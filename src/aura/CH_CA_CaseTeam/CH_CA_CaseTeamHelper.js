({
    init: function(component){
		component.set('v.isLoading', true);
		let action = component.get('c.getCaseTeamMembers');
        action.setParams({ caseId: component.get('v.recordId')});
        action.setCallback(this,function(response) {
            component.set('v.isLoading', false);
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.isLoading', true);
                var data = response.getReturnValue();
                if(data.length != 0){
                    for(let i = 0; i < data.length; i++){
                        data[i].MemberName = data[i].Member?data[i].Member.Name:'';
                        data[i].MemberURL = data[i].Member?this.getLightningURL(data[i].Member.Id):'';
                        data[i].TeamRoleName = data[i].TeamRole?data[i].TeamRole.Name:'';
                        data[i].WorkgroupName = data[i].Workgroup?data[i].Workgroup.Name:'';
                        if(i == (data.length-1)){
                            component.set('v.members', data);
                            component.set('v.isLoading', false);
                        } 
                    }
                }
                else {
                    component.set('v.members', data);
                    component.set('v.isLoading', false);
                }
            }
            else if (state === "INCOMPLETE") {
                console.log('Incomplete');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.log(errors && errors[0] && errors[0].message?("Error message: " + errors[0].message):"Unknown error");
                this.showToast('error', 'Error', errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }
        });
        $A.enqueueAction(action);        
    },
    deleteMember: function(component, member){
		let action = component.get('c.deleteCaseTeamMember'), helper = this;
        action.setParams({ caseMember: member});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.init(component);
                $A.get('e.force:refreshView').fire();
            }
            else if (state === "INCOMPLETE") {
                console.log('Incomplete');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.log(errors && errors[0] && errors[0].message?("Error message: " + errors[0].message):"Unknown error");
                this.showToast('error', 'Error', errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }
        });
        $A.enqueueAction(action);        
    },
    // Sort By Algorithm
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a)?key(a):'', b = key(b)?key(b):'', reverse * ((a > b) - (b > a));
        }
    },
    // Generic Toast Message
    showToast: function(sType, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": sType
        });
        toastEvent.fire();
    },
    // Generic Lightning URL Formation
    getLightningURL: function(recordId) {
        return '/one/one.app?#/sObject/' + recordId + '/view';
    }
})