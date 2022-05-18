({
    
    GetQuoterelatedDetails: function(component, event, helper) {
        component.set("v.IsSpinner", true);
        helper.GetQuoterelatedDetailsHelper(component);
    },
    Closemodelemail: function(component, event, helper) {
        helper.cancelQuote(component,event);
        
    },
    
    ChangeChevronandDrop: function(component, event, helper) {
        var source = event.getSource();
        var auraid=source.getLocalId(); 
        var currentattr = component.get(auraid);
        var val=!currentattr;
        component.set(auraid, val);
        
    },
    OnchangeSelectAll: function(component, event, helper) {
        var source = event.getSource();
        var auraid=source.getLocalId();
        var Checked= source.get("v.checked");
        var TempList=[];
        
        //alert(Checked);
               // alert(auraid);

        if(auraid=="CurrentQuoteteam"){             
            if(Checked)
                component.find("SelectAll_QuoteTeam").set('v.checked',false) ;
            
            if(!Checked)  {  
                var QuoteTeam= component.get("v.Quoteteam");
                var Allchecked=true;
                for(var Q = 0; Q <QuoteTeam.length; Q++)
                {
                    if( QuoteTeam[Q].isselected==false&&QuoteTeam[Q].Quoteteam!=null&&QuoteTeam[Q].Quoteteam!=undefined &&QuoteTeam[Q].Quoteteam!='')
                        Allchecked=false;
                }
                component.find("SelectAll_QuoteTeam").set('v.checked',Allchecked) ;
            }
            
        }
        if(auraid=="CurrentCustomerContact"){
            if(Checked){
                component.find("SelectAll_CustomerContact").set('v.checked',false); 
            }
            if(!Checked)  {  
                var Allchecked=true;
                var Customercontact= component.get("v.Customercontact");
                
                for(var Q = 0; Q <Customercontact.length; Q++)
                {      
                    if( Customercontact[Q].isselected==false&&Customercontact[Q].CustomerContact!=null&&Customercontact[Q].CustomerContact!=undefined &&Customercontact[Q].CustomerContact!='')
                        Allchecked=false;
                }
                component.find("SelectAll_CustomerContact").set('v.checked',Allchecked) ;
                
            }
        }
        
        if(auraid=="CurrentDocument"){
            if(Checked)
                component.find("SelectAll_Documents").set('v.checked',false);  
            if(!Checked)  {  
                var Allchecked=true;
                var curDoc= component.get("v.Documents");
                
                for(var Q = 0; Q <curDoc.length; Q++)
                {
                    if( curDoc[Q].isselected==false&&curDoc[Q].ContDoc_link!=null&&curDoc[Q].ContDoc_link!=undefined &&curDoc[Q].ContDoc_link!='')
                        Allchecked=false;
                }
                component.find("SelectAll_Documents").set('v.checked',Allchecked) ;
                
            }
        }
        
        if(auraid=="SelectAll_QuoteTeam"){
            var QuoteTeam= component.get("v.Quoteteam");
            for(var Q = 0; Q <QuoteTeam.length; Q++)
            {
                QuoteTeam[Q].isselected=Checked;
                TempList.push(QuoteTeam[Q]);  
            } 
            component.set('v.Quoteteam',TempList); 
        }
        if(auraid=="SelectAll_CustomerContact"){
            var Customercontact= component.get("v.Customercontact");
            for(var Q = 0; Q < Customercontact.length; Q++)
            {
                if(!Customercontact[Q].CustomerContact.CQ_Is_Primary__c)
                    Customercontact[Q].isselected=Checked;
                TempList.push(Customercontact[Q]);   
            }
            component.set('v.Customercontact',TempList);
            
        }
        if(auraid=="SelectAll_Documents"){
            var ContDoc= component.get("v.Documents");
            for(var Q = 0; Q < ContDoc.length; Q++)
            {
               if(!  ContDoc[Q].disabled)
                ContDoc[Q].isselected=Checked;
                TempList.push(ContDoc[Q]);   
            }
            component.set('v.Documents',TempList);
            
        }
        
    },
    sendemail: function(component, event, helper) {
        var mailbody=component.find("Mailbodyoutput").get("v.value");
        var isValidEmail = true;
        var NotAllowedOrg = false;
        var emailField = component.find("ExtraEmails");
        var emailFieldValue = emailField.get("v.value");
        emailFieldValue=emailFieldValue.trim();
        var regExpEmailformat = /^(([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)(\s*;\s*|\s*$))*$/;  
        if(!$A.util.isEmpty(emailFieldValue)){   
            if(emailFieldValue.match(regExpEmailformat)){
                var AllowedOrg = $A.get("$Label.c.CQ_SendQuote_AllowedOrg");
                var AllowedOrgList=AllowedOrg.toLowerCase().split(';');
                var Emails = emailFieldValue.toLowerCase().split(';');
                for(var Q = 0; Q <Emails.length; Q++){
                    if(Emails[Q]!=null &&Emails[Q]!=undefined &&Emails[Q]!='')
                    {
                        var EmailOrg=Emails[Q].split('@');
                        if(!AllowedOrgList.includes(EmailOrg[1]))
                            NotAllowedOrg=true;
                    }
                }
                if(!NotAllowedOrg)isValidEmail = true;
                
                if(NotAllowedOrg){
                component.set("v.ErrorMsg", "Emails with these domains only can be entered :"+$A.get("$Label.c.CQ_SendQuote_AllowedOrg"));
                    component.set("v.Showerrormsg", true);
                    isValidEmail = false;
                }
            }
            else{
                component.set("v.ErrorMsg", "Enter valid email ids separated by a semi-colon");
                component.set("v.Showerrormsg", true);
                isValidEmail = false;
            }
        }
        
        if (isValidEmail) {
            
            component.set("v.Showerrormsg", false);
            component.set("v.IsSpinner", true);
            component.find("Sendemailbutton").set('v.disabled',true) ;
            component.find("Cancelbutton").set('v.disabled',true) ;
            helper.SendEmailQuoteUsers(component);
        }
        else {
            if(NotAllowedOrg){
                component.set("v.ErrorMsg", "Emails with these domains only can be entered :"+$A.get("$Label.c.CQ_SendQuote_AllowedOrg"));
                    component.set("v.Showerrormsg", true);  
            }
             if(!NotAllowedOrg)
             {
            component.set("v.ErrorMsg", "Enter valid email ids separated by a semi-colon");
            component.set("v.Showerrormsg", true);
             }
        }
    },
    Closeerrormsg: function(component, event, helper) {
        component.set("v.Showerrormsg", false);
    },
    LoadHtmlValue: function(component, event, helper) {
        var source = event.getSource();
        var value= source.get("v.value");
        component.find("Mailbodyoutput").set('v.value',value) ;
        
    },
    
})