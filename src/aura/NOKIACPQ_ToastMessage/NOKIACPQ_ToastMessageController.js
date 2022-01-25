({
    launchtoast:function(component, event, helper) {
        console.log('start');
        var args = event.getParam("arguments");
        var message = args.message;
        var success = args.isSuccess;
        console.log(success);
        var x = document.getElementById("toast");
        x.className = "show";
        if(success == "true"){
             x.style.backgroundColor = "#04844B";
        }else{
             x.style.backgroundColor = "#C23934";
        }
        var b = document.getElementById("desc")
        
        b.innerHTML = message;
        setTimeout(function(){ x.className = x.className.replace("show", ""); },7000); 
        
    },
    doInit:function(component, event, helper) {
       var message = component.get("v.message1");
        var success = component.get("v.success");
        console.log(success);
        var x = document.getElementById("toast");
        x.className = "show";
        if(success == "true"){
             x.style.backgroundColor = "#04844B";
        }else{
             x.style.backgroundColor = "#C23934";
        }
        var b = document.getElementById("desc")
        
        b.innerHTML = message;
        setTimeout(function(){ x.className = x.className.replace("show", ""); }, 7000); 
        
    },
    onRender:function(component, event, helper) {
        var x = document.getElementById("toast");
         x.className = "show";
        setTimeout(function(){ component.destroy(); }, 7000); 
    }
})