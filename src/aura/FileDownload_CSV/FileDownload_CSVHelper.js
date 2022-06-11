({
    
    pollApex : function(component, event, helper) {
        
        helper.callApexMethod(component,event);
        
        var Interval =  window.setInterval(
            $A.getCallback(function() { 
                var etts = component.get('v.isComplete');
                helper.callApexMethod(component,event,Interval);
                if(etts)
                {
                    window.clearInterval(Interval);
                    return;
                }
            }), 5000
        );  
        
    },
    
    
    callApexMethod : function(component, event,Interval) {
        //call apex class method
        
        var showResult = component.get('v.showResult');
        var ResultID =  component.get('v.ResultID');
        var BatchStatus ;
        if(showResult)
        {
            var action1 = component.get('c.getBatchStatus');
            action1.setParams({ 
                BatchJobID : ResultID 
            } );
            action1.setCallback(this, function(response1){
                //store state of response
                var state = response1.getState();
                if (state === "SUCCESS") {
                    //set response value in ListOfContact attribute on component.
                    var BatchStatus = response1.getReturnValue();
                    component.set('v.ListOfBatchResult', BatchStatus);
                    if(BatchStatus.Status == 'Completed' )
                    {
                        
                        var action = component.get('c.fetchParseResult');
                        action.setParams({ 
                            BatchJobID : ResultID 
                        } ); 
                        action.setCallback(this, function(response){
                            //store state of response
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                //set response value in ListOfContact attribute on component.
                                var returnrecord = response.getReturnValue();
                                component.set('v.isComplete', true);
                                component.set('v.isDownloadResult', true);
                                var vSuccessCount=0 ;
                                var FailCount=0 ;
                                for(var strerror in returnrecord) 
                                {
                                    if(returnrecord[strerror].IsError__c == true)
                                    {
                                        component.set('v.Message', 'Please Download the file to see the failed record');
                                        FailCount ++;
                                    }
                                    if(returnrecord[strerror].IsError__c == false)
                                    {
                                        component.set('v.Message', 'Please Download the file to see the success record');
                                        vSuccessCount++
                                    }
                                    
                                }  
                                component.set('v.SuccessCount', vSuccessCount);
                                component.set('v.FailCount', FailCount);
                                
                                
                                component.set('v.ListOfParseResult', response.getReturnValue());
                                
                                
                                
                            }
                        });
                        $A.enqueueAction(action);
                        
                    }
                    
                    
                }
            });
            $A.enqueueAction(action1);
            
        }
    },
    
    convertArrayOfObjectsToCSV1 : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        //component.set("v.Spinner", true);
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header  
        keys = ['Salesforce_ID__c', 'Result__c', 'Status__c', 'Field_Name__c' ];
        
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                
                // add , [comma] after every String value,. [except first]
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }   
                if(objectRecords[i][skey] == undefined)
                    csvStringResult += '"NA"'; 
                else
                    csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
                
                counter++;
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        
        // return the CSV formate String 
        return csvStringResult;        
    },
})