({
    getTableId: function(component){
    	return '#workgroupmembers-' + component.get("v.timeslotId");        
    },
     // Intialize the datatables object
    createTable: function(component, workGroupMembers) {
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
                    title: 'Select'
            	},{
                    //mRender: function (data, type, full) {
                        // javascript:; makes sure that when you click on the link you don't go anywhere
                    //    return '<a href="javascript:;">' + data + '</a>' 
                    //},
                    data: 'Name',
                    width: '15em',
                    targets: 1,
                    title: 'Member Name'
                },{
                    data: 'CH_Role__c', 
                    targets: 2,
                    title: 'Member Role'
                },{
                    data: 'CH_Workgroup_Member_Type__c', 
                    targets: 3,
                    title: 'Member Type'
                },{
                    orderable: false,
                    mRender: function (data, type, full) {
                        return '<select id="scheduletype"><option value="none">None</option><option value="primary">Primary</option><option value="secondary">Secondary </option><option value="tertiary">Tertiary</option></select>' 
                    },
                    data: null, 
                    targets: 4,
                    title: 'Schedule Type'
                } 
            ],
            ordering: true,
            autoWidth: false,
            rowId: 'Id',
            pageLength: 10,
            bLengthChange : true,
            lengthMenu: [ 5, 10 ],
            data: workGroupMembers,
        });
        $(tableId).on('click', 'input[type="Checkbox"]', function() {
            var table = $(tableId).DataTable();
            
            var selectedRows = table.rows({ selected: true }).ids(false).toArray();
            var row = table.row($(this).closest('tr'));
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
            var button = component.find('addMembersButton');
            selectedRows = table.rows({ selected: true }).ids(false).toArray();
            if (selectedRows.length > 0){
                button.set('v.disabled',false);
            }
            else {
                button.set('v.disabled',true);
            }
        });     
    },
	// Get the list of workgorup users not already assocaited
    refreshUserList : function(component) {
        var thisHelper = this;
        var promise = new Promise( function( resolve , reject ) {
        	const sharedjs = component.find("sharedJavaScript");
        	sharedjs.apex(component, 'getEligableUsers',{ timeslotId : component.get("v.timeslotId")})
            .then(function(result){
                resolve(result);
            });
        });           
        return promise;        
    }
})