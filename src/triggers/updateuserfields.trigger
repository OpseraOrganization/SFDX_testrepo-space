/*******************************************************************************
AERO
Name         : updateuserfields
Created By   : Venu Gundlapalli
Company Name : NTT Data
Project      : Gift and Hospitality 
Created Date : 21-Jan-2015
Description  : This trigger is used to update User informations as well as Order Requests object values (e.g Request Numbers).
   
*******************************************************************************/

trigger updateuserfields on Order_Request__c (before insert,after insert, after Update) {
    
    if(Trigger.isBefore){
    user u = [select id,SBU_User__c,SBG__c from user where id=:userinfo.getuserid()];

        for(Order_Request__c rec : Trigger.New){
            rec .SBU__c = u.SBU_User__c;
            rec .SBG__c = u.SBG__c ;
        }
    }
    
    if(Trigger.isAfter && trigger.isinsert){
        List<Order_Request__c> ghList = new List<Order_Request__c>();
        List<Order_Request__c> ghListUpdate = new List<Order_Request__c>();
        ghList = [select id,Name, GH_Req_Number__c from Order_Request__c  where id in: Trigger.NewMap.keySet()];
        for(Order_Request__c rec : Trigger.New){
            for(Order_Request__c ghrec: ghList){
                system.debug('ghrec.GH_Req_Number__c---->' + ghrec.GH_Req_Number__c);
                if( ghrec.GH_Req_Number__c == null && ghrec.Id == rec.Id){
                    ghrec.GH_Req_Number__c = rec.Name;
                    system.debug('rec.Name' + rec.Name);
                    ghListUpdate.add(ghrec);
                    continue;
                }
            }
        }
        
        if(ghList.size() > 0){
            update ghListUpdate;
        }
    }
    
    if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert) && GHApp_StaticClass.mailOnce){
        GHApp_StaticClass.mailOnce=false;
        Set<id> requestorId = new Set<id>(); 
        for(Order_Request__c oReq:Trigger.new){
            requestorId.add(oReq.Id);       
        }
        Order_Request__c oReq = [SELECT CreatedById,Status__c,GH_Req_Number__c,Is_Event_Request__c, Other_Event_Type__c, Event_status__c,Event_Date__c,Event_Type__c,Number_of_people_for_event__c FROM Order_Request__c where Id =: requestorId LIMIT 1];
        
        List<GH_Request_Recipient__c> RPList = [Select Id,Name,Company__c,Country__c,Date__c,Elected_Representative__c,GH_Request__c,Gift_Occasion_Award_Placement__c,Gift_Frequency__c,Gift_Gift_given_to_government_official__c,
                                                Gift_Gift_offered_to_spouse__c,Gift_Line_Manager_Informed__c,Gift_Occasion_Business_Meeting__c,Gift_Recipient__c,Gifts__c,Gift_Value_of_gift__c,Gift_Description__c,
                                                Gift_Additional_Comments__c,Gift_Business_Purpose__c, Meals_Entertainment__c,ME_Frequency__c,ME_Line_Manager_Informed__c,ME_Occasion_Award_Placement__c,
                                                ME_Occasion_Business_Meeting__c,ME_Travel_offered_to_spouse__c,ME_Travel_provided_to_government_officia__c,ME_Value_of_Meals_Entertainment__c, ME_Description__c, 
                                                ME_Business_Purpose__c, ME_Additional_Comments__c,Name_of_Recipient__c,Name_of_Recipient_Lookup__c,Position__c,Score__c,Status__c,Type_of_Gift__c,Gift_Score__c,
                                                Meal_Score__c,Gift_Currency_Code__c, Gift_Value_Per_Currency__c, Meals_Currency_Code__c, Meals_Value_Per_Currency__c, CreatedDate 
                                                from GH_Request_Recipient__c where GH_Request__r.Id =: requestorId];
        system.debug('Created By Id for Request >>> '  + oReq);
        User u = [select id,SBU_User__c,SBG__c,Name, Email from user where Id =: oReq.CreatedById];
        system.debug('Created By Id for Request Email >>> '  + u.Email);
        string[] addressArray = new List<string>();
        addressArray.add(u.Email);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        mail.setToAddresses(addressArray);
        
        String MailBody='';
        if(oReq.Status__c == 'Complete'){
            mail.setSubject('Approval Status for ' + oReq.GH_Req_Number__c);
            if(oReq.Is_Event_Request__c == True){
                system.debug('if complete addressArray >>> '  + addressArray);
                
                MailBody = '<div style="width: 900px; margin: auto; font-family: \'Calibri\', Helvetica, Arial, sans-serif;"> Hello '+ u.Name +', </div>';           
                            MailBody +='<div style="padding: 20px 0px;border-bottom: 1px solid #ccc">';
                            MailBody +='<br/><br/>';
                            MailBody +='Your GH request for Event has been <b>'+ oReq.Event_status__c +'</b>. <br/><br/>';
                            MailBody +='</div>';
                            MailBody +='<div style=""><br/><br/>';
                            MailBody +='<b>Following are the Details for requested event. </b><br/><br/>';
                            MailBody +='</div>';
                            MailBody +='<table style="border: 1px solid #ccc">';
                            MailBody +='<tr><td>';
                            if(string.valueOf(oReq.Event_Type__c) == 'Other'){
                                MailBody +='<b>Other: '+oReq.Other_Event_Type__c+'</b><br/>';       
                            }else{
                                MailBody +='<b>Event Type: '+oReq.Event_Type__c+'</b><br/>';
                            }
                            MailBody +='<b>No. of Invitees: '+oReq.Number_of_people_for_event__c+'</b><br/>';
                            MailBody +='<b>Event Date: '+string.valueOf(oReq.Event_Date__c).replace('00:00:00','')+'</b><br/>';
                            MailBody +='<div style="background-color: #F7B235;color:#FFF;font-weight:bold;font-size:10px;text-align:center">'+'Event'+'</div>';
                            MailBody +='</td>';
                            MailBody +='</tr>';
                            MailBody +='</table>';
                            MailBody +='<div><br/><br/>';
                            MailBody +='- GH App Communications';
                            MailBody +='</div></div>'; 
                
                
            }
            else{
                MailBody = '<div style="width: 900px; margin: auto; font-family: \'Calibri\', Helvetica, Arial, sans-serif;">';
                            MailBody +='<div style="padding: 20px 0px;border-bottom: 1px solid #ccc">';
                            MailBody +='Hello,<br/><br/>';
                            MailBody +='Your GH request('+oReq.GH_Req_Number__c+') has been <b>Completed</b>. <br/><br/>';
                            MailBody +='</div>';
                            MailBody +='<div style=""><br/><br/>';
                            MailBody +='<b>Following are the recipients for the request. </b><br/><br/>';
                            MailBody +='</div>';
                            MailBody +='<table style="border: 1px solid #ccc; border-right:1px solid #ccc;">';
                    for(GH_Request_Recipient__c RL: RPList) {
                        string GiftMealVar = '';
                        integer GiftMealScore = 0;
                        string reqFinalStatus='';
                        if(RL.Gifts__c == true && RL.Meals_Entertainment__c == false) {
                            GiftMealVar = 'GIFTS';
                            reqFinalStatus=RL.Status__c;
                        }
                        if(RL.Gifts__c == false && RL.Meals_Entertainment__c == true) {
                            GiftMealVar = 'MEALS/ENTERTAINMENT';
                            reqFinalStatus=RL.Status__c;
                        }
                        if(RL.Gifts__c == true && RL.Meals_Entertainment__c == true) {
                            GiftMealVar = 'GIFTS,MEALS/ENTERTAINMENT';
                            reqFinalStatus=RL.Status__c;
                        }            
                        MailBody +='<tr><td style="border-bottom: 1px solid #ccc">';
                        MailBody +='<b>'+RL.Name_of_Recipient__c+'</b><br/>';
                        MailBody +='<small>'+RL.Company__c+','+RL.Country__c+'</small>';
                        MailBody +='<div style="background-color: #F7B235;color:#FFF;font-weight:bold;font-size:10px;text-align:center;">'+GiftMealVar+'</div>';
                        MailBody +='</td>';
                        MailBody +='<td style="padding-left: 20px;padding-right: 20px; border-bottom: 1px solid #ccc;">';
                        MailBody +='<b>'+reqFinalStatus+'</b>';
                        MailBody +='</td>';
                        MailBody +='</tr>';
                    }
                    MailBody +='</table>';
                    MailBody +='<div><br/><br/>';
                    MailBody +='- GH App Communications';
                    MailBody +='</div></div>';    
            }
            mail.setHtmlBody(MailBody);
            mail.setOrgWideEmailAddressId(Label.GH_OrgWideEmailAddress);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        } 
    }
    
}