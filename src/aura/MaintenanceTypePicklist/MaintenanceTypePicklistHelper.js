({
    savefunction : function(component, event, helper){
        component.set("v.Spinner", true);
        var SelectResultFromOption = component.find("picklistArray").get("v.value");
        var maintContaractVal = component.find("ExistMaint").get("v.value");
        var subPlanLevelVal = component.find("releaseSubLevel1").get("v.value");
        var releaseSubLevelVal = component.find("releaseSubLevel").get("v.value");
        var noMaintYearsVal = component.find("noMaintYears").get("v.value");
         //var varMaintLvl = component.find("Maintlvl").get("v.value");
		var newaction = component.get("c.saveRecord");
          //alert("action apoorv--->"+varMaintLvl);
      
        //alert(SelectResultFromOption+' 1'+maintContaractVal+' 2'+subPlanLevelVal+'3 '+releaseSubLevelVal+' 4'+noMaintYearsVal);
        //console.log('[+] Inside saveFunction');
        //console.log("action apoorv--->"+varMaintLvl);
		//console.log("component.get()--->" +component.get("v.recordId"));        
        
        newaction.setParams({"recordIDvar" : component.get("v.recordId"),
                             "maintstring" : SelectResultFromOption,
                             "existcontract" : maintContaractVal,
                             "numyears" : noMaintYearsVal,
                             "planLevel" : subPlanLevelVal,
                             "releaseLevel" : releaseSubLevelVal});
        
        //console.log("SelectResultFromOption--->" +SelectResultFromOption);
        
        newaction.setCallback(this, function(response) {
            //console.log(response.getState());
            var state = response.getState();
            if (response.getState() === "SUCCESS") {
                //console.log(response.getReturnValue());
                var returnStringVal = response.getReturnValue();
				//component.set("v.resultVal","SUCCESS");
				component.set("v.Spinner", false);
            }
      		//console.log("returnStringVal--->" +returnStringVal);
            
            
        	//Toast Message when data gets saved
            var resultsToast = $A.get("e.force:showToast");
           
            if(returnStringVal=="SUCCESS"){
                resultsToast.setParams({"title": "Record Updated",
                                "message": "The record has been updated successfully!",
                                "type": "success"
            	});
                window.location.reload();
            }
            else if(returnStringVal=="FAIL"){
                 resultsToast.setParams({"title": "Record Update Failed",
                                "message": "The quotation cannot be saved. Please select values for all required fields. ",
                                "type": "error"
            	});
            }
            
        	resultsToast.fire();
        	$A.get('e.force:refreshView').fire();
            
        });
        
        $A.enqueueAction(newaction);
   		
    },
    
    savefunctionOnInit : function(component, event, helper){
        component.set("v.Spinner", true);
        var SelectResultFromOption = component.find("picklistArray").get("v.value");
        var maintContaractVal = component.find("ExistMaint").get("v.value");
        var subPlanLevelVal = component.find("releaseSubLevel1").get("v.value");
        var releaseSubLevelVal = component.find("releaseSubLevel").get("v.value");
        var noMaintYearsVal = component.find("noMaintYears").get("v.value");
 		//var varMaintLvl = component.find("Maintlvl").get("v.value");
		var newaction = component.get("c.saveRecord");
      
        //alert(SelectResultFromOption+' 1'+maintContaractVal+' 2'+subPlanLevelVal+'3 '+releaseSubLevelVal+' 4'+noMaintYearsVal);
        
      	//console.log("action--->"+noMaintYearsVal);
		//console.log("component.get()--->" +component.get("v.recordId"));        
        
        newaction.setParams({"recordIDvar" : component.get("v.recordId"),
                             "maintstring" : SelectResultFromOption,
                             "existcontract" : maintContaractVal,
                             "numyears" : noMaintYearsVal,
                             "planLevel" : subPlanLevelVal,
                             "releaseLevel" : releaseSubLevelVal});
        
        //console.log("SelectResultFromOption--->" +SelectResultFromOption);
        
        newaction.setCallback(this, function(response) {
            var state = response.getState();
            //console.log('[+] saveRecord = '+state);
            if (response.getState() === "SUCCESS") {
                var returnStringVal = response.getReturnValue();
				//component.set("v.resultVal","SUCCESS");
            }
      		
        });

        $A.enqueueAction(newaction);
   		setTimeout(function(){ component.set("v.Spinner", false); }, 4000);
    }
    
    
})