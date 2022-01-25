({
    getIMs: function(component) {
        var action = component.get('c.getImList');
        action.setCallback(this, function(actionResult) {
            var result = actionResult.getReturnValue();
            var imList = [];
            for(var i = 0; i < result.length; i++) {
                var imMap = [];
                imMap['index'] = i;
                imMap['object'] = result[i];
                imList.push(imMap);
            }

            console.dir('will add {} now');
            component.set('v.imList', imList);
            component.set('v.imListLoaded', true);
            if(imList[0] != undefined) {
                this.selectIM(imList[0].object);
            }
        });
        $A.enqueueAction(action);
    },
    deleteImRequest: function(component, imId) {
        var action = component.get('c.deleteImRecord');
        action.setParams({
            imId : imId
        });
        action.setCallback(this, function(actionResult) {
            this.getIMs(component);
        });
        $A.enqueueAction(action);
    },
    selectIM: function(selectedIM) {
        var selectImEvent = $A.get("e.c:CH_InterfaceMappingSelectEvent");
        selectImEvent.setParams({ "im": selectedIM });
        selectImEvent.fire();
    },
    getCsvBase64: function(component) {
        var action = component.get('c.getCsvBase64');
        action.setCallback(this, function(actionResult) {
            var csv = actionResult.getReturnValue();
            var imLink = document.createElement('a');
            imLink.href = 'data:text/csv;base64,' + csv;
            imLink.target = '_self';
            imLink.download = 'interface_mapping.csv';
            document.body.appendChild(imLink); // for Firefox
            imLink.click();
        });
        $A.enqueueAction(action);
    }
})