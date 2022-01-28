//This router is initialized on Dashbaord.page and routes all hash requests through these functions.


// Initializers should only be used when magellan_app is loaded, or by Magellan.Navigation.navigate.
// Avoid using Initializers in code outside the Navigation controller
function initializeMagellanInitializers(){
    var Magellan = window.Magellan = window.Magellan || Magellan || {};
    Magellan.Initializers = Magellan.Initializers || {};
    
    Magellan.Initializers.Home = {
        loadHomePage: function() {
            const waitingScreen = Magellan.Controllers.GUI.appWaitingScreen.show('Loading Data...');
            const endDate = moment().subtract(1, 'day').format(Magellan.Validation.DATE_FORMAT);
            const startDate = moment().subtract(31, 'day').format(Magellan.Validation.DATE_FORMAT);

            Magellan.Services.Home.getRoutingUsageMetricsAndLicenseCount(startDate, endDate).then(function(result, event) {
                waitingScreen.resolve();
                initializeHomePage(result, startDate, endDate);
            }); 
       }
    },

    Magellan.Initializers.PartnerApps = {
        loadPartnerAppsPage: function() {
            const waitingScreen = Magellan.Controllers.GUI.appWaitingScreen.show('Loading Data...');
            
            Magellan.Services.Admin.retrievePartnerAppsMetaData()
            .then(function(result, event) {
                initializePartnerApps(result);
                waitingScreen.resolve();
            });
       }
    },
    
    Magellan.Initializers.RoutingMetrics = {
        loadRoutingMetricsPage: function() {
            const waitingScreen = Magellan.Controllers.GUI.appWaitingScreen.show('Loading Data...');
            const endDate = moment().subtract(1, 'day').format(Magellan.Validation.DATE_FORMAT);
            const startDate = moment().subtract(31, 'day').format(Magellan.Validation.DATE_FORMAT);

            Magellan.Services.Home.getRoutingUsageMetricsAndLicenseCount(startDate, endDate).then(function(result, event) {
                waitingScreen.resolve();
                initializeRoutingMetrics(result, startDate, endDate);
            }); 
       }
    },

    Magellan.Initializers.Attribution = {
        loadRunHistory: function() {
            var waitingScreen = Magellan.Controllers.GUI.appWaitingScreen.show('Loading Data...');
            Magellan.Services.Attribution.loadRunHistory().then(function(result, event) {
                initializeRunHistoryModule(result);
                waitingScreen.resolve();
            }); 
       },
      
      loadSettingsHistory: function(){
          var waitingScreen = Magellan.Controllers.GUI.appWaitingScreen.show('Loading Data...');
          Magellan.Services.Attribution.loadSettingsHistory().then(function(result, event) {
              initializeSettingsHistoryModule(result);
              waitingScreen.resolve();
          });
      }
  },
    
    Magellan.Initializers.FlowBuilder = {
        loadFlowBuilderMenu: function(){
            var waitingScreen = Magellan.Controllers.GUI.appWaitingScreen.show('Loading Data...');

            var metadataPromise = Magellan.Controllers.FlowBuilder.getMetaData();
            var magellanResourcePromise = Magellan.Services.FlowBuilder.getMagellanResources(window.LeanData__PrimarySObjectType);
            var graphIdMaps = Magellan.Services.FlowBuilder.checkLongTextInitialization();

            $.when(metadataPromise, magellanResourcePromise, graphIdMaps).then(function(r1, r2, r3) {
                magellanPage = 'main' + (window.LeanData__PrimarySObjectType != 'Lead' ? '-' + window.LeanData__PrimarySObjectType.toLowerCase() : '');
                graphImages = r2[0];
                loadGraphsMenu(window.LeanData__PrimarySObjectType);
            }).always(function() {
                waitingScreen.resolve();
            });
        },
        
        loadFlowBuilderGraph: function(){
            // Note: metadataPromise and magellanResourcePromise are
            // NOT promises. They're deferreds.
            var waitingScreen = Magellan.Controllers.GUI.appWaitingScreen.show('Loading Data...');
            var metadataPromise = Magellan.Controllers.FlowBuilder.getMetaData();
            var magellanResourcePromise =Magellan.Services.FlowBuilder.getMagellanResources(window.LeanData__PrimarySObjectType).then(function(result, event) {
                graphImages = result;
            });
            const partnerAuthorizationsDeferred =
              Magellan.Controllers.FlowBuilder.getPartnerAuthorizations();
            
            $.when(
              metadataPromise,
              magellanResourcePromise,
              partnerAuthorizationsDeferred,
            ).then(function() {
                magellanPage = 'main' + (window.LeanData__PrimarySObjectType != 'Lead' ? '-' + window.LeanData__PrimarySObjectType.toLowerCase() : '');
                loadFlowbuilderGraphById(window.LeanData__PrimarySObjectType, Magellan.Navigation.selectedDeployment);
            }).always(function() {
                waitingScreen.resolve();
                Magellan.Initializers.General.adjustGraphPageSize();
            });
        },

        loadRoutingInsights: function(){
            var waitingScreen = Magellan.Controllers.GUI.appWaitingScreen.show('Loading Data...');

            Magellan.Services.FlowBuilder.getDeploymentResources(window.LeanData__PrimarySObjectType, true, true, false)
            .then(function(result, event) {
              deployedGraphs = result;
              magellanPage = 'deploymentMetrics-'+window.LeanData__PrimarySObjectType.toLowerCase();

              // ensure partnerAuthorizations is defined
              Magellan.Controllers.FlowBuilder.getPartnerAuthorizations().then(() => {
                if (_.isEmpty(result)) {
                  Magellan.Navigation.navigate('#routing/'+window.LeanData__PrimarySObjectType.toLowerCase()+'/flowbuilder');
                } else {
                  window.loadCurrentDeployment();
                }
              }).always(() => {
                waitingScreen.resolve();
                Magellan.Initializers.General.adjustGraphPageSize();
              });
            });
        },

        loadDeploymentHistory: function(){
            var waitingScreen = Magellan.Controllers.GUI.appWaitingScreen.show('Loading Data...');
            Magellan.Services.FlowBuilder.getDeploymentResources(window.LeanData__PrimarySObjectType, true, true, false).then(function(result, event) {
                 deployedGraphs = result;
                 magellanPage = 'deploymentHistory' + (window.LeanData__PrimarySObjectType != 'Lead' ? '-' + window.LeanData__PrimarySObjectType.toLowerCase() : '');
                 
                 loadDeploymentPage(window.LeanData__PrimarySObjectType);
                 waitingScreen.resolve();
            });
        },
        
        loadDeploymentHistoryGraph: function(){
            var waitingScreen = Magellan.Controllers.GUI.appWaitingScreen.show('Loading Data...');
            Magellan.Controllers.FlowBuilder.getPartnerAuthorizations().then(
              () => Magellan.Services.FlowBuilder.getDeploymentResources(window.LeanData__PrimarySObjectType, true, true, false)
            ).then(function(result, event){
                  deployedGraphs = result;
                  magellanPage = 'deploymentHistory' + (window.LeanData__PrimarySObjectType != 'Lead' ? '-' + window.LeanData__PrimarySObjectType.toLowerCase() : '');
                  loadDeploymentGraph(window.LeanData__PrimarySObjectType, Magellan.Navigation.selectedDeployment);
                  waitingScreen.resolve();
                Magellan.Initializers.General.adjustGraphPageSize();
            });
        },
        
        loadMetrics: function(){
            initializeNodeDetailListPage(LeanData__PrimarySObjectType.toLowerCase());
        },

        loadAccountCreationPage: function(){
            initializeAdvancedSettingsAccountCreationModule();
        },

        loadMergeDuplicatesPage: function(){
            var waitingScreen = Magellan.Controllers.GUI.appWaitingScreen.show('Loading Data...');
            Magellan.Services.FlowBuilder.getEdgeSettings().then( function(settings) {
                initializeAdvancedSettingsMergeDuplicatesModule(settings);
                waitingScreen.resolve();
            });
        },

        loadRoundRobinSchedules: function() {
            initializeRoundRobinSchedules();
        },

        loadRoundRobinPools: function() {
            var p1 = Magellan.Services.FlowBuilder.getRoundRobinPoolSettings();
            var p2 = Magellan.Services.FlowBuilder.getRoundRobinScheduleSettings();
            var waitingScreen = Magellan.Controllers.GUI.appWaitingScreen.show('Loading Data...');
            $.when(p1,p2).done(function(r1,r2) {
                initializeRoundRobinPools({
                    poolData: r1[0],
                    scheduleData: r2[0]
                });
                waitingScreen.resolve();
            });
        },

        loadRoundRobinPoolsCreator: function() {
            var poolId = Magellan.Navigation.selectedRoundRobinPoolId;
            console.log('check if creating or editing existing', poolId);
            var waitingScreen = Magellan.Controllers.GUI.appWaitingScreen.show('Loading Data...');
            var pools, members;
            var isEditingExisting = Boolean(poolId);
            var p1 = Magellan.Services.FlowBuilder.getRoundRobinPoolSettings();
            var p2 = Magellan.Services.FlowBuilder.getRoundRobinMembers('{"filterByPoolId": "' + poolId + '"}');
            var p3 = Magellan.Services.FlowBuilder.getUserFilterMetaData();
            var p4Payload = JSON.stringify({filterKey:null});
            var p4 = Magellan.Services.FlowBuilder.getFilteredUserList(p4Payload);
            var p5 = Magellan.Services.FlowBuilder.getGroupsMap();
            var p6 = Magellan.Services.FlowBuilder.getRoundRobinScheduleSettings();
            $.when(p1,p2,p3,p4,p5,p6).then(function(r1,r2,r3,r4,r5,r6) {
                var pool;
                var pools = r1[0];
                var poolNameToPoolTypeMap = {};
                _.each(pools, function(p) {
                    if (isEditingExisting && p.attributes.Id === poolId) pool = p;
                    poolNameToPoolTypeMap[p.attributes.Grouping_Name__c] = p.attributes.Object_Type__c;
                }, this);

                var members;
                var copyMembers = [];
                var members = r2[0].splice(1);
                _.each(members, function(m) {
                  var copyMember;
                  if (m.attributes.User_Owner__c){
                    copyMember = {
                      'attributes': {
                        'Is_Available_For_Routing__c': m.attributes.Is_Available_For_Routing__c,
                        'OwnerId__c': m.attributes.OwnerId__c,
                        'Owner_Order__c': m.attributes.Owner_Order__c,
                        'User_Owner__c': m.attributes.User_Owner__c,
                        'User_Owner__r': m.attributes.User_Owner__r,
                        'Weighting_Next_Pointer__c': m.attributes.Weighting_Next_Pointer__c,
                        'Weighting_Value__c': m.attributes.Weighting_Value__c,
                        'type': null,
                      },
                      'isNextOwner': m.isNextOwner,
                    };
                  } else {
                      copyMember = {
                        'attributes': {
                          'Is_Available_For_Routing__c': m.attributes.Is_Available_For_Routing__c,
                          'OwnerId__c': m.attributes.OwnerId__c,
                          'Owner_Order__c': m.attributes.Owner_Order__c,
                          'Weighting_Next_Pointer__c': m.attributes.Weighting_Next_Pointer__c,
                          'Weighting_Value__c': m.attributes.Weighting_Value__c,
                        },
                        'isNextOwner': m.isNextOwner,
                        'queueInfo': m.queueInfo,
                      };
                  }
                  copyMembers.push(copyMember);
              }, this);

                if(isEditingExisting) {
                    if (!_.isObject(pool)) {
                        var alertModal = new Magellan.Views.ConfirmationModal({
                            header: "Error",
                            message: "Round Robin Pool with Id " + poolId + " no longer exists.",
                            primaryButtonText: "Ok",
                            hideSecondaryButton: true,
                            onConfirmed: function() { 
                                waitingScreen.resolve();
                                Magellan.Navigation.navigate('routing/round_robin_pools'); 
                            }
                        });
                        
                        alertModal.open();
                        return;
                    }
                }
                initializeRoundRobinPoolsCreator({
                    existing: isEditingExisting,
                    pool: pool || null,
                    poolNameToPoolTypeMap: poolNameToPoolTypeMap || {},
                    members: (Magellan.Models.roundRobinPoolCopyMode) ? copyMembers : members,
                    userFilterMetaData: r3[0],
                    filteredUserList: r4[0],
                    groupsMap: r5[0],
                    scheduleSettings: r6[0],
                    waitingScreen: waitingScreen
                });
            });
        },

        loadRoundRobinMembers: function() {
            initializeRoundRobinMembers();
        },

        loadRoundRobinMemberDetails: function() {
            initializeRoundRobinMemberDetails();
        },

        loadRoundRobinLiveRouting: function() {
            // var p1 = Magellan.Services.FlowBuilder.
            var waitingScreen = Magellan.Controllers.GUI.appWaitingScreen.show('Loading Data...');
            // $.when(p1).done(function(data) {
                var data; // TEMP, until remoting call works
                initializeRoundRobinLiveRouting(data);
                waitingScreen.resolve();
            // })
        },
    },
    
    // Matching Initializers
    Magellan.Initializers.Matching = {
        loadTaggingTieBreakers: function(){
            var taggingResourcesPromise = Magellan.Services.FlowBuilder.getTaggingResources().then(function(result, event) {
                if (result) taggingResources = result;
            });
            var metaDataPromise = Magellan.Controllers.FlowBuilder.getMetaData();
            
            $.when(taggingResourcesPromise, metaDataPromise).done(function() {
                window.LeanData__PrimarySObjectType = 'Lead';
                magellanPage = 'taggingSettings'
                initializeMatchingModule();
            });
        },
        
        loadTaggingFinder: function(){
            Magellan.Services.FlowBuilder.getMatchResources().then(function(result, event) {
                window.LeanData__PrimarySObjectType = 'Lead';
                initializeTaggingPreviewPage();
                magellanPage = 'checkMatching'
            });
        },
        
        loadMappedAccountFields: function(){
            Magellan.Services.FlowBuilder.getTaggingResources().then(function(result, event) {
                if (result) taggingResources = result;
                magellanPage = 'matching-mapped-account-fields'
                window.LeanData__PrimarySObjectType = 'Lead';
                initializeMatchingModule();
            });
        },
        
        loadMatchSettings: function() {
            magellanPage = 'matchSettings';
            initializeMatchingModule();
        }
    }

    // Territory Initializers
    Magellan.Initializers.Territory = {
        loadTerritorySegments: function(){
            initializeTerritorySegments();
        },
        loadTerritorySegmentAssignments: function(){
            initializeTerritorySegmentAssignments();
        },
        loadTerritorySegmentEditor: function(){
            initializeTerritorySegmentEditor();
        }
    }

    // General Initializers
    Magellan.Initializers.General = {
        loadHelpPage: function(){
            var waitingScreen = Magellan.Controllers.GUI.appWaitingScreen.show('Loading Data...');
            Magellan.Services.FlowBuilder.getHelpPageInfo().then(function(info) { 
                initializeHelpModule(info);
                waitingScreen.resolve();
            });
        },
        adjustGraphPageSize: function() {
            var $graphTitleContainer;
            var minPageWidth = 1366;
            var currentPageWidth = $(window).width();
            var minContainerWidth = 400;

            var resizeGraphLabel = function() {
                if (_.isEmpty($graphTitleContainer)) {
                    $graphTitleContainer = $('.graph-title-container');
                    if ($('.graph-title-container .ld-input-container').length === 0) {
                        minContainerWidth = 80;
                    }
                }
                currentPageWidth = $(this).width();
                if (currentPageWidth < minPageWidth) {
                    $graphTitleContainer.width(minContainerWidth);
                } else {
                    $graphTitleContainer.width(currentPageWidth - minPageWidth + minContainerWidth);
                }
            }
            $(window).resize(resizeGraphLabel);
            _.delay(resizeGraphLabel.bind(window), 100);
            $('.dg_inner-wrapper').has('#board-container').addClass('graphPagePadding');

            // GET RID OF WEIRD WHITESPACE IN LARGE SCREENS WHEN NODE PANEL IS OPEN
            $('.overlay-rect rect').css('width', '100%');
        },
        resetPageSize: function() {
            $(window).off('resize');
            $('.dg_inner-wrapper').has('#board-container').removeClass('graphPagePadding');
        }
    }
    
    // Magellan.PostLoader is a list of functions that will get called after initializers has run.
    Magellan.PostLoader = [];
}


function initializeMagellanNavigation(){
    var Magellan = window.Magellan = window.Magellan || Magellan || {};
    Magellan.Navigation = Magellan.Navigation || {};
    
    Magellan.Navigation.PermissionSet = getPermissionSet();

    // Keep track of whether or not magellan-app-wrapper has been loaded
    Magellan.Navigation.magellanAppHasLoaded = false;
    Magellan.Navigation.hashFragments = ""
    
    Magellan.Navigation.promptAreYouSure = false;
    Magellan.Navigation.canLoadPage = true;

    Magellan.Navigation.alreadyPrompted = false;
    Magellan.Navigation.promptNavigation = function() {
        var hasValidChosenGraph;
        if (typeof chosenGraphIdMap !== 'undefined') {
            hasValidChosenGraph = _.reduce(Object.keys(chosenGraphIdMap), function(result, curr) {
                return result || chosenGraphIdMap[curr] != null
            }, false);
        }
        return Magellan.Navigation.promptAreYouSure == true || (typeof Magellan.Controllers != 'undefined' && typeof Magellan.Controllers.GUI != 'undefined' && typeof graph != 'undefined' && typeof chosenGraphIdMap !== "undefined" && hasValidChosenGraph && Magellan.Controllers.GUI.graphHasChanged() && magellanAppState == APP_STATE.IN_GRAPH && modalDirtyConfirmed == true);
    };
    
    // This function is called before the page changes
    Magellan.Navigation.navigate = function (path, forceCloseAll=true) {
        if(Magellan.Navigation.promptNavigation()){
            var dirty = new Magellan.Views.ConfirmationModal({
                header: "Changes Detected",
                message: "Are you sure you want to leave this page? ",
                footer: '',
                onConfirmed: function() {
                    Magellan.Navigation.promptAreYouSure = false;
                    Magellan.Navigation.alreadyPrompted = true;
                    Magellan.Navigation.Router.navigate(path, {trigger:true}); 
                    magellanAppState = APP_STATE.OUT_GRAPH;
                }
            });
            dirty.open();
            return false;
        }else{
            //navigate to next page
            if (forceCloseAll) {
              closeAll();
            }
            if(Backbone.history.location.hash == ""){
                Magellan.Navigation.Router.navigate('deadRoute');
            }
            Magellan.Navigation.Router.navigate(path, {trigger:true});
        }
        
        return true;
    }
        
    Magellan.Navigation.getPageFromPath = function(path){
        return _.find(Magellan.Navigation.PAGE_HASHPATH_COLLECTION, function(o){ return o.path === path || path.startsWith(o.path); })['page'];
    }
    
    Magellan.Navigation.getPathFromPage = function(page){
        return _.find(Magellan.Navigation.PAGE_HASHPATH_COLLECTION, function(o){ return o.page === page; })['path'];
    }
    
    Magellan.Navigation.getPermissionSetFromPath = function(path){
        //return _.find(Magellan.Navigation.PAGE_HASHPATH_COLLECTION, function(o){ return o.path == path; })['permission_groups'];
    }
    
    initializeBackboneRouter();
}

function initializeBackboneRouter(){
    
    if(typeof $ == 'undefined') $ = j$;
    
    var Magellan = window.Magellan = window.Magellan || Magellan || {};
    Magellan.Navigation = Magellan.Navigation || {};
    Magellan.Navigation.Middleware = [];
    Magellan.Navigation.Router = Magellan.Navigation.Router || {};
    
    var checkMagellanAppIsLoaded = function(){
         setDeploymentId = null;
         
         if(Magellan.Navigation.hashFragments.includes('lead')) window.LeanData__PrimarySObjectType = 'Lead';
         if(Magellan.Navigation.hashFragments.includes('contact')) window.LeanData__PrimarySObjectType = 'Contact';
         if(Magellan.Navigation.hashFragments.includes('account')) window.LeanData__PrimarySObjectType = 'Account';
         if(Magellan.Navigation.hashFragments.includes('opportunity')) window.LeanData__PrimarySObjectType = 'Opportunity';

        if (j$('#magellan-app-wrapper').length == 0){
            Magellan.Navigation.magellanAppHasLoaded = false;
        }
    }
    Magellan.Navigation.Middleware.push(checkMagellanAppIsLoaded);
    
    // Middleware could be a good place to look for Authorized users
    // Legacy Navigation Menu Highlighting / Dropdowns
    var handleSetActiveNavigationPage = function(path){
        // checking for variables in hash path. The nav bar eventually needs to be decoupled from page names. It should
        // behave entirely on its own.
        var promise;
        if(Magellan.Navigation.hashFragments.includes('lead/insights') && !Magellan.Navigation.hashFragments.includes('live')){  // If insights/live is the path, highlight Routing Insights, if the url is insights/:deployment_id, then show deployment history
            setActiveNav("router-lead-DH");
            promise = function(){ setActiveNav("router-lead-DH"); }
        } else if (Magellan.Navigation.hashFragments.includes('contact/insights') && !Magellan.Navigation.hashFragments.includes('live')){
            setActiveNav("router-contact-DH");
            promise = function(){ setActiveNav("router-contact-DH"); }
        } else if (Magellan.Navigation.hashFragments.includes('account/insights') && !Magellan.Navigation.hashFragments.includes('live')){
						 setActiveNav("router-account-DH");
						 promise = function(){ setActiveNav("router-account-DH"); }
        } else if (Magellan.Navigation.hashFragments.includes('opportunity/insights') && !Magellan.Navigation.hashFragments.includes('live')){
						 setActiveNav("router-opportunity-DH");
						 promise = function(){ setActiveNav("router-opportunity-DH"); }
				} else if(/routing\/[\w]+\/flowbuilder\/[\w]+/.test(Magellan.Navigation.hashFragments)){
            setActiveNav("router-"+window.LeanData__PrimarySObjectType.toLowerCase()+"-FB");
            promise = function(){ setActiveNav("router-"+window.LeanData__PrimarySObjectType.toLowerCase()+"-FB"); }
        } else if (Magellan.Navigation.hashFragments.includes('territory_segment')){
            setActiveNav("router-territoryBB");
            promise = function(){ setActiveNav("router-territoryBB"); }
        } else if (Magellan.Navigation.hashFragments.includes('round_robin_schedules')){
            setActiveNav("router-roundRobin-RRS");
            promise = function(){ setActiveNav("router-roundRobin-RRS"); }
        } else if (Magellan.Navigation.hashFragments.includes('round_robin_pools')){
            setActiveNav("router-roundRobin-RRP");
            promise = function(){ setActiveNav("router-roundRobin-RRP"); }
        } else{
            setActiveNav(Magellan.Navigation.getPageFromPath("#" + Magellan.Navigation.hashFragments));
            promise = function(){
                setActiveNav(Magellan.Navigation.getPageFromPath("#" + Magellan.Navigation.hashFragments))
            }
        }
        
        Magellan.PostLoader.push(promise);
    }
    Magellan.Navigation.Middleware.push(handleSetActiveNavigationPage);
    
    // Check for permissions and redirect to Upsell page if necessary
    var checkPagePermissions = function(){
        if(Magellan.Navigation.hashFragments.includes('lead/insights') && !Magellan.Navigation.hashFragments.includes('live')){  // If insights/live is the path, highlight Routing Insights, if the url is insights/:deployment_id, then show deployment history
        } else if (Magellan.Navigation.hashFragments.includes('contact/insights') && !Magellan.Navigation.hashFragments.includes('live')){
        } else if (Magellan.Navigation.hashFragments.includes('account/insights') && !Magellan.Navigation.hashFragments.includes('live')){
        } else if(/routing\/[\w]+\/flowbuilder\/[\w]+/.test(Magellan.Navigation.hashFragments)){
        } else{
            var permissions = Magellan.Navigation.getPermissionSetFromPath('#' + Magellan.Navigation.hashFragments);
            var valid = true
            _.each(permissions, function(perm){
                valid = !valid ? valid : Magellan.Navigation.PermissionSet[perm];
            })
            return valid
        }
    }

    var MagellanRouter = Backbone.Router.extend({
        routes: {
                    "" : "root",
                    
                    "home": "home",
                    "matching": "matching",
                    "matching/tagging_finder": "matching",
                    "matching/tagging_settings": "taggingSettings",
                    "matching/tagging_account_fields": "matchingTaggingAccountFields",
                    "matching/match_settings": "matchSettings",
                    
                    "routing/:sobject_type/audit_logs":"routingAuditLogs",
                    "routing/:sobject_type/audit_logs/:log_id":"routingAuditLogs",
                    "routing/:sobject_type/deployment_history":"routingDeploymentHistory",
                    "routing/:sobject_type/flowbuilder":"routingFlowbuilder",
                    "routing/:sobject_type/flowbuilder/:deployment_id":"routingFlowbuilderGraph",
                    "routing/:sobject_type/account_creation":"accountCreation",
                    "routing/:sobject_type/metrics":"routingMetrics",
                    "routing/:sobject_type/insights/live":"routingInsightsLive",
                    "routing/:sobject_type/insights/:deployment_id":"routingInsights",
                    "routing/:sobject_type/merge_duplicates":"mergeDuplicates",

                    "territory_segments":"territorySegments",
                    "territory_segments/assignments/:segmentId":"TerritorySegmentAssignments",
                    "territory_segments/editor/:segmentId":"TerritorySegmentEditor",
                    
                    "attribution/run_history":"runHistory",
                    "attribution/settings_history":"settingsHistory",

                    "routing/round_robin_schedules":"roundRobinSchedules",
                    "routing/round_robin_pools":"roundRobinPools",
                    "routing/round_robin_pools/creator":"roundRobinPoolsCreator",
                    "routing/round_robin_pools/creator/:poolId":"roundRobinPoolsCreatorExisting",
                    "routing/round_robin_members":"roundRobinMembers",
                    "routing/round_robin_members/:memberId":"roundRobinMemberDetails",
                    "routing/round_robin_live_routing":"roundRobinLiveRouting",
                    
                    "admin/usage_metrics":"usageMetrics",
                    "admin/partner_apps":"partnerApps",

                    "help":"help",

                    // Visualforce pages - MATCHING
                    "matching/account_scoring": "matchingAccountScoring",
                    "matching/account_scoring/modifiers": "matchingAccountScoringScoreModifiers",
                    "matching/buyer_persona": "matchingBuyerPersona",
                    "matching/domain_matching": "matchingDomainMatching",
                    "matching/preserve_manual_updates": "matchingPreserveManualUpdates",
                    "matching/one_time_tagging": "matchingOneTimeTagging",
                    "matching/list_analyzer/analyze_leads":"matchingAnalyzeLeads",
                    "matching/list_analyzer/matched_account_fields":"matchingMatchedAccountFields",
                    // Visualforce pages - ROUTING
                    "routing/:sobject_type/round_robin":"routingRoundRobin",
                    "routing/:sobject_type/round_robin_vacation":"routingRoundRobinVacation",
                    "routing/:sobject_type/territory_routing":"routingTerritory",
                    "routing/:sobject_type/one_time_routing":"routingOneTimeRouting",
                    "routing/:sobject_type/account_teams":"routingAccountTeams",
                    "routing/:sobject_type/specific_account_team/:account_team_name":"routingSpecificAccountTeam",
                    "routing/:sobject_type/owner_mappings":"routingOwnerMappings",
                    "routing/:sobject_type/owner_mappings_upload":"routingOwnerMappingsUpload",
                    // Visualforce pages - ATTRIBUTION
                    "attribution/general_settings":"attributionGeneralSettings",
                    "attribution/scheduler":"attributionScheduler",
                    "attribution/custom_attribution_model":"attributionCustomAttributionModel",
                    "attribution/campaign_weighting/campaign_types":"attributionCampaignTypes",
                    "attribution/campaign_weighting/campaign_member_statuses":"attributionCampaignMemberStatuses",
                    "attribution/one_time_run":"attributionOneTimeRun",
                    "attribution/opportunity_analyzer":"attributionOpportunityAnalyzer",
                    "attribution/clarity/overview":"attributionOverview",
                    "attribution/clarity/bookings/main":"attributionBookingsMain",
                    "attribution/clarity/bookings/segment":"attributionBookingsSegment",
                    "attribution/clarity/pipeline":"attributionPipeline",
                    "attribution/target_accounts/main":"attributionTargetAccountsMain",
                    "attribution/target_accounts/segment":"attributionTargetAccountsSegment",
                    "attribution/advanced_settings/custom_filters":"attributionCustomFilters",
                    "attribution/advanced_settings/campaign_costs":"attributionCampaignCosts",
                    "attribution/advanced_settings/opportunity_stage_mappings":"attributionOpportunityStageMappings",
                    "attribution/advanced_settings/custom_field_mappings":"attributionCustomFieldMappings",
                    "attribution/advanced_settings/opportunity_cohort_analysis":"attributionOpportunityCohortAnalysis",
                    // Visualforce pages - VIEW
                    "view/general":"viewGeneralSettings",
                    "view/leads":"viewLeads",
                    "view/contacts":"viewContacts",
                    "view/accounts":"viewAccounts",
                    "view/related_leads":"viewRelatedLeads",
                    "view/mass_convert":"viewMassConvert",
                    // Visualforce pages - ADMIN
                    "admin/general":"adminGeneralSettings",
                    "admin/ccio_management":"ccioManagement",
                    "admin/manage_permissions":"managePermissions",
                },
                
         // Backbone.Router.execute is run every time a page changes.
         // Here we call each function included in the Magellan.Navigation.Middleware   
         execute: function(callback, args, name){
            path = _.invert(Magellan.Navigation.Router.routes)[name];
            path = path.replace(':sobject_type', args[0]);
            path = path.replace(':deployment_id', args[1]);

            Magellan.Navigation.hashFragments = path;
            
            if(checkPagePermissions() == false){
                setDashboardUpsellAF('matching');
                return false;
            }
            
            // For general pages with unsaved changes)
            if (Magellan.Navigation.promptAreYouSure) {
                Magellan.Navigation.navigate(path);
                return false;
            } else {
                Magellan.Navigation.promptAreYouSure = false;
            }

            // For flowbuilder graphs
            if (!Magellan.Navigation.alreadyPrompted && Magellan.Navigation.promptNavigation()) {
                if (!confirm('Changes Detected: Are you sure you want to leave this page?')) {
                    var currPath = 'routing/' + LeanData__PrimarySObjectType.toLowerCase() + '/flowbuilder/' + Magellan.Navigation.selectedDeployment;
                    Magellan.Navigation.Router.navigate(currPath, {trigger:false}); 
                    return false;
                } else {
                    magellanAppState = APP_STATE.OUT_GRAPH;
                }
            }
            Magellan.Navigation.alreadyPrompted = false;
            Magellan.Initializers.General.resetPageSize();
            Magellan.PostLoader = [];
            _.each(Magellan.Navigation.Middleware, function(middlewareFunc){middlewareFunc.call();});
             if(callback) callback.apply(this, args);
         }
    });
    
    Magellan.Navigation.Router = new MagellanRouter;
    
    Magellan.Navigation.Router.on('route:root', function(){
      Magellan.Navigation.showDefaultPageWrapper();
      if (Magellan.Navigation.queryParams && !_.isEmpty(Magellan.Navigation.queryParams.page)) {
        // This is to handle the case where the user refreshes the page when on a legacy page, which has no page hash and lands in the root path
        // Angular router will trigger first, so this backbone router route will override that action and redirect users to the dashboard page instead of the legacy page
        return;
      }

        if(Magellan.Navigation.magellanAppHasLoaded) {
            Magellan.Initializers.Home.loadHomePage();
        } else {
            window.initializeMagellanAppPage('home');
            Magellan.PostLoader.push(Magellan.Initializers.Home.loadHomePage);
        }
    });
    
    // Define Matching Routes
    Magellan.Navigation.Router.on('route:matching', function(){
      Magellan.Navigation.showDefaultPageWrapper();
        if(Magellan.Navigation.magellanAppHasLoaded){
            Magellan.Initializers.Matching.loadTaggingFinder();
        }else{
            window.initializeMagellanAppPage('matching-CM');
            Magellan.PostLoader.push(Magellan.Initializers.Matching.loadTaggingFinder);
        }
    })
    
    Magellan.Navigation.Router.on('route:taggingSettings', function(){
      Magellan.Navigation.showDefaultPageWrapper();
        if(Magellan.Navigation.magellanAppHasLoaded){
            Magellan.Initializers.Matching.loadTaggingTieBreakers()
        } else{
            window.initializeMagellanAppPage('matching-MTB');
            Magellan.PostLoader.push(Magellan.Initializers.Matching.loadTaggingTieBreakers);
        }
    })
    
    Magellan.Navigation.Router.on('route:matchingTaggingAccountFields', function(){
      Magellan.Navigation.showDefaultPageWrapper();
        if(Magellan.Navigation.magellanAppHasLoaded){
            Magellan.Initializers.Matching.loadMappedAccountFields()
        }else{
            window.initializeMagellanAppPage('matching-AS-MAF');
            Magellan.PostLoader.push(Magellan.Initializers.Matching.loadMappedAccountFields);
        }
    });
    
    Magellan.Navigation.Router.on('route:matchSettings', function() {
      Magellan.Navigation.showDefaultPageWrapper();
        if(Magellan.Navigation.magellanAppHasLoaded){
            Magellan.Initializers.Matching.loadMatchSettings();
        } else{
            window.initializeMagellanAppPage('matching-MS');
            Magellan.PostLoader.push(Magellan.Initializers.Matching.loadMatchSettings);
        }
    });
    
    /// Define Flowbuilder Routes
    Magellan.Navigation.Router.on('route:routing', function(){
        Magellan.Navigation.legacyChangeDashboardPage('router');
    });
    
    Magellan.Navigation.Router.on('route:routingInsightsLive', function(sobject_type){
      Magellan.Navigation.showDefaultPageWrapper();
        if(Magellan.Navigation.magellanAppHasLoaded && typeof magellanParams.liveDeployment != 'undefined' && typeof currentDeploymentIdMap != 'undefined' && currentDeploymentIdMap[sobject_type] != 'undefined'){   // Temporary workout because we rely on magellanParams to be populated before we can load this page. 
            Magellan.Initializers.FlowBuilder.loadRoutingInsights();
        }else{
            window.initializeMagellanAppPage('router-'+sobject_type+'-DM');
            Magellan.PostLoader.push(Magellan.Initializers.FlowBuilder.loadRoutingInsights);
        }
    });
    
    Magellan.Navigation.Router.on('route:routingInsights', function(sobject_type, deployment_id){
      Magellan.Navigation.showDefaultPageWrapper();
        Magellan.Navigation.selectedDeployment = deployment_id;
        
        if(Magellan.Navigation.magellanAppHasLoaded){
            Magellan.Initializers.FlowBuilder.loadDeploymentHistoryGraph();
        }else{
            window.initializeMagellanAppPage('router-'+sobject_type+'-DH');
            Magellan.PostLoader.push(Magellan.Initializers.FlowBuilder.loadDeploymentHistoryGraph);
        }
    });

    Magellan.Navigation.Router.on('route:territorySegments', function(){
      Magellan.Navigation.showDefaultPageWrapper();
        if(Magellan.Navigation.magellanAppHasLoaded){
            Magellan.Initializers.Territory.loadTerritorySegments();
        }else{
            window.initializeMagellanAppPage('router-territoryBB');
            Magellan.PostLoader.push(Magellan.Initializers.Territory.loadTerritorySegments);
        }
    });
    Magellan.Navigation.Router.on('route:roundRobinSchedules', function(){
      Magellan.Navigation.showDefaultPageWrapper();
        if(Magellan.Navigation.magellanAppHasLoaded){
            Magellan.Initializers.FlowBuilder.loadRoundRobinSchedules();
        }else{
            window.initializeMagellanAppPage('router-RoundRobinSchedules');
            Magellan.PostLoader.push(Magellan.Initializers.FlowBuilder.loadRoundRobinSchedules);
        }
    });
    Magellan.Navigation.Router.on('route:roundRobinPools', function(){
      Magellan.Navigation.showDefaultPageWrapper();
        if(Magellan.Navigation.magellanAppHasLoaded){
            Magellan.Initializers.FlowBuilder.loadRoundRobinPools();
        }else{
            window.initializeMagellanAppPage('router-RoundRobinPools');
            Magellan.PostLoader.push(Magellan.Initializers.FlowBuilder.loadRoundRobinPools);
        }
    });
    
    Magellan.Navigation.Router.on('route:roundRobinPoolsCreator', function(){
      Magellan.Navigation.showDefaultPageWrapper();
        Magellan.Navigation.selectedRoundRobinPoolId = null;
        if(Magellan.Navigation.magellanAppHasLoaded){
            Magellan.Initializers.FlowBuilder.loadRoundRobinPoolsCreator();
        }else{
            window.initializeMagellanAppPage('router-RoundRobinPoolsCreator');
            Magellan.PostLoader.push(Magellan.Initializers.FlowBuilder.loadRoundRobinPoolsCreator);
        }
    });

    Magellan.Navigation.Router.on('route:roundRobinPoolsCreatorExisting', function(poolId){
      Magellan.Navigation.showDefaultPageWrapper();
        Magellan.Navigation.selectedRoundRobinPoolId = poolId;
        if(Magellan.Navigation.magellanAppHasLoaded){
            Magellan.Initializers.FlowBuilder.loadRoundRobinPoolsCreator();
        }else{
            window.initializeMagellanAppPage('router-RoundRobinPoolsCreator');
            Magellan.PostLoader.push(Magellan.Initializers.FlowBuilder.loadRoundRobinPoolsCreator);
        }
    });

    Magellan.Navigation.Router.on('route:roundRobinMembers', function(){
      Magellan.Navigation.showDefaultPageWrapper();
        if(Magellan.Navigation.magellanAppHasLoaded){
            Magellan.Initializers.FlowBuilder.loadRoundRobinMembers();
        }else{
            window.initializeMagellanAppPage('router-RoundRobinMembers');
            Magellan.PostLoader.push(Magellan.Initializers.FlowBuilder.loadRoundRobinMembers);
        }
    });

    Magellan.Navigation.Router.on('route:roundRobinMemberDetails', function(memberId){
      Magellan.Navigation.showDefaultPageWrapper();
        Magellan.Navigation.selectedRoundRobinMemberId = memberId;
        if(Magellan.Navigation.magellanAppHasLoaded){
            Magellan.Initializers.FlowBuilder.loadRoundRobinMemberDetails();
        }else{
            window.initializeMagellanAppPage('router-RoundRobinMemberDetails');
            Magellan.PostLoader.push(Magellan.Initializers.FlowBuilder.loadRoundRobinMemberDetails);
        }
    });

    Magellan.Navigation.Router.on('route:roundRobinLiveRouting', function(){
      Magellan.Navigation.showDefaultPageWrapper();
        if(Magellan.Navigation.magellanAppHasLoaded){
            Magellan.Initializers.FlowBuilder.loadRoundRobinLiveRouting();
        }else{
            window.initializeMagellanAppPage('router-RoundRobinLiveRouting');
            Magellan.PostLoader.push(Magellan.Initializers.FlowBuilder.loadRoundRobinLiveRouting);
        }
    });

    Magellan.Navigation.Router.on('route:TerritorySegmentAssignments', function(segmentId){
      Magellan.Navigation.showDefaultPageWrapper();
        Magellan.Navigation.selectedSegmentId = segmentId;
        if(Magellan.Navigation.magellanAppHasLoaded){
            Magellan.Initializers.Territory.loadTerritorySegmentAssignments();
        }else{
            window.initializeMagellanAppPage('router-territoryBB');
            Magellan.PostLoader.push(Magellan.Initializers.Territory.loadTerritorySegmentAssignments);
        }
    });

    Magellan.Navigation.Router.on('route:TerritorySegmentEditor', function(segmentId){
      Magellan.Navigation.showDefaultPageWrapper();
        Magellan.Navigation.selectedSegmentId = segmentId;
        if(Magellan.Navigation.magellanAppHasLoaded){
            Magellan.Initializers.Territory.loadTerritorySegmentEditor();
        }else{
            window.initializeMagellanAppPage('router-territoryBB');
            Magellan.PostLoader.push(Magellan.Initializers.Territory.loadTerritorySegmentEditor);
        }
    });

    Magellan.Navigation.Router.on('route:routingAuditLogs', function(sobject_type, logId) {
      Magellan.Navigation.showAngularPageWrapper('router-' + sobject_type + '-logs');
    });
    
    Magellan.Navigation.Router.on('route:routingDeploymentHistory', function(sobject_type){
      Magellan.Navigation.showDefaultPageWrapper();
        if(Magellan.Navigation.magellanAppHasLoaded){
            Magellan.Initializers.FlowBuilder.loadDeploymentHistory();
        }else{
            window.initializeMagellanAppPage('router-'+sobject_type+'-DH');
            Magellan.PostLoader.push(Magellan.Initializers.FlowBuilder.loadDeploymentHistory);
        }
    });
    
    Magellan.Navigation.Router.on('route:routingFlowbuilder', function(sobject_type){
      Magellan.Navigation.showDefaultPageWrapper();
        Magellan.Navigation.selectedDeployment = '';
        if(Magellan.Navigation.magellanAppHasLoaded){
           Magellan.Initializers.FlowBuilder.loadFlowBuilderMenu()
        }else{
            window.initializeMagellanAppPage('router-'+sobject_type+'-FB'+ (sobject_type == 'contact' ? 'C' : ''));
            Magellan.PostLoader.push(Magellan.Initializers.FlowBuilder.loadFlowBuilderMenu)
        }
    });
    
    Magellan.Navigation.Router.on('route:routingFlowbuilderGraph', function(sobject_type, deployment_id){
      Magellan.Navigation.showDefaultPageWrapper();
        Magellan.Navigation.selectedDeployment = deployment_id;
        if(Magellan.Navigation.magellanAppHasLoaded){
            Magellan.Initializers.FlowBuilder.loadFlowBuilderGraph();
        }else{
            window.initializeMagellanAppPage('router-'+sobject_type+'-FB' + (sobject_type == 'contact' ? 'C' : ''));
            Magellan.PostLoader.push(Magellan.Initializers.FlowBuilder.loadFlowBuilderGraph)
        }
    });
    
    Magellan.Navigation.Router.on('route:routingMetrics', function(sobject_type){
      Magellan.Navigation.showDefaultPageWrapper();
      Magellan.Navigation.queryParams.objectType = _.capitalize(sobject_type);
        if(Magellan.Navigation.magellanAppHasLoaded){
            Magellan.Initializers.FlowBuilder.loadMetrics();
        }else{
            window.initializeMagellanAppPage('router-'+sobject_type+'-MET', Magellan.Navigation.queryParams);
            Magellan.PostLoader.push(Magellan.Initializers.FlowBuilder.loadMetrics);
        }
    });

    Magellan.Navigation.Router.on('route:accountCreation', function(sobject_type){
      Magellan.Navigation.showDefaultPageWrapper();
        if(Magellan.Navigation.magellanAppHasLoaded){
            Magellan.Initializers.FlowBuilder.loadAccountCreationPage();
        }else{
            window.initializeMagellanAppPage('router-'+sobject_type+'-AS-NAC');
            Magellan.PostLoader.push(Magellan.Initializers.FlowBuilder.loadAccountCreationPage);
        }
        // Magellan.Navigation.legacyChangeDashboardPage('router-lead-AS-NAC');
    });
    
    Magellan.Navigation.Router.on('route:help', function(){
      Magellan.Navigation.showDefaultPageWrapper();
        if (Magellan.Navigation.magellanAppHasLoaded) {
            Magellan.Initializers.General.loadHelpPage();
        } else {
            window.initializeMagellanAppPage('help');
            Magellan.PostLoader.push(Magellan.Initializers.General.loadHelpPage);
        }
    });

    Magellan.Navigation.Router.on('route:mergeDuplicates', function(sobject_type){
      Magellan.Navigation.showDefaultPageWrapper();
        if (Magellan.Navigation.magellanAppHasLoaded) {
            Magellan.Initializers.FlowBuilder.loadMergeDuplicatesPage();
        } else {
            window.initializeMagellanAppPage('router-'+sobject_type+'-AS-MD');
            Magellan.PostLoader.push(Magellan.Initializers.FlowBuilder.loadMergeDuplicatesPage);
        }
    });

    Magellan.Navigation.Router.on('route:usageMetrics', function(){
      Magellan.Navigation.showDefaultPageWrapper();
        if(Magellan.Navigation.magellanAppHasLoaded) {
            Magellan.Initializers.RoutingMetrics.loadRoutingMetricsPage();
        } else {
            window.initializeMagellanAppPage('admin-routing-usage');
            Magellan.PostLoader.push(Magellan.Initializers.RoutingMetrics.loadRoutingMetricsPage);
        }
    });

    Magellan.Navigation.Router.on('route:partnerApps', function(){
        if(Magellan.Navigation.magellanAppHasLoaded) {
            Magellan.Initializers.PartnerApps.loadPartnerAppsPage();
        } else {
            window.initializeMagellanAppPage('admin-partner-apps');
            Magellan.PostLoader.push(Magellan.Initializers.PartnerApps.loadPartnerAppsPage);
        }
    });

    Magellan.Navigation.Router.on('route:runHistory', function(sobject_type) {
      Magellan.Navigation.showDefaultPageWrapper();
        if (Magellan.Navigation.magellanAppHasLoaded) {
            Magellan.Initializers.Attribution.loadRunHistory();
        } else {
            window.initializeMagellanAppPage('attribution-RH');
            Magellan.PostLoader.push(Magellan.Initializers.Attribution.loadRunHistory);
        }
    });
    
    Magellan.Navigation.Router.on('route:settingsHistory', function(sobject_type){
      Magellan.Navigation.showDefaultPageWrapper();
        if (Magellan.Navigation.magellanAppHasLoaded) {
            Magellan.Initializers.Attribution.loadSettingsHistory();
        } else {
            window.initializeMagellanAppPage('attribution-SH');
            Magellan.PostLoader.push(Magellan.Initializers.Attribution.loadSettingsHistory);
        }
    });

    // Visualforce pages - MATCHING
    Magellan.Navigation.Router.on('route:matchingAccountScoring', function(){
      Magellan.Navigation.legacyChangeDashboardPage('matching-accountScoring-FM');
    })
    Magellan.Navigation.Router.on('route:matchingAccountScoringScoreModifiers', function(){
      Magellan.Navigation.legacyChangeDashboardPage('matching-accountScoring-SM');
    });
    Magellan.Navigation.Router.on('route:matchingDomainMatching', function(){
      Magellan.Navigation.legacyChangeDashboardPage('matching-AS-MO'); 
    });
    Magellan.Navigation.Router.on('route:matchingPreserveManualUpdates', function(){
      Magellan.Navigation.legacyChangeDashboardPage('matching-AS-PMU');
    })
    Magellan.Navigation.Router.on('route:matchingOneTimeTagging', function(){
        Magellan.Navigation.legacyChangeDashboardPage('matching-AS-OTM');
    })
    Magellan.Navigation.Router.on('route:matchingAnalyzeLeads', function() {
       Magellan.Navigation.legacyChangeDashboardPage('matching-LA-AL');
    });
    Magellan.Navigation.Router.on('route:matchingMatchedAccountFields', function() {
       Magellan.Navigation.legacyChangeDashboardPage('matching-LA-MAF');
    });
    // Visualforce pages - ROUTING
    Magellan.Navigation.Router.on('route:routingRoundRobin', function(sobject_type){
       Magellan.Navigation.legacyChangeDashboardPage('router-'+sobject_type+'-RR'); 
    });
    Magellan.Navigation.Router.on('route:routingRoundRobinVacation', function(sobject_type){
       Magellan.Navigation.legacyChangeDashboardPage('router-'+sobject_type+'-RR-RRV'); 
    });
    Magellan.Navigation.Router.on('route:routingTerritory', function(sobject_type){
       Magellan.Navigation.legacyChangeDashboardPage('router-'+sobject_type+'-TRM');
    });
    Magellan.Navigation.Router.on('route:routingOneTimeRouting', function(sobject_type) {
       Magellan.Navigation.legacyChangeDashboardPage('router-'+sobject_type+'-OTR');
    });
    Magellan.Navigation.Router.on('route:routingAccountTeams', function(sobject_type) {
       Magellan.Navigation.legacyChangeDashboardPage('router-'+sobject_type+'-AS-ATM');
    });
    Magellan.Navigation.Router.on('route:routingSpecificAccountTeam', function(sobject_type, account_team_name) {
      Magellan.Navigation.legacyChangeDashboardPage('router-'+sobject_type+'-AS-AT');
    });
    Magellan.Navigation.Router.on('route:routingOwnerMappings', function(sobject_type) {
       Magellan.Navigation.legacyChangeDashboardPage('router-'+sobject_type+'-AS-OM');
    });
    Magellan.Navigation.Router.on('route:routingOwnerMappingsUpload', function(sobject_type) {
       Magellan.Navigation.legacyChangeDashboardPage('router-'+sobject_type+'-AS-OMU');
    });
    // Visualforce pages - ATTRIBUTION
    Magellan.Navigation.Router.on('route:attributionGeneralSettings', function() {
       Magellan.Navigation.legacyChangeDashboardPage('attribution-general');
    });
    Magellan.Navigation.Router.on('route:attributionScheduler', function() {
       Magellan.Navigation.legacyChangeDashboardPage('attribution-scheduler');
    });
    Magellan.Navigation.Router.on('route:attributionCustomAttributionModel', function() {
       Magellan.Navigation.legacyChangeDashboardPage('attribution-CAM');
    });
    Magellan.Navigation.Router.on('route:attributionCampaignTypes', function() {
       Magellan.Navigation.legacyChangeDashboardPage('attribution-CW-CTW');
    });
    Magellan.Navigation.Router.on('route:attributionCampaignMemberStatuses', function() {
       Magellan.Navigation.legacyChangeDashboardPage('attribution-CW-CMSW');
    });
    Magellan.Navigation.Router.on('route:attributionOneTimeRun', function() {
       Magellan.Navigation.legacyChangeDashboardPage('attribution-oneTimeRun');
    });
    Magellan.Navigation.Router.on('route:attributionOpportunityAnalyzer', function() {
       Magellan.Navigation.legacyChangeDashboardPage('attribution-oppAnalyzer');
    });
    Magellan.Navigation.Router.on('route:attributionOverview', function() {
       Magellan.Navigation.legacyChangeDashboardPage('attribution-clarity-overview');
    });
    Magellan.Navigation.Router.on('route:attributionBookingsMain', function() {
       Magellan.Navigation.legacyChangeDashboardPage('attribution-clarity-bookings-main');
    });
    Magellan.Navigation.Router.on('route:attributionBookingsSegment', function() {
       Magellan.Navigation.legacyChangeDashboardPage('attribution-clarity-bookings-segment');
    });
    Magellan.Navigation.Router.on('route:attributionPipeline', function() {
       Magellan.Navigation.legacyChangeDashboardPage('attribution-clarity-pipeline');
    });
    Magellan.Navigation.Router.on('route:attributionTargetAccountsMain', function() {
       Magellan.Navigation.legacyChangeDashboardPage('attribution-TA-main');
    });
    Magellan.Navigation.Router.on('route:attributionTargetAccountsSegment', function() {
       Magellan.Navigation.legacyChangeDashboardPage('attribution-TA-segment');
    });
    Magellan.Navigation.Router.on('route:attributionCustomFilters', function() {
       Magellan.Navigation.legacyChangeDashboardPage('attribution-AS-CF');
    });
    Magellan.Navigation.Router.on('route:attributionCampaignCosts', function() {
       Magellan.Navigation.legacyChangeDashboardPage('attribution-AS-CC');
    });
    Magellan.Navigation.Router.on('route:attributionOpportunityStageMappings', function() {
       Magellan.Navigation.legacyChangeDashboardPage('attribution-AS-OSM');
    });
    Magellan.Navigation.Router.on('route:attributionCustomFieldMappings', function() {
       Magellan.Navigation.legacyChangeDashboardPage('attribution-AS-CFM');
    });
    Magellan.Navigation.Router.on('route:attributionOpportunityCohortAnalysis', function() {
       Magellan.Navigation.legacyChangeDashboardPage('attribution-AS-OCA');
    });
    // Visualforce pages - VIEW
    Magellan.Navigation.Router.on('route:viewGeneralSettings', function() {
       Magellan.Navigation.legacyChangeDashboardPage('view-general');
    });
    Magellan.Navigation.Router.on('route:viewLeads', function() {
       Magellan.Navigation.legacyChangeDashboardPage('view-layout-leads');
    });
    Magellan.Navigation.Router.on('route:viewContacts', function() {
       Magellan.Navigation.legacyChangeDashboardPage('view-layout-contacts');
    });
    Magellan.Navigation.Router.on('route:viewAccounts', function() {
       Magellan.Navigation.legacyChangeDashboardPage('view-layout-accounts');
    });
    Magellan.Navigation.Router.on('route:viewRelatedLeads', function() {
       Magellan.Navigation.legacyChangeDashboardPage('view-layout-RL');
    });
    Magellan.Navigation.Router.on('route:viewMassConvert', function() {
       Magellan.Navigation.legacyChangeDashboardPage('view-layout-MC');
    });
    // Visualforce pages - ADMIN
    Magellan.Navigation.Router.on('route:adminGeneralSettings', function() {
       Magellan.Navigation.legacyChangeDashboardPage('admin-general');
    });
    Magellan.Navigation.Router.on('route:ccioManagement', function() {
       Magellan.Navigation.legacyChangeDashboardPage('admin-MA');
    });
    Magellan.Navigation.Router.on('route:managePermissions', function() {
       Magellan.Navigation.legacyChangeDashboardPage('admin-MP');
    });

    Backbone.history.start();
}
