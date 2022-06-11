({
    // ## function call on component load  
    loadParseResult: function(component, event, helper){
        //   helper.onLoad(component, event);
        helper.pollApex(component, event, helper);
        //   alert('working');
        
        
    },
    
    // ## function call on Click on the "Download As CSV" Button. 
    downloadResultCsv : function(component,event,helper){
        
        // get the Records [contact] list from 'ListOfContact' attribute 
        var stockData1 = component.get("v.ListOfParseResult");
        
        // call the helper function which "return" the CSV data as a String   
        var csv1 = helper.convertArrayOfObjectsToCSV1(component,stockData1);   
        if (csv1 == null){return;} 
        
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
        var hiddenElement1 = document.createElement('a');
        hiddenElement1.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv1);
        hiddenElement1.target = '_self'; // 
        hiddenElement1.download = 'ExportData.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement1); // Required for FireFox browser
        hiddenElement1.click(); // using click() js function to download csv file
        //  alert('file downloaded');
        
    }, 
    
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.showResult", false);
        component.set("v.Spinner", true);
        document.location.reload(true);
    },
    
    ClosePrompt : function(component,event,helper){
        //component.set("v.isBatchError", false);
        //component.set('v.showResult', true);
    }
    
})