({
    gotoStep2: function(component, event, helper) {
        component.set("v.StageNumber", 2);
    },
    gotoStep3: function(component, event, helper) {
        component.set("v.StageNumber", 3);
    },
    open1:  function(component, event, helper) {
        component.set("v.StageNumber", 1);
    },
    open2:  function(component, event, helper) {
        component.set("v.StageNumber", 2);
    },
    closeFlow: function(component, event, helper) {
        alert("I am closing bye bye");
    },
    submit:function(component, event, helper) {
        alert("I am Done Bye");
    },
    
})