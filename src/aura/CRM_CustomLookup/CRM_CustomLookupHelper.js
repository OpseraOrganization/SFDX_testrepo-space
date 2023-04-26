({
    searchRecordsHelper : function(component, event, helper, value)
    {
    	$A.util.removeClass(component.find("Spinner"), "slds-hide");
        var searchString = component.get('v.searchString');
        component.set('v.message','');
        var result = helper.filterLocalList(component, event, helper, searchString);
        component.set('v.recordsList', []);
        if(result.length > 0)
        {
            // To check if value attribute is prepopulated or not
            if( $A.util.isEmpty(value) )
            {
                result = helper.removeHiddenContacts(result);
                component.set('v.recordsList',result);
            }
            else
            {
                component.set('v.selectedRecord', {'label': helper.getLabelFromId(result, value) , 'value': value});
            }
        }
        else
        {
            component.set('v.message', "No Records Found for '" + searchString + "'");
        }

        // To open the drop down list of records
        if( $A.util.isEmpty(value) )
        {
            $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
        }
        $A.util.addClass(component.find("Spinner"), "slds-hide");

    },

    filterLocalList : function(component, event, helper, searchString)
    {
    	var fullList = component.get('v.fullList');
        var filteredLocalList = [];
        for( var i = 0; i < fullList.length; i++)
        {
            var contactName = fullList[i].label;
            if(contactName.includes(searchString))
            {
                filteredLocalList.push(fullList[i]);
            }
        }
        return filteredLocalList;
	},

    removeHiddenContacts : function(result)
    {
    	for( var i = result.length - 1; i >= 0 ; i--)
        {
            if(result[i].hide)
            {
                result.splice(i, 1);
            }
        }
        return result;
	},

    getLabelFromId : function(wraperList, idValue)
    {
        var label;
        for( var i = 0; i < wraperList.length; i++)
        {
            if(idValue == wraperList[i].value)
            {
                label = wraperList[i].label;
                break;
            }
        }
        return label;
	},

    searchRecordsHelperDB : function(component, event, helper, value)
    {
        $A.util.removeClass(component.find("Spinner"), "slds-hide");
        var searchString = component.get('v.searchString');
        component.set('v.message', '');
        component.set('v.recordsList', []);

        // Calling Apex Method
        var action = component.get('c.fetchRecords');
        action.setParams({
            'objectName' : component.get('v.objectName'),
            'filterField' : component.get('v.fieldName'),
            'searchString' : searchString,
            'recordCount' : component.get('v.recordCount'),
            'globalFilter' : component.get('v.globalFilter'),
            'value' : value
        });

        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            if(response.getState() === 'SUCCESS')
            {
                if(result.length > 0)
                {
                    // To check if value attribute is prepopulated or not
                    if( $A.util.isEmpty(value) )
                    {
                        component.set('v.recordsList',result);
                    }
                    else
					{
                        component.set('v.selectedRecord', result[0]);
                    }
                }
                else
                {
                    component.set('v.message', "No Records Found for '" + searchString + "'");
                }
            }
            else
            {
                // If server throws any error
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message)
                {
                    component.set('v.message', errors[0].message);
                }
            }
            // To open the drop down list of records
            if( $A.util.isEmpty(value) )
            {
                $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
            }
            $A.util.addClass(component.find("Spinner"), "slds-hide");
        });
        $A.enqueueAction(action);
    },

    notifySelChangeParentCmp : function(component, event, helper)
    {
        var compEvent = component.getEvent("CRM_CustomLookupChangeSelEvent");
        compEvent.setParams({
            "indexOnList" : component.get('v.indexOnList'),
            "message" : 'Lookup value was changed'
        });
        compEvent.fire();
    }
})