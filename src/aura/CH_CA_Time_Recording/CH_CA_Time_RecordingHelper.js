({
    //Initialize time recording component
    init: function(component, event, helper){
        var thisHelper = this;
        var recordId=component.get('v.recordId');
        if(!recordId){
            this.getStartDate(component, event, helper);
            if (component.get("v.mode")=="AddFromList"){
                this.handleAddTimeClick(component, event, helper);
            }
            else{
                this.checkAddTimeButtonApplicability(component,event,helper);
            }            
        }    
        else{
            component.set("v.disableRoleOptions", true);            
            component.set("v.mode",'Edit');
            this.getTimeRecording(component, event, helper);
        }
    },
    
    //Get start date for initial page load
    getStartDate: function(component, event, helper) {     
        let action = component.get('c.getStartDate');               
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.startDate',response.getReturnValue());
            }
        });
        $A.enqueueAction(action);   
    },
    // get time recording data while edit operation
    getTimeRecording: function(component, event, helper){
        //calling method from controller        
        let action = component.get('c.getTimeRecordingListbyId');
        action.setParams({ timeRecordingId: component.get('v.recordId')});        
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //Initialize component value
                var returnValue=response.getReturnValue();                
                var timeSpent= parseInt(returnValue[0].CH_TimeSpent__c);        
                var hours = (timeSpent / 60);
                var rHours = Math.floor(hours);
                var minutes = (hours - rHours) * 60;
                var rMinutes = Math.round(minutes);
                // if (!component.get('v.recordTicketId')){
                component.set('v.recordTicketId',returnValue[0].CH_SupportTicketNumber__c)
                // }                
                var roleOptions = [];
                for (var i = 0; i < returnValue.length; i++) {
                    var item = {
                        "label": returnValue[0].CH_Role__c,
                        "value":returnValue[0].CH_Role__c
                    };
                    roleOptions.push(item);
                } 
                //set role options for time recording
                component.set("v.roleOptions", roleOptions);
                component.set("v.selectedRole",returnValue[0].CH_Role__c);                    
                component.set("v.disableRoleOptions", true);
                component.set("v.recordId",returnValue[0].Id);
                component.set("v.hours",rHours);
                component.set("v.minutes",rMinutes); 
                component.set("v.startDate",returnValue[0].CH_StartDate__c); 
                
                //Open modal/popup box
                component.set("v.isModalOpen", true);
            }
            else {
                var errors = response.getError();                
                this.showToast('error', 'Error','Edit Time Recording  : '+ errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }
        });
        $A.enqueueAction(action);   
    },
    // check Add Time Button Applicability for login user
    checkAddTimeButtonApplicability : function(component, event, helper){
        let action = component.get('c.checkAddTimeButtonApplicability');
        action.setParams({ caseId: component.get('v.recordTicketId')});        
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var buttonDisable=response.getReturnValue(); 
                //enable/disable Add Time button as per return value
                component.set("v.viewTimeTracking",buttonDisable);                               
            }
            else {
                var errors = response.getError();                
                this.showToast('error', 'Error','Time Recording : '+ errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }
        });
        $A.enqueueAction(action);   
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
    // modal open for Add time recording and initialize data
    handleAddTimeClick: function(component, event, helper){         
        let action = component.get('c.getUserRole');
        action.setParams({ caseId: component.get('v.recordTicketId')});        
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue=response.getReturnValue();
                var roleOptions = [];
                for (var i = 0; i < returnValue.length; i++) {
                    var item = {
                        "label": returnValue[i].toString(),
                        "value": returnValue[i].toString()
                    };
                    roleOptions.push(item);
                } 
                //set role options for time recording
                component.set("v.roleOptions", roleOptions);
                if (roleOptions.length==1){
                    component.set("v.selectedRole",roleOptions[0].value);                    
                    component.set("v.disableRoleOptions", true);                    
                }
                else if(roleOptions.length>1){
                    component.set("v.disableRoleOptions", false);
                }
                //Open modal/popup box
                component.set("v.isModalOpen", true);
            }
            else {
                var errors = response.getError();                
                this.showToast('error', 'Error','Time Recording : '+ errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }
        })
        $A.enqueueAction(action);         
    },
    //Add time recording function to save data
    saveTime: function(component, event, helper){        
        var role,hours,minutes,startDate;
        role=component.get("v.selectedRole");
        hours=(!component.find("hours").get("v.value"))?0:component.find("hours").get("v.value");
        minutes=(!component.find("minutes").get("v.value"))?0:component.find("minutes").get("v.value");
        var format = "yyyy-MM-dd HH:mm:ss";
        var langLocale = $A.get("$Locale.langLocale");
        var timezone = $A.get("$Locale.timezone");
        var date = new Date(component.get("v.startDate"));
        $A.localizationService.UTCToWallTime(date, timezone, function(walltime) {           
            startDate = $A.localizationService.formatDateTimeUTC(walltime, format, langLocale);
        });
	
        let action = component.get('c.saveTimeRecording');
        action.setParams({ caseId: component.get('v.recordTicketId'),
                          role: role,
                          hours: hours,
                          minutes: minutes,
                          startDate:startDate }
                        );        
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue=response.getReturnValue();
                this.showToast('success',"Success"," Data saved successfully.") ;
                component.set("v.isModalOpen", false);  
                if ( component.get("v.mode")=='AddFromList'){
                    this.closeConsoleTAB(component,'save');                   
                }else{
                    $A.get('e.force:refreshView').fire();
                }
            }
            else {
                var errors = response.getError();                
                this.showToast('error', 'Error','Time Recording : '+ errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }
        })
        $A.enqueueAction(action);         
    },
    //Edit time recording function to save data
    editTime: function(component, event, helper){        
        var role,hours,minutes,startDate;
        role=component.get("v.selectedRole");
        hours=(!component.find("hours").get("v.value"))?0:component.find("hours").get("v.value");
        minutes=(!component.find("minutes").get("v.value"))?0:component.find("minutes").get("v.value");   
        var format = "yyyy-MM-dd HH:mm:ss";
        var langLocale = $A.get("$Locale.langLocale");
        var timezone = $A.get("$Locale.timezone");
        var date = new Date(component.get("v.startDate"));
        $A.localizationService.UTCToWallTime(date, timezone, function(walltime) {            
            startDate = $A.localizationService.formatDateTimeUTC(walltime, format, langLocale);
        });
        let action = component.get('c.editTimeRecording');
        action.setParams({ Id: component.get('v.recordId'),
                          role: role,
                          hours: hours,
                          minutes: minutes,
                          startDate:startDate}
                        );        
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue=response.getReturnValue();
                this.showToast('success',"Success"," Data updated successfully.") ;
                component.set("v.isModalOpen", false);
                //$A.get('e.force:refreshView').fire();
                this.closeConsoleTAB(component,'save');
                
            }
            else {
                var errors = response.getError();                
                this.showToast('error', 'Error','Time Recording : '+ errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }
        })
        $A.enqueueAction(action);         
    },        
    // Close the current tab that was created for editing or creating a workgroup member
    closeConsoleTAB: function(component,param) {       
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
            if (response.isSubtab && param=='save'){
                var refreshParentTab=response.parentTabId;
                workspaceAPI.refreshTab({
                    tabId: refreshParentTab                    
                });
            }            
        })
        .catch(function(error) {
            console.log("CH_CA:closeConsoleTAB Error:"+ error);
        });
    },
})