({
    getTableId: function(component){
    	return '#schedules-' + component.get("v.workgroupId");          
    },
    // Intialize the datatables object
    createTable: function(component, schedules) {
		//Changes added for NOKIASC-37954
        let getLocales = $A.get("$Label.c.CH_UserLocales");
        var getUserLocale = component.get('v.userLocale');
        var isValidLocale = getLocales.includes(getUserLocale);
        if(isValidLocale){var usrLocale='en-US';}
        else {var usrLocale=component.get('v.userLocale');}
        var thisHelper = this;
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
                    data: 'Name',
                    width: '15em',
                    targets: 1,
                    title: 'Schedule Name'
                },{
                    mRender: function (data, type, full) {
                        return '<input type="Checkbox" ' + ((data)?' Checked ':'') + ' disabled="disabled" />' 
                    },
                    data: 'CH_Active__c',
                    width: '3em',
                    targets: 2,
                    orderDataType: 'dom-checkbox',
                    title: 'Active'
                },{
					 data: 'CH_Start_Date__c',
					 defaultContent: '',
					 mRender: function (data, type, full) {
						 var date = new Date(data);
						 return '<input class="slds-input" type="datetime" readonly value="' +  date.toLocaleDateString(usrLocale,{ timeZone: 'UTC'})  + '" />';  
					 },
					 type: 'date',
					 targets: 3,
					 width: '10em',
					 title: 'Start Date',
					 
				 },{
					 data: 'CH_Start_Time__c',
					 defaultContent: '',
					 mRender: function (data, type, full) {                    
						 var date = new Date(data);                                           
						 return  date.toString()!="Invalid Date"? date.toLocaleTimeString(usrLocale,{ timeZone: 'UTC'}):"Invalid Time" ;                       
					 },
					 width: '10em',
					 targets: 4,
					 title: 'Start Time',
					 
			    },{
						 data: 'CH_End_Date__c',
						 defaultContent: '',
						 mRender: function (data, type, full) {
							 var date = new Date(data);
							 return '<input class="slds-input" type="datetime" readonly value="' +  date.toLocaleDateString(usrLocale,{ timeZone: 'UTC'}) + '" />';  
						 },
						 type: 'date',
						 targets: 5,
						 width: '10em',
						 title: 'End Date',
						 
					 },{
						 data: 'CH_End_Time__c',
						 defaultContent: '',
						 mRender: function (data, type, full) {  
							 var date = new Date(data);                                          
							 return date.toString()!="Invalid Date"? date.toLocaleTimeString(usrLocale,{ timeZone: 'UTC'}):"Invalid Time" ;                                      
						 },
						 width: '10em',
						 targets: 6,
						 title: 'End Time',
						 
					 },{
						 data: 'CH_Time_Zone__c',
						 width: '10em',
						 targets: 7,
						 title: 'TimeZone'
					 },{
                    data: 'CH_Workgroup_Filters__r[0].CH_Region__c',
                    width: '10em',
                    targets: 8,
                    title: 'Region'
                },{
                    data: 'CH_Workgroup_Filters__r[0].CH_Country__c',
                    width: '10em',
                    targets: 9,
                    title: 'Country'
                },{
                    data: 'CH_Workgroup_Filters__r[0].CH_Outage__c',
                    width: '10em',
                    targets: 10,
                    title: 'Outage'
                },{
                    data: 'CH_Workgroup_Filters__r[0].CH_Severity__c',
                    width: '10em',
                    targets: 11,
                    title: 'Severity'
                },{
                    data: 'CH_Workgroup_Filters__r[0].CH_Workgroup_Type__c',
                    width: '10em',
                    targets: 12,
                    title: 'Workgroup Type'
                },{
                    data: 'CH_Workgroup_Filters__r[0].CH_LevelOfSupport__c',
                    width: '10em',
                    targets: 13,
                    title: 'Level Of Support'
                },{
                    data: 'Id',
                    targets: 14,
                    title: 'Schedule Id',
                    visible: false
                },{
                    mRender: function (data, type, full) {
                        return ((data)?'true':'false'); 
                    },
                    data: 'CH_Active__c',
                    targets: 12,
                    title: 'Active Hidden',
                    visible: false
                }        
            ],
            ordering: true,
            autoWidth: false,
            rowId: 'Id',
            pageLength: 5,
            lengthMenu: [ 5, 10, 25 ],
            data: schedules,
        });
        // Handle the (de)select of the checkbox
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
            var button = component.find('deleteScheduleButton');
            var validatebutton = component.find('validateButton');
			var cloneButton = component.find('cloneButton');
			var exportButton = component.find('exportButton');
            selectedRows = $(tableId).DataTable().rows({ selected: true }).ids(false).toArray();
            if (selectedRows.length > 0){
                button.set('v.disabled',false);
                validatebutton.set('v.disabled',false);
				cloneButton.set('v.disabled',false);
				exportButton.set('v.disabled',false);
            }
            else {
                button.set('v.disabled',true);
                validatebutton.set('v.disabled',true);
				cloneButton.set('v.disabled',true);
				exportButton.set('v.disabled',true);
            }
        });
        // When clicking on the schedule name goto the next screen with the id of the row
        $(tableId).on('click', 'a', function() {
            var tr = $(this).closest('tr');
            var rowId = $(tableId).DataTable().row(tr).id();
            component.set("v.scheduleId",rowId);
        });
        // Be able to sort on checkboxes
        $.fn.dataTable.ext.order['dom-checkbox'] = function  ( settings, col )
        {
            return this.api().column( col, {order:'index'} ).nodes().map( function ( td, i ) {
                return $('input', td).prop('checked') ? '1' : '0';
            } );
        };
    },
    // Delete the selected schedules
    deleteSchedules: function(component){
        var tableId = this.getTableId(component);
        var promise = new Promise( function( resolve , reject ) {
            var selectedRows = $(tableId).DataTable().rows({ selected: true }).ids(false).toArray();
        	const sharedjs = component.find("sharedJavaScript");
        	resolve(sharedjs.apex(component, 'deleteSelectedSchedules',{ selectedScheduleIds : selectedRows }));
        });           
        return promise; 
    },
	
	// clone the selected schedules
    cloneSchedule: function(component){
        var tableId = this.getTableId(component);
        var promise = new Promise( function( resolve , reject ) {
            var selectedRows = $(tableId).DataTable().rows({ selected: true }).ids(false).toArray();
            const sharedjs = component.find("sharedJavaScript");
            var getscheduleName=component.find("name").get("v.value");
            var getWrkgpFilterName=component.find("filtername").get("v.value");
            resolve(sharedjs.apex(component, 'cloneSelectedSchedules',{ selectedScheduleIds : selectedRows,scheduleName:getscheduleName,workgpFilterName:getWrkgpFilterName }));
        });           
        return promise; 
    },
	
	// Export Code
    onLoad: function(component, event) {
        var tableId = this.getTableId(component);
        var promise = new Promise( function( resolve , reject ) {
            var selectedRows = $(tableId).DataTable().rows({ selected: true }).ids(false).toArray();
            const sharedjs = component.find("sharedJavaScript");
            var gtSelectedValue = component.find("exportSelection").get("v.value");
            if(gtSelectedValue=="TimeSlot"){
                resolve(sharedjs.apex(component, 'fetchTimeSlot',{ selScheduleIds : selectedRows}));
            }
            else{
                resolve(sharedjs.apex(component, 'fetchTimeSlotMembers',{ selScheduleIds : selectedRows}));
            }
            
        });           
        return promise;
    },
    
    convertTimeSlotObject : function(component,objectRecords){
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variable for sparate CSV values and for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        // in the keys variables store the fields API Names as a key 
        // labels are used in CSV file header  
        
        keys = ['CH_Workgroup_Schedule__r.CH_Workgroup__r.Name','CH_Workgroup_Schedule__r.Name',
				'CH_Workgroup_Schedule__r.CH_Start_Date__c','CH_Workgroup_Schedule__r.CH_Start_Time__c',
                'CH_Workgroup_Schedule__r.CH_End_Date__c','CH_Workgroup_Schedule__r.CH_End_Time__c',
				'CH_Workgroup_Schedule__r.CH_Time_Zone__c','Name','Id','CH_Day__c','CH_Start_Time__c','CH_End_Time__c'];
        csvStringResult = '';
        csvStringResult +=['Workgroup Name','Schedule Name','Schedule StartDate','Schedule StartTime','Schedule EndDate','Schedule EndTime',
                           'Schedule TimeZone','TimeSlot Name','TimeSlot Id','Day','Start Time','End Time','Operation'];
        csvStringResult += lineDivider;
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                // add , [comma] after every String value,. [except first]
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }  
                if(skey == 'CH_Workgroup_Schedule__r.CH_Workgroup__r.Name') {
                    if(JSON.stringify(objectRecords[i].CH_Workgroup_Schedule__r.CH_Workgroup__r.Name) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Schedule__r.CH_Workgroup__r.Name) != undefined){
                        csvStringResult += JSON.stringify(objectRecords[i].CH_Workgroup_Schedule__r.CH_Workgroup__r.Name).replaceAll(",",":");
                    } 
                    
                }
                else if(skey == 'CH_Workgroup_Schedule__r.Name') {
                    if(JSON.stringify(objectRecords[i].CH_Workgroup_Schedule__r.Name) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Schedule__r.Name) != undefined){
                        csvStringResult += JSON.stringify(objectRecords[i].CH_Workgroup_Schedule__r.Name).replaceAll(",",":");
                    } 
                    
                }
				else if(skey == 'CH_Workgroup_Schedule__r.CH_Start_Date__c') {
                        if(JSON.stringify(objectRecords[i].CH_Workgroup_Schedule__r.CH_Start_Date__c) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Schedule__r.CH_Start_Date__c) != undefined){
                            csvStringResult += JSON.stringify(objectRecords[i].CH_Workgroup_Schedule__r.CH_Start_Date__c);
                        } 
                        
                    }
                        else if(skey == 'CH_Workgroup_Schedule__r.CH_Start_Time__c') {
                            if(JSON.stringify(objectRecords[i].CH_Workgroup_Schedule__r.CH_Start_Time__c) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Schedule__r.CH_Start_Time__c) != undefined){
                                var date = new Date(objectRecords[i].CH_Workgroup_Schedule__r.CH_Start_Time__c);
                                var stDate=$A.localizationService.formatTimeUTC(date);
                                csvStringResult += stDate.toString();
                            } 
                        }
                            else if(skey == 'CH_Workgroup_Schedule__r.CH_End_Date__c') {
                                if(JSON.stringify(objectRecords[i].CH_Workgroup_Schedule__r.CH_End_Date__c) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Schedule__r.CH_End_Date__c) != undefined){
                                    csvStringResult += JSON.stringify(objectRecords[i].CH_Workgroup_Schedule__r.CH_End_Date__c);
                                } 
                                
                            }
                                else if(skey == 'CH_Workgroup_Schedule__r.CH_End_Time__c') {
                                    if(JSON.stringify(objectRecords[i].CH_Workgroup_Schedule__r.CH_End_Time__c) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Schedule__r.CH_End_Time__c) != undefined){
                                        var date = new Date(objectRecords[i].CH_Workgroup_Schedule__r.CH_End_Time__c);
                                        var etDate=$A.localizationService.formatTimeUTC(date);
                                        csvStringResult += etDate.toString();
                                    } 
                                }
                    else if(skey == 'CH_Workgroup_Schedule__r.CH_Time_Zone__c') {
                        if(JSON.stringify(objectRecords[i].CH_Workgroup_Schedule__r.CH_Time_Zone__c) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Schedule__r.CH_Time_Zone__c) != undefined){
                            csvStringResult += JSON.stringify(objectRecords[i].CH_Workgroup_Schedule__r.CH_Time_Zone__c);
                        } 
                        
                    }
                        else if(skey === 'Name'){
                            if(JSON.stringify(objectRecords[i].Name) !== null && JSON.stringify(objectRecords[i].Name) != undefined){
                                csvStringResult += JSON.stringify(objectRecords[i].Name);
                            } 
                        }
                            else if(skey === 'Id'){
                                if(JSON.stringify(objectRecords[i].Id) !== null && JSON.stringify(objectRecords[i].Id) != undefined){
                                    csvStringResult += JSON.stringify(objectRecords[i].Id);
                                } 
                            }
                                else if(skey === 'CH_Day__c'){
                                    if(JSON.stringify(objectRecords[i].CH_Day__c) !== null && JSON.stringify(objectRecords[i].CH_Day__c) != undefined){
                                        csvStringResult += JSON.stringify(objectRecords[i].CH_Day__c).replaceAll(";", ":");
                                    } 
                                }
                                    else if(skey === 'CH_Start_Time__c'){
                                        if(JSON.stringify(objectRecords[i].CH_Start_Time__c) !== null && JSON.stringify(objectRecords[i].CH_Start_Time__c) != undefined){
                                            var date = new Date(objectRecords[i].CH_Start_Time__c);
                                            var s1Date=$A.localizationService.formatTimeUTC(date);
                                            csvStringResult += s1Date.toString();
                                        } 
                                    }
                                        else if(skey === 'CH_End_Time__c'){
                                            if(JSON.stringify(objectRecords[i].CH_End_Time__c) !== null && JSON.stringify(objectRecords[i].CH_End_Time__c) != undefined){
                                                var date = new Date(objectRecords[i].CH_End_Time__c);
                                                var s2Date=$A.localizationService.formatTimeUTC(date);
                                                csvStringResult += s2Date.toString();
                                            } 
                                        }
                                            else if(typeof objectRecords[i][skey] === 'undefined'){
                                                csvStringResult += '"'+ objectRecords[i][skey]+'"';
                                            }else{
                                                csvStringResult += '"'+ '' +'"';
                                            }
                counter++;
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        // return the CSV formate String 
        return csvStringResult;        
    },
    
    convertTimeSlotMembersObject : function(component,objectRecords){
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variable for sparate CSV values and for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        // in the keys variables store the fields API Names as a key 
        // labels are used in CSV file header  
        
        keys = ['CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Workgroup__r.Name',
                'CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.Name',
				'CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Start_Date__c',
                'CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Start_Time__c',
                'CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_End_Date__c',
                'CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_End_Time__c',
				'CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Time_Zone__c',
                'CH_Workgroup_Schedule_Timeslot__r.Name','CH_Workgroup_Schedule_Timeslot__r.Id',
                'CH_Workgroup_Schedule_Timeslot__r.CH_Day__c','CH_Workgroup_Schedule_Timeslot__r.CH_Start_Time__c',
                'CH_Workgroup_Schedule_Timeslot__r.CH_End_Time__c','Id','CH_Workgroup_Member__r.Name','CH_Workgroup_Member__r.Id','CH_Schedule_Type__c' ];
        csvStringResult = '';
        csvStringResult +=['Workgroup Name','Schedule Name','Schedule StartDate','Schedule StartTime','Schedule EndDate','Schedule EndTime',
                           'Schedule TimeZone','TimeSlot Name','TimeSlot Id','Day','Start Time','End Time',
                           'Workgroup Member Timeslot Association Id',
                           'Workgroup Member Name','Workgroup Member Id','Schedule Type','Operation'];
        csvStringResult += lineDivider;
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                // add , [comma] after every String value,. [except first]
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                } 
                if(skey == 'CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Workgroup__r.Name') {
                    if(JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Workgroup__r.Name) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Workgroup__r.Name) != undefined){
                        csvStringResult += JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Workgroup__r.Name).replaceAll(",",":");
                    } 
                    
                }
                else if(skey == 'CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.Name') {
                    if(JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.Name) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.Name) != undefined){
                        csvStringResult += JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.Name).replaceAll(",",":");
                    } 
                    
                }
				 else if(skey == 'CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Start_Date__c') {
                        if(JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Start_Date__c) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Start_Date__c) != undefined){
                            csvStringResult += JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Start_Date__c);
                        } 
                    }
                        else if(skey == 'CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Start_Time__c') {
                            if(JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Start_Time__c) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Start_Time__c) != undefined){
                                var date = new Date(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Start_Time__c);
                                var sTime=$A.localizationService.formatTimeUTC(date);
                                csvStringResult += sTime.toString();
                            } 
                        }
                            else if(skey == 'CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_End_Date__c') {
                                if(JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_End_Date__c) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_End_Date__c) != undefined){
                                    csvStringResult += JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_End_Date__c);
                                } 
                            }
                                else if(skey == 'CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_End_Time__c') {
                                    if(JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_End_Time__c) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_End_Time__c) != undefined){
                                        var date = new Date(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_End_Time__c);
                                        var eTime=$A.localizationService.formatTimeUTC(date);
                                        csvStringResult += eTime.toString();
                                    } 
                                }
                    else if(skey == 'CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Time_Zone__c') {
                        if(JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Time_Zone__c) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Time_Zone__c) != undefined){
                            csvStringResult += JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Time_Zone__c);
                        } 
                        
                    }
                        else if(skey === 'CH_Workgroup_Schedule_Timeslot__r.Name'){
                            if(JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.Name) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.Name) != undefined){
                                csvStringResult += JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.Name);
                            } 
                        }
                            else if(skey === 'CH_Workgroup_Schedule_Timeslot__r.Id'){
                                if(JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.Id) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.Id) != undefined){
                                    csvStringResult += JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.Id);
                                } 
                            }
                                else if(skey === 'CH_Workgroup_Schedule_Timeslot__r.CH_Day__c'){
                                    if(JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Day__c) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Day__c) != undefined){
                                        csvStringResult += JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Day__c).replaceAll(";", ":");
                                    } 
                                }
                                    else if(skey === 'CH_Workgroup_Schedule_Timeslot__r.CH_Start_Time__c'){
                                        if(JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Start_Time__c) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Start_Time__c) != undefined){
                                            var date = new Date(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_Start_Time__c);
                                            var s1Date=$A.localizationService.formatTimeUTC(date);
                                            csvStringResult += s1Date.toString();
                                        } 
                                    }
                                        else if(skey === 'CH_Workgroup_Schedule_Timeslot__r.CH_End_Time__c'){
                                            if(JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_End_Time__c) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_End_Time__c) != undefined){
                                                var date = new Date(objectRecords[i].CH_Workgroup_Schedule_Timeslot__r.CH_End_Time__c);
                                                var s2Date=$A.localizationService.formatTimeUTC(date);
                                                csvStringResult += s2Date.toString();
                                            } 
                                        }
                                            else if(skey === 'Id'){
                                                if(JSON.stringify(objectRecords[i].Id) !== null && JSON.stringify(objectRecords[i].Id) != undefined){
                                                    csvStringResult += JSON.stringify(objectRecords[i].Id);
                                                } 
                                            }
                                                else if(skey === 'CH_Workgroup_Member__r.Name'){
                                                    if(JSON.stringify(objectRecords[i].CH_Workgroup_Member__r.Name) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Member__r.Name) != undefined){
                                                        csvStringResult += JSON.stringify(objectRecords[i].CH_Workgroup_Member__r.Name);
                                                    } 
                                                }
                                                    else if(skey === 'CH_Workgroup_Member__r.Id'){
                                                        if(JSON.stringify(objectRecords[i].CH_Workgroup_Member__r.Id) !== null && JSON.stringify(objectRecords[i].CH_Workgroup_Member__r.Id) != undefined){
                                                            csvStringResult += JSON.stringify(objectRecords[i].CH_Workgroup_Member__r.Id);
                                                        } 
                                                    }
                                                        else if(skey === 'CH_Schedule_Type__c'){
                                                            if(JSON.stringify(objectRecords[i].CH_Schedule_Type__c) !== null && JSON.stringify(objectRecords[i].CH_Schedule_Type__c) != undefined){
                                                                csvStringResult += JSON.stringify(objectRecords[i].CH_Schedule_Type__c);
                                                            } 
                                                        }
                                                            else if(typeof objectRecords[i][skey] === 'undefined'){
                                                                csvStringResult += '"'+ objectRecords[i][skey]+'"';
                                                            }else{
                                                                csvStringResult += '"'+ '' +'"';
                                                            }
                counter++;
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        
        // return the CSV formate String 
        return csvStringResult;        
    },
	
	//Read the Import file for TimeSlot Data
    readTimeSlotFile: function(component, helper, file) {
        var filename = file.name;
        if(!file.name.match(/\.(csv||CSV)$/)){
            component.set("v.openImport", false);
            component.set("v.isColumnError",true);
            //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
            helper.validateButtons(component,event,helper,$A.get("$Label.c.CH_Import_Function_Aborted_For_Incorrect_Format"),"ERROR");   
               
            return;
        }
        else{
            reader = new FileReader();
            reader.onerror =function errorHandler(evt) {
                switch(evt.target.error.code) {
                    case evt.target.error.NOT_FOUND_ERR:
                        alert('File Not Found!');
                        break;
                    case evt.target.error.NOT_READABLE_ERR:
                        alert('File is not readable');
                        break;
                    case evt.target.error.ABORT_ERR:
                        break; 
                    default:
                        alert('An error occurred reading this file.');
                };
            }
            reader.onabort = function(e) {
                alert('File read cancelled');
            };
            reader.onloadstart = function(e) { 
                var output = '<ui type=\"disc\"><li><strong> File Name :&nbsp'+file.name +'</strong>'+'</li></ui>';
            };
            reader.onload = function(e) {
                component.set("v.isColumnError",false);
                var csvData=e.target.result;
                var csvRow=csvData.split(/\r\n|\n/);
                csvRow.pop();
                var csvHeader=csvRow[0].includes(";")?csvRow[0].split(';'):csvRow[0].split(',');
                var finalDataTable=[];
                var fieldsList=[{'API':'workgroupName','label':'Workgroup Name'},{'API':'scheduleName','label':'Schedule Name'},
                                {'API':'scheduleStartDate','label':'Schedule StartDate'},{'API':'scheduleStartTime','label':'Schedule StartTime'},
                                {'API':'scheduleEndDate','label':'Schedule EndDate'},{'API':'scheduleEndTime','label':'Schedule EndTime'},
                                {'API':'scheduleTimeZone','label':'Schedule TimeZone'},{'API':'timeslotName','label':'TimeSlot Name'},
                                {'API':'getTimeslotId','label':'TimeSlot Id'},{'API':'day','label':'Day'},
                                {'API':'startTime','label':'Start Time'},{'API':'endTime','label':'End Time'},
                                {'API':'operationType','label':'Operation'}
                               ];
                var thisHelper = this;
                if(csvRow.length<=1){
                    //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                    helper.showToast("ERROR","",
                                     $A.get("$Label.c.CH_Import_Function_Aborted_For_Empty_Cell")
                                    );
                    component.set("v.openImport", false);
                    component.set("v.isColumnError",true);
                    component.set("v.Spinner", false);
                }
				if(!component.get("v.isColumnError")){
                for(var i=1;i<csvRow.length;i++){
                        var csvColumn =csvRow[0].includes(";")?csvRow[i].split(';'):csvRow[i].split(',');
                        var rowObject={};
                        if(csvHeader.length==13){
                            for(var k=0;k<13;k++){
                                var getAPI =  fieldsList.filter(function(item) {
                                    return item.label == csvHeader[k];
                                });
                                if(getAPI.length==0){
                                    helper.showToast("ERROR","",
                                                     "The Import Function is aborted due to following incorrect Header Name:"+csvHeader[k]+" in the file to be imported. Please review your changes."
                                                    );
                                    component.set("v.openImport", false);
                                    component.set("v.isColumnError",true);
                                    component.set("v.Spinner", false);
                                    break;
                                }
                                var apiName=getAPI[0].API;
                                if(apiName!='' ||  apiName!= "undefined"){
                                    if(csvColumn[k]==""||csvColumn[k]== null||csvColumn[k] == undefined || csvColumn[k] =="undefined"){
                                        //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                                        helper.showToast("ERROR","",
                                                         $A.get("$Label.c.CH_Import_Function_Aborted_For_Empty_Cell")
                                                        );
                                        component.set("v.openImport", false);
                                        component.set("v.isColumnError",true);
                                        component.set("v.Spinner", false);
                                        break;
                                    }
                                    else{
                                        var getOperationValue=csvColumn[k].toLowerCase().trim();
                                        if(apiName.trim()=="operationType"&& (getOperationValue!="update"&&getOperationValue!="delete"&&getOperationValue!="unchanged")){
                                           //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                                            helper.showToast("ERROR","",$A.get("$Label.c.CH_Import_Function_Aborted_For_Data_Inconsistency"));
                                             component.set("v.openImport", false);
                                            component.set("v.isColumnError",true);
                                            component.set("v.Spinner", false);
                                            break;
                                            
                                        } 
                                        else{
                                            rowObject[apiName] = csvColumn[k].trim();
                                        }
                                    }
                                }
                            }
                            finalDataTable.push(rowObject);
                        }
                        else{
                            helper.showToast("ERROR","","The Import Function is aborted due to inconsistency between your selection : "+component.get("v.radioValue")+" and the format of the selected file. Please review your selection.");
                            component.set("v.openImport", false);
                            component.set("v.isColumnError",true);
                            component.set("v.Spinner", false);
                        }
                        
                    }
                }
                var getLimit=$A.get("$Label.c.CH_ManageSchedule_ExcelLimit");
                if((!component.get("v.isColumnError")) && finalDataTable.length>getLimit){
                    helper.showToast("ERROR","","The Import Function file should contain less than "+getLimit+" records. Please review your selection.");
                    component.set("v.openImport", false);
                    component.set("v.isColumnError",true);
                    component.set("v.Spinner", false);
                }
                if(!component.get("v.isColumnError")){
                    helper.isActiveSchedule(component,JSON.stringify(finalDataTable))
                    .then(function(result){
                        component.set('v.isActiveSchedule', result); 
                        if(result){
                            component.set("v.openImport", false);
                            component.set("v.isColumnError",true);
                            //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                            helper.validateButtons(component,event,helper,$A.get("$Label.c.CH_Import_Not_Allowed_On_Active_Schedule"),"ERROR"); 
                        }
                        return result;
                    })
                    .then(function(result){
                        if(!component.get('v.isActiveSchedule')){
                            var action = component.get("c.processtimeSlotData");
                            action.setParams({ fileData : JSON.stringify(finalDataTable)});
                            action.setCallback(this, function(response) {
                                var state = response.getState();
                                if (state === "SUCCESS") {  
                                    component.set("v.openImport", false);
                                    var result=response.getReturnValue();
                                    component.set('v.listOfTimeSlot', result);
                                    var getRecords = component.get("v.listOfTimeSlot");
                                    var csv = helper.getTimeSlotErrorFile(component,getRecords);
                                    var messageBox = component.find('messageBox'); 
                                    if (csv == null){
                                        messageBox.displayToastMessage("Import File Processed Sucessfully");
                                        component.set("v.Spinner", false);
                                        return;
                                    } 
                                    // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####  
                                    var getCurrentDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
                                    var hiddenElement = document.createElement('a');
                                    hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                                    hiddenElement.target = '_self'; // 
                                    hiddenElement.download = 'Error TimeSlot_'+getCurrentDate+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
                                    document.body.appendChild(hiddenElement); // Required for FireFox browser
                                    hiddenElement.click(); // using click() js function to download csv file
                                    // Display the status of the save
                                    messageBox.displayToastMessage("Import File Processed with Errors","INFO");
                                    component.set("v.Spinner", false);
                                }
                                else if (state === "ERROR") {
                                    component.set("v.openImport", false);
                                    component.set("v.isColumnError",true);
                                    //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                                    helper.validateButtons(component,event,helper,$A.get("$Label.c.CH_Import_Function_Aborted_For_File_Inconsistency"),"ERROR");  
                                }
                                    else if (state === "INCOMPLETE") {
                                    }
                            });
                            $A.enqueueAction(action);
                        }
                    })
                    .catch(function(error) {
                        component.set("v.openImport", false);
                        component.set("v.isColumnError",true);
                        //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                        helper.validateButtons(component,event,helper,$A.get("$Label.c.CH_Import_Function_Aborted_For_File_Inconsistency"),"ERROR");  
                    });
                    
                }
                
            }
            reader.readAsText(file);
        }
        
        var reader = new FileReader();
        reader.onloadend = function() {
        };
        reader.readAsDataURL(file);
    },
    
     //Read the Import file for TimeSlotMembers Data
    readTimeSlotMembersFile: function(component, helper, file) {
        var filename = file.name;
        if(!file.name.match(/\.(csv||CSV)$/)){
            component.set("v.openImport", false);
            component.set("v.isColumnError",true);
            component.set("v.Spinner", false);
            //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
            helper.validateButtons(component,event,helper,$A.get("$Label.c.CH_Import_Function_Aborted_For_Incorrect_Format"),"ERROR");            
            
            return;
        }
        else{
            reader = new FileReader();
            reader.onerror =function errorHandler(evt) {
                switch(evt.target.error.code) {
                    case evt.target.error.NOT_FOUND_ERR:
                        alert('File Not Found!');
                        break;
                    case evt.target.error.NOT_READABLE_ERR:
                        alert('File is not readable');
                        break;
                    case evt.target.error.ABORT_ERR:
                        break; 
                    default:
                        alert('An error occurred reading this file.');
                };
            }
            reader.onabort = function(e) {
                alert('File read cancelled');
            };
            reader.onloadstart = function(e) { 
                var output = '<ui type=\"disc\"><li><strong> File Name :&nbsp'+file.name +'</strong>'+'</li></ui>';
            };
            reader.onload = function(e) {
                component.set("v.isColumnError",false);
                var csvData=e.target.result;
                var csvRow=csvData.split(/\r\n|\n/);
                csvRow.pop();
                var csvHeader=csvRow[0].includes(";")?csvRow[0].split(';'):csvRow[0].split(',');
                var finalDataTable=[];
                var fieldsList=[{'API':'workgroupName','label':'Workgroup Name'},{'API':'scheduleName','label':'Schedule Name'},
                                {'API':'scheduleStartDate','label':'Schedule StartDate'},{'API':'scheduleStartTime','label':'Schedule StartTime'},
                                {'API':'scheduleEndDate','label':'Schedule EndDate'},{'API':'scheduleEndTime','label':'Schedule EndTime'},
                                {'API':'scheduleTimeZone','label':'Schedule TimeZone'},{'API':'timeslotName','label':'TimeSlot Name'},
                                {'API':'getTimeslotId','label':'TimeSlot Id'},{'API':'day','label':'Day'},
                                {'API':'startTime','label':'Start Time'},{'API':'endTime','label':'End Time'},
                                {'API':'getTimeslotMemberId','label':'Workgroup Member Timeslot Association Id'},
                                {'API':'workgroupMemberName','label':'Workgroup Member Name'},
                                {'API':'getmemberId','label':'Workgroup Member Id'},
                                {'API':'scheduleType','label':'Schedule Type'},{'API':'operationType','label':'Operation'}
                               ];
                var thisHelper = this;
                if(csvRow.length<=1){
                   //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                    helper.showToast("ERROR","",
                                     $A.get("$Label.c.CH_Import_Function_Aborted_For_Empty_Cell")
                                    );
                     component.set("v.openImport", false);
                    component.set("v.isColumnError",true);
                    component.set("v.Spinner", false);
                }
			if(!component.get("v.isColumnError")){
                for(var i=1;i<csvRow.length;i++){
                        var csvColumn =csvRow[0].includes(";")?csvRow[i].split(';'):csvRow[i].split(',');
                        var rowObject={};
                        if(csvHeader.length==17){
                            for(var k=0;k<17;k++){
                                var getAPI =  fieldsList.filter(function(item) {
                                    return item.label == csvHeader[k];
                                    
                                });
                                if(getAPI.length==0){
                                    helper.showToast("ERROR","",
                                                     "The Import Function is aborted due to following incorrect Header Name:"+csvHeader[k]+" in the file to be imported. Please review your changes."
                                                    );
                                    component.set("v.openImport", false);
                                    component.set("v.isColumnError",true);
                                    component.set("v.Spinner",false);
                                    break;
                                    
                                }
                                var apiName=getAPI[0].API;
                                if(apiName!='' ||  apiName!= "undefined"){
                                    if(csvColumn[k]==""||csvColumn[k]== null||csvColumn[k] == undefined || csvColumn[k] =="undefined"){
                                        //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                                        helper.showToast("ERROR","",$A.get("$Label.c.CH_Import_Function_Aborted_For_Empty_Cell"));
                                       component.set("v.openImport", false);
                                        component.set("v.isColumnError",true);
                                        component.set("v.Spinner", false);
                                        break;
                                        
                                    }
                                    else{
                                        var getOperationValue=csvColumn[k].toLowerCase().trim();
                                        if(apiName.trim()=="operationType"&& (getOperationValue!="update"&&getOperationValue!="delete"&&getOperationValue!="insert"&&getOperationValue!="unchanged")){
											//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                                            helper.showToast("ERROR","",$A.get("$Label.c.CH_Import_Function_Aborted_For_Data_Inconsistency"));
										  component.set("v.openImport", false);
                                            component.set("v.isColumnError",true);
                                            component.set("v.Spinner", false);
                                            break;
                                        } 
                                        else{
                                            rowObject[apiName] = csvColumn[k].trim();
                                        }
                                    }
                                }
                            }
                            finalDataTable.push(rowObject);
                        }
                        else{
                            helper.showToast("ERROR","","The Import Function is aborted due to inconsistency between your selection : "+component.get("v.radioValue")+" and the format of the selected file. Please review your selection.");
                            component.set("v.openImport", false);
                            component.set("v.isColumnError",true);
                            component.set("v.Spinner", false);
                        }
                    }
                }
                var getLimit=$A.get("$Label.c.CH_ManageSchedule_ExcelLimit");
                if((!component.get("v.isColumnError")) && finalDataTable.length>getLimit){
                    helper.showToast("ERROR","","The Import Function file should contain less than "+getLimit+" records. Please review your selection.");
                    component.set("v.openImport", false);
                    component.set("v.isColumnError",true);
                    component.set("v.Spinner", false);
                }
                if(!component.get("v.isColumnError")){
                    helper.isActiveSchedule(component,JSON.stringify(finalDataTable))
                    .then(function(result){
                        component.set('v.isActiveSchedule', result); 
                        if(result){
                            component.set("v.openImport", false);
                            component.set("v.isColumnError",true);
                            //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                            helper.validateButtons(component,event,helper,$A.get("$Label.c.CH_Import_Not_Allowed_On_Active_Schedule"),"ERROR"); 
                        
                        }
                        return result;
                    })
                    .then(function(result){
                        if(!component.get('v.isActiveSchedule')){
                            var action = component.get("c.processtimeSlotMembersData");
                            action.setParams({ fileData : JSON.stringify(finalDataTable)});
                            action.setCallback(this, function(response) {
                                var state = response.getState();
                                if (state === "SUCCESS") {  
                                    component.set("v.openImport", false);
                                    var result=response.getReturnValue();
                                    component.set('v.listOfTimeSlotMembers', result);
                                    var getRecords = component.get("v.listOfTimeSlotMembers");
                                    var csv = helper.getTimeslotMemberAssociationErrorFile(component,getRecords);
                                    var messageBox = component.find('messageBox'); 
                                    if (csv == null){
                                        component.set("v.Spinner", false);
                                        messageBox.displayToastMessage("Import File Processed without any Errors");
                                        return;
                                    } 
                                    // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####  
                                    var getCurrentDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
                                    var hiddenElement = document.createElement('a');
                                    hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                                    hiddenElement.target = '_self'; // 
                                    hiddenElement.download = 'Error TimeSlotMembers_'+getCurrentDate+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
                                    document.body.appendChild(hiddenElement); // Required for FireFox browser
                                    hiddenElement.click(); // using click() js function to download csv file
                                    // Display the status of the save
                                    messageBox.displayToastMessage("Import File Processed with Errors","INFO");
                                    component.set("v.Spinner", false);
                                }
                                else if (state === "ERROR") {
                                    component.set("v.openImport", false);
                                    component.set("v.isColumnError",true);
                                    //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                                    helper.validateButtons(component,event,helper,$A.get("$Label.c.CH_Import_Function_Aborted_For_File_Inconsistency"),"ERROR");  
                                }
                                    else if (state === "INCOMPLETE") {
                                    }
                            });
                            $A.enqueueAction(action);
                        }
                    })
                    .catch(function(error) {
                        component.set("v.openImport", false);
                        component.set("v.isColumnError",true);
                        //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                        helper.validateButtons(component,event,helper,$A.get("$Label.c.CH_Import_Function_Aborted_For_File_Inconsistency"),"ERROR");  
                    });
                    
                }
                
            }
            reader.readAsText(file);
        }
        
        var reader = new FileReader();
        reader.onloadend = function() {
        };
        reader.readAsDataURL(file);
    },
    
    //Export the Import file Errors for TimeSlot Data
    getTimeSlotErrorFile: function(component,objectRecords){
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variable for sparate CSV values and for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        // in the keys variables store the fields API Names as a key 
        // labels are used in CSV file header  
        keys = ['CH_Bind1__c','CH_Bind2__c','CH_Bind3__c','CH_Bind4__c',
                'CH_Bind5__c','CH_Bind6__c','CH_Bind7__c','CH_Bind8__c','CH_Bind9__c',
                'CH_Bind10__c','CH_Bind11__c','CH_Bind12__c','CH_Bind13__c'
               ];
        csvStringResult = '';
        csvStringResult +=['Workgroup Name','Schedule Name','Schedule StartDate','Schedule StartTime','Schedule EndDate',
                           'Schedule EndTime','Schedule TimeZone','TimeSlot Name','TimeSlot Id','Day',
                           'Start Time','End Time','Error Message'];
        csvStringResult += lineDivider;
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                // add , [comma] after every String value,. [except first]
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }   
                if(skey == 'CH_Bind1__c') {
                    if(JSON.stringify(objectRecords[i].CH_Bind1__c) !== null && JSON.stringify(objectRecords[i].CH_Bind1__c) != undefined){
                        csvStringResult += JSON.stringify(objectRecords[i].CH_Bind1__c).replaceAll(",",":");
                    } 
                    
                }
                else if(skey === 'CH_Bind2__c'){
                    if(JSON.stringify(objectRecords[i].CH_Bind2__c) !== null && JSON.stringify(objectRecords[i].CH_Bind2__c) != undefined){
                        csvStringResult += JSON.stringify(objectRecords[i].CH_Bind2__c).replaceAll(",",":");
                    } 
                }
                    else if(skey === 'CH_Bind3__c'){
                        if(JSON.stringify(objectRecords[i].CH_Bind3__c) !== null && JSON.stringify(objectRecords[i].CH_Bind3__c) != undefined){
                            csvStringResult += JSON.stringify(objectRecords[i].CH_Bind3__c);
                        } 
                    }
                        else if(skey === 'CH_Bind4__c'){
                            if(JSON.stringify(objectRecords[i].CH_Bind6__c) !== null && JSON.stringify(objectRecords[i].CH_Bind4__c) != undefined){
                                csvStringResult += JSON.stringify(objectRecords[i].CH_Bind4__c);
                            } 
                        }
                            else if(skey === 'CH_Bind5__c'){
                                if(JSON.stringify(objectRecords[i].CH_Bind5__c) !== null && JSON.stringify(objectRecords[i].CH_Bind5__c) != undefined){
                                    csvStringResult += JSON.stringify(objectRecords[i].CH_Bind5__c);
                                } 
                            }
                                else if(skey === 'CH_Bind6__c'){
                                    if(JSON.stringify(objectRecords[i].CH_Bind6__c) !== null && JSON.stringify(objectRecords[i].CH_Bind6__c) != undefined){
                                        csvStringResult += JSON.stringify(objectRecords[i].CH_Bind6__c);
                                    } 
                                }
                                    else if(skey === 'CH_Bind7__c'){
                                        if(JSON.stringify(objectRecords[i].CH_Bind7__c) !== null && JSON.stringify(objectRecords[i].CH_Bind7__c) != undefined){
                                            csvStringResult += JSON.stringify(objectRecords[i].CH_Bind7__c);
                                        } 
                                    }
                                        else if(skey === 'CH_Bind8__c'){
                                            if(JSON.stringify(objectRecords[i].CH_Bind8__c) !== null && JSON.stringify(objectRecords[i].CH_Bind8__c) != undefined){
                                                csvStringResult += JSON.stringify(objectRecords[i].CH_Bind8__c);
                                            } 
                                        }
                                            else if(skey === 'CH_Bind9__c'){
                                                if(JSON.stringify(objectRecords[i].CH_Bind9__c) !== null && JSON.stringify(objectRecords[i].CH_Bind9__c) != undefined){
                                                    csvStringResult += JSON.stringify(objectRecords[i].CH_Bind9__c);
                                                } 
                                            }
												else if(skey === 'CH_Bind10__c'){
                                                    if(JSON.stringify(objectRecords[i].CH_Bind10__c) !== null && JSON.stringify(objectRecords[i].CH_Bind10__c) != undefined){
                                                        csvStringResult += JSON.stringify(objectRecords[i].CH_Bind10__c);
                                                    } 
                                                }
                                                    else if(skey === 'CH_Bind11__c'){
                                                        if(JSON.stringify(objectRecords[i].CH_Bind11__c) !== null && JSON.stringify(objectRecords[i].CH_Bind11__c) != undefined){
                                                            csvStringResult += JSON.stringify(objectRecords[i].CH_Bind11__c);
                                                        } 
                                                    }
                                                        else if(skey === 'CH_Bind12__c'){
                                                            if(JSON.stringify(objectRecords[i].CH_Bind12__c) !== null && JSON.stringify(objectRecords[i].CH_Bind12__c) != undefined){
                                                                csvStringResult += JSON.stringify(objectRecords[i].CH_Bind12__c);
                                                            } 
                                                        }
                                                            else if(skey === 'CH_Bind13__c'){
                                                                if(JSON.stringify(objectRecords[i].CH_Bind13__c) !== null && JSON.stringify(objectRecords[i].CH_Bind13__c) != undefined){
                                                                    var getOperationVal=JSON.stringify(objectRecords[i].CH_Bind13__c).replaceAll('"','');
                                                                    if(getOperationVal === "entity is deleted"){
                                                                        csvStringResult +='WG member does not belong to the timeslot';
                                                                    }
                                                                    else{
                                                                        csvStringResult += JSON.stringify(objectRecords[i].CH_Bind13__c);
                                                                    }
                                                                } 
                                                            }
																else if(typeof objectRecords[i][skey] === 'undefined'){
																	csvStringResult += '"'+ objectRecords[i][skey]+'"';
																}else{
																	csvStringResult += '"'+ '' +'"';
																}
                counter++;
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        
        // return the CSV formate String 
        return csvStringResult;        
    },
    
    //Export the Import file Errors for TimeSlot Members Data
    getTimeslotMemberAssociationErrorFile: function(component,objectRecords){
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variable for sparate CSV values and for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        // in the keys variables store the fields API Names as a key 
        // labels are used in CSV file header  
        
        keys = ['CH_Bind1__c','CH_Bind2__c','CH_Bind3__c','CH_Bind4__c',
                'CH_Bind5__c','CH_Bind6__c','CH_Bind7__c','CH_Bind8__c',
                'CH_Bind9__c','CH_Bind10__c','CH_Bind11__c','CH_Bind12__c','CH_Bind13__c',
                'CH_Bind_16__c','CH_Bind_17__c','CH_Bind19__c','CH_Bind20__c'];
        csvStringResult = '';
        csvStringResult +=['Workgroup Name','Schedule Name','Schedule StartDate','Schedule StartTime','Schedule EndDate',
                           'Schedule EndTime','Schedule TimeZone','TimeSlot Name','TimeSlot Id','Day','Start Time','End Time',
                           'Workgroup Member Timeslot Association Id','Workgroup Member Name','Workgroup Member Id',
                           'Schedule Type','Error Message'];
        csvStringResult += lineDivider;
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                // add , [comma] after every String value,. [except first]
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }   
                if(skey == 'CH_Bind1__c') {
                    if(JSON.stringify(objectRecords[i].CH_Bind1__c) !== null && JSON.stringify(objectRecords[i].CH_Bind1__c) != undefined){
                        csvStringResult += JSON.stringify(objectRecords[i].CH_Bind1__c).replaceAll(",",":");
                    } 
                    
                }
                else if(skey === 'CH_Bind2__c'){
                    if(JSON.stringify(objectRecords[i].CH_Bind2__c) !== null && JSON.stringify(objectRecords[i].CH_Bind2__c) != undefined){
                        csvStringResult += JSON.stringify(objectRecords[i].CH_Bind2__c).replaceAll(",",":");
                    } 
                }
                    else if(skey === 'CH_Bind3__c'){
                        if(JSON.stringify(objectRecords[i].CH_Bind3__c) !== null && JSON.stringify(objectRecords[i].CH_Bind3__c) != undefined){
                            csvStringResult += JSON.stringify(objectRecords[i].CH_Bind3__c);
                        } 
                    }
                        else if(skey === 'CH_Bind4__c'){
                            if(JSON.stringify(objectRecords[i].CH_Bind4__c) !== null && JSON.stringify(objectRecords[i].CH_Bind4__c) != undefined){
                                csvStringResult += JSON.stringify(objectRecords[i].CH_Bind4__c);
                            } 
                        }
                            else if(skey === 'CH_Bind5__c'){
                                if(JSON.stringify(objectRecords[i].CH_Bind5__c) !== null && JSON.stringify(objectRecords[i].CH_Bind5__c) != undefined){
                                    csvStringResult += JSON.stringify(objectRecords[i].CH_Bind5__c);
                                } 
                            }
                                else if(skey === 'CH_Bind6__c'){
                                    if(JSON.stringify(objectRecords[i].CH_Bind6__c) !== null && JSON.stringify(objectRecords[i].CH_Bind6__c) != undefined){
                                        csvStringResult += JSON.stringify(objectRecords[i].CH_Bind6__c);
                                    } 
                                }
                                    else if(skey === 'CH_Bind7__c'){
                                        if(JSON.stringify(objectRecords[i].CH_Bind7__c) !== null && JSON.stringify(objectRecords[i].CH_Bind7__c) != undefined){
                                            csvStringResult += JSON.stringify(objectRecords[i].CH_Bind7__c);
                                        } 
                                    }
                                        else if(skey === 'CH_Bind8__c'){
                                            if(JSON.stringify(objectRecords[i].CH_Bind8__c) !== null && JSON.stringify(objectRecords[i].CH_Bind8__c) != undefined){
                                                csvStringResult += JSON.stringify(objectRecords[i].CH_Bind8__c);
                                            } 
                                        }
                                            else if(skey === 'CH_Bind9__c'){
                                                if(JSON.stringify(objectRecords[i].CH_Bind9__c) !== null && JSON.stringify(objectRecords[i].CH_Bind9__c) != undefined){
                                                    csvStringResult += JSON.stringify(objectRecords[i].CH_Bind9__c);
                                                } 
                                            }
                                                else if(skey === 'CH_Bind10__c'){
                                                    if(JSON.stringify(objectRecords[i].CH_Bind10__c) !== null && JSON.stringify(objectRecords[i].CH_Bind10__c) != undefined){
                                                        csvStringResult += JSON.stringify(objectRecords[i].CH_Bind10__c);
                                                    } 
                                                }
                                                    else if(skey === 'CH_Bind11__c'){
                                                        if(JSON.stringify(objectRecords[i].CH_Bind11__c) !== null && JSON.stringify(objectRecords[i].CH_Bind11__c) != undefined){
                                                            csvStringResult += JSON.stringify(objectRecords[i].CH_Bind11__c);
                                                        } 
                                                    }
                                                        else if(skey === 'CH_Bind12__c'){
                                                            if(JSON.stringify(objectRecords[i].CH_Bind12__c) !== null && JSON.stringify(objectRecords[i].CH_Bind12__c) != undefined){
                                                                csvStringResult += JSON.stringify(objectRecords[i].CH_Bind12__c);
                                                            } 
                                                        }
                                                            else if(skey === 'CH_Bind13__c'){
                                                                if(JSON.stringify(objectRecords[i].CH_Bind13__c) !== null && JSON.stringify(objectRecords[i].CH_Bind13__c) != undefined){
                                                                    csvStringResult += JSON.stringify(objectRecords[i].CH_Bind13__c);
                                                                } 
                                                            }
																else if(skey === 'CH_Bind_16__c'){
                                                                    if(JSON.stringify(objectRecords[i].CH_Bind_16__c) !== null && JSON.stringify(objectRecords[i].CH_Bind_16__c) != undefined){
                                                                        csvStringResult += JSON.stringify(objectRecords[i].CH_Bind_16__c);
                                                                    } 
                                                                }
                                                                    else if(skey === 'CH_Bind_17__c'){
                                                                        if(JSON.stringify(objectRecords[i].CH_Bind_17__c) !== null && JSON.stringify(objectRecords[i].CH_Bind_17__c) != undefined){
                                                                            csvStringResult += JSON.stringify(objectRecords[i].CH_Bind_17__c);
                                                                        } 
                                                                    }
                                                                        else if(skey === 'CH_Bind19__c'){
                                                                            if(JSON.stringify(objectRecords[i].CH_Bind19__c) !== null && JSON.stringify(objectRecords[i].CH_Bind19__c) != undefined){
                                                                                csvStringResult += JSON.stringify(objectRecords[i].CH_Bind19__c);
                                                                            } 
                                                                        }
                                                                            else if(skey === 'CH_Bind20__c'){
                                                                                if(JSON.stringify(objectRecords[i].CH_Bind20__c) !== null && JSON.stringify(objectRecords[i].CH_Bind20__c) != undefined){
                                                                                    var getOperationVal=JSON.stringify(objectRecords[i].CH_Bind20__c).replaceAll('"','');
                                                                                    if(getOperationVal === "entity is deleted"){
                                                                                        csvStringResult +='WG member does not belong to the timeslot';
                                                                                    }
                                                                                    else{
                                                                                        csvStringResult += JSON.stringify(objectRecords[i].CH_Bind20__c);
                                                                                    }
                                                                                } 
                                                                            }
																				else if(typeof objectRecords[i][skey] === 'undefined'){
																					csvStringResult += '"'+ objectRecords[i][skey]+'"';
																				}else{
																					csvStringResult += '"'+ '' +'"';
																				}
                counter++;
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        
        // return the CSV formate String 
        return csvStringResult;        
    },
	
	// Check if the Schedule is active or not
    isActiveSchedule: function(component,filedata){  
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'isScheduleActive',{ fileData: filedata}));
        }); 
        return promise;
    },
	
	 //Helper method to display the error toast message
    showToast : function(type,title,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: message,
            duration:'10000',
            key: 'info_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire(); 
    },
	
	//Validating the buttons on the manage Schedules
	validateButtons:function(component,event,helper,errorMessage,status){
        component.set("v.Spinner", false);
        // Disable the delete button
        var button = component.find('deleteScheduleButton');
        button.set('v.disabled',true);
        // Disable the Clone Button
        var cloneButton = component.find('cloneButton');
        cloneButton.set('v.disabled',true);
        // Disable the Export Button
        var exportButton = component.find('exportButton');
        exportButton.set('v.disabled',true);
        //Disable the Validate Button
        var validatebutton = component.find('validateButton');
        validatebutton.set('v.disabled',true);
        // Display the status of the save
        helper.showToast(status,"",errorMessage);
    },
})