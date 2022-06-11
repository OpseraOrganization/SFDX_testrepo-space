({
        
    getData : function(component, event, helper) {        
        helper.quoteValue(component, event, helper);
        console.log('test');
        var action = component.get("c.UpsertQuote");
        var doc;          
        action.setParams({ recordId: component.get("v.recordId")})
        action.setCallback(this, function(response) {            
            var state = response.getState();        
            if (state === "SUCCESS"){  
                console.info('Success');                
                doc = response.getReturnValue();                
                var quoteProposal = component.get("v.quoteProposalList");
				console.info("quoteProposal"+quoteProposal);
                helper.download(doc,quoteProposal, 'html/json');
                console.info('doc1>>'+doc);
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
    },     
})