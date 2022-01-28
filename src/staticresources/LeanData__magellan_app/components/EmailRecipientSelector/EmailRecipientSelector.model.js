/* 
  RECIPIENT DATA
    notifyPostOwner: false,
    notifyPreOwner: false,
    notifyNewObjectOwner: false,
    emails: null,
    additionalObjectUserFields: [
      {
        userField: "someUserFieldName"
        objectType: "Lead"/"Contact"/"Account"/"Opportunity"
        contextType: "matched"/"created"
      },
      ...
   ]
*/
module.exports = function() {
  return Backbone.Model.extend({
    initialize: function(config) {
      // Defaults when model is initialized
      this.set(Magellan.Util.getDefaultNotificationSettings().recipients);
      // Set default config
      this.set(config);
      // Set specific defaults
      this.set('matchedObjectTypes', config.matchedObjectTypes || []);
      this.set('showOwnerOptions', _.isBoolean(config.notifyOwners) ? config.notifyOwners : true);
      this.set('showAdditionalObjectUserOptions', _.isBoolean(config.notifyAdditionalObjectUsers) ? config.notifyAdditionalObjectUsers : true);
      this.set('emails', config.emails || []);
      // For detecting when changes are made
      this.originalModel = _.cloneDeep(this.toJSON());
      // Detecting changes from original model
      var recipientKeys = Object.keys(Magellan.Util.getDefaultNotificationSettings().recipients);
      this.on('change', () => {
        Magellan.Validation.hasDirtyFormComponent = !recipientKeys.reduce((result, key) => {
          return result && _.isEqual(this.originalModel[key], this.get(key));
        }, true)
      });
    },
  });
}
