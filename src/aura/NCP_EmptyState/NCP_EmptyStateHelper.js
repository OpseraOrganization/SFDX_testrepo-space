({
    // $Label.c.NCP_no_favourite_products_statement
    // $Label.c.NCP_no_favourite_products_action
    // $Label.c.NCP_no_services_statement
    // $Label.c.NCP_no_services_action
    types: {
        products: {
            icon: 'toolbox',
            fullType: 'Favorite Products',
            statement: 'NCP_no_favourite_products_statement',
            action: 'NCP_no_favourite_products_action',
            link: ''
        },
        services: {
            icon: 'folder',
            fullType: 'Services',
            statement: 'NCP_no_services_statement',
            action: 'NCP_no_services_action',
            link: ''
        }
    },
    setData: function (cmp) {
        var myType = cmp.get('v.myType');
        var myData = this.types[myType];
        if (!cmp.get('v.myIcon')) {
            cmp.set('v.myIcon', myData.icon);
        }
        if (!cmp.get('v.myStatement')) {
            cmp.set('v.myStatement', $A.get('$Label.c.' + myData.statement));
        }
        if (!cmp.get('v.myAction')) {
            cmp.set('v.myAction', $A.get('$Label.c.' + myData.action));
        }
        cmp.set('v.myFullType', myData.fullType);
    }
})