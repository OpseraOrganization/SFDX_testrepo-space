({
  doInit: function (component, event, helper) {
      helper.getQuoteType(component, event, helper);
      helper.callDoInt(component, event, helper);
      
      //helper.getSubPortfolioType(component, event, helper);//FN-added helper method
  },

  recordLoaded: function (component, event, helper) {
      component.set("v.showSpinner", false);
  },

  LIrecordLoaded: function (component, event, helper) {
      component.set("v.showSpinner", false);
  },

  handleSubmit: function (component, event, helper) {
      component.set("v.has_error", false);
      component.set("v.showSpinner", true);
      if(component.get("v.addnewproduct")){
          
          var action = component.get("c.prodAvailabilityCheck");
          var prodCode = (component.find("prodCode").get("v.value")).trim();
          action.setParams({
              'prodCodes': new Array(prodCode),
              'productConfigId': component.get("v.strConfigId")
          });
          action.setCallback(this, function (response) {
              var state = response.getState();
              //console.log('handleSubmit-->' + state);
              if (state === "SUCCESS") {
                  
                  var storeResponse = response.getReturnValue();
                  var rsp = storeResponse ? storeResponse[prodCode] : rsp;
                  //console.log('handleSubmit-->' + rsp);
                  if (rsp) {
                      component.set("v.has_error", true);
                      component.set("v.showSpinner", false);
                      if(rsp == 'Defaultly Available') {
                        component.set("v.errors", 'Error : A custom product cannot be created for Product Code: ' + prodCode + ', as the product is auto included in the cart.');
                      } else {
                          component.set("v.errors", 'Error : A custom product cannot be created for Product Code: ' + prodCode + ', as the product is available for selection ' + (rsp == 'Available in Catalog' ?  'in the Catalog. Go to "Add more Products" and select the Product from the Catalog.' : 'as a Pre-Approved Custom Product.'));
                      }
                  } else {
                      helper.getLIValues(component, event, helper);//FN-Added
                      //helper.setLIValues(component, event, helper);//FN-Commented
                  }
              }
          });
          $A.enqueueAction(action);
      }else{
         
          helper.getLIValues(component, event, helper);//FN-Added
          //helper.setLIValues(component, event, helper);//FN-Commented
      }
      //console.log("helper return");
  },

  handleSuccess: function (component, event, helper) {
      //console.log("handle suceess");

      var cmpEvent = component.getEvent("ShowModalevt");
      component.set("v.showSpinner", false);
      component.set("v.showModal", false);

      var cmpEvent = component.getEvent("ShowModalevt");
      cmpEvent.setParams({ "ShowMessage": true, "ShowParentModal": true });
      cmpEvent.fire();

      //helper.createMaint(component, event, helper);


  },

  cancel: function (component, event, helper) {
      //alert(JSON.stringify('Click Event11'));
      //window.location.reload();
      var cmpEvent = component.getEvent("ShowModalevt");
      component.set("v.showSpinner", false);
      component.set("v.showModal", false);

      var cmpEvent = component.getEvent("ShowModalevt");
      cmpEvent.setParams({ "ShowMessage": true, "ShowParentModal": true });
      cmpEvent.fire();
      //location.reload();
  },

  onCheck: function (component, event) {
      var checkCmp = component.find("NFM").get("v.value");


      if (checkCmp == 2)
          component.set("v.isNetwork", true);
      else
          component.set("v.isNetwork", false);


  }
})