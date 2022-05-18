({
    fetchAccount : function(component, event) {
        var recordId = component.get("v.recordId");
        //alert(recordId);
        var action = component.get("c.getAccount");
        action.setParams({"quoId" : recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            //alert(response.getReturnValue());
            if(state === "SUCCESS")
            {
                var acc = response.getReturnValue();
                var acco= acc.split(";");
                //alert('return:'+acco[0]+acco[1]);
                component.set('v.AccountId',acco[0]);
                component.set('v.AvailablePrimary',acco[1]);
                for(var i = 0 ; i< 6 ; i++){
                    //alert('inside');
                    this.createContactData(component, event);
                }
                component.set('v.quoteContactcreationflag',true);
            }
            else{
                var showToast = $A.get('e.force:showToast');
                showToast.setParams(
                    {
                        'message': 'Exception Occured',
                        'type' : 'error',
                        'duration' : 10000
                    }
                ); 
                showToast.fire();
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": recordId,
                    "slideDevName": "related"
                });
                navEvt.fire();
            }
            
        });
        $A.enqueueAction(action);
    },
    createContactData: function(component, event) {
        // get the UserList from component and add(push) New Object to List  
        var RowItemList = component.get("v.contWraplist");
        RowItemList.push({"Cus_Contacts":{"Id":"","Name":""},
                          "consearch":null,"isPrimary":false
                         });
        // set the updated list to attribute (UserList) again    
        component.set("v.contWraplist", RowItemList);
    },
    cancelContact : function(component, event) {
        component.set("v.quoteContactcreationflag", false);
        
        var urlEvt = $A.get("e.force:navigateToURL");
        urlEvt.setParams({
            "url": '/' + component.get("v.recordId")
        });
        urlEvt.fire();
        component.destroy();        
    },
    validateSave: function(component, event){
        var msg;
        component.set("v.disbutton", true);
        component.set("v.conError", false);
        var AvailablePrimary = component.get("v.AvailablePrimary");
        //alert('AvailablePrimary::> '+AvailablePrimary);
        var val = true;
        var valsearch = false;
        var istoast=false;
        var count = 0;
        var rec = 0;
        var user_list = [];
        user_list = component.get("v.contWraplist");
        for(var i=0; i<user_list.length; i++){
            
            if(user_list[i].consearch!=null&&user_list[i].consearch!=''&&user_list[i].consearch!=undefined)
            {
                valsearch=true; 
            }
            if(user_list[i].Cus_Contacts.Id!='' && user_list[i].Cus_Contacts.Id!=null && user_list[i].Cus_Contacts.Id!=undefined)
            {
                rec = rec+1;
                if(user_list[i].isPrimary){
                    count = count+1;
                }
            }
            else if(user_list[i].isPrimary){
                msg = 'Empty record cannot be selected as primary contact';
                val = false;
            }
        }
        if((count==0 && rec==0) || valsearch){
            istoast=true;
            component.set("v.disbutton", false);
            var showToast = $A.get('e.force:showToast');
            var message='';
            if(valsearch)
                message='Please select a valid Customer Contact';
            
            if(count==0 && rec==0)
                message='Please select at least one Customer contact';
            
            showToast.setParams(
                {
                    'message':message ,
                    'type' : 'Error',
                    'duration' : 10000
                }
            ); 
            showToast.fire();
            val = false;
        }
        if(count>1 && rec>0){
            msg = 'Please select only one primary contact';
            val = false;
        }
        if(count==0 && rec>1 && AvailablePrimary == 'false'){
            msg = 'Please select a primary contact';
            val = false;
        }
        
        if(val == false&&!istoast){
            component.set("v.Error", msg);
            component.set("v.conError", true);
            component.set("v.disbutton", false);
        }
        
        return val;
    },
    saveContact : function(component, event){
        component.set("v.IsSpinner", true);
        component.set("v.disbutton", true);
        component.set("v.has_error", false);
        var recordId = component.get("v.recordId");
        var showToast = $A.get('e.force:showToast');
        var contlist = [];
        contlist = component.get("v.contWraplist");
        //alert(JSON.stringify(contlist));
        for(var i=0; i<contlist.length; i++){
            if(contlist[i].Cus_Contacts.Id!='' && contlist[i].Cus_Contacts.Id!=null && contlist[i].Cus_Contacts.Id!=undefined){
                var reclist = [];
                if(component.get("v.contWraplistFinal").length > 0 )
                    reclist = component.get("v.contWraplistFinal"); 
                reclist.push(contlist[i]);
                component.set("v.contWraplistFinal",reclist);
            }
        }
        var acc = component.get("v.AccountId");
        var cusList = [];
        cusList = component.get("v.contWraplistFinal");
        var saveCustomerContact = component.get("c.saveCustomerContact");
        var listOfCont = JSON.stringify(cusList);
        //alert('listOfCont'+listOfCont);
        saveCustomerContact.setParams({
            "contList": listOfCont,
            "quoteId" : recordId,
            "AccId" : acc
        });
        saveCustomerContact.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === "SUCCESS"){
                showToast.setParams(
                    {
                        'message': 'Customer Contact inserted successfully',
                        'type' : 'success',
                        'duration' : 10000
                    }
                ); 
                showToast.fire();
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": recordId,
                    "slideDevName": "related"
                });
                navEvt.fire();
            }
            else
                console.log('Insert CC failed');
        });
        $A.enqueueAction(saveCustomerContact);
    },
})