({
    myAction : function(component, event, helper) {
        
        var queryString = location.search.substring(1);
        var parts = decodeURIComponent(queryString).replace(/\++/g, " ");
        parts = parts.split('=');
        component.set("v.recordId",parts[1]);
        // call content detail method to get document data
        
        var mActionGetMappedValuesURL = component.get("c.getContentDetails");
        mActionGetMappedValuesURL.setParams({
            "parentId": parts[1],
        });
        mActionGetMappedValuesURL.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.contentDetail", response.getReturnValue());
            }
        }); 
        $A.enqueueAction(mActionGetMappedValuesURL);
        // end
       
        // call user detail method
        var mActionGetCurrentUser = component.get("c.getCurrentUser");
        mActionGetCurrentUser.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                
                component.set("v.UserDetail", response.getReturnValue());
                var userID=response.getReturnValue().Id;
                var userEmail=response.getReturnValue().Email;
                var documentDetails=component.get("v.contentDetail");
                var documentid=documentDetails.Title;
                // alert('documentid ++++' +documentid);
                //var articleurl = window.location.href; 
                var articleurl=document.referrer;
                //alert('articleurl' +articleurl);
                component.set("v.articleURL", articleurl);
                //alert('v.articleURL'+  component.get("v.articleURL"));
                helper.GetPRMDocumentData(component, event, helper,userID,documentid);
            }
             
        }); 
        $A.enqueueAction(mActionGetCurrentUser);
        // end
        
        
    },
    openFile : function(component, event, helper){
        
        $A.get('e.lightning:openFiles').fire({
            recordIds: [component.get("v.recordId")]
        });
    },
    /*likeCount : function(component, event, helper){
        var whichOne = event.getSource().getLocalId();
        var disableButton=component.find(whichOne);
        disableButton.set("v.LikeButton",true);
         alert(whichOne)
        
    }, */
    documentLike : function(component, event, helper) {
        helper.getDocumentLike(component, event, helper);
    },
    ShareDoc : function(component, event, helper) {
        var ModalComp= component.find("CLoseTab");
        $A.util.removeClass(ModalComp, 'slds-hide'); 
        $A.util.addClass(ModalComp, 'slds-show'); 
    },
    CloseShare : function(component, event, helper) {
        var ModalComp= component.find("CLoseTab");
        $A.util.addClass(ModalComp, 'slds-hide');
        $A.util.removeClass(ModalComp, 'slds-show');
    },
    
    openEmailContent :function(component, event, helper){
        helper.buildPickValues(component, event, helper);
        var WaitMsg = component.find("CloseEmails");
        $A.util.addClass(WaitMsg,'slds-show');                            
        $A.util.removeClass(WaitMsg,'slds-hide');
        
        
    },
    cancelEmailContent :function(component, event, helper){
        var WaitMsg = component.find("CloseEmails");
        $A.util.addClass(WaitMsg,'slds-hide');                            
        $A.util.removeClass(WaitMsg,'slds-show');
       
    },
    SendEmailContent :function(component, event, helper){
        helper.sendEmailtoUser(component, event, helper)
      
    },
    moveRight : function(component, event, helper) {
        var ErrorDiv= component.find("ErrorDiv");
        if(component.get("v.addValuestoRight").length > 0){
            
            $A.util.removeClass(ErrorDiv, 'slds-show'); 
            $A.util.addClass(ErrorDiv, 'slds-hide'); 
            helper.moveRight(component, event, helper);
        } else {
              var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please select one value to move to right",
                "type":"error",
                
            });
            toastEvent.fire();
           // $A.util.removeClass(ErrorDiv, 'slds-hide'); 
           // $A.util.addClass(ErrorDiv, 'slds-show'); 
           // component.set("v.ErrorMessage","Please select one value to move to right");
            
        }
        
    },
    moveLeft : function(component, event, helper) {
        var ErrorDiv= component.find("ErrorDiv");
        if(component.get("v.remValuesFromRight").length > 0){
            helper.moveLeft(component, event, helper);
            $A.util.removeClass(ErrorDiv, 'slds-show'); 
            $A.util.addClass(ErrorDiv, 'slds-hide');
        } else {
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please select one value to move to left",
                "type":"error",
            });
            toastEvent.fire();
            //return false;
           // $A.util.removeClass(ErrorDiv, 'slds-hide'); 
           // $A.util.addClass(ErrorDiv, 'slds-show');
           // component.set("v.ErrorMessage","Please select one value to move to left");  
        }
    },
    goBack:function(component, event, helper){
         //window.history.back()
       /* var url = window.location.href; 
        var value = url.substr(0,url.lastIndexOf('/') + 1);
        var x = history.length;
        var url=document.referrer;
        
        $A.get("e.force:navigateToURL").setParams(
            {"url": url
            }).fire();
        // window.history.back();*/
        //return false;
    },
    getSelectedLookupValues:function(component, event, helper){
        var valuesArray=[];
        var recordValues=component.get("v.selItem2.text");
    }
    
})