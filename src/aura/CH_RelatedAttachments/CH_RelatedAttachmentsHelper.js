({
    getAttachments : function(component) {
        const isCommunity = component.get('v.isCommunity');
        this.apexAction(component, 'c.getAttachments', { caseId : component.get('v.recordId'), }, true)
        .then(results => {
            results = results.map((cur) => {
            	cur.URL = isCommunity ? '/customers/s/detail/' + cur.Id : ('/one/one.app?#/sObject/' + cur.Id + '/view');
            	cur.description = 'File: "' + cur.File_Name__c + '"' + (cur.CH_Description__c ? (', Description: "' + cur.CH_Description__c + '"'): '');
            	cur.LogCollectionProcess = cur.CH_AutoLogCollection__c ? 'Automatic' : 'One Touch';
                return cur;
            });
            component.set('v.attachments', results);
            component.set('v.logs', results.filter((cur) => cur.RecordType && cur.RecordType.DeveloperName === 'CH_LogCollection'));
        });
    },
    downloadHandler : function(component, result) {
        if(result[0].exceptionMessage != null && result[0].exceptionMessage != undefined) {
            return this.showToast(component, 'error', 'Error', 'Following exception has occurred. Please contact your System Administrator. ' + result[0].exceptionMessage);
        }
        let capsError = '', capsErrorCount = 0;
        //Open PopUp with download passwords
        for(let i = 0, len = result.length; i < len; i++){
            if(result[i].capsError != undefined) {
                capsError += (capsErrorCount++) + '. FileName: '+result[i].fileName +' - ' + result[i].capsError+';\n ';
            } else if(result[i].downLoadUrl != undefined){
                window.open(result[i].downLoadUrl,"_blank");
            }
        }
        component.set("v.popup", 'download');
        component.set('v.fileInfo', result);
        if(capsError != '') { this.showToast(component, 'error', 'Error', 'Error(s) related to file(s) is displayed below: \n ' + capsError); }
    },
    // Tab
    setTabIcon : function(component) {
        if(component.get('v.viewAll')) {
            let type = component.get("v.type"), workspaceAPI = component.find("Workspace");
            workspaceAPI.getEnclosingTabId().then(function(response) {
                workspaceAPI.setTabLabel({
                    tabId: response,
                    label: type,
                    title: type
                });
                workspaceAPI.setTabIcon({
                    tabId: response,
                    icon: "custom:custom22",
                    iconAlt: type
                }); 
            });
        }
    },
    //
    apexAction: function(component, method, params, handleError) {
        let helper = this, action = component.get(method);
        helper.incrementActionCounter(component);
        return new Promise(function(resolve, reject) { 
        	if(params) action.setParams(params);
        	action.setCallback(helper, function(response) {
                let state = response.getState();
                helper.decrementActionCounter(component);
                if (state === "SUCCESS") {
                    resolve(response.getReturnValue());
                } else {
                    if(handleError) {
                        var error = response.getError();
                        var message =  error && error[0] && error[0].message ? error[0].message : "Something went wrong";
                        helper.showToast(component, 'error', 'Error', message);
                        resolve(null);
                    }
                    else reject(response.getError());
                }
            });
            $A.enqueueAction(action);
        });
    },
    // Generic Toast Message
    showToast: function(component, sType, title, message) {
        const helper = this;
        let showToast = $A.get("e.force:showToast");
        if(showToast) {
            showToast.setParams({
                "title": title,
                "message": message,
                "type": sType
            }).fire();
        }
        else {
            component.set('v.portalToast', {
                "title": title,
                "message": message,
                "type": sType
            });
            clearTimeout(helper.timeout);
            helper.timeout = setTimeout(() => component.set('v.portalToast', null), 5000);
        }
    },
    // Loading Framework
    isLoading: function(component) {
        return component.get("v.showSpinner");
    },
    incrementActionCounter: function(component) {
        var counter = component.get("v.actionCounter") + 1;
        if (counter === 1) {
            component.set("v.showSpinner", true);
        }
        component.set("v.actionCounter", counter);
    },
    decrementActionCounter: function(component) {
        var counter = component.get("v.actionCounter") - 1;
        if (counter === 0) {
            component.set("v.showSpinner", false);
        }
        component.set("v.actionCounter", counter);
    }
})