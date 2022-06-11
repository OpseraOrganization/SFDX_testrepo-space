({
    doInit: function (cmp, evt, hlp) {
        hlp.checkAuth(cmp);
        hlp.checkIfUserIsCompetitorUser(cmp);
        hlp.getLoginURL(cmp);
    },
    profileDetailsReceived: function (cmp, evt, hlp) {
        var evtParams = evt.getParams();
        if (evtParams.changeType === 'LOADED') {
            hlp.fullyInitialised(cmp);
        } else {
            // console.log('Problem with loading user profile');
        }
    },
    itemSelected: function (cmp, evt, hlp) {
        if (evt) {
            evt.preventDefault();
            evt.stopPropagation();
        }
        var value = evt.target.dataset.menuItemValue;
        var link = hlp.getLinkFromValue(cmp, value);
        var urlEvent = $A.get('e.force:navigateToURL');
        
        if(value === 'changePassword'){
            window.location.replace(link);
        } else if (value !== 'logout') {
            if(value=='secondaryAccount'||value=='admin'||value=='changePassword'||value=='subscriptions')
            {
                window.open(link,'_self');
            }
            else{
                urlEvent.setParams(
                    {url: link}
                );
                urlEvent.fire();
            }
            
        } else {
            var action = cmp.get("c.fetchURL");
            action.setCallback(this,function(response) {
                var state = response.getState();
                if (state === "SUCCESS") { 
                    var logoutURL = response.getReturnValue()+'/secur/logout.jsp';
                    window.location.replace(logoutURL);
                }
            });
            $A.enqueueAction(action);
            /*var communityName;
            var URL;
            if (window.location.pathname.split('/')[1] !== 's') {
                communityName = window.location.pathname.split('/')[1];
                URL = window.location.origin + '/' + communityName + '/secur/logout.jsp';
            } else {
                communityName = '';
                URL = window.location.origin + '/secur/logout.jsp';
            }
            window.location.replace(URL);
            */
        }
        
        hlp.toggleMenu(cmp);
    },
    toggleProfileMenu: function (cmp, evt, hlp) {
        hlp.toggleMenu(cmp, evt);
    },
    doLogIn: function (cmp, evt, hlp) {
        debugger;
        var url = cmp.get('v.loginRedirectURL');
        /*var urlEvent = $A.get('e.force:navigateToURL');
        urlEvent.setParams({
            'url': '../login/',
            "isredirect" :false
        });
        urlEvent.fire();*/
        var link = url;
        window.open(link,'_self');
    }
});