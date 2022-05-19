({
    myAction : function(component, event, helper) {
        var Id = component.find("Id");
        $A.util.toggleClass(Id, "toggle");
        var country = component.find("country").get("v.value");
        var stateValue = component.get("c.getStateValues");
        var optsstate=[];
        //Set the country parameter for getting related state values
        stateValue.setParams({
            "country" : country
        });       
        //Method to get the related State field values for the selected country
        stateValue.setCallback(this, function(a) {
            var pickVal = component.find('state').get('v.value');
            var isError = false;
            for(var i=0;i< a.getReturnValue().length;i++){
                try{
                    if(pickVal.indexOf("undefined") == -1) {
                    }
                }catch(err) {
                    isError=true
                    optsstate.push({value:a.getReturnValue()[i],label:a.getReturnValue()[i],selected:''});
                }
                if(!isError) {
                    optsstate.push({value:a.getReturnValue()[i],label:a.getReturnValue()[i],selected:pickVal.includes(a.getReturnValue()[i])});
                }
            }
            component.set("v.optState",optsstate);
        });
        $A.enqueueAction(stateValue);
        var distributor = component.get("c.getDistributors");
        var optsdist=[];
        
        //Set coutry parameter to get the related distributor values
        distributor.setParams({
            "countryDis" : country
        });
        
        //Method call to backend to get the related distributor for the Country
        distributor.setCallback(this, function(a) {
            var pickVal = component.get('v.sectionLabels.distributor');
            for(var i=0;i< a.getReturnValue().length;i++){
                optsdist.push({"label":a.getReturnValue()[i],"value":a.getReturnValue()[i]});
            }
            component.set("v.optDistributor",optsdist);
      	});
        $A.enqueueAction(distributor);
        
    }  ,
    
    //Handle Successfull upload of file
    handleUploadFinished : function(component, event, helper){
         var fileId = event.getParam("files");
         if(!component.get("v.sectionLabels.uploadFileId")){
             component.set("v.sectionLabels.uploadFileId", []);
         }
        if(!component.get("v.sectionLabels.fileNames")){
            component.set("v.sectionLabels.fileNames", []);
        }
         //Track the Id of uploaded file
         component.get("v.sectionLabels.uploadFileId").push(fileId[0].documentId);
         //Track File Name
         var fileNames = component.get("v.sectionLabels.fileNames");
         fileNames.push(fileId[0].name);
         component.set("v.sectionLabels.fileNames", fileNames);
        
         console.log(JSON.stringify(component.get("v.fileNames")));
         //Show success message for uploading the file
         var toastEvent = $A.get("e.force:showToast");
         toastEvent.setParams({
             title: "Success!",
             message: 'Attachment has been uploaded successfully',
             duration:'5000',
			 key: 'info_alt',
			 type: 'success',
			 mode: 'pester'
    	});
        toastEvent.fire();
        
        
    }
})