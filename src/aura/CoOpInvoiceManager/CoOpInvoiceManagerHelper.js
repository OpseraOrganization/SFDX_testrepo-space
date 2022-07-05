({
	checkSuccess : function(component, event, helper, response) 
    {
        var success;
        component.set('v.loaded', true);
        if(typeof response.getReturnValue().errorMessage === 'undefined' || typeof response.getReturnValue().errorMessage == '')
        {
            console.log("Success message: " + response.getReturnValue().successMessage);
            helper.showSuccessToast(component, event, helper, response.getReturnValue().successMessage);
            success = true;
        }
        else
        {
            success = false;
            helper.showErrorToast(component, event, helper, response.getReturnValue().errorMessage);
            console.log("Apex error: " + response.getReturnValue().errorMessage);
        }
        return success;
	},
    
    getInvoicesToDelete : function(component, event, helper) 
    {
		var invoiceList = component.get("v.InvoiceWrapperList");
        var invoiceListToDelete = [];
        var invoiceLIListToDelete = [];
        for(var i = (Object.keys(invoiceList).length - 1); i >= 0; i--)
        {
            if(invoiceList[i].selected == true)//invoice selected for removal invoiceList[i].
            {
                invoiceListToDelete.push(invoiceList[i].Id);
                invoiceList.splice(i,1);
            }
            else if(typeof invoiceList[i].invoiceLIWrapperList != 'undefined')//check if invoice line items have been selected for removal
            {
                for(var j = (Object.keys(invoiceList[i].invoiceLIWrapperList).length - 1); j >= 0; j--)
                {
                    if(invoiceList[i].invoiceLIWrapperList[j].selected == true)//invoice selected for removal
                    {
						invoiceLIListToDelete.push(invoiceList[i].invoiceLIWrapperList[j].Id);
                        invoiceList[i].invoiceLIWrapperList.splice(j,1);
                    }
                }
            }
        }
        component.set("v.InvoiceWrapperList", invoiceList);
        console.log(invoiceListToDelete);
        console.log(invoiceLIListToDelete);
        return [invoiceListToDelete, invoiceLIListToDelete];
	},
    
    validateFields : function(component, event, helper) 
    {
        var validFields = true;
		var invoiceList = component.get("v.InvoiceWrapperList");
        for(var i = (Object.keys(invoiceList).length - 1); i >= 0; i--)
        {
            if(typeof invoiceList[i].description === 'undefined' || invoiceList[i].description.replace( /\s/g, '') == '' || typeof invoiceList[i].vendorName === 'undefined' || invoiceList[i].description.replace( /\s/g, '') == '' || typeof invoiceList[i].invoiceAmount === 'undefined' || invoiceList[i].invoiceAmount == '' || typeof invoiceList[i].invoiceNumber === 'undefined' || invoiceList[i].invoiceNumber.replace( /\s/g, '') == '') //invoice selected for removal invoiceList[i].
            {
                validFields = false;
                break;
            }
            else
            {
                if(typeof invoiceList[i].invoiceLIWrapperList != 'undefined')
                {
                    for(var j = (Object.keys(invoiceList[i].invoiceLIWrapperList).length - 1); j >= 0; j--)
                    {
                        if(typeof invoiceList[i].invoiceLIWrapperList[j].description != 'undefined' && invoiceList[i].invoiceLIWrapperList[j].description.replace( /\s/g, '') == '')//invoice selected for removal
                        {
                            validFields = false;
                            break;
                        }
                    }
                }
            }
        }
        return validFields;
	},
    
    createLineItem : function(component, event, helper, invoiceIndex)
    {
        var lineItem = {};
        var invoiceList = component.get("v.InvoiceWrapperList");
        lineItem['amount'] = 0;
        lineItem['description'] = ' ';
        lineItem['Id'];
        lineItem['invoiceId'] = invoiceList[invoiceIndex].Id;
        lineItem['selected'] = false;
		lineItem['visible'] = true;
        return lineItem
    },
    
    updateTotalAmount : function(component, event, helper)
    {
    	var invoiceList = component.get("v.InvoiceWrapperList");
        var claimAmount = component.get("v.claimReimbursableAmount");
        claimAmount = 0;
    	var sum;
        for(var i = (Object.keys(invoiceList).length - 1); i >= 0; i--)
        {
            sum = 0;
            if(typeof invoiceList[i].invoiceLIWrapperList != 'undefined')
            {
                for(var j = (Object.keys(invoiceList[i].invoiceLIWrapperList).length - 1); j >= 0; j--)
                {
                    if(typeof invoiceList[i].invoiceLIWrapperList[j].amount != 'undefined' && invoiceList[i].invoiceLIWrapperList[j].amount != '')
                    {
                    	sum = parseInt(sum) + parseInt(invoiceList[i].invoiceLIWrapperList[j].amount);
                    }
                }
            }
 			invoiceList[i].totalAmount = sum;
            claimAmount = parseInt(claimAmount) + parseInt(sum);
        }
        component.set("v.InvoiceWrapperList", invoiceList);	
        component.set("v.claimReimbursableAmount", claimAmount);	
	},
      
    showSuccessToast : function(component, event, helper, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Successs Message',
            message: message,
            duration:' 3000',
            key: 'info_alt',
            type: 'success',
            mode: 'sticky'
        });
        toastEvent.fire();
    },
    
    showErrorToast : function(component, event, helper, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error Message',
            message:message,
            duration:'5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    }
})