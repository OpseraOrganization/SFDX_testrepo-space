module.exports = function() {
  return Backbone.Model.extend({
    defaults:{
      'viewSpecificSettingCategory': false,
      'descriptionMap':{
        'Campaign Type Weighting': 'Campaign Type Weight',
        'Campaign Member Status Weighting': 'Campaign Member Status Weight',
        'Custom Field Mappings': 'Field Mappings',
        'Opportunity Stage Mappings': 'Opportunity Stage Mappings',
        'Campaign Costs': 'Default Costs',
        'Dashboard Attribution Settings': 'Sales Task Type<br>Sales Task Status<br>Sales Events<br>Opportunity Stage Mapping',
        'Wizard Unchecked Campaigns': 'Excluded Campaigns<br>Excluded Campaign Member Status',
        'Attribution Wizard': 'Campaign Type<br>Lead Status<br>Opportunity Type<br>Opportunity Stage<br>Campaign Member Status<br>Scheduling',
        'Custom Filters': 'Custom Filters',
        'Reporting Scheduler': 'Scheduled Attribution Run Time',
        'Custom Tuples': 'Custom Tuples',
      },
    },
    
  })
}
