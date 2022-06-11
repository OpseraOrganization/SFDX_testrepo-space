({
    // Create the datatable and load it 
    init: function(component){
        var membersList;
        var thisHelper = this;
        var messageBox = component.find('messageBox'); 
        component.set("v.Spinner", true); 
        thisHelper.setCaseAssignType(component)
        .then(function(result){
            component.set('v.isActiveAssignment', result); 
            //NOKIASC-34648
            return thisHelper.hwsCaseCheck(component);
        })
        .then(function(result){
        	component.set('v.isHWSCase', result);
            return thisHelper.getWorkgroupMembers(component);
        })
        .then(function(result){
            membersList = result;
            
            // Exception on US NOKIASC-20664
            // If no workgroup members are found 
            if(membersList.length == 0){
                membersList = null;
                //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                messageBox.displayToastMessage($A.get("$Label.c.CH_No_WG_Member_With_Security_Group_Found"), "error");
            }
            // If for active assignment no workgroup members are found
            if (membersList!= null && 
                membersList.length != 0 && 
                component.get('v.isActiveAssignment')){
                var IsQueue = false;
                for  (var member in membersList) {
                    if (membersList[member].role != 'Queue'){
                        IsQueue=true;
                    }
                }
                if(IsQueue == false)  {
                    //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                    messageBox.displayToastMessage($A.get("$Label.c.CH_No_WG_Member_With_Security_Group_Found_Contact_Manager"), "error");
                }                
            }
            // If for passive assignment no queue workgroup members are found
            if (membersList!= null &&
                membersList.length != 0 && 
                !component.get('v.isActiveAssignment')){
                var IsQueue = false;
                for  (var member in membersList) {
                    if (membersList[member].role == 'Queue'){
                        IsQueue=true;
                    }
                }
                if(IsQueue ==false)  {
                    membersList = null;
                     //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                    messageBox.displayToastMessage($A.get("$Label.c.CH_No_Queue_Member_With_Security_Group_Found_Contact_Manager"), "error");
                }
            }
            component.set('v.workgroupMembers', membersList);
            //Get the workgroup name
           // return thisHelper.getWorkgroupInstructions(component);
            return thisHelper.getWorkgroupName(component);
        })          
        .then(function(result){
            component.set('v.workgroupName', result.Name);
            // Create the table layout
            thisHelper.createTable(component, membersList);
			if (membersList!= null && 
                membersList.length != 0){
			thisHelper.displayWorkgrpInstructions(component, membersList);
		}
            //var callController=component.get("c.handleWorkgroupInstructions");
            //$A.enqueueAction(callController);            
            component.set("v.Spinner", false);
        })                     
        .catch(function(error) {
            component.set("v.Spinner", false);
            var messageBox = component.find('messageBox'); 
            messageBox.displayToastMessage("An error occured. " + error, "error");
        });
    },
    // Create the table to display the workgroup members
    createTable: function(component, workgroupMembers){
        var tableId = '#assignment-' + component.get("v.recordId");
        var thisHelper = this;
        $(tableId).DataTable({
            destroy: true,
            columnDefs: [{
                orderable: false,
                render: function(data, type, row, meta){
                    var buttonsDiv = '';
                    if (row['role'] != 'Queue'){
                        buttonsDiv += '<div><input type=button id="connect" value="Connect" ></div>';
                    }
                    return buttonsDiv;
                },
                data: null,
                defaultContent: '',
                width: '4em',
                targets: 0,
                title: 'Options'
            },{
                orderable: false,
                render: function(data, type, row, meta){
                    var buttonsDiv = '';
                    if (row['role'] != 'Hotline'){
                        buttonsDiv += '<div><input type=button id="assign" value="Assign" ></div>';
                    }
                    return buttonsDiv;
                },
                data: null,
                defaultContent: '',
                width: '4em',
                targets: 1
            },{
                data: 'name',
                defaultContent: '',
                className: 'popup',
                width: '15em',
                targets: 2,
                title: 'Member Details'
            },{
                data: 'scheduleType',
                defaultContent: '',
                width: '7em',
                targets: 3,
                title: 'Schedule Type'
            },{
                data: 'role',
                defaultContent: '',
                width: '15em',
                targets: 4,
                title: 'Role'
            },{            
                data: 'phone',
                defaultContent: '',
                width: '8em',
                targets: 5,
                title: 'Phone'
            },{             
                data: 'workgroupName',
                defaultContent: '',
                width: '15em',
                targets: 6,
                title: 'Workgroup'
            },
			  {
                    data: null,
                    render: function(data, type, row, meta) {
                        if (true) {
                            return (data = '<button id="Instructions" class="getInstructions"><span style="font-size:18px;">&#9432;</span></button>');
                        }
                    },
                    defaultContent: "",
                    width: "2em",
                    targets: 7
                    
                },
			{  
                data: 'ruleOrderNumber',
                defaultContent: '',
                width: '4em',
                targets: 8,
                title: 'Rule #'
            },{                          
                data: 'levelOfSupport',
                defaultContent: '',
                width: '10em',
                targets: 9,
                title: 'Level Of Support'
            },{
            	data: 'lastCaseAssigned',
                defaultContent: '',
                mRender: function (data, type, full) {
                    var date = new Date(data);
                    var locale = $A.get("$Locale.datetimeFormat");
                    return $A.localizationService.formatDateTime(date);                       
            	},
                type: 'date',
                width: '15em',
                targets: 10,
                title: 'Last Case Assigned'
            },{                          
                data: 'roleOrderNumber',
                defaultContent: '',
                targets: 11,
                visible: false
            },{                          
                data: 'scheduleTypeOrderNumber',
                defaultContent: '',
                targets: 12,
                visible: false
            },{
                    data: "workgroupId",
                    defaultContent: "",
                    targets: 13,
                    visible: false
                }],
            ordering: true,
            autoWidth: false,
            rowId: 'userId',
            // Rule order number, Schedule Type Order Number, Role Order Number, Last Assigned Date, Name
            order: [[8,'asc'],[12,'asc'],[11,'asc'],[10,'asc'],[2,'asc']],
            pageLength: 5,
            lengthMenu: [ 5, 10, 25 ],
            data: workgroupMembers
        });
        // When the mouse hovers over the member column display a popup
        $(tableId).on('mouseenter','td.popup', function() {
            var tr = $(this).closest('tr');
            var rowData = $(tableId).DataTable().row(tr);
            if(rowData.data()['role'] == 'Hotline'){
                var popUp = 'Hotline Number: ' + rowData.data()['phone']
                this.setAttribute('title', popUp);
            }
            else{ 
                // If a user
                var popUp = 'Email: ' +  rowData.data()['email'];
                this.setAttribute('title', popUp);
            }
        });
        // When the assign button is clicked
        $(tableId).on('click', '#connect', function() {
            var tr = $(this).closest('tr');
            var email = $(tableId).DataTable().row(tr).data()['email'];
            var ciscoLink='CISCOIM:' + email;
            try {
                location.href=ciscoLink;
            }
            catch(err) {
                var name=$(tableId).DataTable().row(tr).data()['name'];
                var phone=$(tableId).DataTable().row(tr).data()['phone'];
                if(phone === 'undefined' || phone === undefined || phone ===null || phone ===NaN ){
                    phone='';
                }
                if(email === 'undefined' ||email === undefined || email ===null || email ===NaN){
                    email='';
                }
                var textMessage='Impossible to Connect to Jabber \n'+name+' contact details are the following: \n'+'Phone: '+phone+'\n'+'Email: '+email+'\n Warning: Max 3 Contacts details can be displayed at the same time.';
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: 'Sticky',
                    message: textMessage,
                    type : 'Info'
                   
                });
                toastEvent.fire();
            }
        });
        // When the assign button is clicked
        $(tableId).off().on('click', '#assign', function() {
            var messageBox = component.find('messageBox'); 
            component.set("v.Spinner", true); 
            var tr = $(this).closest('tr');
            var rowId = $(tableId).DataTable().row(tr).data()['id'];
            var queueName = $(tableId).DataTable().row(tr).data()['queueName'];
            
            if(queueName != null && queueName !='GWC'){
               //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                messageBox.displayToastMessage($A.get("$Label.c.CH_Queue_Cannot_Be_Case_Owner_Except_For_GWC"), "error");
                component.set("v.Spinner", false);
            }else{
                thisHelper.assignWorkgroupMembers(component,rowId)
                .then(function(result){
                    component.set("v.Spinner", false);
                    var messageBox = component.find('messageBox');
                    //$A.get('e.force:refreshView').fire();
                    messageBox.displayToastMessage("User assigned to the case", "success");
					// Close the sub tab
					thisHelper.closeSubTab(component);                    
                })
                .catch(function(error) {
                    component.set("v.Spinner", false);
                    var messageBox = component.find('messageBox'); 
                    messageBox.displayToastMessage("An error occured. " + error, "error");
                }) 
            } 
        });
        //When Instruction button is clicked
        $(tableId).on('click', '#Instructions', function() {
            var tr = $(this).closest('tr');
            var getWorkgroupId = $(tableId).DataTable().row(tr).data()['workgroupId'];
            component.set("v.captureWorkgroupId", getWorkgroupId); 
            var getWorkgroupName = $(tableId).DataTable().row(tr).data()['workgroupName'];
            component.set("v.captureWorkgroupName", getWorkgroupName); 
            component.set("v.showworkgroupInstructions", true);
            var callController=component.get("c.handleWorkgroupInstructions");
            $A.enqueueAction(callController);
            
        });         
    },
    // Get the case details to load into the search window
    getWorkgroupMembers: function(component){
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
           	//NOKIASC-34648
            var nofilter = false;
            if(!component.get("v.isHWSCase")){
                nofilter = component.get("v.checked");
            }
            resolve(sharedjs.apex(component, 'getWorkgroupMembers',{ caseId: component.get("v.recordId"), noFilter: nofilter}));
        });           
        return promise; 
    },
    // Get the case details to load into the search window
    assignWorkgroupMembers: function(component, userId){
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'updateSupportTicketOwner',{ caseId: component.get("v.recordId"),
                                                                         memId: userId}));
        });           
        return promise; 
    },
    // Get the workgroup instructions for the found workgroup (based on case fields and rules)
    getWorkgroupInstructions: function(component){
        var promise = new Promise( function( resolve , reject ) { 
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'getWorkgroupInstructions',{ caseId: component.get("v.recordId")}));
        });           
        return promise;     	
    },
    // Get the workgroup name for the found workgroup (based on case fields and rules)
    getWorkgroupName: function(component){
        var promise = new Promise( function( resolve , reject ) { 
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'getWorkgroupName',{ caseId: component.get("v.recordId")}));
        });           
        return promise;     	
    },
    // Check if the case is passive or active
    setCaseAssignType: function(component){  
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'isActiveAssignment',{ caseId: component.get("v.recordId")}));
        }); 
        
        return promise;
    },
    closeSubTab: function(component){
        var workspaceAPI = component.find("workspace");
        // Get the Id of the current TAB and that tab should be
        // the re-assignment tab
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedParentTabId = response.parentTabId;            
            workspaceAPI.refreshTab({
                      tabId: focusedParentTabId,
                      includeAllSubtabs: true
             });
            var focusedTabId = response.tabId;            
            workspaceAPI.closeTab({tabId: focusedTabId});
			setTimeout(function(){
                $A.get('e.force:refreshView').fire();
            }, 1000);
        })
        .catch(function(error) {
            console.log(error);
        });
    },
	 displayWorkgrpInstructions: function(component, workgroupMembers) {
        var tableId = "#assignment-" + component.get("v.recordId");
        var getWorkgroupId = $(tableId).DataTable().rows().data();
		component.set("v.captureWorkgroupId", getWorkgroupId[0].workgroupId); 
        component.set("v.captureWorkgroupName", getWorkgroupId[0].workgroupName); 
        console.log('captureWorkgroupId'+component.get("v.captureWorkgroupId"));
        component.set("v.showworkgroupInstructions", true);
        var callController=component.get("c.handleWorkgroupInstructions");
        $A.enqueueAction(callController);
		
    },
    
    // Check if the case HWS or not - 34648
    hwsCaseCheck: function(component){  
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'checkHWSCase',{ caseId: component.get("v.recordId")}));
        }); 
        
        return promise;
    },
})