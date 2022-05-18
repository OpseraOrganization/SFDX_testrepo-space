({
    afterRender: function(component, helper) {
        var afterRend = this.superAfterRender();
        helper.attachEventListBox(component);
        helper.attachScrollListener(component);
        return afterRend;
    }
});