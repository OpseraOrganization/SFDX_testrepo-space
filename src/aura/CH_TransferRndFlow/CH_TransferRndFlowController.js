({
    
    doInit : function (cmp) {
        var action = cmp.get("c.transferRndFlowFieldsQuery");
       
        action.setParams({ caseId : cmp.get("v.problemId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var flow = cmp.find("flow");
                var storeResponse = response.getReturnValue();
                var currentWorkGroup = null;
                if(storeResponse.CH_Workgroup__c ==undefined){
                    storeResponse.CH_Workgroup__c = null;
                    currentWorkGroup ='';
                }else{
                   currentWorkGroup = storeResponse.CH_Workgroup__r.Name 
                }
                var AssignedToUser = false;
                var AssignedUser = storeResponse.Owner.Name;
               
                if(storeResponse.OwnerId.startsWith("005") && AssignedUser !='CH Queue'){
                    AssignedToUser = true;
                }
                var RDSubject ='';
                var RDDescription ='';
                //if(storeResponse.CH_CustomerDescription__c ==undefined){
                //    storeResponse.CH_CustomerDescription__c = null;
                //}else{
                //    RDDescription = storeResponse.CH_CustomerDescription__c;
                //}
               //NOKIASC-26230
			   if(storeResponse.CH_IssueDescription__c ==undefined){
                    storeResponse.CH_IssueDescription__c = null;
                }else{
                    RDDescription = storeResponse.CH_IssueDescription__c;
                }

                if(storeResponse.CH_RDInterface__c ==undefined){
                    storeResponse.CH_RDInterface__c = null;
                } else if (storeResponse.CH_RDInterface__c == 'JIRA' || storeResponse.CH_RDInterface__c == 'PRONTO') {
                    RDSubject = 'Problem ' + storeResponse.CaseNumber  + ': Transfer to ' + storeResponse.CH_RDInterface__c;
                }
                var inputVariables = [
                     {
                        name : 'RecordId',
                        type : 'String',
                        value : cmp.get("v.problemId")
                    },
                    {
                        name : 'AssignedToUser',
                        type : 'Boolean',
                        value : AssignedToUser
                    },
                    
                    {
                        name : 'AssignedUser',
                        type : 'String',
                        value : AssignedUser
                    },
                    
                    {
                        name : 'WorkGroupName',
                        type : 'String',
                        value : currentWorkGroup
                    },
                    {
                        name : 'RDSubject',
                        type : 'String',
                        value : RDSubject
                    },
                    {
                        name : 'RDDescription',
                        type : 'String',
                        value : RDDescription
                    },
                    
                    {
                        name : "Problem",
                        type : "SObject",
                        value : {"Id" : cmp.get("v.problemId")
                                }
                    }
                    
                ];
                flow.startFlow("CH_Transfer_To_R_D", inputVariables);
            }    
        });     
        $A.enqueueAction(action);
    },
    
    statusChange : function (cmp, event) {
        if (event.getParam('status') === "FINISHED") {
            cmp.destroy();
            $A.get('e.force:refreshView').fire();
        }
        
        if (event.getParam('status') === "STARTED") {
       
          var outputVariables = event.getParam("outputVariables");
            
            var outputVar;
            var rndId = null;
            for(var i = 0; i < outputVariables.length; i++) {
                outputVar = outputVariables[i];
                if(outputVar !=null && outputVar.name =='RnDId' && outputVar.value!=null){
                    
                    rndId= outputVar.value;
                    
                }
               
            }
            if(rndId !=null){
                
           var action = cmp.get("c.sendCreateAnalysisRndInteraction");
        action.setParams({ rndId : rndId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
            }   
        });     
        $A.enqueueAction(action);
            }
            
            
        }
    },
    close: function (component, event, helper) {
         component.destroy();
        $A.get('e.force:refreshView').fire();
    },
})