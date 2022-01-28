({
   /* doInit : function (component) {
         var action = component.get("c.fetchLookUpValues");
          
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
           // Find the component whose aura:id is "flowData"
           var flow = component.find("flowData");
           var inputVariables = [
             {
                name : "Test43",
                type : "String",
                value : storeResponse 
              }
           ];
           // In that component, start your flow. Reference the flow's Unique Name.
           flow.startFlow("MultiSelectLookUpFlow", inputVariables );
		
            }
        });
		
    $A.enqueueAction(action);
    },*/
    
            onblur : function(component,event,helper){
            // on mouse leave clear the listOfSeachRecords & hide the search result component 
            var getSelectRecords = component.get("v.listOfSearchRecords");
            console.log('Test ganga' +getSelectRecords);
            component.set("v.listOfSearchRecords", null );
            component.set("v.SearchKeyWord", '');
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            },
            onfocus : function(component,event,helper){
            // show the spinner,show child search result component and call helper function
            $A.util.addClass(component.find("mySpinner"), "slds-show");
            component.set("v.listOfSearchRecords", null ); 
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            // Get Default 5 Records order by createdDate DESC 
            var getInputkeyWord = '';
            helper.searchHelper(component,event,getInputkeyWord);
            //helper.searchHelper1(component,event,getInputkeyWord);
            },
            
            keyPressController : function(component, event, helper) {
            $A.util.addClass(component.find("mySpinner"), "slds-show");
            // get the search Input keyword   
            var getInputkeyWord = component.get("v.SearchKeyWord");
            // check if getInputKeyWord size id more then 0 then open the lookup result List and 
            // call the helper 
            // else close the lookup result List part.   
            if(getInputkeyWord.length > 0){
            var forOpen = component.find("searchRes");
           // $A.util.addClass(forOpen, 'slds-is-open');
          //  $A.util.removeClass(forOpen, 'slds-is-close');
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
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.lstSelectedRecords"); 
        
        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i].Id == selectedPillId){
                AllPillsList.splice(i, 1);
                component.set("v.lstSelectedRecords", AllPillsList);
            }  
        }
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );      
    },
    
 
 // This function call when the end User Select any record from the result list.   
 handleComponentEvent : function(component, event, helper) {
    component.set("v.SearchKeyWord",null);
    // get the selected object record from the COMPONENT event 	 
    var listSelectedItems =  component.get("v.lstSelectedRecords");
    var selectedAccountGetFromEvent = event.getParam("recordByEvent");
  // var multiListValues = event.getParam("multiListValues");
    //console.log('multiListValues in parent:'+multiListValues);
    listSelectedItems.push(selectedAccountGetFromEvent);
    component.set("v.lstSelectedRecords" , listSelectedItems); 
     var selectresult=component.get("v.lstSelectedRecords");
   //  alert(JSON.stringify(selectresult));
    var forclose = component.find("lookup-pill");
    $A.util.addClass(forclose, 'slds-show');
    $A.util.removeClass(forclose, 'slds-hide');
    
    var forclose = component.find("searchRes");
    $A.util.addClass(forclose, 'slds-is-close');
    $A.util.removeClass(forclose, 'slds-is-open'); 
},
    
       save:function(component, event, helper){
        var action = component.get("c.mapCaseToArticle");   
        var selectresult=component.get("v.lstSelectedRecords");
        var knowledgeId=component.get("v.recordId");  
        console.log('Finally'+JSON.stringify(selectresult)); 
        //alert(JSON.stringify(selectresult));  
          action.setParams({
            'FinalId': knowledgeId,
            'productvalue' : selectresult,
        });   
        
           
           
           action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success Message',
            message: 'Records Created Successfully',
           // messageTemplate: 'Records Created Successfully',
            duration:'2000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
              } 
           else {
             var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error Message',
            message:'Error:Records are not inserted Successfully',
           // messageTemplate: 'Error:Records are not inserted Successfully',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
               
               }
            });
        $A.enqueueAction(action);   
      // alert('Records Inserted Succesfully')    
       component.set('v.lstSelectedRecords',null); 
    }
})