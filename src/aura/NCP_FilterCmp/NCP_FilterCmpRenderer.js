({
    afterRender: function (component, helper) {
        var afterRend = this.superAfterRender();
        helper.attachEventListBox(component);      
        return afterRend;
    }
})