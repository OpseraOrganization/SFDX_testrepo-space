({
	doInit : function(component, event, helper) {
        var oppId = component.get("v.recordId");
        component.set("v.sptOpp",oppId);
        console.log(oppId);
        var quoteRecordType="";
        var urlString = window.location.href;
        component.set("v.cbaseURL", urlString);
        console.log(component.get("v.cbaseURL"));
        
       	var action = component.get('c.getOpportunityRecord');
        action.setParams({
                recordId : oppId
        })
            action.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS' || state === 'DRAFT'){
                    var responseValue = response.getReturnValue();
                    var resVal = responseValue[0].OwnerId;
                    var lmid=responseValue[0].LastModifiedById;
                    var acLeEntity = responseValue[0].Legal_Entity__c;
                    component.set("v.OwnerId",responseValue[0].OwnerId);
                    component.set("v.accLeagalEnittyId",acLeEntity);
                    console.log("Account Legal Entity Account : "+component.get("v.accLeagalEnittyId"));
                    component.set("v.qLead",responseValue[0].LastModifiedById);
                    
                    component.set("v.currentUser", $A.get("$SObjectType.CurrentUser.Id"));
                }
            });
            $A.enqueueAction(action);
        
        	/////////// get Base URL /////////////
        	var action2 = component.get('c.getBaseUrl');
        	action2.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS' || state === 'DRAFT'){
                    var baseURL = response.getReturnValue();
                     //alert (" Base URL is "+baseURL);    
                    component.set("v.baseUrl",baseURL);
                    //alert (" Base URL from component is "+component.get("v.baseUrl"));                    
                }
            });
            $A.enqueueAction(action2);

            var action3 = component.get('c.getPricingPool');
            action3.setParams({ recordId : oppId })
            action3.setCallback(this,function(response){
                var state = response.getState();
                console.log(state);
                if(state === 'SUCCESS' || state === 'DRAFT'){
                    var pricingPoolList = response.getReturnValue();
                    component.set("v.pricingPoolList", pricingPoolList);
                    console.log(pricingPoolList);
                }
            });
            $A.enqueueAction(action3);
	},
    disableFields : function(component, event, helper) {
        var val = component.find("QWMcheckbox").get("v.value");
        console.log("On Page Load : "+val);
        if(val == true){
            component.set('v.hide' ,true);
            
        }
        if(val == false){
           console.log(val);
            component.set('v.hide' ,false); 
        }
         
	},
    disableQWMCheckboxField : function(component, event, helper){
        var portfolioValue = component.find("qPortfolio").get("v.value");
        console.log(portfolioValue);
        if(portfolioValue == 'Fixed Network'){
            component.set('v.hideQWMChekbox',false);
        }
        else
          component.set('v.hideQWMChekbox',true);        
    }, 
    
   enableNewQuote :function(component, event, helper) {
        var newQuote = false;
        var recordTypeSelection = true;
        if(newQuote == false){
            component.set("v.newQuote",true);
            component.set("v.recordTypeSelection",false);
            component.set("v.quoteRecordType","Direct_Quote");
            console.log(component.get("v.quoteRecordType")); 
        }
        
    },
    enableNewQuotecpq :function(component, event, helper) {
        var newQuote = false;
        var newQTCquoteCPQ = false;
        var recordTypeSelection = true;
        if(newQuote == false){
            component.set("v.newQTCquoteCPQ",true);
            component.set("v.recordTypeSelection",false);
            component.set("v.quoteRecordType","CPQ_QTC_NCQ_Quote");
            console.log(component.get("v.quoteRecordType"));
        }
        
    },
    enableNewQuotesurroundPT :function(component, event, helper) {
        var newQuote = false;
        var newQTCquoteCPQ = false;
        var newQTCquoteSurrountPT = false;
        var recordTypeSelection = true;
        if(newQTCquoteSurrountPT == false){
            component.set("v.newQTCquoteSurrountPT",true);
            component.set("v.recordTypeSelection",false);
            component.set("v.quoteRecordType","Contracted_Quote");
            console.log(component.get("v.quoteRecordType"));
        }
        
    },
    enableNewQuoteCQ :function(component, event, helper) {
        var newQuote = false;
        var newQTCquoteCPQ = false;
        var newQTCquoteSurrountPT = false;
        var newQTCquoteCQ = false;
        var recordTypeSelection = true;
        if(newQTCquoteCQ == false){
            component.set("v.newQTCquoteCQ",true);
            component.set("v.recordTypeSelection",false);
            component.set("v.quoteRecordType","CPQ_QTC_CQ_Quote");
            console.log(component.get("v.quoteRecordType"));
        }
        
    },
    submitRecord : function(component, event, helper){
		//alert(component.get("v.newQuote"));
		component.set("v.Spinner", true); 
		var qrt = component.get("v.quoteRecordType");
        var noValidationError = true;
        //var qNameURL = "";
        if (qrt == "Direct_Quote"){
            var directQuote = component.get("v.newQuote");
            var quoteName = component.find("qName").get("v.value");
            //qNameURL = quoteName;
            var quoteDescription = component.find("qDescription").get("v.value");
            var quotePortfolio = component.find("qPortfolio").get("v.value");
            if(quotePortfolio != 'Fixed Network')
            {
            	var quoteQWM = component.find("QWMcheckbox").get("v.value");
            }
            console.log(qrt+","+quoteName +"," +quoteDescription+","+quotePortfolio+","+quoteQWM);
            //alert('quoteName :'+quoteName+' quotePortfolio :'+quotePortfolio );
            if(quoteQWM == true){
                var quoteMT = component.find("qMaintenanceType").get("v.value");
                var quoteEMT = component.find("qExistingMaintenanceContract").get("v.value");
                var quoteNYM = component.find("qNbrYear").get("v.value");
                var action = component.get('c.createQuoteRecord');
            	var oppId = component.get("v.recordId");
                action.setParams({
                recordType : qrt,
                Name : quoteName,
                OppId : oppId,
                Description : quoteDescription,
                Portfolio   : quotePortfolio,
                quoteQWM    : quoteQWM,
                quoteMT     : quoteMT,
                quoteEMT    : quoteEMT,
                quoteNYM    : quoteNYM
            })
            }
            else{
                var action = component.get('c.createQuoteRecordWM');
            	var oppId = component.get("v.recordId");
                action.setParams({
                recordType : qrt,
                Name : quoteName,
                OppId : oppId,
                Description : quoteDescription,
                Portfolio   : quotePortfolio
                })
            }
         
            
            action.setCallback(this,function(response){
                component.set("v.Spinner", false);
                var state = response.getState();
                console.log("State is "+state);
                if(state === 'SUCCESS' || state === 'DRAFT'){
             		var responseValue  = response.getReturnValue();
                    var baseURL = component.get("v.baseUrl");
                    var qNameURL = responseValue["Name"];
                    var qId      = responseValue["Id"];
                    var completeURL = baseURL+'/'+qId;
                                       	
                   	var navEvt = $A.get("e.force:navigateToSObject");
                                navEvt.setParams({
                                  "recordId": component.get("v.recordId"),
                                  "slideDevName": "detail"
                                });
    					navEvt.fire();
                    var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
        			mode: 'pester',
                    key: 'info_alt',
                    type: 'success',
                    title : 'Success',
                    duration:'10000',
        			message: 'This is a required message',
        			messageTemplate: 'Quote {0} created!',
        			messageTemplateData: [{
            		url:completeURL,
            		label: qNameURL,
            		}
        			]
    				});
                    
                    toastEvent.fire(); 
                    $A.get("e.force:closeQuickAction").fire();
                }
                else if(state === 'ERROR'){
                   	//component.set("v.Spinner", false);
                  	var errorMsg = response.getError();
                    var msg = errorMsg[0].message
                    console.log("Original Message  :"+errorMsg[0].message);
                    component.set("v.showError",true);
                   	component.set("v.errorMessage",msg);
            
                }
            }); // Set call back end here
            
            console.log("quoteName : "+quoteName);
            console.log("quotePortfolio : "+quotePortfolio);
            
             if(quoteName === null ||  quoteName === "" || quotePortfolio === null || quotePortfolio === ""){
                component.set("v.Spinner", false);
                 var msg = "Please enter value for mandetory fields";
                 console.log("Validation error on the fields : "+msg);
                component.set("v.showError",true);
                component.set("v.errorMessage",msg);
                noValidationError = false;
                 //retun;
             }
                      
            console.log(" Before enqueueAction " + noValidationError);
            if(noValidationError)
            {
            	$A.enqueueAction(action);
            }
        }
        else if(qrt == "CPQ_QTC_NCQ_Quote"){
            var qtcQuoteCpqName = component.find("qtcQuoteCpqName").get("v.value");
            var qtcQuoteCpqDueDate = component.find("qtcQuoteCpqDueDate").get("v.value");
            var qtcQuoteCpqDescription = component.find("qtcQuoteCpqDescription").get("v.value");
            var qtcQuoteCpqNotes = component.find("qtcQuoteCpqNotes").get("v.value");
            var qtcQuoteCpqMQ = component.find("qtcQuoteCpqMQ").get("v.value");
            var qtcQuoteCpqMQquantity = component.find("qtcQuoteCpqMQquantity").get("v.value");
            var qtcQuoteCpqALE = component.find("qtcQuoteCpqALE").get("v.value");
            console.log("Legal Account= "+qtcQuoteCpqALE);
            var qtcQuoteCpqCPC = component.find("qtcQuoteCpqCPC").get("v.value");
            var qtcQuoteCpqCOS = component.find("qtcQuoteCpqCOS").get("v.value");
            var qtcQuoteCpqCRN = component.find("qtcQuoteCpqCRN").get("v.value");
            var qtcQuoteCpqSL = component.find("qtcQuoteCpqSL").get("v.value");
            var qtcQuoteCpqCPSC = component.find("qtcQuoteCpqCPSC").get("v.value");
            var qtcQuoteCpqQL = component.find("qtcQuoteCpqQL").get("v.value");
            var qtcQuoteCpqCPSS = component.find("qtcQuoteCpqCPSS").get("v.value");
            
            var action = component.get('c.createQTCQuoteCPQRecord');
            	var oppId = component.get("v.recordId");
                action.setParams({
                recordType : qrt,
                Name 			: qtcQuoteCpqName,
                OppId 			: oppId,
                Description 	: qtcQuoteCpqDescription,
                DueDate   		: qtcQuoteCpqDueDate,
                Notes    		: qtcQuoteCpqNotes,
                MasterQuote     : qtcQuoteCpqMQ,
                MQuoteQuantity  : qtcQuoteCpqMQquantity,
                AccLegalEntity :  qtcQuoteCpqALE,
                CustProcode     : qtcQuoteCpqCPC,
                CustOrgSeg		: qtcQuoteCpqCOS, 
                CustReqNum		: qtcQuoteCpqCRN,
                SalesLead		: qtcQuoteCpqSL,
                CustProSiteCity : qtcQuoteCpqCPSC,
                QuoteLead		: qtcQuoteCpqQL,
                CustProSiteState:qtcQuoteCpqCPSS   
            })
            action.setCallback(this,function(response){
                component.set("v.Spinner", false);
                var state = response.getState();
                if(state === 'SUCCESS' || state === 'DRAFT'){
                   	var responseValue  = response.getReturnValue();
                    var baseURL = component.get("v.baseUrl");
                    var qNameURL = responseValue["Name"];
                    var qId      = responseValue["Id"];
                    var completeURL = baseURL+'/'+qId;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
        			mode: 'pester',
                    key: 'info_alt',
                    type: 'success',
                    title : 'Success',
                    duration:'10000',
        			message: 'This is a required message',
        			messageTemplate: 'Quote {0} created!',
        			messageTemplateData: [{
            		url:completeURL,
            		label: qNameURL,
            		}
        			]
    				});
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                }else if(state === 'ERROR'){
                   	//component.set("v.Spinner", false);
                  	var errorMsg = response.getError();
                    var msg = errorMsg[0].message
                    console.log("Original Message  :"+errorMsg[0].message);
                    component.set("v.showError",true);
                   	component.set("v.errorMessage",msg);
                }
            });
            console.log("qtcQuoteCpqName : "+qtcQuoteCpqName);
            console.log("qtcQuoteCpqDueDate : "+qtcQuoteCpqDueDate);
            
             if(qtcQuoteCpqName === null ||  qtcQuoteCpqName === "" || qtcQuoteCpqDueDate === null || qtcQuoteCpqDueDate === ""){
            	component.set("v.Spinner", false);
                var msg = "Please enter value for mandetory fields";
                component.set("v.showError",true);
                component.set("v.errorMessage",msg);
                noValidationError = false;
        	}
                      
            console.log(" Before enqueueAction " + noValidationError);
            if(noValidationError)
            {
            	$A.enqueueAction(action);
            }
            
        }
        else if(qrt == 'Contracted_Quote'){
            var sptQuoteCpqName = component.find('sptQuoteCpqName').get('v.value');
            var sptDueDate= component.find('sptDueDate').get('v.value');
            var sptOpp= component.find('sptOpp').get('v.value');
            var sptQuotVal= component.find('sptQuotVal').get('v.value');
            var sptDescription= component.find('sptDescription').get('v.value');
            var sptNotes= component.find('sptNotes').get('v.value');
            var sptMasterQuote= component.find('sptMasterQuote').get('v.value');
            var sptMQquantity= component.find('sptMQquantity').get('v.value');
            var sptAccLegEntity= component.find('sptAccLegEntity').get('v.value');
            var sptCustProCode= component.find('sptCustProCode').get('v.value');
            var sptCustOrgSeg= component.find('sptCustOrgSeg').get('v.value');
            var sptCustReqNum= component.find('sptCustReqNum').get('v.value');
            var sptSalesLead= component.find('sptSalesLead').get('v.value');
            var sptCustProSC= component.find('sptCustProSC').get('v.value');
            var sptQuoteLead= component.find('sptQuoteLead').get('v.value');
            var sptCustProSS= component.find('sptCustProSS').get('v.value');
            var sptServComp= component.find('sptServComp').get('v.value');
            var action = component.get('c.createQTCQuoteSPTRecord');
            	var oppId = component.get("v.recordId");
                action.setParams({
                recordType 		: qrt,
                OppId			: oppId,
                Name 			: sptQuoteCpqName,
                sptOpp 			: sptOpp,
                sptQuotVal		: sptQuotVal,
                sptDescription 	: sptDescription,
                sptDueDate   	: sptDueDate,
                sptNotes    	: sptNotes,
                sptMasterQuote  : sptMasterQuote,
                sptMQquantity   : sptMQquantity,
                sptAccLegEntity : sptAccLegEntity,
                sptCustProCode  : sptCustProCode,
                sptCustOrgSeg	: sptCustOrgSeg, 
                sptCustReqNum	: sptCustReqNum,
                sptSalesLead	: sptSalesLead,
                sptCustProSC 	: sptCustProSC,
                sptQuoteLead	: sptQuoteLead,
                sptCustProSS	: sptCustProSS,
                sptServComp		: sptServComp
            })
            action.setCallback(this,function(response){
                component.set("v.Spinner", false); 
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var responseValue  = response.getReturnValue();
                    var baseURL = component.get("v.baseUrl");
                    var qNameURL = responseValue["Name"];
                    var qId      = responseValue["Id"];
                    var completeURL = baseURL+'/'+qId;
                    
                    console.log(JSON.stringify(responseValue));
                   
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
        			mode: 'pester',
                    key: 'info_alt',
                    type: 'success',
                    title : 'Success',
                    duration:'10000',
        			message: 'This is a required message',
        			messageTemplate: 'Quote {0} created!',
        			messageTemplateData: [{
            		url:completeURL,
            		label: qNameURL,
            		}
        			]
    				});
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                }else if(state === 'ERROR'){
                   	//component.set("v.Spinner", false);
                  	var errorMsg = response.getError();
                    var msg = errorMsg[0].message
                    console.log("Original Message  :"+errorMsg[0].message);
                    component.set("v.showError",true);
                   	component.set("v.errorMessage",msg);
                }
            });
            
            console.log("sptQuoteCpqName : "+sptQuoteCpqName);
            console.log("sptDueDate : "+sptDueDate);
            
             if(sptQuoteCpqName === null ||  sptQuoteCpqName === "" || sptDueDate === null || sptDueDate === ""){
                component.set("v.Spinner", false);
                 var msg = "Please enter value for mandetory fields";
                 console.log("Validation error on the fields : "+msg);
                component.set("v.showError",true);
                component.set("v.errorMessage",msg);
                noValidationError = false;
                 //retun;
             }
                      
            console.log(" Before enqueueAction " + noValidationError);
            if(noValidationError)
            {
            	$A.enqueueAction(action);
            }
            
        }else if(qrt == "CPQ_QTC_CQ_Quote"){
            var qtcQuoteCqName = component.find("qtcQuoteCqName").get("v.value");
            var qtcQuoteCqDueDate = component.find("qtcQuoteCqDueDate").get("v.value");
            var qtcQuoteCqDescription = component.find("qtcQuoteCqDescription").get("v.value");
            var qtcQuoteCqNotes = component.find("qtcQuoteCqNotes").get("v.value");
            var qtcQuoteCqMQ = component.find("qtcQuoteCqMQ").get("v.value");
            var qtcQuoteCqMQquantity = component.find("qtcQuoteCqMQquantity").get("v.value");
            var qtcQuoteCqALE = component.find("qtcQuoteCqALE").get("v.value");
            console.log("Legal Account for CQ= "+qtcQuoteCqALE);
            var qtcQuoteCqCPC = component.find("qtcQuoteCqCPC").get("v.value");
            var qtcQuoteCqCOS = component.find("qtcQuoteCqCOS").get("v.value");
            var qtcQuoteCqCRN = component.find("qtcQuoteCqCRN").get("v.value");
            var qtcQuoteCqSL = component.find("qtcQuoteCqSL").get("v.value");
            var qtcQuoteCqCPSC = component.find("qtcQuoteCqCPSC").get("v.value");
            var qtcQuoteCqQL = component.find("qtcQuoteCqQL").get("v.value");
            var qtcQuoteCqCPSS = component.find("qtcQuoteCqCPSS").get("v.value");
            var pricingPool	= component.find("pricingPool").get("v.value");
            console.log("---- CQ= "+qtcQuoteCqCPSS);
            var action = component.get('c.createQTCQuoteCPQRecord');
            var oppId = component.get("v.recordId");
            action.setParams({
                recordType : qrt,
                Name 			: qtcQuoteCqName,
                OppId 			: oppId,
                Description 	: qtcQuoteCqDescription,
                DueDate   		: qtcQuoteCqDueDate,
                Notes    		: qtcQuoteCqNotes,
                MasterQuote     : qtcQuoteCqMQ,
                MQuoteQuantity  : qtcQuoteCqMQquantity,
                CustProcode     : qtcQuoteCqCPC,
                CustOrgSeg		: qtcQuoteCqCOS, 
                CustReqNum		: qtcQuoteCqCRN,
                SalesLead		: qtcQuoteCqSL,
                CustProSiteCity : qtcQuoteCqCPSC,
                CustProSiteState:qtcQuoteCqCPSS,
                AccLegalEntity :  qtcQuoteCqALE,
                QuoteLead		: qtcQuoteCqQL,
                pricingPoolVal	: component.get("v.pricingPoolVal").split('---')[0],
                priceConVal		: component.get("v.priceConVal").split('---')[0],
                priceConCodeVal		: component.get("v.priceConCodeVal")
            })
            action.setCallback(this,function(response){
                component.set("v.Spinner", false);
                var state = response.getState();
                if(state === 'SUCCESS' || state === 'DRAFT'){
                    var responseValue  = response.getReturnValue();
                    var baseURL = component.get("v.baseUrl");
                    var qNameURL = responseValue["Name"];
                    var qId      = responseValue["Id"];
                    var completeURL = baseURL+'/'+qId;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'pester',
                        key: 'info_alt',
                        type: 'success',
                        title : 'Success',
                        duration:'10000',
                        message: 'This is a required message',
                        messageTemplate: 'Quote {0} created!',
                        messageTemplateData: [{
                            url:completeURL,
                            label: qNameURL,
                        }
                                             ]
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                }else if(state === 'ERROR'){
                    var errorMsg = response.getError();
                    var msg = errorMsg[0].message
                    console.log("Original Message  :"+errorMsg[0].message);
                    component.set("v.showError",true);
                    component.set("v.errorMessage",msg);
                }
            });
            console.log("qtcQuoteCqName : "+qtcQuoteCqName);
            console.log("qtcQuoteCqDueDate : "+qtcQuoteCqDueDate);
            
            if(qtcQuoteCqName === null ||  qtcQuoteCqName === "" || qtcQuoteCqDueDate === null || qtcQuoteCqDueDate === "" || pricingPool === null || pricingPool ===""){
                component.set("v.Spinner", false);
                var msg = "Please enter value for mandetory fields";
                component.set("v.showError",true);
                component.set("v.errorMessage",msg);
                noValidationError = false;
            }
            
            console.log(" Before enqueueAction " + noValidationError);
            if(noValidationError)
            {	
                console.log(" inside enqueueAction " + noValidationError);
                $A.enqueueAction(action);
            }
            
        }
       // $A.get("e.force:closeQuickAction").fire();
       // console.log("End of callback");
        
	},
    onsubmitform : function(component, event, helper){
        component.find("createNewQuoteform").submit();
    },
    
    closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
      $A.get("e.force:closeQuickAction").fire();
   },
    //this function automatic call by aura:waiting event  
    /*showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    } */
    
    handlePricingPool: function(component, event, helper) {
        var oppId = component.get("v.recordId");
        var ppValue = component.get("v.pricingPoolVal");
        console.log('RRR :: ', ppValue);
        var res = ppValue.split("---");
        console.log('RRR :: res ', res);
        
        //component.set("v.pricingPoolVal", res[0]);
        
        var action3 = component.get('c.getPricingConditions');
        console.log(res[1]);
        action3.setParams({ recordId : oppId, ppId : res[1] })
        action3.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS' || state === 'DRAFT'){
                var priceConList = response.getReturnValue();
                component.set("v.priceConList", priceConList);
            }
        });
        $A.enqueueAction(action3);
    },
    
    handlePriceCondition: function(component, event, helper) {
        var ppConValue = component.get("v.priceConVal");
        console.log('RRR :: ', ppConValue);
        var res = ppConValue.split("---");
        console.log('RRR :: res ', res);
        
        //component.set("v.priceConVal", res[0]);
        component.set("v.priceConCodeVal", res[1]);
    },
})