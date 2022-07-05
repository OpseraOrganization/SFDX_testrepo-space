({
    GetPRMDocumentData : function(component, event, helper,userID,documentid) {
        // call getuserDetail method
        //var documentid=parts[1];
        var mActiongetuserDetail = component.get("c.getuserDetail");
        //alert('mActiongetuserDetail'+userID);
        //alert('mActiongetuserDetail'+documentid);
        mActiongetuserDetail.setParams({
            "UserId": userID,
            "DocumentId":documentid
            
        });
        mActiongetuserDetail.setCallback(this, function(response){
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                component.set("v.PRMDocDetails", response.getReturnValue());
                var SharedEmail=[];
                var recordLength=response.getReturnValue().length;
                //alert('recordLength::::::::::  '+recordLength);
                for(var i=0;i<recordLength;i++){
                    if(response.getReturnValue()[i].Shared_WIth__c != undefined){
                        SharedEmail.push(response.getReturnValue()[i].Shared_WIth__c);
                    }
                }
                //Like functionality
                //alert(response.getReturnValue().Like__c);
                //alert(JSON.stringify(response.getReturnValue()));
                 var liketrue = response.getReturnValue().length;
                 for(var i=0;i<recordLength;i++){
                    if(response.getReturnValue()[i].Like__c == true){
                        //alert('hey');
                        var likeButton=component.find("LikeButton");
					    likeButton.set("v.disabled",true);//Disable the button
                       // SharedEmail.push(response.getReturnValue()[i].Shared_WIth__c);
                    }
                }
          		
               
                
            }else if(state === "ERROR"){
                //alert("no data");
            }
        }); 
        $A.enqueueAction(mActiongetuserDetail);
        // end
        
    },
    getDocumentLike :function(component, event, helper){
        var userdetails= component.get("v.UserDetail");
        var documentDetails=component.get("v.contentDetail");
        var documentid=documentDetails.Title;
        var artiURLForLike= component.get("v.articleURL");
        var usertype;
        //var documentLastmodified = documentDetails.LastModifiedDate;
        // call insert record for PRMDocument's method
        if(userdetails.IsPortalEnabled == true)
        {
             usertype = 'External';
        }
        else{
            usertype = 'Internal';
        }
        //alert(usertype);
        var mActionSetMappedValuesURL = component.get("c.setLikeRecord");
        mActionSetMappedValuesURL.setParams({
            "UserId": userdetails.Id,
            "flag":true,
            "DocumentId":documentid,
            "documentDetails":documentDetails,
            "artiURL":artiURLForLike,
            "usertype":usertype,
            "senderData":userdetails
           
        });
        mActionSetMappedValuesURL.setCallback(this, function(response){
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
               // component.set("v.contentDetail", response.getReturnValue());
               //likeButton.set("v.label",'true');
                var source=event.getSource();
                source.set('v.disabled',true);
            }            
        }); 
        $A.enqueueAction(mActionSetMappedValuesURL);
        // end
        
    },
    sendEmailtoUser :function(component, event, helper){
        
        var InternalEmails=component.get("v.SelectedLookupMultiple");
        
        var senderData=component.get("v.UserDetail");
        var documentDetails=component.get("v.contentDetail");
        var AllemailArr=[];
        var artURL= component.get("v.articleURL");
       // alert('artURL+++++' +artURL);
        var ErrorDiv= component.find("ErrorDiv");
         var url = window.location.href;
				//alert('url' +url);
        if(senderData.IsPortalEnabled != false){
            var emailsValur = component.find("mSelectRight").get("v.options");
            for(var j=0;j<emailsValur.length;j++){
                AllemailArr.push(emailsValur[j]["value"]);
            } 
        }else{
            for(var i=0;i<InternalEmails.length;i++){
                AllemailArr.push(InternalEmails[i].value);}
            
        }  
        
        //var EmailForRecordCreation;
        if(AllemailArr == '')
        {
           // $A.util.removeClass(ErrorDiv, 'slds-hide'); 
           // $A.util.addClass(ErrorDiv, 'slds-show'); 
           // component.set("v.ErrorMessage","Please select atleast one email");
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please select atleast one email from list",
                "type":"error"
            });
            toastEvent.fire();
            return false;
        }
        /*else{
            $A.util.removeClass(ErrorDiv, 'slds-show'); 
            $A.util.addClass(ErrorDiv, 'slds-hide'); 
        }*/
        var mActionsendMailToUser = component.get("c.sendMailToUser");
        mActionsendMailToUser.setParams({
            "mMail": AllemailArr,
            "mSubject":'',
            "mbody":'',
            "documentDetails":documentDetails,
            "senderData":senderData,
            "artiURL":artURL,
                     
        });
          
        
        mActionsendMailToUser.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success",
                    "message": "Mail has been sent to selected users",
                    'type' : 'Success'
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
            }
            
        });
        $A.enqueueAction(mActionsendMailToUser);
       
        
        
    },
    buildPickValues : function(component, event, helper) {
        var action = component.get("c.getDatavalues");
        var inputMultiSel = component.find("mSelectLeft");
        var opts=[];
        action.setParams({
            objName : component.get("v.ObjectName"),
            field_apiname : component.get("v.FieldName")
        });
        
        action.setCallback(this, function(resp) {
            var state=resp.getState();
            //(state);
            if(state === "SUCCESS"){
                
                var res = resp.getReturnValue();
                
                var index = res.indexOf(component.get("v.UserDetail.Email"));
                res.splice(index, 1);
                for(var i=0;i< res.length;i++){
                    opts.push({"class": "optionClass",
                               label: res[i],
                               value: res[i]});
                }
                inputMultiSel.set("v.options", opts);
                
                // component.set("v.masterValues", opts);
            }
        });
        $A.enqueueAction(action);
    },
    
    moveRight : function(component, event, helper) {
        var addSelValues = component.get("v.addValuestoRight").split(";");
        
        var leftOpts = [];
        var rightOpts = [];
        var SelectedValues=[];
        rightOpts = component.find("mSelectRight").get("v.options");
        leftOpts = component.find("mSelectLeft").get("v.options");
        for(var i=0;i< addSelValues.length;i++){
            rightOpts.push({"class": "optionClass",
                            label: addSelValues[i],
                            value: addSelValues[i]});
           
            for(var j=0;j< leftOpts.length;j++){
                if(leftOpts[j]["value"] == addSelValues[i]){
                    leftOpts.splice(j,1);
                    break;
                }
            }
        }
        
        
        for(var j=0;j< rightOpts.length;j++){
            SelectedValues.push(rightOpts[j]["value"]);
            
        }
        
        
       
        component.set("v.SelectedValues",SelectedValues);
        
        component.find("mSelectRight").set("v.options", rightOpts);
        component.find("mSelectLeft").set("v.options", leftOpts);
    },
    moveLeft : function(component, event, helper) {
        var remSelValues = component.get("v.remValuesFromRight").split(";");
        
        var leftOpts = [];
        var rightOpts = [];
        
        rightOpts = component.find("mSelectRight").get("v.options");
        leftOpts = component.find("mSelectLeft").get("v.options");
        
        for(var i=0;i< remSelValues.length;i++){
            
            leftOpts.push({"class": "optionClass",
                           label: remSelValues[i],
                           value: remSelValues[i]});
            for(var j=0;j< rightOpts.length;j++){
                if(rightOpts[j]["value"] == remSelValues[i]){
                    rightOpts.splice(j,1);
                    break;
                }
            }
        }
        
        component.find("mSelectLeft").set("v.options", leftOpts);
        component.find("mSelectRight").set("v.options", rightOpts);
    },
    
})