/** * File Name: TaskCreation
* Description :Trigger to create task
* Copyright : NTTDATA 2015 *
* @author : NTTDATA
* Modification Log =============================================================== Ver Date Author Modification --- ---- ------ -------------*
Version    Date         Author         Modification 
1.1       9/29/2015    NTTDATA        INC000008975216 - Activity Notifications for NSS Detractor Ratings
1.2       9/15/2016    TCS Run Team   INC000010662371 - NSS follow-up activity change
1.3       06/21/2018   NTTDATA        SCTASK2015022 - Survey Optimization changes for Overall Satisfation score detractor creation
**/ 

trigger TaskCreation on Feedback__c (after insert, after update)
{
    list<task> tasklist = new list<task>();
    set<id> fid = new set<id>();
    map<id,id> fdaccmap = new map<id,id>();
    map<id,AccountTeamMember > actemmem = new map<id,AccountTeamMember >();
    map<id,list<task>> tmap = new map<id,list<task>>();
    for(feedback__c fb:trigger.new)
    {
        if(fb.Account__c!=null)
        {
            fdaccmap.put(fb.id,fb.Account__c);
        }        
    }
    List<feedback__c> ls = [select Id,case__c,case__r.ownerid__r.managerid,Planned_Meeting__c,Planned_Meeting__r.Owner_Name__r.Managerid from feedback__c where id in: fdaccmap.keyset()];
    map<id,feedback__c> febCasmap = new map<id,feedback__c>(ls);
    for(task t:[select id,whatid from task where whatid in:fdaccmap.keyset()])
    {
        if(t.whatid!=null && !tmap.keyset().contains(t.whatid))
        {
            tmap.put(t.whatid, new list<task>());
            tmap.get(t.whatid).add(t); 
        } 
        else
            tmap.get(t.whatid).add(t);
    }   
    for(AccountTeamMember atml:[SELECT UserId,user.name,AccountId,account.name,TeamMemberRole FROM AccountTeamMember where accountid in:fdaccmap.values() and TeamMemberRole='Customer Business Manager (CBM)'] )
    {
        actemmem.put(atml.AccountId,atml);
    }    
    // INC000008975216  - Start
    Map<String,NSSDetractor__c> nssOwnerMap = NSSDetractor__c.getall();
    Map<String,NSSFollowup__c> nssfollowupOwnerMap = NSSFollowup__c.getall();
    // INC000008975216  - End
    for(feedback__c fb:trigger.new)
    {
        if(fb.ATR_Survey_Group__c=='Airbus' && (fb.Consolidated_score__c == 1 || fb.Consolidated_score__c == 2))
        {
            if(tmap!=null && tmap.get(fb.id)==NULL)
            {
                task t = new task();
                if(fdaccmap!=NULL && fdaccmap.get(fb.id)!=NULL && actemmem!=NULL && actemmem.get(fdaccmap.get(fb.id))!=NULL) 
                {
                    t.ownerid= actemmem.get(fdaccmap.get(fb.id)).userid;
                }
                t.subject='Technical Support';
                t.Priority='Normal';
                t.status='Not Started';
                t.MenuOption__c='Log';
                t.whatid=fb.id;
                tasklist.add(t);
            }
        }
        // INC000008975216  - Start
        if(trigger.isInsert && fb.recordtypeid == label.NSS_Feedback && (fb.Overall_satisfaction__c <= 2) && 
            (fb.Case_RecordType__c == 'Orders' || fb.Case_RecordType__c == 'Quotes' || fb.Case_RecordType__c == 'Returns' || fb.Case_RecordType__c == 'OEM Quotes Orders' || fb.Case_RecordType__c == 'Repair_Overhaul'))
        {
            task t = new task();
            t.recordtypeid = label.Task_Survey_FP_RecordTypeId;
            t.Account_Name__c = fb.Account_Name__c;
            t.whoid = fb.Contact__c;
            //t.whatid = fb.id; temporarily commented 
            t.whatid=fb.Case__c;
            t.subject = 'NSS Detractor Follow Up';
            t.Priority = 'Normal';
            t.ActivityDate = System.Today().addDays(3);

            /*if(fb.Account_SBU__c=='ATR')
                t.ownerid=nssOwnerMap.get('ATR').ownerid__c;         
            else if(fb.Account_SBU__c=='BGA')
                t.ownerid=nssOwnerMap.get('BGA').ownerid__c; 
            else if(fb.Account_SBU__c=='D&S')
                t.ownerid=nssOwnerMap.get('D&S').ownerid__c;*/
            t.ownerid = fb.Owner_Manager_ID__c;  
            tasklist.add(t);                                    
        }
        // INC000008975216 - End
        if(trigger.isInsert && fb.recordtypeid == label.NSS_Feedback && (fb.Overall_satisfaction__c <= 2) && 
            (fb.Case_RecordType__c == 'AOG' || fb.Case_RecordType__c == 'Technical_Issue' ))  
        {
         task t = new task();
            t.recordtypeid = label.Task_Survey_FP_RecordTypeId;
            t.Account_Name__c = fb.Account_Name__c;
            t.whoid = fb.Contact__c;
            t.whatid = fb.Case__c;
            t.subject = 'Follow-Up with Customer is Required';
            t.Priority = 'Normal';
            t.ActivityDate = System.Today().addDays(3);
            t.ownerid = febCasmap.get(fb.id).Case__r.ownerid__r.Managerid;           
            tasklist.add(t);                                    
        }

        // TCM Survey-start
        if(trigger.isInsert && fb.recordtypeid == label.TCM_Survey_Feedback_RecID && (fb.Overall_Satisfaction_survey__c <= 2))  
        {
            task t = new task();   
            if(fb.Planned_Meeting__c!=null)   {    
                t.ownerid=febCasmap.get(fb.id).Planned_Meeting__r.Owner_Name__r.Managerid;
            }
            
            system.debug('@@@@@@@'+t);
            t.recordtypeid = label.Task_Survey_FP_RecordTypeId;
            t.Account_Name__c = fb.Account_Name__c;
            t.whoid = fb.Contact__c;            
            t.whatid=fb.id;   
            t.subject='Tech Connect Survey Follow-Up with Customer';
            t.description = 'One or more detractor scores have been given by this customer or customer has requested contact. Follow-up to understand the problem and put corrective action in place.';
            t.Priority='Normal';
            //datetime myDate =datetime.newInstance(1960, 2, 17);
            //datetime newDate = mydate.addHours(1);
            t.IsReminderSet = TRUE ;
            t.ReminderDateTime = system.now();
            t.ActivityDate = System.Today().addDays(1);
            //t.ActivityDate = newDate.Date() ;
            tasklist.add(t);    
            system.debug('@@@@@@@'+tasklist);
                                         
        }
        //TCM ends
    }
    if(tasklist != null && tasklist.size()> 0)
    insert tasklist;  
}