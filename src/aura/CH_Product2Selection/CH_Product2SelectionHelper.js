({
    searchProduct: function(component, searchText) {
        var helper = this, product = component.get('v.product');
        helper.incrementActionCounter(component);
        helper.action(component, "c.searchProducts", { 
            searchString: searchText 
        }, (productList, error) => {
            helper.decrementActionCounter(component);
            component.set('v.productData', productList);
            component.set("v.focusData", productList);
            if(productList.length == 0) {
            	return helper.select(component, { Id: 'product', Name: 'Product'}, null, true, searchText);
        	}
   			else if(product!=null){component.find("productTable").setSelectedRows(new Array(product.Id));}
        });
    },
    searchProductRelated: function(component, target) {
        var helper = this, parents = ['product'], object = component.get('v.'+target.Id);
        helper.incrementActionCounter(component);
        switch(target.Id) {
            case 'swRelease': parents = ['productRelease', 'swComponent']; break;
            case 'swModule': parents = ['product', 'productVariant', 'swComponent']; break;
            case 'swBuild': parents = ['productRelease', 'swRelease', 'swModule']; break;
        }
        var source = {}, valid = false;
        for(let i = 0; i < parents.length; i++) {
            let nokiaId = component.get('v.'+parents[i]);
            if(helper.valid(nokiaId)) {
                valid = true;
                source[parents[i]] = (parents[i].indexOf('Release') != -1 ? nokiaId.CH_NSNLegacyCode__c : nokiaId.NCP_Nokia_Product_Id__c);
            }
        }
        if(valid) {
            helper.action(component, "c.searchProductRelated", { 
                "target": target.Id,
                "source": source
            }, (productList, error) => {
                helper.decrementActionCounter(component);
                if(object != null && productList.length == 0) {
                	return helper.select(component, target, null, true);
            	}
                for(let i = 0; i < productList.length; i++) {
                    if(productList[i].CH_Summary__c && productList[i].CH_Summary__c !== '') productList[i].Description = productList[i].CH_Summary__c;
                    if(productList[i].CH_Description__c && productList[i].CH_Description__c !== '') productList[i].Description = productList[i].CH_Description__c;
                }
                component.set('v.focusData', productList?productList:[]);
                if(object != null) component.find("productTable").setSelectedRows(new Array(object.Id));
                else component.find("productTable").setSelectedRows(new Array());
            });
        }
        else {
            helper.decrementActionCounter(component);
            component.set('v.focusData', []);         
        }
    },
    select : function(component, target, object, recursive, searchText, dontEmit) {
        let element = component.find(target.Id), helper = this, oldObject = component.get('v.'+target.Id);
        if(element) element.set('v.value', ((helper.valid(object)) ? object.Name :((recursive && !searchText) ? '' : searchText)));
        if(!recursive) component.set('v.productDescription', component.get('v.showDescription') && object && object.Description?object.Description:'');
        component.set('v.'+target.Id, object);
        if(!dontEmit) {
            if(!helper.valid(oldObject) || (helper.valid(oldObject) && (!helper.valid(object) || helper.valid(object) && oldObject.Id !== object.Id))) {
                switch(target.Name){
                    case 'Product':
                        component.set('v.productIsSolution', helper.valid(object) && (object.CH_Product_Type__c === 'NSN Solution' || object.CH_Product_Type__c === 'Complementary Item'));
                        helper.select(component, { Id: 'solution', Name: 'Solution'}, null, true);
                        helper.select(component, { Id: 'productVariant', Name: 'Product Variant'}, null, true);
                        helper.select(component, { Id: 'productRelease', Name: 'Product Release'}, null, true);
                        helper.select(component, { Id: 'productModule', Name: 'Product Module'}, null, true);
                        helper.select(component, { Id: 'swComponent', Name: 'SW Component'}, null, true);
                        helper.select(component, { Id: 'hwComponent', Name: 'HW Component'}, null, true);
                        break;
                    case 'Product Release':
                        helper.select(component, { Id: 'swRelease', Name: 'SW Release'}, null, true);
                        break;
                    case 'SW Component':
                        helper.select(component, { Id: 'swModule', Name: 'SW Module'}, null, true);
                        break;
                    case 'SW Release':
                        helper.select(component, { Id: 'swBuild', Name: 'SW Build'}, null, true);
                        break;
                }
            }
            this.emit(component, 'select', {target: target.Name, object : object});
        }
    },
    action : function(component, method, args, callback) {
        let action = component.get(method);
        if(args) action.setParams(args);
        action.setCallback(this,function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {
                callback(response.getReturnValue(), null);
            } else if (state === "INCOMPLETE") {
                callback(null, 'Incomplete');
            } else if (state === "ERROR") {
                var errors = response.getError();
                callback(null, errors && errors[0] && errors[0].message?("Error message: " + errors[0].message):"Unknown error");
            }
        });
        $A.enqueueAction(action);
    },
	incrementActionCounter: function(component) {
        component.getEvent("onEvent").setParams({
            message: 'incrementActionCounter'
        }).fire();
    },
    decrementActionCounter: function(component) {
        component.getEvent("onEvent").setParams({
            message: 'decrementActionCounter'
        }).fire();
    },
    emit: function(component, event, args) {
        component.getEvent("onEvent").setParams({
            message	: event,
            target	: args.target,
            object	: JSON.stringify(args.object)
        }).fire();
    },
    valid: function(object) {
        return object != null && object != '';
    }
})