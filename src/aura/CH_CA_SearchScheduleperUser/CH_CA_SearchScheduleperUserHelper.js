({   
    //Get user for initial page load
    getUserDetail: function(component, event, helper) {       
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'getUserDetail',{ }));
        });           
        return promise; 
    },
   
    //Search Schedule per User with user id ,startdate,endate 
    Search: function(component, event, helper) {
        component.set("v.Spinner", true);        
        var startDate= component.find("startDate").get("v.value");
		var startTime= component.find("startTime").get("v.value");
        var endDate= component.find("endDate").get("v.value");
		var endTime= component.find("endTime").get("v.value");
        var userId = component.find("user").get("v.value");
        var action = component.get("c.getSchedulePerUser");
        action.setParams({startDate: startDate,
						  startTime: startTime,
                          endDate: endDate, 
						  endTime: endTime,				
                          userId : userId});        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var date = new Date();            
            if (state === "SUCCESS") {
                component.set("v.currentPageNumber",1);                
                component.set("v.totalRecords", response.getReturnValue().length);
                //Create array for date table
                var searchScheduleperUser = response.getReturnValue();
                for(var i = 0; i < searchScheduleperUser.length; i++) {
                    searchScheduleperUser[i].scheduleName=searchScheduleperUser[i].CH_Workgroup_Schedule_Timeslot__r.CH_Schedule_Name__c;
                    searchScheduleperUser[i].Role=searchScheduleperUser[i].CH_Workgroup_Member__r.CH_Role__c;
                    searchScheduleperUser[i].CH_Day__c=searchScheduleperUser[i].CH_Workgroup_Schedule_Timeslot__r.CH_Day__c;
                    searchScheduleperUser[i].CH_Time_Zone__c=searchScheduleperUser[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Time_Zone__c;
                    var date = new Date(searchScheduleperUser[i].CH_Workgroup_Schedule_Timeslot__r.CH_Start_Time__c);  
                    searchScheduleperUser[i].CH_Start_Time__c=date.toLocaleTimeString([], {timeZone: 'UTC'});                        
                    date= new Date(searchScheduleperUser[i].CH_Workgroup_Schedule_Timeslot__r.CH_End_Time__c);  
                    searchScheduleperUser[i].CH_End_Time__c=date.toLocaleTimeString([], {timeZone: 'UTC'}); 
                    searchScheduleperUser[i].workgroupName=searchScheduleperUser[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Workgroup__r.Name;
                    searchScheduleperUser[i].workgroupNameURL = this.getLightningURL(searchScheduleperUser[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Workgroup__c);
                }
                //call data table
                this.setScheduleTable(component,event,helper);
                component.set('v.searchScheduleperUser', searchScheduleperUser);
                searchScheduleperUser.sort(this.sortBy('scheduleName', false)); 
                component.set("v.allFilterData", searchScheduleperUser); 
                component.set("v.allData", searchScheduleperUser); 
                //call data table
                this.initializationPagination(component, helper);
            }
            else{
                var errors = response.getError();                
                this.showToast('error', 'Error','search Schedule per User : '+ errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");                
            }
            component.set("v.Spinner", false);
        });
        $A.enqueueAction(action);
    },
    // initialize pagination
    initializationPagination : function(component, helper) {
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allFilterData");
        var x = (pageNumber-1)*pageSize;
        //creating data-table data
        for(; x<(pageNumber)*pageSize; x++){
            if(allData[x]){
                data.push(allData[x]);
            }
        }
        var count = component.get("v.totalRecords");         
        component.set("v.countofRecords",allData.length);
        if(component.get("v.currentPageNumber")==1){
            component.set("v.PreviousPageNumber",1);
            component.set("v.NextPageNumber",0);
        }
        component.set("v.totalPages", Math.ceil(allData.length/component.get("v.pageSize")));
        console.log('currentPageNumber:'+component.get("v.currentPageNumber")+'totalPages:'+component.get("v.totalPages"));
        if(component.get("v.currentPageNumber") ==component.get("v.totalPages")){
            component.set("v.NextPageNumber",1);
        }
        component.set("v.searchScheduleperUser", data);
        
    },
    //initialize data table for Search Schedule per User
    setScheduleTable : function (component,event,helper){        
        component.set('v.tblColumnsforScheduleperUser', [  
            {label: 'Workgroup name', fieldName: 'workgroupNameURL', type: 'url',      sortable: 'true',wrapText: 'true', typeAttributes: {label: { fieldName: 'workgroupName' }, target: '_self'}},
            // {label: 'Workgroup name', fieldName: 'workgroupName',type: 'text', sortable: 'true', wrapText: 'true'},  
            {label: 'Schedule Name', fieldName: 'scheduleName',type: 'text', sortable: 'true', wrapText: 'true'},   
            {label: 'Schedule Type', fieldName: 'CH_Schedule_Type__c',type: 'text', sortable: 'true'},   
            {label: 'Role', fieldName: 'Role',type: 'text',sortable: 'true'},
            {label: 'Days', fieldName: 'CH_Day__c', type: 'text', wrapText: 'true',initialwidth:"250"},             
            {label: 'Start Time', fieldName: 'CH_Start_Time__c',type: 'text', sortable: 'true'},  
            {label: 'End Time', fieldName: 'CH_End_Time__c',type: 'text', sortable: 'true'},
            {label: 'Time Zone', fieldName: 'CH_Time_Zone__c',type: 'text', sortable: 'true'}                               
        ]);           
    } , 
    //open link in new tab
    getLightningURL: function(recordId) {
        return '/one/one.app?#/sObject/' + recordId + '/view';
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
    //sort data of data table
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.searchScheduleperUser");
        var reverse = sortDirection !== 'asc';        
        data = Object.assign([],
                             data.sort(this.sortBy(fieldName, reverse ? -1 : 1))
                            );
        cmp.set("v.searchScheduleperUser", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer
        ? function(x) {
            return primer(x[field]);
        }
        : function(x) {
            return x[field];
        };        
        return function (a, b) {            
            var A = key(a)? key(a).toLowerCase() : '';
            var B = key(b)? key(b).toLowerCase() : '';
            return reverse * ((A > B) - (B > A));
            
        };
    },
	
	//Initialize Date and Time Values on Initial Load
    getDateTimeDetails:function(component, event, helper) { 
        var helperModule = this;
        var action = component.get("c.getDateTimeDetails");
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var timeVal = response.getReturnValue();
                component.set('v.getDateTimeDetails', response.getReturnValue());
                component.set('v.startDate',component.get('v.getDateTimeDetails.getStartDate'));
                component.set('v.endDate',component.get('v.getDateTimeDetails.getEndDate'));
                component.set('v.startTime',helperModule.calculateTime(component.get('v.getDateTimeDetails.getStartTime')));
                component.set('v.endTime',helperModule.calculateTime(component.get('v.getDateTimeDetails.getStartTime')));
            }
        });
        $A.enqueueAction(action);
    },
    
    // Convert the miliseconds returned by SF to a time
    calculateTime: function(duration) {
        var minutes = Math.floor((duration / (1000 * 60)) % 60);
        var hours = Math.floor((duration / (1000 * 60 * 60)) % 24);
        hours = (hours < 10) ? "0" + hours : hours;
        minutes = (minutes < 10) ? "0" + minutes : minutes;
        return hours + ":" + minutes + ":00.000";
    },
})