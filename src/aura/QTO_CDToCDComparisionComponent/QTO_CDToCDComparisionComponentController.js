({
	populateCompareScreen : function(component, event, helper) {
        console.log('populate called');
	    component.set("v.isOpen", true);
        console.log('populate called');
        
	},
    closeModel: function(component, event, helper) {
    // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   },
 
   likenClose: function(component, event, helper) {
      // Display alert message on the click on the "Like and Close" button from Model Footer 
      // and set set the "isOpen" attribute to "False for close the model Box.
      alert('thanks for like Us :)');
      component.set("v.isOpen", false);
   },
    recordUpdated : function(component, event, helper) {
        console.log('record updated');
        console.log('record updated1',  component.get('v.associationRecord'));
        console.log('record updated1',  component.get('v.associationRecord.Name'));
        component.set('v.associationName', component.get('v.associationRecord.Name'));
    }
})