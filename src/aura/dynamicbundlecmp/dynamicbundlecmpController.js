({
    doInit : function(component, event, helper) {
        helper.showSpinner(component);
        helper.getlineitemlist(component, event, helper);
        console.log('getlineitemlist helper is done');
        helper.getgroups(component, event, helper);
        helper.getAdjustmentTypes(component, event, helper);//added by jithin - flexible group
        helper.hideSpinner(component);
        
    },
    
    Addbundle : function(component, event, helper){
        
        helper.Updatebundle(component, event, helper);
        
    },
    
    selectedrowcount: function (cmp, event) {
        
        var selectedRows = event.getParam('selectedRows');
        var setRows = [];
        
        cmp.set('v.selectedRowsCount', selectedRows.length);
        console.log('selectedRows.length: '+selectedRows.length);
        for ( var i = 0; i < selectedRows.length; i++ ) {
            setRows.push(selectedRows[i]);
        }
        cmp.set('v.selectedRows', setRows);
        
    },
    
    Closeerrormsg:function (cmp, event) {
        
        cmp.set('v.iserror', 'false');
    },
    
    selectedbundlerow: function (cmp, event) {
        
        var selectedRows = event.getParam('selectedRows');
        var setRows = [];
        
        cmp.set('v.bundlerowCnt', selectedRows.length);
        console.log('bundlerowCnt.length: '+selectedRows.length);
        
        for ( var i = 0; i < selectedRows.length; i++ ) {
            setRows.push(selectedRows[i]);
        }
        cmp.set('v.BundleRows', setRows);
        
    },
    
    DeleteLineItems: function (component, event, helper) {
        
        helper.DeleteLineItems(component, event, helper);
    },

    handleoptionChange: function(component, event, helper){
        
        var seloption = component.get("v.bundleoptionselected");// event.getParam("label");
      //  var sellabel = component.get("v.groupoptions")[component.get("v.bundleoptionselected")];
        console.log('label of option chagne: '+ component.get("v.bundleoptionselected"));
        console.log('seloption: '+seloption);
        component.set('v.bundleoptionselected',seloption);
        
        // if(seloption == 'new' || seloption == 'choose'){
        if(seloption == 'new'){//added by jithin - flexible group
            component.set('v.isnewgroup', 'true');
            component.set('v.newgroupname',null);
            component.set('v.quantity','1');
            component.set('v.unitOverridePrice','');//added by jithin - flexible group
            component.set('v.adjustmentAmount','');//added by jithin - flexible group
            component.set('v.bundledata', []);//added by jithin - flexible group
        }else {
            component.set('v.isnewgroup', 'false');
            helper.getbundledetails(component, event, helper, seloption);
        }
        //added by jithin -flexible group - remove from here and and reset the value in above new block once more adjustment types are added
        component.set('v.adjustmentTypeSelected','Price Override');
    },
    
    //added by jithin - flexible group - start
    handleAdjustmentTypeOptionChange: function(component, event, helper){
        var seloption = component.get("v.adjustmentTypeSelected");
        component.set('v.adjustmentTypeSelected',seloption);
        console.log("v.adjustmentTypeSelected", component.get("v.adjustmentTypeSelected"));
        component.set('v.adjustmentTypeChanged','true');
    },
    //added by jithin - flexible group - end

    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },
    
    RedirectToCart : function(component,event,helper){
        
        helper.RedirectTocart(component, event, helper);
    },
    
    setquantitychange : function(component,event,helper){
        component.set('v.qtychanged','true');
	},
    
    getbundletreedata : function(component,event,helper){
        var spinner = component.find("mySpinner2");
        console.log('entered show spinner');
        component.set("v.Spinner2", true); 
        helper.fetchhierarchydata(component, event, helper);
	},
    
    setnamechange : function(component,event,helper){
        component.set('v.namechanged','true');
    },

    setUnitPriceOverrideChange : function(component,event,helper){
        component.set('v.unitPriceOverrideChanged','true');
    }
    
})