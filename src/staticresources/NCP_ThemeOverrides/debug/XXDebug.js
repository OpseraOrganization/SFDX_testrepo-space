(function () {
    var timerObj = null;
    function attachErrorListener() {
        if (!timerObj) {
            debugger;
            timerObj = setInterval(function () {
                var errorMsg = document.getElementById('auraErrorMessage');
                if (errorMsg && errorMsg.innerText === 'CSS Error') {
                    debugger;
                }
            }, 5000)
        }
    }
    attachErrorListener();
}());