({
    doInit : function(component, event, helper) {
 
        helper.doInit(component, event, helper);
    },
    RedirectTocart : function(component, event, helper) {

        helper.RedirectTocart(component, event, helper);

    },
    AddToCart : function(component, event, helper) {

        helper.AddToCart(component, event, helper);

    },

    Search : function(component, event, helper) {

        var searchField = component.find('searchField');
        var isValueMissing = searchField.get('v.validity').valueMissing;
        if(isValueMissing) {
            searchField.showHelpMessageIfInvalid();
        }else{
            console.log("Inside Search");
            helper.SearchHelper(component, event);
        }

    },
    CheckboxClick : function(component, event, helper) {

        helper.CheckboxClick(component, event, helper);

    }
})