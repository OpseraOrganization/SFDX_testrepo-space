({
    //this function load during initialization	
    doInit : function(component, event, helper) {
        //var myMap = component.get("v.techToCSS");
        //console.log('myMap is'+myMap);
        var reportSection = component.find('reportSection');
        console.log('reportSection--- '+reportSection);
        var action =  component.get("c.getUniqueTechnologies");   
        console.log('after action '+action);
        var techCss =  []; 
        action.setCallback(this, function(response) {
            var techlist = response.getReturnValue();
            console.log('******techlist***********'+techlist);                
            component.set("v.technologyList",techlist);
            var actionUseCase =  component.get("c.returnUseCaseOnTechnology");	
            actionUseCase.setParams({
                'technology' : techlist[0].techValue,		
            });
            
            actionUseCase.setCallback(this, function(response) {
                component.set("v.usecaseList",response.getReturnValue());			
            });
            
            $A.enqueueAction(actionUseCase); 
            
            
        });
        $A.enqueueAction(action);  
        component.set("v.selectedTech", "FDD LTE");
    } ,
    //explain what does this do
    afterScriptsLoaded : function(component, event, helper) {
		//('Inside afterScriptsLoaded');
        var mywindow;
        var sPageURL = decodeURIComponent(window.parent.location.search.substring(1));
        
        
        var access_Token = window.localStorage.getItem("v.accesstoken");
        var refresh_token = window.localStorage.getItem("v.refreshtoken");
        var expires_on = window.localStorage.getItem("v.expiresOn");
        
        var expiresOn = 0;
        if(expires_on != null)
            expiresOn = parseInt(expires_on);
        var currentTime = Date.now()/1000;
        
        
        
        var sURLVariables = sPageURL.split('&'); 
        console.log('*********sURLVariables.length***************'+sURLVariables.length);
        var authorizationCode = '';
        if(sURLVariables.length > 1) {
            for (var i = 0; i < sURLVariables.length; i++) {
                console.log('******sURLVariables[i]*********'+sURLVariables[i]);
                var sParameterName = sURLVariables[i].split('='); //to split the key from the value.
                
                if (sParameterName[0] === 'code') {
                    console.log('Code is:'+sParameterName[1]);
                    authorizationCode = sParameterName[1];
                }
            }
        }
        
        
        console.log('*******authorizationCode.length******* **'+authorizationCode.length);
        //alert('*******access_Token.length******* **'+access_Token.length);
        if(authorizationCode.length > 0  ) {
            console.log('***********authorizationCode*******************'+authorizationCode);
            
            var action =  component.get("c.genarateAccessToken");
            console.log('Action********'+action);
            var accessToken ='';
            action.setParams({
                'authCode' : authorizationCode,			
            });
            console.log('Auth Code****'+authorizationCode);
            action.setCallback(this, function(response) {
                var obtainedResponse = response.getReturnValue();
                
                console.log('obtainedResponse.isRequestSucceed *******'+obtainedResponse.isRequestSucceed);
                console.log('obtainedResponse.isTokenFound *******'+obtainedResponse.isTokenFound);
                console.log('obtainedResponse.oAuthInfo.access_token *******'+obtainedResponse.oAuthInfo.access_token);
                console.log('*********obtainedResponse.oAuthInfo.access_token************'+obtainedResponse.oAuthInfo.access_token);
                console.log('*********obtainedResponse.oAuthInfo.refreshtoken************'+obtainedResponse.oAuthInfo.refreshtoken); 
                console.log('*********obtainedResponse.oAuthInfo.refreshtoken************'+obtainedResponse.oAuthInfo.refreshtoken);    
                if(obtainedResponse.isRequestSucceed == true) {
                    
                    window.localStorage.setItem('v.accesstoken',obtainedResponse.oAuthInfo.access_token); 
                    window.localStorage.setItem('v.refreshtoken',obtainedResponse.oAuthInfo.refresh_token);
                    window.localStorage.setItem('v.expiresOn',obtainedResponse.oAuthInfo.expires_on);
                   // alert('Before close');
                   // alert('window.parant updated'+window.parent);
                    //alert('Variable value'+mywindow);
                    window.parent.close();
                    // window.open('https://ccpq1-nokiapartners.cs26.force.com/digitalsalesportal/s/digitalproposallist','_self');
                }
                else
                {
                    window.localStorage.setItem('v.accesstoken',''); 
                    window.localStorage.setItem('v.refreshtoken','');
                    window.localStorage.setItem('v.expiresOn','0');
                    
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Please Note",
                        "message": "Something went wrong!Please contact your system administrator",
                        "type": "info",
                        "duration" : "5000",
                        "mode":"dismissible"
                    });
                    resultsToast.fire();
                    
                }
                
                
                console.log('Before calling load report');
                console.log('Reading the data from the cachae'+window.localStorage.getItem("v.accesstoken"));
                
                //helper.loadReportData(component, event, helper,obtainedResponse.oAuthInfo.access_token);
                
                
                
            });
            $A.enqueueAction(action);
        }
        else if(expiresOn <= currentTime || access_Token.length == 0) { 
				//alert('*******Inside expiresOn <= currentTime || access_Token.length == 0***********');
            // var loginWindow = window.open('{!authUrl}','Login','width=250,height=900,0,status=0');
            var actionURL =  component.get("c.getOAuthURL");
            actionURL.setCallback(this, function(response) {
                var obtainedResponseURL = response.getReturnValue();
                console.log('ObtainedURL'+obtainedResponseURL);
                //window.open(obtainedResponseURL,'_self');
                mywindow = window.open(obtainedResponseURL,'_blank','width=250,height=900');
            });
            $A.enqueueAction(actionURL);
            //window.open('https://login.microsoftonline.com/nokia.com/oauth2/authorize/?client_id=6fc877de-8f30-457e-8d97-f9c3c7622908&redirect_uri=https%3A%2F%2Fccpq1-nokiapartners.cs26.force.com%2Fdigitalsalesportal%2Fs%2Fdigitalproposallist&resource=https%3A%2F%2Fanalysis.windows.net%2Fpowerbi%2Fapi&response_type=code','_self');
        } 
        else if((expiresOn - 2000) <= currentTime  ) {
            
           
            var refresh_token = window.localStorage.getItem("v.refreshtoken");
            console.log('**********Obtained refresh token from Cachae*********'+refresh_token);
            var action =  component.get("c.genarateAccessTokenFromRefreshToken");
            action.setParams({
                'refreshToken' : refresh_token,			
            });
            
            
            action.setCallback(this, function(response) {
                //alert('**Inside refresh token call back***');
                //alert('*******response.getStatusCode()**********'+response.getStatuscode());
                //alert('***************response.getReturnvalue()******************'+response.getReturnValue());
                var obtainedResponse = response.getReturnValue();
                //alert('*****************obtainedResponse.isRequestSucceed******************'+obtainedResponse.isRequestSucceed);
                //alert('*****************obtainedResponse.isNeedRequestForAccesToken******************'+obtainedResponse.isNeedRequestForAccesToken);
                if(obtainedResponse.isRequestSucceed == true) {
                    
                    window.localStorage.setItem('v.accesstoken',obtainedResponse.oAuthInfo.access_token); 
                    window.localStorage.setItem('v.refreshtoken',obtainedResponse.oAuthInfo.refresh_token);
                    window.localStorage.setItem('v.expiresOn',obtainedResponse.oAuthInfo.expires_on);
                    //helper.loadReportData(component, event, helper,obtainedResponse.oAuthInfo.access_token);
                    
                }
                else if(obtainedResponse.isNeedRequestForAccesToken ==  true ){
                    console.log('******Need to go  for getting access token on refreshtoken*********');
                    window.localStorage.setItem('v.accesstoken',''); 
                    window.localStorage.setItem('v.refreshtoken','');
                    window.localStorage.setItem('v.expiresOn',0);
                    var actionURL =  component.get("c.getOAuthURL");
                    actionURL.setCallback(this, function(response) {
                        var obtainedResponseURL = response.getReturnValue();
                        console.log('ObtainedURL'+obtainedResponseURL);
                      //  window.open(obtainedResponseURL,'_self');
                      mywindow = window.open(obtainedResponseURL,'_blank','width=250,height=900');
                    });
                    $A.enqueueAction(actionURL);    
                }
                
                    else{
                        
                        window.localStorage.setItem('v.accesstoken',''); 
                        window.localStorage.setItem('v.refreshtoken','');
                        window.localStorage.setItem('v.expiresOn','0');
                        
                        var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "title": "Please Note",
                            "message": "Something went wrong!Please contact your system administrator",
                            "type": "info",
                            "duration" : "5000",
                            "mode":"dismissible"
                        });
                        resultsToast.fire();
                        
                    }
                
                
            });
            $A.enqueueAction(action);
            
            
        }
        else {
                
                console.log('*********obtainedResponse.oAuthInfo.refreshtoken************'+window.localStorage.getItem("v.refreshtoken")); 
                console.log('*********Final Else********');
                // helper.loadReportData(component, event, helper,access_Token);
                
        } 
    },
    openModel: function(component, event, helper) {
        
        //alert('Inside Open Modal');
        component.set("v.isOpen", true);
        var reportSection = component.find('reportSection');
        $A.util.addClass(reportSection,'slds-show');
        $A.util.removeClass(reportSection,'slds-hide');
        
        
        var report = component.find('myReport');
        $A.util.addClass(report,'slds-show');
        $A.util.removeClass(report,'slds-hide');
        
        var  techUseCase = component.find('techUseCaseList'); 
        $A.util.addClass(techUseCase,'slds-hide');
        $A.util.removeClass(techUseCase,'slds-show');
        
        //helper.loadReportData(component, event, helper,window.localStorage.getItem("v.accesstoken"));
        
        
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        
    },
    loadUsecases: function(component, event, helper) {
        
        
        var rectarget = event.currentTarget;            
        var reportURL = rectarget.getAttribute("data-value"); 
        var selecedTechnologyvalue = event.currentTarget.dataset.value; 
       
        component.set("v.selectedTech", selecedTechnologyvalue);
        
        var selectedIndex = event.currentTarget.dataset.index; 
        var techList =  component.get("v.technologyList");
        for(var i = 0; i < techList.length; i++) {
            if(selectedIndex  == i) {
                techList[i].className = 'btActivated'; 
            }
            else {
                techList[i].className = 'btDefault'; 
            }
        }
        component.set("v.technologyList",techList);
        var actionUseCase =  component.get("c.returnUseCaseOnTechnology");	
        actionUseCase.setParams({
            'technology' : selecedTechnologyvalue,			
        });
        
        actionUseCase.setCallback(this, function(response) {
            component.set("v.usecaseList",response.getReturnValue());			
        });
        
        $A.enqueueAction(actionUseCase); 
    },
    
    loadReportOnTechnology : function(cmp, event, helper) {
        //Create component dynamically
        var reportlink =  event.getSource().get("v.name");
        console.log("reportlink----->"+reportlink);
        var parentComponent = cmp.get("v.body");
        console.log('parentComponent--->'+parentComponent);
        var  techUseCase = cmp.find('techUseCaseList'); 
        
        var useCase = event.getSource().get("v.value")
        var technology = cmp.get("v.selectedTech");
        
        console.log('techUseCase--->'+techUseCase);
        console.log('*****techUseCaseList found*******');
        $A.util.addClass(techUseCase,'slds-hide');
        $A.util.removeClass(techUseCase,'slds-show');
        
        
        $A.createComponent(
            "c:DS_PBI_ReportChild",
            {
                "link":reportlink,
                "UseCase":useCase,
                "technology":technology
                
            },
            function(newButton, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body.push(newButton);
                    cmp.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                        // Show error message
                    }
            }
        );
        }, 
    
    handlePress : function(cmp) {
        // Find the button by the aura:id value
        console.log("button: " + cmp.find("findableAuraId"));
        console.log("button pressed");
    },
    
    handleClick : function(component, event, helper) {
        //component.find('myReport').getElement().innerHtml
        var element = component.find('myReport').getElement();
        console.log('****Element found********'+element);
        element = '';
        console.log('****Element set with null value********');
        var report = component.find('reportSection');
        $A.util.addClass(report,'slds-hide');
        $A.util.removeClass(report,'slds-show');
        
        var  techUseCase = component.find('techUseCaseList'); 
        $A.util.addClass(techUseCase,'slds-show');
        $A.util.removeClass(techUseCase,'slds-hide');
    }, 
    
    parentAction : function(component, event, helper) {
        console.log('In Parent action');
        var  techUseCase = component.find('techUseCaseList'); 
        $A.util.addClass(techUseCase,'slds-hide');
        $A.util.removeClass(techUseCase,'slds-show'); 
    },
    handleSampleEvent : function(cmp,event){
        
        
        var  techUseCase = cmp.find('techUseCaseList'); 
        console.log('*****techUseCaseList found*******');
        $A.util.addClass(techUseCase,'slds-show');
        $A.util.removeClass(techUseCase,'slds-hide');
    }
    
})