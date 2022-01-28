({
    afterRender: function(cmp, hlp) {
        this.superAfterRender();

        var deviceWidth = 0;
        var ticking = false;

        function doSomething(aDeviceWidth) {
            // do something with the scroll position
            hlp.sizeUpdate(cmp, aDeviceWidth);
        }

        function sizeListener() {
            deviceWidth = window.innerWidth;
            if (!ticking) {
                window.requestAnimationFrame(function() {
                    doSomething(deviceWidth);
                    ticking = false;
                });
                ticking = true;
            }
        }

        window.addEventListener('resize', sizeListener);
        sizeListener();
    },
    unrender: function() {
        this.superUnrender();
    }
});