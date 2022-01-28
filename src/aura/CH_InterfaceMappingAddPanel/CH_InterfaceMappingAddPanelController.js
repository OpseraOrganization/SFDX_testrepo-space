({
    doInit: function(component, event, helper) {
        helper.getIMs(component);
    },
    deleteDialog: function(component, event, helper) {
        component.set("v.imIndexDeleteSelected", event.getSource().get('v.name'));
        component.set("v.isDialogOpen", true);
    },
    deleteIM: function(component, event, helper) {
        component.set("v.isDialogOpen", false);
        var deleteIndexSelected = component.get("v.imIndexDeleteSelected");
        var imId = component.get('v.imList')[deleteIndexSelected].object.Id;
        component.get('v.imList').splice(deleteIndexSelected, 1);
        component.set('v.imList', component.get('v.imList'));
        if(imId == undefined) {
            if(component.get('v.imIndexSelected') == deleteIndexSelected) {
                console.dir('select first in the list');
                console.dir(component.get('v.imList')[0]);
                if(component.get('v.imList')[0] != undefined) {
                    helper.selectIM(component.get('v.imList')[0].object);
                }
            }
        } else {
            console.dir('will delete now '+imId);
            //console.dir(component.get('v.imNew'));
            helper.deleteImRequest(component, imId);
        }
        return null;

    },
    closeModel: function(component, event, helper) { 
        component.set("v.isDialogOpen", false);
    },
    createIM: function(component, event, helper) {
        var isNewInitiated = false;
        for(var i in component.get('v.imList')) {
            if(component.get('v.imList')[i].object.Id == undefined) {
                isNewInitiated = true;
            }
        }
        if(isNewInitiated) {
            return;
        }
        var newIM = {index : component.get('v.imList').length, object : {Name: 'New IM'}};
        component.get('v.imList')[component.get('v.imList').length] = newIM;
        component.set('v.imList', component.get('v.imList'));
        helper.selectIM(newIM.object);
        console.dir('select the new one');
        component.set("v.imIndexSelected", component.get('v.imList').length - 1);
    },
    selectIM: function(component, event, helper) {
        helper.selectIM(component.get('v.imList')[event.currentTarget.dataset.rowIndex].object);
        console.dir('select clicked');
        component.set("v.imIndexSelected", event.currentTarget.dataset.rowIndex);
        return null;
    },
    downloadCSV: function(component, event, helper) {
        helper.getCsvBase64(component);
        
        return null;
    }
})