({
    init: function (component, event, helper) {
        
        //FN_START
        var vars = {};
        window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function (m, key, value) {
            vars[key] = value;
        });
        var quoteId = vars["retId"];
        //FN_END

        var action = component.get("c.getDocumentId");
        action.setParams({quoteId: quoteId});//FN-added params
        action.setCallback(this, function (response) {
            component.set("v.showSpinner", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log("From server: " + response.getReturnValue());
                component.set("v.templateId", "/servlet/servlet.FileDownload?file=" + response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                component.set("v.has_error", true);
                component.set("v.error", "There was an error while initializing this application. Please try again.");
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    component.set("v.has_error", true);
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " + errors[0].message);
                        component.set("v.error", "There was an error while initializing this application. Please contact the Administrator.");
                    }
                } else {
                    //console.log("Unknown error");
                    component.set("v.error", "There was an error while initializing this application. Please contact the Administrator.");
                }
            }
        });
        $A.enqueueAction(action);
        
        //FN_START
        var action2 = component.get("c.getSubPortfolio");
        action2.setParams({quoteId: quoteId});
        action2.setCallback(this, function (response) {
            component.set("v.showSpinner", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log("From server: " + response.getReturnValue());
                component.set("v.subPortfolio", response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                component.set("v.has_error", true);
                component.set("v.error", "There was an error while initializing this application. Please try again.");
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    component.set("v.has_error", true);
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " + errors[0].message);
                        component.set("v.error", "There was an error while initializing this application. Please contact the Administrator.");
                    }
                } else {
                    //console.log("Unknown error");
                    component.set("v.error", "There was an error while initializing this application. Please contact the Administrator.");
                }
            }
        });
        $A.enqueueAction(action2); 
        //FN_END
    },

    handleFilesChange: function (component, event, helper) {

        var uploadFile = event.getSource().get("v.files");
        var self = this;
        var file = uploadFile[0]; // getting the first file, loop for multiple files
        var filename = file.name;
        component.set("v.csvAsString", filename);
        var reader = new FileReader();
        reader.onload = $A.getCallback(function () {
            var dataURL = reader.result;
            var base64 = 'base64,';
            var dataStart = dataURL.indexOf(base64) + base64.length;
            dataURL = dataURL.substring(dataStart);
            component.set("v.csvFileBody", dataURL);

        });
        reader.readAsDataURL(file);



    },

    upload: function (component, event, helper) {

        component.set("v.showSpinner2", true);
        var action = component.get("c.init");
        component.set("v.has_error2", false);
        component.set("v.success", false);
        component.set("v.has_error", false);
        action.setParams({
            filename: component.get("v.csvAsString"),
            filebody: component.get("v.csvFileBody"),
            configId: component.get("v.configId")
        });

        action.setCallback(this, function (response) {
            component.set("v.showSpinner2", false);
            var state = response.getState();
            //console.log("From server: " + response.getReturnValue());
            if (state === "SUCCESS") {
                //console.log("From server: " + response.getReturnValue());
                if (response.getReturnValue().includes("Success~")) {
                    var rspStr = (response.getReturnValue().split("~")[1]).trim();
                    if (rspStr && rspStr != "" && rspStr != "false") {
                        if (rspStr === "true") {
                            component.set("v.has_error2", true);
                        } else {
                            component.set("v.has_error", true);
                            component.set("v.error", rspStr);
                        }
                    }
                    else {
                        component.set("v.success", true);
                    }
                }

                else if (response.getReturnValue().includes("Error")) {
                    component.set("v.has_error", true);
                    // component.set("v.error","The Cell "+response.getReturnValue().split(":")[1]+" in the uploaded csv file is empty!");
                    component.set("v.error", response.getReturnValue().split("~")[1]);
                    //console.log(response.getReturnValue().split("~")[1]);
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
                component.set("v.has_error", true);
                component.set("v.error", "The Import process did not complete successfully. Please try again.");
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    component.set("v.has_error", true);
                    if (errors[0] && errors[0].message) {
                        // log the error passed in to AuraHandledException
                        //console.log("Error message: " + errors[0].message);
                        component.set("v.error", "The Import process did not complete successfully. Please contact the Administrator.");
                    }
                } else {
                    //console.log("Unknown error");
                    component.set("v.error", "The Import process did not complete successfully. Please contact the Administrator.");
                }
            }
        });

        $A.enqueueAction(action);


    },

    redirectToCart: function (component, event, helper) {

        var vars = {};
        var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function (m, key, value) {
            vars[key] = value;
        });

        var vURL = "https://" + $A.get("$Label.c.CartURL") + "/apex/Pricing?configRequestId=" + vars["configRequestId"] + "&cartStatus=New&id=" + vars["id"] + "&flow=";
        window.location = vURL;



    }
})