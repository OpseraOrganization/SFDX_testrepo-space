({
    fetchQuote : function(component, event) {
        var recordId = component.get("v.recordId")
        var action = component.get("c.fetchquoteDetails");
        action.setParams({"quoteId" : recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === "SUCCESS")
            {
                var quo = response.getReturnValue();
                console.log('Quote data: ' + JSON.stringify(response.getReturnValue()));
                component.set('v.quote',response.getReturnValue());
                component.set('v.cosvalue',quo.CQ_Customer_Organization_Segment__c);
                component.set('v.servalue',quo.CQ_Servies_components__c);
                component.set('v.AccountId',quo.Apttus_Proposal__Account__c);
                component.set('v.cqlead',quo.CQ_Lead__c);
                component.set('v.saleslead',quo.CQ_Sales_Lead__c);
                
                var cos = 'CQ_Customer_Organization_Segment__c';
                var getPicklist = component.get("c.fetchpicklistValues");
                getPicklist.setParams({"field" : cos});
                getPicklist.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === "SUCCESS")
                    {
                        var picklist = [];
                        var plvalues = [];
                        picklist = response.getReturnValue();
                        var cosval = component.get("v.cosvalue");
                        if(!$A.util.isUndefined(cosval) && !$A.util.isEmpty(cosval)){
                            plvalues.push({
                                class: "optionClass", label: cosval, value: cosval
                            });
                        }
                        plvalues.push({
                            class: "optionClass", label: "--- None ---", value: ""
                        });
                        for(var i=0;i<picklist.length;i++){
                            plvalues.push({"class": "optionClass", label: picklist[i], value: picklist[i]});
                        }
                        component.set("v.coslist", plvalues);
                    }
                    else
                    {
                        console.log(state);
                    }
                });
                $A.enqueueAction(getPicklist);
                
                var ser = 'CQ_Servies_components__c';
                var getmPicklist = component.get("c.fetchpicklistValues");
                getmPicklist.setParams({"field" : ser});
                getmPicklist.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === "SUCCESS")
                    {
                        var result = response.getReturnValue();
                        var mplValues = [];
                        for (var i = 0; i < result.length; i++) {
                            mplValues.push({
                                label: result[i],
                                value: result[i]
                            });
                        }
                        //alert('mplvalues:::>'+JSON.stringify(mplValues));
                        component.set("v.serlist", mplValues);
                        var sval = component.get("v.servalue");
                        if(!$A.util.isUndefined(sval) && !$A.util.isEmpty(sval))
                        {
                            var mselect = sval.split(';');
                            component.set("v.selectedserlist",mselect);
                        }
                    }
                    else
                    {
                        console.log(state);
                    }
                });
                $A.enqueueAction(getmPicklist);
                
                var getUser = component.get("c.fetchUser");
                //alert('saleslead '+component.get("v.saleslead"));
                getUser.setParams({"cqid" : component.get("v.cqlead"),
                                   "salesid" : component.get("v.saleslead")});
                getUser.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === "SUCCESS")
                    {
                        var quo = response.getReturnValue();
                        if(quo.cqObj!=undefined&&quo.cqObj!=''&&quo.cqObj!=null)
                            component.set('v.selectedCQLeadRecord',quo.cqObj);
                        if(quo.salesObj!=undefined&&quo.salesObj!=''&&quo.salesObj!=null)
                            component.set('v.selectedSalesLeadRecord',quo.salesObj);
                        component.set('v.usersection',true);
                    }
                    else
                    {
                        console.log(state);
                    }
                });
                $A.enqueueAction(getUser);
                
            }
            else
            {
                showToast.setParams(
                    {
                        'message': 'Exception occured',
                        'type' : 'warning',
                        'duration' : 10000
                    }
                ); 
                showToast.fire(); 
            }
        });
        $A.enqueueAction(action);
    },
    
    cancelClone : function(component, event) {
        component.set("v.quotecreationflag", false);
        component.set("v.quote",{'sobjectType' : 'Apttus_Proposal__Proposal__c'});
        
        var urlEvt = $A.get("e.force:navigateToURL");
        urlEvt.setParams({
            "url": '/' + component.get("v.recordId")
        });
        urlEvt.fire();
        component.destroy();        
    },
    
    validateNext : function(component, event) {
        var flag = true;
        var errorMessages = 'Required fields are missing: [ ';
        
        if( $A.util.isUndefined(component.find('quoteName').get('v.value')) ||
           $A.util.isEmpty(component.find('quoteName').get('v.value')) ){
            errorMessages += 'Quote Name, ';
            flag = false;
        }
        if( $A.util.isUndefined(component.find('cqduedate').get('v.value')) ||
           $A.util.isEmpty(component.find('cqduedate').get('v.value')) ){
            errorMessages += 'CQ Due Date ';
            flag = false;
        }
        errorMessages += ' ]';
        
        var err= [] 
        err.push(errorMessages);
        if(flag == false ){
            component.set("v.errors", err);
            component.set("v.has_error", true); 
            component.set("v.disbutton", false);
        }
        return flag;
    },
    
    handlefirstNext : function(component, event) {
        component.set("v.has_error", false)
        var recordId = component.get("v.recordId")
        var getQuoteTeam = component.get("c.getQuoteTeam");
        getQuoteTeam.setParams({"quoId":recordId});
        getQuoteTeam.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS")
            {
                component.set("v.teamWraplist",response.getReturnValue());                
                component.set("v.quotecreationflag", false);
                component.set("v.quoteTeamcreationflag", true);
                var quoTeam = component.get("v.teamWraplist");
                if(quoTeam != undefined && quoTeam != null && quoTeam != ''){
                    var lengthOfTeam = component.get("v.teamWraplist").length;
                    console.log('lengthOfTeam'+lengthOfTeam);
                    if(lengthOfTeam < 8)
                    {
                        for(var i = 0 ; i< (6-lengthOfTeam) ; i++){
                            this.createObjectData(component, event);
                        }
                    }
                }else
                {
                    for(var i = 0 ; i< 6 ; i++){
                        this.createObjectData(component, event);
                    }
                }  
            }
        });
        $A.enqueueAction(getQuoteTeam); 
    },
    
    handleSecondNext : function(component, event) { 
        var recordId = component.get("v.recordId")
        var getCusCon = component.get("c.getCustomerContact");
        getCusCon.setParams({"quoId":recordId});
        getCusCon.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS")
            {
                component.set("v.contWraplist",response.getReturnValue());                
                component.set("v.quoteTeamcreationflag", false);
                component.set("v.quoteContactcreationflag", true);
                var quoTeam = component.get("v.contWraplist");
                
                if(quoTeam != undefined && quoTeam != null && quoTeam != ''){
                    var lengthOfTeam = component.get("v.contWraplist").length;
                    console.log('lengthOfTeam'+lengthOfTeam);
                    if(lengthOfTeam < 8)
                    {
                        for(var i = 0 ; i< (6-lengthOfTeam) ; i++){
                            this.createContactData(component, event);
                        }
                    }
                }else
                {
                    for(var i = 0 ; i< 6 ; i++){
                        this.createContactData(component, event);
                    }
                }  
            }
        });
        $A.enqueueAction(getCusCon); 
    },
    
    validateSave: function(component, event){
        var msg;
        component.set("v.disbutton", true);
        component.set("v.conError", false);
        var val = true;
        var count = 0;
        var rec = 0;
        var user_list = [];
        user_list = component.get("v.contWraplist");
        //alert('user_list'+JSON.stringify(user_list));
        for(var i=0; i<user_list.length; i++){
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
        if(count>1 && rec>0){
            msg = 'Please select only one primary contact';
            val = false;
        }
        if(count==0 && rec>1){
            msg = 'Please select a primary contact';
            val = false;
        }
        if(val == false){
            component.set("v.Error", msg);
            component.set("v.conError", true);
            component.set("v.disbutton", false);
        }
        return val;
    },
    
    saveClone: function(component, event){
        var servalue = component.get("v.selectedserlist");
        component.set("v.quote.CQ_Servies_components__c",servalue);
        component.set("v.IsSpinner", true);
        component.set("v.disbutton", true);
        component.set("v.has_error", false); 
        //var recordId = component.get("v.recordId")
        var quo = component.get("v.quote")
        
        var cloneaction = component.get("c.cloneQuote");
        cloneaction.setParams({"cqquote": quo});
        //alert(quo);
        cloneaction.setCallback(this, function(response){
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS")
            {
                var returned =response.getReturnValue();  
                var showToast = $A.get('e.force:showToast');
                if(returned.includes(' '))
                {
                    component.set("v.IsSpinner", false);
                    component.set("v.quoteContactcreationflag", false);
                    component.set("v.quotecreationflag", true);
                    component.set("v.disbutton", false);
                    component.set("v.has_error", true);
                    component.set("v.errors", returned);
                    return;
                }
                else
                {
                    var ulist = [];
                    ulist = component.get("v.teamWraplist");
                    //alert(JSON.stringify(component.get("v.teamWraplist")));
                    for(var i=0; i<ulist.length; i++){
                        if(ulist[i].Quoteteam.Id!=''&&ulist[i].Quoteteam.Id!=null&&ulist[i].Quoteteam.Id!=undefined){
                            var recordlist = [];
                            if(component.get("v.teamWraplistFinal").length > 0 )
                                recordlist = component.get("v.teamWraplistFinal"); 
                            recordlist.push(ulist[i]);
                            component.set("v.teamWraplistFinal",recordlist);
                        }
                    }
                    
                    var quoteTeam = [];
                    quoteTeam = component.get("v.teamWraplistFinal");
                    var saveQuoteTeam = component.get("c.saveQuoteTeam");
                    var listOfTeam =JSON.stringify(quoteTeam);
                    saveQuoteTeam.setParams({
                        "userList": listOfTeam,
                        "quoteId" : returned,
                        "quote" : quo
                    });
                    saveQuoteTeam.setCallback(this, function(response){
                        var state = response.getState();
                        //alert(JSON.stringify(response.getState()));
                        if(state === "SUCCESS"){                            
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
                                "quoteId" : returned,
                                "AccId" : acc
                            });
                            saveCustomerContact.setCallback(this, function(response){
                                var state = response.getState();
                                
                                if(state === "SUCCESS"){
                                    showToast.setParams(
                                        {
                                            'message': 'Quote Clone Successful',
                                            'type' : 'success',
                                            'duration' : 10000
                                        }
                                    ); 
                                    showToast.fire();
                                }
                                else
                                    console.log('Insert CC failed');
                            });
                            $A.enqueueAction(saveCustomerContact);   
                        }
                        else
                            console.log('Insert QT failed');
                    });
                    $A.enqueueAction(saveQuoteTeam);
                    
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": returned,
                        "slideDevName": "related"
                    });
                    navEvt.fire();
                }
            }
            else
                console.log('Insert Quote Failed');
        });
        $A.enqueueAction(cloneaction);       
    },
    
    createObjectData: function(component, event) {
        // get the UserList from component and add(push) New Object to List  
        var RowItemList = component.get("v.teamWraplist");
        RowItemList.push({"Quoteteam":{"Id":"","Name":""}
                         });
        // set the updated list to attribute (UserList) again    
        component.set("v.teamWraplist", RowItemList);
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
    
    firstBack: function(component, event){
        component.set("v.quoteTeamcreationflag", false);
        component.set("v.quotecreationflag", true);
    },
    
    SecondBack: function(component, event){
        component.set("v.quoteContactcreationflag", false);
        component.set("v.quoteTeamcreationflag", true);
    },
})