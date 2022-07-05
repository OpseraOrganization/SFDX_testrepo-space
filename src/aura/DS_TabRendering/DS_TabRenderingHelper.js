({
    getEntitlementinfo: function (component,event,helper) {
        var newaction = component.get("c.Get_entitlepicklist");
        newaction.setCallback(this, function(response) {
            var state = response.getState();
            if (response.getState() === "SUCCESS") {
                var StoreResponse = response.getReturnValue();
                component.set("v.Entitlementinfo", StoreResponse);
                window.setTimeout(
                    $A.getCallback( function() {
                        if(window.localStorage.getItem("v.selectedentitlementCache") === undefined || window.localStorage.getItem("v.selectedentitlementCache") ===null ||  window.localStorage.getItem("v.selectedentitlementCache") ===''){
                            component.find("Entitlement").set("v.value",'--None--');
                        }
                        else{
                            component.set("v.selectedentitlementCache",localStorage.getItem("v.selectedentitlementCache"));
                            component.find("Entitlement").set("v.value", localStorage.getItem("v.selectedentitlementCache"));
                        }
                    }));
            }	
            
        });
        $A.enqueueAction(newaction);
    },
	
	getTypeinfo: function (component,event,helper) {
        var actionCaseTechPro = component.get("c.Get_typepicklist");
        var optstechpro=[];
        actionCaseTechPro.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){                
                optstechpro.push(a.getReturnValue()[i]);
            }
            component.set("v.Typeinfo",optstechpro);
            
        });
        window.setTimeout(
                    $A.getCallback( function() {
                        if(window.localStorage.getItem("v.selectedTypCache") === undefined || window.localStorage.getItem("v.selectedTypCache") ===null ||  window.localStorage.getItem("v.selectedTypCache") ===''){
                            component.find("Type").set("v.value",'--None--');
                            //alert('in if loop '+ component.find("Type").get("v.value"));
                            
                        }
                        else{
                            component.set("v.selectedTypCache",localStorage.getItem("v.selectedTypCache"));
                            component.find("Type").set("v.value", localStorage.getItem("v.selectedTypCache"));
                           // alert('in if loop '+ component.find("Type").get("v.value"));
                            
                        }
                        
                    }));
        $A.enqueueAction(actionCaseTechPro);
    },
    
    getTechnologyHelper : function(component,event,helper,objDetails,controllerField, dependentField){
        //('Inside getTechnologyHelper');
        //Below code will load the technology value.
        // alert('Inside Technology helper');
        component.set('v.showbutton', false);
        component.set('v.showmessage', false);
        
        component.set('v.DPData', null);
        component.set('v.DigitalProposal', null);
        var newaction = component.get("c.getTechnologies");
        
        
        newaction.setCallback(this, function(response) {
            var state = response.getState();
            
            if (response.getState() === "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                
                component.set("v.technology", StoreResponse);
                var technologylist = component.get("v.technology");
                window.setTimeout(
                    $A.getCallback( function() {
                        // Now set our preferred value
                        
                        //below code will check for the Status Value. If it exists in the cachae , then will update it to cachae value.
                        //	alert('****Tech Cachae Value on Page Load*********'+window.localStorage.getItem("v.selectedTechCache"));
                        if(window.localStorage.getItem("v.selectedTechCache") === undefined || window.localStorage.getItem("v.selectedTechCache") ===null ||  window.localStorage.getItem("v.selectedTechCache") ===''||(!technologylist.includes(window.localStorage.getItem("v.selectedTechCache")))){
                            component.find("tech").set("v.value",'---None---');
                        }
                        else{
                            component.set("v.selectedTechCache",localStorage.getItem("v.selectedTechCache"));
                            component.find("tech").set("v.value", localStorage.getItem("v.selectedTechCache"));
                        }
                        //alert('Inside set time out Selected Tech Value'+component.find("tech").get("v.value"));
                        
                        //Below Code will load the usecase values. 
                        var selectedTechnologyValue = component.find("tech").get("v.value");
                        //alert('Selected Technology onload'+selectedTechnologyValue);
                        if(selectedTechnologyValue == '---None---') {
                            component.set("v.selectedUsecaseCache",'---None---');
                        }
                        //else {
                        var newactionUsecase = component.get("c.getUseCaseOnTechnology");
                        newactionUsecase.setParams({
                            'selectedTechnology' : selectedTechnologyValue,			
                        });
                        newactionUsecase.setCallback(this, function(response) {
                            state = response.getState();
                            
                            if (response.getState() === "SUCCESS") {
                                //store the return response from server (map<string,List<string>>)  
                                var StoreResponse = response.getReturnValue();  
                                component.set("v.usecase", StoreResponse);
                                
                                var usecaselist = component.get("v.usecase");
                                var technologylist = component.get("v.technology");
                                var Entitlementinfolist = component.get("v.Entitlementinfo");
                                var Typeinfolist = component.get("v.Typeinfo");
                                //var usecaselist.includes(Org_par_NAme) 
                                window.setTimeout(
                                    $A.getCallback( function() {
                                        
                                        if(window.localStorage.getItem("v.selectedUsecaseCache") === undefined || window.localStorage.getItem("v.selectedUsecaseCache") ===null ||  window.localStorage.getItem("v.selectedUsecaseCache") ===''||(!usecaselist.includes(window.localStorage.getItem("v.selectedUsecaseCache")))){
                                            component.find("usecase1").set("v.value" ,'---None---');
                                        }
                                        else{
                                            component.set("v.selectedUsecaseCache",localStorage.getItem("v.selectedUsecaseCache"));
                                            component.find("usecase1").set("v.value", localStorage.getItem("v.selectedUsecaseCache"));
                                        }
                                        // Now set our preferred value
                                        if(window.localStorage.getItem("v.selectedStatusCache") === undefined || window.localStorage.getItem("v.selectedStatusCache") ===null || window.localStorage.getItem("v.selectedStatusCache") ===''){
                                            component.find("listview").set("v.value" ,'All Proposal');
                                        }
                                        else{
                                            component.set("v.selectedStatusCache",localStorage.getItem("v.selectedStatusCache"));
                                            component.find("listview").set("v.value", localStorage.getItem("v.selectedStatusCache"));
                                        }
                                        
                                        if(window.localStorage.getItem("v.selectedentitlementCache") === undefined || window.localStorage.getItem("v.selectedentitlementCache") ===null ||  window.localStorage.getItem("v.selectedentitlementCache") ==='' ||(!Entitlementinfolist.includes(window.localStorage.getItem("v.selectedentitlementCache")))){
                                            component.find("Entitlement").set("v.value" ,'--None--');
                                        }
                                        else{
                                            component.set("v.selectedentitlementCache",localStorage.getItem("v.selectedentitlementCache"));
                                            component.find("Entitlement").set("v.value", localStorage.getItem("v.selectedentitlementCache"));
                                            
                                        }
                                        
                                        if(window.localStorage.getItem("v.selectedTypCache") === undefined || window.localStorage.getItem("v.selectedTypCache") ===null ||  window.localStorage.getItem("v.selectedTypCache") ==='' ||(!Typeinfolist.includes(window.localStorage.getItem("v.selectedTypCache")))){
                                            component.find("Type").set("v.value" ,'--None--');
                                        }
                                        else{
                                            component.set("v.selectedTypCache",localStorage.getItem("v.selectedTypCache"));
                                            component.find("Type").set("v.value", localStorage.getItem("v.selectedTypCache"));
                                            
                                        }
                                        
                                        var techselectedValue = component.find("tech").get("v.value");
                                        var useCaseselectedValue = component.find("usecase1").get("v.value");
                                        var statusSelectedValue = component.find("listview").get("v.value");
                                        var entitlementSelectedValue = component.find("Entitlement").get("v.value");
                                        var typeSelectedValue = component.find("Type").get("v.value");
                                        // alert('Selected Technology onload'+techselectedValue);
                                        //alert('Selected Usecase onload'+useCaseselectedValue);
                                        //alert('Selected status onload'+statusSelectedValue);
                                        // alert('Selected entitle onload'+entitlementSelectedValue);
                                        
                                        
                                        
                                        if((window.localStorage.getItem("v.selectedTechCache")!== null &&window.localStorage.getItem("v.selectedTechCache")!== '' && window.localStorage.getItem("v.selectedTechCache").length > 0 )
                                           ||
                                           (window.localStorage.getItem("v.selectedUsecaseCache")!== null &&window.localStorage.getItem("v.selectedUsecaseCache")!== '' && window.localStorage.getItem("v.selectedUsecaseCache").length > 0)
                                           ||
                                           (window.localStorage.getItem("v.selectedStatusCache")!== null &&window.localStorage.getItem("v.selectedStatusCache")!== '' && window.localStorage.getItem("v.selectedStatusCache").length > 0)
                                           ||
                                           (window.localStorage.getItem("v.selectedentitlementCache")!== null &&window.localStorage.getItem("v.selectedentitlementCache")!== '' && window.localStorage.getItem("v.selectedentitlementCache").length > 0)
                                          	|| 
                                           (window.localStorage.getItem("v.selectedTypCache")!== null &&window.localStorage.getItem("v.selectedTypCache")!== '' && window.localStorage.getItem("v.selectedTypCache").length > 0)
                                          )
                                            
                                        {
                                            //alert('This will call the Filter DP Record');
                                            // This will call the automated Search fucntionality.
                                            var techselectedValue = window.localStorage.getItem("v.selectedTechCache") ;
                                            var useCaseselectedValue = window.localStorage.getItem("v.selectedUsecaseCache");
                                            var statusSelectedValue = window.localStorage.getItem("v.selectedStatusCache");
                                            var entitlementSelectedValue = window.localStorage.getItem("v.selectedentitlementCache");
                                            var typeSelectedValue = window.localStorage.getItem("v.selectedTypCache");
                                            
                                        }
                                        
                                        if(techselectedValue == '---None---') {
                                            techselectedValue=null;
                                            
                                        }
                                        if(useCaseselectedValue == '---None---') {
                                            useCaseselectedValue=null;
                                        }
                                        
                                        if(statusSelectedValue == null) {
                                            statusSelectedValue = 'All Proposal';
                                        }
                                        
                                        
                                        var newFilteraction = component.get("c.filterDPRecord");
                                        newFilteraction.setParams({
                                            "techinfo": techselectedValue,
                                            "useCaseInfo": useCaseselectedValue,
                                            "statusInfo": statusSelectedValue,
                                            "Entitlementinfo": entitlementSelectedValue,
                                            "Typeinfo": typeSelectedValue,
                                        });
                                        newFilteraction.setCallback(this, function(response) {
                                            var state = response.getState();
                                            // alert('Total Record Retrieved***'+response.getReturnValue().length);
                                            if (response.getState() == "SUCCESS") {
                                                
                                                var pageSize = component.get("v.pageSize");
                                                // hold all the records into an attribute named "DPData"
                                                var DPlistval = response.getReturnValue();
                                                
                                                if(DPlistval==null || DPlistval==undefined || DPlistval=='')
                                                    component.set('v.showmessage', true);
                                                
                                                if(DPlistval!=null && DPlistval!=undefined && DPlistval!='')
                                                {
                                                    component.set('v.DPData', response.getReturnValue());
                                                    // get size of all the records and then hold into an attribute "totalRecords"
                                                    component.set("v.totalRecords", component.get("v.DPData").length);
                                                    // set star as 0
                                                    //alert('***Total number of Records ****'+component.get("v.DPData").length)
                                                    
                                                    component.set("v.maxpagenumber",Math.ceil(component.get("v.DPData").length / pageSize));
                                                    
                                                    component.set("v.startPage",0);
                                                    component.set("v.endPage",pageSize-1);
                                                    component.set("v.PAgenumber",Math.ceil(component.get("v.startPage")+1 / pageSize));
                                                    var PaginationList = [];
                                                    for(var i=0; i< pageSize; i++){
                                                        if(component.get("v.DPData").length> i)
                                                            PaginationList.push(response.getReturnValue()[i]);    
                                                    }
                                                    component.set('v.showbutton', true);
                                                    component.set('v.DigitalProposal', PaginationList);
                                                    component.set('v.isSending',false);
                                                }
                                            }
                                        });
                                        $A.enqueueAction(newFilteraction); 
                                        
                                        
                                    }));
                                
                                
                            }
                            else {
                                
                            }
                        });
                        $A.enqueueAction(newactionUsecase);  
                        //}
                        
                        
                    }));
                
            }	
            
        });
        $A.enqueueAction(newaction);
    },
    
    getJsonFromUrl : function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
    },
    
    
    getUseCasehelper : function(component, event, helper, ListOfDependentFields){
        
        //component.set("v.selectedUsecaseCache",localStorage.getItem("v.selectedUsecaseCache"));
        var selectedValue = component.find("tech").get("v.value");
        
        if(selectedValue === undefined || selectedValue === null  ){
            selectedValue =window.localStorage.getItem("v.selectedTechCache");
        }
        
        
        // create a empty array var for store dependent picklist values for controller field  
        var dependentFields = [];
        dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set("v.usecase", dependentFields);
    },
    
    filterDPHelper : function(component, event, helper){
        var techselectedValue = component.find("tech").get("v.value");
        var useCaseselectedValue = component.find("usecase1").get("v.value");
        var statusSelectedValue = component.find("listview").get("v.value");
        var entitlementSelectedValue = component.find("Entitlement").get("v.value");
        var typeSelectedValue = component.find("Type").get("v.value");
        //alert('Selected entry Technology onload'+techselectedValue);
        //alert('Selected entry Usecase onload'+useCaseselectedValue);
        
        component.set('v.showmessage', false);
        component.set('v.showbutton', false);
        
        component.set('v.DPData', null);
        component.set('v.DigitalProposal', null);
        if(techselectedValue!=null&&techselectedValue.length >0){
            
            window.localStorage.setItem('v.selectedTechCache',techselectedValue);   
            
        }
        else {
            window.localStorage.setItem('v.selectedTechCache',null);
        }
        if(useCaseselectedValue!=null&&useCaseselectedValue.length >0){
            
            window.localStorage.setItem('v.selectedUsecaseCache', useCaseselectedValue);
            
        }
        else {
            window.localStorage.setItem('v.selectedUsecaseCache', null);
            
        }
        
        if(statusSelectedValue!=null&&statusSelectedValue.length >0){
            window.localStorage.setItem('v.selectedStatusCache', statusSelectedValue); 
        }
        else {
            window.localStorage.setItem('v.selectedStatusCache', 'All Proposal');
        }
        
        if(entitlementSelectedValue!=null&&entitlementSelectedValue.length >0){
            window.localStorage.setItem('v.selectedentitlementCache', entitlementSelectedValue); 
        }
        else {
            window.localStorage.setItem('v.selectedentitlementCache', null);
        }
        
        if(typeSelectedValue!=null&&typeSelectedValue.length >0){
            window.localStorage.setItem('v.selectedTypCache', typeSelectedValue); 
        }
        else {
            window.localStorage.setItem('v.selectedTypCache', null);
        }
        if(techselectedValue==='---None---') {
            //alert('Selected Technology onload'+techselectedValue);
            techselectedValue=null;
        }
        if(useCaseselectedValue ==='---None---') {
            // alert('Selected in Usecase onload'+useCaseselectedValue);
            useCaseselectedValue=null;
        }
        
        if(statusSelectedValue===null) {
            statusSelectedValue ='All Proposal';
        }
        
        var newaction = component.get("c.filterDPRecord");
        newaction.setParams({
            "techinfo": techselectedValue,
            "useCaseInfo": useCaseselectedValue,
            "statusInfo": statusSelectedValue,
            "Entitlementinfo": entitlementSelectedValue,
            "Typeinfo": typeSelectedValue,
        });
        
        
        newaction.setCallback(this, function(response) {
            var state = response.getState();
            //	alert('Total Record Retrieved***'+response.getReturnValue().length);
            if (response.getState() == "SUCCESS") {
                var DPlistval = response.getReturnValue();
                
                if(DPlistval==null || DPlistval==undefined || DPlistval=='')
                    component.set('v.showmessage', true);
                
                if(DPlistval!=null && DPlistval!=undefined && DPlistval!='')
                {
                    var pageSize = component.get("v.pageSize");
                    
                    // hold all the records into an attribute named "DPData"
                    component.set('v.DPData', response.getReturnValue());
                    //alert('*****Total Number of Record Filtered******'+response.getReturnValue().length);
                    // get size of all the records and then hold into an attribute "totalRecords"
                    component.set("v.totalRecords", component.get("v.DPData").length);
                    component.set("v.maxpagenumber",Math.ceil(component.get("v.DPData").length / pageSize));
                    
                    // set star as 0
                    component.set("v.startPage",0);
                    component.set("v.PAgenumber",Math.ceil(component.get("v.startPage")+1 / pageSize));
                    component.set("v.endPage",pageSize-1);
                    var PaginationList = [];
                    for(var i=0; i< pageSize; i++){
                        if(component.get("v.DPData").length> i)
                            PaginationList.push(response.getReturnValue()[i]);    
                    }
                    component.set('v.showbutton', true);
                    component.set('v.DigitalProposal', PaginationList);
                    component.set('v.isSending',false);
                }
                
            }
        });
        
        $A.enqueueAction(newaction);
    },
    
    applySorting : function(component, event, sortFieldName){
        
        var techselectedValue = component.find("tech").get("v.value");
        var useCaseselectedValue = component.find("usecase1").get("v.value");
        var statusSelectedValue = component.find("listview").get("v.value");
        var entitlementSelectedValue = component.find("Entitlement").get("v.value");
        var typeSelectedValue = component.find("Type").get("v.value");
        component.set('v.showmessage', false);
        component.set('v.showbutton', false);
        if(techselectedValue==='---None---') {
            techselectedValue=null;
        }
        if(useCaseselectedValue ==='---None---') {
            useCaseselectedValue=null;
        }
        
        if(statusSelectedValue===null) {
            statusSelectedValue ='All Proposal';
        }
        var newaction = component.get("c.sortDPRec");
        newaction.setParams({
            'sortField': sortFieldName,
            'isAsc': component.get("v.isAsc"),
            "techinfo": techselectedValue,
            "useCaseInfo": useCaseselectedValue,
            "statusInfo": statusSelectedValue,
            "Entitlementinfo": entitlementSelectedValue,
            "Typeinfo": typeSelectedValue,
            
        });
        newaction.setCallback(this, function(response) {
            var state = response.getState();
            
            if (response.getState() == "SUCCESS") {
                
                var pageSize = component.get("v.pageSize");
                
                component.set('v.DPData', response.getReturnValue());
                
                component.set("v.totalRecords", component.get("v.DPData").length);
                component.set("v.maxpagenumber",Math.ceil(component.get("v.DPData").length / pageSize));
                component.set("v.startPage",0);
                component.set("v.endPage",pageSize-1);
                component.set("v.PAgenumber",Math.ceil(component.get("v.startPage")+1 / pageSize));
                var PaginationList = [];
                for(var i=0; i< pageSize; i++){
                    if(component.get("v.DPData").length> i)
                        PaginationList.push(response.getReturnValue()[i]);    
                }
                component.set('v.showbutton', true);
                component.set('v.DigitalProposal', PaginationList);
                component.set('v.isSending',false);
                
            }
        });
        $A.enqueueAction(newaction);
    },
    
    sortHelper: function(component, event, sortFieldName) {
        
        var currentDir = component.get("v.arrowDirection");
        if (currentDir == 'arrowdown') {
            component.set("v.arrowDirection", 'arrowup');
            component.set("v.isAsc", true);
        } else {
            component.set("v.arrowDirection", 'arrowdown');
            component.set("v.isAsc", false);
        }
        // call the onLoad function for call server side method with pass sortFieldName 
        this.applySorting(component, event, sortFieldName);
    },
    
    
    next : function(component, event){
        var sObjectList = component.get("v.DPData");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var PAgenumber = component.get("v.PAgenumber");
        var Paginationlist = [];
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++){
            if(sObjectList.length > i){
                Paginationlist.push(sObjectList[i]);
            }
            counter ++ ;
        }
        
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set("v.PAgenumber",PAgenumber+1);
        component.set('v.DigitalProposal', Paginationlist);
    },
    /*
     * Method will be called when use clicks on previous button and performs the 
     * calculation to show the previous set of records
     */
    previous : function(component, event){
        var sObjectList = component.get("v.DPData");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var PAgenumber = component.get("v.PAgenumber");
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                Paginationlist.push(sObjectList[i]);
                counter ++;
            }else{
                start++;
            }
        }
        
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set("v.PAgenumber",PAgenumber-1);
        component.set('v.DigitalProposal', Paginationlist);
    }
    
    
    
})