({
	download : function(text, name, type) {
    var a = document.createElement("a");
        console.log('text>>>'+text);
        console.log('name>>>'+name);
        console.log('type>>>'+type);
    //var file = new Blob([text], {type: type});
    var file = new Blob([text], {type : "application/json"});
    
    a.href = URL.createObjectURL(file);
    a.download = name;
    a.click();
	},
    quoteValue : function(component, event, helper){        
        var action = component.get("c.getQuoteName");
        var docName; 
        action.setParams({ recordId: component.get("v.recordId")})
        action.setCallback(this, function(response){
            var state = response.getState();        
            if (state === "SUCCESS"){  
                console.info('Successasdasd');                
                docName = response.getReturnValue();                
                //helper.download(doc, docName, 'html/json');
                console.info('docName>>'+docName);                
                component.set("v.quoteProposalList", docName);
                console.info("Result"+component.get("v.quoteProposalList"));
            }
            else{                 
                var errors = response.getError();
                if (errors){
                    console.info('Inside if of errors');
                    if (errors[0] && errors[0].message){
                        console.info("Error message: " + errors[0].message);
                    }
                }
            } 
        });
        $A.enqueueAction(action);
    }
})