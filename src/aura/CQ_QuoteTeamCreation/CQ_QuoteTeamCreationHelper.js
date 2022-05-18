({
    createObjectData: function(component, event) {
        // get the UserList from component and add(push) New Object to List  
        var RowItemList = component.get("v.teamWraplist");
        RowItemList.push({"Quoteteam":{"Id":"","Name":""}
                         });
        // set the updated list to attribute (UserList) again    
        component.set("v.teamWraplist", RowItemList);
    },
    
    cancelQT : function(component, event) {
        component.set("v.quoteTeamcreationflag", false);
        
        var urlEvt = $A.get("e.force:navigateToURL");
        urlEvt.setParams({
            "url": '/' + component.get("v.recordId")
        });
        urlEvt.fire();
        component.destroy();
    },
    
    saveQuoteTeam : function(component, event) {
        var recordId = component.get("v.recordId");
        var showToast = $A.get('e.force:showToast');
        var ulist = [];
        var tobesave=true;
        var msg='';
        var empty = [];
        ulist = component.get("v.teamWraplist");
        component.set("v.teamWraplistFinal",empty);
        //alert(component.get("v.teamWraplistFinal"));
        //alert(JSON.stringify(component.get("v.teamWraplist")));
        for(var i=0; i<ulist.length; i++){
            if(ulist[i].Quoteteam.Id!=''&&ulist[i].Quoteteam.Id!=null&&ulist[i].Quoteteam.Id!=undefined)
            {
             var recordlist = [];
             if(component.get("v.teamWraplistFinal").length > 0 )
                 recordlist = component.get("v.teamWraplistFinal"); 
             recordlist.push(ulist[i]);
             component.set("v.teamWraplistFinal",recordlist);
                
            }
            else if(ulist[i].usersearch!=undefined&&ulist[i].usersearch!=''&&ulist[i].usersearch!=null)
            {
                //alert('inside else if');
                tobesave = false;
                msg = "Please select a valid quote team member";
                
            }
        }
        
        if(tobesave){
            var quoteTeam = [];
            quoteTeam = component.get("v.teamWraplistFinal");
            if(quoteTeam.length > 0){
                //alert('inside save');
                component.set("v.IsSpinner", true);
                component.set("v.disbutton", true);
                var insertQuoteTeam = component.get("c.saveQuoteTeam");
                var listOfTeam =JSON.stringify(quoteTeam);
                insertQuoteTeam.setParams({
                    "userList": listOfTeam,
                    "quoteId" : recordId
                });
                insertQuoteTeam.setCallback(this, function(response){
                    var state = response.getState();
                    //alert(JSON.stringify(response.getState()));
                    if(state === "SUCCESS"){
                        showToast.setParams(
                            {
                                'message': 'Quote Team inserted successfully',
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
                        console.log('Insert QT failed');
                });
                $A.enqueueAction(insertQuoteTeam);
            }
            
            else{
                if(quoteTeam.length == 0)
                    msg='Please select at least one Quote team member';
                showToast.setParams(
                    {
                        'message': msg,
                        'type' : 'Error',
                        'duration' : 10000
                    }
                ); 
                showToast.fire();
            }
        }
        else{
            showToast.setParams(
                {
                    'message': msg,
                    'type' : 'Error',
                    'duration' : 10000
                }
            ); 
            showToast.fire();
        }
    },
})