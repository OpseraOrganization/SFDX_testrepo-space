({
    doInit : function(component, event, helper) {
        helper.enableFIR(component, event, helper);
        var ndaLabel=$A.get("$Label.c.NDAURL");
        var firLabel=$A.get("$Label.c.CH_FIR_URL");
		var ccrLabel=$A.get("$Label.c.CH_CaseClosureReportURL");
      //  console.log('ndaLabel'+ndaLabel);
        var caseId = component.get("v.recordId");
        var action = component.get("c.fetchCaseDetails");
        action.setParams({ caseId : caseId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state is'+state);
            if (state === "SUCCESS") {
                console.log('state is'+state);
                
                component.set('v.caseUrlMap', response.getReturnValue());
                
             //   console.log('caseUrlMap'+component.get('v.caseUrlMap.caseNumber')+'country'+component.get('v.caseUrlMap.caseCountry')+JSON.stringify(response.getReturnValue()));
                component.set('v.casNumber',component.get('v.caseUrlMap.caseNumber'));
               // console.log('Case number is'+component.get('v.caseUrlMap.caseNumber'));
                component.set('v.ncibUrl',component.get('v.caseUrlMap.caseURL'));
                //change made for NOKIASC-36084 | START
                component.set("v.ndaUrl",ndaLabel.replace('{0}',component.get('v.caseUrlMap.caseNumber')));
                //component.set("v.ndaUrl",ndaLabel+' '+component.get('v.caseUrlMap.caseNumber'));
                //change made for NOKIASC-36084 | END
                component.set("v.firUrl",firLabel+'?CaseNum='+component.get('v.caseUrlMap.caseNumber'));
                component.set("v.caseClosureUrl",ccrLabel+'?CaseNum='+component.get('v.caseUrlMap.caseNumber'));
                component.set("v.showFIR",component.get('v.caseUrlMap.showFIR'))//NOKIASC-35336
                component.set("v.showCCR",component.get('v.caseUrlMap.showCCR'))//NOKIASC-35336
              }
        });
        $A.enqueueAction(action);
        
    },
     handleMenuSelect: function(component, event, helper) {
    	var selectedMenuItemValue = event.getParam("value");
        if(event.getParam("value")=='NDA'){
        	helper.navigateToNDA(component,event,helper);      
        }else if (event.getParam("value")=='NCIB'){
            helper.navigateToNCIB(component,event,helper);
        }else if(event.getParam("value")=='FIR'){
            helper.navigateToFIR(component,event,helper); 
        }else{
            helper.navigateToCaseClosureReport(component,event,helper);
        }
	}
})