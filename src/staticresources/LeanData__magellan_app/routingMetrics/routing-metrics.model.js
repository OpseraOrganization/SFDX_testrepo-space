module.exports = function() {
	return Backbone.Model.extend({
		defaults: {
			'usageMetrics': [],
			'lineValues': [],
			'idToRecordTypeCount' : {},
			'leadLineValues': undefined,
			'contactLineValues': undefined,
			'accountLineValues': undefined,
			'opportunityLineValues': undefined,
			'selectedTab': 'total',
			'selectedPoint': undefined,
			'renderTableOnly' : false,
			'routingList': [], // to be used by table's template
			'allRoutingList': [], // to store ALL routing info 
			'tempRoutingList' : [], // to store previous routing list
			'hideInactiveUsers' : false,
			'inactiveUserIds' : [],
		}
	});
}
