({
    init : function(component, event, helper) {
        var action = component.get('c.initClass');
        action.setParams({recordID: component.get('v.recordId')});
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "ERROR" || state === "SUCCESS" && !response.getReturnValue().event ) {
                $(".zipWindowTitle").eq(0).html('No Event Agenda found in the event...');
                $(".zipWindowIcon").eq(0).hide();  
                $(".zipWindowIcon").eq(2).show();
            }
            if (state === "SUCCESS") {
                let result = response.getReturnValue(), content;
                let rowStyle = [
                        'style="width:63pt; border-right:0.75pt solid #b8cce4; border-bottom:0.75pt solid #95b3d7; padding-right:5.03pt; padding-left:5.03pt; vertical-align:top"',
                        'style="width:99.45pt; border-right:0.75pt solid #b8cce4; border-left:0.75pt solid #b8cce4; border-bottom:0.75pt solid #95b3d7; padding-right:5.03pt; padding-left:5.03pt; vertical-align:top"',
                        'style="width:138.05pt; border-right:0.75pt solid #b8cce4; border-left:0.75pt solid #b8cce4; border-bottom:0.75pt solid #95b3d7; padding-right:5.03pt; padding-left:5.03pt; vertical-align:top"',
                        'style="width:80.85pt; border-right:0.75pt solid #b8cce4; border-left:0.75pt solid #b8cce4; border-bottom:0.75pt solid #95b3d7; padding-right:5.03pt; padding-left:5.03pt; vertical-align:top"',
                        'style="width:47.45pt; border-left:0.75pt solid #b8cce4; border-bottom:0.75pt solid #95b3d7; padding-right:5.03pt; padding-left:5.03pt; vertical-align:top"',
                    	'style="width:100pt; border:none; padding-right:5.03pt; padding-left:5.03pt; vertical-align:top"',
                    	'style="width:180pt; border:none; padding-right:5.03pt; padding-left:5.03pt; vertical-align:top"',
                    ];
                content= [
                    {style:"",text:"",linebreak:true},
                    {style:"font-size:18pt;text-align:center;font-weight: bold;",text:result.accountName+" Executive Review Meeting",linebreak:true},
                    {style:"font-size:14pt;text-align:center;font-weight: bold;",text:"Hosted by Nokia",linebreak:true},
                    {style:"font-size:14pt;text-align:center;font-weight: bold;",text:(result.event.RecordType.DeveloperName==="ERM"?"Venue: Nokia Headquarters - Nokia One ":"")+result.venue,linebreak:true},
                    {style:"",text:"<br>",linebreak:true},
                    {style:"font-size:12pt;color:#999999;text-align:left;font-weight:bold;",text:"Dates",linebreak:true},
                    {style:"font-size:10pt;color:#000000;text-align:left;font-weight:normal;padding-left:100pt;",text:
                    	'<table cellspacing="0" cellpadding="0" style="none; border-collapse:collapse"><tbody><tr><td '+rowStyle[5]+'></td><td '+rowStyle[6]+'>From '+
                     	helper.getFormattedDate(result.event.Event_Start_Date__c)+'</td><td '+rowStyle[6]+'>To '+helper.getFormattedDate(result.event.Event_End_Date__c)+'</td></tr></tbody></table>',linebreak:true},
                    {style:"",text:"<br>",linebreak:true},
                ];
                if(result.externalParticipants.length > 0) {
                    content= [...content, {style:"font-size:12pt;color:#999999;text-align:left;font-weight:bold;",text:"Attendees from "+result.accountName,linebreak:true}];
                    let table= '<table cellspacing="0" cellpadding="0" style="none; border-collapse:collapse"><tbody>';
                    for(let i = 0; i < result.externalParticipants.length; i++)
                        table= table+'<tr><td '+rowStyle[5]+'></td><td '+rowStyle[6]+'>'+result.externalParticipants[i].Name+
                               '</td><td '+rowStyle[6]+'>'+(result.externalParticipants[i].Contact__r.Title?result.externalParticipants[i].Contact__r.Title:"")+'</td></tr>';
                 	content = [...content, {style:"font-size:10pt;color:#000000;text-align:left;font-weight:normal;",text:table+"</tbody></table>",linebreak:true}];
                }
            	if(result.internalParticipants.length > 0) {
                    content = [...content, {style:"",text:"<br>",linebreak:true},
                               	{style:"font-size:12pt;color:#999999;text-align:left;font-weight:bold;",text:"Attendees from Nokia",linebreak:true}];
                    let roles= [];
                    for(let i = 0; i < result.internalParticipants.length; i++)
                        if(roles.indexOf(result.internalParticipants[i].Role__c) == -1)
                            roles= [...roles, result.internalParticipants[i].Role__c];
                    for(let r = 0; r < roles.length; r++){
                        content = [...content, {style:"font-size:12pt;color:#1f497d;text-align:left;font-weight:normal;",text:roles[r],linebreak:true}];
                    	let table= '<table cellspacing="0" cellpadding="0" style="none; border-collapse:collapse"><tbody>';
                        for(let i = 0; i < result.internalParticipants.length; i++)
                            if(result.internalParticipants[i].Role__c === roles[r])
                                table= table+'<tr><td '+rowStyle[5]+'></td><td '+rowStyle[6]+'>'+result.internalParticipants[i].Name+
                                       '</td><td '+rowStyle[6]+'>'+(result.internalParticipants[i].User__r.Title?result.internalParticipants[i].User__r.Title:"")+'</td></tr>';
                 		content = [...content, {style:"font-size:10pt;color:#000000;text-align:left;font-weight:normal;",text:table+"</tbody></table>",linebreak:true}];
                    }
                }
            	if(result.event.Event_Vision__c)
                    content = [...content, {style:"",text:"<br>",linebreak:true},
                               	{style:"font-size:12pt;color:#999999;text-align:left;font-weight:bold;",text:"Purpose and Vision",linebreak:true},
                              	{style:"font-size:10pt;color:#000000;text-align:left;font-weight:normal;",text:result.event.Event_Vision__c,linebreak:true}];
                if(result.sessions.length > 0) {
                    let startDay = result.sessions[0].Start_time__c,
                        startDayText = startDay?helper.getFormattedDate(startDay):'',
                        defaultRoom = (result.event.Default_Room__r?' ('+result.event.Default_Room__r.Name+')':'');
            		content = [...content, {style:"",text:"",linebreak:true, pagebreak:true},
                                           {style:"font-size:16pt;color:#1f497d;text-align:left;font-weight:bold;",text:"Agenda",linebreak:true},
                                           {style:"",text:"<br>",linebreak:true},
                               {style:"font-size:12pt;color:#999999;text-align:left;font-weight:bold;",text:startDayText+defaultRoom,linebreak:true}];
            		let table= '<table cellspacing="0" cellpadding="0" style="border:0.75pt solid #b8cce4; border-collapse:collapse"><tbody>';
            		table= table+'<tr><td '+rowStyle[0]+'><strong>Info</strong></td><td '+rowStyle[1]+'><strong>Topic</strong></td><td '+rowStyle[2]+'><strong>Focus Areas</strong></td><td '
                    		+rowStyle[3]+'><strong>Speaker</strong></td><td '+rowStyle[4]+'><strong>Content Owners</strong></td><td '+rowStyle[4]+'><strong>Atendees</strong></td></tr>';
                    for(let i = 0; i < result.sessions.length; i++) {
                        if(startDay !== result.sessions[i].Start_time__c){
                            startDay = result.sessions[i].Start_time__c;
                            startDayText = startDay?helper.getFormattedDate(startDay):'';
                            content = [...content, {style:"",text:table+"</tbody></table>",linebreak:true},
                                                   {style:"",text:"<br>",linebreak:true},
                                       {style:"font-size:12pt;color:#999999;text-align:left;font-weight:bold;",text:startDayText+(i==0?defaultRoom:""),linebreak:true}];
                            table= '<table cellspacing="0" cellpadding="0" style="border:0.75pt solid #b8cce4; border-collapse:collapse"><tbody>';
            				table= table+'<tr><td '+rowStyle[0]+'><strong>Info</strong></td><td '+rowStyle[1]+'><strong>Topic</strong></td><td '+rowStyle[2]+'><strong>Focus Areas</strong></td><td '
                    					+rowStyle[3]+'><strong>Speaker</strong></td><td '+rowStyle[4]+'><strong>Content Owners</strong></td><td '+rowStyle[4]+'><strong>Atendees</strong></td></tr>';
                        }
                        let session = result.sessions[i];
                        //
                        let hours, start_hour, end_hour, start_minute, end_minute;
                        start_hour = ""+(session.Start_hour__c?Math.floor((session.Start_hour__c / (1000*60*60)) % 24):"");
                        start_minute = ""+(session.Start_hour__c?Math.floor((session.Start_hour__c / (1000*60)) % 60):"");
                        hours= (start_hour.length==1?"0":"")+start_hour+(start_hour.length!=0?":":"") +
                               (start_minute.length==1?"0":"")+start_minute;
                        //
                        let stakeholders= {"Content Owner":[""],"Content Support":[""],"Main Speaker":[""],"Speaker":[""],"Atendee":[""]};
                        for(let s = 0; s < result.Stakeholders.length; s++)
                            if(result.Stakeholders[s].Session__c === session.Id && stakeholders[result.Stakeholders[s].Role__c] != null)
								stakeholders[result.Stakeholders[s].Role__c]= [...stakeholders[result.Stakeholders[s].Role__c],result.Stakeholders[s].Participant__r.Name];
                        table= table+'<tr><td '+rowStyle[0]+'>'+hours+'\n'+(session.Room__r?(result.event.Default_Room__r?(session.Room__r.Name !== result.event.Default_Room__r.Name?'('+session.Room__r.Name+')':''):'('+session.Room__r.Name+')'):'')+'</td>'+
                            		 '<td '+rowStyle[1]+'>'+session.Name+'</td>'+
                            		 '<td '+rowStyle[2]+'>'+(session.Session_Notes__c?session.Session_Notes__c:"")+'</td>'+
                            		 '<td '+rowStyle[3]+'>'+(stakeholders["Main Speaker"].join(" / ")+stakeholders["Speaker"].join(" / ")).substr(3)+'</td>'+
                            		 '<td '+rowStyle[4]+'>'+(stakeholders["Content Owner"].join(" / ")+stakeholders["Content Support"].join(" / ")).substr(3)+'</td>'+
                            		 '<td '+rowStyle[4]+'>'+(stakeholders["Atendee"].join(" / ")).substr(3)+'</td></tr>';
                    }
            		content = [...content, {style:"",text:table+"</tbody></table>",linebreak:true}];
                }
    
    			window.createDoc(content, { pagination: false, 
    				style:"font-family:'Nokia Pure Headline Light';", 
    				download: true, name:result.accountName+" Executive Review Meeting "+result.event.Event_Start_Date__c,
    				header: { style:"text-align: right;", text:
    					'<img width="177px" heigth="35px" src="https://i.imgur.com/J6rwocL.jpg">'
                    }
				});
                $(".eventBriefingWindowTitle").eq(0).html('Event Agenda document ready.');
                $(".eventBriefingWindowIcon").eq(0).hide();
                $(".eventBriefingWindowIcon").eq(1).show();
            }
        });
        $A.enqueueAction(action);
    },
    closeQuickAction : function(component, event, helper) { 
        // Close the action panel 
        var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
        dismissActionPanel.fire(); 
    }
})