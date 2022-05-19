({
    
    doInit : function (cmp) {
        var probid=cmp.get("v.problemId"); 
        console.log("recordtype id is :"+probid);
        var action1= cmp.get("c.transfercaseornot");
        action1.setParams({ recordId : cmp.get("v.problemId") });
        action1.setCallback(this, function(response) {
            var state = response.getState();
            console.log("stored response is :"+state);
            if (state === "SUCCESS") {  
                var storeResponse = response.getReturnValue();
                var checkresponse=storeResponse;
                console.log("stored response is :"+storeResponse);
                
                if(storeResponse=="true")
                {
                    console.log("i am in if");
                    var probstat="SupportTicket";
                    var action= cmp.get("c.transferProblemDetailsQuery");
                    action.setParams({ recordId : cmp.get("v.problemId") });
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            var flow = cmp.find("flow");
                            var storeResponse = response.getReturnValue();
                            var recordtypename=storeResponse.RecordType.Name;
                            var currentWorkGroup = null;
                            var AccountCountry='';
                            var RecordtypeId = storeResponse.RecordTypeId;
                            
                            if(storeResponse.CH_Workgroup__c ==undefined){
                                storeResponse.CH_Workgroup__c = null;
                                currentWorkGroup ='';
                            }else{
                                currentWorkGroup = storeResponse.CH_Workgroup__r.Name 
                            }
                            var AssignedToUser = false;
                            var AssignedUser = storeResponse.Owner.Name;
                            if(storeResponse.CH_CurrentQueue__c !=null){
                                AssignedToUser = false;
                                AssignedUser = storeResponse.CH_CurrentQueue__c;
                            }else {
                                AssignedToUser = true;
                            }
                            if(storeResponse.ACcountID !=null){
                                AccountCountry = storeResponse.Account.BillingCountry;
                            }
                            //alert(AccountCountry);
                            var inputVariables = [
                                {
                                    name : 'RecordId',
                                    type : 'String',
                                    value : cmp.get("v.problemId")
                                },
                                {
                                    name : 'Recordtypename',
                                    type : 'String',
                                    value : recordtypename
                                },
                                
                                {
                                    name : 'RecordtypeId',
                                    type : 'String',
                                    value : RecordtypeId
                                },
                                {
                                    name : 'ProblemType',
                                    type : 'String',
                                    value : probstat
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
                                }
                                ,
                                
                                {
                                    name : 'AccountCountry',
                                    type : 'String',
                                    value : AccountCountry
                                }
                                ,
								
                                {
                                    name : 'solutionTargetDate',//Changes added for NOKIASC-35322
                                    type : 'DateTime',
                                    value : cmp.get("v.solutionTargetDate")
                                }
								 ,
                                
                                {
                                    name : 'pausedSinceDate',//Changes added for NOKIASC-35322
                                    type : 'DateTime',
                                    value : cmp.get("v.pausedSinceDate")
                                }
                                
                            ];
                            flow.startFlow("CH_CreateProblemFromIncidentnProduct",inputVariables);
                            
                        }
                    } );
                    //var flow = cmp.find("flow");
                    
                    
                    $A.enqueueAction(action);
                }
                
                else if(storeResponse=="false"){
                    console.log("i am in else"); 
                    
                    var probstatval="NewProblem";
                    console.log("product id"+cmp.get("v.problemId"));
                    var action2= cmp.get("c.transferNewProblemDetailsQuery");
                    action2.setParams({ recordId : cmp.get("v.problemId") });
                    action2.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            cmp.set("v.isNewProblem",true);
                            var flow = cmp.find("flow1");
                            var storeResponse = response.getReturnValue();
                            var recordtypename=storeResponse.RecordType.Name;
                            var RecordtypeId = storeResponse.RecordTypeId;
                            //alert(RecordtypeId);
                            var inputVariables = [
                                {
                                    name : 'RecordId',
                                    type : 'String',
                                    value : cmp.get("v.problemId")
                                },
                                {
                                    name : 'Recordtypename',
                                    type : 'String',
                                    value : recordtypename
                                },
                                {
                                    name : 'RecordtypeId',
                                    type : 'String',
                                    value : RecordtypeId
                                },
                                {
                                    name : 'ProblemType',
                                    type : 'String',
                                    value : probstatval
                                }
                                
                            ];
                            flow.startFlow("CH_CreateProblemFromIncidentnProduct",inputVariables);
                            
                        }
                    } );
                    //var flow = cmp.find("flow");
                    
                    
                    $A.enqueueAction(action2);
                    
                }            
                
            }
            
        });
        $A.enqueueAction(action1);
        
        
    },
    
    statusChange : function (cmp, event) {
        if (event.getParam('status') === "FINISHED") {
            if(!cmp.get("v.isNewProblem")){
                  cmp.destroy();
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
                //refresh
            }else{
                $A.get("e.force:closeQuickAction").fire();
				 $A.get('e.force:refreshView').fire();
            }
             
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
            
            
            
        }
    },
    close: function (component, event, helper) {
        component.destroy();
         $A.get('e.force:refreshView').fire();
    },
})