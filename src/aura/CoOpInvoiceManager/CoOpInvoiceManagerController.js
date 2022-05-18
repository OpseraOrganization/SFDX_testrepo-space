({
    init : function(component, event, helper)
    {   
        var getListCall = component.get("c.getClaimInvoices");
        component.set("v.coopClaimId", component.get("v.recordId"));
        getListCall.setParams(
            {
                "coopClaimId": component.get("v.coopClaimId")
            }); 
        getListCall.setCallback(this, function(response) 
                                {	
                                    if(helper.checkSuccess(component, event, helper, response))
                                    {
                                        component.set("v.InvoiceWrapperList", response.getReturnValue().invoiceWrapperList);
                                        component.set("v.writeAccess", response.getReturnValue().writeAccess);
                                        component.set("v.hideDeleteButton", true);
                                        component.set("v.hideSaveButton", true);
                                        helper.updateTotalAmount(component, event, helper);
                                        console.log(component.get("v.InvoiceWrapperList"));
                                    }
                                });
        component.set('v.loaded', false);
        $A.enqueueAction(getListCall);
    },
    
    updateTable : function(component, event, helper)
    {
        var updateTableCall = component.get("c.updateClaimInvoices");
        var wrapper = {};
        if(helper.validateFields(component, event, helper))
        {
            wrapper = component.get("v.InvoiceWrapperList");
            updateTableCall.setParams(
                {
                    "coopClaimId": component.get("v.coopClaimId"),
                    "wrapperList": wrapper
                }); 
            updateTableCall.setCallback(this, function(response) 
                                        {
                                            if(helper.checkSuccess(component, event, helper, response))
                                            {
                                                component.set("v.InvoiceWrapperList", {});
                                                component.set("v.hideSaveButton", true);
                                                component.set("v.InvoiceWrapperList", response.getReturnValue().invoiceWrapperList);
                                            }
                                        }); 
            component.set('v.loaded', false);
            $A.enqueueAction(updateTableCall);
        }
        else
        {
            helper.showErrorToast(component, event, helper, 'Please make sure that all line items and invoices have all fields filled.');
        }
    },    
    
    createInvoice : function(component, event, helper)
    {
        var createInvoiceCall = component.get("c.createClaimInvoice");
        createInvoiceCall.setParams(
            {
                "coopClaimId": component.get("v.coopClaimId")
            }); 
        createInvoiceCall.setCallback(this, function(response) //Add created value to the component list
                                      {
                                          if(helper.checkSuccess(component, event, helper, response))
                                          {
                                              
                                              var invoiceWrapperList = component.get("v.InvoiceWrapperList");
                                              console.log(response.getReturnValue().invoiceWrapperList[0]);
                                              invoiceWrapperList.push(response.getReturnValue().invoiceWrapperList[0]);
                                              component.set("v.InvoiceWrapperList", invoiceWrapperList);
                                          }
                                      }); 
        component.set('v.loaded', false);
        $A.enqueueAction(createInvoiceCall);
    },
    
    deleteRecords : function(component, event, helper)
    {
        console.log('deleterecord');
        var lists = helper.getInvoicesToDelete(component, event, helper);
        var invoiceIdList = lists[0];
        var invoiceLIIdList = lists[1];
        if(invoiceIdList.length > 0 || invoiceLIIdList.length > 0)
        {
            var deleteInvoiceCall = component.get("c.deleteRecordsApex");
            deleteInvoiceCall.setParams(
                {
                    "invoiceIdList": invoiceIdList,
                    "invoiceLIIdList": invoiceLIIdList,
                    "coopClaimId": component.get("v.coopClaimId")                          
                });
            deleteInvoiceCall.setCallback(this, function(response) //Add created value to the component list
                                          {
                                              if(helper.checkSuccess(component, event, helper, response))
                                              {
                                               	  component.set("v.hideDeleteButton", true);
                                                  helper.updateTotalAmount(component, event, helper);
                                              }
                                          }); 
            component.set('v.loaded', false);
            $A.enqueueAction(deleteInvoiceCall);
        }
    },
    
    handleInvoiceSelection : function(component,event,helper)
    {
        var invoiceList = component.get("v.InvoiceWrapperList");
        var anySelectedElem = false;
        for(var i = 0; i < Object.keys(invoiceList).length; i++)
        {
            if(invoiceList[i].selected === true)
            {
                anySelectedElem = true;
                break;
            }
            if(typeof invoiceList[i].invoiceLIWrapperList != 'undefined')
            {
                for(var j = 0; j < Object.keys(invoiceList[i].invoiceLIWrapperList).length; j++)
                {
                    if(invoiceList[i].invoiceLIWrapperList[j].selected)
                    {
                        anySelectedElem = true;
                        break;
                    }
                }
            }
        }
        component.set("v.hideDeleteButton", !anySelectedElem);
    },
    
    handleAmountChange : function(component,event,helper)
    {
        helper.updateTotalAmount(component, event, helper);
        component.set("v.hideSaveButton", false);
    },
    
    handleInputChange : function(component,event,helper)
    {
        component.set("v.hideSaveButton", false);
    },
    
    addInvoiceLI : function(component,event,helper)
    {
        //Create new entry on line item list:
        component.set('v.loaded', false);
        var invIndex =  event.getSource().get('v.value');
        var newLineItem = {};
        var newLineItem = helper.createLineItem(component, event, helper, invIndex);
        var invoiceWrapperList = component.get("v.InvoiceWrapperList");
        if(typeof invoiceWrapperList[invIndex].invoiceLIWrapperList === 'undefined'){
            invoiceWrapperList[invIndex].invoiceLIWrapperList = [];
        }
        invoiceWrapperList[invIndex].invoiceLIWrapperList.push(newLineItem);
        component.set("v.InvoiceWrapperList",invoiceWrapperList);
        component.set("v.hideSaveButton", false);
        component.set('v.loaded', true);
    }
})