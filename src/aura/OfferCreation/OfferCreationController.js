({
    doInit : function(component, event, helper) {
        component.set("v.offerCreationFlag", false);
        var pageReference = component.get("v.pageReference");
        if(pageReference!==undefined && pageReference!==null && pageReference.state!=null){
            
            var recordId=pageReference.state.c__recordId;
            component.set("v.recordId",recordId);
            if(recordId==undefined || recordId==null){  //if null means that was opened in the oppty, !=null was from the offer teams edit
                
                // Prepare the action to load Opportunity record
                var action = component.get("c.getOppty");
                action.setParams({"opptyId": component.get("v.opptyId")});
                var G4PlannedDate,G3PlannedDate,G5PlannedDate;
            }
            
            if(recordId==undefined || recordId==null){
                // Configure response handler
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if(state === "SUCCESS") {
                        var oppty = response.getReturnValue();
                        if(oppty.Business_Type__c === 'Fast Track Opportunity'){
                            helper.fastTrackOppty(component, event, helper);
                        }
                        component.set("v.offerCreationFlag", true);
                        console.log('Oppty data: ' + JSON.stringify(response.getReturnValue()));
                        component.set("v.currentOppty", response.getReturnValue());
                        component.set("v.G4PlannedDate",oppty.G4_Planned_Date__c);
                        component.set("v.G3PlannedDate",oppty.G3_Planned_Date__c);
                        component.set("v.G5PlannedDate",oppty.G5_Planned_Date__c);
                        component.set("v.G4PlannedDateOLD",oppty.G4_Planned_Date__c);
                        component.set("v.G3PlannedDateOLD",oppty.G3_Planned_Date__c);
                        component.set("v.G5PlannedDateOLD",oppty.G5_Planned_Date__c);
                        var g3flag = oppty.Gate_3_Bypass_no_offer_support__c;
                        component.set("v.g3BypassFlag", g3flag);
                        if(oppty.Account.Customer_Compliance__c == 'US_Govern')
                        {
                            component.set("v.NSACompliance",true);
                        }
                    } else {
                        console.log('Problem getting oppty data ' + state);
                    }
                });
                $A.enqueueAction(action);
                
            }else{
                var loaLevels = component.get("v.loaLevels");
                var loaLevelsSelected = [];
                Object.keys(loaLevels).forEach(key => {
                    loaLevelsSelected.push(loaLevels[key]);
                });
                    component.set("v.loaLevels", loaLevelsSelected);
                    var actionOfferTeam = component.get("c.getOfferTeam");
                    actionOfferTeam.setParams({"offerId": recordId});
                // Configure response handler
                actionOfferTeam.setCallback(this, function(response) {
                    var state = response.getState();
                    if(state === "SUCCESS") {
                        console.log('Offer Team Data: ' + JSON.stringify(response.getReturnValue()));
                        component.set("v.wrapper",response.getReturnValue());
                        component.set("v.offerCreationFlag", false);
                        component.set("v.offerTeamCreationFlag", true);
                        console.log('length'+response.getReturnValue().length);
                        var offTeam = component.get("v.wrapper");
                        if(offTeam != undefined && offTeam != null && offTeam != ''){
                            var lengthOfTeam = component.get("v.wrapper").length;
                            console.log('lengthOfTeam'+lengthOfTeam);
                            if(lengthOfTeam < 8){
                                for(var i = 0 ; i< (8-lengthOfTeam) ; i++){
                                    helper.createObjectData(component, event);
                                }
                            }
                        }else{
                            for(var i = 0 ; i< 8 ; i++){
                                helper.createObjectData(component, event);
                            }
                        }
                    } else {
                        console.log('Problem getting offer Team ' + state);
                    }
                });
                $A.enqueueAction(actionOfferTeam);
            }
        };
    },
    handleNext: function(component, event, helper) {
        
        var btn = event.getSource();
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
        
        if (dd < 10) {
            dd = '0' + dd;
        }
        
        if (mm < 10) {
            mm = '0' + mm;
        }
        
        today = yyyy + '-' + mm + '-' + dd;
        helper.validateRequiredFields( component );
        
        
        console.log(component.get("v.has_error"));
        if(component.get("v.has_error") == true ){
            document.getElementById('scrollable_div').scrollTop = 0;
            return;
        }
        
        var g3PlannedPast = component.get("v.G3PlannedDate") != component.get("v.G3PlannedDateOLD")  && component.get("v.G3PlannedDate") < today;//checks if in the past, but only if changed
        var g4PlannedPast = component.get("v.G4PlannedDate") < today; //can never be in the past
        var winDeclPlannedPast = component.get("v.G5PlannedDate") != component.get("v.G5PlannedDateOLD") && component.get("v.G5PlannedDate") < today;//checks if in the past if changed (also enforced by G4 planned date as need to be sequential) 
        var notSequentialDates = component.get("v.G4PlannedDate") < component.get("v.G3PlannedDate") || component.get("v.G4PlannedDate") > component.get("v.G5PlannedDate"); // G3 <= G4 <= WD
        
        if( g3PlannedPast || g4PlannedPast || winDeclPlannedPast ||  notSequentialDates )
        {
            component.set("v.has_error", true);
            component.set("v.errors", 'Error : The Gate Planned Date entered is either blank, in the past, precedes the date entered for the previous gate or exceeds the date entered for the following gate');
            return;
        }else
            component.set("v.has_error", false);
        
        
        component.set("v.newOffer.Opportunity__c",component.get("v.currentOppty.Id"));
        
        var actionOpptyTeam = component.get("c.getOpptyTeam");
        actionOpptyTeam.setParams({"opptyId": component.get("v.opptyId")});
        // Configure response handler
        actionOpptyTeam.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                console.log('Oppty Team Data: ' + JSON.stringify(response.getReturnValue()));
                component.set("v.wrapper",response.getReturnValue());
                component.set("v.offerCreationFlag", false);
                component.set("v.offerTeamCreationFlag", true);
                console.log('length'+response.getReturnValue().length);
                var oppTeam = component.get("v.wrapper");
                if(oppTeam != undefined && oppTeam != null && oppTeam != ''){
                    var lengthOfTeam = component.get("v.wrapper").length;
                    console.log('lengthOfTeam'+lengthOfTeam);
                    if(lengthOfTeam < 8)
                    {
                        for(var i = 0 ; i< (8-lengthOfTeam) ; i++){
                            helper.createObjectData(component, event);
                        }
                    }
                }else
                {
                    for(var i = 0 ; i< 8 ; i++){
                        helper.createObjectData(component, event);
                    }
                }
                
                var MSG = $A.get("$Label.c.Offer_Team_creation_warning_message");
                component.set("v.mylabel", MSG);
                var resultsToastWarning = $A.get("e.force:showToast");
                resultsToastWarning.setParams({
                    'message': MSG,
                    'type' : 'warning',
                    'duration' : 10000
                });
                //$A.get("e.force:closeQuickAction").fire();
                resultsToastWarning.fire();
            } else {
                console.log('Problem getting oppty Team ' + state);
            }
        });
        $A.enqueueAction(actionOpptyTeam);
    },
    
    
    handleCancel: function(component, event, helper) {
        component.set("v.offerCreationFlag", false);
        component.set("v.newOffer",{'sobjectType':'Offer__c',
                                    'Name':'',
                                    'Customer_Offer_Due_Date__c':'',
                                    'Opportunity':''
                                   });
        component.set("v.wrapper", null );
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/' + component.get("v.opptyId")
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();
        component.destroy();
    },
    
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.offerCreationFlag", true);
    },
    
    closeOfferCreation: function(component, event, helper) {
        component.set("v.offerCreationFlag", false);
        component.set("v.newOffer",{'sobjectType':'Offer__c',
                                    'Name':'',
                                    'Customer_Offer_Due_Date__c':'',
                                    'Opportunity':''
                                   });
        component.set("v.wrapper", null );
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/' + component.get("v.opptyId")
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();
        component.destroy();
    },
    closeOfferTeamCreation: function(component, event, helper) {
        component.set("v.offerCreationFlag", false);
        component.set("v.offerTeamCreationFlag", false);
        component.set("v.newOffer",{'sobjectType':'Offer__c',
                                    'Name':'',
                                    'Customer_Offer_Due_Date__c':'',
                                    'Opportunity':'',
                                    'Expected_loA_Level':''
                                   });
        component.set("v.wrapper", null );
        var recordId = component.get("v.recordId");
        var urlEvent = $A.get("e.force:navigateToURL");
        if(recordId==undefined || recordId==null){
            urlEvent.setParams({
                "url": '/' + component.get("v.opptyId")
            });
        }else{
            urlEvent.setParams({
                "url": '/' + component.get("v.recordId")
            });
        }
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();
        component.destroy();
    },
    
    handleSave: function(component, event, helper) {
        component.set("v.saveClicked",true);
        var teamValidated = helper.validateTeam(component);
        if(teamValidated)
        {
            helper.removeEmptyKeyRoles(component);
            helper.saveOffer(component);
        }
        else
        {
            component.set("v.saveClicked",false);
        }
    },
    
    // function for create new object Row in Contact List
    addNewRow: function(component, event, helper) {
        // call the comman "createObjectData" helper method for add new Object Row to List
        helper.createObjectData(component, event);
    },
    
    // function for delete the row
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute
        var index = event.getParam("indexVar");
        // get the all List (contactList attribute)
        var AllRowsList = component.get("v.wrapper");
        //check if offer teams already exists and deletes de record, if not just splices the list
        if(AllRowsList[index].offerteamId != null || AllRowsList[index].offerTeamId != ''){
            var deleteRecord = component.get("c.deleteRowFromList");
            deleteRecord.setParams({"offerTeamId": AllRowsList[index].offerTeamId});
            deleteRecord.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    //in case that state is error, user knows that the row wasn't elemenated
                    //AllRowsList.splice(index, 1);
                } else {
                    console.log('Problem deleting Offer Team record, response state: ' + state);
                }
            });
            $A.enqueueAction(deleteRecord);
        }//else{
        AllRowsList.splice(index, 1);
        //}
        // set the contactList after remove selected row element
        component.set("v.wrapper", AllRowsList);
    },
    
})