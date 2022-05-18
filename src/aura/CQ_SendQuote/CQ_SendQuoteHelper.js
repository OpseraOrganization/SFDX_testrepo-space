({
    GetQuoterelatedDetailsHelper: function(component,event,helper){
        var action = component.get("c.QuoteRelatedDetails");
        action.setParams({
            "currentRecordId": component.get("v.recordId"),
            "Objecttype": "Apttus_Proposal__Proposal__c",
        });
        
        action.setCallback(this, function(response){
            
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid()){ 
                component.set("v.IsSpinner", false);
                
                var result=response.getReturnValue();
                if(result!=null &&result!=undefined &&result!='')
                {
                    if(result.Errormessage==null)
                    {
                        component.set("v.isOpenmodal", true);
                        component.set('v.CurrentQUote', result.CurrentQuote);
                        component.set('v.Quote_Number', result.CurrentQuote.NokiaCPQ_Proposal_Id__c.replace(/[^\w\s]/gi, ''));
                        component.set('v.Email_Templates', result.Emailtemplates);
                        if(result.Emailtemplates!=null &&result.Emailtemplates!=undefined &&result.Emailtemplates!='')
                        component.find("Mailbodyoutput").set('v.value',result.Emailtemplates[0].HtmlValue) ;
                        component.set('v.Helptext', "Emails with these domains only can be entered :"+$A.get("$Label.c.CQ_SendQuote_AllowedOrg"));

                        if(result.Contactteamwraplist!=null &&result.Contactteamwraplist!=undefined &&result.Contactteamwraplist!='')
                        {
                            var Quoteteamlist = [];
                            var CustomerContactlist = [];
                            var Documentlist = [];
                            for(var Q = 0; Q < result.Contactteamwraplist.length; Q++)
                            {
                                if(result.Contactteamwraplist[Q].CustomerContact!=null&&result.Contactteamwraplist[Q].CustomerContact!=undefined &&result.Contactteamwraplist[Q].CustomerContact!='' )
                                    CustomerContactlist.push(result.Contactteamwraplist[Q]);
                                if(result.Contactteamwraplist[Q].Quoteteam!=null&&result.Contactteamwraplist[Q].Quoteteam!=undefined &&result.Contactteamwraplist[Q].Quoteteam!='' )
                                    Quoteteamlist.push(result.Contactteamwraplist[Q]);
                                if(result.Contactteamwraplist[Q].ContDoc_link!=null&&result.Contactteamwraplist[Q].ContDoc_link!=undefined &&result.Contactteamwraplist[Q].ContDoc_link!='' )
                                    Documentlist.push(result.Contactteamwraplist[Q]);
                            }
                            component.set('v.Customercontact',CustomerContactlist);
                            component.set('v.Quoteteam',Quoteteamlist); 
                            component.set('v.Documents',Documentlist); 
                        } 
                    }
                    if(result.Errormessage!=null)
                    {
                        this.cancelQuote(component,event);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "warning",
                            "title": "Warning",
                            "duration":"5000",
                            "message": result.Errormessage,
                            "mode":"dismissible",
                        });
                        toastEvent.fire();
                        
                    }
                }
                
                component.set('v.IsSpinner',false);
                
            }else{
                component.set('v.IsSpinner',false);
                var   errors = response.getError();
                var errorpgmsg=JSON.stringify(errors);
                alert(errorpgmsg);
            }
        });
        $A.enqueueAction(action);
        
    },
    
    SendEmailQuoteUsers: function(component,event,helper)
    {
        var ExtraEmails =component.find("ExtraEmails").get('v.value');
        ExtraEmails=ExtraEmails.trim();
        var Extramail=[];
        if(!$A.util.isEmpty(ExtraEmails)){
            var Emails = ExtraEmails.split(';');
            for(var Q = 0; Q <Emails.length; Q++){
                if(Emails[Q]!=null &&Emails[Q]!=undefined &&Emails[Q]!='')
                    Extramail.push(Emails[Q]);
            }
        }
        var mailbody=component.find("Mailbodyoutput").get("v.value");
        var subject=  component.get("v.subject");
        var Customercontact=component.get("v.Customercontact");
        var Quoteteam=component.get("v.Quoteteam");
        var Documents=component.get("v.Documents");
        var Quote=component.get("v.CurrentQUote");
        var Documentslist=[];
        var Customercontactlist=[];
        var Customercontactlistv1 =[];
        var Customercontactlistv2=[];
        var Quoteteamlist=[];
        var Customercontactval=[];
        var sendEmail=true;
        var Errormessage=null;
        var Sub=Quote.NokiaCPQ_Proposal_Id__c.replace(/[^\w\s]/gi, '')+' - '+Quote.Apttus_Proposal__Proposal_Name__c;  
        
        //alert('mailbody-->'+mailbody);
        if(subject!=null &&subject!=undefined)
            Sub=Quote.NokiaCPQ_Proposal_Id__c.replace(/[^\w\s]/gi, '')+' - '+Quote.Apttus_Proposal__Proposal_Name__c+' - '+subject;
        
        for(var Q = 0; Q <Quoteteam.length; Q++)
            if( Quoteteam[Q].isselected==true)Quoteteamlist.push(Quoteteam[Q].Quoteteam.CQ_Quote_Team_Member__r.Email);
        
        for(var Q = 0; Q <Customercontact.length; Q++){
            if( Customercontact[Q].isselected==true){
                Customercontactlist.push(Customercontact[Q].CustomerContact.CQ_Contact__r.Email);
                Customercontactval.push(Customercontact[Q].CustomerContact);
            }
        }
        for(var Q = 0; Q <Documents.length; Q++)
            if( Documents[Q].isselected==true)Documentslist.push(Documents[Q].ContDoc_link.ContentDocumentId);
        
        if(Documentslist.length==0 || Customercontactlist.length==0 || Quoteteamlist.length==0)
        {         component.set("v.IsSpinner", false);
         
         sendEmail=false;
         if(Documentslist.length==0)
             Errormessage='Please select at least one document';
         if(Customercontactlist.length==0)
             Errormessage='Please select at least one Customer contact';
         if(Quoteteamlist.length==0)
             Errormessage='Please select at least one Quote team member';
         
         component.set("v.ErrorMsg", Errormessage);
         component.set("v.Showerrormsg", true);
         component.find("Sendemailbutton").set('v.disabled',false) ;
         component.find("Cancelbutton").set('v.disabled',false) ;
         
        }
        
        if(sendEmail){
             Customercontactlistv1 = Customercontactlist.concat( Quoteteamlist );
             Customercontactlistv2=Customercontactlistv1.concat( Extramail ); 
           
            var action = component.get("c.sendQuoteEmail");
            action.setParams({
               "toAddresses": Customercontactlistv2,
                "mailbody" :mailbody,
                "subject":Sub,
                "DocumentIds" :Documentslist,
                "Quote":Quote,
                "Customercontacts":Customercontactval,
                "QuoteteamEmails":Quoteteamlist,
            });
          
            action.setCallback(this, function(response){
                component.find("Sendemailbutton").set('v.disabled',false) ;
                component.find("Cancelbutton").set('v.disabled',false) ;
                var state = response.getState();
                var result=response.getReturnValue();
                var error=true;
                if(state === "SUCCESS"&&result!=null&&result.includes('success')) {
                    error=false;
                    Errormessage='Email Sent Successfully';
                    component.set("v.IsSpinner", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": 'Success',
                        "message": 'Email Sent Successfully',
                        "mode":"dismissible",
                    });
                    toastEvent.fire();
                    this.cancelQuote(component,event); 
                }  
                if(state === "ERROR"){
                    var errors = response.getError();
                    var errorpgmsg=JSON.stringify(errors);
                    component.set("v.IsSpinner", false);
                    Errormessage=errorpgmsg;
                    component.set("v.ErrorMsg", Errormessage);
                    component.set("v.Showerrormsg", true);
                    component.set("v.isOpenmodal", true); 
                }
                if(result!=null&&error)
                {    
                    component.set("v.IsSpinner", false);
                    if(result.includes('INVALID_EMAIL_ADDRESS'))  
                        Errormessage='TO/CC Email addresses contains invalid email.Please check your Email Addresses'
                        else
                            if(result.includes('Email body is required'))  
                                Errormessage='You cannot send empty Email.Please write Something';
                            else
                                Errormessage=result;
                    
                    component.set("v.ErrorMsg", Errormessage);
                    component.set("v.Showerrormsg", true);
                    
                    component.set("v.isOpenmodal", true); 
                }
            });
            $A.enqueueAction(action);
        }
        
        
    },
    
    cancelQuote: function(component, event) {
        component.set("v.isOpenmodal", false);
        var urlEvt = $A.get("e.force:navigateToURL");
        urlEvt.setParams({
            "url": '/' + component.get("v.recordId")
        });
        urlEvt.fire();
        component.destroy();        
    },
    
})