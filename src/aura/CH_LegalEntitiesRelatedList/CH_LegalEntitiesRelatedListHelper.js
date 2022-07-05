({
    getContactList: function(component) {    
        var action = component.get("c.getContactList");        
        action.setParams({
            "contactId" : component.get("v.recordId")
        });    
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnList = response.getReturnValue(),
                    resultList= [];
                for(let i in returnList){
                    resultList = [...resultList, {
                                  'ServiceContract': returnList[i].Entitlement.ServiceContract.Name,
                                  'ServiceContraclUrl': '/one/one.app?#/sObject/' + returnList[i].Entitlement.ServiceContract.Id + '/view',
                                  'AccountName': returnList[i].Entitlement.Account.Name,
                                  'AccountNameUrl': '/one/one.app?#/sObject/' + returnList[i].Entitlement.Account.Id + '/view',
                                  'AccountNumber': returnList[i].Entitlement.Account.AccountNumber
                	}];
                }
                component.set("v.mycolumn", [
                    {label: 'Service Contract Name', fieldName: 'ServiceContraclUrl', type: 'url', sortable: 'true', typeAttributes: {
                        label: { fieldName: 'ServiceContract' }
                    }},
                    {label: 'Legal Entity Name', fieldName: 'AccountNameUrl', type: 'url', sortable: 'true', typeAttributes: {
                        label: { fieldName: 'AccountName' }
                    }},
                    {label: 'Legal Entity Account Number', fieldName: 'AccountNumber', type: 'text', sortable: 'true'}
                ]);
                component.set("v.LegalEntities", resultList);
            }
        });         
        $A.enqueueAction(action);
    },
    sortData: function (component, fieldName, sortDirection) {
        var data = component.get("v.LegalEntities");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy((fieldName.indexOf('Url') != -1?fieldName:fieldName.replace('Url','')), reverse));
        component.set("v.LegalEntities", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a)?key(a):'', b = key(b)?key(b):'', reverse * ((a > b) - (b > a));
        }
    }
})