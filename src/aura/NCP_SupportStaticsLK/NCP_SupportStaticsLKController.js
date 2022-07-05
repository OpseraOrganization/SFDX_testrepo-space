({
    doInit: function(cmp, evt, hlp) {
        var action = cmp.get('c.getArticle');
        action.setParams({
            articleTitle: 'General Support FAQ'
        });
        action.setCallback(this, function(resp) {
            if (resp.getState() === 'SUCCESS') {
                var targetTag = cmp.find('bodyCopy').getElement();
                var pageContent = resp.getReturnValue();
                cmp.set('v.pageTitle', pageContent.Title);
                var formattedCopy = hlp.formatBodyCopy(cmp, pageContent.Details__c);
                targetTag.innerHTML = formattedCopy;
            } else {
                var toastEvent = $A.get('e.force:showToast');
                toastEvent.setParams({
                    mode: 'sticky',
                    title: 'Problem loading content',
                    type: 'error',
                    message: resp.getError()[0].message
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
});