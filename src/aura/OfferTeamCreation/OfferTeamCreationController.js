({
    
    doInit: function(component, event, helper) {
        // method for get picklist values dynamic   
        helper.fetchPickListVal(component);
    },
    
    handleAdditionTeamRoleChange: function (component, event, helper) {
        //Get the Selected values  
        var selectedValues = event.getParam("value");
        var finalSelectedValues = '';
        for(var i in selectedValues)
        {
            if(finalSelectedValues != '')
            {
                finalSelectedValues = finalSelectedValues+';'+selectedValues[i];
            }else{
                finalSelectedValues = selectedValues[i];
            }
        }
        //var selectedVal = selectedValues.replace(",", ";");
        //console.log('selectedValues'+selectedValues);
        //Update the Selected Values 
        component.set("v.selectedAdditionalTeamMemberRoles", selectedValues);
        component.set("v.singleRec.additionalTeamRole",finalSelectedValues);
    },
    
    inlineEditTeamRole : function(component,event,helper){   
        // show the rating edit field popup 
        component.set("v.teamRoleEditMode", true); 
        // after set ratingEditMode true, set picklist options to picklist field 
        component.find("teamRole").set("v.options" , component.get("v.teamMemberRoles"));
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("teamRole").focus();
        }, 100);
    },
    
    inlineEditAdditionalTeamRole : function(component,event,helper){   
        // show the rating edit field popup 
        component.set("v.additionalTeamRoleEditMode", true); 
        // after set ratingEditMode true, set picklist options to picklist field 
        component.find("addTeamRole").set("v.options" , component.get("v.additionalTeamMemberRoles"));
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("addTeamRole").focus();
        }, 100);
    },
    inlineEditAccess : function(component,event,helper){   
        // show the rating edit field popup 
        component.set("v.accessEditMode", true); 
        // after set ratingEditMode true, set picklist options to picklist field 
        component.find("accessOnTeam").set("v.options" , component.get("v.accessLevels"));
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("accessOnTeam").focus();
        }, 100);
    },
    inlineEditLeadBG : function(component,event,helper){   
        // show the rating edit field popup 
        component.set("v.leadBGEditMode", true); 
        // after set ratingEditMode true, set picklist options to picklist field 
        component.find("leadBG").set("v.options" , component.get("v.leadBGs"));
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("leadBG").focus();
        }, 100);
    },
     onLeadBGChange : function(component,event,helper){ 
        // if picklist value change,
        // then show save and cancel button by set attribute to true
        component.set("v.showSaveCancelBtn",true);
    }, 
    onTeamRoleChange : function(component,event,helper){ 
        // if picklist value change,
        // then show save and cancel button by set attribute to true
		var teamRoleVar = component.get("v.teamRoleMap")[component.find("teamRole").get("v.value")];
        component.set("v.singleRec.teamRoleLabel",teamRoleVar);
        component.set("v.showSaveCancelBtn",true);
    }, 
    onAdditionalTeamRoleChange : function(component,event,helper){ 
        // if picklist value change,
        // then show save and cancel button by set attribute to true
        component.set("v.showSaveCancelBtn",true);
    },
    onAccessChange : function(component,event,helper){ 
        // if picklist value change,
        // then show save and cancel button by set attribute to true
        component.set("v.showSaveCancelBtn",true);
    },    
    closeLeadBGBox : function (component, event, helper) {
        // on focus out, close the input section by setting the 'ratingEditMode' att. as false
        component.set("v.leadBGEditMode", false); 
    },
    closeTeamRoleBox : function (component, event, helper) {
        // on focus out, close the input section by setting the 'ratingEditMode' att. as false
        component.set("v.teamRoleEditMode", false); 
    },
    
    closeAdditionalTeamRoleBox : function (component, event, helper) {
        // on focus out, close the input section by setting the 'ratingEditMode' att. as false
        component.set("v.additionalTeamRoleEditMode", false); 
    },
    
    closeAccessBox : function (component, event, helper) {
        // on focus out, close the input section by setting the 'ratingEditMode' att. as false
        component.set("v.accessEditMode", false); 
    },
    
    // automatically call when the component is done waiting for a response to a server request.  
    hideSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();    
        //alert('Rec Idasd'+ component.get("v.recordId"));
    },
    
    // automatically call when the component is waiting for a response to a server request.
    showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    },
    
    onfocus : function(component,event,helper){
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
        var getInputkeyWord = component.get("v.SearchKeyWord");
        if(getInputkeyWord==null || getInputkeyWord==undefined || getInputkeyWord=='')
         getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
    },
    
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    keyPressController : function(component, event, helper) {
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    // function for clear the Record Selaction 
    clear :function(component,event,heplper){
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRecord", {} ); 
		component.set("v.singleRec.userId","");
        component.set("v.singleRec.userName","");
        component.set("v.singleRec.nsaCompliant","");
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        // get the selected Account record from the COMPONETN event 	 
        var selectedUserFromEvent = event.getParam("recordByEvent");
        console.log('selectedUserFromEvent',selectedUserFromEvent);
        console.log('selectedUserFromEvent.Id',selectedUserFromEvent.Id);
        console.log('selectedUserFromEvent.Name',selectedUserFromEvent.Name);
        component.set("v.selectedRecord" , selectedUserFromEvent); 
        component.set("v.singleRec.userId",selectedUserFromEvent.Id);
        component.set("v.singleRec.isActiveUser",selectedUserFromEvent.IsActive);
        component.set("v.singleRec.userName",selectedUserFromEvent.Name);
        component.set("v.singleRec.nsaCompliant",selectedUserFromEvent.NSA_Compliant__c);
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
        
    },
    AddNewRow : function(component, event, helper){
        // fire the AddNewRowEvt Lightning Event 
        component.getEvent("AddRowEvt").fire();     
    },
    
    removeRow : function(component, event, helper){
        // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
        component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    }, 
    
    showAdditionalRole : function(component, event, helper) {
        window.scrollTo(1000, 0); 
        var lble = component.find("showButton").get("v.title");
        if(lble === 'show'){
            component.set("v.showAddTeam",true);
            component.find("showButton").set("v.title","hide");
        }else {
            component.set("v.showAddTeam",false);
            component.find("showButton").set("v.title","show");
        }
    },
})