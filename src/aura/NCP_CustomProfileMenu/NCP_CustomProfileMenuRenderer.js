({
 afterRender: function (cmp, hlp) {
        var afterRend = this.superAfterRender();
        hlp.attachEventMenu(cmp);
        return afterRend;
    }
})