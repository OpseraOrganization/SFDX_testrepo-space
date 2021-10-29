trigger NotifyWhenEventCreatedForOpportunity on Event (after insert) 
{
    integer errLoc = 0;
    string recId = '';
    
    Set<ID> WhatID = new Set<ID>(); 
    for(Event newevent : Trigger.new)
    if(newevent.WhatId != null)
    WhatID.add(newevent.WhatId);
    Map<Id,Opportunity> Oppmap = new Map<Id,Opportunity>([Select recordtypeid from Opportunity where ID in : WhatID AND (recordtypeid =: label.Opportunity_BGA_Recordtype OR recordtypeid =: label.BGA_OE_Opportunity)]);
    
    try
    {
    
    for (Event evnt : Trigger.new)
    if(Oppmap.size() > 0 && evnt.recordtypeid == label.BGA_Event)
    {
        recId = evnt.Id;
        /*string serverUrl   =                'https://na1.salesforce.com/'; //'https://cs1.salesforce.com/';*/
        string serverUrl = URL.getSalesforceBaseUrl().toExternalForm() +'/';
        string htmlHeader  =                '<html><head>'
                                    +       '<style>.tableborder{   border-bottom:3px solid #e39321;}.fontlabel{    font-family:Arial, Helvetica, sans-serif;   color:#333; font-size:100%;}</style>'
                                    +       '</head><body class=fontlabel>';
        string htmlFotter  =                '</body></html>';
        
        
        //    Check is whatid is an opportunity id or not 
        
        
        
        List<Opportunity> objOpp = [select Name,Id,opportunity.Owner.Email,OwnerId,Opportunity_Co_owner_new__c from Opportunity WHERE Id  = :evnt.WhatId];
        errLoc = 10;
        
        //if goes inside IF then whatid is an opportunity id
        
        
        if(objOpp != null && objOpp.size() > 0 )
        {
                
                integer i = 0;
                List<Opportunity_Sales_Team__c> objOppTeamList = [select User__r.Email from Opportunity_Sales_Team__c where Opportunity__r.Id = :objOpp[i].Id LIMIT 10];
                List<User> objOppOwnerEmail = [select Email from User WHERE Id = :objOpp[i].OwnerId OR Id = :objOpp[i].Opportunity_Co_owner_new__c  ];
                errLoc = 50;
                string[] emailList = null;
                
                if(objOppTeamList != null)
                {
                    errLoc = 60;
                    integer ownerCnt = (objOppOwnerEmail == null ? 0 : objOppOwnerEmail.size());
                    
                    emailList = new string[objOppTeamList.size()+ownerCnt] ;
                    
                    if( ownerCnt > 0 )
                    for (integer j=0 ; j < objOppOwnerEmail.size(); j++)
                    {
                         errLoc = 70;
                         emailList[j] = objOppOwnerEmail[j].Email ;
                    } 

                    
                    for (integer j=0 ; j < objOppTeamList.size(); j++)
                    {
                        errLoc = 80;
                        emailList[j+ownerCnt] = objOppTeamList[j].User__r.Email;
                    } 
                }
                else
                {
                    errLoc = 90;
                    integer ownerCnt = (objOppOwnerEmail == null ? 0 : objOppOwnerEmail.size());
                    
                    emailList = new string[ownerCnt] ;
                    
                    
                    for (integer j=0 ; j < ownerCnt; j++)
                    {
                         errLoc = 100;
                         emailList[j] = objOppOwnerEmail[j].Email ;
                    } 
                }
                
                     errLoc = 110;
                     string htmlBdy =  'Dear Opportunity Team,<br><br>For opportunity <a href='+serverUrl+objOpp[i].Id+'>'+ objOpp[i].Name +'</a>.<br><br>New Event <a href='+serverUrl+evnt.Id+'>'+evnt.Subject+'</a> is added, please have a look.';
                     htmlBdy = htmlBdy + '<br><br>Thank you';
                     
                    if(emailList!= null && emailList.size() >1)
                    {
                     
                     sendEmail.SendSimpleEmailNotification
                                                        (
                                                            emailList,
                                                            'Event created for opportunity: '+ objOpp[i].Name,
                                                            htmlHeader + htmlBdy + htmlFotter
                                                        );
                    }
            
        } 
        
    }
    }
    catch(Exception e)
    {
                            utilClass.createErrorLog
                                                             (
                                                             'NotifyWhenEventCreatedForOpportunity',
                                                             'NotifyWhenEventCreatedForOpportunity',
                                                             'errLoc - ' + errLoc + ' - ' + recId + ' - ' + e.getMessage()
                                                             );
    
    }
    
}