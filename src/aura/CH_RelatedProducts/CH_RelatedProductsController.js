({
	doInit : function(component, event, helper) {
        const objectName = component.get('v.sObjectName');
        let tableColumns = [];
        switch(objectName) {
            default:
               tableColumns = [
                    {label: 'Name', fieldName: 'RecordURL', type: 'url', sortable: 'true', searchable: 'true', typeAttributes: {
                        label: { fieldName: 'Name' }
                    }},
                    {label: 'State', fieldName: 'State', type: 'text', sortable: 'true', searchable: 'true'},
                    {label: 'Type', fieldName: 'Type', type: 'text', sortable: 'true', searchable: 'true'},
                    {label: 'Relation Type', fieldName: 'RelationType', type: 'text', sortable: 'true', searchable: 'true'},
                    {label: 'Product Code', fieldName: 'ProductCode', type: 'text', sortable: 'true', searchable: 'true'},
                    {label: 'C10 (Obsolete) Scheduled', fieldName: 'C10Scheduled', type: 'date', sortable: 'true', searchable: 'true', typeAttributes:{
                        year: "numeric",
                        month: "2-digit",
                        day: "2-digit",
                        hour: "2-digit",
                        minute: "2-digit"
                    }},
                    {label: 'NSN Code', fieldName: 'NSNCode', type: 'text', sortable: 'true', searchable: 'true'},
                    {label: 'Portofolio Classification', fieldName: 'PortfolioClassification', type: 'text', sortable: 'true', searchable: 'true'},
                    {label: 'Addition Classification', fieldName: 'AdditionClassification', type: 'text', sortable: 'true', searchable: 'true'},                    
                ];
                break;
        }
        component.set('v.tableColumns', tableColumns);
        helper.apexAction(component, "c.getProductRelated", { objectName : objectName, recordId : component.get("v.recordId"), type : component.get("v.type") }, true)
        .then(relatedProducts => component.set("v.relatedProducts", relatedProducts.map(cur => (cur.RecordURL = '/one/one.app?#/sObject/' + cur.Id + '/view', cur))));
		helper.setTabIcon(component);
	},
    handleGlobalAction : function(component, event, helper) {
        switch(event.getParam('action')) {
            case 'refresh':
                $A.get('e.force:refreshView').fire(); 
                break;
            case 'viewAll':
                var event = $A.get("e.force:navigateToComponent");
                event.setParams({
                    componentDef: "c:CH_RelatedProducts",
                    componentAttributes:{
                        sObjectName : component.get('v.sObjectName'),
                        recordId : component.get("v.recordId"),
                        type : component.get("v.type"),
                        viewAll: true
                    }
                });
                event.fire();
                break;
        }
	},
})