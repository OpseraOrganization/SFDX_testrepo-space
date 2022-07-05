({
    getGateParticipants: function(component,event,helper){
        helper.getGAteparticipantsHelper(component);
    },
    
    
    UpdateGatePArticipants: function(component,event,helper){
        component.set('v.needtorefresh',true);
        component.set('v.Gateuser_msgval',null);
        component.set('v.MyApprovalList', null);
        component.set('v.MyApprovalEmailList',null);
        component.set('v.EmailBlock',false);
        component.set('v.Gateuser_msg',false);
        helper.getGAteparticipantsHelper(component);
    },
    
    downloadGatePArticipants: function(component,event,helper){
        var MyApprovalList = component.get("v.MyApprovalList");
        var Currentopp = component.get("v.Currentopp");
        var csvfile = helper.convertListToCSV(component,MyApprovalList);  
        if (csvfile == null)
        {return;}
        
      
        var dateformat= new Date().toLocaleString();
        
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvfile);
        hiddenElement.target = '_self'; //Name 
        hiddenElement.download = Currentopp.Opportunity_ID__c+"_GateParticipants__"+dateformat+'.csv';  
        document.body.appendChild(hiddenElement); 
        hiddenElement.click(); 
    }, 
    
    viewfunction : function (component, event, helper) {
        
        var viewRecord = event.getSource().get("v.value");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId":viewRecord,
        });
        navEvt.fire(); 
    },
    Copytoclipboard : function(component, event, helper) {
        
        window.getSelection().removeAllRanges();
        document.getSelection().empty();
        var source = event.getSource();
        var auraid=source.getLocalId();
       // var holdtxt = document.getElementById(auraid);
          var copytxt = component.find(auraid).get('v.value');
     
        if(auraid=='AV_Emails'){
            component.find("SH_Emails").set('v.label','Copy Stakeholders');
            component.find("SH_Emails").set('v.class','slds-button slds-button_brand');
            component.find("AV_Emails").set('v.class','slds-button slds-button_success');
            window.setTimeout(
                $A.getCallback(function() {
                    component.find("AV_Emails").set('v.label','Copy Approvers/Validators');
                    component.find("AV_Emails").set('v.class','slds-button slds-button_brand');
                }), 3000
            );
        } 
        if(auraid=='SH_Emails'){
            component.find("AV_Emails").set('v.label','Copy Approvers/Validators');
            component.find("AV_Emails").set('v.class','slds-button slds-button_brand');
            component.find("SH_Emails").set('v.class','slds-button slds-button_success');
            window.setTimeout(
                $A.getCallback(function() {
                    component.find("SH_Emails").set('v.label','Copy Stakeholders');
                    component.find("SH_Emails").set('v.class','slds-button slds-button_brand');
                }), 3000
            );
        }
        
     /*   holdtxt.select();
        document.queryCommandSupported('copy');
        document.execCommand('copy');
        */
    function handler (event){
        event.clipboardData.setData('text/plain', copytxt);
        event.preventDefault();
        document.removeEventListener('copy', handler, true);
    }

    document.addEventListener('copy', handler, true);
    document.execCommand('copy');
        
        source.set('v.label','Copied!');
     },
    
    OpenmodalEmail: function(component, event, helper) {
        component.set("v.isOpenmodal", true);
    },
    Closemodelemail: function(component, event, helper) {
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
    },
    sendemail: function(component, event, helper) {
        helper.SendEmailforgateParticipants(component);
    },
    
    launchoutlook: function(component, event, helper) {
        var subject = component.get("v.subject");
        var AV_users = component.get("v.AV_users");
        var SH_users = component.get("v.SH_users");
        if(subject==null || subject==undefined )
            subject='Regarding Gate Participants';
        
        var mailbody=component.get("v.mailbody");
        
        if(mailbody==null || mailbody==undefined )
            mailbody='Hi All ';
        
        var body = escape(mailbody);
        
        if(SH_users==null || SH_users==undefined ||SH_users=='' )
            window.location.href = "mailto:"+AV_users+"?body="+body+"&subject="+subject;
        
        if(SH_users!=null &&SH_users!=undefined &&SH_users!=''&& AV_users!=null &&AV_users!=undefined &&AV_users!='')
            window.location.href = "mailto:"+AV_users+"?cc="+SH_users+"&subject=%20"+subject+"&body=%20"+body;
           
         if(AV_users==null || AV_users==undefined ||AV_users=='' )
            window.location.href = "mailto:"+SH_users+"?body="+body+"&subject="+subject;

    },
    
    NEWEVEntCreation: function(component, event, helper) {
        var Create_NEW = 'Event' ; 
        var RecordID = component.get("v.recordId") ;
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName":Create_NEW,
            "defaultFieldValues": {
                'WhatId' :RecordID ,
            }
        });
        createRecordEvent.fire();
    },
    startDateUpdated: function(component, event, helper) {
    },
    endDateUpdated: function(component, event, helper) {
    },
    ToggleformeetingChange : function(component, event, helper) {
      var changeElement = component.find("Showmeeting");
      $A.util.toggleClass(changeElement, "slds-hide");
      var Sendattachment =component.find("sendattachment").get('v.value');
      if(Sendattachment)
        component.find("Sendemailbutton").set('v.label','Send invite');
      if(!Sendattachment)
        component.find("Sendemailbutton").set('v.label','Send email');
      
	  },
     ToggleforEmailaddresses : function(component, event, helper) {
      var changeElement = component.find("ShowEmails");
      $A.util.toggleClass(changeElement, "slds-hide");
     
	  },
    
})