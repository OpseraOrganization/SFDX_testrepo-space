({
    toggleMenu: function(cmp) {
        var menuShowing = cmp.get('v.isMenuShowing');
        if (menuShowing) {
            this.hideMenu(cmp);
        } else {
            this.showMenu(cmp);
        }
    },
    showMenu: function(cmp) {
        var navMenu = cmp.find('ncp-customNavMenu').getElement();
        $A.util.removeClass(navMenu, 'slds-hide');
        $A.util.addClass(navMenu, 'slds-show');
        cmp.set('v.isMenuShowing', true);
    },
    hideMenu: function(cmp) {
        var navMenu = cmp.find('ncp-customNavMenu').getElement();
        $A.util.removeClass(navMenu, 'slds-show');
        $A.util.addClass(navMenu, 'slds-hide');
        cmp.set('v.isMenuShowing', false);
    },
    sizeUpdate: function(cmp, aNewSize) {
        var breakpoint = cmp.get('v.breakpoint');

        if (aNewSize >= breakpoint) {
            // need to make sure the menu isn't hidden on selection
            cmp.set('v.isDevice', false);
            cmp.set('v.currentWidth', aNewSize);
            // if the menu is hidden need to show it
            this.showMenu(cmp);
        } else {
            var currentWidth = cmp.get('v.currentWidth');
            cmp.set('v.isDevice', true);
            if (!currentWidth || aNewSize < currentWidth) {
                // first load so hide the menu
                this.hideMenu(cmp);
                cmp.set('v.currentWidth', aNewSize);
            }
        }
        // console.log(aNewSize);
    }
});