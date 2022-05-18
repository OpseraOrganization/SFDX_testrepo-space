({
    getEntitlementinfo: function (component,event,helper) {
        var newaction = component.get("c.Get_entitlepicklist");
        newaction.setCallback(this, function(response) {
            var state = response.getState();
            if (response.getState() === "SUCCESS") {
                var StoreResponse = response.getReturnValue();
                component.set("v.Entitlementinfo", StoreResponse);
                var infoidlist=[];
                
                for (var indexVar = 0; indexVar < StoreResponse.length; indexVar++) {
                    
                    if (StoreResponse[indexVar].Id!=null)
                    {
                        infoidlist.push(StoreResponse[indexVar].Id)
                    }
                }
                component.set("v.Entitlementinfoidlist", infoidlist);
                
                window.setTimeout(
                    $A.getCallback( function() {
                        if(window.localStorage.getItem("v.selectedentitlementCacheval") === undefined || window.localStorage.getItem("v.selectedentitlementCacheval") ===null ||  window.localStorage.getItem("v.selectedentitlementCacheval") ===''){
                            component.find("Entitlement").set("v.value",'---None---');
                        }
                        else{
                            component.set("v.selectedentitlementCacheval",localStorage.getItem("v.selectedentitlementCacheval"));
                            component.find("Entitlement").set("v.value", localStorage.getItem("v.selectedentitlementCacheval"));
                        }
                    }));
                
            }	
            
        });
        $A.enqueueAction(newaction);
    },
    
    getTechnologyHelper : function(component,event,helper,objDetails,controllerField, dependentField){
        
        component.set('v.showbutton', false);
        component.set('v.showmessage', false);
        
        component.set('v.DPData', null);
        component.set('v.Commercialproposal', null);
        var newaction = component.get("c.getTechnologies");
        
        
        newaction.setCallback(this, function(response) {
            var state = response.getState();
            
            if (response.getState() === "SUCCESS") {
                var StoreResponse = response.getReturnValue();
                
                component.set("v.technology", StoreResponse);
                var technologylist = component.get("v.technology");
                window.setTimeout(
                    $A.getCallback( function() {
                        
                        if(window.localStorage.getItem("v.selectedTechCacheval") === undefined || window.localStorage.getItem("v.selectedTechCacheval") ===null ||  window.localStorage.getItem("v.selectedTechCacheval") ===''||(!technologylist.includes(window.localStorage.getItem("v.selectedTechCacheval")))){
                            component.find("tech").set("v.value",'---None---');
                        }
                        else{
                            component.set("v.selectedTechCacheval",localStorage.getItem("v.selectedTechCacheval"));
                            component.find("tech").set("v.value", localStorage.getItem("v.selectedTechCacheval"));
                        }
                        
                        var selectedTechnologyValue = component.find("tech").get("v.value");
                        if(selectedTechnologyValue == '---None---') {
                            component.set("v.selectedUsecaseCacheval",'---None---');
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
                                var Entitlementinfoidlist = component.get("v.Entitlementinfoidlist");
                                
                                window.setTimeout(
                                    $A.getCallback( function() {
                                        
                                        if(window.localStorage.getItem("v.selectedUsecaseCacheval") === undefined || window.localStorage.getItem("v.selectedUsecaseCacheval") ===null ||  window.localStorage.getItem("v.selectedUsecaseCacheval") ===''||(!usecaselist.includes(window.localStorage.getItem("v.selectedUsecaseCacheval")))){
                                            component.find("usecase1").set("v.value" ,'---None---');
                                        }
                                        else{
                                            component.set("v.selectedUsecaseCacheval",localStorage.getItem("v.selectedUsecaseCacheval"));
                                            component.find("usecase1").set("v.value", localStorage.getItem("v.selectedUsecaseCacheval"));
                                        }
                                        if(window.localStorage.getItem("v.selectedentitlementCacheval") === undefined || window.localStorage.getItem("v.selectedentitlementCacheval") ===null ||  window.localStorage.getItem("v.selectedentitlementCacheval") ==='' ||(!Entitlementinfoidlist.includes(window.localStorage.getItem("v.selectedentitlementCacheval")))){
                                            component.find("Entitlement").set("v.value" ,'---None---');
                                        }
                                        else{
                                            component.set("v.selectedentitlementCacheval",localStorage.getItem("v.selectedentitlementCacheval"));
                                            component.find("Entitlement").set("v.value", localStorage.getItem("v.selectedentitlementCacheval"));
                                            
                                        }
                                        
                                        var techselectedValue = component.find("tech").get("v.value");
                                        var useCaseselectedValue = component.find("usecase1").get("v.value");
                                        var entitlementSelectedValue = component.find("Entitlement").get("v.value");
                                        if((window.localStorage.getItem("v.selectedTechCacheval")!== null &&window.localStorage.getItem("v.selectedTechCacheval")!== '' && window.localStorage.getItem("v.selectedTechCacheval").length > 0 )
                                           ||
                                           (window.localStorage.getItem("v.selectedUsecaseCacheval")!== null &&window.localStorage.getItem("v.selectedUsecaseCacheval")!== '' && window.localStorage.getItem("v.selectedUsecaseCacheval").length > 0)
                                           ||
                                           (window.localStorage.getItem("v.selectedentitlementCacheval")!== null &&window.localStorage.getItem("v.selectedentitlementCacheval")!== '' && window.localStorage.getItem("v.selectedentitlementCacheval").length > 0))
                                            
                                        {
                                            var techselectedValue = window.localStorage.getItem("v.selectedTechCacheval") ;
                                            var useCaseselectedValue = window.localStorage.getItem("v.selectedUsecaseCacheval");
                                            var entitlementSelectedValue = window.localStorage.getItem("v.selectedentitlementCacheval");
                                        }
                                        
                                        if(techselectedValue == '---None---') {
                                            techselectedValue=null;
                                            
                                        }
                                        if(useCaseselectedValue == '---None---') {
                                            useCaseselectedValue=null;
                                        }
                                        
                                        
                                        
                                        var newFilteraction = component.get("c.filtercommercialRecord");
                                        newFilteraction.setParams({
                                            "techinfo": techselectedValue,
                                            "useCaseInfo": useCaseselectedValue,
                                            "Entitlementinfo": entitlementSelectedValue,
                                        });
                                        newFilteraction.setCallback(this, function(response) {
                                            var state = response.getState();
                                            if (response.getState() == "SUCCESS") {
                                                
                                                var pageSize = component.get("v.pageSize");
                                                var DPlistval = response.getReturnValue();
                                                
                                                if(DPlistval==null || DPlistval==undefined || DPlistval=='')
                                                    component.set('v.showmessage', true);
                                                
                                                if(DPlistval!=null && DPlistval!=undefined && DPlistval!='')
                                                {
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
                                                    component.set('v.Commercialproposal', PaginationList);
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
            selectedValue =window.localStorage.getItem("v.selectedTechCacheval");
        }
        
        
        var dependentFields = [];
        dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        component.set("v.usecase", dependentFields);
    },
    
    filterDPHelper : function(component, event, helper){
        var techselectedValue = component.find("tech").get("v.value");
        var useCaseselectedValue = component.find("usecase1").get("v.value");
        var entitlementSelectedValue = component.find("Entitlement").get("v.value");
        
        component.set('v.showmessage', false);
        component.set('v.showbutton', false);
        
        component.set('v.DPData', null);
        component.set('v.Commercialproposal', null);
        if(techselectedValue!=null&&techselectedValue.length >0){
            
            window.localStorage.setItem('v.selectedTechCacheval',techselectedValue);   
            
        }
        else {
            window.localStorage.setItem('v.selectedTechCacheval',null);
        }
        if(useCaseselectedValue!=null&&useCaseselectedValue.length >0){
            
            window.localStorage.setItem('v.selectedUsecaseCacheval', useCaseselectedValue);
            
        }
        else {
            window.localStorage.setItem('v.selectedUsecaseCacheval', null);
            
        }
        
        
        
        if(entitlementSelectedValue!=null&&entitlementSelectedValue.length >0){
            window.localStorage.setItem('v.selectedentitlementCacheval', entitlementSelectedValue); 
        }
        else {
            window.localStorage.setItem('v.selectedentitlementCacheval', null);
        }
        if(techselectedValue==='---None---') {
            techselectedValue=null;
        }
        if(useCaseselectedValue ==='---None---') {
            useCaseselectedValue=null;
        }
        
        
        
        var newaction = component.get("c.filtercommercialRecord");
        newaction.setParams({
            "techinfo": techselectedValue,
            "useCaseInfo": useCaseselectedValue,
            "Entitlementinfo": entitlementSelectedValue,
        });
        newaction.setCallback(this, function(response) {
            var state = response.getState();
            if (response.getState() == "SUCCESS") {
                var DPlistval = response.getReturnValue();
                
                if(DPlistval==null || DPlistval==undefined || DPlistval=='')
                    component.set('v.showmessage', true);
                
                if(DPlistval!=null && DPlistval!=undefined && DPlistval!='')
                {
                    var pageSize = component.get("v.pageSize");
                    
                    component.set('v.DPData', response.getReturnValue());
                    
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
                    component.set('v.Commercialproposal', PaginationList);
                }
                
            }
        });
        
        $A.enqueueAction(newaction);
    },
    
    applySorting : function(component, event, sortFieldName){
        
        var techselectedValue = component.find("tech").get("v.value");
        var useCaseselectedValue = component.find("usecase1").get("v.value");
        var entitlementSelectedValue = component.find("Entitlement").get("v.value");
        component.set('v.showmessage', false);
        component.set('v.showbutton', false);
           if(techselectedValue == '---None---') {
                                            techselectedValue=null;
                                            
                                        }
                                        if(useCaseselectedValue == '---None---') {
                                            useCaseselectedValue=null;
                                        }
        var newaction = component.get("c.sortCPRec");
        newaction.setParams({
            'sortField': sortFieldName,
            'isAsc': component.get("v.isAsc"),
            "techinfo": techselectedValue,
            "useCaseInfo": useCaseselectedValue,
            "Entitlementinfo": entitlementSelectedValue,
            
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
                component.set('v.Commercialproposal', PaginationList);
                
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
        component.set('v.Commercialproposal', Paginationlist);
    },
    
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
        component.set('v.Commercialproposal', Paginationlist);
    }
    
    
    
})