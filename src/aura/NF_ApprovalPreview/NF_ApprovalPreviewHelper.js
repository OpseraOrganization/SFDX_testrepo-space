({
    getGAteparticipantsHelper: function(component,event,helper){
        component.set('v.IsSpinner',true);
        var action = component.get("c.myoppApproval_relatedlist");
        action.setParams({
            "currentRecordId": component.get("v.recordId"),
            "Objecttype": "Opportunity",
            "needtorefresh" :component.get("v.needtorefresh"),
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid()){ 
                var result=response.getReturnValue();
                if(result!=null &&result!=undefined &&result!='')
                   { 
                       component.set('v.Currentopp', result.currentopp);
                       component.set('v.Nogate_byapss',result.Nogate_bypass);
                       component.set('v.Bypassmsg',result.Bypass_msgval);
                       component.set('v.HiddenEmailbutton',result.HiddenEmailbutton);
                    if(result.GAteParticipantsPageWrapper!=null &&result.GAteParticipantsPageWrapper!=undefined&&result.GAteParticipantsPageWrapper!=''){
                        component.set('v.MyApprovalList', result.GAteParticipantsPageWrapper);
                        component.set('v.MyApprovalEmailList',result.EmailForUsers);
                    }
                     if(result.EmailForUsers!=null &&result.EmailForUsers!=undefined &&result.EmailForUsers!='')
                    {
                        component.set('v.EmailBlock',true);
                          component.set('v.MyApprovalEmailList',result.EmailForUsers);
                    }
                    if(result.Gateuser_msgval!=null &&result.Gateuser_msgval!=undefined &&result.Gateuser_msgval!='')
                    {
                        component.set('v.Gateuser_msg',true);
                        component.set('v.Gateuser_msgval',result.Gateuser_msgval);
                    }
                    if(result.sH_Emailids!=null &&result.sH_Emailids!=undefined &&result.sH_Emailids!='')
                    {
                        component.set('v.SH_users',result.sH_Emailids);
                             var SHuseremails=JSON.parse(JSON.stringify(result.sH_Emailids));
                        component.set('v.SH_usersForemail',SHuseremails);                        
                    }
                    if(result.AV_Emailids!=null &&result.AV_Emailids!=undefined &&result.AV_Emailids!='')
                    {
                        component.set('v.AV_users',result.AV_Emailids);
                        var AVuseremails=JSON.parse(JSON.stringify(result.AV_Emailids));
                       component.set('v.AV_usersforemail',AVuseremails);                        
                    }
                    
                }
                component.set('v.IsSpinner',false);
                
            }else{
                component.set('v.IsSpinner',false);
                var   errors = response.getError();
                var errorpgmsg=JSON.stringify(errors);
                component.set('v.Gateuser_msg',true);
                component.set('v.Gateuser_msgval',errorpgmsg);
                //errorpgmsg=errors[0].pageErrors[0].message;
            }
        });
        $A.enqueueAction(action);
    },
    
    
    SendEmailforgateParticipants: function(component,event,helper)
    {
        var tomailids = component.find("toemail").get('v.value');
        var ccmailids =component.find("CCmail").get('v.value');
        var Sendattachment =component.find("sendattachment").get('v.value');
        var mailbody=component.get("v.mailbody");
        var subject= component.get("v.subject");
        var startDate = component.find("start_date_Email").get('v.value');
        var EndDate = component.find("end_date_Email").get('v.value');
        var Location=component.find("Location").get('v.value');

        var sendemail=true;
        var errormsgpopup=false;
         var errormsg='';
        if(Sendattachment){
            var fields='';
             errormsg='please fill the following fields: ';
            if(startDate=='' || startDate==null )
            {
               fields+='start Date/time'; 
                errormsgpopup=true;
            } 
             if(EndDate=='' || EndDate==null )
            {
                 if(startDate==''|| startDate==null )
                        fields+=',';
                
               fields+='End Date/time'; 
                errormsgpopup=true;
            } 
            
        }
        if((mailbody=='' ||mailbody==null||mailbody==undefined)&&!Sendattachment){
                        errormsg='You cannot send empty Email.Please write Something';
                        errormsgpopup=true;
        }
          
          if(errormsgpopup==true)
                sendemail=false;
            
            if( errormsgpopup)  {
              var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Error",
                    "title": "Error",
                    "duration":"5000",
                    "message": errormsg+fields,
                    "mode":"dismissible",
                });
                toastEvent.fire();
            }

     //   var Mailto=component.find("Replyto").get('v.value');
        var Mailto=null;
        if(sendemail){
            if(startDate=='' ||startDate==null||startDate==undefined)
            startDate='2019-01-13T17:27:00.000Z';
           if(EndDate=='' ||EndDate==null||EndDate==undefined)
            EndDate='2019-01-13T17:27:00.000Z';
            
        var action = component.get("c.sendInvite");
        action.setParams({
            "tomailids": tomailids,
            "mailbody": mailbody,
            "subject" :subject,
            "startdate": startDate,
            "Enddate" :EndDate,
            "Location": Location,
            "ccmailids" :ccmailids,
            "Mailto" :Mailto,
            "SendAttachment" :Sendattachment,
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
              var result=response.getReturnValue();
           
            if(state === "SUCCESS"&&result!=null&&!result.includes('failed')) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Success",
                    "title": "Success",
                    "duration":"5000",
                    "message": "mail sent successfully.",
                    "mode":"dismissible",
                });
                toastEvent.fire();
                component.set('v.mailbody', null);
                component.set('v.subject',null);
              var SHuseremails='';
              var AVuseremails='';
                
              var AVmails=component.get('v.AV_users');
              var SHmails=component.get('v.SH_users');
               
              if(SHmails!=null &&SHmails!=undefined &&SHmails!='')
              SHuseremails=JSON.parse(JSON.stringify(SHmails));
        
             if(AVmails!=null &&AVmails!=undefined &&AVmails!='')
             AVuseremails=JSON.parse(JSON.stringify(AVmails));
                
             component.set('v.AV_usersforemail',AVuseremails);       
             component.set('v.SH_usersForemail',SHuseremails); 
                
                 component.set("v.isOpenmodal", false);
            }  
            if(state === "ERROR"){
                component.set("v.isOpenmodal", true);
                var errors = response.getError();
               var errorpgmsg=JSON.stringify(errors);
              var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Error",
                    "title": "Error",
                    "duration":"5000",
                    "message": errorpgmsg,
                    "mode":"dismissible",
                });
                toastEvent.fire(); 
            }
              if(result!=null&&result.includes('failed'))
            {    var message='';
              if(result.includes('INVALID_EMAIL_ADDRESS'))  
                  message='TO/CC Email addresses contains invalid email.Please check your Email Addresses'
               else
                if(result.includes('Email body is required'))  
                  message='You cannot send empty Email.Please write Something';
               else
                message=result;
                 
                 component.set("v.isOpenmodal", true);
              var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Error",
                    "title": "Error",
                    "duration":"5000",
                    "message": message,
                    "mode":"dismissible",
                });
                toastEvent.fire();    
            }
             
        });
        $A.enqueueAction(action);
        }
    },
    convertListToCSV : function(component,objectRecords){
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        columnDivider = ',';
        lineDivider =  '\n';
        keys = ['USER','ROLENAME','ASSIGNEE TYPE','BG ATTRIBUTE','ORGANISATION','EMAIL','DELEGATE USERS','DELEGATE USEREMAILS' ];
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                if(skey=='USER'&&objectRecords[i].User!=null&&objectRecords[i].User.Name!=null)csvStringResult += '"'+ objectRecords[i].User.Name+'"';
                if(skey=='ROLENAME'&&objectRecords[i].ApprovalRequest!=null&&objectRecords[i].ApprovalRequest.NF_Role_Name__c!=null)csvStringResult += '"'+ objectRecords[i].ApprovalRequest.NF_Role_Name__c+'"'; 
                if(skey=='ASSIGNEE TYPE'&& objectRecords[i].ApprovalRequest!=null&&objectRecords[i].ApprovalRequest.NF_Assignee_Type__c!=null)csvStringResult += '"'+ objectRecords[i].ApprovalRequest.NF_Assignee_Type__c+'"'; 
                if(skey=='BG ATTRIBUTE'&& objectRecords[i].ApprovalRequest!=null&&objectRecords[i].ApprovalRequest.NF_BG_Attribute__c!=null)csvStringResult += '"'+ objectRecords[i].ApprovalRequest.NF_BG_Attribute__c+'"'; 
                if(skey=='ORGANISATION'&& objectRecords[i].ApprovalRequest!=null&&objectRecords[i].ApprovalRequest.NF_Organization_Level__c!=null)csvStringResult += '"'+ objectRecords[i].ApprovalRequest.NF_Organization_Level__c+'"';  
                if(skey=='EMAIL'&&objectRecords[i].User!=null&&objectRecords[i].User.Email!=null)csvStringResult += '"'+ objectRecords[i].User.Email+'"'; 
                if(skey=='DELEGATE USERS'&&objectRecords[i].DelegateUsers!=null)csvStringResult += '"'+ objectRecords[i].DelegateUsers+'"'; 
                if(skey=='DELEGATE USEREMAILS'&&objectRecords[i].DelegateUserEmails!=null)csvStringResult += '"'+ objectRecords[i].DelegateUserEmails+'"'; 
                
                counter++;
            } 
            csvStringResult += lineDivider;
        }
        return csvStringResult;        
    },
    
    
})