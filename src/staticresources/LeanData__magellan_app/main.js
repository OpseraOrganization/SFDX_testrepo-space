window.currentNode; // global currentNode. refactor this

// check for Magellan globals
Magellan = window.Magellan = window.Magellan || Magellan || {};
Magellan.Models = Magellan.Models || {};
Magellan.Views = Magellan.Views || {};
Magellan.Controllers = Magellan.Controllers || {};

require('./flowbuilder/templates')();

/* Global Initializers */

// Home
window.initializeHomePage = require('./home/dashboard-home.module');

// FlowBuilder
window.initializeMagellanUtil = require('./flowbuilder/util');
window.initializeMagellanController = require('./flowbuilder/gui_controller');
window.initializeFlowBuilderHelpers = require('./flowbuilder/flowBuilder_helpers');
window.initializeMagellanModels = require('./flowbuilder/models');
window.initializeNewViews = require('./flowbuilder/new_view');
window.initializeMagellanMigration = require('./flowbuilder/migration');
window.initializeMagellanValidation = require('./flowbuilder/validation');

window.initializeMetricsDetail= require('./flowbuilder/MetricsDetails/metrics_detail.js');
window.initializeMetricsDetailView = require('./flowbuilder/MetricsDetails/metrics_detail_view.js');
window.initializeMetricsDetailTable = require('./flowbuilder/MetricsDetails/metrics_detail_table.js');
window.initializeMetricsDetailTableRow = require('./flowbuilder/MetricsDetails/metrics_detail_table_row.js');
window.initializeMetricsDetailTableRowError = require('./flowbuilder/MetricsDetails/metrics_detail_table_row_error.js');
window.initializeMetricsDetailModels = require('./flowbuilder/MetricsDetails/metrics_model.js');
// Matching
window.initializeMatchingModule = require('./matching/matching.module');
// Help
window.initializeHelpModule = require('./flowbuilder/Help/help.module');
// AdvancedSettings - New Account Creation
window.initializeAdvancedSettingsAccountCreationModule = require('./flowbuilder/AdvancedSettings/AccountCreation/account-creation.module');
// router > lead > advanced settings > merge duplicates page
window.initializeAdvancedSettingsMergeDuplicatesModule = require('./flowbuilder/AdvancedSettings/MergeDuplicates/merge-duplicates.module');
//run history
window.initializeRunHistoryModule = require('./attribution/RunHistory/RunHistory.module');
//settings history
window.initializeSettingsHistoryModule = require('./attribution/SettingsHistory/SettingsHistory.module');


// account router
require('./flowbuilder/AccountRouter/account-router.module');

// ContactRouter
require('./flowbuilder/ContactRouter/contact-router.module');

// OpportunityRouter
require('./flowbuilder/OpportunityRouter/opportunity-router.module');

// Territory
window.initializeTerritorySegments = require('./flowbuilder/Territory/territory-segments.module');
window.initializeTerritorySegmentAssignments = require('./flowbuilder/Territory/territory-segment-assignments.module');
window.initializeTerritorySegmentEditor = require('./flowbuilder/Territory/territory-segment-editor.module');

// Round Robin
window.initializeRoundRobinSchedules = require('./flowbuilder/RoundRobin/RoundRobinSchedules/round-robin-schedules.module');
window.initializeRoundRobinPools = require('./flowbuilder/RoundRobin/RoundRobinPools/round-robin-pools.module');
window.initializeRoundRobinPoolsCreator = require('./flowbuilder/RoundRobin/RoundRobinPools/Creator/round-robin-pools-creator.module');
window.initializeRoundRobinMembers = require('./flowbuilder/RoundRobin/RoundRobinMembers/round-robin-members.module');
window.initializeRoundRobinMemberDetails = require('./flowbuilder/RoundRobin/RoundRobinMembers/MemberDetails/member-details.module');
window.initializeRoundRobinLiveRouting = require('./flowbuilder/RoundRobin/LiveRouting/live-routing.module');

// Routing Metrics
window.initializeRoutingMetrics = require('./routingMetrics/routing-metrics.module');

// Partner App
window.initializePartnerApps = require('./partnerApps/partner-apps.module');

// Our own extensions on jointjs
require('./flowbuilder/flowbuilder_controller')(); // Early initialization
require('./flowbuilder/external-joint.js')();

// import and initialize components
require('./components/GraphSettingsMenu/GraphSettingsMenu')();
require('./components/SOFieldUpdater/SOFieldUpdater')();
require('./components/ConfirmationModal/ConfirmationModal')();
require('./components/LDInput/LDInput')();
require('./components/LDTable/LDTable')();
require('./components/LDDropdown/LDDropdown')();
require('./components/NestedTypeaheadSelector/NestedTypeaheadSelector')();
require('./components/NestedTypeaheadSelector/MultiNestedTypeaheadSelector')();
require('./components/MetricsDetail/OwnershipDistributionGraph.js')();
require('./components/LDSelectableList/ld-selectable-list.view')();
require('./components/WaitingScreen/waiting-screen.view')();
require('./components/LDMultiSelect/LDMultiSelect.view')();
require('./components/TupleConditions/tuple-conditions.view')();
require('./components/TupleConditions/single-tuple-condition.view')();
require('./components/ErrorBanner/ErrorBanner.view')();
require('./components/EmailTemplateSelector/EmailTemplateSelector.module')();
require('./components/EmailRecipientSelector/EmailRecipientSelector.module')();
require('./components/DataCards/datacards.view')();
require('./components/LineGraph/linegraph.view')();
require('./components/LDRadioButton/LDRadioButton')();

//# sourceURL=magellan/main.js
