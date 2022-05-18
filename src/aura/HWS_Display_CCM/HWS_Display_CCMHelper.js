({
    fetchOwnersData : function(component,event,helper) {
        component.set("v.IsSpinner", true);
        component.set('v.usersColumns', [
            {label: 'First Name', fieldName: 'userURL', type: 'url' , wrapText: true, typeAttributes: {label: { fieldName: 'FirstName' }, target: '_blank'}},
            {label: 'Last Name', fieldName: 'usrURL', type: 'url' , wrapText: true, typeAttributes: {label: { fieldName: 'LastName' }, target: '_blank'}},
            {label: 'Email', fieldName: 'Email', type: 'text',wrapText: true,initialWidth: 250 },
            {label: 'Mobile Number', fieldName: 'MobilePhone', type: 'text' },
            {label: 'Phone Number', fieldName: 'Phone', type: 'text'}
            
        ]); 
        var getCaseId=component.get("v.recordId");
        var action=component.get('c.getUserInfo');
        action.setParams({
            caseId : getCaseId});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                if(returnValue.length > 0){
                    component.set("v.isOpen", true);
                    var userRecords = response.getReturnValue();
                    userRecords.forEach(function(record){
                        record.userURL ='/one/one.app?#/sObject/' + record.Id + '/view';
                        record.usrURL = '/one/one.app?#/sObject/' + record.Id + '/view';
                        record.Email = record.Email;
                        record.MobilePhone = record.MobilePhone;
                        record.Phone = record.Phone;
                    });
                    component.set("v.relatedUsers", userRecords);
                    component.set("v.IsSpinner", false);
                }
                else{
                    var errorMessage='There are no Service Contract owners identified for this Account Number. \n';
                    errorMessage+='Please enter the correct Account Number for the Legal Entity and click the "Display CCM" button again.\n';
                    component.set("v.IsSpinner", false);
                    this.showToast('Error','ErrorMessage',errorMessage);
                }
            }
        }));
        $A.enqueueAction(action); 
    },
    
     //Helper method to display the error toast message
    showToast : function(type,title,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: message,
            duration:'20000',
            key: 'info_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire(); 
    },  
})