({
    init: function(cmp, evt, hlp) {
        var myPageRef = cmp.get("v.pageReference");
        var name = myPageRef && myPageRef.state ? myPageRef.state.c__recordId : "";
        cmp.set("v.recordId", name);
        cmp.set("v.refresh", true);
    },
    handlePageChange: function(cmp, evt, hlp) {
        var myPageRef = cmp.get("v.pageReference");
        var name = myPageRef && myPageRef.state ? myPageRef.state.c__recordId : "";
        cmp.set("v.recordId", name);
        cmp.set("v.refresh", true);
    }
})