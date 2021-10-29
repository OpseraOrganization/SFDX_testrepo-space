trigger NotifyAfterNewNote_Notes on Note (after insert) 
{
    
    integer errLoc = 0;
    string recId = '';
    
    
    Set<ID> ParentId = new Set<ID>(); 
    for(Note recNote : Trigger.new)
    if(recNote.ParentId != null)
    ParentId.add(recNote.ParentId);
    Map<Id,Opportunity> Oppmap = new Map<Id,Opportunity>([Select recordtypeid from Opportunity where ID in : ParentId AND (recordtypeid =: label.Opportunity_BGA_Recordtype OR recordtypeid =: label.BGA_OE_Opportunity)]);
    System.debug('aaaaaaa'+Oppmap);
    
    try
    {
    for (Note recNote : Trigger.new)
    if(Oppmap.size() > 0 )
    {
        recId = recNote.Id;
        /*string serverUrl   =                'https://na1.salesforce.com/'; //'https://cs1.salesforce.com/';*/
        string serverUrl = URL.getSalesforceBaseUrl().toExternalForm() +'/';
        string htmlHeader  =                '<html><head>'
                                    +       '<style>.tableborder{   border-bottom:3px solid #e39321;}.fontlabel{    font-family:Arial, Helvetica, sans-serif;   color:#333; font-size:100%;}</style>'
                                    +       '</head><body class=fontlabel>';
                                    
        string htmlFotter  =                '</body></html>';
        errLoc = 10;
        /*
            Check is whatid is an opportunity id or not 
        */
        
        List<Opportunity> objOpp = [select Name,Id,opportunity.Owner.Email,OwnerId,Opportunity_Co_owner_new__c from Opportunity WHERE Id  = :recNote.ParentId];
        
        
        /*
        if goes inside IF then whatid is an opportunity id
        */
        errLoc = 20;
        if(objOpp != null && recNote.IsPrivate == false && objOpp.size() > 0 )
        {
            errLoc = 30;
                integer i = 0;
                
                errLoc = 50;
                
                List<Opportunity_Sales_Team__c> objOppTeamList = [select User__r.Id,User__r.Email from Opportunity_Sales_Team__c where Opportunity__r.Id = :objOpp[i].Id LIMIT 10];
                system.debug('bbbbbbbb'+objOppTeamList);
                
                List<User> objOppOwnerEmail = [select ID,Email from User WHERE Id = :objOpp[i].OwnerId OR ID = :objOpp[i].Opportunity_Co_owner_new__c  ];
                system.debug('cccccccc'+objOppOwnerEmail);
                
                string[] emailList = null;
                errLoc = 60;
                if(objOppTeamList != null)
                {
                    errLoc = 70;
                    integer ownerCnt = (objOppOwnerEmail == null ? 0 : objOppOwnerEmail.size());
                    
                    emailList = new string[objOppTeamList.size()+ownerCnt] ;
                    
                    if( ownerCnt > 0 )
                    for (integer j=0 ; j < objOppOwnerEmail.size(); j++)
                    {
                         errLoc = 80;
                         emailList[j] = objOppOwnerEmail[j].Email ;
                    } 
 
                    for (integer j=0 ; j < objOppTeamList.size(); j++)
                    {
                        errLoc = 90;
                        emailList[j+ownerCnt] = objOppTeamList[j].User__r.Email;
                    } 
                }
                else
                {
                    errLoc = 100;
                    integer ownerCnt = (objOppOwnerEmail == null ? 0 : objOppOwnerEmail.size());
                    
                    errLoc = 110;
                    emailList = new string[ownerCnt] ;
                    
                    for (integer j=0 ; j < ownerCnt; j++)
                    {
                         errLoc = 120;
                         emailList[j] = objOppOwnerEmail[j].Email ;
                    } 
                }
                
                     errLoc = 130;
                     
                     string htmlBdy =  'Dear Opportunity Team,<br><br>For opportunity <a href='+serverUrl+objOpp[i].Id+'>'+ objOpp[i].Name +'</a>.<br><br>New Note <a href='+serverUrl+recNote.Id+'>'+recNote.Title+'</a> is added, please have a look.';
                     htmlBdy = htmlBdy + '<br><br>Thank you';
                     errLoc = 140;
                    system.debug('dddddddd'+emailList);
                    if(emailList!= null && emailList.size() > 1)
                    {
                     sendEmail.SendSimpleEmailNotification
                                                        (
                                                            emailList,
                                                            'Note added for opportunity: '+ objOpp[i].Name,
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
                                                                                     'NotifyAfterNewNote_Notes',
                                                                                     'NotifyAfterNewNote_Notes',
                                                                                     'errLoc - ' + errLoc + ' - ' + recId + ' - ' + e.getMessage()
                                                                                     );
    
    }
    
}