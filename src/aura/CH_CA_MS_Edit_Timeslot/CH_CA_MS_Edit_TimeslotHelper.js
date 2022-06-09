({
    getTableId: function(component){
    	return '#associations-' + component.get("v.timeslotId");        
    },
    // Intialize the datatables object
    createTable: function(component, timeslotAssociations) {
		var tableId = this.getTableId(component);
        $(tableId).DataTable({
            columnDefs: [{
                	orderable: false,
                    mRender: function (data, type, full) {
                        return '<input class="button" type="Checkbox" />' 
                    },
                    data: null,
                    defaultContent: '',
                	width: '3em',
                	targets: 0,
                    title: 'Select',
					"visible": component.get("v.isEditEnabled")
            	},{
                    mRender: function (data, type, full) {
                        // javascript:; makes sure that when you click on the link you don't go anywhere
                        return '<a href="javascript:;">' + data + '</a>' 
                    },
                    data: 'CH_Workgroup_Member_Name__c',
                    width: '15em',
                    targets: 1,
                    title: 'Workgroup Member Name'
                },{
                    data: 'CH_Workgroup_Member_Role__c', 
                    targets: 2,
                    title: 'Role'
                },{
                    data: 'CH_Schedule_Type__c', 
                    targets: 3,
                    title: 'Schedule Type'
                }        
            ],
            ordering: true,
            autoWidth: false,
            rowId: 'Id',
            pageLength: 5,
            lengthMenu: [ 5, 10, 25 ],
            data: timeslotAssociations,
        });
        $(tableId).on('click', 'input[type="Checkbox"]', function() {
            var selectedRows = $(tableId).DataTable().rows({ selected: true }).ids(false).toArray();
            var row = $(tableId).DataTable().row($(this).closest('tr'));
            var rowId = row.data().Id;
            // Check if the rowId of the current row is a slected row already
            if ($.inArray(rowId, selectedRows) === -1){
                // If not selected
            	row.select();        
            }
            else {
                // If selected
                row.deselect();
            }
            
            // Enable Disable the delete button
            var button = component.find('deleteTimeslotWorkgroupMembers');
            selectedRows = $(tableId).DataTable().rows({ selected: true }).ids(false).toArray();
            if (selectedRows.length > 0){
                button.set('v.disabled',false);
            }
            else {
                button.set('v.disabled',true);
            }
        });        
    },
    // Delete the schedules
    deleteTimeslot: function(component, scheduleId){
        var promise = new Promise( function( resolve , reject ) {
        	const sharedjs = component.find("sharedJavaScript");
        	resolve(sharedjs.apex(component, 'deleteTimeslot',{ timeslotId : component.get("v.timeslot.Id"), scheduleId : scheduleId}));
        });           
        return promise; 
    },
    // Delete the selected timeslots associations
    deleteTimeSlotAssociations: function(component, scheduleId){
        var tableId = this.getTableId(component);
        var promise = new Promise( function( resolve , reject ) {
            var selectedRows = $(tableId).DataTable().rows({ selected: true }).ids(false).toArray();
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'deleteSelectedTimeSlotAssociations',{ selectedTimeSlotAssocationIds : selectedRows, scheduleId : scheduleId }));
        });           
        return promise; 
    },
    // Get the timeslot based on the attribute v.timeslot.Id
    refreshTimeslot : function(component) {
        var thisHelper = this;
        var promise = new Promise( function( resolve , reject ) {
        	const sharedjs = component.find("sharedJavaScript");
        	sharedjs.apex(component, 'getTimeSlot',{ timeslotId : component.get("v.timeslotId")})
            .then(function(result){
                component.set('v.timeslotId', result.Id);
                component.set('v.timeslot', result);
                var startTime = (result.CH_Start_Time__c === undefined)? "0" : result.CH_Start_Time__c;
                component.find("CH_Start_Time__c").set("v.value", thisHelper.calculateTime(startTime));
                var endTime = (result.CH_End_Time__c === undefined)? "0" : result.CH_End_Time__c;
                component.find("CH_End_Time__c").set("v.value",thisHelper.calculateTime(endTime));
                // Reload the recordedit form to make sure the latest data is visible
                component.set('v.refreshUI', false);
                component.set('v.refreshUI', true);                
                component.set('v.dataChanged', false);

                resolve(result);
            })
            .then(function() {
                // Get the schedule data 
        		const sharedjs = component.find("sharedJavaScript");
        		return sharedjs.apex(component, 'getSchedule',{ scheduleId : component.get("v.scheduleId")})
            })
            .then(function(schedule){
                component.set('v.schedule', schedule);
            });
        });           
        return promise;         
    },
    // Save the schedule
    saveTimeslot: function(component, timeslotFields){
        // Update the filter related lists on the server
        var promise = new Promise( function( resolve , reject ) {
        	const sharedjs = component.find("sharedJavaScript");
        	//resolve(sharedjs.apex(component, 'saveTimeslot',{ timeslotFields : timeslotFields }));
			//Start Changes for Bug-27444
			component.set("v.timeslot",{'sobjectType':'CH_Workgroup_Schedule_Timeslot__c',
                                        'CH_Workgroup_Schedule__c':component.get("v.scheduleId"),
                                        'CH_Day__c':component.find("CH_Day__c").get("v.value"),
                                        'CH_Start_Time__c':component.find("CH_Start_Time__c").get("v.value"),
                                        'CH_End_Time__c':component.find("CH_End_Time__c").get("v.value"),
                                        'Id':component.get("v.timeslotId")
                                       });
		 resolve(sharedjs.apex(component, 'saveTimeslot',{ gettimeslot : component.get("v.timeslot") }));
		 //End Changes for the Bug-27444
        });           
        return promise; 
    },
    // Conevert the miliseconds returned by SF to a time
    calculateTime: function(duration) {
        var minutes = Math.floor((duration / (1000 * 60)) % 60);
    	var hours = Math.floor((duration / (1000 * 60 * 60)) % 24);
        
  		hours = (hours < 10) ? "0" + hours : hours;
  		minutes = (minutes < 10) ? "0" + minutes : minutes;
        
        return hours + ":" + minutes + ":00.000";
    }, 
})