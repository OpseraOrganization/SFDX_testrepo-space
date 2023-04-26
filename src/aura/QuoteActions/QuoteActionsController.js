({
    doInit: function (component, event, helper) {
      component.set("v.IsSpinner", true);
      var qId = component.get("v.recordId");
      var hasAggregationAction = component.get("c.getAggregation");
      hasAggregationAction.setParams({ proposalId: qId });
      hasAggregationAction.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
              var rsp = response.getReturnValue();
              if (rsp && rsp.includes("|") && rsp.split("|").length > 1) {
                  component.set("v.configId", rsp.split("|")[0]);
                  component.set("v.hasAggregation", (rsp.split("|")[1]).localeCompare('true') >= 0);
              }
        }
        component.set("v.IsSpinner", false);    
      });
      $A.enqueueAction(hasAggregationAction);
  
      var action = component.get("c.getProposal");
      action.setParams({
        proposalId: qId,
      });
      action.setCallback(this, function (response) {
        var state = response.getState();
        if (state === "SUCCESS") {
			 var rsp = response.getReturnValue();
           //surinder turbo
           component.set("v.showTurbo",(rsp.Turbo_Pricing_Enable__c || rsp.Is_Turbo_Pricing__c));
                 
           //--surinder changes end-->
          component.set("v.proposal", response.getReturnValue());
          //console.log('Apoorv Jain' + component.get("v.proposal.NokiaCPQ_Environment_Access_Type__c"));
          helper.ValidateCqorderButtonhelper(component, event, helper);
        }
      });
      $A.enqueueAction(action);
       //surinder turbo 2
       var action = component.get("c.isUserhasTurboPermission");
       action.setParams({            
      });
      action.setCallback(this, function (response) {
          var state = response.getState();
          if (state === "SUCCESS") {                
              component.set("v.validForTurboFeature",response.getReturnValue());             
                          
          }
      });
      $A.enqueueAction(action);
      //surinder turbo 2 end
  
      var newAction = component.get("c.returnProfileName");
      newAction.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          component.set("v.profileName", response.getReturnValue());
        }
      });
      $A.enqueueAction(newAction);
  
      var newAction1 = component.get("c.returnAccessLoaFile");
      newAction1.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          component.set("v.loaAccess", response.getReturnValue());
        }
      });
      $A.enqueueAction(newAction1);
  
      var newAction2 = component.get("c.isPricingManager");
      newAction2.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          component.set("v.isPricingManager", response.getReturnValue());
          //console.log('isPricingManager>>>' + response.getReturnValue());
        }
      });
  
      $A.enqueueAction(newAction2);
  
      //Added by Imran Wipro
      var newAction3 = component.get("c.QueryConfiguration");
      newAction3.setParams({ recordIdVar: component.get("v.recordId") });
      newAction3.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          component.set("v.QuoteConfiguration", response.getReturnValue());
        }
      });
  
      $A.enqueueAction(newAction3);
      //Added by Imran Wipro
      var ad = component.get("c.reCallOnLoad");
      $A.enqueueAction(ad);
      var newAction4 = component.get("c.QueryQuoteRecord");
      newAction4.setParams({ recordIdVar: component.get("v.recordId") });
      newAction4.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          component.set("v.OldQuote", response.getReturnValue());
          //console.log('OldQuote>>>' + response.getReturnValue());
        }
      });
  
      $A.enqueueAction(newAction4);
  
      var newAction5 = component.get("c.QueryUserQuoteAccess");
      newAction5.setParams({ recordIdVar: component.get("v.recordId") });
      newAction5.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          component.set("v.recEditaccess", response.getReturnValue());
        }
      });
  
      $A.enqueueAction(newAction5);
    },
  
    reCallOnLoad: function (component, event, helper) {
      window.setTimeout(
        $A.getCallback(function () {
          var qIds = component.get("v.recordId");
          var actionRecall = component.get("c.getProposal");
          actionRecall.setParams({
            proposalId: qIds,
          });
          actionRecall.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
              component.set("v.proposal", response.getReturnValue());
            }
          });
          $A.enqueueAction(actionRecall);
        }),
        10000
      );
    },
    makePrimary: function (component, event, helper) {
      var action = component.get("c.makePrimaryMethod");
      action.setParams({ recordIdVar: component.get("v.recordId") });
      action.setCallback(this, function (response) {
        if (response.getState() == "SUCCESS") {
          var link = response.getReturnValue();
          window.open(link, "_self");
        }
        $A.get("e.force:refreshView").fire();
      });
  
      $A.enqueueAction(action);
    },
    bomExport: function (component, event, helper) {
      var action = component.get("c.bomExportMethod");
      action.setParams({ recordIdVar: component.get("v.recordId") });
      action.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          var link = response.getReturnValue();
          window.open(link, "_self");
        }
      });
  
      $A.enqueueAction(action);
    },
    quoteExport: function (component, event, helper) {
      var action = component.get("c.quoteExportMethod");
      action.setParams({ recordIdVar: component.get("v.recordId") });
      action.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          var link = response.getReturnValue();
          window.open(link, "_self");
        }
      });
  
      $A.enqueueAction(action);
    },
    //RG Start:Renamed for Req-6611
    baiscquoteExport: function (component, event, helper) {
      var action = component.get("c.basicquoteExportMethod");
      action.setParams({ recordIdVar: component.get("v.recordId") });
      action.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          var link = response.getReturnValue();
          window.open(link, "_self");
        }
      });
  
      $A.enqueueAction(action);
    },
    //RG End:Renamed for Req-6611
    //RG start for Approval Process
    submitforApproval: function (component, event, helper) {
      var action = component.get("c.submitForApprovalMethod");
      action.setParams({ recordIdVar: component.get("v.recordId") });
      action.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          component.set("v.isSubmitApproval", false);
          var link = response.getReturnValue();
          window.open(link, "_self");
        }
        $A.get("e.force:refreshView").fire();
      });
      $A.enqueueAction(action);
    },
    recallforApproval: function (component, event, helper) {
      var filePath;
      var recId = component.get("v.recordId");
      filePath = "/apex/Apttus_Approval__PreviewSubmitApprovals?id=" + recId;
      var url = location.href;
      var baseURL = url.substring(0, url.indexOf("/", 14));
      //console.log('>>>' + baseURL + filePath);
      var link = baseURL + filePath;
      window.open(link, "_self");
    },
    //Generate proposal quote action
    Generate: function (component, event, helper) {
      var filePath;
      var recId = component.get("v.recordId");
      filePath =
        "/one/one.app#/alohaRedirect/apex/Apttus_Proposal__ProposalGenerate?id=" +
        recId;
      var url = location.href;
      var baseURL = url.substring(0, url.indexOf("/", 14));
      //console.log('>>>' + baseURL + filePath);
      var link = baseURL + filePath;
      window.open(link, "_self");
    },
    //RG end for Approval Process
    //Modified by Christie JJ for ITCCPQ - 677
    acceptProposal: function (component, event, helper) {
      var action = component.get("c.acceptMethod");
      action.setParams({ recordIdVar: component.get("v.recordId") });
      action.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          var link = response.getReturnValue();
          var url = link.split("|")[0];
          var type = link.split("|")[1];
          var is_rg_nam = link.split("|")[2];
  
          if (
            type != "Indirect CPQ" ||
            (type == "Indirect CPQ" && is_rg_nam != "True")
          ) {
            window.open(url, "_self");
            $A.get("e.force:refreshView").fire();
          } else if (type == "Indirect CPQ" && is_rg_nam == "True") {
            helper.sendAddQuoteMessageToEAI(component, event, helper);
            $A.get("e.force:refreshView").fire();
          }
        }
        //$A.get('e.force:refreshView').fire();
      });
  
      $A.enqueueAction(action);
    },
    configureProductsDirect: function (component, event, helper) {
      if (component.get("v.hasAggregation")) {
        component.set("v.showConfirmDialog", true);
        component.set("v.action", "c.configureMethodDirect");
      } else {
        var action = component.get("c.configureMethodDirect");
        action.setParams({ recordIdVar: component.get("v.recordId") });
        action.setCallback(this, function (response) {
          if (response.getState() === "SUCCESS") {
            var link = response.getReturnValue();
            window.open(link, "_self");
          }
        });
  
        $A.enqueueAction(action);
      }
    },
    configureProductsMNDirect: function (component, event, helper) {
      var action = component.get("c.configureMethodMNDirect");
      action.setParams({ recordIdVar: component.get("v.recordId") });
      action.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          var filePath;
          var recId = component.get("v.recordId");
          var isPricingManager = component.get("v.isPricingManager");
          if (isPricingManager === true) {
            filePath =
              "/apex/Apttus_QPConfig__ProposalConfiguration?id=" +
              recId +
              "&flow=GridViewCartMNDirectPricing&cntrNbr_1=" +
              component.get("v.proposal.Direct_Price_List_Number__c");
          } else {
            filePath =
              "/apex/Apttus_QPConfig__ProposalConfiguration?id=" +
              recId +
              "&flow=GridViewCartMNDirect&cntrNbr_1=" +
              component.get("v.proposal.Direct_Price_List_Number__c");
          }
  
          var url = location.href; // entire url including querystring - also: window.location.href;
          var baseURL = url.substring(0, url.indexOf("/", 14));
          //console.log('>>>' + baseURL + filePath);
          var link = baseURL + filePath;
          window.open(link, "_self");
        }
      });
  
      $A.enqueueAction(action);
    },
    configureProducts: function (component, event, helper) {
      var action = component.get("c.configureMethod");
      action.setParams({ recordIdVar: component.get("v.recordId") });
      action.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          var link = response.getReturnValue();
          window.open(link, "_self");
        }
      });
  
      $A.enqueueAction(action);
    },
    //Added by Imran Wipro for Turbo Pricing
    configureMethodTurbo: function (component, event, helper) {
      //console.log('in turbo new');
      if (component.get("v.hasAggregation")) {
        component.set("v.showConfirmDialog", true);
        component.set("v.action", "c.configureTurboserver");
      } else {
        var action = component.get("c.configureTurboserver");
        action.setParams({ recordIdVar: component.get("v.recordId") });
  
        action.setCallback(this, function (response) {
          if (response.getState() === "SUCCESS") {
            var link = response.getReturnValue();
            window.open(link, "_self");
          }
        });
        $A.enqueueAction(action);
      }
    },
    viewProducts: function (component, event, helper) {
      var action = component.get("c.viewProductsMethod");
      action.setParams({ recordIdVar: component.get("v.recordId") });
      action.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          var link = response.getReturnValue();
          window.open(link, "_self");
        }
      });
  
      $A.enqueueAction(action);
    },
    viewProductsDirect: function (component, event, helper) {
      var action = component.get("c.viewProductsDirectMethod");
      action.setParams({ recordIdVar: component.get("v.recordId") });
      action.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          var link = response.getReturnValue();
          window.open(link, "_self");
        }
      });
  
      $A.enqueueAction(action);
    },
    viewProductsMNDirect: function (component, event, helper) {
      var action = component.get("c.viewProductsMNDirectMethod");
      action.setParams({ recordIdVar: component.get("v.recordId") });
      action.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          var recId = component.get("v.recordId");
          var filePath =
            "/apex/Apttus_QPConfig__ProposalConfiguration?id=" +
            recId +
            "&flow=GridViewCartMNDirect&cntrNbr_1=" +
            component.get("v.proposal.Direct_Price_List_Number__c") +
            "&mode=readOnly";
          var url = location.href; // entire url including querystring - also: window.location.href;
          var baseURL = url.substring(0, url.indexOf("/", 14));
          //console.log('>>>' + baseURL + filePath);
          var link = baseURL + filePath;
          window.open(link, "_self");
        }
      });
  
      $A.enqueueAction(action);
    },
  
    collaboration: function (component, event, helper) {
      var action = component.get("c.configureCollaboration");
      action.setParams({ recordIdVar: component.get("v.recordId") });
      action.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          var link = response.getReturnValue();
          window.open(link, "_self");
        }
      });
  
      $A.enqueueAction(action);
    },
    boqExport: function (component, event, helper) {
      var generateSiteIdAction = component.get("c.generateSiteId");
      generateSiteIdAction.setParams({
        proposalId: component.get("v.recordId"),
      });
      generateSiteIdAction.setCallback(this, function (response) {
        //console.log('>>Output from apex class:::::' + response.getReturnValue());
        if (response.getState() === "SUCCESS") {
          var messageResult = response.getReturnValue();
          //console.log('messageResult1' + messageResult);
          if (messageResult === "SUCCESS") {
            var toastTitle = "Success";
            var toastType = "Success";
            var toastMessage = "Line Item Updated successfully !";
            var action = component.get("c.boqExportreturn");
            action.setParams({ recordIdVar: component.get("v.recordId") });
            action.setCallback(this, function (response) {
              if (response.getState() === "SUCCESS") {
                var link = response.getReturnValue();
                window.open(link, "_self");
              }
            });
            $A.enqueueAction(action);
          } else {
            // toast message
            //console.log('>>messageResult:::::' + messageResult);
            var toastTitle = "Error";
            var toastType = "Error";
            helper.toastMessage(
              component,
              event,
              helper,
              toastTitle,
              messageResult,
              toastType
            );
          }
        }
      });
      $A.enqueueAction(generateSiteIdAction);
    },
    boqClpExport: function (component, event, helper) {
      var generateSiteIdAction = component.get("c.generateSiteId");
      generateSiteIdAction.setParams({
        proposalId: component.get("v.recordId"),
      });
      generateSiteIdAction.setCallback(this, function (response) {
        //console.log('>>Output from apex class:::::' + response.getReturnValue());
        if (response.getState() === "SUCCESS") {
          var messageResult = response.getReturnValue();
          //console.log('messageResult1' + messageResult);
          if (messageResult === "SUCCESS") {
            var toastTitle = "Success";
            var toastType = "Success";
            var toastMessage = "Line Item Updated successfully !";
            var action = component.get("c.boqClpExportReturn");
            action.setParams({ recordIdVar: component.get("v.recordId") });
            action.setCallback(this, function (response) {
              if (response.getState() === "SUCCESS") {
                var link = response.getReturnValue();
                window.open(link, "_self");
              }
            });
  
            $A.enqueueAction(action);
          } else {
            // toast message
            //console.log('>>messageResult:::::' + messageResult);
            var toastTitle = "Error";
            var toastType = "Error";
            helper.toastMessage(
              component,
              event,
              helper,
              toastTitle,
              messageResult,
              toastType
            );
          }
        }
      });
      $A.enqueueAction(generateSiteIdAction);
    },
    prmExport: function (component, event, helper) {
      var action = component.get("c.prmExportFunction");
      action.setParams({ recordIdVar: component.get("v.recordId") });
      action.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          var link = response.getReturnValue();
          window.open(link, "_self");
        }
      });
  
      $A.enqueueAction(action);
    },
    loaFileExport: function (component, event, helper) {
      var action = component.get("c.loaFileExportFunction");
      action.setParams({ recordIdVar: component.get("v.recordId") });
      action.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          var link = response.getReturnValue();
          window.open(link, "_self");
        }
      });
  
      $A.enqueueAction(action);
    },
    // CSP Export
    startOrderExportForCSP: function (component, event, helper) {
      var generateSiteIdAction = component.get("c.generateSiteId");
      generateSiteIdAction.setParams({
        proposalId: component.get("v.recordId"),
      });
      generateSiteIdAction.setCallback(this, function (response) {
        //console.log('>>Output from apex class:::::' + response.getReturnValue());
        if (response.getState() === "SUCCESS") {
          var messageResult = response.getReturnValue();
          //console.log('messageResult1' + messageResult);
          if (messageResult === "SUCCESS") {
            var toastTitle = "Success";
            var toastType = "Success";
            var toastMessage = "Line Item Updated successfully !";
            helper.fireEventCPQ_Evt_ToCallStatusCheck(
              component,
              event,
              helper,
              "CSP Export"
            );
          } else {
            // toast message
            //console.log('>>messageResult:::::' + messageResult);
            var toastTitle = "Error";
            var toastType = "Error";
            helper.toastMessage(
              component,
              event,
              helper,
              toastTitle,
              messageResult,
              toastType
            );
          }
        }
      });
      $A.enqueueAction(generateSiteIdAction);
    },
    //Alliance Export
    startOrderExportForAlliance: function (component, event, helper) {
      var generateSiteIdAction = component.get("c.generateSiteId");
      generateSiteIdAction.setParams({
        proposalId: component.get("v.recordId"),
      });
      generateSiteIdAction.setCallback(this, function (response) {
        //console.log('>>Output from apex class:::::' + response.getReturnValue());
        if (response.getState() === "SUCCESS") {
          var messageResult = response.getReturnValue();
          //console.log('messageResult1' + messageResult);
          if (messageResult === "SUCCESS") {
            var toastTitle = "Success";
            var toastType = "Success";
            var toastMessage = "Line Item Updated successfully !";
            helper.fireEventCPQ_Evt_ToCallStatusCheck(
              component,
              event,
              helper,
              "Alliance Export"
            );
          } else {
            // toast message
            //console.log('>>messageResult:::::' + messageResult);
            var toastTitle = "Error";
            var toastType = "Error";
            helper.toastMessage(
              component,
              event,
              helper,
              toastTitle,
              messageResult,
              toastType
            );
          }
        }
      });
      $A.enqueueAction(generateSiteIdAction);
    },
    // QTC export
    startOrderExportForQTC: function (component, event, helper) {
      var generateSiteIdAction = component.get("c.generateSiteId");
      generateSiteIdAction.setParams({
        proposalId: component.get("v.recordId"),
      });
      generateSiteIdAction.setCallback(this, function (response) {
        //console.log('>>Output from apex class:::::' + response.getReturnValue());
        if (response.getState() === "SUCCESS") {
          var messageResult = response.getReturnValue();
          //console.log('messageResult1' + messageResult);
          if (messageResult === "SUCCESS") {
            var toastTitle = "Success";
            var toastType = "Success";
            var toastMessage = "Line Item Updated successfully !";
            helper.fireEventCPQ_Evt_ToCallStatusCheck(
              component,
              event,
              helper,
              "QTC SURROUND Export"
            );
          } else {
            // toast message
            //console.log('>>messageResult:::::' + messageResult);
            var toastTitle = "Error";
            var toastType = "Error";
            helper.toastMessage(
              component,
              event,
              helper,
              toastTitle,
              messageResult,
              toastType
            );
          }
        }
      });
      $A.enqueueAction(generateSiteIdAction);
    },
    // QTC SITE export
    startOrderExportForQTCSite: function (component, event, helper) {
      var generateSiteIdAction = component.get("c.generateSiteId");
      generateSiteIdAction.setParams({
        proposalId: component.get("v.recordId"),
      });
      generateSiteIdAction.setCallback(this, function (response) {
        //console.log('>>Output from apex class:::::' + response.getReturnValue());
        if (response.getState() === "SUCCESS") {
          var messageResult = response.getReturnValue();
          //console.log('messageResult1' + messageResult);
          if (messageResult === "SUCCESS") {
            var toastTitle = "Success";
            var toastType = "Success";
            var toastMessage = "Line Item Updated successfully !";
            helper.fireEventCPQ_Evt_ToCallStatusCheck(
              component,
              event,
              helper,
              "QTC SITE Export"
            );
          } else {
            // toast message
            //console.log('>>messageResult:::::' + messageResult);
            var toastTitle = "Error";
            var toastType = "Error";
            helper.toastMessage(
              component,
              event,
              helper,
              toastTitle,
              messageResult,
              toastType
            );
          }
        }
      });
      $A.enqueueAction(generateSiteIdAction);
    },
    // handle the product status check event and execute order export
    handleProductStatusCheckEvent: function (component, event, helper) {
      var orderExportName = event.getParam("orderExportName");
      //console.log('orderExportName>>>' + orderExportName);
  
      var toastTitle = "Information";
      var toastType = "Information";
      var toastMessage =
        orderExportName + " is in progress. Kindly wait for further instruction!";
      helper.toastMessage(
        component,
        event,
        helper,
        toastTitle,
        toastMessage,
        toastType
      );
  
      if (orderExportName === "Alliance Export") {
        helper.executeAllianceExport(component, event, helper);
      } else if (orderExportName === "QTC SITE Export") {
        helper.executeQTCSiteExport(component, event, helper);
      } else if (orderExportName === "QTC SURROUND Export") {
        helper.executeQTCExport(component, event, helper);
      } else if (orderExportName === "CSP Export") {
        helper.cspExport(component, event, helper);
      } else if (orderExportName === "Reconciliation Export") {
        helper.generateReconciliationFile(component, event, helper);
      }
    },
  
    // Add Quote Message
    sendAddQuoteMessage: function (component, event, helper) {
      helper.sendAddQuoteMessageToEAI(component, event, helper);
    },
  
    CQOrderDocExporthandler: function (component, event, helper) {
      helper.CQOrderDocExporthelper(
        component,
        event,
        helper,
        "CQ Order Document"
      );
    },
    CQOrderDocExportWithoutChildhandler: function (component, event, helper) {
      helper.CQOrderDocExporthelper(
        component,
        event,
        helper,
        "CQ Order Doc-Without Child records"
      );
    },
    startReconciliationExport: function (component, event, helper) {
      var generateReconciliationExportAction = component.get(
        "c.generateReconciliationExport"
      );
      generateReconciliationExportAction.setParams({
        proposalId: component.get("v.recordId"),
      });
      generateReconciliationExportAction.setCallback(this, function (response) {
        //console.log('>>Output from apex class:::::' + response.getReturnValue());
        if (response.getState() === "SUCCESS") {
          var messageResult = response.getReturnValue();
          //console.log('messageResult1' + messageResult);
          if (messageResult === "SUCCESS") {
            // helper.generateReconciliationFile(component, event, helper);
            helper.fireEventCPQ_Evt_ToCallStatusCheck(
              component,
              event,
              helper,
              "Reconciliation Export"
            );
            var toastTitle = "Success";
            var toastType = "Success";
            var toastMessage = "Line Item Updated successfully !";
          } else {
            // toast message
            //console.log('>>messageResult:::::' + messageResult);
            var toastTitle = "Error";
            var toastType = "Error";
            helper.toastMessage(
              component,
              event,
              helper,
              toastTitle,
              messageResult,
              toastType
            );
          }
        }
      });
      $A.enqueueAction(generateReconciliationExportAction);
    },
  
    //Elakkiya start for Approval Process - September Enterprise Release
    submitforApprovalEBG: function (component, event, helper) {
      var filePath;
      var recId = component.get("v.recordId");
      filePath =
        "/apex/Apttus_Approval__PreviewSubmitApprovals?id=" +
        recId +
        "&hideSubmitWithAttachments=" +
        true;
      var url = location.href;
      var baseURL = url.substring(0, url.indexOf("/", 14));
      //console.log('>>>' + baseURL + filePath);
      var link = baseURL + filePath;
      window.open(link, "_self");
    },
    configureProductsNCQ: function (component, event, helper) {
      //console.log('in configureProductsNCQ')
      var action = component.get("c.configureMethodNCQ");
      action.setParams({ recordIdVar: component.get("v.recordId") });
      action.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          var link = response.getReturnValue();
          //console.log('link ' + link);
          //alert(JSON.stringify('configureProductsNCQ'));
          window.open(link, "_self");
        }
      });
      $A.enqueueAction(action);
    },
    sendBomToNPT: function (component, event, helper) {
      var action = component.get("c.callSendBomToNPT");
      action.setParams({ recordIdVar: component.get("v.recordId") });
      action.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          var res = response.getReturnValue();
          //alert('The response is '+res);
          if (response.getReturnValue() === "Success") {
            //window.alert('current quote id '+component.get("v.recordId"));
            //var url = location.href;
            //var baseURL = url.substring(0, url.indexOf('/', 14));
            //window.open(baseURL+'/'+link,"_blank","",true);
  
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
              //title : res,
              message: "Quote data transferred to NPT for processing",
              duration: " 5000",
              key: "info_alt",
              type: "success",
              mode: "pester",
            });
            toastEvent.fire();
          } else {
            var toastEvent1 = $A.get("e.force:showToast");
            toastEvent1.setParams({
              //title : res,
              message:
                "There was an error sending the data to NPT Cloud. Please contact your support.",
              duration: " 5000",
              key: "info_alt",
              type: "error",
              mode: "pester",
            });
            toastEvent1.fire();
          }
        }
      });
  
      $A.enqueueAction(action);
    },
    goToCart: function (component, event, helper) {
      component.set("v.showConfirmDialog", false);
      component.set("v.IsSpinner", true);
      var action = component.get(component.get("v.action"));
      action.setParams({ recordIdVar: component.get("v.recordId") });
      action.setCallback(this, function (response) {
        component.set("v.IsSpinner", false);
        if (response.getState() === "SUCCESS") {
          var link = response.getReturnValue();
          window.open(link, "_self");
        }
        else{
                  component.set("v.showConfirmDialog", true);
              }
      });
      $A.enqueueAction(action);
    },
    launchDPT: function (component, event, helper) {
      var action = component.get("c.getXAEParameters");
      action.setParams({ recordIdVar: component.get("v.configId") });
      action.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          var link = response.getReturnValue();
          component.set("v.showConfirmDialog", false);
          var urlEvent = $A.get("e.force:navigateToURL");
          urlEvent.setParams({
            url: link,
          });
          urlEvent.fire();
        }
      });
      $A.enqueueAction(action);
    },
    cancelDialog: function (component, event, helper) {
      component.set("v.showConfirmDialog", false);
    },
    goToInstallLink: function (component, event, helper) {
      var action = component.get("c.getCustomSetting");
      action.setCallback(this, function (response) {
        var rsp = response.getReturnValue();
        if (response.getState() === "SUCCESS" && rsp && rsp != "") {
          window.open(rsp, "_blank");
        }
      });
      $A.enqueueAction(action);
    },
    onChangeToggle: function(component, event, helper){
      component.set("v.IsSpinner",true);
      var togglevalue = component.find('inputToggle').get('v.value');              
      
      var turboChange = component.get("c.updateTurboFlag");
      turboChange.setParams({ "quoteRecord": component.get("v.proposal"),
                                "isTurbo": togglevalue });      
      turboChange.setCallback(this, function (response) {
          if (response.getState() === "SUCCESS") {
              component.set("v.IsSpinner",false);  
               component.set("v.showTurbo",togglevalue); 
               //window.location.reload();
               $A.get('e.force:refreshView').fire();
          }
         
      });
      $A.enqueueAction(turboChange);
      
  }
  });