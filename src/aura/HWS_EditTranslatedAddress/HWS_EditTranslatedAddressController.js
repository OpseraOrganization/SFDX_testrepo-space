({
    doInit : function(component, event, helper){
        helper.getAccountDetails(component, event, helper);
    },
    closeModel : function(component, event, helper) {
        helper.closeModel(component, event, helper);        
    },
    collapseSection: function(component, event, helper){
        try{
            var selected_row_div = event.currentTarget;
            var section = selected_row_div.dataset.value;
            helper.collapseSec(component, event, section);
        } catch (err) {
            //console.log('ERROR: ' + err + ' ** MESSAGE: ' + err.message + ' ** STACK: ' + err.stack);
        }
    },
    updateDetails: function(component, event, helper){
        try{
            component.set('v.projectAddr1',component.get('v.Account.Hws_Address_Line_1__c'));
            component.set('v.projectAccName',component.get('v.Account.Name'));
            //NOKIASC-38946 - Added check while edit Ad hoc address -- Start
            var projectAccCity = component.get('v.Account.BillingCity')+','+((typeof(component.get('v.Account.ShippingState'))=="undefined")?'':('v.Account.ShippingState'))+','+component.get('v.Account.ShippingCountry')+','+component.get('v.Account.ShippingPostalCode');
            component.set('v.projectAccCity',projectAccCity.replace(',,',','));           
            component.set('v.projectAddr2',component.get('v.Account.Hws_Address_Line_2__c'));
            component.set('v.projectAddr3',component.get('v.Account.Hws_Address_Line_3__c'));
            component.set('v.projectAddrLocal1', component.get('v.Account.HWS_AddressLineLocal1__c'));
            component.set('v.projectAccNameLocal', component.get('v.Account.Legal_Name_Ext__c'));
            var projectAccCityLocal = component.get('v.Account.ShippingCity')+','+((typeof(component.get('v.Account.ShippingState'))=="undefined")?'':('v.Account.ShippingState'))+','+component.get('v.Account.ShippingCountry')+','+component.get('v.Account.ShippingPostalCode');
            component.set('v.projectAccCityLocal',projectAccCityLocal.replace(',,',','));
            //NOKIASC-38946 - Added check while edit Ad hoc address -- End
			var fullAdd = '';
            if(component.get('v.Account.HWS_AddressLineLocal1__c') != undefined)
                fullAdd =component.get('v.Account.HWS_AddressLineLocal1__c')+',';
            if(component.get('v.Account.HWS_AddressLineLocal2__c') != undefined)
                fullAdd =fullAdd + component.get('v.Account.HWS_AddressLineLocal2__c')+',';
            if(component.get('v.Account.HWS_AddressLineLocal3__c') != undefined)
                fullAdd =fullAdd + component.get('v.Account.HWS_AddressLineLocal3__c')+',';
            component.set('v.Account.ShippingStreet', fullAdd);
            
            var fullAdd2 = '';
            if(component.get('v.Account.Hws_Address_Line_1__c') != undefined)
                fullAdd2 =component.get('v.Account.Hws_Address_Line_1__c')+',';
            if(component.get('v.Account.Hws_Address_Line_2__c') != undefined)
                fullAdd2 =fullAdd2 + component.get('v.Account.Hws_Address_Line_2__c')+',';
            if(component.get('v.Account.Hws_Address_Line_3__c') != undefined)
                fullAdd2 =fullAdd2 + component.get('v.Account.Hws_Address_Line_3__c')+',';
            component.set('v.Account.BillingStreet', fullAdd2); 
           
            component.set('v.projectAddrLocal2', component.get('v.Account.HWS_AddressLineLocal2__c'));
            component.set('v.projectAddrLocal3', component.get('v.Account.HWS_AddressLineLocal3__c'));
            component.set('v.showtranslateValue',true);
            var validation = helper.getShiptoPartyValidation(component, event);
            if(validation)
           	 helper.updateDetails(component, event, helper); 
        }
        catch (err) {
           // console.log('ERROR: ' + err + ' ** MESSAGE: ' + err.message + ' ** STACK: ' + err.stack);
        }
    }
})