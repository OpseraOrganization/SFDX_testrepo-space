({
    myAction : function(component, event, helper) {
        component.set("v.SelectedLanguage",'English');
        var actionLanguage = component.get("c.getLanguageTerm");
        //Get all available languages and related Terms from backend
        actionLanguage.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var selectedLanguage=component.find("LanguageSelection").get("v.value");
                var Text=response.getReturnValue();
                //A list of objects where Langauage and its related Terms are the instance variables
                component.set("v.LangAndTerm",response.getReturnValue());
                var LanguageArray=[];
                var TermArray=[];
                //Construct Array for each Langauages and Terms
                for(var i=0;i<Text.length;i++)
                {
                    if(Text[i].Language__c === selectedLanguage)
                    {
                        TermArray.push(Text[i].Terms__c);
                    }
                    LanguageArray.push(Text[i].Language__c);
                }
                var index=LanguageArray.indexOf('English');
                if (index > -1) {
                    LanguageArray.splice(index, 1);
                }
                component.set("v.SelectedTerm",TermArray);    
                component.set("v.Language",LanguageArray);
            }
        });
        $A.enqueueAction(actionLanguage);
    },
    
    //Method Change the displayed T&C based on the language selection
    LanguageTerms : function(component, event, helper) {
        var selectedLanguage=component.find("LanguageSelection").get("v.value");
        component.set("v.SelectedLanguage",selectedLanguage);
        var LangTerm=component.get("v.LangAndTerm");
        var TermArray=[];
        for(var i=0 ; i<LangTerm.length;i++)
        {
            if(LangTerm[i].Language__c == selectedLanguage)
            {
                TermArray.push(LangTerm[i].Terms__c);
            }
        }
        component.set("v.SelectedTerm",TermArray);  
    },
    
    //Method to close the Modal
    closeModal : function(component, event, helper)
    {
        var LanguageSelection = component.find("LanguageSelection").get("v.value");
        component.set("v.SelectedLanguage",LanguageSelection);
        //Assign the Agree checkboxes state to the attribute to validate if the T&C is agreed or not
        component.set("v.isAgree", component.find("Agretc").get("v.checked"));
        component.set("v.closeModal",false); 
    }
})