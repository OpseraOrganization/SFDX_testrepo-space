({
    // To prepopulate the seleted value pill if value attribute is filled
    doInit : function( component, event, helper )
    {
        console.log('lookupInit');
        $A.util.toggleClass(component.find('resultsDiv'),'slds-is-open');
        if( !$A.util.isEmpty(component.get('v.value')) )
        {
            var value = component.get('v.value');
            if( typeof component.get('v.fullList')  == "undefined" || component.get('v.fullList').length == 0 )
            {
                if( !$A.util.isEmpty(component.get('v.value')) )
                {
                	helper.searchRecordsHelperDB(component, event, helper, value);
                }
            }
            else
            {
                helper.searchRecordsHelper( component, event, helper, value );
            }
        }
    },

    // When a keyword is entered in search box
    searchRecords : function( component, event, helper )
    {

        if( typeof component.get('v.fullList')  == "undefined" || Object.keys(component.get('v.fullList')).length == 0)
        {
            if( !$A.util.isEmpty(component.get('v.searchString')) )
            {
                helper.searchRecordsHelperDB( component, event, helper, '');

            }
            else
            {
                $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
            }
        }
        else
        {
            helper.searchRecordsHelper( component, event, helper, '');
        }
    },

    // When an item is selected
    selectItem : function( component, event, helper )
    {
        if(!$A.util.isEmpty(event.currentTarget.id))
        {
            var recordsList = component.get('v.recordsList');
            var index = recordsList.findIndex(x => x.value === event.currentTarget.id)
            if(index != -1)
            {
                var selectedRecord = recordsList[index];
            }
            component.set('v.selectedRecord',selectedRecord);
            component.set('v.value',selectedRecord.value);
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
            //Trigger Event
            helper.notifySelChangeParentCmp(component, event, helper);
        }
    },

    showRecords : function( component, event, helper )
    {
        if(!$A.util.isEmpty(component.get('v.recordsList')) && !$A.util.isEmpty(component.get('v.searchString')))
        {
            $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
        }
    },

    // To remove the selected item.
    removeItem : function( component, event, helper )
    {
        component.set('v.selectedRecord','');
        component.set('v.value','');
        component.set('v.searchString','');
        setTimeout( function() {
            component.find( 'inputLookup' ).focus();
        }, 250);
        //Trigger Event
        helper.notifySelChangeParentCmp(component, event, helper);
    },

    // To close the dropdown if clicked outside the dropdown.
    blurEvent : function( component, event, helper )
    {
        $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
    },
})