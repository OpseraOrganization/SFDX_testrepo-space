({
    // $Label.c.NCP_home_page_name;
    onClick: function(cmp, evt, hlp) {
        var id = evt.target.dataset.menuItemId;
        var menuItems = cmp.get('v.shadowMenuItems');
        if (id) {
            cmp.getSuper().navigate(id);
            cmp.set('v.currentMenuItemLabel', menuItems[id].label);
            if (cmp.get('v.isDevice')) {
                // hide the menu
                hlp.toggleMenu(cmp);
            }
        }
    },
    toggleMenu: function(cmp, evt, hlp) {
        hlp.toggleMenu(cmp);
    },
    menuItemsChanged: function(cmp, evt) {
        var menuItems = evt.getParam('value');
        // Possibility here to change the label
        menuItems.forEach(function(item) {
            if (item.label === 'Home') {
                item.label = $A.get('$Label.c.NCP_home_page_name');
            }
            if (item.active) {
                cmp.set('v.currentMenuItemLabel', item.label);
            }
        });
        if (!cmp.get('v.currentMenuItemLabel')) {
            cmp.set('v.currentMenuItemLabel', '•••');
        }
        cmp.set('v.shadowMenuItems', menuItems);
    }
});