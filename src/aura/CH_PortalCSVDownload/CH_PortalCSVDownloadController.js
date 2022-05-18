({
    doInit : function(component) {        
        var pickvar = component.get("c.getPickListValuesIntoList");
        pickvar.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var list = response.getReturnValue();
                component.set("v.picvalue", list);
            }
            else if(state === 'ERROR'){
                //var list = response.getReturnValue();
                //component.set("v.picvalue", list);
                alert('ERROR OCCURED.');
            }
        })
        $A.enqueueAction(pickvar);
    },
    
    
    // ## function call on component load  
    loadCaseList: function(component, event, helper){
        helper.onLoad(component, event);
        helper.checkManageServiceQuoteDisplay(component, event);
    },
    
    // ## function call on Click on the "Download As CSV" Button. 
    downloadCsv : function(component,event,helper) {
        var recordType = component.get("v.selectedType");
        var startDate = component.get("v.startDate");
        var endDate = component.get("v.endDate");
        var formatType = component.get("v.selectedformat");
        var status = component.get("v.selectedStatus");
        console.log('recordType ===='+recordType);
        console.log('startDate ===='+startDate);
        console.log('endDate ==='+endDate);
        console.log('formatType ==='+formatType);
        console.log('status ==='+status);
       var today = new Date();
       var tomorrow = today.getDate() + 1;
	   component.set("v.IsSpinner", true);
          var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
                    "title": "Error!",
                    "message": "Start Date cannot be greater than End Date",
                    "type": "Error"
                });
        var toastEventOnNullData = $A.get("e.force:showToast");
    toastEventOnNullData.setParams({
                    "title": "Error!",
                    "message": "No Data found, Please change the filter to download",
                    "type": "Error"
                });
        if(startDate >endDate && startDate!=null && endDate!=null){
          // alert('Start Date cannot be greater than End Date');
		   component.set("v.IsSpinner", false);
           toastEvent.fire();
       }
        else{
        var action; 
        if (formatType == 'csv') {
            
        	action = component.get("c.getCaseInfoForDownload");
            
            action.setParams({ type : recordType, startDate : startDate, endDate : endDate, status : status});
             action.setCallback(this, function(response) {
                 var state = response.getState();
                 if(state === 'SUCCESS'){
                     var list = response.getReturnValue();
                     component.set("v.ListOfCase", list);
                     var stockData = component.get("v.ListOfCase");
                     var rtType = component.get("v.selectedType")
                     if (formatType == 'csv') {
                         var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
                         var csv = helper.convertArrayOfObjectsToCSV(component,stockData, rtType);   
                         if (csv == null){
                             toastEventOnNullData.fire();
							 component.set("v.IsSpinner", false);
                            // alert('No Data found, Please change the filter to download');
                            // return;
                         }   
                         //NOKIASC-35092 | 29/04/2021 | Start
                         else if(stockData.length > 5000){
                             var fireRecordCoundValidation = $A.get("e.force:showToast");
                            fireRecordCoundValidation.setParams({
                            "title": "Error!",
                            "message": $A.get('$Label.c.HWS_Report_Count_Validation'),
                            "type": "Error",
                            "duration": "10000" 
                            });
                            fireRecordCoundValidation.fire();
                            component.set("v.IsSpinner", false);  
                         }
                         //NOKIASC-35092 | 29/04/2021 | End
                         else{
                         var hiddenElement = document.createElement('a');
						 var BOM = "\uFEFF"; 
                          var csvContentWithBOM = BOM + csv;
                         hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURIComponent(csvContentWithBOM);
                         //hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                         hiddenElement.target = '_self'; // 
                         hiddenElement.download = 'CaseExport'+today+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
                         document.body.appendChild(hiddenElement); // Required for FireFox browser
                         hiddenElement.click(); // using click() js function to download csv file  
						 component.set("v.IsSpinner", false);
                         }
                      } 
                     }
             })      
        } else { 
            console.log('Inside Excel');
			component.set("v.IsSpinner", true);
            var params =  { type : recordType, startDate : startDate, endDate : endDate, status : status};
            helper.CheckExcelCount(component, event, params)
            .then($A.getCallback(function(records) {
                console.log('First From Server-Side: ' + records);
                if (records == '' || records == null) {
                  toastEventOnNullData.fire();
				  component.set("v.IsSpinner", false);
                }
                //NOKIASC-35092 | 29/04/2021 | Start
                 else if(records.length > 5000){
                    var fireRecordCoundValidation = $A.get("e.force:showToast");
                    fireRecordCoundValidation.setParams({
                    "title": "Error!",
                    "message": $A.get('$Label.c.HWS_Report_Count_Validation'),
                    "type": "Error",
                    "duration": "10000" 
                    });
                    fireRecordCoundValidation.fire();
                    component.set("v.IsSpinner", false);  
                 }
                 //NOKIASC-35092 | 29/04/2021 | End
                else {
					//Added on 06-April-2021 | NOKIASC-35092 | Start
					if(startDate == null)
						startDate = '';
					if(endDate == null)
						endDate = '';
					if(status == null)
						status = '';
					
                    window.open(window.location.origin+'/'+window.location.pathname.split('/')[1]+'/excelfilepage?rtType='+recordType+'&startDate='+startDate+'&endDate='+endDate+'&status='+status);
                	component.set("v.IsSpinner", false);  
					//Added on 06-April-2021 | NOKIASC-35092 | End
                }
                
            }))
			//Commented on 06-April-2021 | NOKIASC-35092 | Start 
           /*return helper.getexcelContent(component, event, params)
            .then($A.getCallback(function(records) {
                //var strFile = "data:application/excel;base64,"+records;
                if (JSON.stringify(records) == 'null' || JSON.stringify(records) == null) {
                    toastEventOnNullData.fire(); 
					component.set("v.IsSpinner", false);
                } else {
                    
                    download("data:application/excel;base64,"+records, "CaseExport"+today+".xls", "application/excel"); 
				    component.set("v.IsSpinner", false);
                }
                //console.log('Second From Server-Side: ' + records);
            }))*/
			//Commented on 06-April-2021 | NOKIASC-35092 | End
        }
            $A.enqueueAction(action); 
       }
        
    },
   panelOne : function(component, event, helper) {
        helper.toggleAction(component, event, 'panelOne');
    },
    panelTwo : function(component, event, helper) {
       var navEvent = $A.get('e.force:navigateToURL');
            navEvent.setParams({
                'url': "/report/Report/Recent/Report/?queryScope=userFolders"
            });
            navEvent.fire(); 
    },
    navHome : function (component, event, helper) {
    var homeEvent = $A.get("e.force:navigateToObjectHome");
    homeEvent.setParams({
        "scope": "HWS_Service_Quote__c"
    });
    homeEvent.fire();
}
})