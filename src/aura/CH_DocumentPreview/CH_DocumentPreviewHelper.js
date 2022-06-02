({
    doInit: function(component, event, helper) {
        component.set('v.showSpinner',true);
        var action = component.get("c.getCaseInfoString");
        action.setParams({
            caseId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var response = JSON.parse(response.getReturnValue());
                component.set("v.imgURL",(response.baseUrl).replace('.my.salesforce','--c.visualforce')+$A.get('$Resource.Nokia_Letterhead'));
                var result = response.case;
                component.set('v.case',result);
                component.set('v.caseNumber',result.CaseNumber);
                var tzString = component.get("v.selectedTimezone");
                var docType = component.get("v.docType");
                var subHeadings = [];
                var prodDetails = this.prodDetails(result);
                var probStatement = this.probStatement(result);
                var custImpact = this.custImpact(component, helper, result);
                subHeadings.push({
                    "label": 'PRODUCT SUMMARY',
                    "value": prodDetails,
                });
                subHeadings.push({
                    "label": 'PROBLEM STATEMEMT',
                    "value": probStatement,
                });
                var custImpactHeading = docType == 'CAR'?'CUSTOMER IMPACT':'INCIDENT TIMESTAMPS';
                subHeadings.push({
                    "label":  custImpactHeading+' ('+tzString+' 24H)',
                    "value": custImpact,
                });
                if(docType == 'SDR'){
                    var incContact = this.incContact(result);
                    subHeadings.push({
                        "label":  'INCIDENT CONTACTS',
                        "value": incContact,
                    });
                }
                component.set("v.subHeadings",subHeadings);
                var contentData = this.contentData(component, result);
                component.set("v.contentData",contentData);
                component.set('v.showSpinner',false);
                var covertedTZ= this.convertTZ(new Date(),tzString);
                component.set("v.currentDate",(covertedTZ+' '+tzString+' (24H)'));
            }
        });
        $A.enqueueAction(action);
    },
    convertTZ: function(date, tzString) {
        var convertedDate = new Date((typeof date === "string" ? new Date(date) : date).toLocaleString("en-US", {timeZone: tzString}));   
        var dateOnly = $A.localizationService.formatDate(convertedDate);                       
        //dateOnly = dateOnly.replace(/[\/\\.-]/g, ' ');                        
        var timeOnly = $A.localizationService.formatTime(convertedDate);                        
        var hours = (convertedDate.getHours()<10?'0':'') + convertedDate.getHours();//NOKIASC-39344 0-9 Minutes will be formatted to 00-09 Minutes
        var minutes = (convertedDate.getMinutes()<10?'0':'') + convertedDate.getMinutes();//NOKIASC-39344 0-9 Hours will be formatted to 00-09 Hours
        var convertedTZ = dateOnly+' '+hours+':'+minutes;
        return convertedTZ;
    },
    
    prodDetails: function(result){
        var prodDetails = [];
        prodDetails.push({
            "label": 'Product Name',
            "value": result.Product.Name,
        });
        if(result.CH_Solution__r){
            prodDetails.push({
                "label": 'Solution',
                "value": result.CH_Solution__r.Name,
            }); 
        }
        if(result.CH_Product_Release__r){
            prodDetails.push({
                "label": 'Product Release',
                "value": result.CH_Product_Release__r.Name,
            }); 
        }
        if(result.CH_ProductVariant__r){
            prodDetails.push({
                "label": 'Product Variant',
                "value": result.CH_ProductVariant__r.Name,
            }); 
        }
        if(result.CH_Product_Module__r){
            prodDetails.push({
                "label": 'Product Module',
                "value": result.CH_Product_Module__r.Name,
            }); 
        }
        if(result.CH_SW_Release__r){
            prodDetails.push({
                "label": 'SW Release',
                "value": result.CH_SW_Release__r.Name,
            }); 
        }
        if(result.CH_NetworkElementAsset__r){
            prodDetails.push({
                "label": 'Network Element',
                "value": result.CH_NetworkElementAsset__r.Name,
            }); 
        }
        return prodDetails;
    },
    
    probStatement: function(result){
        var probStatement = [];
        probStatement.push({
            "label": 'Nokia Ticket Number',
            "value": result.CaseNumber,
        });
        if(result.Reference_Number__c){
            probStatement.push({
                "label": 'Reference Number',
                "value": result.Reference_Number__c,
            }); 
        }
        if(result.Severity__c){
            probStatement.push({
                "label": 'Severity - Outage',
                "value": result.Severity__c+' - '+(result.CH_Outage__c =='Yes'?'Outage':'Non-Outage'),
            }); 
        }
        if(result.Account){
            probStatement.push({
                "label": 'Customer Name',
                "value": result.Account.Name,
            }); 
        }
        if(result.Country__c){
            probStatement.push({
                "label": 'Country',
                "value": result.Country__c,
            }); 
        }
        if(result.CH_Site__c){
            probStatement.push({
                "label": 'Site',
                "value": this.replaceLineBr(result.CH_Site__c),
            }); 
        }
        if(result.Subject){
            probStatement.push({
                "label": 'Ticket Subject',
                "value": result.Subject,
            }); 
        }
        return probStatement;
    },
    
    custImpact: function(component, helper, result){
        var custImpact = [];
        var selectedTZ = component.get("v.selectedTimezone"); 
        if(component.get("v.docType") == 'SDR'){
            if(result.CH_IssueOccurenceDate__c){
                custImpact.push({
                    "label": 'Incident Started',
                    "value": this.convertTZ(result.CH_IssueOccurenceDate__c,selectedTZ),
                }); 
            }
			if(result.CH_ReportedDate__c){
            custImpact.push({
                "label": 'Incident Reported',
                "value": this.convertTZ(result.CH_ReportedDate__c,selectedTZ),
            }); 
			}
            
            if(result.CH_InitialResponse__c){
                custImpact.push({
                    "label": 'Initial Response',
                    "value": this.convertTZ(result.CH_InitialResponse__c,selectedTZ),
                }); 
            }
        }
        if(result.CH_OutageStartDate__c){
            custImpact.push({
                "label": 'Impact Started',
                "value": this.convertTZ(result.CH_OutageStartDate__c,selectedTZ),
            }); 
        }
        if(result.CH_Outage__c =='Yes'){
        if(result.CH_OutageEndDate__c){
            custImpact.push({
                "label": 'Impact Ended',
                "value": this.convertTZ(result.CH_OutageEndDate__c,selectedTZ),
            }); 
        }
		}
		 if(component.get("v.docType") != 'SDR'){
        if(result.CH_ReportedDate__c){
            custImpact.push({
                "label": 'Issue Reported',
                "value": this.convertTZ(result.CH_ReportedDate__c,selectedTZ),
            }); 
        }
		 }
        if(result.CH_SystemRestored__c){
            custImpact.push({
                "label": 'Restoration Time',
                "value": this.convertTZ(result.CH_SystemRestored__c	,selectedTZ),
            }); 
        }
        if(result.CH_TotalOutageDuration__c){
            custImpact.push({
                "label": 'Total Outage Duration',
                "value": result.CH_TotalOutageDuration__c+' (minutes)',
            }); 
        }
        return custImpact;
    },
    
    incContact: function(result){
        var incContact = [];
        incContact.push({
            "label": 'Customer Name',
            "value": result.Contact.Name,
        });
        if(result.Contact.Phone){
            incContact.push({
                "label": 'Customer Phone',
                "value": result.Contact.Phone,
            }); 
        }
        if(result.Contact.Email){
            incContact.push({
                "label": 'Customer Email',
                "value": result.Contact.Email,
            }); 
        }
        if(result.Owner){
            incContact.push({
                "label": 'Case Owner Name',
                "value": result.Owner.Name,
            }); 
        }
        if(result.Owner.Email){
            incContact.push({
                "label": 'Case Owner Email',
                "value": result.Owner.Email,
            }); 
        }
        if(result.Entitlement){
            if(result.Entitlement.ServiceContract.Owner.Name){
                incContact.push({
                    "label": 'Care Manager Name',
                    "value": result.Entitlement.ServiceContract.Owner.Name,
                }); 
            }
            if(result.Entitlement.ServiceContract.Owner.Phone){
                incContact.push({
                    "label": 'Care Manager Phone',
                    "value": result.Entitlement.ServiceContract.Owner.Phone,
                }); 
            }
            if(result.Entitlement.ServiceContract.Owner.Email){
                incContact.push({
                    "label": 'Care Manager Email',
                    "value": result.Entitlement.ServiceContract.Owner.Email,
                }); 
            }
        }
        return incContact;
    },
    
    exSummary: function(result){
        var exSummary = [];
        exSummary.push({
            "label": '',
            "value": result.CH_Summary__c?this.replaceLineBr(result.CH_Summary__c):'',
        }); 
        
        return exSummary;
    },
    
    custDesc: function(result){
        var custDesc = [];
        custDesc.push({
            "label": '',
            "value": result.CH_CustomerDescription__c?this.replaceLineBr(result.CH_CustomerDescription__c):'',
        }); 
        
        return custDesc;
    },
    
    tlEvnts: function(component, result){
        var tlEvnts = [];
        var alphabets = ['a','b','c','d','e','f','g'];
        var i =0;
        var selectedTZ = component.get("v.selectedTimezone");
        if(result.Outage_Durations__r){
            tlEvnts.push({
                "label": 'Outage duration info',
                "value": 'OutageDurationInfoTable',
                "index": alphabets[i]
            });
            i=i+1;
            var j, len;
            var odLst = result.Outage_Durations__r.records;
            var convertedODLst = [];
            for (j = 0, len = odLst.length; j < len; j++) {
                var od = odLst[j];
                od.CH_DurationStartDate__c = this.convertTZ(od.CH_DurationStartDate__c,selectedTZ);
                od.CH_DurationEndDate__c = this.convertTZ(od.CH_DurationEndDate__c,selectedTZ);
                convertedODLst.push(od);
            }
            component.set("v.outageDurData",convertedODLst);
            
        }
        if(result.CH_SequenceOfEvents__c){
            tlEvnts.push({
                "label": 'Sequence of events',
                "value": this.replaceLineBr(result.CH_SequenceOfEvents__c),
                "index": alphabets[i]
            });
            i=i+1;
        }
        tlEvnts.push({
            "label": 'Detailed timeline',
            "value": '',
            "index": alphabets[i]
        });  
        
        return tlEvnts;
    },
    
    custImpactValue: function(result){
        var custImpact = [];
        custImpact.push({
            "label": '',
            "value": result.CH_IssueDescription__c?this.replaceLineBr(result.CH_IssueDescription__c):'',
        }); 
        return custImpact;
    },
    
    rrDetails: function(result, docType){
        var rrDetails = [];
        var alphabets = ['a','b','c','d','e','f','g'];
        var i =0;
        if(docType=='SDR'){
            if(result.CH_IssueDescription__c){
                rrDetails.push({
                    "label": 'Issue description',
                    "value": this.replaceLineBr(result.CH_IssueDescription__c),
                    "index": alphabets[i]
                });
                i=i+1;
            }
        }
        if(result.CH_RestorationMethod__c){
            rrDetails.push({
                "label": 'Restoration method',
                "value": this.replaceLineBr(result.CH_RestorationMethod__c),
                "index": alphabets[i]
            });
            i=i+1;
        }
        if(result.CH_TechnicalAnalysis__c){
            rrDetails.push({
                "label": 'Technical analysis',
                "value": this.replaceLineBr(result.CH_TechnicalAnalysis__c),
                "index": alphabets[i]
            });
            i=i+1;
        }
        if(result.CH_TemporarySolution__c){
            rrDetails.push({
                "label": 'Temporary solution',
                "value": this.replaceLineBr(result.CH_TemporarySolution__c),
                "index": alphabets[i]
            });  
            i=i+1;
        }
        if(docType=='CAR'){
            if(result.CH_SolutionDetails__c){
                rrDetails.push({
                    "label": 'Solution details',
                    "value": this.replaceLineBr(result.CH_SolutionDetails__c),
                    "index": alphabets[i]
                });  
                i=i+1;
            }
        }
        return rrDetails;
    },
    
    rcAnls: function(result){
        var rcAnls = [];
        var alphabets = ['a','b','c','d','e','f','g'];
        var i =0;
		if(result.CH_Problem__r !=undefined && result.CH_Problem__r !='' && result.CH_Problem__r !=null ){
        if(result.CH_Problem__r.CH_Root_Cause_Description__c != undefined && result.CH_Problem__r.CH_Root_Cause_Description__c != '' && result.CH_Problem__r.CH_Root_Cause_Description__c != null){
            rcAnls.push({
                "label": 'Root cause description',
                "value": this.replaceLineBr(result.CH_Problem__r.CH_Root_Cause_Description__c),
                "index": alphabets[i]
            });
            i=i+1;
        }
        if(result.CH_Problem__r.Steps_to_Reproduce_Issue__c != undefined && result.CH_Problem__r.Steps_to_Reproduce_Issue__c != '' && result.CH_Problem__r.Steps_to_Reproduce_Issue__c != null){
            rcAnls.push({
                "label": 'Steps to reproduce issue',
                "value": this.replaceLineBr(result.CH_Problem__r.Steps_to_Reproduce_Issue__c),
                "index": alphabets[i]
            });
            i=i+1;
        }
        if(result.CH_Problem__r.CH_SummaryofAnalysis__c != undefined && result.CH_Problem__r.CH_SummaryofAnalysis__c != '' && result.CH_Problem__r.CH_SummaryofAnalysis__c != null){
            rcAnls.push({
                "label": 'Summary of analysis',
                "value": this.replaceLineBr(result.CH_Problem__r.CH_SummaryofAnalysis__c),
                "index": alphabets[i]
            });  
            i=i+1;
        }
		}	
        return rcAnls;
    },
    
    recomds: function(result){
        var recomds = [];
        var alphabets = ['a','b','c','d','e','f','g'];
        var i =0;
		if(result.CH_Problem__r !=undefined && result.CH_Problem__r !='' && result.CH_Problem__r !=null ){
        if(result.CH_Problem__r.CH_ActionTaken__c != undefined && result.CH_Problem__r.CH_ActionTaken__c != '' && result.CH_Problem__r.CH_ActionTaken__c != null){
            recomds.push({
                "label": 'Reduction of impact',
                "value": this.replaceLineBr(result.CH_Problem__r.CH_ActionTaken__c),
                "index": alphabets[i]
            });
            i=i+1;
        }
        if(result.CH_Problem__r.CH_PreventiveActions__c != undefined && result.CH_Problem__r.CH_PreventiveActions__c != '' && result.CH_Problem__r.CH_PreventiveActions__c != null){
            recomds.push({
                "label": 'Preventive actions',
                "value": this.replaceLineBr(result.CH_Problem__r.CH_PreventiveActions__c),
                "index": alphabets[i]
            });
            i=i+1;
        }
        if(result.CH_Problem__r.CH_CorrectiveActions__c != undefined && result.CH_Problem__r.CH_CorrectiveActions__c != '' && result.CH_Problem__r.CH_CorrectiveActions__c != null){
            recomds.push({
                "label": 'Corrective actions',
                "value": this.replaceLineBr(result.CH_Problem__r.CH_CorrectiveActions__c),
                "index": alphabets[i]
            });  
            i=i+1;
        }
		}
        return recomds;
    },
    
    reportDtls: function(result){
        var reportDtls = [];
        reportDtls.push({
            "label": '',
            "value": 'ReportDetailsTable',
        }); 
        return reportDtls;
    },
    
    contentData: function(component, result){
        var contentData = [];
        var docType = component.get("v.docType");
        contentData.push({
            "label": docType=='CAR'?'Executive summary':'Customer description',
            "value": docType=='CAR'?this.exSummary(result):this.custDesc(result),
        });
        
        contentData.push({
            "label": 'Timeline of events',
            "value": this.tlEvnts(component, result),
        });
        if(docType=='CAR'){
            contentData.push({
                "label": 'Customer impact',
                "value": this.custImpactValue(result),
            });
        }
        var rrDetails = this.rrDetails(result, docType);
        contentData.push({
            "label": docType=='CAR'?'Recovery and resolution details':'Restoration details',
            "value": rrDetails,
        });
        if(docType=='CAR'){
            var rcAnls = this.rcAnls(result);
            var recomds = this.recomds(result);
            var reportDtls = this.reportDtls(result);
            
            contentData.push({
                "label": 'Root cause analysis',
                "value": rcAnls,
            });
            contentData.push({
                "label": 'Recommendations',
                "value": recomds,
            });
            contentData.push({
                "label": 'Report details',
                "value": reportDtls,
            });
        }
        return contentData;
    },
    
    replaceLineBr: function(value){
        value= value.replaceAll('\n','\n<br/>');
		value= value.replaceAll('<p>','<p style=" margin: .1em 0em">');
		return value
    },

	setFocusedTabLabel : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: component.get("v.docType")+" Report"
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    
        unEscapeHTML: function(value){
        value = value.replaceAll('&lt;p&gt;','<p>');
        value = value.replaceAll('&lt;/p&gt;','</p>');
        value = value.replaceAll('&lt;br&gt;','<br>');
        value = value.replaceAll('&lt;/br&gt;','</br>');
        value = value.replaceAll('&lt;b&gt;','<b>');
        value = value.replaceAll('&lt;/b&gt;','</b>');
        value = value.replaceAll('&lt;ul&gt;','<ul>');
        value = value.replaceAll('&lt;/ul&gt;','</ul>');
        value = value.replaceAll('&lt;li&gt;','<li>');
        value = value.replaceAll('&lt;/li&gt;','</li>');
        value = value.replaceAll('&lt;img&gt;','<img>');
        value = value.replaceAll('&lt;/img&gt;','</img>');
        value = value.replaceAll('&lt;i&gt;','<i>');
        value = value.replaceAll('&lt;/i&gt;','</i>');
        value = value.replaceAll('&lt;u&gt;','<u>');
        value = value.replaceAll('&lt;/u&gt;','</u>');
        value = value.replaceAll('&lt;span&gt;','<span>');
        value = value.replaceAll('&lt;/span&gt;','</span>');
        value = value.replaceAll('&lt;ol&gt;','<ol>');
        value = value.replaceAll('&lt;/ol&gt;','</ol>');
        value = value.replaceAll('&lt;a&gt;','<a>');
        value = value.replaceAll('&lt;/a&gt;','</a>');
		value = value.replaceAll('&lt;body&gt;','<body>');
        value = value.replaceAll('&lt;/body&gt;','</body>');
		value = value.replaceAll('&lt;col&gt;','<col>');
        value = value.replaceAll('&lt;/col&gt;','</col>');
		value = value.replaceAll('&lt;div&gt;','<div>');
        value = value.replaceAll('&lt;/div&gt;','</div>');
		value = value.replaceAll('&lt;font&gt;','<font>');
        value = value.replaceAll('&lt;/font&gt;','</font>');
		value = value.replaceAll('&lt;h1&gt;','<h1>');
        value = value.replaceAll('&lt;/h1&gt;','</h1>');
		value = value.replaceAll('&lt;h2&gt;','<h2>');
        value = value.replaceAll('&lt;/h2&gt;','</h2>');
		value = value.replaceAll('&lt;h3&gt;','<h3>');
        value = value.replaceAll('&lt;/h3&gt;','</h3>');
		value = value.replaceAll('&lt;h4&gt;','<h4>');
        value = value.replaceAll('&lt;/h4&gt;','</h4>');
		value = value.replaceAll('&lt;h5&gt;','<h5>');
        value = value.replaceAll('&lt;/h5&gt;','</h5>');
		value = value.replaceAll('&lt;h6&gt;','<h6>');
        value = value.replaceAll('&lt;/h6&gt;','</h6>');
		value = value.replaceAll('&lt;table&gt;','<table>');
        value = value.replaceAll('&lt;/table&gt;','</table>');
		value = value.replaceAll('&lt;tr&gt;','<tr>');
        value = value.replaceAll('&lt;/tr&gt;','</tr>');
		value = value.replaceAll('&lt;td&gt;','<td>');
        value = value.replaceAll('&lt;/td&gt;','</td>');
		value = value.replaceAll('&lt;th&gt;','<th>');
        value = value.replaceAll('&lt;/th&gt;','</th>');
		value = value.replaceAll('&lt;title&gt;','<title>');
        value = value.replaceAll('&lt;/title&gt;','</title>');
        
        value = value.replaceAll('&lt;p','<p');
        value = value.replaceAll('/&gt;','/>');
        value = value.replaceAll('"&gt;','">');
        value = value.replaceAll('&lt;br','<br');
        value = value.replaceAll('&lt;b','<b');
        value = value.replaceAll('&lt;ul','<ul');
        value = value.replaceAll('&lt;li','<li');
        value = value.replaceAll('&lt;img','<img');
        value = value.replaceAll('&lt;i','<i');
        value = value.replaceAll('&lt;u','<u');
        value = value.replaceAll('&lt;span','<span');
        value = value.replaceAll('&lt;a','<a');
        value = value.replaceAll('&lt;body','<body');
        value = value.replaceAll('&lt;col','<col');
        value = value.replaceAll('&lt;div','<div');
        value = value.replaceAll('&lt;font','<font');
        value = value.replaceAll('&lt;h1','<h1');
		value = value.replaceAll('&lt;h2','<h2');
		value = value.replaceAll('&lt;h3','<h3');
		value = value.replaceAll('&lt;h4','<h4');
		value = value.replaceAll('&lt;h5','<h5');
		value = value.replaceAll('&lt;h6','<h6');
        value = value.replaceAll('&lt;table','<table');
        value = value.replaceAll('&lt;tr','<tr');
        value = value.replaceAll('&lt;td','<td');
		value = value.replaceAll('&lt;th','<th');
        value = value.replaceAll('&lt;title','<title');

        value = value.replaceAll('&amp;#39;',' \'');

        return value;
    }
})