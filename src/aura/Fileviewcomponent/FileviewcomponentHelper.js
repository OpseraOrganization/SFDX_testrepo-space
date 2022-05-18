({
	attatchmentlist : function(component, event, helper) {
        var action = component.get("c.getattachment");
        var account = component.get("v.recordId");
        action.setParams({
            accounts : account
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var contacts = response.getReturnValue();
                
                contacts.forEach(function(record){
                    console.log('filetype:' + record.ContentDocument.FileType);
                    if(record.ContentDocument.FileType === "CSV"){
                        record.displayIconName = "doctype:csv";
                    }
                }); 
                component.set("v.attachmentslist",contacts);
                console.log(contacts);
            }
            else{
                alert("error in getting contacts");
            }
        })
        
        $A.enqueueAction(action);
    },
    getfiles : function(component, event, helper) {
        var action = component.get("c.getattachment");
         
         var recordid = component.get('v.recordId');
         console.log('recordid:' + recordid);
         
         action.setParams({
             idlist : recordid
         })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var output = response.getReturnValue();
                
                output.forEach(function(record){
                    console.log('filetype:' + record.ContentDocument.FileType);
                    record.formattedDate = $A.localizationService.formatDate(record.ContentDocument.CreatedDate, "dd-MMM-yyyy")
                    switch(record.ContentDocument.FileType){
                        case 'CSV':
                        	record.displayIconName = "doctype:csv";
                            break;
                        case 'PDF':
                          	record.displayIconName = "doctype:pdf";
                            break;
                        case 'WORD_X':
                            record.displayIconName = "doctype:word";
                            break;
                        case 'TEXT':
                            record.displayIconName = "doctype:txt";
                            break;
                        case 'PPT':
                            record.displayIconName = "doctype:ppt";
                            break;
                        case 'ZIP':
                            record.displayIconName = "doctype:zip";
                            break;
                        case 'EXCEL_X':
                            record.displayIconName = "doctype:excel";
                            break;    
                        default:
                            record.displayIconName = "doctype:unknown";
                    }
                    
                }); 
                component.set('v.lstContentDoc', output);
                console.log('responsefromaoex: ' + output);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
         $A.enqueueAction(action);
    },
    getcountoffiles : function(component, event, helper){
    var action = component.get("c.getcount");
    var recordid = component.get('v.recordId');
         action.setParams({
             idlist : recordid
         })
         action.setCallback(this, function(response) {
            var state = response.getState();
             if (state === "SUCCESS") {
                var cnt = response.getReturnValue();
                 component.set('v.countoffiles',cnt);
             }
         })
       
         $A.enqueueAction(action);
    }
})