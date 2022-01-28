({    
    fetchPickListValforclassification: function(component, fieldName, elementId) {
        var action = component.get("c.getselectOptions");
        action.setParams({ 
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                if (allValues != undefined && allValues.length > 0) {
                    /*opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }*/
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
            }
                component.find(elementId).set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },    
    MAX_FILE_SIZE: 5368709120,//5*1024*1024*1024  5GB=5368709120 1GB=1073741824
    CHUNK_SIZE: 4720000,//1MB=1000kb=1000*1024=1024000bytes //5120000
    uploadHelper : function(component, event) {
        // start/show the loading spinner   
        component.set("v.showLoadingSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showLoadingSpinner", false);
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents);
        });
        objFileReader.readAsDataURL(file);
    },
    uploadProcess: function(component, file, fileContents) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        var partNumber = 1;
        //var uploadId = '';
        var isLastChunk = false;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '', partNumber, isLastChunk);
    },
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId, partNumber, isLastChunk) {
        // call the apex method 'saveChunk'
        var description 			= component.find("descriptionfield");
        var descriptionValue 		= description.get("v.value");
        var classification			= component.find("classification");
        var classificationValue 	= classification.get("v.value");
        var getchunk = fileContents.substring(startPosition, endPosition);
        if(fileContents.length == endPosition){
            isLastChunk = true;
        }
        var action = component.get("c.saveChunk");
        var partNumber = partNumber;
        action.setParams({
            caseRecordId: component.get("v.recordId"),
            customervisible: document.getElementById("checkbox-1").checked,
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId,
            desfield:description.get("v.value"),
            classfield : classificationValue,
            fileSize: file.size,
            partNumber: partNumber,
            isLastChunk : isLastChunk,
            wrapperFromJs: JSON.stringify(component.get("v.uploadWrapper")) 
        });     	
        action.setCallback(this, function(response) {
            var wrapResponse = response.getReturnValue();
            component.set("v.uploadWrapper",wrapResponse);
            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition  < endPosition) {
                    startPosition = startPosition + 1;
                    partNumber = partNumber + 1;
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId, partNumber, isLastChunk);
                } else {
                    component.set("v.showLoadingSpinner", false);
                    description.set("v.value",null);
                    classification.set("v.value",null);
                    document.getElementById("checkbox-1").checked = false;
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success Message',
                        message: 'Your File is uploaded Successfully.',
                        messageTemplate: 'Record {0} created! See it {1}!',
                        duration:' 5000',
                        type : 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    component.set("v.fileName", " ");
                    var appEvent = $A.get("e.c:CH_UploadEvent");
                    appEvent.fire();
                }
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.log('errors>>>'+errors);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'An internal server error has occurred',
                            message: 'Your File Failed to Upload.Please refresh the Page',
                            type : 'Error',
                            mode: 'sticky'
                        });
                        toastEvent.fire();
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
    isCommunity: function(component) {
        var action = component.get("c.isCommunity");
        action.setCallback(this, function(response) {
            component.set("v.isCommunity", response.getReturnValue());
            //var isCommunity = response.getReturnValue(); 
        });
        $A.enqueueAction(action);
	}

})