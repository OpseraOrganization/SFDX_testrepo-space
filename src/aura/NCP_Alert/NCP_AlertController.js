({
    doInit: function (cmp, evt, hlp) {
        var urgency = cmp.get('v.urgency').toLowerCase();
        var styleString = cmp.get('v.styleString');
        cmp.set('v.styleString', styleString + ' ' + hlp.types[urgency]);
        cmp.set('v.icon', hlp.icons[urgency]);
    },
    hideSelf: function (cmp) {
        cmp.destroy();
    }
})