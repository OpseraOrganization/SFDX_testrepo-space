({
	itemSelected : function(component, event, helper) {
		helper.itemSelected(component, event, helper);
	}, 
    serverCall :  function(component, event, helper) {
		helper.serverCall(component, event, helper);
	},
    clearSelection : function(component, event, helper){
        helper.clearSelection(component, event, helper);
    } ,
    getSelectedLookupValues:function(component, event, helper){
        var capturedCheckboxName = event.getSource().get("v.name");
        var capturedCheckboxId = event.getSource().get("v.value");
        var capturedCheckboxcheck = event.getSource().get("v.checked");
        var selectedCheckBoxes =  component.get("v.numbers");
        var selectedCheckID =  component.get("v.UserId");
         if (!Array.isArray(selectedCheckBoxes)) {
            selectedCheckBoxes = [selectedCheckBoxes];
        }
     /* if(event.getSource()){
          
         if(selectedCheckBoxes.indexOf(capturedCheckboxName) > -1){  
           
            selectedCheckBoxes.splice(selectedCheckBoxes.indexOf(capturedCheckboxName), 1); 
            selectedCheckID.splice(selectedCheckID.indexOf(capturedCheckboxId), 1); 
        }
       else{
           if(capturedCheckboxcheck == true){
            selectedCheckBoxes.push({
                    value: capturedCheckboxName,
                });
            
            //selectedCheckBoxes.push(capturedCheckboxName);
            selectedCheckID.push({
                    value: capturedCheckboxId,
                });
            //selectedCheckID.push(capturedCheckboxId);
           }
           }
        }      */
       
           var checkedValue=event.getSource();
        if (!Array.isArray(checkedValue)) {
            checkedValue = [checkedValue];
        }
        for(var i=0;i<checkedValue.length;i++)
        {
            if(checkedValue[i].get("v.checked") == true){
                 selectedCheckBoxes.push({
                    value: checkedValue[i].get("v.name"),
                });
                selectedCheckID.push({
                    value: checkedValue[i].get("v.value"),
                });
            }else{
                
            }
        }
        //alert(checkedValue)
       
     
        component.set("v.numbers", selectedCheckBoxes);
        component.set("v.UserId",selectedCheckID);
    },
    handleRemoveOnly : function(component, event, helper){
       var valuesPill=event.getSource().get("v.label");
        var numbers=component.get("v.numbers");
        var userId=component.get("v.UserId");
        for(var i=0;i<numbers.length;i++){
            if(numbers[i].value == valuesPill){
               numbers.splice(i,1);
                userId.splice(i,1);
                    break;
            }
        }
     component.set("v.numbers",numbers);  
     component.set("v.UserId",userId);
    }
})