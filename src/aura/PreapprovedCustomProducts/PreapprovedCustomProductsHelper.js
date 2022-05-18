({
  doInit: function (component, event, helper) {
    //console.log("Init");
    //console.log("Prod conf id = ");
    //console.log(component.get("v.ProductConfigId"));
    var action = component.get("c.init");
    action.setParams({
      ProductConfigId: component.get("v.ProductConfigId"),
    });
    action.setCallback(this, function (response) {
      //component.find("Id_spinner").set("v.class" , 'slds-hide');
      var state = response.getState();
      if (state === "SUCCESS") {
        //console.log("Success");
        var storeResponse = response.getReturnValue();
        if (storeResponse.length == 0) {
          component.set("v.RecordDisplayMessage", "No Record Found");
        } else {
          component.set("v.RecordDisplayMessage", "");
          component.set("v.searchResult", storeResponse);
        }
        component.set("v.showSpinner", false);
      } else if (state === "ERROR") {
        //console.log("Error");
      }
    });
    $A.enqueueAction(action);
  },
  RedirectTocart: function (component, event, helper) {
    var vars = {};
    var parts = window.location.href.replace(
      /[?&]+([^=&]+)=([^&]*)/gi,
      function (m, key, value) {
        vars[key] = value;
      }
    );
    var vURL =
      "https://" +
      $A.get("$Label.c.CartURL") +
      "/apex/Pricing?configRequestId=" +
      vars["configRequestId"] +
      "&cartStatus=New&id=" +
      vars["id"] +
      "&flow=";
    window.location = vURL;
  },

  AddToCart: function (component, event, helper) {
    //console.log("Selected checkboxes = ");
    component.set("v.has_error", false);
    component.set("v.success", false);
    var list = [];
    var notChecked = true;
    // var checkContact = component.find("checkContact");
    // for(var i=0; i<checkContact.length; i++){
    //     if(checkContact[i].get("v.value"))
    //     notChecked= false;

    // }

    var elements = [];
    elements = elements.concat(component.find("checkContact"));
    if (elements.length > 0) {
      for (var i = 0; i < elements.length; i++) {
        //console.log(elements[i].get("v.value"));
        if (elements[i].get("v.value")) {
          notChecked = false;
          list.push(component.get("v.searchResult")[i]);
        }
      }
      //console.log('Any checked-->' + !notChecked);
    }

    if (notChecked) {
      //console.log("No Products were selected");
    } else {
      component.set("v.showSpinner", true);
      component.set("v.infoMessage", "");
      //console.log("Inside Else");
      //console.log("Calling upload method with list size - " + list.length);

      var action = component.get("c.upload");
      action.setParams({
        preApprovedList: list,
        configId: component.get("v.ProductConfigId"),
      });
      action.setCallback(this, function (response) {
        component.set("v.showSpinner", false);
        var state = response.getState();
        if (state === "SUCCESS") {
          //console.log("Success");
          var storeResponse = response.getReturnValue();
          //christie to add a message for  prod discount
          if (storeResponse.includes("Success")) {
            component.set("v.success", true);
            var msg = storeResponse.split("~")[1];
            if (msg && msg != "") {
              component.set("v.infoMessage", msg);
            }
          }
        } else if (state === "INCOMPLETE") {
          component.set("v.has_error", true);
          component.set(
            "v.error",
            "The Import process did not complete successfully. Please contact the Administrator."
          );
        } else if (state === "ERROR") {
          var errors = response.getError();
          if (errors) {
            if (errors[0] && errors[0].message) {
              // log the error passed in to AuraHandledException
              component.set("v.has_error", true);
              component.set("v.error", errors[0].message);
            }
          } else {
            component.set("v.has_error", true);
            component.set(
              "v.error",
              "The Import process did not complete successfully. Please contact the Administrator."
            );
          }
        }
      });
    }

    $A.enqueueAction(action);
  },
  SearchHelper: function (component, event) {
    component.set("v.showSpinner", true);
    var action = component.get("c.fetchProduct");
    action.setParams({
      searchKeyWord: component.get("v.searchKeyword"),
      ProductConfigId: component.get("v.ProductConfigId"),
    });
    action.setCallback(this, function (response) {
      component.set("v.showSpinner", false);
      var state = response.getState();

      if (state === "SUCCESS") {
        //console.log("Inside Search Success");
        //console.log(storeResponse);
        var storeResponse = response.getReturnValue();

        if (storeResponse.length == 0) {
          component.set("v.RecordDisplayMessage", "No Record Found");
        } else {
          component.set("v.RecordDisplayMessage", "");
        }
        component.set("v.searchResult", storeResponse);
      } else if (state === "INCOMPLETE") {
        alert("Response is Incompleted");
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            alert("Error message: " + errors[0].message);
          }
        } else {
          alert("Unknown error");
        }
      }
    });
    $A.enqueueAction(action);
  },
  CheckboxClick: function (component, event) {
    //console.log("Inside Click");
    var elements = [];
    //console.log('checked-->' + event.getSource().get('v.value'));
    if (event.getSource().get("v.value")) {
      component.set("v.button", false);
    } else {
      var notChecked = true;
      elements = elements.concat(component.find("checkContact"));
      if (elements.length > 0) {
        for (var i = 0; i < elements.length; i++) {
          //console.log(elements[i].get("v.value"));
          if (elements[i].get("v.value")) {
            notChecked = false;
            break;
          }
        }
        //console.log('Any checked-->' + !notChecked);
        component.set("v.button", notChecked);
      }
    }
  },
});