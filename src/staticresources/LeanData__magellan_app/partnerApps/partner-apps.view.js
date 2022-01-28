// TODO - Move PartnerAppsConfigPage into its own page/url. There's barely
//        any shared functionality between the two. (Literally only the title
//        "Partner Apps".)
module.exports = function() {
  const PartnerCard = require('./partnerCard/partner-card.view')();
  const PartnerAppsConfigPage = require('./partnerAppsConfigPage/partner-apps-config-page.view')();

  return Backbone.View.extend({
    template: _.template(require('./partner-apps.template.html')),
    initialize: function(params) {
      // fetch data and update model here
      this.parseDataAndUpdateModel(params);
      this.on('partnerCardClicked', this.partnerCardClickedHandler);
      this.render();
    },

    events: {
      'click #return-to-partner-apps': 'returnToPartnerApps'
    },

    parseDataAndUpdateModel: function(params) {
      console.log(params);
      let partnerList = [];
      let authorizedPartnerList = Object.keys(params.metadata.authorizedPartnerMetadata);

      for (let partnerName of Object.keys(params.metadata.configurationInstructions)) {
        // partnerList.push(JSON.parse(partnerName));
        let partnerData = JSON.parse(params.metadata.configurationInstructions[partnerName]);

        // has integration config data
        if (authorizedPartnerList.includes(partnerName)) {
          partnerData.isAuthorized = true;
          partnerData.authorizedDate =
            moment(params.metadata.partners[partnerName].AuthorizedDate)
            .format('MM/DD/YYYY hh:mm:ss A');
          partnerData.authorizedBy =
            params.metadata.partners[partnerName].LastModifiedByName;
          
          if(params.metadata.integrationConfig[partnerName]){
            partnerData.integrationConfig = JSON.parse(params.metadata.integrationConfig[partnerName]);
          } else if (partnerName === 'salesloft') {
            partnerData.integrationConfig = {
              applicationId: null,
              clientSecret: null,
              retryTime: 10,
              retryTimeUnit: 'Minutes',
            };
          }
        } else {
          if (partnerName === 'outreach') {
            partnerData.integrationConfig = {
              applicationId: null,
              clientSecret: null,
              leadProspectIdField: null,
              contactProspectIdField: null,
              userIdField: null,
              retryTime: 10,
              retryTimeUnit: 'Minutes',
            };
          } else if (partnerName === 'salesloft') {
            partnerData.integrationConfig = {
              applicationId: null,
              clientSecret: null,
              retryTime: 10,
              retryTimeUnit: 'Minutes',
            };
          }
        }
        // fieldMappingOptions - mapping of sobjects to fields
        partnerData.fieldMappingOptions = params.metadata.fieldMappingOptions;
        if (partnerName === 'outreach') {
          // mappingFields is really a poorly named variable for what fields
          // there are and which sobjects they belong to. anything populated by
          // the backend is bad. don't trust it. we'll have to refactor all of
          // it before we do more integrations.
          partnerData.mappingFields = [
            {
              name: 'Lead',
              sObject: 'lead',
              integrationConfigKey: 'leadProspectIdField',
            },
            {
              name: 'Contact',
              sObject: 'contact',
              integrationConfigKey: 'contactProspectIdField',
            },
            {
              name: 'User',
              sObject: 'user',
              integrationConfigKey: 'userIdField',
            },
          ];
        } else if (partnerName === 'salesloft') {
          partnerData.mappingFields = [];
        } else {
          // this isn't anything, TODO - remove later when we're not rushing
          // to do a release
          partnerData.mappingFields = params.metadata.mappingFields;
        }

        partnerList.push(partnerData);
      }

      this.model.set('partnersList', partnerList);
    },

    returnToPartnerApps: function() {
      this.model.set('selectedPartnerModel', []);
      this.model.set('selectedPartnerName', '');
      this.model.set('showPartnerCards', true);

      this.render();
    },

    partnerCardClickedHandler: function(params) {
      // params contain the unique identifier for whichever partner card was clicked
      const partner = this.model.get('partnersList').find((partner) => {
        return partner.partnerName === params;
      });

      if (partner !== undefined) {
        this.model.set('selectedPartnerModel', partner);
        this.model.set('selectedPartnerName', partner.partnerName);
        this.model.set('showPartnerCards', false);
        this.render();
      }
    },

    render: function() {
      const content = this.template({
        model: this.model.toJSON()
      });

      this.$el.html(content);

      if (this.model.get('showPartnerCards')) {
        this.model.get('partnersList').forEach((partner) => {
          const partnerCard = new PartnerCard({
            model: partner,
            parent: this
          });

          this.$el.find('.partner-apps-content').append(partnerCard.$el);
        });
        this.$el.find('.breadCrumbContainer').hide();
        this.$el.find('.partner-apps-summary').show();
      } else {
        let partnerAppsConfigPage = new PartnerAppsConfigPage({
          model: this.model.get('selectedPartnerModel'),
          parent: this
        });
        
        this.$el.find('.partner-apps-content').html(partnerAppsConfigPage.$el);
        this.$el.find('.breadCrumbContainer').show();
        // the partner-apps page and the partner config page are tightly
        // coupled. we will decouple in future, currently following set
        // paradigm
        this.$el.find('.partner-apps-summary').hide();
      }

      return this;
    }
  });
}
