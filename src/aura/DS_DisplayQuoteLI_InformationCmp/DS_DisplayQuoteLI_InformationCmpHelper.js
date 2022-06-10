({
    getQuoteList : function(component) {
        var action = component.get("c.getQuoteDetails");
         action.setParams({
            "currentRecordId": component.get("v.recordId"),
        });
        action.setCallback(this, function(response){
            if (response.getState() === 'SUCCESS' && component.isValid()) {
                component.set('v.QuoteInfoList', response.getReturnValue());
            } else {
                alert(JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    getAttributeList : function(component) {
        var action = component.get("c.getAttributeLabelListForQuote");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                component.set('v.attributeList', response.getReturnValue());
            } else {
                alert(JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    getAttributeMap : function(component) {
        //Colleting Attribute Label - Attribute Value pairs for each Line Items
        var action = component.get("c.getAttributeMapForQuote");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                //The following structure is processable by the component
                var result = response.getReturnValue();
                var LineItemAttributeMap = [];
                for (var key1 in result) {
                    var AttributeLabelValueMap = [];
                    for (var key2 in result[key1]) {
                        AttributeLabelValueMap.push({key: key2, value: result[key1][key2]});
                    }
                    LineItemAttributeMap.push({key: key1, value: AttributeLabelValueMap});
                }
                component.set("v.mapValues", LineItemAttributeMap);
            } else {
                alert(JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    }
})