({
    init: function (cmp, event, helper) {
        var breadcrumbCollection = [
            {label: 'Technical Proposal', name: 'Technical Proposal'},
            {label: 'Digital Proposal', name: 'record' }
        ];

        cmp.set('v.breadcrumbCollection', breadcrumbCollection);
         
    },
    navigateTo: function (cmp, event, helper) {
        var name = event.getSource().get('v.name');

        switch(name) {
            case 'Technical Proposal':
                var url = 'https://ccpq1-nokiapartners.cs26.force.com/digitalsalesportal/s/technical-proposals?tabset-a20eb=2';
                cmp.set('v.urlToNavigate',url);
                return alert('Navigating to "Parent Entity"');
                
            case 'record':
                var tabURL = window.location.href;
                var res = tabURL.split("/");
                var recordId = res[6];
                var url = 'https://ccpq1-nokiapartners.cs26.force.com/digitalsalesportal/s/swx-upsell-proposal/'+recordId;
                cmp.set('v.urlToNavigate',url);
                return alert('Navigating to "Parent Record Name"');
        }
    },
    
    handleEvent : function(component, event, helper) {
        alert('test')
       
       }
})