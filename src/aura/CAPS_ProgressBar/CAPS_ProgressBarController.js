({
	progressBarAction : function(component, event) {
        var params = event.getParam('arguments');
        if (params) {
            var setCounterVal = params.setCounterVal;
            setCounterVal = parseFloat(setCounterVal).toFixed(0);
            var isAbort = params.isAbort;
            var msg = params.msgVal + ' ';
           // alert('Progress bar--'+isAbort);
           // if(isAbort){
            //    component.set('v.msg',msg); 
           // }
            component.set('v.SetAbortVal',isAbort);
            component.set('v.msg',msg);
             window.setTimeout(
                 $A.getCallback(function() {
                     component.set('v.value',setCounterVal);
                 }), 50
             );
        }
    },
    
   
   
})