({
    init: function(cmp, evt, hlp) {
        var myPageRef = cmp.get("v.pageReference");
        var name = myPageRef && myPageRef.state ? myPageRef.state.c__recordId : "";
        cmp.set("v.recordId", name);
        cmp.set("v.refresh", true);
		//34690
        var hwsCase = myPageRef && myPageRef.state ? myPageRef.state.c__isHWSCase : false;
        cmp.set("v.isHWSCase", hwsCase);
    },
    handlePageChange: function(cmp, evt, hlp) {
        var myPageRef = cmp.get("v.pageReference");
        var name = myPageRef && myPageRef.state ? myPageRef.state.c__recordId : "";
        cmp.set("v.recordId", name);
        cmp.set("v.refresh", true);
    }
})