({
 getCookie:function(cookiename) {        
        console.log('getCookie :: ',cookiename);
        var name = cookiename + "=";
        var ca = document.cookie.split(';');
        for(var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) == 0) {
                return c.substring(name.length, c.length);
            }
        }
        return "";
    },
    
    createCookie:function (name,value,days) {
      if (days){
        var date = new Date();
        date.setTime(date.getTime()+(days*365*24*60*60*1000));
        var expires = "; expires="+date.toGMTString();
      }else 
          var expires = "";
          document.cookie = name + "=" + value + ";" + expires + ";domain=.nokia.com;path=/";
		//document.cookie = name + "=" + value + ";" + expires + ";domain=.force.com;path=/";
        //document.cookie = name+"="+value+expires+"; path=.nokia.com/";
        //document.cookie = name+"="+value+expires+"; path=/; HttpOnly; secure;";
        console.log('createCookie>> :: ',document.cookie);
    } 
})