({
    createObjectData: function(component, event) {
        // get the contactList from component and add(push) New Object to List
        var RowItemList = component.get("v.wrapper");
        RowItemList.push({
            'sobjectType': 'OfferTeamWrapper',
            'offerTeamId': '',
            'userName': '',
            'isActiveUser': true,
            'teamRole': '',
            'userId': '',
            'additionalTeamRole':'',
            'isKeyRole': false,
            'offerAccess':''
        });
        // set the updated list to attribute (contactList) again
        component.set("v.wrapper", RowItemList);
    },

    validateRequiredFields: function(component) {

        var flag = false;
        var errorMessages = 'Required fields are missing: [ ';
        var missing = [];

        if( $A.util.isUndefined(component.find('offerName').get('v.value')) ||
           $A.util.isEmpty(component.find('offerName').get('v.value')) ){
            missing.push('Offer Name');
            flag = true;
        }

        if( $A.util.isUndefined(component.find('G3Planned').get('v.value')) ||
           $A.util.isEmpty(component.find('G3Planned').get('v.value'))){
            missing.push('G3 Planned Date');
            flag = true;
        }

        if( $A.util.isUndefined(component.find('G4Planned').get('v.value')) ||
           $A.util.isEmpty(component.find('G4Planned').get('v.value'))){
            missing.push('G4 Planned Date');
            flag = true;
        }

        if( $A.util.isUndefined(component.find('G5Planned').get('v.value')) ||
           $A.util.isEmpty(component.find('G5Planned').get('v.value'))){
            missing.push('G5 Planned Date');
            flag = true;
        }

        if( $A.util.isUndefined(component.find('oppty').get('v.value')) ||
           $A.util.isEmpty(component.find('oppty').get('v.value'))){
            missing.push('Opportunity');
            flag = true;
        }

        errorMessages += missing.join(', ') +  ' ]';

        var err= []
        err.push(errorMessages);

        if(flag == true ){
            component.set("v.errors", err);
            component.set("v.has_error", true);

        }else
        {
            component.set("v.errors", err);
            component.set("v.has_error", false);

        }
    },

    removeEmptyKeyRoles: function(component)
    {
        var allRecords = component.get("v.wrapper");
        for(var i = (allRecords.length -1); i >= 0;i--)
        {
            if(allRecords[i].isKeyRole && (allRecords[i].userName == undefined || allRecords[i].userName == null || allRecords[i].userName == ''))
            {
                allRecords.splice(i,1);
            }
        }
        component.set("v.wrapper",allRecords);
    },

    validateTeam: function(component)
    {
        // get all offer team record
        var allRecords = [];
        var allRecords = component.get("v.wrapper");
        console.log('in validate team',allRecords);
        var isValid = true;
        // play a for loop on all OfferTeamWrapper list and check that fields are not null,
        for(var i = 0; i < allRecords.length;i++){
            if(!(allRecords[i].isKeyRole && (allRecords[i].userName == undefined || allRecords[i].userName == null || allRecords[i].userName == '')) ){
                if((allRecords[i].userName != undefined && allRecords[i].userName != null && allRecords[i].userName != '') ||
                   (allRecords[i].teamRole != undefined && allRecords[i].teamRole != null && allRecords[i].teamRole != '' && allRecords[i].teamRole != '--None--') ||
                   (allRecords[i].additionalTeamRole != undefined && allRecords[i].additionalTeamRole != null && allRecords[i].additionalTeamRole != '' ) ||
                   (allRecords[i].offerAccess != undefined && allRecords[i].offerAccess != null && allRecords[i].offerAccess != '' && allRecords[i].offerAccess != '--None--')){


                    if(allRecords[i].teamRole == null || allRecords[i].teamRole == '' || allRecords[i].teamRole == undefined){
                        if(isValid){
                            var showToast = $A.get('e.force:showToast');
                            showToast.setParams({
                                message: 'Row No ' + (i+1) + ' : Please select Team Role.' ,
                                type: 'error',
                                duration: '10000'
                            });
                            showToast.fire();
                            isValid = false;
                        }
                    }else if(allRecords[i].teamRole == '--None--'){
                        if(isValid){
                            var showToast = $A.get('e.force:showToast');
                            showToast.setParams({
                                message: 'Row No ' + (i+1) + ' : Please select Team Role.' ,
                                type: 'error',
                                duration: '10000'
                            });
                            showToast.fire();
                            isValid = false;
                        }
                    }else if(allRecords[i].userId == null || allRecords[i].userId == '' || allRecords[i].userName == undefined){
                        if(isValid){
                            var showToast = $A.get('e.force:showToast');
                            showToast.setParams({
                                message: 'Row No ' + (i+1) + ' : Please Select User.' ,
                                type: 'error',
                                duration: '10000'
                            });
                            showToast.fire();
                            isValid = false;
                        }
                    }else if(allRecords[i].isActiveUser == false){
                        if(isValid){
                            var showToast = $A.get('e.force:showToast');
                            showToast.setParams({
                                message: 'Row No ' + (i+1) + ' : Please Select an Active User or remove the line from the list.' ,
                                type: 'error',
                                duration: '10000'
                            });
                            showToast.fire();
                            isValid = false;
                        }
                    }else if(allRecords[i].offerAccess == null || allRecords[i].offerAccess == '' || allRecords[i].offerAccess == undefined){
                        if(isValid){
                            var showToast = $A.get('e.force:showToast');
                            showToast.setParams({
                                message: 'Row No ' + (i+1) + ' : Please select Offer Access.' ,
                                type: 'error',
                                duration: '10000'
                            });
                            showToast.fire();
                            isValid = false;
                        }
                    }else if(allRecords[i].offerAccess == '--None--'){
                        if(isValid){
                            var showToast = $A.get('e.force:showToast');
                            showToast.setParams({
                                message: 'Row No ' + (i+1) + ' : Please select Offer Access.' ,
                                type: 'error',
                                duration: '10000'
                            });
                            showToast.fire();
                            isValid = false;
                        }
                    }else if(allRecords[i].additionalTeamRole != null && allRecords[i].additionalTeamRole != '' && allRecords[i].additionalTeamRole != undefined ){
                        var addTeamRole = allRecords[i].additionalTeamRole;
                        var addTeamRoleSet = addTeamRole.split(';');
                        console.log('addTeamRoleSet',addTeamRoleSet);
                        if(addTeamRoleSet.includes(allRecords[i].teamRole))
                        {
                            if(isValid){
                                var showToast = $A.get('e.force:showToast');
                                showToast.setParams({
                                    message: 'Row No ' + (i+1) + ' : Team Role and Additional Team Role cannot be Same.' ,
                                    type: 'error',
                                    duration: '10000'
                                });
                                showToast.fire();
                                isValid = false;
                            }
                        }
                    } if(isValid && component.get("v.NSACompliance") && allRecords[i].nsaCompliant != true)
                    {
                        console.log('allRecords[i].nsaCompliant',allRecords[i].nsaCompliant);
                        if(isValid){
                            var showToast = $A.get('e.force:showToast');
                            showToast.setParams({
                                message: 'Row No ' + (i+1) + ' :: New team member should be NSA compliant.' ,
                                type: 'error',
                                duration: '10000'
                            });
                            showToast.fire();
                            isValid = false;
                        }
                    }
                }
            }
        }
        return isValid;
    },

    saveOffer : function(component){
        component.set("v.IsSpinner",true);
        var recordId = component.get("v.recordId");
        var allRecords = [];
        var allRecords = component.get("v.wrapper");
        var userList  = [];
        console.log('in save offer',allRecords);

        for(var i = 0; i < allRecords.length;i++){
            if(allRecords[i].teamRole != null && allRecords[i].teamRole != ''
               && allRecords[i].teamRole != undefined && (allRecords[i].teamRole == 'Pricing Manager' || allRecords[i].teamRole == 'Pricing Manager (Lead)')){
                userList.push(allRecords[i]);
            }else if(allRecords[i].additionalTeamRole != null && allRecords[i].additionalTeamRole != ''
                     && allRecords[i].additionalTeamRole != undefined ){
                var addTeamRole = allRecords[i].additionalTeamRole;
                var addTeamRoleSet = addTeamRole.split(';');
                console.log('addTeamRoleSet',addTeamRoleSet);
                if(addTeamRoleSet.includes('Pricing Manager'))
                {
                    userList.push(allRecords[i]);
                }
            }
        }
        if( userList.length > 0){
            var Action = component.get("c.offerTeamPrMValidation");
            var varOpptyId = component.get("v.opptyId");
            if(varOpptyId == undefined){
                varOpptyId = null;
            }else if(recordId == undefined || recordId == null){
                recordId = null;
            }
            var userListFinal = JSON.stringify(userList);
            Action.setParams({
                "offTeamList" : userListFinal ,
                "opptyId" : varOpptyId,
                "recordId" : recordId
            });
            Action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    var pricingManagerList = [];
                    pricingManagerList = response.getReturnValue();
                    if(  typeof pricingManagerList != "undefined" && pricingManagerList != null
                       && pricingManagerList.length != null && pricingManagerList.length > 0){
                        component.set("v.IsSpinner",false);
                        for(var i = 0; i < pricingManagerList.length;i++){

                            var resultsToast = $A.get("e.force:showToast");
                            resultsToast.setParams({
                                message: 'The User: '+pricingManagerList[i].userName + ' you are trying to add to the Offer Team is not a Pricing Manager / Pricing Manager (Lead).',
                                duration: '10000',
                                type: 'error'
                            });
                            resultsToast.fire();
                            component.set("v.saveClicked",false);
                        }
                    }else if(recordId == undefined || recordId == null){

                        var allRecordsList = component.get("v.wrapper");
                        for(var i = 0; i < allRecords.length;i++){
                            if((allRecordsList[i].userName != undefined && allRecordsList[i].userName != null && allRecordsList[i].userName != '') &&
                               (allRecordsList[i].teamRole != undefined && allRecordsList[i].teamRole != null && allRecordsList[i].teamRole != '' && allRecords[i].teamRole != '--None--') &&
                               (allRecordsList[i].offerAccess != undefined && allRecordsList[i].offerAccess != null && allRecordsList[i].offerAccess != '' && allRecords[i].offerAccess != '--None--')){
                                var recordList = [];
                                if(component.get("v.wrapperListFinal").length > 0 ){
                                    recordList = component.get("v.wrapperListFinal");
                                }
                                recordList.push(allRecords[i]);
                                component.set("v.wrapperListFinal",recordList);
                            }
                        }
                        var offerId;
                        var saveOfferAction = component.get("c.saveOffer");
                        saveOfferAction.setParams({
                            "offerRec": component.get("v.newOffer")
                        });
                        // Saving offer
                        saveOfferAction.setCallback(this, function(response) {
                            var state = response.getState();
                            if(state === "SUCCESS") {
                                console.log('In success');
                                offerId = response.getReturnValue();
                                console.log('offerId.length',offerId.length);

                                if(offerId.length == 18){
                                    console.log('offerId saved');
                                    console.log('new offer saved');
                                    var offerRec = component.get("v.newOffer");
                                    component.set("v.offerId",offerId);
                                    // Saving offer Team
                                    var offerTeam = [];
                                    offerTeam = component.get("v.wrapperListFinal");
                                    var saveOfferTeamAction = component.get("c.saveOfferTeam");
                                    var listOfTeam =JSON.stringify(offerTeam);
                                    saveOfferTeamAction.setParams({
                                        "wrapperList": listOfTeam,
                                        "newOfferId" : offerId
                                    });

                                    saveOfferTeamAction.setCallback(this, function(response) {
                                        var state = response.getState();
                                        if(state === "SUCCESS") {
                                            var opptyData = component.get("v.currentOppty");

                                            var actionOpptySave = component.get("c.saveOppty");
                                            var opptyWithNewDate = component.get("v.currentOppty");
                                            opptyWithNewDate["G3_Planned_Date__c"] =  component.get("v.G3PlannedDate");
                                            opptyWithNewDate["G4_Planned_Date__c"] =  component.get("v.G4PlannedDate");
                                            opptyWithNewDate["G5_Planned_Date__c"] =  component.get("v.G5PlannedDate");
                                            actionOpptySave.setParams({"opptyRec": opptyWithNewDate});
                                            actionOpptySave.setCallback(this, function(response) {
                                                var stateOppty = response.getState();

                                                if(stateOppty === "SUCCESS") {
                                                    var messageReturned = response.getReturnValue();
                                                    console.log('Returned message ' + messageReturned);
                                                    if(messageReturned == 'Success'){

                                                    }
                                                    else  {
                                                        component.set("v.saveClicked",false);
                                                        var resultsToastWarning = $A.get("e.force:showToast");
                                                        resultsToastWarning.setParams({
                                                            'message': messageReturned,
                                                            'type' : 'Error',
                                                            'duration' : 10000
                                                        });
                                                        resultsToastWarning.fire();

                                                    }

                                                }
                                            });
                                            $A.enqueueAction(actionOpptySave);

                                            console.log('Offer Team Saved');

                                            var resultsToast = $A.get("e.force:showToast");
                                            resultsToast.setParams({
                                                message: 'Offer created successfully.',
                                                messageTemplate: 'Offer {0} created successfully.',
                                                messageTemplateData: [
                                                    { url: '/' + offerId,
                                                     label: offerRec.Name
                                                    }
                                                ],
                                                duration: '5000',
                                                type: 'success'
                                            });
                                            resultsToast.fire();
                                            var navEvt = $A.get("e.force:navigateToSObject");
                                            navEvt.setParams({
                                                "recordId": component.get("v.opptyId"),
                                                "slideDevName": "detail"
                                            });
                                            navEvt.fire();
                                            $A.get('e.force:refreshView').fire();
                                            component.destroy();
                                        }
                                        else if(state === "ERROR"){
                                            component.set("v.saveClicked",false);
                                        }else if (status === "INCOMPLETE") {
                                            component.set("v.saveClicked",false);
                                            console.log('No response from server or client is offline.');
                                        }
                                    });
                                    // Send the request to create the new offer Team
                                    $A.enqueueAction(saveOfferTeamAction);
                                }
                                else{
                                    component.set("v.IsSpinner",false);
                                    var resultsToast = $A.get("e.force:showToast");
                                    resultsToast.setParams({
                                        message: offerId,
                                        type : 'Error',
                                        duration : '10000'
                                    });
                                    // Update the UI: close panel, show toast,
                                    $A.get("e.force:closeQuickAction").fire();
                                    resultsToast.fire();

                                }
                            }
                            else if (state === "ERROR") {
                                component.set("v.saveClicked",false);
                            }
                                else {
                                    component.set("v.saveClicked",false);
                                    console.log('Unknown problem, response state: ' + state);
                                }
                        });
                        // Send the request to create the new offer
                        $A.enqueueAction(saveOfferAction);



                    }else{
                        for(var i = 0; i < allRecords.length;i++){
                            if((allRecords[i].userName != undefined && allRecords[i].userName != null && allRecords[i].userName != '') &&
                               (allRecords[i].teamRole != undefined && allRecords[i].teamRole != null && allRecords[i].teamRole != '' && allRecords[i].teamRole != '--None--') &&
                               (allRecords[i].offerAccess != undefined && allRecords[i].offerAccess != null && allRecords[i].offerAccess != '' && allRecords[i].offerAccess != '--None--')){
                                var recordList = [];
                                if(component.get("v.wrapperListFinal").length > 0 ){
                                    recordList = component.get("v.wrapperListFinal");
                                }
                                recordList.push(allRecords[i]);
                                component.set("v.wrapperListFinal",recordList);
                            }
                        }
                        // Saving offer Team
                        var offerListWrapper = component.get('v.wrapperListFinal');
                        var saveOfferTeamAction = component.get("c.saveOfferTeam");
                        var listOfTeam =JSON.stringify(offerListWrapper);
                        saveOfferTeamAction.setParams({
                            "wrapperList": listOfTeam,
                            "newOfferId" : recordId
                        });

                        saveOfferTeamAction.setCallback(this, function(response) {
                            var state = response.getState();
                            if(state === "SUCCESS") {

                                console.log('Offer Team Saved');
                                var resultsToast = $A.get("e.force:showToast");
                                resultsToast.setParams({
                                    message: 'Offer Team edited successfully.',
                                    duration: '5000',
                                    type: 'success'
                                });
                                resultsToast.fire();
                                var navEvt = $A.get("e.force:navigateToSObject");
                                navEvt.setParams({
                                    "recordId": recordId,
                                    "slideDevName": "detail"
                                });
                                navEvt.fire();
                                $A.get('e.force:refreshView').fire();
                                component.destroy();
                            }else if(state === "ERROR"){
                                component.set("v.saveClicked",false);
                            }else if (status === "INCOMPLETE") {
                                component.set("v.saveClicked",false);
                                console.log('No response from server or client is offline.');
                            }
                        });
                        // Send the request to create the new offer Team
                        $A.enqueueAction(saveOfferTeamAction);
                    }
                }else{
                    component.set("v.saveClicked",false);
                }
            });
            $A.enqueueAction(Action);
        }else if(recordId == undefined || recordId == null) {
            var allRecordsList = component.get("v.wrapper");
            for(var i = 0; i < allRecords.length;i++){
                if((allRecordsList[i].userName != undefined && allRecordsList[i].userName != null && allRecordsList[i].userName != '') &&
                   (allRecordsList[i].teamRole != undefined && allRecordsList[i].teamRole != null && allRecordsList[i].teamRole != '' && allRecords[i].teamRole != '--None--') &&
                   (allRecordsList[i].offerAccess != undefined && allRecordsList[i].offerAccess != null && allRecordsList[i].offerAccess != '' && allRecords[i].offerAccess != '--None--')){
                    var recordList = [];
                    if(component.get("v.wrapperListFinal").length > 0 )
                        recordList = component.get("v.wrapperListFinal");
                    recordList.push(allRecords[i]);
                    component.set("v.wrapperListFinal",recordList);
                }
            }
            var offerId;
            var saveOfferAction = component.get("c.saveOffer");
            saveOfferAction.setParams({
                "offerRec": component.get("v.newOffer")
            });
            // Saving offer
            saveOfferAction.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    console.log('In success');
                    offerId = response.getReturnValue();
                    console.log('offerId.length',offerId.length);
                    if(offerId.length == 18){
                        console.log('offerId saved');
                        var offerRec = component.get("v.newOffer");
                        component.set("v.offerId",offerId);
                        // Saving offer Team
                        var offerTeam = [];
                        offerTeam = component.get("v.wrapperListFinal");
                        var saveOfferTeamAction = component.get("c.saveOfferTeam");
                        var listOfTeam =JSON.stringify(offerTeam);
                        saveOfferTeamAction.setParams({
                            "wrapperList": listOfTeam,
                            "newOfferId" : offerId
                        });

                        saveOfferTeamAction.setCallback(this, function(response) {
                            var state = response.getState();
                            if(state === "SUCCESS") {
                                var opptyData = component.get("v.currentOppty");

                                var actionOpptySave = component.get("c.saveOppty");
                                var opptyWithNewDate = component.get("v.currentOppty");
                                opptyWithNewDate["G3_Planned_Date__c"] =  component.get("v.G3PlannedDate");
                                opptyWithNewDate["G4_Planned_Date__c"] =  component.get("v.G4PlannedDate");
                                opptyWithNewDate["G5_Planned_Date__c"] =  component.get("v.G5PlannedDate");
                                actionOpptySave.setParams({"opptyRec": opptyWithNewDate});
                                actionOpptySave.setCallback(this, function(response) {
                                    var stateOppty = response.getState();

                                    if(stateOppty === "SUCCESS") {
                                        var messageReturned = response.getReturnValue();
                                        console.log('Returned message ' + messageReturned);
                                        if(messageReturned == 'Success'){

                                        }
                                        else  {

                                            var resultsToastWarning = $A.get("e.force:showToast");
                                            resultsToastWarning.setParams({
                                                'message': messageReturned,
                                                'type' : 'Error',
                                                'duration' : 10000
                                            });
                                            resultsToastWarning.fire();

                                        }

                                    }
                                });
                                $A.enqueueAction(actionOpptySave);

                                console.log('Offer Team Saved');

                                var resultsToast = $A.get("e.force:showToast");
                                resultsToast.setParams({
                                    message: 'Offer created successfully.',
                                    messageTemplate: 'Offer {0} created successfully.',
                                    messageTemplateData: [
                                        { url: '/' + offerId,
                                         label: offerRec.Name
                                        }
                                    ],
                                    duration: '5000',
                                    type: 'success'
                                });
                                resultsToast.fire();

                                var navEvt = $A.get("e.force:navigateToSObject");
                                navEvt.setParams({
                                    "recordId": component.get("v.opptyId"),
                                    "slideDevName": "detail"
                                });
                                navEvt.fire();
                                $A.get('e.force:refreshView').fire();
                                component.destroy();
                            }
                            else if(state === "ERROR"){
                                component.set("v.saveClicked",false);
                            }else if (status === "INCOMPLETE") {
                                component.set("v.saveClicked",false);
                                console.log('No response from server or client is offline.');
                            }
                        });
                        // Send the request to create the new offer Team
                        $A.enqueueAction(saveOfferTeamAction);
                    }
                    else{
                        component.set("v.IsSpinner",false);
                        var resultsToast = $A.get("e.force:showToast");
						var errorMsg = offerId;
						if(errorMsg.includes("duplicate value") || errorMsg.includes("unable to obtain")){
							resultsToast.setParams({
									message: 'Another offer is currently being created for the opportunity. Please try again', //01825599
									type : 'Error',
									duration : '10000'
							});
						}else{
							resultsToast.setParams({
								message: offerId,
								type : 'Error',
								duration : '10000'
							});
						}

                        // Update the UI: close panel, show toast,
                        $A.get("e.force:closeQuickAction").fire();
                        resultsToast.fire();

                    }
                }
                else if (state === "ERROR") {
                    component.set("v.saveClicked",false);
                }
                else {
                    component.set("v.saveClicked",false);
                    console.log('Unknown problem, response state: ' + state);
                }
            });
            // Send the request to create the new offer
            $A.enqueueAction(saveOfferAction);
        }else{
            for(var i = 0; i < allRecords.length;i++){
                if((allRecords[i].userName != undefined && allRecords[i].userName != null && allRecords[i].userName != '') &&
                   (allRecords[i].teamRole != undefined && allRecords[i].teamRole != null && allRecords[i].teamRole != '' && allRecords[i].teamRole != '--None--') &&
                   (allRecords[i].offerAccess != undefined && allRecords[i].offerAccess != null && allRecords[i].offerAccess != '' && allRecords[i].offerAccess != '--None--')){
                    var recordList = [];
                    if(component.get("v.wrapperListFinal").length > 0 ){
                        recordList = component.get("v.wrapperListFinal");
                    }
                    recordList.push(allRecords[i]);
                    component.set("v.wrapperListFinal",recordList);
                }
            }
            // Saving offer Team
            var offerListWrapper = component.get('v.wrapperListFinal');
            var saveOfferTeamAction = component.get("c.saveOfferTeam");
            var listOfTeam =JSON.stringify(offerListWrapper);
            saveOfferTeamAction.setParams({
                "wrapperList": listOfTeam,
                "newOfferId" : recordId
            });

            saveOfferTeamAction.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {

                    console.log('Offer Team Saved');
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        message: 'Offer Team edited successfully.',
                        duration: '5000',
                        type: 'success'
                    });
                    resultsToast.fire();
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": recordId,
                        "slideDevName": "detail"
                    });
                    navEvt.fire();
                    $A.get('e.force:refreshView').fire();
                    component.destroy();
                }else if(state === "ERROR"){
                    component.set("v.saveClicked",false);
                }else if (status === "INCOMPLETE") {
                    component.set("v.saveClicked",false);
                    console.log('No response from server or client is offline.');
                }
            });
            // Send the request to create the new offer Team
            $A.enqueueAction(saveOfferTeamAction);
        }
    },


    fastTrackOppty : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Not Allowed",
            "type": "warning",
            "mode": "pester",
            "duration": 10000,
            "message": "Creating a new offer is not allowed for fast track opportunities"
        });
        toastEvent.fire();
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/' + component.get("v.opptyId")
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();
        component.destroy();
    },
})