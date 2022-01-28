var APP_STATE = { "IN_GRAPH": 0, "OUT_GRAPH": 1 };
var graphsMenuInstance = null;

window.loadCurrentDeployment = function () {
  var urlHash = window.location.hash.replace('#', '') || '';
  var hashParams = urlHash.split('/');
  window.chosenGraphIdMap = window.chosenGraphIdMap || {};
  var sobjectType = window.LeanData__PrimarySObjectType.toLowerCase();
  
  if(typeof currentDeploymentIdMap[sobjectType] != 'undefined'){
      deploymentId = currentDeploymentIdMap[sobjectType]
  }else{
      deploymentId = magellanParams.liveDeployment;
  }
  
  if (!_.isEmpty(hashParams) && hashParams[0] == 'ld-routing-deployment' && hashParams[1]) {
    deploymentId = hashParams[1];
  }

  window.chosenGraphIdMap[sobjectType] = deploymentId;
  Magellan.Controllers.GUI.refreshFlowBuilder();
  var newDeploymentView =  new Magellan.Views.DeploymentHistory({
    objectType : sobjectType
  });

  newDeploymentView.openDeploymentGraph();
}

function loadFlowbuilderGraphById(objectType, deployment_id){
    var thisObjectType = objectType.toLowerCase();
     var graphsMenu = new Magellan.Views.GraphsMenu({
        graphs: window.graphImages,
        objectType: thisObjectType,
        localStorageName: thisObjectType + '_tile_order'
      });
      graphsMenu.openGraph(deployment_id);
}

function loadGraphsMenu(objectType){
    var objectType = objectType.toLowerCase();

    if (graphsMenuInstance instanceof Magellan.Views.GraphsMenu) graphsMenuInstance.remove();

    graphsMenuInstance = new Magellan.Views.GraphsMenu({
      graphs: window.graphImages,
      objectType: objectType,
      localStorageName: objectType + '_tile_order',
    });
    j$(".dg_inner-wrapper").html(graphsMenuInstance.render().$el);

    // When any graph menu gets loaded, reset chosenGraphIdMaps to null values for all routers
    // This covers the case where a user is in a router graph, then selects FlowBuilder for another router without hitting the "close" button
    _.each(Object.keys(chosenGraphIdMap), function(key) {
      chosenGraphIdMap[key] = null;
    })
}

function loadDeploymentPage(objectType){
    var objectType = objectType.toLowerCase();
    var deploymentHistory = new Magellan.Views.DeploymentHistory({
        model: window.deployedGraphs, 
        objectType: objectType,
        localStorageName: objectType+'_tile_order'
    });
    if(objectType == 'account'){var deploymentHistory = Magellan.Controllers.AccountRouter.createDeploymentHistoryView(window.deployedGraphs);}
    
    j$(".dg_inner-wrapper").html(deploymentHistory.render().$el);
}

function loadDeploymentGraph(objectType, deploymentId){
    var objectType = objectType.toLowerCase();
    var deploymentHistory = new Magellan.Views.DeploymentHistory({
        model: window.deployedGraphs, 
        objectType: objectType,
        localStorageName: objectType+'_tile_order'
    });
    if(objectType == 'account'){var deploymentHistory = Magellan.Controllers.AccountRouter.createDeploymentHistoryView(window.deployedGraphs);}
    
    deploymentHistory.openDeploymentGraph(deploymentId);
}

function initializeNewGraph(objectType) {
  Magellan.Controllers.GUI.refreshFlowBuilder();
  var newGraphsMenu = new Magellan.Views.GraphsMenu({
    graphs: window.graphImages,
    objectType: objectType,
    localStorageName: objectType+'_tile_order'
  });
  newGraphsMenu.newGraph();
}

function initializeTaggingPreviewPage() {
  var taggingPreview = new Magellan.Views.TaggingPreview({ model: {} });
  j$(".dg_inner-wrapper").html(taggingPreview.render().$el);
}

// Lead/Contact Deployment Metrics page
function initializeNodeDetailListPage(objectType) {
  var clti = Magellan.Services.FlowBuilder.checkLongTextInitialization();
  var gdm = Magellan.Services.FlowBuilder.getDeploymentMetrics(Magellan.Navigation.queryParams);

  $.when(clti, gdm).done(function(cltiResult, gdmResult) {
    var idMaps = cltiResult[0];
    var parsedMetrics = JSON.parse(gdmResult[0]);
    
    initializeMetricsDetailModels(parsedMetrics);
    initializeMetricsDetail(parsedMetrics);
    initializeMetricsDetailView();
    initializeMetricsDetailTable();
    initializeMetricsDetailTableRow();
    initializeMetricsDetailTableRowError();

    var nodeDetailListPage = new Magellan.Views.MetricsDetailView({});
    j$(".dg_inner-wrapper").html(nodeDetailListPage.$el);
  });
}

function initializeBackboneApp() {
  $(".dynamic-template").each(function(i, el) { el.innerHTML = el.innerHTML.replace(/#RESOURCEURL#/g, resourceURL) });
  initializeMagellanUtil(); 
  _.defer(Magellan.Util.fetchNodeAuxMaps);
  initializeFlowBuilderHelpers();
  initializeMagellanModels();

  initializeMagellanMigration();
  initializeMagellanValidation();

  initializeNewViews();
  initializeMagellanController();
    
  Magellan.Controllers.AccountRouter.initialize();
  Magellan.Controllers.ContactRouter.initialize();
  Magellan.Controllers.OpportunityRouter.initialize();
}

function htmlDecode(input) {
  var e = document.createElement('div');
  e.innerHTML = input;
  return e.childNodes.length === 0 ? "" : e.childNodes[0].nodeValue;
}

function stealDashboardImagesForMagellan() {
  dashboardImagesToURLMap = {};
  $("img").each(function() {
    var imgSrc = $(this).attr("src");
    var imgPathComponents = imgSrc.split("/");
    var imgName = imgPathComponents[imgPathComponents.length - 1];

    dashboardImagesToURLMap[imgName] = imgSrc;
  });
}

function loadFlowBuilderResources(objectType) {
    var graphResourceWaitingPromise = Magellan.Controllers.GUI.appWaitingScreen.show('Retrieving Graphs...');
    return $.when(
        Magellan.Services.FlowBuilder.checkLongTextInitialization(),
        Magellan.Services.FlowBuilder.getMagellanResources(objectType).then(function(result, event) {
            graphImages = result;
        })
    ).fail(function() {
        alert('Failed to retrieve graphs data.');
    }).always(function() {
        graphResourceWaitingPromise.resolve();
    });
}



initializeApp = function() {
  $("div.container").addClass("container-fluid").removeClass("container")
  $("div.row").removeClass("row").addClass("row-fluid")
  if (typeof graphImages === "undefined") graphImages = [];

  iconToURLMap = {
    "Action Node Highlighted": resourceURL + "/images/Action_Node_Highlight.png",
    "Action Node Dashed": resourceURL + "/images/Action_Dash_Icon.png",
    "Action Node Logs": resourceURL + "/images/Action_LOGS.png",
    "Action Node Small": resourceURL + "/images/Action_Node_Small.png",
    "Account2Opportunity Icon" : resourceURL + "/images/A2O_badge_icon.png",
    "Account2Opportunity Icon Disabled" : resourceURL + "/images/A2O_badge_icon_Disabled.png",
    "Account Icon": resourceURL + "/images/Account_badge_icon.png",
    "Action Node Icon": resourceURL + "/images/Action_Node_Opaque.png",
    "Action Node Draggable": resourceURL + "/images/Action_Node_Opaque.png",
    "Action Node": resourceURL + "/images/Action_Node.png",
    "Action Node Opaque": resourceURL + "/images/Action_Node_Opaque.png",
    "Add Button Icon": resourceURL + "/images/Add_Icon_Unselected.png",
    "Admin Static" : resourceURL + "/images/settings-static-lrg@2x.png",
    "Admin Hover" : resourceURL + "/images/settings-hover-lrg@2x.png",
    "Arrow Anchor": resourceURL + "/images/Arrows5_acute_4.png",  
    "Assign Owner Account": resourceURL + "/images/AssignOwnerAccount.png", //"{!URLFOR($Resource.ActionIcons, 'ActionIcons/AssignOwnerAccount.png')}",
    "Assign Owner Account Disabled": resourceURL + "/images/AssignOwnerAccount_disabled.png",
    "Assign Owner Lead": resourceURL + "/images/AssignOwnerLead.png",
    "Assign Owner Lead Disabled": resourceURL + "/images/AssignOwnerLeadDisabled.png",
    "Assign Owner Opportunity": resourceURL + "/images/AssignOwnerOpportunity.png",
    "Assign Owner Opportunity Disabled": resourceURL + "/images/AssignOwnerOpportunityDisabled.png",
    "Assignment Rule": resourceURL + "/images/AssignmentRule.png",
    "Attribution Static" : resourceURL + "/images/attribution-static-lrg@2x.png",
    "Attribution Hover" : resourceURL + "/images/attribution-hover-lrg@2x.png",

    "Branch": resourceURL + "/images/Branch_Icon.png",

    "Calendar Icon": resourceURL + "/images/Calendar_Icon.png",
    "Contact2Opportunity Icon": resourceURL + "/images/C2O_badge_icon.png",
    "Contact2Opportunity Icon Disabled": resourceURL + "/images/C2O_badge_Icon_Disabled.png",
    "Contact2Contact Icon": resourceURL + "/images/C2C_badge_icon.png",
    "Contact2Contact Icon Disabled": resourceURL + "/images/C2C_badge_icon_disabled.png",
    "Contact Icon": resourceURL + "/images/Contact_badge_icon.png",
    "Convert": resourceURL + "/images/Convert.png",
    "Convert Disabled": resourceURL + "/images/convert-lead_disabled@2x.png",
    "Copy Function Icon": resourceURL + "/images/Copy_Icon_Unselected.png",
    "Copy Function Icon Selected": resourceURL + "/images/Copy_Icon_Selected.png",
    "Collapse Arrow": resourceURL + "/images/collapse_arrow_icon.png",
    "Complete Button" : resourceURL + "/images/Complete_Button.png",
    "Create Account": resourceURL + "/images/CreateAccount.png",
    "Create Account Disabled": resourceURL + "/images/CreateAccountDisabled.png",
    "Create Opportunity": resourceURL + "/images/CreateOpportunity.png",
    "Create Opportunity Disabled": resourceURL + "/images/CreateOpportunity_Disabled.png",
    "Create Task": resourceURL + "/images/CreateTask.png",
    "Create Task Disabled": resourceURL + "/images/CreateTask_Disabled.png",
    "Cross Icon": resourceURL + "/images/Cross_Icon.png",
    "Custom Interface": resourceURL + "/images/custom-interface@2x.png",

    "Decision Node": resourceURL + "/images/Decision_Node_Hat.png",
    "Decision Node Small": resourceURL + "/images/Decision_Node_Small.png",
    "Decision Node Dashed": resourceURL + "/images/Decision_Hat_Dash_Icon.png",
    "Decision Node Highlighted": resourceURL + "/images/Decision_Hat_Node_Highlight.png",
    "Decision Node Icon": resourceURL + "/images/Decision_Node_Opaque.png",
    "Decision Node Logs": resourceURL + "/images/Decision_LOGS.png",
    "Decision Node Opaque": resourceURL + "/images/Decision_Node_Opaque_HAT.png",
    "Delete Function Icon": resourceURL + "/images/Delete_Icon_Unselected.png",
    "Delete Function Icon Selected": resourceURL + "/images/Delete_Icon.png",
    "Directional Arrow": resourceURL + "/images/Directional_Arrow.png",
    "Double Arrows": resourceURL + "/images/Double_Arrows_Icon.png",
    "Duplicate Icon" : resourceURL + "/images/Duplicate_badge_icon.png",
    "Duplicate Icon Disabled" : resourceURL + "/images/Duplicate_badge_icon_disabled.png",
    "DuplicateContact Icon" : resourceURL + "/images/DuplicateContact_badge_icon.png",
    "DuplicateContact Icon Disabled" : resourceURL + "/images/DuplicateContact_badge_icon_disabled.png",

    "Edge Arrow": resourceURL + "/images/Edge_Arrow.png",
    "Edge Arrow Logs" : resourceURL + "/images/Edge_icon.png",
    "Edge Arrow Selected": resourceURL + "/images/Edge_Arrow_Selected.png",
    "Edge Notification Icon": resourceURL + "/images/Caution_Icon.png",
    "Edge Notification Icon Highlighted": resourceURL + "/images/Caution_Icon_Highlighted.png",
    "Edge Selected": resourceURL + "/images/Selected_Arrow_Button.png",
    "Edge Stat Icon": resourceURL + "/images/Dashed_circle_icon.png",
    "Edge Unselected": resourceURL + "/images/Unselected_Arrow_Button.png",
    "Edit Function Icon": resourceURL + "/images/Edit_Icon_Unselected.png",
    "Edit Function Icon Selected": resourceURL + "/images/Edit_Icon_Selected.png",
    "Empty Anchor": resourceURL + "/images/Empty_Anchor_White_Icon.png",
    "End of Flow Icon": resourceURL + "/images/EOF_Icon.png",
    "Error Stats Pill": resourceURL + "/images/Failure_Icon.png",
    "Expand Arrow": resourceURL + "/images/expand_arrow_icon.png",
    "Explicit Owner Assignment": resourceURL + "/images/Assign_Owner_Icon.png",

    "Fist Cursor": resourceURL + "/images/Fist_Icon.png",

    "Gray Trigger Node": resourceURL + "/images/Gray_Trigger_Node.png",
    "Gray Trigger Node Opaque": resourceURL + "/images/Gray_Trigger_Node_Opaque.png",

    "Help Static" : resourceURL + "/images/help-static-lrg@2x.png",
    "Help Hover" : resourceURL + "/images/help-hover-lrg@2x.png",
    "Hide Icon" : resourceURL + "/images/Hide_Icon.png",

    "Lead Icon" : resourceURL + "/images/Lead_badge_icon.png",
    "Lead2Account Icon" : resourceURL + "/images/Lead2Account_badge_icon.png",
    "Lead2Account Icon Disabled" : resourceURL + "/images/Lead2Account_badge_icon_disabled.png",
    "Lead2Lead Icon" : resourceURL +"/images/Lead2Lead_badge_icon.png",
    "Lead2Opportunity Icon" : resourceURL + "/images/Lead2Opportunity_badge_icon.png",
    "Lead2Lead Icon Disabled" : resourceURL + "/images/Lead2Lead_badge_icon_disabled.png",
    "Lead2Account Tag": resourceURL + "/images/Lead2AccountTag.png",
    "Lead2Opportunity Icon Disabled" : resourceURL + "/images/Lead2Opportunity_badge_icon_disabled.png",
    "Link Icon" : resourceURL + "/images/Link_Icon.png",

    "Mail Failure Active" : resourceURL + "/images/Mail_Failure_Active_Icon.png",
    "Mail Failure Inactive" : resourceURL + "/images/Mail_Failure_Inactive_Icon.png",
    "Mail Success Active" : resourceURL + "/images/Mail_Success_Active_Icon.png",
    "Mail Success Inactive" : resourceURL + "/images/Mail_Success_Inactive_Icon.png",
    "Magnifying Glass Icon" : resourceURL + "/images/Magnifying_Glass_icon.png", 
    "Match Node": resourceURL + "/images/Match_Node_Hat.png",
    "Match Node Small": resourceURL + "/images/Match_Node_Small.png",
    "Match Node Dashed": resourceURL + "/images/Match_Hat_Dash_Icon.png",
    "Match Node Highlighted": resourceURL + "/images/Match_Hat_Node_Highlight.png",
    "Match Node Icon": resourceURL + "/images/Match_Node_Opaque.png",
    "Match Node Logs": resourceURL + "/images/Match_LOGS.png",
    "Match Node Opaque": resourceURL + "/images/Match_Node_Opaque_HAT.png",
    "Matching Static" : resourceURL + "/images/matching-static-lrg@2x.png",
    "Matching Hover" : resourceURL + "/images/matching-hover-LRG@2x.png",
    "Maximize": resourceURL + "/images/Maximize_Icon.png",
    "Merge": resourceURL + "/images/Merge.png",
    "Merge Disabled": resourceURL + "/images/Merge_disabled.png",
    "Merge Contact": resourceURL + "/images/Merge_Contact_Icon.png",
    "Merge Contact Disabled": resourceURL + "/images/Merge_Contact_Icon_disabled.png",
    "Minus Icon" : resourceURL + "/images/Minus_icon.png",
    "Node Validation Error Icon": resourceURL + "/images/Triangle_Error_Icon_node.png",

    "Opportunity Icon" : resourceURL + "/images/Opportunity_badge_icon.png",
    "Opportunity2Contact Icon" : resourceURL + "/images/O2C_badge_icon_2x.png",
    "Opportunity2Contact Icon Disabled" : resourceURL + "/images/O2C_badge_icon_2x_disabled.png",
    "Opportunity2Opportunity Icon" : resourceURL + "/images/O2O_badge_icon_2x.png",
    "Opportunity2Opportunity Icon Disabled" : resourceURL + "/images/O2O_badge_icon_2x_disabled.png",
    "Outreach Node Icon" : resourceURL + "/images/outreach-icon_FB_2x.png",
    "Outreach Node": resourceURL + "/images/outreach-node_static_2x.png",
    "Outreach Node Dashed": resourceURL + "/images/outreach-node_link_2x.png",

    "Palette Icon Arrow": resourceURL + "/images/Palette_Icon_Arrow.png",
    "Paste Function Icon": resourceURL + "/images/Paste_Icon.png",
    "Plus Icon" : resourceURL + "/images/Plus_icon.png", 

    "Refresh Icon": resourceURL + "/images/refresh-icon_2x.png",
    "Round Robin": resourceURL + "/images/RoundRobin.png",
    "Route To Territory" : resourceURL + "/images/TerritoryRouting.png",
    "Route To Territory Disabled" : resourceURL + "/images/TerritoryRouting_disabled.png",
    "Routing Static" : resourceURL + "/images/routing-static-lrg@2x.png",
    "Routing Hover" : resourceURL + "/images/routing-hover-lrg@2x.png",
    "Salesloft Node Icon" : resourceURL + "/images/salesloft-icon_FB_2x.png",
    "Salesloft Node": resourceURL + "/images/salesloft-node_static_2x.png",
    "Salesloft Node Dashed": resourceURL + "/images/salesloft-node_link_2x.png",
    "Timebased Reroute Node": resourceURL + "/images/Time-Node_FB-static@2x.png",
    "Timebased Reroute Node Insights": resourceURL + "/images/TIME-NODE_INSIGHTS@2x.png",
    "Timebased Reroute Node Selected": resourceURL + "/images/Time-Node_FB-selected@2x.png",
    "Timebased Reroute Node Connected": resourceURL + "/images/Time-Node_FB-connected@2x.png",
    "Timebased": resourceURL + "/images/Time-based@2x.png",

    "Selected Edge Stat Icon": resourceURL + "/images/Selected_Dashed_circle_icon.png",
    "Send Notification" : resourceURL + "/images/Send_Notification_Icon.png",
    "Send Notification Disabled" : resourceURL + "/images/Send_Notification_Icon_Disabled.png",
    "Stats Legend Icon": resourceURL + "/images/Legend_Icon.png",
    "Success Stats Pill": resourceURL + "/images/Success_Icon.png",
    "Success Failure Icon": resourceURL + "/images/Success_Failure_Icon.png",

    "Territory Routing" : resourceURL + "/images/TerritoryRouting.png",
    "Territory Routing Disabled" : resourceURL + "/images/TerritoryRouting_disabled.png",
    "Tooltip Icon": resourceURL + "/images/tooltip_icon-static.png",
    "Tooltip Icon Hover": resourceURL + "/images/tooltip_icon-hover.png",
    "Trigger Node Small": resourceURL + "/images/Trigger_Node_Small.png",
    "Trigger Node": resourceURL + "/images/Trigger_Node.png",
    "Trigger Node Highlighted": resourceURL + "/images/Trigger_Node_Highlight.png",
    "Trigger Node Logs": resourceURL + "/images/Trigger_LOGS.png",
    "Trigger Node Opaque": resourceURL + "/images/Trigger_Node_Opaque.png",
    "True/False": resourceURL + "/images/True_False_Icon.png",
    "Unlinked Edge Icon": resourceURL + "/images/Caution_Unlink_Icon.png",
    
    "Unselected Anchor": resourceURL + "/images/Anchor_Icon.png",
    "Update Lead": resourceURL + "/images/UpdateLead.png",
    "Upgrade Sash" : resourceURL + "/images/Upgrade_Sash.png",

    "Vacation Icon": resourceURL + "/images/Vacation_Icon_2x.png",
    "View Static" : resourceURL + "/images/view-static-lrg@2x.png",
    "View Hover" : resourceURL + "/images/view-hover-lrg@2x.png",
  };

  // 1. When external.js is fetched
  // 2. Then fetch external-joint.js
  // 3. Then fetch other non-dependent js asynchronously
  // 4. Finally run initializeBackboneApp, etc..
  $.getScript(resourceURL + "/main.bundle.js")
  .then(function () {
    initializeBackboneApp();
    magellanAppState = APP_STATE.OUT_GRAPH;
    //Metadata caching
    fieldMetaData = JSON.parse(window.localStorage.getItem('field_metadata')) || {}

    actionNodeMetaData = JSON.parse(window.localStorage.getItem('action_node_metadata')) || {};
    stealDashboardImagesForMagellan();
       
    // This runs all the Magellan.Initializer functions that were saved in order to run after all Backbone models and views were initialized.
    Magellan.Services.FlowBuilder.checkLongTextInitialization();
    _.each(Magellan.PostLoader, function(callback){callback.call()});
    Magellan.Navigation.magellanAppHasLoaded = true;

    initializeMagellanModals();

    j$('.loadingOverlay').parent().css('display', 'block');
    return Magellan.Controllers.FlowBuilder.getPartnerAuthorizations()
    .then(() => Magellan.Controllers.FlowBuilder.getMetaData());
  })
  .always(() => {
    j$('.loadingOverlay').parent().css('display', 'none');
  })
  .fail(throwFailedScript);
}
initializeApp();

function initializeMagellanModals() {
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "delete-node",
    headerText: "Are you sure you want to delete this node?",
    mainText: "Press OK to delete or Cancel to keep it.",
    button1Name: "Cancel",
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "delete-setting",
    headerText: "Delete Setting",
    mainText: "Warning: Are you sure you want to delete this setting?",
    button1Name: "Cancel",
    button2Name: "Delete",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "delete-territory",
    headerText: "Delete Territory",
    mainText: "Warning: Are you sure you want to delete this territory?",
    button1Name: "Cancel",
    button2Name: "Delete",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "delete-territory-segment",
    headerText: "Delete Territory Segment",
    mainText: "Warning: Are you sure you want to delete this Segment? It will no longer be available in FlowBuilder.",
    button1Name: "Cancel",
    button2Name: "Delete",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "save-as",
    headerText: "Enter new graph name",
    mainText: "Note: You are saving a copy and will be allowed to edit.",
    button1Name: "Cancel",
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $("#save-as-extra").html("<div class='row' style='width:100%;'><div class='col col-xs-3 text-right' style='padding-top: 6px;'>Name:</div><div class='col col-xs-9'><input type='text'></div></div>");
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "deployment-save-as",
    headerText: "Save a Copy",
    mainText: "Save a copy of this graph to make it available for deployment.",
    button1Name: "Cancel",
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "deployment-save-as-success",
    headerText: "Copy Saved",
    mainText: "Successfully created graph from deployment.",
    button1Name: null,
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "deployment-save-as-failure-duplicate",
    headerText: "Copy Failed",
    mainText: "Graph name is already taken.",
    button1Name: null,
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $("#deployment-save-as-extra").html("<span style='padding-right:20px'>Name:</span><input type='text'></input>");
  $('#deployment-save-as-button-2').click(function() {
    var newGraphName = $('#deployment-save-as-extra input').val();
    if (_.find(graphImages, function(graph) {
        return graph.name === newGraphName
      }) != undefined) {
      alert('Save Failed: Graph name already taken');
      return;
    }
    paper.toJPEG(function(previewImage) {
      createGraphFromDeployment(newGraphName, previewImage);
    }, { quality: .1 });
  });
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "save-and-deploy",
    headerText: "Are you sure you want to save and deploy?",
    mainText: "Note: The changes you made will be saved and made live.",
    button1Name: "Cancel",
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "dirty",
    headerText: "Are you sure you want to leave this panel?",
    mainText: "You have unsaved changes that will be lost. Press OK to leave or Cancel to stay on the page.",
    button1Name: "Cancel",
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "dirty-close-graph",
    headerText: "Are you sure you want to leave this graph?",
    mainText: "You have unsaved changes that will be lost. Press OK to leave or Cancel to stay on the page.",
    button1Name: "Cancel",
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $('#dirty-close-graph-button-2').click(function() {
    refreshFlowCharts();
    magellanAppState = APP_STATE.OUT_GRAPH;
  });
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "name-taken",
    headerText: "Settle naming issue.",
    mainText: "The name you have selected is already in use. Press OK to revert the name and keep other changes or Cancel to stay on the page.",
    button1Name: "Cancel",
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));

  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "territory-rename",
    headerText: "Edit Segment",
    mainText: magellanDocument.getElementById("territory_rename").innerHTML,
    button1Name: "Cancel",
    button2Name: "Rename",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "territory-create",
    headerText: "Create Territory Segment",
    mainText: magellanDocument.getElementById("territory_create").innerHTML,
    button1Name: "Cancel",
    button2Name: "Create",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "error-in-graph",
    headerText: "Save Anyway?",
    mainText: "There are errors in the graph that may prevent deployment. Save anyway?",
    button1Name: "Do Not Save",
    button2Name: "Yes, Save Anyway",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "graph-deploy-success",
    headerText: "Deploy Successful",
    mainText: "Graph Deployed",
    button1Name: null,
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "save-failure",
    headerText: "Save Failure",
    mainText: "An error occurred while saving your changes.",
    button1Name: null,
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "save-success",
    headerText: "Save Successful",
    mainText: "Your changes were saved successfully.",
    button1Name: null,
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "save-tagging-settings",
    headerText: "Save Successful",
    mainText: "Settings Saved",
    button1Name: null,
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "import-graph-success",
    headerText: "Import Successful",
    mainText: "Graph Imported",
    button1Name: null,
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "import-graph-failure",
    headerText: "Import Failed",
    mainText: "Invalid Graph File",
    button1Name: null,
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "graph-deploy-failure",
    headerText: "Deploy Cancelled",
    mainText: "Graph is not valid and cannot be deployed",
    button1Name: null,
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "validation-errors",
    headerText: "<div class='validation-errors-modal-icon'></div><span>Validation Errors</span>",
    mainText: '<div style="margin-top:5px; color:#d91e18">The following validation errors were detected and must be fixed prior to taking this flow live.</div>',
    button1Name: null,
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "validation-successful",
    headerText: "Validation Successful",
    mainText: "Graph is well-formed and valid.",
    button1Name: null,
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "metrics-error",
    headerText: "Metrics Unavailable",
    mainText: "There was a system error generating metrics for your Router flow. Please reload Flow Builder and try again. If you keep encountering issues, please reach out to LeanData.",
    button1Name: null,
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "no-leads-routed",
    headerText: "No Leads Routed",
    mainText: "No leads have been routed through LeanData Router during the time period you selected.",
    button1Name: null,
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "metrics-incompatible",
    headerText: "Metrics Unavailable",
    mainText: "Metrics are not available for this graph. Please view metrics for newer graphs and deployments.",
    button1Name: null,
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "wildcard",
    headerText: "<div id='wildcard-modal-header'></div>",
    mainText: "<div id='wildcard-modal-main'></div>",
    button1Name: null,
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "confirm-undo",
    headerText: "Undo Changes",
    mainText: "Are you sure you want to undo the changes you've made?",
    button1Name: "Cancel",
    button2Name: "Undo",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "confirm-revert",
    headerText: "Revert Changes",
    mainText: "Are you sure you want to revert the changes you've made?",
    button1Name: "Cancel",
    button2Name: "Revert",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "territory-replace",
    headerText: "Replace Territory Segment",
    mainText: "Warning: Uploading another CSV will overwrite and replace this one. Are you sure you want to overwrite this Segment?",
    button1Name: "Cancel",
    button2Name: "Replace",
    button1Action: null,
    button2Action: null
  }));
  $("#magellan-modals").append(_.template(magellanDocument.getElementById("modal_template").innerHTML)({
    uniqueId: "territory-deploy",
    headerText: "Deploy Draft Version",
    mainText: "Are you sure you want to overwrite your deployed territory data with this draft version?",
    button1Name: "Cancel",
    button2Name: "OK",
    button1Action: null,
    button2Action: null
  }));

  // We don't have a streamlined way to insert these configurations for now
  $('#validation-errors-button-div').css('padding-top', '10px');
  $('#import-graph-success-button-div').css('padding-top', '10px');

  // All modals are always in front
  $("#magellan-modals").children().each(function() {
    $(this).css("z-index", 2147483647);
  });
}
//# sourceURL=magellan/initializers.js
