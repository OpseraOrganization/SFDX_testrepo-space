({
    myAction : function(component, event, helper) {
        component.set("v.SelectedLanguage",'English');
        var actionLanguage = component.get("c.getLanguageTerm");
        actionLanguage.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var selectedLanguage=component.find("LanguageSelection").get("v.value");
                var Text=response.getReturnValue();
                component.set("v.LangAndTerm",response.getReturnValue());
                var LanguageArray=[];
                var TermArray=[];
                for(var i=0;i<Text.length;i++)
                {
                    if(Text[i].Language__c === selectedLanguage)
                    {
                        TermArray.push(Text[i].Terms__c);
                    }
                    LanguageArray.push(Text[i].Language__c);
                }
                //alert('1::::'+LanguageArray);
                //alert(TermArray)
                var index=LanguageArray.indexOf('English');
                if (index > -1) {
                    LanguageArray.splice(index, 1);
                }
                //(LanguageArray);
                component.set("v.SelectedTerm",TermArray);    
                component.set("v.Language",LanguageArray);
                
                
            }
        });
        $A.enqueueAction(actionLanguage);
        
        
    },
    LanguageTerms : function(component, event, helper) {
        var selectedLanguage=component.find("LanguageSelection").get("v.value");
        component.set("v.SelectedLanguage",selectedLanguage);
        if(selectedLanguage == 'English'){
            //var LanguageSelectiontodownload = component.find("LanguageSelection1").get("v.value");
           // component.set("v.SelectedLanguage",LanguageSelectiontodownload);
            
        }
            var LangTerm=component.get("v.LangAndTerm");
        var TermArray=[];
        for(var i=0 ; i<LangTerm.length;i++)
        {
            if(LangTerm[i].Language__c == selectedLanguage)
            {
                TermArray.push(LangTerm[i].Terms__c)
                
            }
        }
        component.set("v.SelectedTerm",TermArray);  
        
        
    },
    closeModal : function(component, event, helper)
    {
        var LanguageSelection = component.find("LanguageSelection").get("v.value");
        component.set("v.SelectedLanguage",LanguageSelection);
        
       
        if(LanguageSelection != 'English'){
               var showToast1 = $A.get('e.force:showToast');
            //set the title and message params
            showToast1.setParams(
                {
                    'message': 'Please select english to accept terms first',
                    'type' : 'error'
                }
            );
            showToast1.fire(); 
            return false;
        }else{
          //  var LanguageSelectiontodownload = component.find("LanguageSelection1").get("v.value");
          //  component.set("v.SelectedLanguage",LanguageSelectiontodownload);
        }
        var checkCmp = component.find("Agretc").get("v.value");
        var checkCmpField = component.find("Agretc");
        if(checkCmp != true)
        {
            //checkCmpField.set("v.errors",[{message:"Please enter the mandatory field"}]);
            var showToast = $A.get('e.force:showToast');
            
            //set the title and message params
            showToast.setParams(
                {
                    'message': 'Please Agree With T&C',
                    'type' : 'error'
                    
                }
            );
            
            showToast.fire(); 
            
            return false;
            
        }
        else
        {
            component.set("v.closeModal",false); 
            
        }
    },
   /* DownloadTerm :function(component, event, helper) {
        var staticLabel = $A.get("$Label.c.CommunityUrl3");
        var LanguageSelection = component.find("LanguageSelection1").get("v.value");
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "https://dr1prm-nokiapartners.cs13.force.com/IRTandC?Language="+LanguageSelection
        });
        urlEvent.fire();
        
    }*/
})