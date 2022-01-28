module.exports = function() {
  const LineGraphView = require('../components/LineGraph/linegraph.view')();

  return Backbone.View.extend({
    template: _.template(require('./dashboard-home.template.html')),
    initialize: function(params) {
      this.transitionTime = 700;
      this.firstTimeGraphRender = false;
      this.formatUsageMetrics(params.routingMetrics.routingCountMetrics, params.startDate, params.endDate);
      this.model.set('routingUserLicenseCount', params.routingMetrics.routingUserLicenseCount);
      this.render();
    },

    events: {
      'click .show_authorization' : 'showAuthorizationDiv',
      'click .hide_authorization' : 'hideAuthorizationDiv',
      'click .icon' : 'handlePageChange',
      'click .detailed-report-button' : 'redirectToRoutingUsage'
    },

    handlePageChange: function(event) {
      const pageName = $(event.currentTarget).data('page-name');

      // different functions are currently used to handle different pages
      if (pageName === 'matching-CM' && this.hasProductEnabled('Matching')) {
        Magellan.Navigation.navigate('/matching/tagging_finder');
      } else if (pageName === 'router-lead-FB' && this.hasProductEnabled('Routing')) {
        if (this.hasProductEnabled('LeadRouting')) {
          Magellan.Navigation.navigate('/routing/lead/flowbuilder');
        } else if (this.hasProductEnabled('ContactRouting')) {
          Magellan.Navigation.navigate('/routing/contact/flowbuilder');
        } else if (this.hasProductEnabled('AccountRouting')) {
          Magellan.Navigation.navigate('/routing/account/flowbuilder');
        } else if (this.hasProductEnabled('OpportunityRouting')) {
          Magellan.Navigation.navigate('/routing/opportunity/flowbuilder');
        }
      } else if (pageName === 'help') {
        Magellan.Navigation.navigate('/help');
      } else if (pageName === 'attribution' && !this.hasProductEnabled('Attribution')) {
        return;
      } else {
        Magellan.Navigation.legacyChangeDashboardPage(pageName);
      }
    },

    redirectToRoutingUsage: function() {
      Magellan.Navigation.navigate('admin/usage_metrics');
    },

    showAuthorizationDiv: function() {
      this.$el.find('.show_authorization').slideUp(100, function() {
      this.$el.find('.authorization-div').slideDown('100');
      }.bind(this));
    },

    hideAuthorizationDiv: function() {
      this.$el.find('.authorization-div').slideUp(100, function() {
      this.$el.find('.show_authorization').slideDown('100');
      }.bind(this));
    },

    render: function() {
      // pass model to the template
      const content = this.template({
      model: this.model.toJSON()
      });

      this.$el.html(content);
      this.initDashboardComponent();

      // only render line graph if user has Router
      if (this.hasProductEnabled('Routing')) {
        this.showGraphTitleAndDateRange();
        this.modifySpacingForLineGraph();
        this.createGraphData();
        this.renderLineGraph();
      }
      return this;
    },

    // DASHBOARD
    initDashboardComponent: function() {
      let numOfTimesPanelDisplayed;

      if (dashboardController.viewObject['installationPanelStatus'] === 'no token for org') {
        numOfTimesPanelDisplayed = this.getCookie('num_of_times_panel_displayed_in_no_token_org');
      } else if (dashboardController.viewObject['installationPanelStatus'] === 'no token for user') {
        numOfTimesPanelDisplayed = this.getCookie('num_of_times_panel_displayed_in_token_org');
      }

      if (dashboardController.viewObject['installationPanelStatus'] === 'org blind') {
        this.$el.find('.auth_panel').hide();
      }

      if (dashboardController.viewObject['installationPanelStatus'] === 'completed installation' || 
        dashboardController.viewObject['installationPanelStatus'] === 'no token for org' && numOfTimesPanelDisplayed  > 9 ||
        dashboardController.viewObject['installationPanelStatus'] === 'no token for user' && numOfTimesPanelDisplayed > 0
      ) {
        this.hideAuthPanel();
      } else { 
        this.showAuthPanel();
      }

      // Show Authorization Banner 
      if(dashboardController.viewObject['installationPanelStatus'] === 'completed installation') {
        this.$el.find('.installation-complete').css('display', 'block');
        this.$el.find('.auth_text').hide()
      } else {
        this.$el.find('.authorization-link').css('display', 'block');
      }  

      if(dashboardController.viewObject['installationPanelStatus'] === 'no token for org' && numOfTimesPanelDisplayed < 10) {
       this.setCookie('num_of_times_panel_displayed_in_no_token_org', (parseInt(numOfTimesPanelDisplayed)+1).toString());
      } else if (dashboardController.viewObject['installationPanelStatus'] === 'no token for user' && numOfTimesPanelDisplayed < 1)
       this.setCookie('num_of_times_panel_displayed_in_token_org', 1);

      this.disableHomeProductButtons();
    },

    hasProductEnabled: function(product) {
      const statuses = dashboardController.viewObject.statuses;
      if (product === 'Matching') {
        return statuses.hasMatching;
      } else if (product === 'Routing') {
        return (statuses.hasRouterProduct || statuses.hasRouter) &&
          (
            statuses.hasLeadRouting ||
            statuses.hasContactRouting ||
            statuses.hasAccountRouting ||
            statuses.hasOpportunityRouting
          )
        ;
      } else if (product === 'LeadRouting') {
        return statuses.hasLeadRouting;
      } else if (product === 'ContactRouting') {
        return statuses.hasContactRouting;
      } else if (product === 'AccountRouting') {
        return statuses.hasAccountRouting;
      } else if (product === 'OpportunityRouting') {
        return statuses.hasOpportunityRouting;
      } else if (product === 'Attribution') {
        return statuses.hasAttribution;
      } else {
        return false;
      }
    },

    disableHomeProductButtons: function () {
      _.each(dashboardController.FEATURE_CONFIG, function (featureConfig, settingKey) {
        const featureSelector = featureConfig['selector'];
        let htmlContent = '';
        const productButton = this.$el.find('.home-component ' + featureSelector).find('.product-icon-button');
        
        if (!dashboardController.viewObject.featureProvisioning[settingKey]) {
          productButton.toggleClass('disabled', true).prop('onclick', null).off('click');
          htmlContent = dashboardController.viewObject.upsellContainerTemplate(featureConfig);
        }
        if (
          settingKey === 'has routing product' && !(
            dashboardController.viewObject.statuses.hasLeadRouting ||
            dashboardController.viewObject.statuses.hasContactRouting ||
            dashboardController.viewObject.statuses.hasAccountRouting ||
            dashboardController.viewObject.statuses.hasOpportunityRouting
          )
        ) {
          productButton.toggleClass('disabled', true).prop('onclick', null).off('click');
          htmlContent = dashboardController.viewObject.upsellContainerTemplate(featureConfig);
        }

        this.$el.find(
          '.home-component ' + featureSelector + ' .dg_section-nav-image'
        ).parent().popover({
          placement: 'top',
          container: '.home-component-popover-container',
          content: htmlContent,
          html: true,
          trigger: 'manual',
          template: '<div class="popover" role="tooltip"><div class="arrow"></div>' +
          '<h3 class="popover-title">' +
          '</h3><div class="popover-content"></div></div>'
        }).on("mouseenter", function() {
          setTimeout(function () {
            $(this).popover("show");
            $('#' + $(this).attr('aria-describedby')).on("mouseleave", function () {
              $(this).popover('hide');
            }.bind(this));
          }.bind(this), 50);
        }).on("mouseleave", function () {
          setTimeout(function () {
            if (!$(".popover:hover").length) {
              $(this).popover("hide")
            }
          }.bind(this), 50);
        });
      }, this);
    },       
    
    getCookie: function(cookie_name){
      const all_cookies = document.cookie.split(';');
      for (let i=0; i < all_cookies.length; i++ ){
        const key = all_cookies[i].split( '=' );
        const name =key[0].replace(/^\s+|\s+$/g, '');
        if(name === cookie_name) {
          return key[1];
        }
      }
      return 0;
    },

    setCookie: function(cookie_name, value){
      const newCookie =  cookie_name + '=' + value;
      document.cookie = newCookie;
    },

    hideAuthPanel: function(){
      this.$el.find('.authorization-div').fadeOut();
      this.$el.find('.show_authorization').fadeIn();
    }, 

    showAuthPanel: function(){
      this.$el.find('.authorization-div').fadeIn();
      this.$el.find('.show_authorization').fadeOut();
    },

    showAuthorizationDiv: function() {
      this.$el.find('.show_authorization').slideUp(100, function() {
      this.$el.find('.authorization-div').slideDown('100');
      }.bind(this));
    },

    hideAuthorizationDiv: function() {
      this.$el.find('.authorization-div').slideUp(100, function() {
      this.$el.find('.show_authorization').slideDown('100');
      }.bind(this));
    },

    showGraphTitleAndDateRange: function() {
      this.$el.find('.graph-name').css('display', 'inline-block');
      this.$el.find('.graph-date-range').css('display', 'inline-block');
      this.$el.find('.detailed-report-button').css('display', 'inline-block');
    },

    modifySpacingForLineGraph: function() {
      this.$el.find('.icon-container').css({'position' : 'relative'});
    },

    // ROUTING METRICS LINE GRAPH

    formatUsageMetrics: function(rawRoutingMetrics, startDate, endDate) {
      const formattedMetrics = Magellan.Util.formatUsageMetrics(rawRoutingMetrics);

      this.model.set({
        usageMetrics: formattedMetrics.usageMetrics,
        userCount: formattedMetrics.uniqueIdCount,
        recordsRouted: formattedMetrics.recordsRouted,
        routingUsageRoutedRecordCount: Magellan.Util.shortenNumbers(formattedMetrics.totalRecordsRouted),
        startDate: moment(startDate).format('MMMM D, YYYY'),
        endDate: moment(endDate).format('MMMM D, YYYY'),
      });
    },

    createGraphData: function() {
      const lineValues = this.model.get('usageMetrics').map(
      function(metric, i) {
        const routedMap = metric['All_Routing_Users'];
        return {
          index: i,
          date: metric.Date,
          count: metric['All_Routing_User_Count'],
          metric: metric,
        };
      }
      );

      this.model.set('lineValues', lineValues);
    },

    getCardInfo: function(licensedUserCount, maxUserCount, recordsRouted) {
      return [
        { title: 'Licensed Users', value: numberWithCommas(licensedUserCount) }, // hardcode value at least until user provisioning is ready
        { title: 'Unique Users', value: numberWithCommas(maxUserCount) },
        { title: 'Records Routed', value: numberWithCommas(recordsRouted) },
      ];
    },

    getLegendInfo: function() {
      return [
        'Active Users/Queues',
        'Licensed Users',
      ];
    },

    renderLineGraph: function() {
      const licensedUserCount = this.model.get('routingUserLicenseCount');
      const totalMaxUserCount = Magellan.Util.shortenNumbers(this.model.get('userCount'));
      const totalRecordsRouted = this.model.get('recordsRouted')['total'];

      this.lineGraphView = new LineGraphView({
      cardInfo: this.getCardInfo(licensedUserCount, totalMaxUserCount, totalRecordsRouted),
      legendInfo: this.getLegendInfo(),
      graphLines: {}, // initialize with empty object first and manually set graphlines below
      params: {
        width: 1050,
        height: 350,
        margin_top: 10,
        margin_left: 15,
        margin_bottom: 30,
        margin_right: 30,
        tick_format_x: d3.timeFormat("%m/%d"),
        tick_format_y: function(y) { return Math.floor(y) == y ? y : undefined; },
        get_data_x: function(p) { return p.date; },
        get_data_y: function(p) { return p.count; },
        transition_time: this.firstTimeGraphRender ? 700 : 0
      }
      });
      this.$el.find('.line-graph-wrapper').html(this.lineGraphView.$el);

      const lineValues = this.model.get('lineValues');
      if (lineValues != undefined) {
        // get variables
        const startDate = this.model.get('startDate');
        const endDate = this.model.get('endDate');
        const licensedUsersCount = this.model.get('routingUserLicenseCount');

        this.firstTimeGraphRender = false;
        this.lineGraphView.createAndSetGraphLine(startDate, endDate, licensedUsersCount, lineValues, []);
        this.lineGraphView.updateGraph();
      }
    }
  });
}
