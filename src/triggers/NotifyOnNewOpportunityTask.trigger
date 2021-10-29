trigger NotifyOnNewOpportunityTask on Task (after insert) 
{
    integer errLoc = 0;
    string recId = '';
    Set<ID> WhatID = new Set<ID>(); 
    List<Task> listTask = new List<Task>();
    List<ID> listOppId = new List<ID>();  
    for (Task tsk : Trigger.new)
    {       
        if(tsk.recordtypeid == label.General_Task || tsk.recordtypeid ==label.Sales_Task_RT_ID )
        {
            listTask.add(tsk);            
            if (tsk.WhatId != null){
                if( string.valueOf(tsk.WhatId).startsWith('006') ){
                    listOppId.add(tsk.WhatId);
                }     
            }
            
        }       
    }
    Map<id,Opportunity> mapobjOpp = new Map<id,Opportunity>();
    Map<id,id> mapUpdateOpp = new Map<id,id>();
    //System.debug('Size of Opportunity'+listOppId.size() );
    if(null!=listOppId && listOppId.size()>0){    
        // Code Added for SR# INC000008286465 - ATR RMU - Start
        //mapobjOpp = new Map<id,Opportunity>([select Name,Id,Owner.Email,OwnerId,Opportunity_Co_owner_new__r.email,
        mapobjOpp = new Map<id,Opportunity>([select Name,Id,Owner.Email,OwnerId,Opportunity_Co_owner_new__r.email, createdbyid,recordtypeid,(select id from Tasks where recordtypeid=:label.Sales_Task_RT_ID and Subject='Call'),
        (select User__r.Email from Opportunity_Sales_Teams__r ) from Opportunity WHERE Id  in :listOppId]);        
        // Code Added for SR# INC000008286465 - ATR RMU - End
    }
    try
    {
        for (Task tsk : Trigger.new)
        {
            //if(Oppmap.size() > 0 && tsk.recordtypeid == label.General_Task)
            System.debug('Inside FORLOOP'+tsk.recordtypeid);
            if(tsk.recordtypeid == label.General_Task)
            {
                recId = tsk.Id;
                /*string serverUrl   =                'https://na1.salesforce.com/'; //'https://cs1.salesforce.com/';*/
                string serverUrl = URL.getSalesforceBaseUrl().toExternalForm() +'/';
                string htmlHeader  =                '<html><head>'
                            +       '<style>.tableborder{   border-bottom:3px solid #e39321;}.fontlabel{    font-family:Arial, Helvetica, sans-serif;   color:#333; font-size:100%;}</style>'
                            +       '</head><body class=fontlabel>';
                            
                string htmlFotter  =                '</body></html>';
                errLoc = 10;

                //    Check is whatid is an opportunity id or not 
                // Commented and Added for INC000005619821 - Start
                //List<Opportunity> objOpp = [select Name,Id,opportunity.Owner.Email,OwnerId,Opportunity_Co_owner_new__c from Opportunity WHERE Id  = :tsk.WhatId];
                List<Opportunity> objOpp = new List<Opportunity>();
                if(null != mapobjOpp && mapobjOpp.size()>0 && null!=tsk.WhatId && null!=mapobjOpp.get(tsk.WhatId))
                    objOpp.add(mapobjOpp.get(tsk.WhatId));
                // Commented and Added for INC000005619821 - End
                //   if goes inside IF then whatid is an opportunity id
                errLoc = 20;
                if(objOpp != null && objOpp.size() > 0)
                {

                    errLoc = 30;
                    integer i = 0;
                    // Commented for INC000005619821 - Start
                    //List<Opportunity_Sales_Team__c> objOppTeamList = [select User__r.Email from Opportunity_Sales_Team__c where Opportunity__r.Id = :objOpp[i].Id LIMIT 10];
                    //List<User> objOppOwnerEmail = [select Email from User WHERE Id = :objOpp[i].OwnerId OR Id = :objOpp[i].Opportunity_Co_owner_new__c];
                    // Commented for INC000005619821 - End
                    List<Opportunity_Sales_Team__c> objOppTeamList = new List<Opportunity_Sales_Team__c>();
                    if(null!= mapobjOpp.get(objOpp[i].Id))
                        objOppTeamList = mapobjOpp.get(objOpp[i].Id).Opportunity_Sales_Teams__r;
                    List<String> objOppOwnerEmail = new List<String>(); 
                    if(null != objOpp[i].OwnerId && null!=mapobjOpp.get(objOpp[i].id))
                        objOppOwnerEmail.add(mapobjOpp.get(objOpp[i].id).Owner.Email);
                    if(null != objOpp[i].Opportunity_Co_owner_new__c && null!=mapobjOpp.get(objOpp[i].id))
                        objOppOwnerEmail.add(mapobjOpp.get(objOpp[i].id).Opportunity_Co_owner_new__r.email);

                    string[] emailList = null;
                    errLoc = 60;
                    if(objOppTeamList != null && objOppTeamList.size()>0)
                    {                       
                        errLoc = 70;
                        integer ownerCnt = (objOppOwnerEmail == null ? 0 : objOppOwnerEmail.size());                        
                        emailList = new string[objOppTeamList.size()+ownerCnt] ;                        
                        if( ownerCnt > 0 )
                        for (integer j=0 ; j < objOppOwnerEmail.size(); j++)
                        {
                         errLoc = 80;
                         emailList[j] = objOppOwnerEmail[j] ;
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
                         emailList[j] = objOppOwnerEmail[j];
                        } 
                    }

                     errLoc = 130;
                     string htmlBdy =  'Dear Opportunity Team,<br><br>For opportunity <a href='+serverUrl+objOpp[i].Id+'>'+ objOpp[i].Name +'</a>.<br><br>New Task <a href='+serverUrl+tsk.Id+'>'+tsk.Subject+'</a> is added, please have a look.';
                     htmlBdy = htmlBdy + '<br><br>Thank you';
                     errLoc = 140;
                    
                    if(emailList!= null && emailList.size() >1)
                    {
                     sendEmail.SendSimpleEmailNotification
                    (
                        emailList,
                        'Task created for opportunity: '+ objOpp[i].Name,
                        htmlHeader + htmlBdy + htmlFotter
                    );
                    }

                } 
            
            } // End If
            // Code Added for SR# INC000008286465 - ATR RMU - Start
            else if(tsk.recordtypeid ==label.Sales_Task_RT_ID)
            {
                System.debug('Inside ELSEIF');
                System.debug('tsk.subject'+tsk.subject);
                if(tsk.subject=='Call' && (null != mapobjOpp && mapobjOpp.size()>0 && null!=tsk.WhatId && null!=mapobjOpp.get(tsk.WhatId)))
                {
                    System.debug('Inside ELSEIF-IF');
                    System.debug('Inside ELSEIF-IF'+mapobjOpp.get(tsk.WhatId).createdbyid);
                    if(mapobjOpp.get(tsk.WhatId).createdbyid==label.ATR_API_User_id && mapobjOpp.get(tsk.WhatId).recordtypeid==label.AM_Complex)
                    {
                        List<Task> lsttsk = mapobjOpp.get(tsk.WhatId).tasks;
                        System.debug('Total Size of List task=='+lsttsk.size());
                        if(lsttsk.size()==1){
                            mapUpdateOpp.put(tsk.WhatId,tsk.id);
                        }    
                    }
                }
            }
            // Code Added for SR# INC000008286465 - ATR RMU - Start
        }// End For
        if(mapUpdateOpp.size()>0)
        {
            UpdateOpportunityFromTask.UpdateOpportunityFromTask(mapUpdateOpp);
        }
    }
    catch(Exception e)
    {
        utilClass.createErrorLog
             (
             'NotifyOnNewOpportunityTask',
             'NotifyOnNewOpportunityTask',
             'errLoc - ' + errLoc + ' - ' + recId + ' - ' + e.getMessage()
             );
    
    }
    
}