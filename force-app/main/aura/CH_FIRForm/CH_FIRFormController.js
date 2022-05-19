({
	doInit : function(component, event, helper) {
		helper.apexAction(component, "c.getFIRQuestions", null, true)
        .then(res => {
            component.set('v.questions', res.map((c) => (c.options = helper.splitValues(c.PicklistValues__c),c)));
            helper.setAnswers(component, res.map((c) => (delete c.Id, c.CustomerAnswer__c = '', c.PicklistAnswer__c = '', c)));
        });
	},
	getAnswers : function(component, event, helper) {
        return component.get('v.answers');
	},
	changeHandler : function(component, event, helper) {
        const { localName, value, dataset } = event.srcElement;
        let answers = component.get('v.answers');
        switch(localName) {
            case 'select':
                answers[dataset.target].PicklistAnswer__c = value ? value : '';
                break;
            case 'textarea':
                answers[dataset.target].CustomerAnswer__c = value ? value : '';
                break;
        }
        helper.setAnswers(component, answers);
	},
})