({
    initialiseData: function (cmp) {
        // create the breadcrumbs
        var userId = $A.get('$SObjectType.CurrentUser.Id');
        if (userId) {
            // this shows the upgrade banner and determines external link state
            cmp.set('v.isAuth', true);
        }
        // create the
    },
    setBreadcrumbs: function (cmp) {
        var product = cmp.get('v.product');
        var fullURL = '';
        var pathNameParts = window.location.pathname.split('/');
        pathNameParts.forEach(function (aPart) {
            if (aPart) {
                fullURL += '/' + aPart;
            }
        });
        var communityURLName = cmp.get('v.currentCommunityURL');
        var urlString = window.location.href;
        var current = "";
        if(urlString.includes(communityURLName)){
            current+='/'+communityURLName;
        }
        current+='/s/product-list-view';

        //href: '/customers/s/product-list-view'
        var myBreadcrumbs = [
            { label: 'PRODUCTS', name: 'product-list-view', title: 'product-list-view', href: current},
            { label: product.Name, name: 'product-name', title: product.Name, href: fullURL }
        ];
        cmp.set('v.myBreadcrumbs', myBreadcrumbs);
    },
    setRecord: function (cmp) {
        // Need to check the record id against the users list of entitled products
        // If it is present need to check whether it is a favourite or not and then display
        // add or remove button accordingly
        // var action = cmp.get('c.getRecord');
        var action = cmp.get('c.getRecordandCommunityURL');
        action.setStorable();
        action.setParams({
            prId: cmp.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                var product = result[0];
                cmp.set('v.product', product);
                cmp.set('v.currentCommunityURL',result[1]);
                this.setBreadcrumbs(cmp);
                this.setProductAccess(cmp);
            }
        });
        $A.enqueueAction(action);
    },
    setProductAccess: function (cmp) {
        var action = cmp.get('c.getProductAccess2');
        action.setStorable();
        action.setParams({
            prId: cmp.get('v.recordId')
        });
        action.setCallback(this, function (resp) {
            var productResources = resp.getReturnValue();
            productResources.forEach(function (productResourceGroup) {
                var productResourceGroupAccessList = productResourceGroup.productAccessList;
                productResourceGroupAccessList.forEach(function (productResource) {
                    var targetUrl = productResource.productAccess.NCP_Link__c;
                    var suffix = '';
                    var docType = '';
                    if (!productResource.productAccess.NCP_Standard_Service_URL__c) {
                        var parentProduct = cmp.get('v.product');
                        docType = productResource.productAccess.NCP_docType__c;
                       /* if (parentProduct.NCP_ALTERNATE_CODE2__c !== undefined) {
                            suffix = parentProduct.NCP_ALTERNATE_CODE2__c;
                        } else {
                            suffix = parentProduct.NCP_Nokia_Product_Id__c;
                        }*/
                        if(productResource.productAccess.NCP_Type__c == 'Discovery Center' && parentProduct.NCP_Nokia_Product_Id__c !== undefined){
                            suffix = parentProduct.NCP_Nokia_Product_Id__c;
                        }
                        else if(productResource.productAccess.NCP_Type__c == 'Product Alerts' && parentProduct.NCP_ALTERNATE_CODE2__c !== undefined){
                            suffix = '&Product=' + parentProduct.NCP_ALTERNATE_CODE2__c;
                        }
                        else{
                            suffix = parentProduct.NCP_ALTERNATE_CODE2__c;
                        }
                    }
                    targetUrl += suffix;
                    targetUrl += docType || '';
                    productResource.targetUrl = targetUrl;
                });
            });
            cmp.set('v.productAccessWrapper', productResources);
        });
        $A.enqueueAction(action);
    },
    getProductStatus: function (cmp) {
        var action = cmp.get('c.checkProductStatus');
        action.setParams({
            prId: cmp.get('v.recordId')
        });
        action.setCallback(this, function (resp) {
            var productStatus = resp.getReturnValue();
            cmp.set('v.isEntitledProduct', productStatus.entitledProduct);
            cmp.set('v.isFavourite', productStatus.favourite);
        });
        $A.enqueueAction(action);
    },
    makeFavourite: function (cmp, isFavourite) {
        function getSuccessMessage() {
            if (isFavourite) {
                return 'Product added to favorites';
            } else {
                return 'Product removed from favorites';
            }
        }

        var action = cmp.get('c.changeProductStatus');
        action.setParams({
            Id: cmp.get('v.recordId'),
            isFavourite: isFavourite
        });
        action.setCallback(this, function (response) {
            var toastEvent = $A.get('e.force:showToast');
            var state = response.getState();
            if (state === 'SUCCESS') {
                // show a toast here
                toastEvent.setParams({
                    mode: 'pester',
                    title: 'Favorite status changed',
                    type: 'success',
                    message: getSuccessMessage()
                });
                this.getProductStatus(cmp);
            } else {
                toastEvent.setParams({
                    mode: 'sticky',
                    title: 'Problem changing favorite status',
                    type: 'error',
                    message: response.getError()[0].message
                });
            }
            toastEvent.fire();
        });
        $A.enqueueAction(action);
    }
});