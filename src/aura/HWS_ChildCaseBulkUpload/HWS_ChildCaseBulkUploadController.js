({
	doInit : function(component,event, helper){
        //alert('BULKRMA call from parent');
        component.set("v.enableSaveAndReview", true);
		// NOKIASC-37921 | Start
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var allowed_users= $A.get("$Label.c.HWS_Allowed_Users");
        if(allowed_users != 'old'){
            component.set('v.showSubmitButton',true);
        }
        // NOKIASC-37921 | End
    },
	uploadbutton : function(component, event, helper) {
       
		event.stopPropagation();
        event.preventDefault();
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
        helper.readFile(component,helper,event.getSource().get("v.files")[0]);
    },
	/****** Method to create the Bulk RMA Cases
    		HWST-3681 Sprint - 1926
    		Start ***************************/
    saveHWSCase : function(component, event, helper){
        //alert('saveHWSCase method Test');
        component.set("v.enableSubmit", true);
        component.set("v.inProgressCase", true);
        component.set("v.saveAndReview", false);
		component.set("v.disableValidateDelete", true);
        //NOKIASC-37921 | Start
        if(!component.get('v.showSubmitButton'))
            helper.saveCaseHelper(component, event);
        else
            helper.insertCaseHelper(component, event, 'Submit');
        // NOKIASC-37921 | End
    },
    saveandReviewCase : function(component, event, helper) {
        component.set("v.enableSaveAndReview", true);
        component.set("v.inProgressCase", false);
        component.set("v.saveAndReview", true);
		//  NOKIASC-37921 | Start
   		if(!component.get('v.showSubmitButton'))
            helper.saveCaseHelper(component, event);
        else
            helper.insertCaseHelper(component, event, 'SaveReview'); 
		//  NOKIASC-37921 | End
    },
    /************** END *******************/
    cancel : function(component,event,helper){
        component.set("v.showMain",true);
    },
    setColumnsValues : function(component, event, helper) {
        component.set("v.spinner",true);
        helper.setColumnsData(component, event);
    },
    deleteCaseController : function(component,event,helper){        
        helper.deleteCaseHlp(component,event);
    },
	handleSuccess : function(component, event, helper) {
        component.set("v.selectFailureDescription",false);
		component.set("v.requiredFieldValidationCheck",true);
        component.set('v.fieldUpdateValidationCheck',true);
        helper.setColumnsData(component,event);
    },
    onRowSelection: function(component,event,helper)
    {		
        
        var selectedRows = event.getParam('selectedRows');        
        var allSelectedRows = [];
        for (var i = 0; i < selectedRows.length; i++){
			//console.log(selectedRows[i].Id);NOKIASC-36296
            
            allSelectedRows.push(selectedRows[i].Id);
        }

            //Setting new value in selection attribute
           
            component.set("v.selection", allSelectedRows);
    },
    validateGrid : function(component, event, helper) {
		component.set("v.spinner",true);
		var action=component.get("c.updateStatusforMandatoryFields");
        action.setParams({
            bulkRMAList : component.get("v.bulkRMAData")
        });
        action.setCallback(this,function(response){
            var state=response.getState(); 
            if (state=='SUCCESS'){        
                component.set("v.spinner",false);			
                component.set('v.statusforMandatoryCheck',response.getReturnValue());
                //console.log('&&&&&&&&&&'+JSON.stringif(response.getReturnValue()));
                helper.setColumnsData(component,event);  
            }
        })
        $A.enqueueAction(action);  
	},
     handleSave: function(component,event,helper) {
        helper.saveTableValues(component, event, helper);
        //helper.validateGridHelper(component,event);
        helper.validateMandatoryFields(component,event); 
    },
	editRowAction: function (component, event, helper) {
        //console.log('on row edit') NOKIASC-36296
        helper.getRecordValues(component, event);
    },
	//NOKIASC-32957
    loadMoreData : function(component, event,helper) {
       // console.log('LOAD:'+event.getSource().get("v.isLoading")+'###'+component.get('v.enableInfiniteLoading'));
        if(!event.getSource().get("v.isLoading") && component.get('v.enableInfiniteLoading') == true){
            event.getSource().set("v.isLoading", true);        
            component.set('v.loadMoreStatus', 'Loading');
            helper.fetchAssets(component, event,helper);
        }
    },
	closeModel: function(component, event){
        component.set("v.Assets",[]);
        component.set("v.selectContractLineItem",false);
        component.set("v.shipToAddrCheck",false);
        component.set("v.selectFailureDescription",false);
        component.set("v.shipToAddrListResult",[]); 
        component.set("v.shipToAddrAccId",'');
        component.set("v.shipToAddrAccName",'');
        component.set("v.strSearchShipToAddrName",'');
		 // Start of Changes for US-25679
        //This is used to show/hide the Model box for Network Element Asset Selection
        component.set("v.selectNEAItem",false);
        //Resetting the values of the asset after Closing the model box in the Network Element Asset Selection
        component.set("v.netElemAssets",[]);
        // End Changes for US-25679
    },
    processSelectedContract : function(component, event){
        var selectedRows = event.getParam("selectedRows");
        var selectedAsset = selectedRows[0];
        component.set("v.selectedAsset",selectedAsset);
        //console.log('selectedAsset11:'+JSON.stringify(selectedAsset)); NOKIASC-36296
        //alert('selectedAsset:'+JSON.stringify(component.get("v.selectedAsset")));
        
    },
    submitDetails : function(component, event, helper){
        helper.updateServiceContract(component, event); 
    },
    setShipToAddress : function(component, event, helper){
        helper.setShipToAddressHelper(component, event);
    },
    selectShipToAddrName:function(component,event,helper){        
        var objectId = event.currentTarget.dataset.id;
        component.set("v.shipToAddrAccId",objectId);
        var shipToList =component.get('v.shipToAddrList');
        for(var i=0;i<shipToList.length;i++){
            var projectSelected =shipToList[i];
            var objectLabel = '';
            if(projectSelected.currentworkingTitleId==objectId){
                objectLabel = projectSelected.currentworkingTitleName;
                component.set("v.shipToAddrAccName",objectLabel);
                break;
            }
        }
        var shipToAddrId = component.get("v.shipToAddrId");
        component.set("v.strSearchShipToAddrName",'');
        component.set("v.shipToAddrId",'');        
        var lookupList = component.find('lookuplistPilot');        
        $A.util.addClass(component.find('idSearchboxPilotSeries'),'slds-hide');
        var shipToAddrListResult = component.get("v.shipToAddrListResult");
        var projectSelected = new Array();
        var projectSelected = { 'currentworkingTitleId' : objectId, 
                               'currentworkingTitleName' : objectLabel
                              };
        shipToAddrListResult.push(projectSelected);
        component.set("v.shipToAddrListResult",shipToAddrListResult);
    },
    removeShipToAddrName:function(component,event,helper){
       $A.util.removeClass(component.find('idSearchboxPilotSeries'),'slds-hide');  
        var objectId = event.currentTarget.dataset.id;
        var objectLabel = event.currentTarget.innerText;
        var projectList = component.get("v.shipToAddrListResult");
        var projectSelected = new Array();
        var projectSelected = { 'currentworkingTitleId' : objectId, 
                               'currentworkingTitleName' : objectLabel
                              };                
        for(var iSelMem=0;iSelMem<projectList.length;iSelMem++){
            var projectSelected =projectList[iSelMem];
            if(projectSelected.currentworkingTitleId==objectId){
                projectList.splice(iSelMem,1);
        }        
        component.set("v.shipToAddrListResult",projectList); 
        component.set("v.shipToAddrAccId",'');
        component.set("v.shipToAddrAccName",'');       
        }
    },
    saveShipToAddress : function(component, event, helper){
        helper.saveShipToAddrHlpr(component, event);
		helper.validateMandatoryFields(component,event);
        helper.validateGridHelper(component,event);
        component.set("v.shipToAddrCheck",false);
        $A.util.removeClass(component.find('idSearchboxPilotSeries'),'slds-hide');
        component.set("v.shipToAddrListResult",[]); 
        component.set("v.shipToAddrAccId",'');
        component.set("v.shipToAddrAccName",'');
    },
	
	//Start of Changes for 25679
   //Used to store the value of the Asset selected in the Network Element Asset Selection Screen
    processSelectedNEA : function(component, event){
        //Fetch the value of the Row selected in the NEA Screen
        var selectedRows = event.getParam("selectedRows");
        var selectedNEAAsset = selectedRows[0];
        //Assigning the NEA value to the object
        component.set("v.selectedNEAAsset",selectedNEAAsset);
        //console.log('selectedNEAAsset:'+JSON.stringify(selectedNEAAsset)); NOKIASC-36296
        },
    
    //Used to update the value of the NEA in the Bulkupload 
    submitNEADetails : function(component, event, helper){
        helper.updateNEA(component, event); 
    },
    
    // Clear the selected rows in the Network Element Asset Selection Screen 
    clearSelection : function (component, event, helper) {
        component.set("v.selectedNEAAsset",null); 
        component.find("neaTable").set("v.selectedRows", new Array());
    },
    
    //End of Changes for 25679
	
	//Start Changes for 27358
    //This Method is used to filter the values in the Network Element Asset Selection Screen  
    filterNEA: function(component, event, helper) {
		//NOKIASC-32957
        if(event.keyCode === 13 ){
                        helper.componentRefresh(component, event, helper);        
        helper.getAssetsWithSearchFilter(component, event, helper);
        }
		/*var action = component.get("v.showAllNEA"),
            NEAFilter = component.get("v.NEAFilterText"),
            results = action, regex;
        try {
            regex = new RegExp(NEAFilter, "i");
             results = action.filter(
                row => regex.test(row.Name) ||
                regex.test(row.CH_NetworkElementID__c) ||
                regex.test(row.Product2.Name) ||
                regex.test(row.SolutionName) ||
                regex.test(row.ProductVariant) ||
                regex.test(row.ProductRelease) ||
                regex.test(row.CH_LabEnvironment__c) ||
                regex.test(row.CH_CountryISOName__c) ||
                regex.test(row.Address)
                
            );
        } catch(e) {
            // invalid regex, use full list
        }
        component.set("v.netElemAssets", results);*/
        
    },
    //End Changes for 27358
	showToolTip : function(component, event, helper) {
        component.set("v.showtooltip" , true);
        
    },
    hideToolTip : function(component, event, helper){
        component.set("v.showtooltip" , false);
    }
})