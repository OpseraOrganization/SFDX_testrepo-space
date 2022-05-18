({
    //get the object type onLoad of the page
    doInit: function(component, event, helper) {
        helper.fetchPickListVal(component, event, helper);
    },
    
    //get the object type value and based on that get the objects to show
    onPicklistChange: function(component, event, helper) {
        component.set("v.isFileSelected", true);
        helper.fetchsObject(component, event, helper);
    },
    
    handleFilesChange: function(component, event, helper) {
        var fileName1 = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName1 = event.getSource().get("v.files")[0]['name'];
        }
        
        
        //var fileName2 =component.find("fileId").get("v.files")[0]['si'];
        //   console.log('Please Select File'+fileName2.size);
        
        
        if(component.find("fileId").get("v.files").length > 0)
        {
            component.set("v.isFileSelected", false);
            component.set("v.fileName", fileName1);
        }
        else 
        {
            component.set("v.isFileSelected", true);
            component.set("v.isShowError", true);
            component.set("v.ShowMessage", 'Please Select File');
            component.set("v.fileName", 'No File Selected..');
            //alert('Please Select File');
        }
        var vFileExtension = fileName1.lastIndexOf('.');
        var vgetExtension = fileName1.substring(vFileExtension + 1);
        if(vgetExtension != 'csv') 
        {
            component.set("v.isFileSelected", true);
            component.set("v.isShowError", true);
            component.set("v.ShowMessage", 'Please Select CSV File');
            component.set("v.fileName", 'No File Selected..');
            //alert('Please Select CSV File');
        }
    },
    
    Insert: function(component, event, helper) {
        if(component.find("idObject").get("v.value") == undefined)
        {
            component.set("v.ShowMessage", 'Please Select Object');
            //  alert('Please Select Object');
            component.set("v.isShowError", true);
            component.set("v.isUploadFile", true);
            return ;
        }
        
        var vDMLOperation = component.find("idDML").get("v.value");
        
        var fileButton =component.find("fileId").get("v.files")[0];
        component.set("v.Spinner", true);
        if (fileButton) {
            var reader = new FileReader();
            var textfile = reader.readAsText(fileButton, "UTF-8");
            var vObjectName = component.find("idObject").get("v.value");
            
            reader.onload = function (evt) {
                var strData = evt.target.result;
                var  strDelimiter = (strDelimiter || ",");
                var objPattern = new RegExp((
                    "(\\" + strDelimiter + "|\\r?\\n|\\r|^)" +
                    "(?:\"([^\"]*(?:\"\"[^\"]*)*)\"|" +
                    "([^\"\\" + strDelimiter + "\\r\\n]*))"), "gi");
                var arrData = [[]];
                var arrDataSort = [[]];
                var arrMatches = null;
                while (arrMatches = objPattern.exec(strData)) {
                    var strMatchedDelimiter = arrMatches[1];
                    if (strMatchedDelimiter.length && (strMatchedDelimiter != strDelimiter)) {
                        arrData.push([]);
                        arrDataSort.push([]);
                    }
                    if (arrMatches[2]) {
                        var strMatchedValue = arrMatches[2].replace(
                            new RegExp("\"\"", "g"), "\"");
                    } else {
                        var strMatchedValue = arrMatches[3];
                    }
                    arrData[arrData.length - 1].push(strMatchedValue);
                    arrDataSort[arrDataSort.length - 1].push(strMatchedValue);
                }
                
                var arraySort = arrDataSort;
                var array = arrData;
                var objArray = [];
                
                var vFieldAPI = component.get('v.ListOfField');
                
                if(vDMLOperation == 'Insert')
                {
                    if(arraySort[0].length != vFieldAPI.length)
                    {
                        component.set("v.isShowError", true);
                        component.set("v.Spinner", false);
                        component.set("v.ShowMessage", 'Please Check the Api Fields Length.They dont match with Custommeta');
                        return ;
                    }else if(arraySort[0].length == vFieldAPI.length)
                    {
                        var vMatchFields = [];
                        var vUnMatchFields = [];
                        arraySort[0].sort();
                        vFieldAPI.sort();
                        for(var i = 0; i < arraySort[0].length; i += 1) {
                            if(vFieldAPI.indexOf(arraySort[0][i]) > -1){
                                vMatchFields.push(arraySort[0][i]);
                            }
                            else 
                            {
                                vUnMatchFields.push(arraySort[0][i]);
                            }
                        }
                        if(vUnMatchFields.length != 0 || vUnMatchFields !='')
                        {
                            var ErrMsg = 'These fields are not matching with the meta : '+vUnMatchFields;
                            component.set("v.ShowMessage", ErrMsg);
                            component.set("v.isShowError", true);
                            component.set("v.Spinner", false);
                            return ;
                        }
                    }
                }
                
                
                for (var i = 1; i < array.length - 1; i++) {
                    objArray[i - 1] = {};
                    for (var k = 0; k < array[0].length && k < array[i].length; k++) {
                        var key = array[0][k];
                        if(array[i][k] ==  '')
                        {
                            console.log('Blank'+key);
                            objArray[i - 1][key] = 'Blank';
                        }
                        else  if(array[i][k] !=  '')
                            objArray[i - 1][key] = array[i][k];
                    }
                }
                
                if(objArray.length < 1)
                {
                    component.set("v.isShowError", true);
                    component.set("v.ShowMessage", 'File has no Record\'s to insert');
                    component.set("v.Spinner", false);
                    component.set("v.showResult", false);
                    return ;
                }
                else
                {
                    var json = JSON.stringify(objArray);    
                    component.set("v.NumberOfRecords", objArray.length);
                    
                    var action_1 = component.get("c.passFile_Jason");
                    action_1.setParams({ 
                        strJason_file : json ,
                        strObjectName : vObjectName,
                        strDMLOperation : vDMLOperation } );
                    action_1.setCallback(this, function(actionResult) {
                        
                        if(actionResult.getReturnValue() != '')
                        {
                            component.set("v.Spinner", false);
                            component.set("v.BatchJobID", actionResult.getReturnValue()); 
                            component.set("v.showResult", true);
                        }
                        
                    });
                    $A.enqueueAction(action_1);
                }
            }
            reader.onerror = function (evt) {
                
            }
        }
        
    } ,
    
    APIFieldvalues: function(component, event, helper) {
        
        helper.getApiValues(component, event);
        var vObjTypeOpts = [];
        vObjTypeOpts.push({
            class: "optionClass",
            label: "--- None ---",
            value: "None"
        });
        vObjTypeOpts.push({
            class: "optionClass",
            label: "Insert",
            value: "Insert"
        });
        vObjTypeOpts.push({
            class: "optionClass",
            label: "Update",
            value: "Update"
        });
        
        component.find('idDML').set("v.options", vObjTypeOpts);
    } ,
    
    DMLValues: function(component, event, helper) {
        // component.set("v.isDMLDependable",false);
        helper.getDMLValues(component, event);
    } ,
    
    
    
    // ## function call on Click on the "Download As CSV" Button. 
    downloadCsv : function(component,event,helper){
        var vDMLOperation = component.find("idDML").get("v.value");
        var vObjectType = component.find("idObject").get("v.value");
        //console.log('vObjectType is '+vObjectType);
        var vReturnValue = component.get("v.ListOfField");
        
        
        if(vDMLOperation =='Update')
        {
            var vColumnValue =["Id"] ;
            for(var strerror in vReturnValue) 
            {
                if(vObjectType=='Co_Op_Allocation__c'){
                    //console.log('object is ');
                    //console.log(strerror);
                    if(vReturnValue[strerror]!='Fund_Id__c' && vReturnValue[strerror] !='Partner_Name__c' ){                        
                		vColumnValue.push(vReturnValue[strerror]);
                    }
                }
                else{
                    vColumnValue.push(vReturnValue[strerror]);
                }
            }
            //console.log('vColumnValue'+vColumnValue);
        }
        else if(vDMLOperation =='Insert')
            vColumnValue = vReturnValue;
        var stockData = vColumnValue;
        
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component,stockData);   
        var vSObjectName = component.find("idObject").get("v.value");
        
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; // 
        hiddenElement.download = vSObjectName+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
        
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
        
    },
    
    ClosePrompt : function(component,event,helper){
        component.set("v.isShowError", false);
    }
    
})